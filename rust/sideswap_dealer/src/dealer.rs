use super::rpc;
use base64::Engine;
use serde::{Deserialize, Serialize};
use sideswap_api::*;
use sideswap_common::types::{Amount, TxOut};
use sideswap_common::{types, ws};
use std::collections::{BTreeMap, BTreeSet};
use std::str::FromStr;

// Extra asset UTXO amount to cover future price edits
const EXTRA_ASSET_UTXO_FRACTION: f64 = 0.03;

// Recreated order if bitcoin amount increase to more than that value
// (for example if wallet balance increase).
const RECREATE_ORDER_AMOUNT_FRACTION: f64 = 0.05;

const MIN_BITCOIN_AMOUNT: f64 = 0.0001;

const PRICE_EXPIRATON_TIME: std::time::Duration = std::time::Duration::from_secs(60);

const PRICE_EDIT_MIN_DELAY: std::time::Duration = std::time::Duration::from_secs(5);

#[derive(Debug, Clone)]
pub struct Params {
    pub env: sideswap_common::env::Env,

    pub server_host: String,
    pub server_port: u16,
    pub server_use_tls: bool,

    pub rpc: rpc::RpcServer,

    pub interest_submit_usdt: f64,
    pub interest_sign_usdt: f64,
    pub interest_submit_eurx: f64,
    pub interest_sign_eurx: f64,

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
    pub txid: elements::Txid,
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

const SERVER_REQUEST_TIMEOUT: std::time::Duration = std::time::Duration::from_secs(30);

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
        ticker_from_string(&name).map_err(serde::de::Error::custom)
    }
}

pub fn apply_interest(price: PricePair, interest: f64) -> PricePair {
    // Limit to 10% as sanity check
    assert!((1.0..=1.1).contains(&interest));
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
) -> Result<PsetMakerRequest, anyhow::Error> {
    let env_data = params.env.data();
    let bitcoin_asset = AssetId::from_str(env_data.policy_asset).unwrap();
    let (send_asset, send_amount) = if details.send_bitcoins {
        (bitcoin_asset, details.bitcoin_amount + details.server_fee)
    } else {
        (details.asset, details.asset_amount)
    };

    let mut asset_utxos: Vec<_> = utxos
        .values()
        .filter(|utxo| {
            utxo.item.asset == send_asset
                && utxo.item.amountblinder.is_some()
                && utxo.item.assetblinder.is_some()
        })
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

    let mut inputs = Vec::<PsetInput>::new();

    for amount in selected {
        let index = asset_utxos
            .iter()
            .position(|v| v.amount == amount)
            .expect("utxo must exists");
        let utxo = asset_utxos.swap_remove(index);

        let asset_bf = utxo.item.assetblinder.unwrap();
        let value_bf = utxo.item.amountblinder.unwrap();
        inputs.push(PsetInput {
            txid: utxo.item.txid,
            vout: utxo.item.vout,
            asset: send_asset,
            asset_bf,
            value: amount as u64,
            value_bf,
            redeem_script: utxo.item.redeem_script.clone(),
        });
    }

    let recv_addr =
        rpc::make_rpc_call::<elements::Address>(http_client, &params.rpc, &rpc::get_new_address())
            .expect("getting new address failed");
    let change_addr =
        rpc::make_rpc_call::<elements::Address>(http_client, &params.rpc, &rpc::get_new_address())
            .expect("getting new address failed");

    let addr_request = PsetMakerRequest {
        order_id: *order_id,
        price: details.price,
        private: false,
        ttl_seconds: None,
        inputs,
        recv_addr,
        change_addr,
        signed_half: None,
    };
    Ok(addr_request)
}

fn sign_pset(
    secp: &elements::secp256k1_zkp::Secp256k1<elements::secp256k1_zkp::All>,
    data: &SignNotification,
    params: &Params,
    utxos: &Utxos,
    http_client: &reqwest::blocking::Client,
) -> Result<SignRequest, anyhow::Error> {
    let mut pset = elements::encode::deserialize::<elements::pset::PartiallySignedTransaction>(
        &base64::engine::general_purpose::STANDARD.decode(&data.pset)?,
    )?;
    let tx = pset.extract_tx()?;

    for (index, input) in tx.input.iter().enumerate() {
        let tx_out = TxOut {
            txid: elements::Txid::from_str(&input.previous_output.txid.to_string()).unwrap(),
            vout: input.previous_output.vout,
        };
        if let Some(utxo) = utxos.get(&tx_out) {
            let priv_key = rpc::make_rpc_call::<rpc::DumpPrivKey>(
                http_client,
                &params.rpc,
                &rpc::dumpprivkey(&utxo.item.address),
            )?;
            let private_key = elements::bitcoin::PrivateKey::from_str(&priv_key)?;

            let value_commitment =
                hex::decode(utxo.item.amountcommitment.as_ref().unwrap()).unwrap();
            let value_commitment =
                elements::encode::deserialize::<elements::confidential::Value>(&value_commitment)
                    .unwrap();

            let input_sign = sideswap_common::pset::internal_sign_elements(
                secp,
                &tx,
                index,
                &private_key,
                value_commitment,
                elements::EcdsaSigHashType::All,
            );
            let public_key = private_key.public_key(secp);
            let pset_input = pset.inputs_mut().get_mut(index).unwrap();
            pset_input.final_script_sig = utxo.item.redeem_script.as_ref().map(|script| {
                elements::script::Builder::new()
                    .push_slice(script.as_bytes())
                    .into_script()
            });
            pset_input.final_script_witness = Some(vec![input_sign, public_key.to_bytes()]);
        }
    }

    let pset = elements::encode::serialize(&pset);
    let sign_request = SignRequest {
        order_id: data.order_id,
        signed_pset: base64::engine::general_purpose::STANDARD.encode(pset),
        side: data.details.side,
    };
    Ok(sign_request)
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
            order_id: data.order_id,
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
    let interest_submit = match ticker {
        DEALER_USDT => params.interest_submit_usdt,
        DEALER_EURX => params.interest_submit_eurx,
        _ => panic!("unexpected asset"),
    };
    let interest_take_ajusted = interest_submit
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
                        asset: asset.asset_id,
                        bitcoin_amount: Some(if send_bitcoins {
                            -new_bitcoin_amount_normal.to_bitcoin()
                        } else {
                            new_bitcoin_amount_normal.to_bitcoin()
                        }),
                        asset_amount: None,
                        price: Some(price),
                        index_price: None,
                    },
                }
            );
            if let Ok(submit_resp) = submit_result {
                let pset = get_pset(
                    &submit_resp.order_id,
                    &submit_resp.details,
                    utxos,
                    params,
                    http_client,
                    true,
                );
                match pset {
                    Ok(pset_maker_req) => {
                        let addr_result = send_request!(send_request, PsetMaker, pset_maker_req);
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
                        order_id: data.order_id,
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
                                order_id: data.order_id,
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

fn worker(
    params: Params,
    to_rx: crossbeam_channel::Receiver<To>,
    from_tx: crossbeam_channel::Sender<From>,
) {
    assert!(
        params.bitcoin_amount_min.to_bitcoin() >= MIN_BITCOIN_AMOUNT,
        "bitcoin_amount_min can't be less than {}",
        MIN_BITCOIN_AMOUNT
    );
    assert!(params.bitcoin_amount_submit >= params.bitcoin_amount_min);
    assert!(params.bitcoin_amount_submit <= params.bitcoin_amount_max);

    assert!(params.interest_sign_usdt > 1.0);
    assert!(params.interest_submit_usdt > params.interest_sign_usdt);
    assert!(params.interest_submit_usdt < 1.1);

    assert!(params.interest_sign_eurx > 1.0);
    assert!(params.interest_submit_eurx > params.interest_sign_eurx);
    assert!(params.interest_submit_eurx < 1.1);

    let asset_usdt = AssetId::from_str(params.env.data().network.usdt_asset_id()).unwrap();
    let asset_eurx = AssetId::from_str(params.env.data().network.eurx_asset_id()).unwrap();

    let (ws_tx, ws_rx) = sideswap_common::ws::auto::start(
        params.server_host.clone(),
        params.server_port,
        params.server_use_tls,
    );

    let (msg_tx, msg_rx) = crossbeam_channel::unbounded::<Msg>();

    let msg_tx_copy = msg_tx.clone();
    std::thread::spawn(move || {
        for to in to_rx {
            msg_tx_copy.send(Msg::To(to)).unwrap();
        }
    });

    let (resp_tx, resp_rx) = crossbeam_channel::unbounded::<Result<Response, Error>>();

    let msg_tx_copy = msg_tx.clone();
    std::thread::spawn(move || {
        for msg in ws_rx {
            match msg {
                ws::auto::WrappedResponse::Connected => {
                    msg_tx_copy.send(Msg::Connected).unwrap();
                }
                ws::auto::WrappedResponse::Disconnected => {
                    msg_tx_copy.send(Msg::Disconnected).unwrap();
                }
                ws::auto::WrappedResponse::Response(ResponseMessage::Response(_, response)) => {
                    resp_tx.send(response).unwrap()
                }
                ws::auto::WrappedResponse::Response(ResponseMessage::Notification(msg)) => {
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
            .send(ws::auto::WrappedRequest::Request(RequestMessage::Request(
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

    let secp = elements::secp256k1_zkp::Secp256k1::new();
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
    let mut last_price_edit = std::time::Instant::now();

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
                        embedded_icons: Some(false),
                        all_assets: Some(true),
                    })
                )
                .expect("loading assets failed")
                .assets;

                let login_resp =
                    send_request!(send_request, Login, LoginRequest { session_id: None })
                        .expect("subscribing to order list failed");
                assert!(login_resp.orders.is_empty());
                for asset in assets.iter().filter(|asset| {
                    params
                        .tickers
                        .iter()
                        .any(|ticker| ticker.0 == asset.ticker.0)
                }) {
                    let subscribe_resp = send_request!(
                        send_request,
                        Subscribe,
                        SubscribeRequest {
                            asset: Some(asset.asset_id),
                        }
                    )
                    .expect("subscribing to order list failed");
                    for order in subscribe_resp.orders {
                        orders.insert(order.order_id, order);
                    }
                }

                server_connected = true;

                msg_tx.send(Msg::ReloadUtxo).unwrap();
            }

            Msg::Disconnected => {
                server_connected = false;
                orders.clear();
                taken_orders.clear();
                for own_order in own_orders.values_mut() {
                    *own_order = None;
                }
            }

            Msg::Notification(msg) => match msg {
                Notification::OrderCreated(order) if order.own.is_none() => {
                    orders.insert(order.order_id, order);
                    msg_tx.send(Msg::Timer).unwrap();
                }

                Notification::OrderRemoved(order) => {
                    orders.remove(&order.order_id);
                }

                Notification::Sign(order) => {
                    debug!("sign notification received, order_id: {}", &order.order_id);
                    let interest_sign = if order.details.asset == asset_usdt {
                        params.interest_sign_usdt
                    } else if order.details.asset == asset_eurx {
                        params.interest_sign_eurx
                    } else {
                        panic!("unexpected asset");
                    };

                    // TODO: Verify PSET
                    let result = take_order(
                        &params,
                        &assets,
                        &order.details,
                        &all_balances,
                        &index_prices,
                        interest_sign,
                    );
                    match result {
                        Ok(_) => {
                            let result =
                                sign_pset(&secp, &order, &params, &utxos, &rpc_http_client)
                                    .unwrap();
                            send_request!(send_request, Sign, result)
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

                let mut asset_amounts = BTreeMap::<AssetId, f64>::new();
                for item in unspent_with_zc.iter() {
                    let asset_amount = asset_amounts.entry(item.asset).or_default();
                    *asset_amount += Amount::from_rpc(&item.amount).to_bitcoin();
                }

                let wallet_balances_new = assets
                    .iter()
                    .flat_map(|asset| {
                        asset_amounts
                            .get(&asset.asset_id)
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
                        }
                    });
                }
                for key in old_keys.difference(&new_keys) {
                    debug!("remove consumed utxo: {}/{}", &key.txid, key.vout);
                    utxos.remove(key);
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
                let now = std::time::Instant::now();
                if server_connected && now.duration_since(last_price_edit) >= PRICE_EDIT_MIN_DELAY {
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
                    last_price_edit = now;
                }

                for order in orders.values() {
                    if taken_orders.get(&order.order_id).is_some() {
                        continue;
                    }

                    let interest_submit = if order.details.asset == asset_usdt {
                        params.interest_submit_usdt
                    } else if order.details.asset == asset_eurx {
                        params.interest_submit_eurx
                    } else {
                        panic!("unexpected asset");
                    };

                    let result = take_order(
                        &params,
                        &assets,
                        &order.details,
                        &all_balances,
                        &index_prices,
                        interest_submit,
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
                            Ok(pset_req) => {
                                let taker_pset_req = PsetTakerRequest {
                                    order_id: pset_req.order_id,
                                    price: pset_req.price,
                                    inputs: pset_req.inputs,
                                    recv_addr: pset_req.recv_addr,
                                    change_addr: pset_req.change_addr,
                                };
                                let addr_result =
                                    send_request!(send_request, PsetTaker, taker_pset_req);
                                if let Err(e) = addr_result {
                                    error!("sending addr details failed: {}", e);
                                } else {
                                    taken_orders.insert(order.order_id);
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

pub fn start(
    params: Params,
) -> (
    crossbeam_channel::Sender<To>,
    crossbeam_channel::Receiver<From>,
) {
    let (from_tx, from_rx) = crossbeam_channel::unbounded::<From>();
    let (to_tx, to_rx) = crossbeam_channel::unbounded::<To>();

    std::thread::spawn(move || {
        worker(params, to_rx, from_tx);
    });

    (to_tx, from_rx)
}
