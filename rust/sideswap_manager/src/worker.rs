use std::{collections::BTreeMap, sync::Arc, time::Duration};

use elements::{pset::PartiallySignedTransaction, AssetId};
use sideswap_api::{
    mkt::{self, AssetType, TradeDir},
    ResponseMessage,
};
use sideswap_common::{
    abort, b64,
    channel_helpers::{UncheckedOneshotSender, UncheckedUnboundedSender},
    dealer_ticker::{DealerTicker, TickerLoader},
    make_market_request,
    rpc::{self, balances::ParsedBalanceMap, RpcServer},
    types::{asset_float_amount_, asset_int_amount_},
    verify,
    ws::{
        auto::{WrappedRequest, WrappedResponse},
        ws_req_sender::{self, WsReqSender},
    },
};
use sideswap_types::asset_precision::AssetPrecision;
use tokio::sync::mpsc::{unbounded_channel, UnboundedReceiver, UnboundedSender};

use crate::{api, db::Db, error::Error, ws_server::ClientId, Settings};

pub enum Command {
    NewAddress {
        res_sender: UncheckedOneshotSender<Result<elements::Address, Error>>,
    },
    GetQuote {
        req: api::GetQuoteReq,
        res_sender: UncheckedOneshotSender<Result<api::GetQuoteResp, Error>>,
    },
    AcceptQuote {
        req: api::AcceptQuoteReq,
        res_sender: UncheckedOneshotSender<Result<api::AcceptQuoteResp, Error>>,
    },
    ClientConnected {
        client_id: ClientId,
        notif_sender: UncheckedUnboundedSender<api::Notif>,
    },
    ClientDisconnected {
        client_id: ClientId,
    },
}

enum Event {
    Balances {
        balances: rpc::balances::GetBalances,
    },
}

struct ClientData {
    notif_sender: UncheckedUnboundedSender<api::Notif>,
}

struct Data {
    settings: Settings,

    policy_asset: AssetId,

    ticker_loader: Arc<TickerLoader>,

    db: Db,

    ws: WsReqSender,

    markets: Vec<mkt::MarketInfo>,

    clients: BTreeMap<ClientId, ClientData>,

    last_balances: Option<api::BalancesNotif>,
}

fn send_notifs(data: &Data, notif: &api::Notif) {
    for client in data.clients.values() {
        client.notif_sender.send(notif.clone());
    }
}

struct Asset {
    asset_id: AssetId,
    precision: AssetPrecision,
}

fn try_get_asset(ticker_loader: &TickerLoader, ticker: DealerTicker) -> Result<Asset, Error> {
    verify!(
        ticker_loader.has_ticker(ticker),
        Error::UnknownTicker(ticker)
    );
    Ok(Asset {
        asset_id: *ticker_loader.asset_id(ticker),
        precision: ticker_loader.precision(ticker),
    })
}

fn try_convert_asset_amount(amount: f64, asset_precision: AssetPrecision) -> Result<u64, Error> {
    let int_amount = asset_int_amount_(amount, asset_precision);
    let float_amount = asset_float_amount_(int_amount, asset_precision);
    verify!(
        float_amount == amount,
        Error::InvalidAssetAmount(amount, asset_precision)
    );
    Ok(int_amount)
}

async fn new_address(rpc_server: &RpcServer) -> Result<elements::Address, Error> {
    rpc::make_rpc_call(rpc_server, rpc::GetNewAddressCall {})
        .await
        .map_err(Error::Rpc)
}

enum QuoteStatus {
    Disconnected,
    Timeout(tokio::time::error::Elapsed),
    Quote(mkt::QuoteNotif),
}

async fn get_quote(data: &mut Data, req: api::GetQuoteReq) -> Result<api::GetQuoteResp, Error> {
    let send_asset = try_get_asset(&data.ticker_loader, req.send_asset)?;
    let recv_asset = try_get_asset(&data.ticker_loader, req.recv_asset)?;

    log::debug!(
        "try to find market for send_asset: {}, recv_asset: {}",
        send_asset.asset_id,
        recv_asset.asset_id
    );

    let market = data
        .markets
        .iter()
        .find(|market| {
            market.asset_pair.base == send_asset.asset_id
                && market.asset_pair.quote == recv_asset.asset_id
                || market.asset_pair.base == recv_asset.asset_id
                    && market.asset_pair.quote == send_asset.asset_id
        })
        .ok_or(Error::NoMarket)?;

    let fee_asset = market.fee_asset;

    let asset_type = if market.asset_pair.base == send_asset.asset_id {
        AssetType::Base
    } else {
        AssetType::Quote
    };

    let base_trade_dir = match asset_type {
        AssetType::Base => TradeDir::Sell,
        AssetType::Quote => TradeDir::Buy,
    };

    let send_amount = try_convert_asset_amount(req.send_amount, send_asset.precision)?;

    // TODO: Reuse addresses
    let receive_address = new_address(&data.settings.rpc).await?;
    let change_address = new_address(&data.settings.rpc).await?;

    let utxos = rpc::make_rpc_call(&data.settings.rpc, rpc::ListUnspentCall { minconf: 0 })
        .await
        .map_err(Error::Rpc)?
        .into_iter()
        .filter(|utxo| utxo.asset == send_asset.asset_id)
        .map(|unspent| sideswap_api::Utxo {
            txid: unspent.txid,
            vout: unspent.vout,
            asset: unspent.asset,
            asset_bf: unspent.assetblinder,
            value: unspent.amount.to_sat(),
            value_bf: unspent.amountblinder,
            redeem_script: unspent.redeem_script.clone(),
        })
        .collect::<Vec<_>>();

    let total = utxos.iter().map(|utxo| utxo.value).sum::<u64>();

    verify!(
        total >= send_amount,
        Error::NotEnoughAmount {
            asset_id: send_asset.asset_id,
            required: send_amount,
            available: total,
        }
    );

    let start_quote_resp = make_market_request!(
        data.ws,
        StartQuotes,
        mkt::StartQuotesRequest {
            asset_pair: market.asset_pair,
            asset_type,
            amount: send_amount,
            trade_dir: TradeDir::Sell,
            utxos,
            receive_address,
            change_address,
            order_id: None,
            private_id: None,
        }
    )?;

    let deadline = tokio::time::Instant::now() + Duration::from_secs(15);

    let status = loop {
        let res = tokio::time::timeout_at(deadline, data.ws.recv()).await;

        match res {
            Ok(resp) => {
                let status = match &resp {
                    WrappedResponse::Connected => None,
                    WrappedResponse::Disconnected => Some(QuoteStatus::Disconnected),
                    WrappedResponse::Response(ResponseMessage::Response(_, _)) => None,
                    WrappedResponse::Response(ResponseMessage::Notification(
                        sideswap_api::Notification::Market(mkt::Notification::Quote(quote)),
                    )) if quote.quote_sub_id == start_quote_resp.quote_sub_id => {
                        Some(QuoteStatus::Quote(quote.clone()))
                    }
                    WrappedResponse::Response(ResponseMessage::Notification(_)) => None,
                };

                process_ws_event(data, resp).await;

                if let Some(status) = status {
                    break status;
                }

                continue;
            }

            Err(err) => break QuoteStatus::Timeout(err),
        };
    };

    let quote = match status {
        QuoteStatus::Disconnected => abort!(Error::WsError(ws_req_sender::Error::Disconnected)),
        QuoteStatus::Timeout(err) => abort!(Error::WsError(ws_req_sender::Error::Timeout(err))),
        QuoteStatus::Quote(quote) => quote,
    };

    match quote.status {
        mkt::QuoteStatus::Success {
            quote_id,
            base_amount,
            quote_amount,
            server_fee,
            fixed_fee,
            ttl,
        } => {
            let total_fee = server_fee + fixed_fee;

            let (quote_send_amount, quote_recv_amount) = match (base_trade_dir, fee_asset) {
                (TradeDir::Sell, AssetType::Base) => {
                    (base_amount.saturating_add(total_fee), quote_amount)
                }
                (TradeDir::Sell, AssetType::Quote) => {
                    (base_amount, quote_amount.saturating_sub(total_fee))
                }
                (TradeDir::Buy, AssetType::Base) => {
                    (quote_amount, base_amount.saturating_sub(total_fee))
                }
                (TradeDir::Buy, AssetType::Quote) => {
                    (quote_amount.saturating_add(total_fee), base_amount)
                }
            };

            verify!(
                quote_send_amount == send_amount,
                Error::NotEnoughAmount {
                    asset_id: send_asset.asset_id,
                    required: send_amount,
                    available: quote_send_amount,
                }
            );

            let quote_recv_amount = asset_float_amount_(quote_recv_amount, recv_asset.precision);

            Ok(api::GetQuoteResp {
                quote_id,
                recv_amount: quote_recv_amount,
                ttl,
            })
        }

        mkt::QuoteStatus::LowBalance {
            base_amount: _,
            quote_amount: _,
            server_fee: _,
            fixed_fee: _,
            available,
        } => {
            log::error!("unexpected LowBalance quote status");
            abort!(Error::NotEnoughAmount {
                asset_id: send_asset.asset_id,
                required: send_amount,
                available,
            })
        }

        mkt::QuoteStatus::Error { error_msg } => abort!(Error::QuoteError(error_msg)),
    }
}

async fn accept_quote(
    data: &mut Data,
    req: api::AcceptQuoteReq,
) -> Result<api::AcceptQuoteResp, Error> {
    let quote_resp = make_market_request!(
        data.ws,
        GetQuote,
        mkt::GetQuoteRequest {
            quote_id: req.quote_id
        }
    )?;

    let pset = b64::decode(&quote_resp.pset)?;
    let mut pset = elements::encode::deserialize::<PartiallySignedTransaction>(&pset)?;

    let unsigned_tx = pset.extract_tx()?;

    let signed_tx = rpc::make_rpc_call(
        &data.settings.rpc,
        rpc::sign_raw_transaction::SignRawTransactionWithWalletCall {
            raw_tx: unsigned_tx.into(),
        },
    )
    .await
    .map_err(Error::Rpc)?;

    let signed_tx = signed_tx.hex.into_inner();

    for (tx_input, pset_input) in signed_tx.input.iter().zip(pset.inputs_mut()) {
        if !tx_input.script_sig.is_empty() {
            pset_input.final_script_sig = Some(tx_input.script_sig.clone());
        }
        if !tx_input.witness.script_witness.is_empty() {
            pset_input.final_script_witness = Some(tx_input.witness.script_witness.clone());
        }
    }

    let pset = elements::encode::serialize(&pset);

    let accept_resp = make_market_request!(
        data.ws,
        TakerSign,
        mkt::TakerSignRequest {
            quote_id: req.quote_id,
            pset: b64::encode(&pset)
        }
    )?;

    Ok(api::AcceptQuoteResp {
        txid: accept_resp.txid,
    })
}

async fn process_command(data: &mut Data, command: Command) {
    match command {
        Command::NewAddress { res_sender } => {
            let rpc_server = data.settings.rpc.clone();
            tokio::spawn(async move {
                let res = new_address(&rpc_server).await;
                res_sender.send(res);
            });
        }

        Command::GetQuote { req, res_sender } => {
            let res = get_quote(data, req).await;
            res_sender.send(res);
        }

        Command::AcceptQuote { req, res_sender } => {
            let res = accept_quote(data, req).await;
            res_sender.send(res);
        }

        Command::ClientConnected {
            client_id,
            notif_sender,
        } => {
            if let Some(balance) = &data.last_balances {
                notif_sender.send(api::Notif::Balances(balance.clone()));
            }
            data.clients.insert(client_id, ClientData { notif_sender });
        }

        Command::ClientDisconnected { client_id } => {
            data.clients.remove(&client_id).expect("must not fail");
        }
    }
}

fn convert_balances(data: &Data, balances: ParsedBalanceMap) -> api::Balances {
    balances
        .iter()
        .filter_map(|(asset_id, amount)| {
            let ticker = data.ticker_loader.ticker(asset_id)?;
            let precision = data.ticker_loader.precision(ticker);
            let amount = asset_float_amount_(*amount, precision);
            Some((ticker, amount))
        })
        .collect()
}

fn process_event(data: &mut Data, event: Event) {
    match event {
        Event::Balances { balances } => {
            let trusted = rpc::balances::parse_balances(&balances.mine.trusted, &data.policy_asset);
            let untrusted_pending =
                rpc::balances::parse_balances(&balances.mine.untrusted_pending, &data.policy_asset);
            let new_balances = api::BalancesNotif {
                trusted: convert_balances(data, trusted),
                untrusted_pending: convert_balances(data, untrusted_pending),
            };
            if data.last_balances.as_ref() != Some(&new_balances) {
                // TODO: Send updated balances to the clients
                log::debug!("wallet balances updated: {new_balances:?}");
                send_notifs(data, &api::Notif::Balances(new_balances.clone()));
                data.last_balances = Some(new_balances);
            }
        }
    }
}

fn process_ws_connected(data: &mut Data) {
    data.ws
        .send_request(sideswap_api::Request::Market(mkt::Request::ListMarkets(
            mkt::ListMarketsRequest {},
        )));
}

fn process_ws_disconnected(_data: &mut Data) {}

fn process_market_resp(data: &mut Data, resp: mkt::Response) {
    match resp {
        mkt::Response::ListMarkets(resp) => {
            data.markets = resp.markets;
        }

        mkt::Response::Challenge(_)
        | mkt::Response::Register(_)
        | mkt::Response::Login(_)
        | mkt::Response::Subscribe(_)
        | mkt::Response::Unsubscribe(_)
        | mkt::Response::AddUtxos(_)
        | mkt::Response::RemoveUtxos(_)
        | mkt::Response::AddOrder(_)
        | mkt::Response::EditOrder(_)
        | mkt::Response::AddOffline(_)
        | mkt::Response::CancelOrder(_)
        | mkt::Response::ResolveGaid(_)
        | mkt::Response::StartQuotes(_)
        | mkt::Response::StopQuotes(_)
        | mkt::Response::MakerSign(_)
        | mkt::Response::GetQuote(_)
        | mkt::Response::TakerSign(_)
        | mkt::Response::GetOrder(_)
        | mkt::Response::ChartSub(_)
        | mkt::Response::ChartUnsub(_)
        | mkt::Response::LoadHistory(_)
        | mkt::Response::Ack(_) => {}
    }
}

fn process_market_notif(data: &mut Data, notif: mkt::Notification) {
    match notif {
        mkt::Notification::MarketAdded(notif) => {
            data.markets.push(notif.market);
        }

        mkt::Notification::MarketRemoved(notif) => {
            data.markets
                .retain(|market| market.asset_pair != notif.asset_pair);
        }

        mkt::Notification::UtxoAdded(_)
        | mkt::Notification::UtxoRemoved(_)
        | mkt::Notification::OwnOrderCreated(_)
        | mkt::Notification::OwnOrderRemoved(_)
        | mkt::Notification::PublicOrderCreated(_)
        | mkt::Notification::PublicOrderRemoved(_)
        | mkt::Notification::Quote(_)
        | mkt::Notification::MakerSign(_)
        | mkt::Notification::MarketPrice(_)
        | mkt::Notification::ChartUpdate(_)
        | mkt::Notification::HistoryUpdated(_)
        | mkt::Notification::NewEvent(_)
        | mkt::Notification::TxBroadcast(_) => {}
    }
}

async fn process_ws_event(data: &mut Data, event: WrappedResponse) {
    match event {
        WrappedResponse::Connected => {
            process_ws_connected(data);
        }

        WrappedResponse::Disconnected => {
            process_ws_disconnected(data);
        }

        WrappedResponse::Response(ResponseMessage::Response(
            _,
            Ok(sideswap_api::Response::Market(resp)),
        )) => {
            process_market_resp(data, resp);
        }

        WrappedResponse::Response(ResponseMessage::Response(req_id, res)) => {
            // let req_id = req_id.expect("mut be set");
            // let ws_callback = data.async_requests.remove(&req_id);
            // if let Some(callback) = ws_callback {
            //     let res = match res {
            //         Ok(sideswap_api::Response::Market(resp)) => Ok(resp),
            //         Ok(_) => Err(Error::WsRequestError(
            //             ws_req_sender::Error::UnexpectedResponse,
            //         )),
            //         Err(err) => Err(Error::WsRequestError(ws_req_sender::Error::BackendError(
            //             err.message,
            //             err.code,
            //         ))),
            //     };
            //     callback(data, res);
            // }
        }

        WrappedResponse::Response(ResponseMessage::Notification(
            sideswap_api::Notification::Market(notif),
        )) => {
            process_market_notif(data, notif);
        }

        WrappedResponse::Response(ResponseMessage::Notification(_)) => {}
    }
}

async fn update_balance(rpc: RpcServer, event_sender: UnboundedSender<Event>) {
    loop {
        let res = rpc::make_rpc_call(&rpc, rpc::balances::GetBalancesCall {}).await;

        match res {
            Ok(balances) => {
                let res = event_sender.send(Event::Balances { balances });
                if res.is_err() {
                    log::debug!("stop update balances loop");
                    break;
                }
                tokio::time::sleep(Duration::from_secs(5)).await;
            }
            Err(err) => {
                log::error!("wallet balance loading failed: {err}");
                tokio::time::sleep(Duration::from_secs(15)).await;
            }
        }
    }
}

pub async fn run(
    settings: Settings,
    mut command_receiver: UnboundedReceiver<Command>,
    ticker_loader: Arc<TickerLoader>,
    db: Db,
) {
    let server_url = settings.env.base_server_ws_url();

    let (req_sender, req_receiver) = unbounded_channel::<WrappedRequest>();
    let (resp_sender, resp_receiver) = unbounded_channel::<WrappedResponse>();
    tokio::spawn(sideswap_common::ws::auto::run(
        server_url.clone(),
        req_receiver,
        resp_sender,
    ));
    let ws = WsReqSender::new(req_sender, resp_receiver);

    let policy_asset = settings.env.nd().policy_asset.asset_id();

    let mut data = Data {
        settings,
        policy_asset,
        ticker_loader,
        db,
        ws,
        markets: Vec::new(),
        clients: BTreeMap::new(),
        last_balances: None,
    };

    let term_signal = sideswap_dealer::signals::TermSignal::new();

    let (event_sender, mut event_receiver) = tokio::sync::mpsc::unbounded_channel();

    tokio::spawn(update_balance(data.settings.rpc.clone(), event_sender));

    loop {
        tokio::select! {
            command = command_receiver.recv() => {
                let command = command.expect("channel must be open");
                process_command(&mut data, command).await;
            },

            event = event_receiver.recv() => {
                let event = event.expect("channel must be open");
                process_event(&mut data, event);
            }

            event = data.ws.recv() => {
                process_ws_event(&mut data, event).await;
            },

            _ = term_signal.recv() => {
                log::info!("terminate signal received");
                break;
            },
        }
    }

    data.db.close().await;
}
