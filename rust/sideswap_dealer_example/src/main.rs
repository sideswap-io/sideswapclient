use clap::{App, Arg};
use rpc::RpcServer;
use serde::Deserialize;
use sideswap_api::*;
use sideswap_common::*;
use std::collections::{BTreeMap, BTreeSet};
use types::{Amount, TxOut};

mod btc_zmq;
mod prices;

#[macro_use]
extern crate log;
#[macro_use]
extern crate anyhow;

const TICKER_BITCOIN: &str = "L-BTC";
const TICKER_TETHER: &str = "USDt";

const SERVER_REQUEST_TIMEOUT: std::time::Duration = std::time::Duration::from_secs(5);

const UNSPENT_MIN_CONF: i32 = 1;

// Sanity check
const MIN_PROFIT_RATIO: f64 = 1.002;

#[derive(Debug, Deserialize)]
struct Settings {
    log_settings: String,

    max_trade_size: f64,

    server_host: String,
    server_port: i32,
    server_use_tls: bool,

    rpc: RpcServer,

    api_key: String,

    zmq: btc_zmq::Server,

    profit_ratio: f64,
}

enum Msg {
    Connected,
    Disconnected,
    Notification(Notification),
    NewBlock,
}

#[derive(Clone, Debug)]
struct Utxo {
    item: rpc::UnspentItem,
    reserve: Option<OrderId>,
    amount: i64,
}

struct ActiveSwap {
    proposal: i64,
    change_amount: i64,
    sell_asset: String,
    swap: Option<Swap>,
}

type Utxos = BTreeMap<TxOut, Utxo>;

fn free_reservation(order_id: &OrderId, utxos: &mut Utxos) {
    for utxo in utxos
        .values_mut()
        .filter(|utxo| utxo.reserve.as_ref() == Some(&order_id))
    {
        utxo.reserve = None;
    }
}

fn main() {
    let matches = App::new("sideswap_dealer")
        .arg(Arg::with_name("config").required(true))
        .get_matches();
    let config_path = matches.value_of("config").unwrap();

    info!("starting up");

    let mut conf = config::Config::new();
    conf.merge(config::File::with_name(config_path))
        .expect("can't load config");
    conf.merge(config::Environment::with_prefix("app").separator("_"))
        .expect("reading env failed");
    let settings: Settings = conf.try_into().expect("invalid config");

    log4rs::init_file(&settings.log_settings, Default::default()).expect("can't open log settings");

    let (msg_tx, msg_rx) = std::sync::mpsc::channel::<Msg>();
    let (ws_tx, ws_rx) = ws::start(
        settings.server_host,
        settings.server_port,
        settings.server_use_tls,
    );
    let current_request_id = std::sync::Arc::new(std::sync::atomic::AtomicI64::new(0));
    let (resp_tx, resp_rx) = std::sync::mpsc::channel::<Result<Response, Error>>();
    let current_request_id_copy = std::sync::Arc::clone(&current_request_id);
    let max_trade_amount = Amount::from_bitcoin(settings.max_trade_size);

    assert!(settings.profit_ratio >= MIN_PROFIT_RATIO);

    let msg_tx_copy = msg_tx.clone();
    std::thread::spawn(move || {
        for msg in ws_rx {
            match msg {
                ws::WrappedResponse::Connected => {
                    msg_tx_copy.send(Msg::Connected).unwrap();
                }
                ws::WrappedResponse::Disconnected => {
                    msg_tx_copy.send(Msg::Disconnected).unwrap();
                }
                ws::WrappedResponse::Response(ResponseMessage::Response(
                    Some(RequestId::Int(request_id)),
                    response,
                )) => {
                    let pending_request_id =
                        current_request_id_copy.load(std::sync::atomic::Ordering::Relaxed);
                    if request_id != pending_request_id {
                        panic!(
                            "unexpected request_id response: {}, expecting: {}",
                            request_id, pending_request_id
                        );
                    }
                    resp_tx.send(response).unwrap();
                }
                ws::WrappedResponse::Response(ResponseMessage::Response(_, _)) => {
                    panic!("invalid request_id response");
                }
                ws::WrappedResponse::Response(ResponseMessage::Notification(notification)) => {
                    msg_tx_copy.send(Msg::Notification(notification)).unwrap();
                }
            }
        }
    });

    let send_request = |request: Request| -> Result<Response, Error> {
        current_request_id.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
        let request_id = current_request_id.load(std::sync::atomic::Ordering::Relaxed);
        ws_tx
            .send(ws::WrappedRequest::Request(RequestMessage::Request(
                RequestId::Int(request_id),
                request,
            )))
            .unwrap();
        resp_rx
            .recv_timeout(SERVER_REQUEST_TIMEOUT)
            .expect("request timeout")
    };

    let msg_tx_copy = msg_tx.clone();
    btc_zmq::connect(&settings.zmq, move |topic, _| {
        match topic {
            btc_zmq::BtcTopic::PubHashBlock => {
                msg_tx_copy.send(Msg::NewBlock).unwrap();
            }
            _ => {}
        };
    });

    macro_rules! send_request {
        ($t:ident, $value:expr) => {
            match send_request(Request::$t($value)) {
                Ok(Response::$t(value)) => Ok(value),
                Ok(_) => panic!("unexpected response type"),
                Err(error) => Err(error),
            }
        };
    }

    let mut assets = Vec::new();
    let mut utxos = Utxos::new();
    let mut swaps: BTreeMap<OrderId, ActiveSwap> = BTreeMap::new();

    msg_tx.send(Msg::NewBlock).unwrap();

    let rpc_http_client = reqwest::blocking::Client::builder()
        .timeout(std::time::Duration::from_secs(5))
        .build()
        .expect("http client construction failed");

    loop {
        let msg = msg_rx.recv().unwrap();

        match msg {
            Msg::Connected => {
                info!("connected to server");

                send_request!(
                    LoginDealer,
                    LoginDealerRequest {
                        api_key: settings.api_key.clone(),
                    }
                )
                .expect("dealer login failed");

                assets = send_request!(Assets, None)
                    .expect("loading assets failed")
                    .assets;
            }

            Msg::Disconnected => {
                warn!("disconnected from server");
            }

            Msg::Notification(notification) => match notification {
                Notification::RfqCreated(rfq) => {
                    let asset_sell = assets
                        .iter()
                        .find(|v| v.asset_id == rfq.rfq.recv_asset)
                        .expect("buy_asset must be known");
                    let asset_buy = assets
                        .iter()
                        .find(|v| v.asset_id == rfq.rfq.send_asset)
                        .expect("sell_asset must be known");
                    info!(
                        "new RFQ received, order_id: {}, dealer deleiver: {}, dealer receive: {}",
                        &rfq.order_id, &asset_sell.ticker, &asset_buy.ticker
                    );

                    assert!(
                        asset_sell.ticker == TICKER_BITCOIN || asset_buy.ticker == TICKER_BITCOIN
                    );

                    let sell_bitcoin = asset_sell.ticker == TICKER_BITCOIN;
                    let other_asset = if sell_bitcoin { asset_buy } else { asset_sell };

                    let md_price = if other_asset.ticker == TICKER_TETHER {
                        match prices::download_bitcoin_last_usd_price() {
                            Ok(v) => v,
                            Err(e) => {
                                error!("getting bitcoin price failed: {}", &e);
                                continue;
                            }
                        }
                    } else {
                        warn!("unknown asset: {}", &other_asset.ticker);
                        continue;
                    };

                    let proposal = if sell_bitcoin {
                        rfq.rfq.send_amount / (md_price * settings.profit_ratio) as i64
                    } else {
                        rfq.rfq.send_amount * (md_price / settings.profit_ratio) as i64
                    };
                    let bitcoin_amount = if sell_bitcoin {
                        Amount::from_bitcoin(
                            Amount::from_sat(rfq.rfq.send_amount).to_bitcoin() / md_price,
                        )
                    } else {
                        Amount::from_sat(rfq.rfq.send_amount)
                    };

                    if bitcoin_amount > max_trade_amount {
                        info!(
                            "amount to trade is more than allowed: {} > {}",
                            Amount::from_sat(rfq.rfq.send_amount).to_bitcoin(),
                            max_trade_amount.to_bitcoin()
                        );
                        continue;
                    }

                    let available_utxos: Vec<i64> = utxos
                        .values()
                        .filter(|utxo| {
                            utxo.item.asset == asset_sell.asset_id && utxo.reserve.is_none()
                        })
                        .map(|utxo| utxo.amount)
                        .collect();
                    let total: i64 = available_utxos.iter().sum();
                    if total < proposal {
                        info!(
                            "not enough amount to make proposal: {}, required: {}",
                            total, proposal
                        );
                        continue;
                    }

                    let result = types::select_utxo(available_utxos, proposal);
                    let change_amount = result.iter().sum::<i64>() - proposal;
                    assert!(change_amount >= 0);

                    info!("sending quote: {}", proposal);
                    let quote_result = send_request!(
                        MatchQuote,
                        MatchQuoteRequest {
                            quote: MatchQuote {
                                order_id: rfq.order_id.clone(),
                                send_amount: proposal,
                                utxo_count: result.len() as i32,
                                with_change: change_amount > 0,
                            },
                        }
                    );
                    if let Err(e) = quote_result {
                        error!("sending quote failed: {}", &e.message);
                        continue;
                    };
                    debug!("sending quote succeed");

                    for &amount in result.iter() {
                        let utxo = utxos
                            .values_mut()
                            .find(|utxo| {
                                utxo.item.asset == asset_sell.asset_id
                                    && utxo.reserve.is_none()
                                    && utxo.amount == amount
                            })
                            .expect("utxo must exists");
                        utxo.reserve = Some(rfq.order_id.clone());
                    }

                    swaps.insert(
                        rfq.order_id,
                        ActiveSwap {
                            proposal,
                            change_amount,
                            sell_asset: asset_sell.asset_id.clone(),
                            swap: None,
                        },
                    );
                }

                Notification::RfqRemoved(rfq) => {
                    if rfq.status != RfqStatus::Accepted {
                        free_reservation(&rfq.order_id, &mut utxos);
                    }
                }

                Notification::Swap(swap) => {
                    let active_swap = swaps.get_mut(&swap.order_id).expect("swap must exists");
                    match &swap.state {
                        SwapState::ReviewOffer(offer) => {
                            info!("waiting user offer accept");
                            assert!(!offer.accept_required);
                            assert!(offer.swap.send_asset == active_swap.sell_asset);
                            assert!(offer.swap.send_amount == active_swap.proposal);
                            active_swap.swap = Some(offer.swap.clone());
                        }
                        SwapState::WaitPsbt => {
                            let sw = active_swap.swap.as_ref().expect("swap must be set");
                            let new_address = rpc::make_rpc_call::<String>(
                                &rpc_http_client,
                                &settings.rpc,
                                &rpc::get_new_address(),
                            )
                            .expect("getting new address failed");

                            let inputs: Vec<_> = utxos
                                .values()
                                .filter(|utxo| utxo.reserve.as_ref() == Some(&swap.order_id))
                                .map(|utxo| utxo.item.tx_out())
                                .collect();
                            let mut outputs_amounts: BTreeMap<String, serde_json::Value> =
                                BTreeMap::new();
                            let mut outputs_assets: BTreeMap<String, String> = BTreeMap::new();

                            outputs_amounts.insert(
                                new_address.clone(),
                                Amount::from_sat(sw.recv_amount).to_rpc(),
                            );
                            outputs_assets.insert(new_address.clone(), sw.recv_asset.clone());

                            if active_swap.change_amount > 0 {
                                let change_address = rpc::make_rpc_call::<String>(
                                    &rpc_http_client,
                                    &settings.rpc,
                                    &rpc::get_new_address(),
                                )
                                .expect("getting new address failed");
                                outputs_amounts.insert(
                                    change_address.clone(),
                                    Amount::from_sat(active_swap.change_amount).to_rpc(),
                                );
                                outputs_assets
                                    .insert(change_address, active_swap.sell_asset.clone());
                            }

                            let raw_tx = rpc::make_rpc_call::<String>(
                                &rpc_http_client,
                                &settings.rpc,
                                &rpc::create_raw_tx(
                                    &inputs,
                                    &outputs_amounts,
                                    0,
                                    false,
                                    &outputs_assets,
                                ),
                            )
                            .expect("creating raw tx failed");

                            let psbt = rpc::make_rpc_call::<String>(
                                &rpc_http_client,
                                &settings.rpc,
                                &rpc::convert_to_psbt(&raw_tx),
                            )
                            .expect("converting PSBT failed");

                            let psbt = rpc::make_rpc_call::<rpc::FillPsbtData>(
                                &rpc_http_client,
                                &settings.rpc,
                                &rpc::fill_psbt_data(&psbt),
                            )
                            .expect("converting PSBT failed");

                            send_request!(
                                Swap,
                                SwapRequest {
                                    order_id: swap.order_id.clone(),
                                    action: SwapAction::Psbt(psbt.psbt),
                                }
                            )
                            .expect("sending psbt failed");
                        }
                        SwapState::WaitSign(psbt) => {
                            let result = rpc::make_rpc_call::<rpc::WalletSignPsbt>(
                                &rpc_http_client,
                                &settings.rpc,
                                &rpc::wallet_sign_psbt(&psbt),
                            )
                            .expect("signing PSBT failed");

                            send_request!(
                                Swap,
                                SwapRequest {
                                    order_id: swap.order_id.clone(),
                                    action: SwapAction::Sign(result.psbt),
                                }
                            )
                            .expect("sending signed PSBT failed");
                        }
                        SwapState::Failed(error) => {
                            info!("swap failed: {:?}", error);
                            free_reservation(&swap.order_id, &mut utxos);
                        }
                        SwapState::Done(txid) => {
                            info!("swap succeed, txid: {}", &txid);
                        }
                    }
                }
                _ => {}
            },

            Msg::NewBlock => {
                debug!("new block detected");
                let unspent_with_zc = rpc::make_rpc_call::<rpc::ListUnspent>(
                    &rpc_http_client,
                    &settings.rpc,
                    &rpc::list_unspent2(0),
                )
                .expect("list_unspent failed");

                let unspent: rpc::ListUnspent = unspent_with_zc
                    .into_iter()
                    .filter(|utxo| utxo.confirmations >= UNSPENT_MIN_CONF)
                    .collect();
                let old_keys: BTreeSet<_> = utxos.keys().cloned().collect();
                let new_keys: BTreeSet<_> = unspent.iter().map(|item| item.tx_out()).collect();
                for item in unspent {
                    utxos.entry(item.tx_out()).or_insert(Utxo {
                        amount: Amount::from_rpc(&item.amount).to_sat(),
                        item,
                        reserve: None,
                    });
                }
                for key in old_keys.difference(&new_keys) {
                    debug!("remove consumed utxo: {}/{}", &key.txid, key.vout);
                    utxos.remove(&key);
                }
            }
        }
    }
}
