use std::{
    collections::{BTreeMap, BTreeSet},
    sync::{
        mpsc::{self, channel},
        Arc,
    },
    time::Duration,
};

use elements::{pset::PartiallySignedTransaction, AssetId};
use sideswap_api::{
    mkt::{self, AssetType, QuoteId, TradeDir},
    OrderId, PegStatus, ResponseMessage,
};
use sideswap_common::{
    abort, b64,
    channel_helpers::{UncheckedOneshotSender, UncheckedUnboundedSender},
    dealer_ticker::{DealerTicker, TickerLoader},
    make_market_request, make_request,
    types::{asset_float_amount_, asset_int_amount_},
    verify,
    ws::{
        auto::{WrappedRequest, WrappedResponse},
        ws_req_sender::{self, WsReqSender},
    },
};
use sideswap_dealer::utxo_data::UtxoData;
use sideswap_types::asset_precision::AssetPrecision;
use sqlx::types::Text;
use tokio::{
    sync::mpsc::{unbounded_channel, UnboundedReceiver},
    time::Instant,
};

use crate::{
    api,
    db::Db,
    error::Error,
    models::{Peg, Swap},
    ws_server::ClientId,
    Settings,
};

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
    NewPeg {
        req: api::NewPegReq,
        res_sender: UncheckedOneshotSender<Result<api::NewPegResp, Error>>,
    },
    DelPeg {
        req: api::DelPegReq,
        res_sender: UncheckedOneshotSender<Result<api::DelPegResp, Error>>,
    },
    GetSwaps {
        req: api::GetSwapsReq,
        res_sender: UncheckedOneshotSender<Result<api::GetSwapsResp, Error>>,
    },
    ClientConnected {
        client_id: ClientId,
        notif_sender: UncheckedUnboundedSender<api::Notif>,
    },
    ClientDisconnected {
        client_id: ClientId,
    },
}

struct ClientData {
    notif_sender: UncheckedUnboundedSender<api::Notif>,
}

struct Quote {
    txid: elements::Txid,
    pset: PartiallySignedTransaction,
    expires_at: Instant,
}

impl Quote {
    fn ttl_valid(&self) -> bool {
        Instant::now() < self.expires_at
    }
}

struct Data {
    _settings: Settings,

    _policy_asset: AssetId,

    ticker_loader: Arc<TickerLoader>,

    db: Db,

    ws: WsReqSender,

    wallet_command_sender: mpsc::Sender<sideswap_lwk::Command>,

    markets: Vec<mkt::MarketInfo>,

    clients: BTreeMap<ClientId, ClientData>,

    last_balances: Option<api::BalancesNotif>,

    utxo_data: Option<UtxoData>,

    pegs: BTreeSet<OrderId>,

    peg_statuses: BTreeMap<OrderId, PegStatus>,

    swaps: BTreeSet<elements::Txid>,

    quotes: BTreeMap<QuoteId, Quote>,
}

fn encode_pset(pset: &PartiallySignedTransaction) -> String {
    let pset = elements::encode::serialize(pset);
    b64::encode(&pset)
}

fn decode_pset(pset: &str) -> Result<PartiallySignedTransaction, Error> {
    let pset = b64::decode(pset)?;
    let pset = elements::encode::deserialize(&pset)?;
    Ok(pset)
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

fn convert_balances(data: &Data, utxo_data: &UtxoData) -> api::Balances {
    let mut totals = BTreeMap::<elements::AssetId, u64>::new();
    for utxo in utxo_data.utxos() {
        *totals.entry(utxo.asset).or_default() += utxo.value;
    }

    totals
        .iter()
        .filter_map(|(asset_id, amount)| {
            let ticker = data.ticker_loader.ticker(asset_id)?;
            let precision = data.ticker_loader.precision(ticker);
            let amount = asset_float_amount_(*amount, precision);
            Some((ticker, amount))
        })
        .collect()
}

enum QuoteStatus {
    Disconnected,
    Timeout(tokio::time::error::Elapsed),
    Quote(mkt::QuoteNotif),
}

async fn new_recv_address(data: &Data) -> Result<elements::Address, Error> {
    let (res_sender, res_receiver) = tokio::sync::oneshot::channel();
    data.wallet_command_sender
        .send(sideswap_lwk::Command::NewAdddress {
            res_sender: res_sender.into(),
        })?;
    let address = res_receiver.await?.map_err(Error::Wallet)?;
    Ok(address)
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
    let receive_address = req.receive_address;
    let change_address = new_recv_address(&data).await?;

    let utxos = data
        .utxo_data
        .as_ref()
        .ok_or(Error::NoUtxos)?
        .utxos()
        .iter()
        .filter(|utxo| utxo.asset == send_asset.asset_id)
        .cloned()
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

            let quote_resp =
                make_market_request!(data.ws, GetQuote, mkt::GetQuoteRequest { quote_id })?;

            let pset = decode_pset(&quote_resp.pset)?;

            let txid = pset.extract_tx()?.txid();

            let expires_at = Instant::now() + quote_resp.ttl.duration();

            let pset = data
                .utxo_data
                .as_ref()
                .ok_or(Error::NoUtxos)?
                .sign_pset(pset);

            data.quotes.insert(
                quote_id,
                Quote {
                    txid,
                    pset,
                    expires_at,
                },
            );

            Ok(api::GetQuoteResp {
                quote_id,
                recv_amount: quote_recv_amount,
                ttl,
                txid,
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
    let quote = data.quotes.get(&req.quote_id).ok_or(Error::NoQuote)?;

    verify!(quote.ttl_valid(), Error::QuoteExpired);

    let pset = encode_pset(&quote.pset);

    data.db
        .add_swap(Swap {
            txid: Text(quote.txid),
        })
        .await;

    data.swaps.insert(quote.txid);

    let accept_resp = make_market_request!(
        data.ws,
        TakerSign,
        mkt::TakerSignRequest {
            quote_id: req.quote_id,
            pset,
        }
    )?;

    assert_eq!(quote.txid, accept_resp.txid);

    Ok(api::AcceptQuoteResp {
        txid: accept_resp.txid,
    })
}

async fn new_peg(
    data: &mut Data,
    api::NewPegReq {
        recv_addr,
        peg_in,
        blocks,
    }: api::NewPegReq,
) -> Result<api::NewPegResp, Error> {
    let resp = make_request!(
        data.ws,
        Peg,
        sideswap_api::PegRequest {
            recv_addr,
            send_amount: None,
            peg_in,
            device_key: None,
            blocks,
            peg_out_amounts: None,
        }
    )?;

    let status = make_request!(
        data.ws,
        PegStatus,
        sideswap_api::PegStatusRequest {
            order_id: resp.order_id,
            peg_in: None,
        }
    )?;

    process_peg_status(data, status);

    data.db
        .add_peg(Peg {
            order_id: Text(resp.order_id),
        })
        .await;

    data.pegs.insert(resp.order_id);

    Ok(api::NewPegResp {
        order_id: resp.order_id,
        peg_addr: resp.peg_addr,
    })
}

async fn del_peg(
    data: &mut Data,
    api::DelPegReq { order_id }: api::DelPegReq,
) -> Result<api::DelPegResp, Error> {
    data.db.delete_peg(order_id).await;

    Ok(api::DelPegResp {})
}

async fn get_swaps(
    data: &mut Data,
    api::GetSwapsReq {}: api::GetSwapsReq,
) -> Result<api::GetSwapsResp, Error> {
    let (res_sender, res_receiver) = tokio::sync::oneshot::channel();
    data.wallet_command_sender
        .send(sideswap_lwk::Command::GetTxs {
            req: sideswap_lwk::GetTxsReq {
                txids: data.swaps.clone(),
            },
            res_sender: res_sender.into(),
        })?;
    let txs = res_receiver.await?.map_err(Error::Wallet)?;

    let swaps = data
        .swaps
        .iter()
        .map(|txid| {
            let tx = txs.txs.iter().find(|tx| tx.txid == *txid);

            let status = if let Some(tx) = tx {
                if tx.height.is_some() {
                    api::SwapStatus::Confirmed
                } else {
                    api::SwapStatus::Mempool
                }
            } else {
                api::SwapStatus::NotFound
            };

            api::Swap {
                txid: *txid,
                status,
            }
        })
        .collect::<Vec<_>>();

    Ok(api::GetSwapsResp { swaps })
}

async fn process_command(data: &mut Data, command: Command) {
    match command {
        Command::NewAddress { res_sender } => {
            let res = new_recv_address(data).await;
            res_sender.send(res);
        }

        Command::GetQuote { req, res_sender } => {
            let res = get_quote(data, req).await;
            res_sender.send(res);
        }

        Command::AcceptQuote { req, res_sender } => {
            let res = accept_quote(data, req).await;
            res_sender.send(res);
        }

        Command::NewPeg { req, res_sender } => {
            let res = new_peg(data, req).await;
            res_sender.send(res);
        }

        Command::DelPeg { req, res_sender } => {
            let res = del_peg(data, req).await;
            res_sender.send(res);
        }

        Command::GetSwaps { req, res_sender } => {
            let res = get_swaps(data, req).await;
            res_sender.send(res);
        }

        Command::ClientConnected {
            client_id,
            notif_sender,
        } => {
            if let Some(balance) = &data.last_balances {
                notif_sender.send(api::Notif::Balances(balance.clone()));
            }

            for status in data.peg_statuses.values() {
                notif_sender.send(api::Notif::PegStatus(status.clone()));
            }

            data.clients.insert(client_id, ClientData { notif_sender });
        }

        Command::ClientDisconnected { client_id } => {
            data.clients.remove(&client_id).expect("must not fail");
        }
    }
}

fn process_ws_connected(data: &mut Data) {
    data.ws
        .send_request(sideswap_api::Request::Market(mkt::Request::ListMarkets(
            mkt::ListMarketsRequest {},
        )));

    for order_id in data.pegs.iter() {
        data.ws.send_request(sideswap_api::Request::PegStatus(
            sideswap_api::PegStatusRequest {
                order_id: *order_id,
                peg_in: None,
            },
        ));
    }
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

fn process_peg_status(data: &mut Data, status: PegStatus) {
    if data.pegs.contains(&status.order_id) {
        send_notifs(data, &api::Notif::PegStatus(status.clone()));
    }
    data.peg_statuses.insert(status.order_id, status);
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

        WrappedResponse::Response(ResponseMessage::Response(
            _,
            Ok(sideswap_api::Response::PegStatus(status)),
        )) => {
            process_peg_status(data, status);
        }

        WrappedResponse::Response(ResponseMessage::Response(_req_id, _res)) => {}

        WrappedResponse::Response(ResponseMessage::Notification(
            sideswap_api::Notification::PegStatus(status),
        )) => {
            process_peg_status(data, status);
        }

        WrappedResponse::Response(ResponseMessage::Notification(
            sideswap_api::Notification::Market(notif),
        )) => {
            process_market_notif(data, notif);
        }

        WrappedResponse::Response(ResponseMessage::Notification(_)) => {}
    }
}

fn process_wallet_event(data: &mut Data, event: sideswap_lwk::Event) {
    match event {
        sideswap_lwk::Event::Utxos { utxo_data } => {
            let new_balances = api::BalancesNotif {
                balances: convert_balances(data, &utxo_data),
            };

            data.utxo_data = Some(utxo_data);

            if data.last_balances.as_ref() != Some(&new_balances) {
                // TODO: Send updated balances to the clients
                log::debug!("wallet balances updated: {new_balances:?}");
                send_notifs(data, &api::Notif::Balances(new_balances.clone()));
                data.last_balances = Some(new_balances);
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

    let network = settings.env.d().network;

    let (wallet_command_sender, wallet_command_receiver) = channel::<sideswap_lwk::Command>();
    let (wallet_event_sender, mut wallet_event_receiver) =
        unbounded_channel::<sideswap_lwk::Event>();
    let wallet_params = sideswap_lwk::Params {
        network,
        work_dir: settings.work_dir.clone(),
        mnemonic: settings.mnemonic.clone(),
        script_variant: settings.script_variant,
    };
    sideswap_lwk::start(wallet_params, wallet_command_receiver, wallet_event_sender);

    let pegs = db
        .load_pegs()
        .await
        .iter()
        .map(|peg| peg.order_id.0)
        .collect();

    let swaps = db
        .load_swaps()
        .await
        .iter()
        .map(|swap| swap.txid.0)
        .collect();

    let mut data = Data {
        _settings: settings,
        _policy_asset: policy_asset,
        ticker_loader,
        db,
        ws,
        wallet_command_sender,
        markets: Vec::new(),
        clients: BTreeMap::new(),
        last_balances: None,
        utxo_data: None,
        pegs,
        peg_statuses: BTreeMap::new(),
        swaps,
        quotes: BTreeMap::new(),
    };

    let term_signal = sideswap_dealer::signals::TermSignal::new();

    loop {
        tokio::select! {
            event = wallet_event_receiver.recv() => {
                let event = event.expect("must be open");
                process_wallet_event(&mut data, event);
            },

            command = command_receiver.recv() => {
                let command = command.expect("channel must be open");
                process_command(&mut data, command).await;
            },

            event = data.ws.recv() => {
                process_ws_event(&mut data, event).await;
            },

            _ = term_signal.recv() => {
                log::info!("terminate signal received");
                break;
            },
        }

        data.quotes.retain(|_quote_id, quote| quote.ttl_valid())
    }

    data.db.close().await;
}
