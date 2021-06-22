use super::rpc;
use serde::{Deserialize, Serialize};
use sideswap_api::*;
use sideswap_common::types;
use sideswap_common::types::{Amount, TxOut};
use sideswap_common::ws;
use std::collections::{BTreeMap, BTreeSet};
use std::sync::mpsc::{Receiver, Sender};

// Extra asset UTXO amount to cover future price edits
const EXTRA_ASSET_UTXO_FRACTION: f64 = 0.03;

// Recreated order if bitcoin amount increase to more than that value
// (for example if wallet balance increase).
const RECREATE_ORDER_AMOUNT_FRACTION: f64 = 0.05;

const MIN_BITCOIN_AMOUNT: f64 = 0.0001;

const PRICE_EXPIRATON_TIME: std::time::Duration = std::time::Duration::from_secs(60);

#[derive(Debug, Clone)]
pub struct Params {
    pub env: types::Env,

    pub server_host: String,
    pub server_port: u16,
    pub server_use_tls: bool,

    pub rpc: rpc::RpcServer,

    pub interest_submit: f64,
    pub interest_sign: f64,

    pub tickers: BTreeSet<DealerTicker>,

    pub bitcoin_amount_submit: Amount,
    pub bitcoin_amount_min: Amount,
    pub bitcoin_amount_max: Amount,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ToPrice {
    pub ticker: DealerTicker,
    pub price: Option<PricePair>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ToLimitBalance {
    pub ticker: DealerTicker,
    pub recv_limit: bool,
    pub balance: f64,
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "snake_case")]
pub enum To {
    Price(ToPrice),
    LimitBalance(ToLimitBalance),
    ResetPrices(Empty),
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "snake_case")]
pub enum From {
    Swap(SwapSucceed),
    WalletBalanceUpdated(Empty),
}
#[derive(Serialize, Deserialize, Debug)]
pub struct SwapSucceed {
    pub txid: String,
    pub ticker: DealerTicker,
    pub bitcoin_amount: sideswap_common::types::Amount,
    pub send_bitcoins: bool,
}

enum Msg {
    To(To),
    Timer,
    Connected,
    Disconnected,
    Notification(Notification),
    ReloadUtxo,
}

#[derive(Clone, Debug)]
pub struct Utxo {
    pub item: rpc::UnspentItem,
    pub reserve: Option<OrderId>,
    pub amount: i64,
}

pub type Utxos = BTreeMap<TxOut, Utxo>;

pub type WalletBalances = BTreeMap<DealerTicker, f64>;
pub type IndexPrices = BTreeMap<DealerTicker, PriceTimestamp>;
#[derive(Clone, Copy, PartialEq, Debug)]
pub struct PriceTimestamp {
    pub price: PricePair,
    pub timestamp: std::time::Instant,
}

#[derive(Default)]
pub struct AllBalances {
    wallet: WalletBalances,
    max_send: WalletBalances,
    max_recv: WalletBalances,
}

pub struct OwnOrder {
    pub order_id: OrderId,
    pub bitcoin_amount: Amount,
    pub price: f64,
}

#[derive(Debug, Hash, PartialEq, Eq, Ord, PartialOrd, Clone, Copy)]
struct OwnOrderKey {
    ticker: DealerTicker,
    send_bitcoins: bool,
}

const SERVER_REQUEST_TIMEOUT: std::time::Duration = std::time::Duration::from_secs(5);

#[derive(Debug, Clone, Copy, Hash, PartialEq, Eq, PartialOrd, Ord, Serialize)]
pub struct DealerTicker(pub &'static str);

pub const DEALER_LBTC: DealerTicker = DealerTicker(TICKER_LBTC);
pub const DEALER_USDT: DealerTicker = DealerTicker(TICKER_USDT);
pub const DEALER_EURX: DealerTicker = DealerTicker(TICKER_EURX);
pub const DEALER_LCAD: DealerTicker = DealerTicker(TICKER_LCAD);
pub const DEALER_AUDL: DealerTicker = DealerTicker(TICKER_AUDL);

macro_rules! send_request {
    ($f:ident, $t:ident, $value:expr) => {
        match $f(Request::$t($value)) {
            Ok(Response::$t(value)) => Ok(value),
            Ok(_) => panic!("unexpected response type"),
            Err(error) => Err(error),
        }
    };
}

pub fn ticker_from_string(asset: &str) -> Result<DealerTicker, anyhow::Error> {
    let ticker = match asset {
        TICKER_LBTC => TICKER_LBTC,
        TICKER_USDT => TICKER_USDT,
        TICKER_EURX => TICKER_EURX,
        TICKER_LCAD => TICKER_LCAD,
        TICKER_AUDL => TICKER_AUDL,
        _ => bail!("ticker {} not found", asset),
    };
    Ok(DealerTicker(ticker))
}

pub fn ticker_from_asset(asset: &Asset) -> Result<DealerTicker, anyhow::Error> {
    ticker_from_string(&asset.ticker.0)
}

impl<'de> Deserialize<'de> for DealerTicker {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: serde::Deserializer<'de>,
    {
        let name = String::deserialize(deserializer)?;
        ticker_from_string(&name).map_err(|e| serde::de::Error::custom(e))
    }
}

pub fn apply_interest(price: PricePair, interest: f64) -> PricePair {
    // Limit to 10% as sanity check
    assert!(interest >= 1.0 && interest <= 1.1);
    PricePair {
        bid: price.bid / interest,
        ask: price.ask * interest,
    }
}

pub fn get_price_pair(price: PriceTimestamp) -> PricePair {
    price.price
}

fn take_order(
    params: &Params,
    assets: &Assets,
    details: &Details,
    all: &AllBalances,
    index_prices: &IndexPrices,
    interest: f64,
) -> Result<(), anyhow::Error> {
    ensure!(details.bitcoin_amount >= params.bitcoin_amount_min.to_sat());
    ensure!(details.bitcoin_amount <= params.bitcoin_amount_max.to_sat());
    let asset = assets
        .iter()
        .find(|asset| asset.asset_id == details.asset)
        .unwrap();
    let ticker = ticker_from_asset(asset)?;
    let index_price = index_prices.get(&ticker).cloned();
    let actual_bitcoin_amount = Amount::from_sat(if details.send_bitcoins {
        details.bitcoin_amount + details.server_fee
    } else {
        details.bitcoin_amount - details.server_fee
    });
    let asset_amount = types::asset_float_amount(details.asset_amount, asset.precision);
    let actual_price = asset_amount / actual_bitcoin_amount.to_bitcoin();
    assert!(actual_price > 0.0);
    let index_price = get_price_pair(index_price.ok_or(anyhow!("index price is not known"))?);
    let dealer_price = apply_interest(index_price, interest);
    let bitcoin_amount_max =
        get_bitcoin_amount(all, ticker, actual_price, details.send_bitcoins, true);
    if details.send_bitcoins {
        ensure!(
            actual_price >= dealer_price.ask,
            "actual_price: {}, dealer_price.ask: {}",
            actual_price,
            dealer_price.ask
        );
    } else {
        ensure!(
            actual_price <= dealer_price.bid,
            "actual_price: {}, dealer_price.bid: {}",
            actual_price,
            dealer_price.bid
        );
    }
    ensure!(
        details.bitcoin_amount <= bitcoin_amount_max.to_sat(),
        "bitcoin amount: {}, max bitcoin amount: {}",
        details.bitcoin_amount,
        bitcoin_amount_max
    );
    Ok(())
}

fn get_pset(
    order_id: &OrderId,
    details: &Details,
    utxos: &Utxos,
    params: &Params,
    http_client: &reqwest::blocking::Client,
    extra_asset_utxo: bool,
) -> Result<AddrRequest, anyhow::Error> {
    let env_data = types::env_data(params.env);
    let (send_asset, send_amount) = if details.send_bitcoins {
        (
            AssetId(env_data.bitcoin_asset_id.to_owned()),
            details.bitcoin_amount + details.server_fee,
        )
    } else {
        (details.asset.clone(), details.asset_amount)
    };

    let mut asset_utxos: Vec<_> = utxos
        .values()
        .filter(|utxo| utxo.item.asset == send_asset.0)
        .collect();
    let utxos_amounts: Vec<i64> = asset_utxos.iter().map(|utxo| utxo.amount).collect();
    let total: i64 = utxos_amounts.iter().sum();
    ensure!(send_amount <= total);
    let utxo_amount = if extra_asset_utxo && !details.send_bitcoins {
        i64::min(
            total,
            f64::round(send_amount as f64 * (1.0 + EXTRA_ASSET_UTXO_FRACTION)) as i64,
        )
    } else {
        send_amount
    };
    let selected = types::select_utxo(utxos_amounts, utxo_amount);
    let mut selected_utxos = Vec::new();
    for amount in selected {
        let index = asset_utxos
            .iter()
            .position(|v| v.amount == amount)
            .expect("utxo must exists");
        let utxo = asset_utxos.swap_remove(index);
        let txout = TxOut::new(utxo.item.txid.clone(), utxo.item.vout);
        selected_utxos.push(txout);
    }
    let outputs_amounts: BTreeMap<String, serde_json::Value> = BTreeMap::new();
    let outputs_assets: BTreeMap<String, String> = BTreeMap::new();
    let raw_tx = rpc::make_rpc_call::<String>(
        &http_client,
        &params.rpc,
        &rpc::create_raw_tx(&selected_utxos, &outputs_amounts, 0, false, &outputs_assets),
    )
    .expect("creating raw tx failed");

    let pset =
        rpc::make_rpc_call::<String>(http_client, &params.rpc, &rpc::convert_to_psbt(&raw_tx))
            .expect("converting PSBT failed");
    let pset = rpc::make_rpc_call::<rpc::FillPsbtData>(
        &http_client,
        &params.rpc,
        &rpc::fill_psbt_data(&pset),
    )
    .expect("converting PSBT failed");

    let recv_addr =
        rpc::make_rpc_call::<String>(&http_client, &params.rpc, &rpc::get_new_address())
            .expect("getting new address failed");
    let change_addr =
        rpc::make_rpc_call::<String>(&http_client, &params.rpc, &rpc::get_new_address())
            .expect("getting new address failed");

    Ok(AddrRequest {
        order_id: order_id.clone(),
        pset: pset.psbt,
        recv_addr,
        change_addr,
        price: details.price,
    })
}

fn get_price(price: &PricePair, send_bitcoins: bool, interest: f64) -> f64 {
    if send_bitcoins {
        price.ask * interest
    } else {
        price.bid / interest
    }
}

fn amount_change(new: Amount, old: Amount) -> f64 {
    (new.to_bitcoin() - old.to_bitcoin()) / old.to_bitcoin()
}

fn get_bitcoin_amount(
    all: &AllBalances,
    ticker: DealerTicker,
    price: f64,
    send_bitcoins: bool,
    max_amount: bool,
) -> Amount {
    let wallet_asset = all.wallet.get(&ticker).cloned().unwrap_or_default();
    let wallet_bitcoin =
        all.wallet.get(&DEALER_LBTC).cloned().unwrap_or_default() / (1.0 + types::SERVER_FEE_RATE);
    let bitcoin_max_send = all.max_send.get(&DEALER_LBTC).cloned().unwrap_or(f64::MAX);
    let bitcoin_max_recv = all.max_recv.get(&DEALER_LBTC).cloned().unwrap_or(f64::MAX);
    let asset_max_send = all.max_send.get(&ticker).cloned().unwrap_or(f64::MAX);
    let asset_max_recv = all.max_recv.get(&ticker).cloned().unwrap_or(f64::MAX);
    let extra_asset_downscale = if max_amount {
        1.0
    } else {
        1.0 / (1.0 + EXTRA_ASSET_UTXO_FRACTION)
    };
    if send_bitcoins {
        Amount::from_bitcoin(f64::min(
            f64::min(
                wallet_bitcoin,
                asset_max_recv * extra_asset_downscale / price,
            ),
            bitcoin_max_send,
        ))
    } else {
        Amount::from_bitcoin(f64::min(
            f64::min(
                wallet_asset * extra_asset_downscale / price,
                bitcoin_max_recv,
            ),
            asset_max_send * extra_asset_downscale / price,
        ))
    }
}

fn cancel_order<T: Fn(Request) -> Result<Response, Error>>(data: &mut OwnOrder, send_request: &T) {
    let cancel_result = send_request!(
        send_request,
        Cancel,
        CancelRequest {
            order_id: data.order_id.clone(),
        }
    );
    if let Err(e) = cancel_result {
        error!("cancelling order failed: {}", e);
    }
}

fn update_price<T: Fn(Request) -> Result<Response, Error>>(
    own: &mut Option<OwnOrder>,
    send_bitcoins: bool,
    assets: &Assets,
    ticker: DealerTicker,
    index_prices: &IndexPrices,
    all: &AllBalances,
    utxos: &Utxos,
    params: &Params,
    http_client: &reqwest::blocking::Client,
    send_request: &T,
) {
    let asset = assets
        .iter()
        .find(|asset| asset.ticker.0 == ticker.0)
        .unwrap();
    let price = index_prices.get(&ticker).cloned();
    let expected_server_fee = Amount::from_bitcoin(f64::max(
        types::SERVER_FEE_RATE * params.bitcoin_amount_submit.to_bitcoin(),
        types::MIN_SERVER_FEE.to_bitcoin(),
    ));
    let interest_take_ajusted = params.interest_submit
        * (1.0 + expected_server_fee.to_bitcoin() / params.bitcoin_amount_submit.to_bitcoin());
    let price = price.map(|price| get_price(&price.price, send_bitcoins, interest_take_ajusted));
    let new_bitcoin_amount_normal = price
        .map(|price| {
            Amount::min(
                get_bitcoin_amount(all, ticker, price, send_bitcoins, false),
                params.bitcoin_amount_submit,
            )
        })
        .unwrap_or_default();
    let new_bitcoin_amount_max = price
        .map(|price| get_bitcoin_amount(all, ticker, price, send_bitcoins, true))
        .unwrap_or_default();
    match (own.as_mut(), price) {
        (None, Some(price)) if new_bitcoin_amount_normal >= params.bitcoin_amount_min => {
            let submit_result = send_request!(
                send_request,
                Submit,
                SubmitRequest {
                    order: PriceOrder {
                        asset: asset.asset_id.clone(),
                        bitcoin_amount: if send_bitcoins {
                            -new_bitcoin_amount_normal.to_bitcoin()
                        } else {
                            new_bitcoin_amount_normal.to_bitcoin()
                        },
                        price: Some(price),
                        index_price: None,
                    },
                    session_id: None,
                }
            );
            if let Ok(submit_resp) = submit_result {
                let pset = get_pset(
                    &submit_resp.order_id,
                    &submit_resp.details,
                    &utxos,
                    &params,
                    &http_client,
                    true,
                );
                match pset {
                    Ok(v) => {
                        let addr_result = send_request!(send_request, Addr, v);
                        match addr_result {
                            Ok(_) => {
                                *own = Some(OwnOrder {
                                    order_id: submit_resp.order_id,
                                    bitcoin_amount: new_bitcoin_amount_normal,
                                    price,
                                });
                            }
                            Err(e) => error!("sending Addr request failed: {}", e),
                        }
                    }
                    Err(e) => error!("creating PSET failed: {}", e),
                }
            }
        }
        (Some(data), Some(_))
            if new_bitcoin_amount_max.to_sat() == 0
                || data.bitcoin_amount > new_bitcoin_amount_max
                || amount_change(new_bitcoin_amount_normal, data.bitcoin_amount)
                    >= RECREATE_ORDER_AMOUNT_FRACTION =>
        {
            info!(
                "cancel order {} because bitcoin amount changes, old: {}, new: {}, max: {}",
                data.order_id,
                data.bitcoin_amount.to_bitcoin(),
                new_bitcoin_amount_normal.to_bitcoin(),
                new_bitcoin_amount_max.to_bitcoin(),
            );
            cancel_order(data, send_request);
        }
        (Some(data), None) => {
            info!("cancel order {} because index price expired", data.order_id,);
            cancel_order(data, send_request);
        }
        (Some(data), Some(price)) => {
            if data.price != price {
                let edit_result = send_request!(
                    send_request,
                    Edit,
                    EditRequest {
                        order_id: data.order_id.clone(),
                        price: Some(price),
                        index_price: None,
                    }
                );
                match edit_result {
                    Ok(_) => {
                        data.price = price;
                    }
                    Err(e) => {
                        error!("price update failed: {}", e);
                        let cancel_result = send_request!(
                            send_request,
                            Cancel,
                            CancelRequest {
                                order_id: data.order_id.clone(),
                            }
                        );
                        if let Err(e) = cancel_result {
                            error!("cancelling request failed: {}", e);
                        }
                        *own = None;
                    }
                }
            }
        }
        // Index price is not known
        (None, None) => {}
        // Amount is not enough to submit
        (None, Some(_)) => {}
    }
}

fn worker(params: Params, to_rx: Receiver<To>, from_tx: Sender<From>) {
    assert!(
        params.bitcoin_amount_min.to_bitcoin() >= MIN_BITCOIN_AMOUNT,
        "bitcoin_amount_min can't be less than {}",
        MIN_BITCOIN_AMOUNT
    );
    assert!(params.bitcoin_amount_submit >= params.bitcoin_amount_min);
    assert!(params.bitcoin_amount_submit <= params.bitcoin_amount_max);

    assert!(params.interest_sign > 1.0);
    assert!(params.interest_submit > params.interest_sign);
    assert!(params.interest_submit < 1.1);

    let (ws_tx, ws_rx) = ws::start(
        params.server_host.clone(),
        params.server_port,
        params.server_use_tls,
    );

    let (msg_tx, msg_rx) = std::sync::mpsc::channel::<Msg>();

    let msg_tx_copy = msg_tx.clone();
    std::thread::spawn(move || {
        for to in to_rx {
            msg_tx_copy.send(Msg::To(to)).unwrap();
        }
    });

    let (resp_tx, resp_rx) = std::sync::mpsc::channel::<Result<Response, Error>>();

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
                ws::WrappedResponse::Response(ResponseMessage::Response(_, response)) => {
                    resp_tx.send(response).unwrap()
                }
                ws::WrappedResponse::Response(ResponseMessage::Notification(msg)) => {
                    msg_tx_copy.send(Msg::Notification(msg)).unwrap();
                }
            }
        }
    });

    let msg_tx_copy = msg_tx.clone();
    std::thread::spawn(move || loop {
        msg_tx_copy.send(Msg::Timer).unwrap();
        std::thread::sleep(std::time::Duration::from_secs(1));
    });

    let send_request = |request: Request| -> Result<Response, Error> {
        let request_id = sideswap_common::ws::next_request_id();
        ws_tx
            .send(ws::WrappedRequest::Request(RequestMessage::Request(
                request_id, request,
            )))
            .unwrap();
        resp_rx
            .recv_timeout(SERVER_REQUEST_TIMEOUT)
            .expect("request timeout")
    };

    let rpc_http_client = reqwest::blocking::Client::builder()
        .timeout(std::time::Duration::from_secs(5))
        .build()
        .expect("http client construction failed");

    let mut assets = Vec::new();
    let mut server_connected = false;
    let mut utxos = Utxos::new();
    let mut orders = BTreeMap::new();
    let mut taken_orders = BTreeSet::<OrderId>::new();
    let mut all_balances = AllBalances::default();
    let mut index_prices = IndexPrices::new();
    let mut pending_signs = BTreeMap::<OrderId, Details>::new();
    let mut own_orders = BTreeMap::<OwnOrderKey, Option<OwnOrder>>::new();
    let mut wallet_balance = None;

    for &ticker in params.tickers.iter() {
        for &send_bitcoins in [false, true].iter() {
            let key = OwnOrderKey {
                ticker,
                send_bitcoins,
            };
            own_orders.insert(key, None);
        }
    }

    loop {
        let msg = msg_rx.recv().unwrap();
        match msg {
            Msg::Connected => {
                assets = send_request!(
                    send_request,
                    Assets,
                    Some(AssetsRequestParam {
                        embedded_icons: false,
                    })
                )
                .expect("loading assets failed")
                .assets;

                let login_resp =
                    send_request!(send_request, Login, LoginRequest { session_id: None })
                        .expect("subscribing to order list failed");
                assert!(login_resp.orders.is_empty());
                orders.clear();
                for asset in assets.iter().filter(|asset| {
                    params
                        .tickers
                        .iter()
                        .find(|ticker| ticker.0 == asset.ticker.0)
                        .is_some()
                }) {
                    let subscribe_resp = send_request!(
                        send_request,
                        Subscribe,
                        SubscribeRequest {
                            asset: asset.asset_id.clone()
                        }
                    )
                    .expect("subscribing to order list failed");
                    for order in subscribe_resp.orders {
                        orders.insert(order.order_id.clone(), order);
                    }
                }

                server_connected = true;

                msg_tx.send(Msg::ReloadUtxo).unwrap();
            }

            Msg::Disconnected => {
                server_connected = false;
                orders.clear();
                taken_orders.clear();
            }

            Msg::Notification(msg) => match msg {
                Notification::OrderCreated(order) if order.own.is_none() => {
                    orders.insert(order.order_id.clone(), order);
                    msg_tx.send(Msg::Timer).unwrap();
                }

                Notification::OrderRemoved(order) => {
                    orders.remove(&order.order_id);
                }

                Notification::Sign(order) => {
                    debug!("sign notification received, order_id: {}", &order.order_id);
                    // TODO: Verify PSET
                    let result = take_order(
                        &params,
                        &assets,
                        &order.details,
                        &all_balances,
                        &index_prices,
                        params.interest_sign,
                    );
                    match result {
                        Ok(_) => {
                            let result = rpc::make_rpc_call::<rpc::WalletSignPsbt>(
                                &rpc_http_client,
                                &params.rpc,
                                &rpc::wallet_sign_psbt(&order.pset),
                            )
                            .expect("signing PSBT failed");
                            send_request!(
                                send_request,
                                Sign,
                                SignRequest {
                                    order_id: order.order_id.clone(),
                                    signed_pset: result.psbt,
                                    side: order.details.side,
                                }
                            )
                            .expect("sending signed PSBT failed");
                            pending_signs.insert(order.order_id, order.details);
                        }
                        Err(e) => error!(
                            "sign request ignored: {}, order_id: {}, details: {:?}",
                            e, order.order_id, order.details
                        ),
                    }
                }

                Notification::Complete(msg) => {
                    for own in own_orders.values_mut() {
                        if own.as_ref().map(|own| &own.order_id) == Some(&msg.order_id) {
                            *own = None;
                        }
                    }

                    let details = pending_signs.remove(&msg.order_id);
                    match msg.txid {
                        Some(txid) => {
                            info!("order {} complete succesfully", msg.order_id);
                            let details = details.expect("details must exists");
                            let asset = assets
                                .iter()
                                .find(|asset| asset.asset_id == details.asset)
                                .unwrap();
                            let ticker = ticker_from_asset(asset).unwrap();
                            let send_bitcoins = details.send_bitcoins;
                            let bitcoin_amount = Amount::from_sat(if send_bitcoins {
                                details.bitcoin_amount + details.server_fee
                            } else {
                                details.bitcoin_amount - details.server_fee
                            });
                            let swap_succeed = SwapSucceed {
                                txid,
                                ticker,
                                bitcoin_amount,
                                send_bitcoins,
                            };
                            from_tx.send(From::Swap(swap_succeed)).unwrap();
                        }
                        None => info!("order {} complete unsuccesfully", msg.order_id),
                    };
                }

                _ => {}
            },

            Msg::ReloadUtxo => {
                let unspent_with_zc = rpc::make_rpc_call::<rpc::ListUnspent>(
                    &rpc_http_client,
                    &params.rpc,
                    &rpc::listunspent(0),
                )
                .expect("list_unspent failed");

                let mut asset_amounts = BTreeMap::<&str, f64>::new();
                for item in unspent_with_zc.iter() {
                    let asset_amount = asset_amounts.entry(&item.asset).or_default();
                    *asset_amount += Amount::from_rpc(&item.amount).to_bitcoin();
                }

                let wallet_balances_new = assets
                    .iter()
                    .flat_map(|asset| {
                        asset_amounts
                            .get(asset.asset_id.0.as_str())
                            .map(|balance| (asset, *balance))
                    })
                    .flat_map(|(asset, balance)| {
                        ticker_from_asset(asset).map(|ticker| (ticker, balance))
                    })
                    .collect::<BTreeMap<_, _>>();

                if all_balances.wallet != wallet_balances_new {
                    all_balances.wallet = wallet_balances_new;
                }

                let old_keys: BTreeSet<_> = utxos.keys().cloned().collect();
                let new_keys: BTreeSet<_> =
                    unspent_with_zc.iter().map(|item| item.tx_out()).collect();
                for item in unspent_with_zc {
                    utxos.entry(item.tx_out()).or_insert_with(|| {
                        debug!(
                            "add new utxo: {}/{}, asset: {}, amount: {}",
                            &item.txid, item.vout, item.asset, item.amount
                        );
                        Utxo {
                            amount: Amount::from_rpc(&item.amount).to_sat(),
                            item,
                            reserve: None,
                        }
                    });
                }
                for key in old_keys.difference(&new_keys) {
                    debug!("remove consumed utxo: {}/{}", &key.txid, key.vout);
                    utxos.remove(&key);
                }
            }

            Msg::To(to) => match to {
                To::Price(ToPrice { ticker, price }) => {
                    match price {
                        Some(v) => index_prices.insert(
                            ticker,
                            PriceTimestamp {
                                price: v,
                                timestamp: std::time::Instant::now(),
                            },
                        ),
                        None => index_prices.remove(&ticker),
                    };
                    msg_tx.send(Msg::Timer).unwrap();
                }
                To::LimitBalance(msg) => {
                    if msg.recv_limit {
                        all_balances.max_recv.insert(msg.ticker, msg.balance);
                    } else {
                        all_balances.max_send.insert(msg.ticker, msg.balance);
                    }
                    msg_tx.send(Msg::Timer).unwrap();
                }
                To::ResetPrices(_) => {
                    index_prices.clear();
                }
            },

            Msg::Timer => {
                if server_connected {
                    for (key, own) in own_orders.iter_mut() {
                        update_price(
                            own,
                            key.send_bitcoins,
                            &assets,
                            key.ticker,
                            &index_prices,
                            &all_balances,
                            &utxos,
                            &params,
                            &rpc_http_client,
                            &send_request,
                        );
                    }
                }

                for order in orders.values() {
                    if taken_orders.get(&order.order_id).is_some() {
                        continue;
                    }
                    let result = take_order(
                        &params,
                        &assets,
                        &order.details,
                        &all_balances,
                        &index_prices,
                        params.interest_submit,
                    );
                    if result.is_ok() {
                        info!("take order: {:?}", order);
                        let result = get_pset(
                            &order.order_id,
                            &order.details,
                            &utxos,
                            &params,
                            &rpc_http_client,
                            false,
                        );
                        match result {
                            Ok(addr_details) => {
                                let addr_result = send_request!(send_request, Addr, addr_details);
                                if let Err(e) = addr_result {
                                    error!("sending addr details failed: {}", e);
                                } else {
                                    taken_orders.insert(order.order_id.clone());
                                }
                            }
                            Err(e) => error!("sending quote failed: {}", e),
                        }
                    }
                }

                let wallet_result = rpc::make_rpc_call::<rpc::GetWalletInfo>(
                    &rpc_http_client,
                    &params.rpc,
                    &rpc::get_wallet_info(),
                );
                match wallet_result {
                    Ok(v) => {
                        if wallet_balance.as_ref() != Some(&v) {
                            wallet_balance = Some(v);
                            msg_tx.send(Msg::ReloadUtxo).unwrap();
                            from_tx.send(From::WalletBalanceUpdated(None)).unwrap();
                        }
                    }
                    Err(e) => error!("wallet balance loading failed: {}", e),
                }

                let now = std::time::Instant::now();
                let expired = index_prices
                    .iter()
                    .filter(|(_, price)| now.duration_since(price.timestamp) > PRICE_EXPIRATON_TIME)
                    .map(|(ticker, _)| *ticker)
                    .collect::<Vec<_>>();
                for ticker in expired {
                    warn!("remove expired ticker: {}", ticker.0);
                    index_prices.remove(&ticker);
                }
            }
        }
    }
}

pub fn start(params: Params) -> (Sender<To>, Receiver<From>) {
    let (from_tx, from_rx) = std::sync::mpsc::channel::<From>();
    let (to_tx, to_rx) = std::sync::mpsc::channel::<To>();

    std::thread::spawn(move || {
        worker(params, to_rx, from_tx);
    });

    (to_tx, from_rx)
}
