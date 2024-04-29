use super::rpc;
use base64::Engine;
use serde::{Deserialize, Serialize};
use sideswap_api::*;
use sideswap_common::types::{Amount, TxOut};
use sideswap_common::{types, ws};
use std::collections::{BTreeMap, BTreeSet};
use std::str::FromStr;

// Keep some extra amount in the wallet for the various fees (server, network, external exchange)
const INSTANT_SWAP_WORK_AMOUNT: f64 = 0.995;

// Extra asset UTXO amount to cover future price edits
const EXTRA_ASSET_UTXO_FRACTION: f64 = 0.03;

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

    pub tickers: BTreeSet<DealerTicker>,

    pub bitcoin_amount_submit: Amount,
    pub bitcoin_amount_min: Amount,
    pub bitcoin_amount_max: Amount,

    pub api_key: Option<String>,
}

#[derive(Serialize, Deserialize, Debug, Clone, Copy, PartialEq)]
pub struct DealerPrice {
    /// Instant and regular submit swaps
    pub submit_price: PricePair,

    /// Maximum amount of LBTC the dealer is allowed to receive to own wallet (in one swap)
    pub limit_btc_dealer_recv: f64,

    /// Maximum amount of LBTC the dealer is allowed to send from own wallet (in one swap)
    pub limit_btc_dealer_send: f64,

    /// Instant swaps balancing flag to let users know
    pub balancing: bool,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ToPrice {
    pub ticker: DealerTicker,
    pub price: Option<DealerPrice>,
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
    ResetPrices(Empty),
    IndexPriceUpdate(PriceUpdateBroadcast),
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "snake_case")]
pub enum From {
    Swap(SwapSucceed),
    ServerConnected(Empty),
    ServerDisconnected(Empty),
    Utxos(rpc::ListUnspent),
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SwapSucceed {
    pub txid: elements::Txid,
    pub ticker: DealerTicker,
    pub bitcoin_amount: sideswap_common::types::Amount,
    pub dealer_send_bitcoins: bool,
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
pub type DealerPrices = BTreeMap<DealerTicker, DealerPriceTimestamp>;

#[derive(Clone, Copy, PartialEq, Debug)]
pub struct DealerPriceTimestamp {
    pub dealer: DealerPrice,
    pub timestamp: std::time::Instant,
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
pub enum DealerTicker {
    LBTC,
    USDt,
    EURx,
    MEX,
    DePIX,
}

pub fn get_dealer_asset_id(
    known_assets: &sideswap_common::env::KnownAssetIds,
    ticker: DealerTicker,
) -> elements::AssetId {
    match ticker {
        DealerTicker::LBTC => known_assets.bitcoin,
        DealerTicker::USDt => known_assets.usdt,
        DealerTicker::EURx => known_assets.eurx,
        DealerTicker::MEX => known_assets.mex,
        DealerTicker::DePIX => known_assets.depix,
    }
}

macro_rules! send_request {
    ($f:ident, $t:ident, $value:expr) => {
        match $f(Request::$t($value)) {
            Ok(Response::$t(value)) => Ok(value),
            Ok(_) => panic!("unexpected response type"),
            Err(error) => Err(error),
        }
    };
}

impl std::fmt::Display for DealerTicker {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        dealer_ticker_to_asset_ticker(*self).fmt(f)
    }
}

pub fn dealer_ticker_to_asset_ticker(dealer_ticker: DealerTicker) -> &'static str {
    match dealer_ticker {
        DealerTicker::LBTC => TICKER_LBTC,
        DealerTicker::USDt => TICKER_USDT,
        DealerTicker::EURx => TICKER_EURX,
        DealerTicker::MEX => TICKER_MEX,
        DealerTicker::DePIX => TICKER_DEPIX,
    }
}

pub fn dealer_ticker_from_asset_ticker(ticker: &str) -> Option<DealerTicker> {
    let ticker = match ticker {
        TICKER_LBTC => DealerTicker::LBTC,
        TICKER_USDT => DealerTicker::USDt,
        TICKER_EURX => DealerTicker::EURx,
        TICKER_DEPIX => DealerTicker::DePIX,
        _ => return None,
    };
    Some(ticker)
}

pub fn dealer_ticker_from_asset(asset: &Asset) -> Option<DealerTicker> {
    dealer_ticker_from_asset_ticker(&asset.ticker.0)
}

impl<'de> Deserialize<'de> for DealerTicker {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: serde::Deserializer<'de>,
    {
        let name = String::deserialize(deserializer)?;
        dealer_ticker_from_asset_ticker(&name)
            .ok_or_else(|| serde::de::Error::custom(anyhow!("unknown ticker {name}")))
    }
}

pub fn apply_interest(price: &PricePair, interest: f64) -> PricePair {
    // Limit to 10% as sanity check
    assert!((1.0..=1.1).contains(&interest));
    PricePair {
        bid: price.bid / interest,
        ask: price.ask * interest,
    }
}

pub fn pick_price(price: &PricePair, send_bitcoins: bool) -> f64 {
    if send_bitcoins {
        price.ask
    } else {
        price.bid
    }
}

fn take_order(
    params: &Params,
    assets: &Assets,
    details: &Details,
    wallet_balances: &WalletBalances,
    dealer_prices: &DealerPrices,
) -> Result<(), anyhow::Error> {
    ensure!(details.bitcoin_amount >= params.bitcoin_amount_min.to_sat());
    ensure!(details.bitcoin_amount <= params.bitcoin_amount_max.to_sat());
    let asset = assets
        .iter()
        .find(|asset| asset.asset_id == details.asset)
        .unwrap();
    let ticker =
        dealer_ticker_from_asset(asset).ok_or_else(|| anyhow!("unknown asset {}", asset.name))?;
    let dealer_price = dealer_prices
        .get(&ticker)
        .cloned()
        .ok_or(anyhow!("dealer price for {ticker:?} is not known"))?;
    let actual_bitcoin_amount = Amount::from_sat(if details.send_bitcoins {
        details.bitcoin_amount + details.server_fee
    } else {
        details.bitcoin_amount - details.server_fee
    });
    let asset_amount = types::asset_float_amount(details.asset_amount, asset.precision);
    let actual_price = asset_amount / actual_bitcoin_amount.to_bitcoin();
    assert!(actual_price > 0.0);
    let bitcoin_amount_max = get_bitcoin_amount(
        asset,
        wallet_balances,
        ticker,
        actual_price,
        details.send_bitcoins,
    );
    if details.send_bitcoins {
        ensure!(
            actual_price >= dealer_price.dealer.submit_price.ask,
            "actual_price: {}, dealer_price.ask: {}",
            actual_price,
            dealer_price.dealer.submit_price.ask
        );
        ensure!(actual_bitcoin_amount.to_bitcoin() <= dealer_price.dealer.limit_btc_dealer_send);
    } else {
        ensure!(
            actual_price <= dealer_price.dealer.submit_price.bid,
            "actual_price: {}, dealer_price.bid: {}",
            actual_price,
            dealer_price.dealer.submit_price.bid
        );
        ensure!(actual_bitcoin_amount.to_bitcoin() <= dealer_price.dealer.limit_btc_dealer_recv);
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
    http_client: &ureq::Agent,
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

    let recv_addr = rpc::make_rpc_call(http_client, &params.rpc, rpc::GetNewAddressCall {})
        .expect("getting new address failed");
    let change_addr = rpc::make_rpc_call(http_client, &params.rpc, rpc::GetNewAddressCall {})
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
    http_client: &ureq::Agent,
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
            let private_key = rpc::make_rpc_call(
                http_client,
                &params.rpc,
                rpc::DumpPrivKeyCall {
                    address: utxo.item.address.clone(),
                },
            )?;

            let value_commitment = utxo.item.amountcommitment.clone().unwrap().into_inner();

            let input_sign = sideswap_common::pset::internal_sign_elements(
                secp,
                &tx,
                index,
                &private_key,
                value_commitment,
                elements::EcdsaSighashType::All,
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

fn get_bitcoin_amount(
    asset: &Asset,
    wallet_balances: &WalletBalances,
    ticker: DealerTicker,
    price: f64,
    send_bitcoins: bool,
) -> Amount {
    let wallet_asset = wallet_balances.get(&ticker).cloned().unwrap_or_default();
    let wallet_bitcoin = wallet_balances
        .get(&DealerTicker::LBTC)
        .cloned()
        .unwrap_or_default()
        / (1.0 + asset.server_fee().value());
    if send_bitcoins {
        Amount::from_bitcoin(wallet_bitcoin)
    } else {
        Amount::from_bitcoin(wallet_asset / price)
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
    index_prices: &DealerPrices,
    wallet_balances: &WalletBalances,
    utxos: &Utxos,
    params: &Params,
    http_client: &ureq::Agent,
    send_request: &T,
) {
    let dealer_ticker = dealer_ticker_to_asset_ticker(ticker);
    let asset = assets
        .iter()
        .find(|asset| asset.ticker.0 == dealer_ticker)
        .unwrap();
    let price_with_limits = index_prices.get(&ticker).cloned();
    let server_fee = Amount::from_bitcoin(f64::max(
        asset.server_fee().value() * params.bitcoin_amount_submit.to_bitcoin(),
        types::SWAP_MARKETS_MIN_SERVER_FEE.to_bitcoin(),
    ));
    let server_fee_interest =
        1.0 + server_fee.to_bitcoin() / params.bitcoin_amount_submit.to_bitcoin();

    let price = price_with_limits.map(|price| {
        pick_price(
            &apply_interest(&price.dealer.submit_price, server_fee_interest),
            send_bitcoins,
        )
    });

    let bitcoin_amount_limit_external = price_with_limits
        .map(|price| {
            if send_bitcoins {
                price.dealer.limit_btc_dealer_send
            } else {
                price.dealer.limit_btc_dealer_recv
            }
        })
        .unwrap_or_default();
    let bitcoin_amount_limit_wallet = price
        .map(|price| get_bitcoin_amount(asset, wallet_balances, ticker, price, send_bitcoins))
        .unwrap_or_default()
        .to_bitcoin();
    let bitcoin_amount_limit = bitcoin_amount_limit_wallet.min(bitcoin_amount_limit_external);
    let order_allowed = params.bitcoin_amount_submit.to_bitcoin() <= bitcoin_amount_limit;

    match (own.as_mut(), price) {
        (None, Some(price)) if order_allowed => {
            let submit_result = send_request!(
                send_request,
                Submit,
                SubmitRequest {
                    order: PriceOrder {
                        asset: asset.asset_id,
                        bitcoin_amount: Some(if send_bitcoins {
                            -params.bitcoin_amount_submit.to_bitcoin()
                        } else {
                            params.bitcoin_amount_submit.to_bitcoin()
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
                                    bitcoin_amount: params.bitcoin_amount_submit,
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
        // Amount is not enough or index price is not known, do nothing
        (None, _) => {}

        (Some(data), _) if !order_allowed => {
            info!("cancel order {}, submit is not allowed", data.order_id,);
            cancel_order(data, send_request);
        }
        (Some(data), None) => {
            info!("cancel order {} because index price expired", data.order_id);
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
    }
}

struct InstantSwap {
    send_asset: AssetId,
}

fn worker(
    params: Params,
    to_rx: crossbeam_channel::Receiver<To>,
    from_tx: crossbeam_channel::Sender<From>,
) -> ! {
    assert!(
        params.bitcoin_amount_min.to_bitcoin() >= MIN_BITCOIN_AMOUNT,
        "bitcoin_amount_min can't be less than {}",
        MIN_BITCOIN_AMOUNT
    );
    assert!(params.bitcoin_amount_submit >= params.bitcoin_amount_min);
    assert!(params.bitcoin_amount_submit <= params.bitcoin_amount_max);

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

    let rpc_http_client = ureq::AgentBuilder::new()
        .timeout(std::time::Duration::from_secs(20))
        .build();

    let bitcoin_asset = AssetId::from_str(params.env.data().policy_asset).unwrap();

    let secp = elements::secp256k1_zkp::Secp256k1::new();
    let mut assets = Vec::new();
    let mut server_connected = false;
    let mut utxos = Utxos::new();
    let mut orders = BTreeMap::new();
    let mut taken_orders = BTreeSet::<OrderId>::new();
    let mut wallet_balances = WalletBalances::default();
    let mut dealer_prices = DealerPrices::new();
    let mut pending_signs = BTreeMap::<OrderId, Details>::new();
    let mut own_orders = BTreeMap::<OwnOrderKey, Option<OwnOrder>>::new();
    let mut wallet_balance = None;
    let mut last_price_edit = std::time::Instant::now();
    let mut instant_swaps: BTreeMap<OrderId, InstantSwap> = BTreeMap::new();

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

                from_tx.send(From::ServerConnected(None)).unwrap();

                let login_resp =
                    send_request!(send_request, Login, LoginRequest { session_id: None })
                        .expect("subscribing to order list failed");
                assert!(login_resp.orders.is_empty());
                for asset in assets.iter().filter(|asset| {
                    dealer_ticker_from_asset(asset)
                        .map(|ticker| params.tickers.contains(&ticker))
                        .unwrap_or(false)
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

                if let Some(api_key) = &params.api_key {
                    send_request!(
                        send_request,
                        LoginDealer,
                        LoginDealerRequest {
                            api_key: api_key.to_owned(),
                        }
                    )
                    .expect("dealer login failed");
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
                from_tx.send(From::ServerDisconnected(None)).unwrap();
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

                    // TODO: Verify PSET

                    let result =
                        sign_pset(&secp, &order, &params, &utxos, &rpc_http_client).unwrap();
                    send_request!(send_request, Sign, result).expect("sending signed PSBT failed");
                    pending_signs.insert(order.order_id, order.details);
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
                            let ticker = dealer_ticker_from_asset(asset).unwrap();
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
                                dealer_send_bitcoins: send_bitcoins,
                            };
                            from_tx.send(From::Swap(swap_succeed)).unwrap();
                        }
                        None => info!("order {} complete unsuccesfully", msg.order_id),
                    };
                }

                Notification::StartSwapDealer(data) => {
                    info!("start instant swap, order_id: {}", data.order_id);
                    let inputs: Vec<_> = utxos
                        .values()
                        .filter(|utxo| {
                            utxo.item.asset == data.send_asset
                                && utxo.item.amountblinder.is_some()
                                && utxo.item.assetblinder.is_some()
                        })
                        .map(|utxo| PsetInput {
                            txid: utxo.item.txid,
                            vout: utxo.item.vout,
                            asset: utxo.item.asset,
                            asset_bf: utxo.item.assetblinder.unwrap(),
                            value: Amount::from_rpc(&utxo.item.amount).to_sat() as u64,
                            value_bf: utxo.item.amountblinder.unwrap(),
                            redeem_script: utxo.item.redeem_script.clone(),
                        })
                        .collect();

                    let recv_addr = rpc::make_rpc_call(
                        &rpc_http_client,
                        &params.rpc,
                        rpc::GetNewAddressCall {},
                    )
                    .expect("getting new address failed");
                    let change_addr = rpc::make_rpc_call(
                        &rpc_http_client,
                        &params.rpc,
                        rpc::GetNewAddressCall {},
                    )
                    .expect("getting new address failed");

                    let start_swap_dealer_resp = send_request!(
                        send_request,
                        StartSwapDealer,
                        StartSwapDealerRequest {
                            order_id: data.order_id,
                            inputs,
                            recv_addr,
                            change_addr,
                        }
                    );
                    if let Err(e) = start_swap_dealer_resp {
                        error!("starting swap failed: {}", e);
                    }

                    instant_swaps.insert(
                        data.order_id,
                        InstantSwap {
                            send_asset: data.send_asset,
                        },
                    );
                }

                Notification::BlindedSwapDealer(data) => {
                    info!("got blinded pset, order_id: {}", data.order_id);
                    let mut pset = elements::encode::deserialize::<
                        elements::pset::PartiallySignedTransaction,
                    >(
                        &base64::engine::general_purpose::STANDARD
                            .decode(&data.pset)
                            .unwrap(),
                    )
                    .expect("parsing pset failed");
                    let swap = instant_swaps.get(&data.order_id).expect("order not found");

                    let tx = pset.extract_tx().unwrap();

                    let own_inputs: BTreeMap<_, _> = utxos
                        .values()
                        .filter(|utxo| {
                            utxo.item.asset == swap.send_asset
                                && utxo.item.amountblinder.is_some()
                                && utxo.item.assetblinder.is_some()
                        })
                        .map(|utxo| {
                            (
                                TxOut {
                                    txid: utxo.item.txid,
                                    vout: utxo.item.vout,
                                },
                                utxo,
                            )
                        })
                        .collect();

                    // FIXME: Verify recv output
                    // let recv_output = tx
                    //     .output
                    //     .iter()
                    //     .filter(|output| output.script_pubkey == swap.recv_addr.script_pubkey())
                    //     .filter_map(|output| {
                    //         output.unblind(&secp, swap.recv_addr_blinding_key).ok()
                    //     })
                    //     .find(|output| {
                    //         debug!(
                    //             "unblinded recv output, amount: {}, asset: {}",
                    //             output.value, output.asset
                    //         );
                    //         output.value == swap.recv_amount as u64
                    //             && output.asset
                    //                 == elements::AssetId::from_slice(&swap.recv_asset.0)
                    //                     .unwrap()
                    //     });
                    // if recv_output.is_none() {
                    //     error!("can't find own output for swap {}", data.order_id);
                    //     continue;
                    // }
                    //assert!(recv_output.is_some());

                    for (index, input) in tx.input.iter().enumerate() {
                        let tx_out = TxOut {
                            txid: input.previous_output.txid,
                            vout: input.previous_output.vout,
                        };
                        if let Some(utxo) = own_inputs.get(&tx_out) {
                            let private_key = rpc::make_rpc_call(
                                &rpc_http_client,
                                &params.rpc,
                                rpc::DumpPrivKeyCall {
                                    address: utxo.item.address.clone(),
                                },
                            )
                            .expect("loading priv key failed");

                            let value_commitment =
                                utxo.item.amountcommitment.clone().unwrap().into_inner();
                            let input_sign = sideswap_common::pset::internal_sign_elements(
                                &secp,
                                &tx,
                                index,
                                &private_key,
                                value_commitment,
                                elements::EcdsaSighashType::All,
                            );
                            let public_key = private_key.public_key(&secp);
                            let pset_input = pset.inputs_mut().get_mut(index).unwrap();
                            pset_input.final_script_sig =
                                utxo.item.redeem_script.as_ref().map(|script| {
                                    elements::script::Builder::new()
                                        .push_slice(script.as_bytes())
                                        .into_script()
                                });
                            pset_input.final_script_witness =
                                Some(vec![input_sign, public_key.to_bytes()]);
                        }
                    }

                    let pset = elements::encode::serialize(&pset);
                    let signed_swap_resp = send_request!(
                        send_request,
                        SignedSwapDealer,
                        SignedSwapDealerRequest {
                            order_id: data.order_id,
                            pset: base64::engine::general_purpose::STANDARD.encode(&pset),
                        }
                    );
                    if let Err(e) = signed_swap_resp {
                        error!("starting swap failed: {}", e);
                    }
                }

                Notification::SwapDone(swap) => {
                    debug!("instant swap complete: {:?}", &swap);
                    let _active_swap = instant_swaps
                        .remove(&swap.order_id)
                        .expect("order not found");
                    if swap.status == SwapDoneStatus::Success {
                        let txid = swap.txid.unwrap();
                        // All reported amounts are from the client side
                        let dealer_send_bitcoins = swap.recv_asset == bitcoin_asset;
                        let (asset_id, bitcoin_amount) = if swap.recv_asset == bitcoin_asset {
                            (swap.send_asset, swap.recv_amount)
                        } else {
                            (swap.recv_asset, swap.send_amount)
                        };
                        let bitcoin_amount = Amount::from_sat(bitcoin_amount);
                        let asset = assets
                            .iter()
                            .find(|v: &&Asset| v.asset_id == asset_id)
                            .expect("asset must be known");
                        let ticker = dealer_ticker_from_asset(asset).unwrap();
                        let instant_swap_succeed = SwapSucceed {
                            txid,
                            dealer_send_bitcoins,
                            bitcoin_amount,
                            ticker,
                        };
                        from_tx.send(From::Swap(instant_swap_succeed)).unwrap();
                    }
                }

                _ => {}
            },

            Msg::ReloadUtxo => {
                let unspent_with_zc = rpc::make_rpc_call(
                    &rpc_http_client,
                    &params.rpc,
                    rpc::ListUnspentCall { minconf: 0 },
                )
                .expect("list_unspent failed");

                from_tx.send(From::Utxos(unspent_with_zc.clone())).unwrap();

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
                        dealer_ticker_from_asset(asset).map(|ticker| (ticker, balance))
                    })
                    .collect::<BTreeMap<_, _>>();

                if wallet_balances != wallet_balances_new {
                    wallet_balances = wallet_balances_new;
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
                        Some(v) => dealer_prices.insert(
                            ticker,
                            DealerPriceTimestamp {
                                dealer: v,
                                timestamp: std::time::Instant::now(),
                            },
                        ),
                        None => dealer_prices.remove(&ticker),
                    };
                    msg_tx.send(Msg::Timer).unwrap();
                }

                To::ResetPrices(_) => {
                    dealer_prices.clear();
                    msg_tx.send(Msg::Timer).unwrap();
                }

                To::IndexPriceUpdate(price_update) => {
                    if server_connected {
                        let price_update =
                            send_request!(send_request, PriceUpdateBroadcast, price_update);
                        if let Err(e) = price_update {
                            error!("price update failed: {}", e);
                        }
                    }
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
                            &dealer_prices,
                            &wallet_balances,
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

                    let result = take_order(
                        &params,
                        &assets,
                        &order.details,
                        &wallet_balances,
                        &dealer_prices,
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

                for (ticker, dealer_price) in dealer_prices.iter() {
                    let base_price = dealer_price.dealer.submit_price;

                    // Correct price for the server fee on instant swaps
                    let submit_price = apply_interest(
                        &base_price,
                        1.0 + sideswap_common::pset::INSTANT_SWAPS_SERVER_FEE,
                    );

                    let wallet_asset_amount =
                        wallet_balances.get(ticker).copied().unwrap_or_default();
                    let wallet_btc_amount = wallet_balances
                        .get(&DealerTicker::LBTC)
                        .copied()
                        .unwrap_or_default();

                    let mut list = PriceOffers::default();
                    let max_send_asset_amount = f64::min(
                        wallet_btc_amount * submit_price.ask,
                        dealer_price.dealer.limit_btc_dealer_send * submit_price.ask,
                    ) * INSTANT_SWAP_WORK_AMOUNT;
                    let max_send_bitcoin_amount = f64::min(
                        dealer_price.dealer.limit_btc_dealer_recv,
                        wallet_asset_amount / submit_price.bid,
                    ) * INSTANT_SWAP_WORK_AMOUNT;
                    if max_send_asset_amount > 0.0 {
                        list.push(PriceOffer {
                            client_send_bitcoins: false,
                            price: submit_price.ask,
                            max_send_amount: Amount::from_bitcoin(max_send_asset_amount).to_sat(),
                        });
                    }
                    if max_send_bitcoin_amount > 0.0 {
                        list.push(PriceOffer {
                            client_send_bitcoins: true,
                            price: submit_price.bid,
                            max_send_amount: Amount::from_bitcoin(max_send_bitcoin_amount).to_sat(),
                        });
                    }
                    if server_connected {
                        let ticker = dealer_ticker_to_asset_ticker(*ticker);
                        let asset = assets
                            .iter()
                            .find(|asset| asset.ticker.0 == ticker)
                            .unwrap();

                        let price_stream = BroadcastPriceStreamRequest {
                            asset: asset.asset_id,
                            list,
                            balancing: dealer_price.dealer.balancing,
                        };
                        let broadcast_price_resp =
                            send_request!(send_request, BroadcastPriceStream, price_stream);
                        if let Err(e) = broadcast_price_resp {
                            error!("broadcast price failed: {}", e);
                        }
                    }
                }

                let wallet_result =
                    rpc::make_rpc_call(&rpc_http_client, &params.rpc, rpc::GetWalletInfoCall {});
                match wallet_result {
                    Ok(v) => {
                        if wallet_balance.as_ref() != Some(&v) {
                            wallet_balance = Some(v);
                            msg_tx.send(Msg::ReloadUtxo).unwrap();
                        }
                    }
                    Err(e) => error!("wallet balance loading failed: {}", e),
                }

                let now = std::time::Instant::now();
                let expired = dealer_prices
                    .iter()
                    .filter(|(_, price)| now.duration_since(price.timestamp) > PRICE_EXPIRATON_TIME)
                    .map(|(ticker, _)| *ticker)
                    .collect::<Vec<_>>();
                for ticker in expired {
                    warn!("remove expired ticker: {ticker}");
                    dealer_prices.remove(&ticker);
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
