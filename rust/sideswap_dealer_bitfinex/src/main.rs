#![recursion_limit = "1024"]

mod module;

pub mod proto {
    include!(concat!(
        env!("OUT_DIR"),
        "/sideswap.proxy.bitfinex.proto.rs"
    ));
}

#[allow(non_snake_case)]
extern "C" {
    fn cgoStartApp(port: u16, logFilePort: *const libc::c_char);
}

pub mod balancing;
mod slack;
mod storage;

use balancing::*;
use clap::{App, Arg};
use prost::Message;
use rpc::make_rpc_call;
use serde::{Deserialize, Serialize};
use sideswap_api::*;
use sideswap_common::*;
use sideswap_dealer::dealer::*;
use sideswap_dealer::rpc;
use std::collections::{BTreeMap, BTreeSet, VecDeque};
use std::convert::Infallible;
use std::net::TcpListener;
use storage::*;
use types::{Amount, TxOut};

type Timestamp = std::time::Instant;

const ACCEPT_GRACE_PERIOD: std::time::Duration = std::time::Duration::from_secs(65);

#[derive(Debug, Clone, Hash, PartialEq, Eq, PartialOrd, Ord, Deserialize)]
pub struct ExchangeTicker(String);

const DEALER_TICKERS: [&DealerTicker; 2] = [&DEALER_USDT, &DEALER_EURX];

const BITFINEX_WALLET_EXCHANGE: &str = "exchange";

const BITFINEX_METHOD_USDT: &str = "tetherusl";
const BITFINEX_METHOD_LBTC: &str = "LBT";

const BITFINEX_STATUS_COMPLETED: &str = "COMPLETED";

const MIN_BALANCE_BITCOIN: f64 = 0.05;
const MIN_BALANCE_TETHER: f64 = 2500.;

const BF_RESERVE: f64 = 0.99;

#[macro_use]
extern crate log;
#[macro_use]
extern crate anyhow;
#[macro_use]
extern crate futures;

const MAX_RATIO_UPDATE_NOTIFICATION: f64 = 0.05;

const SERVER_REQUEST_TIMEOUT: std::time::Duration = std::time::Duration::from_secs(5);

const PRICE_EXPIRED: std::time::Duration = std::time::Duration::from_secs(300);

const INTEREST_DEFAULT: f64 = 1.0075;
const INTEREST_TO_SIGN: f64 = 1.0050;

const MIN_HEDGE_AMOUNT: f64 = 0.0002;

const BITFINEX_FEE_PROD: f64 = 0.0017;
const BITFINEX_FEE_TEST: f64 = 0.002;

macro_rules! send_request {
    ($f:ident, $t:ident, $value:expr) => {
        match $f(Request::$t($value)) {
            Ok(Response::$t(value)) => Ok(value),
            Ok(_) => panic!("unexpected response type"),
            Err(error) => Err(error),
        }
    };
}

#[derive(Debug, Deserialize, Clone)]
pub struct NotificationSettings {
    pub url: Option<String>,
}

type ExchangeBalances = BTreeMap<ExchangeTicker, f64>;
type ModulePrices = BTreeMap<DealerTicker, Price>;
type PendingOrders = BTreeMap<i64, std::time::Instant>;

#[derive(Debug, Deserialize)]
pub struct Args {
    log_settings: String,

    env: types::Env,

    bitcoin_amount_submit: f64,
    bitcoin_amount_min: f64,
    bitcoin_amount_max: f64,

    proxy_log_file: String,
    proxy_port: u16,

    server_host: String,
    server_port: u16,
    server_use_tls: bool,

    status_port: u16,

    rpc: rpc::RpcServer,

    #[serde(rename = "apikey")]
    api_key: Option<String>,

    module: module::Server,

    notifications: NotificationSettings,

    #[serde(rename = "bitfinexkey")]
    bitfinex_key: String,
    #[serde(rename = "bitfinexsecret")]
    bitfinex_secret: String,

    bitfinex_bookname_usdt: String,
    bitfinex_bookname_eurx: String,

    bitfinex_withdraw_address: String,
    bitfinex_fund_address: String,

    bitfinex_currency_btc: ExchangeTicker,
    bitfinex_currency_lbtc: ExchangeTicker,
    bitfinex_currency_usdt: ExchangeTicker,
    bitfinex_currency_eur: ExchangeTicker,

    storage_path: String,
    balancing_enabled: bool,
}

enum Msg {
    Timer,
    Connected,
    Disconnected,
    Notification(Notification),
    ModuleConnected,
    ModuleDisconnected,
    ModuleMessage(proto::from::Msg),
    ReloadUtxo,
    Cli(CliRequestData),
    Exit,
    CheckExchange,
    Dealer(From),
}

struct QuoteTimestamp {
    quote: Quote,
    timestamp: std::time::Instant,
}

struct ActiveSwap {
    ticker: Option<DealerTicker>,
    rfq: MatchRfq,
    send_bitcoin: bool,
    quote_last: Result<Quote, RfqRejectReason>,
    quotes_old: VecDeque<QuoteTimestamp>,
    swap: Option<Swap>,
    accepted: bool,
    last_updated: std::time::Instant,
}

#[derive(Eq, PartialEq, Clone, Debug)]
struct Quote {
    proposal: i64,
    change_amount: i64,
    txouts: Vec<TxOut>,
}

type Utxos = BTreeMap<TxOut, Utxo>;

#[derive(Clone, Copy)]
struct Price {
    pub bid: f64,
    pub ask: f64,
    pub timestamp: std::time::Instant,
}

fn free_reservation(order_id: &OrderId, utxos: &mut Utxos) {
    for utxo in utxos
        .values_mut()
        .filter(|utxo| utxo.reserve.as_ref() == Some(&order_id))
    {
        utxo.reserve = None;
    }
}

fn send_msg(tx: &module::Sender, msg: proto::to::Msg) {
    let msg = proto::To { msg: Some(msg) };
    let mut buf = Vec::new();
    msg.encode(&mut buf).expect("encoding message failed");
    tx.send(module::WrappedRequest::Data(buf))
        .expect("sending must succeed");
}

fn bitcoin_ratio(unspent_with_zc: &rpc::ListUnspent, price: &Price, assets: &Vec<Asset>) -> f64 {
    let mut bitcoin_amount = Amount::default();
    let mut tether_amount = Amount::default();
    for utxo in unspent_with_zc.iter() {
        let asset = assets.iter().find(|asset| asset.asset_id.0 == utxo.asset);
        if let Some(asset) = asset {
            let utxo_amount = Amount::from_rpc(&utxo.amount);
            if asset.ticker.0 == TICKER_LBTC {
                bitcoin_amount = bitcoin_amount + utxo_amount;
            } else if asset.ticker.0 == TICKER_USDT {
                tether_amount = tether_amount + utxo_amount;
            }
        }
    }

    let expected_tether_price = (price.ask + price.bid) / 2.0;
    let bitcoin_amount_from_tether =
        Amount::from_bitcoin(tether_amount.to_bitcoin() / expected_tether_price);
    let total_bitcoin_amount = bitcoin_amount + bitcoin_amount_from_tether;
    if total_bitcoin_amount.to_sat() == 0 {
        0.0
    } else {
        bitcoin_amount.to_bitcoin() / total_bitcoin_amount.to_bitcoin()
    }
}

fn send_notification(msg: &str, slack_url: &Option<String>) {
    info!("send notification: {}", msg);
    if let Some(url) = slack_url.clone() {
        let msg = msg.to_owned();
        std::thread::spawn(move || {
            let result = slack::send_slack(&msg, &url, 3, std::time::Duration::from_secs(15));
            if let Err(e) = result {
                error!("sending slack notification failed: {}", &e);
            }
        });
    }
}

fn get_exchange_balance(exchange_balances: &ExchangeBalances, name: &ExchangeTicker) -> i64 {
    Amount::from_bitcoin(exchange_balances.get(name).cloned().unwrap_or_default() * BF_RESERVE)
        .to_sat()
}

fn get_new_quote(
    assets: &Assets,
    module_price: &Option<Price>,
    active_swap: &ActiveSwap,
    utxos: &Utxos,
    server_status: &ServerStatus,
    interest: f64,
    args: &Args,
    exchange_balances: &ExchangeBalances,
) -> Result<Quote, RfqRejectReason> {
    let send_bitcoin = active_swap.send_bitcoin;
    let rfq = &active_swap.rfq;
    let asset_send = assets
        .iter()
        .find(|v: &&Asset| v.asset_id == rfq.recv_asset)
        .expect("buy_asset must be known");
    let asset_recv = assets
        .iter()
        .find(|v| v.asset_id == rfq.send_asset)
        .expect("sell_asset must be known");
    assert!(asset_send.ticker.0 == TICKER_LBTC || asset_recv.ticker.0 == TICKER_LBTC);

    let other_asset = if send_bitcoin { asset_recv } else { asset_send };
    let dealer_ticker = DEALER_TICKERS
        .iter()
        .find(|ticker| ticker.0 == other_asset.ticker.0);
    if dealer_ticker.is_none() {
        return Err(RfqRejectReason::NoDealer);
    }
    let module_price = match module_price.as_ref() {
        Some(v) => v,
        None => return Err(RfqRejectReason::ServerError),
    };
    let md_price = if send_bitcoin {
        module_price.bid
    } else {
        module_price.ask
    };
    let proposal = if send_bitcoin {
        rfq.send_amount / (md_price * interest) as i64
    } else {
        rfq.send_amount * (md_price / interest) as i64
    };
    let (bitcoin_amount, asset_amount) = if send_bitcoin {
        (proposal, rfq.send_amount)
    } else {
        (rfq.send_amount, proposal)
    };
    if proposal <= 0 {
        return Err(RfqRejectReason::AmountLow);
    }

    let low_btc = !send_bitcoin
        && get_exchange_balance(exchange_balances, &args.bitfinex_currency_btc) < bitcoin_amount;
    let low_usdt = send_bitcoin
        && other_asset.ticker.0 == TICKER_USDT
        && get_exchange_balance(exchange_balances, &args.bitfinex_currency_usdt) < asset_amount;
    let low_eurx = send_bitcoin
        && other_asset.ticker.0 == TICKER_EURX
        && get_exchange_balance(exchange_balances, &args.bitfinex_currency_eur) < asset_amount
        && args.env.is_mainnet();
    if low_btc || low_usdt || low_eurx {
        return Err(RfqRejectReason::AmountHigh);
    }

    let mut asset_utxos: Vec<Utxo> = utxos
        .values()
        .filter(|utxo| utxo.item.asset == asset_send.asset_id.0 && utxo.reserve.is_none())
        .cloned()
        .collect();

    let utxos_amounts: Vec<i64> = asset_utxos.iter().map(|utxo| utxo.amount).collect();
    let total: i64 = utxos_amounts.iter().sum();
    if total == 0 {
        return Err(RfqRejectReason::NoDealer);
    }
    if total < proposal {
        return Err(RfqRejectReason::AmountHigh);
    }

    // TODO: Always send with change to keep things simple (and remove corner cases)
    let selected = types::select_utxo(utxos_amounts, proposal);
    let selected_amount = selected.iter().sum::<i64>();
    let change_amount = selected_amount - proposal;
    assert!(change_amount >= 0);
    let with_change = change_amount > 0;
    let vin_count = rfq.utxo_count + selected.len() as i32;
    let vout_count = 2 + rfq.with_change as i32 + with_change as i32;
    let expected_fee = sideswap_common::types::expected_network_fee(
        vin_count,
        vout_count,
        server_status.elements_fee_rate,
    )
    .to_sat();

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

    if send_bitcoin {
        Ok(Quote {
            proposal,
            change_amount,
            txouts: selected_utxos,
        })
    } else {
        let corrected_proposal = (rfq.send_amount - expected_fee) * (md_price / interest) as i64;
        let corrected_change = selected_amount - corrected_proposal;
        if corrected_proposal <= 0 {
            return Err(RfqRejectReason::AmountLow);
        }
        //debug!("propsal: {}, corrected: {}", proposal, corrected_proposal);

        Ok(Quote {
            proposal: corrected_proposal,
            change_amount: corrected_change,
            txouts: selected_utxos,
        })
    }
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
enum CliRequest {
    TestSendUsdt(f64),
    TestRecvUsdt(f64),
    TestSendBtc(f64),
    TestRecvBtc(f64),
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
enum CliResponse {
    Success(String),
    Error(String),
}

struct CliRequestData {
    req: CliRequest,
    resp_tx: Option<std::sync::mpsc::Sender<CliResponse>>,
}

fn send_cli_request(msg_tx: &std::sync::mpsc::Sender<Msg>, req: CliRequest) {
    msg_tx
        .send(Msg::Cli(CliRequestData { req, resp_tx: None }))
        .unwrap();
}

fn process_cli_client(
    msg_tx: std::sync::mpsc::Sender<Msg>,
    stream: std::net::TcpStream,
) -> Result<(), anyhow::Error> {
    let mut websocket = tungstenite::server::accept(stream)?;
    loop {
        let msg = match websocket.read_message() {
            Ok(v) => v,
            Err(_) => return Ok(()),
        };
        if msg.is_text() || msg.is_binary() {
            let req = msg.to_text()?.to_owned();
            let req = serde_json::from_str::<CliRequest>(&req);
            let (resp_tx, resp_rx) = std::sync::mpsc::channel::<CliResponse>();
            match req {
                Ok(v) => msg_tx
                    .send(Msg::Cli(CliRequestData {
                        req: v,
                        resp_tx: Some(resp_tx),
                    }))
                    .unwrap(),
                Err(v) => resp_tx.send(CliResponse::Error(v.to_string())).unwrap(),
            };
            let resp = resp_rx.recv().unwrap();
            let resp = serde_json::to_string(&resp).unwrap();
            websocket.write_message(tungstenite::protocol::Message::Text(resp))?;
        }
    }
}

fn start_cli(msg_tx: std::sync::mpsc::Sender<Msg>) {
    let server = TcpListener::bind("127.0.0.1:9001").unwrap();
    for stream in server.incoming() {
        let msg_tx_copy = msg_tx.clone();
        std::thread::spawn(move || {
            let result = process_cli_client(msg_tx_copy, stream.unwrap());
            if let Err(e) = result {
                error!("processing client failed: {}", &e);
            }
        });
    }
}

fn save_storage(storage: &Storage, path: &str) {
    let path_tmp = format!("{}.tmp", path);
    use std::io::prelude::*;
    let data = serde_json::to_vec(storage).unwrap();
    let mut f = std::fs::File::create(&path_tmp).expect("can't create storage file");
    f.write_all(data.as_slice()).expect("storage write failed");
    std::mem::drop(f);
    std::fs::rename(path_tmp, path).expect("renaming new file failed");
}

fn load_storage(path: &str) -> Option<Storage> {
    if !std::path::Path::new(path).exists() {
        return None;
    }
    let data = std::fs::read_to_string(path).expect("reading failed");
    let storage = serde_json::from_str(&data).expect("parsing storage failed");
    Some(storage)
}

type HealthStatus = std::sync::Arc<std::sync::Mutex<Option<String>>>;

async fn health(
    _: hyper::Request<hyper::Body>,
    status: HealthStatus,
) -> Result<hyper::Response<hyper::Body>, Infallible> {
    let status = status
        .lock()
        .unwrap()
        .clone()
        .unwrap_or("NoError".to_owned());
    Ok(hyper::Response::new(hyper::Body::from(status)))
}

pub async fn start_webserver(
    status_port: u16,
    status: HealthStatus,
) -> Result<(), Box<dyn std::error::Error + Send + Sync>> {
    let make_svc = hyper::service::make_service_fn(move |_| {
        let status = status.clone();
        async {
            Ok::<_, Error>(hyper::service::service_fn(move |req| {
                health(req, status.clone())
            }))
        }
    });
    let addr = ([0, 0, 0, 0], status_port).into();
    let server = hyper::Server::bind(&addr).serve(make_svc);
    server.await?;
    Ok(())
}

struct ProfitsReport {
    wallet_balances: WalletBalances,
    exchange_balances: ExchangeBalances,
    created_at: std::time::Instant,
}

fn get_exchange_ticker(ticker: &ExchangeTicker, args: &Args) -> Option<DealerTicker> {
    if *ticker == args.bitfinex_currency_btc {
        Some(DEALER_LBTC)
    } else if *ticker == args.bitfinex_currency_usdt {
        Some(DEALER_USDT)
    } else if *ticker == args.bitfinex_currency_eur {
        Some(DEALER_EURX)
    } else {
        None
    }
}

fn hedge_order(
    args: &Args,
    txid: &str,
    dealer_ticker: DealerTicker,
    bitcoin_amount: Amount,
    send_bitcoins: bool,
    balancing_blocked: &mut std::time::Instant,
    profit_reports: &mut Option<ProfitsReport>,
    wallet_balances: &WalletBalances,
    exchange_balances: &ExchangeBalances,
    book_names: &BTreeMap<DealerTicker, String>,
    mod_tx: &module::Sender,
    pending_orders: &mut PendingOrders,
) {
    info!("swap succeed, txid: {}", &txid);
    *balancing_blocked = std::time::Instant::now();
    let bf_fee = if args.env.is_mainnet() {
        BITFINEX_FEE_PROD
    } else {
        BITFINEX_FEE_TEST
    };
    let signed_bitcoin_amount = if send_bitcoins {
        Amount::from_bitcoin(bitcoin_amount.to_bitcoin() / (1.0 - bf_fee)).to_bitcoin()
    } else {
        -bitcoin_amount.to_bitcoin()
    };
    if bitcoin_amount.to_bitcoin() >= MIN_HEDGE_AMOUNT {
        *profit_reports = Some(ProfitsReport {
            wallet_balances: wallet_balances.clone(),
            exchange_balances: exchange_balances.clone(),
            created_at: std::time::Instant::now(),
        });
        let cid = types::timestamp_now();
        let bookname = book_names
            .get(&dealer_ticker)
            .expect("bookname must be know");
        info!(
            "swap succeed, txid: {}, send order request, amount: {}, bookname: {}, cid: {}",
            txid, signed_bitcoin_amount, bookname, cid
        );
        send_msg(
            &mod_tx,
            proto::to::Msg::OrderSubmit(proto::to::OrderSubmit {
                cid,
                amount: signed_bitcoin_amount,
                book_name: bookname.clone(),
            }),
        );
        pending_orders.insert(cid, std::time::Instant::now());
    } else {
        debug!(
            "skip hedging as amount is too low: {}",
            signed_bitcoin_amount
        );
    }
}

fn main() {
    std::panic::set_hook(Box::new(|i| {
        eprint!("panic: {:?}", i);
        error!("panic: {:?}", i);
        std::process::abort();
    }));

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
    let args: Args = conf.try_into().expect("invalid config");

    let tickers = vec![DEALER_USDT, DEALER_EURX].into_iter().collect();
    let params = Params {
        env: args.env,
        server_host: args.server_host.clone(),
        server_port: args.server_port,
        server_use_tls: args.server_use_tls,
        rpc: args.rpc.clone(),
        interest_submit: INTEREST_DEFAULT,
        interest_sign: INTEREST_TO_SIGN,
        tickers,
        bitcoin_amount_submit: Amount::from_bitcoin(args.bitcoin_amount_submit),
        bitcoin_amount_min: Amount::from_bitcoin(args.bitcoin_amount_min),
        bitcoin_amount_max: Amount::from_bitcoin(args.bitcoin_amount_max),
    };

    log4rs::init_file(&args.log_settings, Default::default()).expect("can't open log settings");

    info!("starting proxy...");
    unsafe {
        let proxy_port = args.proxy_port;
        let proxy_log_file = std::ffi::CString::new(args.proxy_log_file.clone()).unwrap();
        std::thread::spawn(move || {
            cgoStartApp(proxy_port, proxy_log_file.as_ptr());
        });
    }

    let mut storage = load_storage(&args.storage_path).unwrap_or_default();
    let storage_path = args.storage_path.clone();
    save_storage(&storage, &storage_path);

    let mut movements: Option<proto::from::Movements> = None;

    let (msg_tx, msg_rx) = std::sync::mpsc::channel::<Msg>();
    let (ws_tx, ws_rx) = ws::start(
        args.server_host.clone(),
        args.server_port,
        args.server_use_tls,
        false,
    );
    let (resp_tx, resp_rx) = std::sync::mpsc::channel::<Result<Response, Error>>();

    let msg_tx_copy = msg_tx.clone();
    let (mod_tx, mod_rx) = module::start(args.module.clone());
    std::thread::spawn(move || {
        for msg in mod_rx {
            match msg {
                module::WrappedResponse::Connected => {
                    msg_tx_copy.send(Msg::ModuleConnected).unwrap();
                }
                module::WrappedResponse::Disconnected => {
                    msg_tx_copy.send(Msg::ModuleDisconnected).unwrap();
                }
                module::WrappedResponse::Data(data) => {
                    let from = proto::From::decode(data.as_slice()).expect("message decode failed");
                    let data = from.msg.unwrap();
                    msg_tx_copy.send(Msg::ModuleMessage(data)).unwrap();
                }
            }
        }
    });

    let mut balancing_blocked = std::time::Instant::now();

    let msg_tx_copy = msg_tx.clone();
    std::thread::spawn(move || loop {
        msg_tx_copy.send(Msg::Timer).unwrap();
        std::thread::sleep(std::time::Duration::from_secs(1));
    });

    let msg_tx_copy = msg_tx.clone();
    #[cfg(target_os = "linux")]
    std::thread::spawn(move || loop {
        const SIGNALS: &[libc::c_int] = &[
            signal_hook::consts::signal::SIGTERM,
            signal_hook::consts::signal::SIGINT,
        ];
        let mut sigs = signal_hook::iterator::Signals::new(SIGNALS).unwrap();
        for _ in &mut sigs {
            debug!("received term signal");
            msg_tx_copy.send(Msg::Exit).unwrap();
        }
    });

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
                ws::WrappedResponse::Response(ResponseMessage::Notification(notification)) => {
                    msg_tx_copy.send(Msg::Notification(notification)).unwrap();
                }
            }
        }
    });

    let send_request = |request: Request| -> Result<Response, Error> {
        let request_id = ws::next_request_id();
        ws_tx
            .send(ws::WrappedRequest::Request(RequestMessage::Request(
                request_id, request,
            )))
            .unwrap();
        resp_rx
            .recv_timeout(SERVER_REQUEST_TIMEOUT)
            .expect("request timeout")
    };

    let (dealer_tx, dealer_rx) = start(params.clone());
    let msg_tx_copy = msg_tx.clone();
    std::thread::spawn(move || {
        for msg in dealer_rx {
            msg_tx_copy.send(Msg::Dealer(msg)).unwrap();
        }
    });

    let mut assets = Vec::new();
    let mut utxos = Utxos::new();
    let mut server_status = None;
    let mut swaps: BTreeMap<OrderId, ActiveSwap> = BTreeMap::new();
    let mut server_connected = false;
    let mut module_connected = false;

    let mut wallet_balances = WalletBalances::new();
    let mut wallet_balances_confirmed = WalletBalances::new();
    let mut exchange_balances = ExchangeBalances::new();
    let mut exchange_balances_reported = ExchangeBalances::new();

    let mut profit_reports = None;

    let bitfinex_currency_btc = &args.bitfinex_currency_btc;
    let bitfinex_currency_usdt = &args.bitfinex_currency_usdt;
    let bitfinex_currency_eur = &args.bitfinex_currency_eur;

    let book_names = [
        (DEALER_USDT, args.bitfinex_bookname_usdt.clone()),
        (DEALER_EURX, args.bitfinex_bookname_eurx.clone()),
    ]
    .iter()
    .cloned()
    .collect::<BTreeMap<_, _>>();
    let book_tickers = book_names
        .iter()
        .map(|(ticker, book)| (book.clone(), ticker.clone()))
        .collect::<BTreeMap<_, _>>();

    let rpc_http_client = reqwest::blocking::Client::builder()
        .timeout(std::time::Duration::from_secs(5))
        .build()
        .expect("http client construction failed");

    let mut bitcoin_ratio_old: Option<f64> = None;

    let mut module_prices = ModulePrices::new();
    let mut broadcast_timestamps = BTreeMap::<DealerTicker, Timestamp>::new();
    let mut latest_check_exchange = std::time::Instant::now();

    let msg_tx_copy = msg_tx.clone();
    std::thread::spawn(|| {
        start_cli(msg_tx_copy);
    });

    send_notification("dealer started", &args.notifications.url);

    let status_port = args.status_port;
    let health_text = std::sync::Arc::new(std::sync::Mutex::new(None));
    let health_text_copy = health_text.clone();
    std::thread::spawn(move || {
        let rt = tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap();
        rt.block_on(start_webserver(status_port, health_text_copy))
            .unwrap();
    });

    let mut orders = BTreeMap::<OrderId, OrderCreatedNotification>::new();
    let mut pending_orders = PendingOrders::new();

    loop {
        let msg = msg_rx.recv().unwrap();
        let now = std::time::Instant::now();
        let interest = INTEREST_DEFAULT;

        // Broadcast prices
        for (ticker, module_price) in module_prices.iter() {
            let broadcast_timestamp = broadcast_timestamps.get(ticker);
            let expired = broadcast_timestamp
                .map(|timestamp| now.duration_since(*timestamp) > std::time::Duration::from_secs(1))
                .unwrap_or(true);
            if expired && server_connected {
                let asset = assets
                    .iter()
                    .find(|v: &&Asset| v.ticker.0 == ticker.0)
                    .expect("asset must be known");
                let price_new = PricePair {
                    bid: module_price.bid / interest,
                    ask: module_price.ask * interest,
                };
                if args.api_key.is_some() {
                    let price_update = send_request!(
                        send_request,
                        PriceUpdateBroadcast,
                        PriceUpdateBroadcast {
                            asset: asset.asset_id.clone(),
                            price: price_new,
                        }
                    );
                    if let Err(e) = price_update {
                        error!("price update failed: {}", e);
                    }
                }
                broadcast_timestamps.insert(ticker.clone(), now);
            }
        }

        // Send quote updates
        for (order_id, active_swap) in swaps.iter_mut() {
            if active_swap.accepted {
                continue;
            }
            let module_price = active_swap
                .ticker
                .as_ref()
                .map(|ticker| module_prices.get(&ticker))
                .flatten()
                .cloned();
            let server_status = server_status.as_ref().expect("server_status must exists");
            let quote_new = get_new_quote(
                &assets,
                &module_price,
                &active_swap,
                &utxos,
                &server_status,
                interest,
                &args,
                &exchange_balances,
            );
            // No need to send update
            if active_swap.quote_last == quote_new {
                continue;
            }
            // Skip update if that just quote amount update
            if now.duration_since(active_swap.last_updated) < std::time::Duration::from_secs(1)
                && active_swap.quote_last.is_ok()
                && quote_new.is_ok()
            {
                continue;
            }
            if let Err(reason) = &quote_new {
                warn!("reject quote: {}, reason: {:?}", order_id, reason);
            }
            let quote_new_copy = quote_new.clone();
            let quote_request = quote_new.map(|v| MatchQuote {
                send_amount: v.proposal,
                utxo_count: v.txouts.len() as i32,
                with_change: v.change_amount > 0,
            });
            let quote_result = send_request!(
                send_request,
                MatchQuote,
                MatchQuoteRequest {
                    order_id: order_id.clone(),
                    quote: quote_request,
                }
            );
            // RFQ might be already removed
            if let Err(e) = quote_result {
                error!("send quote request failed: {}", &e);
                continue;
            }

            let now = std::time::Instant::now();
            if let Ok(v) = &quote_new_copy {
                active_swap.quotes_old.push_back(QuoteTimestamp {
                    quote: v.clone(),
                    timestamp: now,
                });
            }
            // Remove only outdated quotes, to make sure there is always non-expired quote that user still might accept
            while active_swap.quotes_old.len() >= 2
                && now - active_swap.quotes_old[1].timestamp > ACCEPT_GRACE_PERIOD
            {
                active_swap.quotes_old.pop_front();
            }
            active_swap.quote_last = quote_new_copy;
            active_swap.last_updated = now;
        }

        match msg {
            Msg::Connected => {
                info!("connected to server");
                send_notification("connected to the server", &args.notifications.url);

                if let Some(api_key) = &args.api_key {
                    send_request!(
                        send_request,
                        LoginDealer,
                        LoginDealerRequest {
                            api_key: api_key.to_owned(),
                        }
                    )
                    .expect("dealer login failed");
                }

                assets = send_request!(
                    send_request,
                    Assets,
                    Some(AssetsRequestParam {
                        embedded_icons: false,
                    })
                )
                .expect("loading assets failed")
                .assets;

                let subscribe_resp =
                    send_request!(send_request, Login, LoginRequest { session_id: None })
                        .expect("subscribing to order list failed");
                for order in subscribe_resp.orders {
                    orders.insert(order.order_id.clone(), order);
                }

                server_status = Some(
                    send_request!(send_request, ServerStatus, None)
                        .expect("loading server status failed"),
                );
                server_connected = true;

                // Must reload wallet balances after updating assets
                msg_tx.send(Msg::ReloadUtxo).unwrap();
            }

            Msg::Disconnected => {
                warn!("disconnected from server");
                send_notification("disconnected from the server", &args.notifications.url);
                server_connected = false;
                swaps.clear();
                for utxo in utxos.values_mut() {
                    utxo.reserve = None;
                }
            }

            Msg::Notification(notification) => match notification {
                Notification::RfqCreated(req) => {
                    let asset_send = assets
                        .iter()
                        .find(|v: &&Asset| v.asset_id == req.rfq.recv_asset)
                        .expect("recv_asset must be known");
                    let asset_recv = assets
                        .iter()
                        .find(|v: &&Asset| v.asset_id == req.rfq.send_asset)
                        .expect("recv_asset must be known");
                    let send_bitcoin = asset_send.ticker.0 == TICKER_LBTC;
                    let other_asset = if send_bitcoin { asset_recv } else { asset_send };
                    let dealer_ticker = DEALER_TICKERS
                        .iter()
                        .find(|ticker| ticker.0 == other_asset.ticker.0)
                        .cloned()
                        .cloned();
                    swaps.insert(
                        req.order_id,
                        ActiveSwap {
                            ticker: dealer_ticker,
                            rfq: req.rfq,
                            send_bitcoin,
                            quote_last: Err(RfqRejectReason::ServerError),
                            quotes_old: VecDeque::new(),
                            swap: None,
                            accepted: false,
                            last_updated: std::time::Instant::now(),
                        },
                    );
                }

                Notification::RfqRemoved(req) => {
                    if req.status == RfqStatus::Accepted {
                        debug!("rfq accepted...");
                        let active_swap = swaps.get_mut(&req.order_id).expect("swap must exists");
                        active_swap.accepted = true;
                    } else {
                        debug!("rfq rejected");
                        swaps.remove(&req.order_id);
                    }
                }

                Notification::Swap(swap) => {
                    let active_swap = swaps.get_mut(&swap.order_id).expect("swap must exists");
                    match &swap.state {
                        SwapState::WaitPsbt(sw) => {
                            let quote = &active_swap
                                .quotes_old
                                .iter()
                                .rev()
                                .find(|item| item.quote.proposal == sw.send_amount)
                                .expect("quote must exists")
                                .quote;
                            for txout in quote.txouts.iter() {
                                let utxo = utxos
                                    .values_mut()
                                    .find(|utxo| {
                                        utxo.item.txid == txout.txid && utxo.item.vout == txout.vout
                                    })
                                    .expect("utxo must exists");
                                utxo.reserve = Some(swap.order_id.clone());
                            }

                            // TODO: Check assets and amounts
                            active_swap.swap = Some(sw.clone());

                            let sw = active_swap.swap.as_ref().expect("swap must be set");
                            let new_address = make_rpc_call::<String>(
                                &rpc_http_client,
                                &args.rpc,
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
                            outputs_assets.insert(new_address.clone(), sw.recv_asset.clone().0);

                            if quote.change_amount > 0 {
                                let change_address = make_rpc_call::<String>(
                                    &rpc_http_client,
                                    &args.rpc,
                                    &rpc::get_new_address(),
                                )
                                .expect("getting new address failed");
                                outputs_amounts.insert(
                                    change_address.clone(),
                                    Amount::from_sat(quote.change_amount).to_rpc(),
                                );
                                outputs_assets.insert(change_address, sw.send_asset.clone().0);
                            }

                            let raw_tx = make_rpc_call::<String>(
                                &rpc_http_client,
                                &args.rpc,
                                &rpc::create_raw_tx(
                                    &inputs,
                                    &outputs_amounts,
                                    0,
                                    false,
                                    &outputs_assets,
                                ),
                            )
                            .expect("creating raw tx failed");

                            let psbt = make_rpc_call::<String>(
                                &rpc_http_client,
                                &args.rpc,
                                &rpc::convert_to_psbt(&raw_tx),
                            )
                            .expect("converting PSBT failed");

                            let psbt = make_rpc_call::<rpc::FillPsbtData>(
                                &rpc_http_client,
                                &args.rpc,
                                &rpc::fill_psbt_data(&psbt),
                            )
                            .expect("converting PSBT failed");

                            send_request!(
                                send_request,
                                Swap,
                                SwapRequest {
                                    order_id: swap.order_id.clone(),
                                    action: SwapAction::Psbt(psbt.psbt),
                                }
                            )
                            .expect("sending psbt failed");
                        }
                        SwapState::WaitSign(psbt) => {
                            let result = make_rpc_call::<rpc::WalletSignPsbt>(
                                &rpc_http_client,
                                &args.rpc,
                                &rpc::wallet_sign_psbt(&psbt),
                            )
                            .expect("signing PSBT failed");

                            send_request!(
                                send_request,
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
                            swaps.remove(&swap.order_id);
                        }
                        SwapState::Done(txid) => {
                            let swap = active_swap.swap.as_ref().expect("swap must be set");
                            let dealer_ticker = active_swap
                                .ticker
                                .as_ref()
                                .expect("dealer ticker must be know")
                                .clone();
                            let bitcoin_amount = Amount::from_sat(if active_swap.send_bitcoin {
                                swap.send_amount
                            } else {
                                swap.recv_amount
                            });
                            hedge_order(
                                &args,
                                &txid,
                                dealer_ticker,
                                bitcoin_amount,
                                active_swap.send_bitcoin,
                                &mut balancing_blocked,
                                &mut profit_reports,
                                &wallet_balances,
                                &exchange_balances,
                                &book_names,
                                &mod_tx,
                                &mut pending_orders,
                            );
                        }
                    }
                }
                Notification::ServerStatus(status) => server_status = Some(status),

                Notification::OrderCreated(order) if order.own.is_none() => {
                    orders.insert(order.order_id.clone(), order);
                    msg_tx.send(Msg::Timer).unwrap();
                }
                Notification::OrderRemoved(order) => {
                    orders.remove(&order.order_id);
                }

                _ => {}
            },

            Msg::ReloadUtxo => {
                let unspent_with_zc = make_rpc_call::<rpc::ListUnspent>(
                    &rpc_http_client,
                    &args.rpc,
                    &rpc::listunspent(0),
                )
                .expect("list_unspent failed");

                let convert_balances = |amounts: &BTreeMap<&str, f64>| {
                    assets
                        .iter()
                        .flat_map(|asset| {
                            amounts
                                .get(asset.asset_id.0.as_str())
                                .map(|balance| (asset, *balance))
                        })
                        .flat_map(|(asset, balance)| {
                            ticker_from_asset(asset).map(|ticker| (ticker, balance))
                        })
                        .collect::<BTreeMap<_, _>>()
                };

                let mut asset_amounts = BTreeMap::<&str, f64>::new();
                let mut asset_amounts_confirmed = BTreeMap::<&str, f64>::new();
                for item in unspent_with_zc.iter() {
                    let asset_amount = asset_amounts.entry(&item.asset).or_default();
                    let asset_amount_confirmed =
                        asset_amounts_confirmed.entry(&item.asset).or_default();
                    let amount = Amount::from_rpc(&item.amount).to_bitcoin();
                    *asset_amount += amount;
                    if item.confirmations > 0 {
                        *asset_amount_confirmed += amount;
                    }
                }

                let wallet_balances_new = convert_balances(&asset_amounts);
                wallet_balances_confirmed = convert_balances(&asset_amounts_confirmed);

                if wallet_balances != wallet_balances_new {
                    wallet_balances = wallet_balances_new;
                    let balances = wallet_balances
                        .iter()
                        .map(|(ticker, balance)| format!("{}: {:.8}", ticker.0, balance))
                        .collect::<Vec<_>>();
                    let balance_str = balances.join(", ");
                    let message = format!("ss: {}", &balance_str);
                    send_notification(&message, &args.notifications.url);
                }

                let module_price_usdt = module_prices.get(&DEALER_USDT).cloned();
                if let Some(module_price_usdt) = module_price_usdt {
                    if !assets.is_empty() {
                        let bitcoin_ratio =
                            bitcoin_ratio(&unspent_with_zc, &module_price_usdt, &assets);
                        let send_update = match bitcoin_ratio_old {
                            Some(v) => (v - bitcoin_ratio).abs() >= MAX_RATIO_UPDATE_NOTIFICATION,
                            None => true,
                        };
                        if send_update {
                            bitcoin_ratio_old = Some(bitcoin_ratio);
                            // TODO: Account balance on exchange too
                            let text = format!("bitcoin ratio: {:0.2}", bitcoin_ratio);
                            info!("{}", &text);
                            //send_notification(&text, &args.notifications.url);
                        }
                    }
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

            Msg::ModuleConnected => {
                module_connected = true;
                info!("connected to module");
                send_notification("module connection online", &args.notifications.url);

                send_msg(
                    &mod_tx,
                    proto::to::Msg::Login(proto::to::Login {
                        key: args.bitfinex_key.clone(),
                        secret: args.bitfinex_secret.clone(),
                    }),
                );

                for book_name in book_names.values() {
                    send_msg(
                        &mod_tx,
                        proto::to::Msg::Subscribe(proto::to::Subscribe {
                            book_name: book_name.clone(),
                        }),
                    );
                }

                msg_tx.send(Msg::CheckExchange).unwrap();
            }
            Msg::ModuleDisconnected => {
                module_connected = false;
                info!("disconnected from module");
                send_notification("module connection offline", &args.notifications.url);
                module_prices.clear();
                for &ticker in params.tickers.iter() {
                    dealer_tx
                        .send(To::Price(ToPrice {
                            ticker,
                            price: None,
                        }))
                        .unwrap();
                }
            }
            Msg::ModuleMessage(msg) => {
                match msg {
                    proto::from::Msg::BookUpdate(book_update) => {
                        let price = Price {
                            bid: book_update.price.bid,
                            ask: book_update.price.ask,
                            timestamp: now,
                        };
                        //debug!("updated price, bid: {}, ask: {}", price.bid, price.ask);
                        let ticker = book_tickers
                            .get(&book_update.book_name)
                            .expect("book ticker must be known")
                            .clone();
                        let old_module_price = module_prices.insert(ticker, price);
                        dealer_tx
                            .send(To::Price(ToPrice {
                                ticker,
                                price: Some(PricePair {
                                    bid: price.bid,
                                    ask: price.ask,
                                }),
                            }))
                            .unwrap();
                        if old_module_price.is_none() {
                            info!("received price");
                            send_notification(
                                &format!(
                                    "module price refreshed: {}/{} for {}",
                                    price.ask, price.bid, ticker.0,
                                ),
                                &args.notifications.url,
                            );
                        }
                    }
                    proto::from::Msg::OrderConfirm(msg) => {
                        info!(
                            "order created, cid: {}, id: {}, amount: {}, price: {}",
                            msg.cid, msg.id, msg.amount, msg.price
                        );
                        let pending_order = pending_orders.remove(&msg.cid);
                        match pending_order {
                            Some(v) => debug!(
                                "order created: {}, {} seconds",
                                msg.cid,
                                std::time::Instant::now().duration_since(v).as_secs_f64()
                            ),
                            None => debug!("unexpected order: {}", msg.cid),
                        }
                    }
                    proto::from::Msg::WalletUpdate(msg) => {
                        let currency = ExchangeTicker(msg.currency);
                        let old_balance = exchange_balances.get(&currency);
                        if old_balance != Some(&msg.balance) {
                            info!("exchange balance updated: {}: {}", &currency.0, msg.balance);
                            if let Some(ticker) = get_exchange_ticker(&currency, &args) {
                                dealer_tx
                                    .send(To::LimitBalance(ToLimitBalance {
                                        ticker,
                                        balance: msg.balance * BF_RESERVE,
                                        recv_limit: true,
                                    }))
                                    .unwrap();
                            }
                            let old_value = exchange_balances.insert(currency, msg.balance);
                            if old_value.is_some() {
                                msg_tx.send(Msg::CheckExchange).unwrap();
                            }
                        }
                    }
                    proto::from::Msg::Withdraw(msg) => {
                        balancing::process_withdraw(&mut storage, msg, &args);
                    }
                    proto::from::Msg::Movements(msg) => {
                        balancing::process_movements(&mut storage, msg, &args, &mut movements);
                    }

                    proto::from::Msg::Transfer(msg) => {
                        balancing::process_transfer(&mut storage, msg, &args);
                    }

                    proto::from::Msg::Error(msg) => {
                        send_notification(
                            &format!("module failed: {}", msg.error),
                            &args.notifications.url,
                        );
                    }
                }
            }

            Msg::Timer => {
                let balance_wallet_bitcoin = wallet_balances
                    .get(&DEALER_LBTC)
                    .cloned()
                    .unwrap_or_default();
                let balance_wallet_usdt = wallet_balances
                    .get(&DEALER_USDT)
                    .cloned()
                    .unwrap_or_default();
                let balance_wallet_eurx = wallet_balances
                    .get(&DEALER_EURX)
                    .cloned()
                    .unwrap_or_default();
                let balance_exchange_bitcoin = exchange_balances
                    .get(bitfinex_currency_btc)
                    .cloned()
                    .unwrap_or_default();
                let balance_exchange_usdt = exchange_balances
                    .get(bitfinex_currency_usdt)
                    .cloned()
                    .unwrap_or_default();
                let balance_exchange_eur = exchange_balances
                    .get(bitfinex_currency_eur)
                    .cloned()
                    .unwrap_or_default();
                let balancing_expired = storage
                    .balancing
                    .as_ref()
                    .map(|balancing| {
                        std::time::SystemTime::now()
                            .duration_since(balancing.created_at)
                            .expect("must succeed")
                            > std::time::Duration::from_secs(30 * 60)
                    })
                    .unwrap_or_default();
                let status = [
                    (!module_connected).then(|| "ServerOffline"),
                    (!server_connected).then(|| "ModuleOffline"),
                    (module_prices.len() != DEALER_TICKERS.len()).then(|| "PriceExpired"),
                    (balance_wallet_bitcoin < MIN_BALANCE_BITCOIN).then(|| "WalletBitcoinLow"),
                    (balance_exchange_bitcoin < MIN_BALANCE_BITCOIN).then(|| "ExchangeBitcoinLow"),
                    (balance_wallet_usdt < MIN_BALANCE_TETHER).then(|| "WalletTetherLow"),
                    (balance_exchange_usdt < MIN_BALANCE_TETHER).then(|| "ExchangeTetherLow"),
                    balancing_expired.then(|| "BalancingStuck"),
                ]
                .iter()
                .flatten()
                .map(|v| v.to_owned())
                .collect::<Vec<_>>();
                *health_text.lock().unwrap() = if status.is_empty() {
                    None
                } else {
                    Some(status.join(","))
                };

                if storage.balancing.is_none()
                    && args.env.is_mainnet()
                    && now.duration_since(balancing_blocked) > std::time::Duration::from_secs(60)
                    && args.balancing_enabled
                {
                    let balance_bitcoin =
                        get_balancing(balance_wallet_bitcoin, balance_exchange_bitcoin, &RATIO_BTC);
                    let balance_usdt =
                        get_balancing(balance_wallet_usdt, balance_exchange_usdt, &RATIO_USDT);
                    match balance_bitcoin {
                        Balancing::Recv(amount) => {
                            send_cli_request(&msg_tx, CliRequest::TestRecvBtc(amount))
                        }
                        Balancing::Send(amount) => {
                            send_cli_request(&msg_tx, CliRequest::TestSendBtc(amount))
                        }
                        Balancing::None => match balance_usdt {
                            Balancing::Recv(amount) => {
                                send_cli_request(&msg_tx, CliRequest::TestRecvUsdt(amount))
                            }
                            Balancing::Send(amount) => {
                                send_cli_request(&msg_tx, CliRequest::TestSendUsdt(amount))
                            }
                            Balancing::None => {}
                        },
                    }
                }

                for ticker in DEALER_TICKERS.iter() {
                    let module_price = module_prices.get(ticker);
                    if let Some(module_price) = module_price {
                        let price_age = now.duration_since(module_price.timestamp);
                        if price_age > PRICE_EXPIRED {
                            warn!("price expired");
                            send_notification(
                                &format!("module price expired for {}", ticker.0),
                                &args.notifications.url,
                            );
                            module_prices.remove(ticker);
                            dealer_tx
                                .send(To::Price(ToPrice {
                                    ticker: **ticker,
                                    price: None,
                                }))
                                .unwrap();
                        }
                    }
                }

                if exchange_balances_reported != exchange_balances {
                    exchange_balances_reported = exchange_balances.clone();
                    let balances = exchange_balances_reported
                        .iter()
                        .map(|(curr, amount)| format!("{}: {:.8}", curr.0, amount))
                        .collect::<Vec<_>>();
                    let balance_str = balances.join(", ");
                    let message = format!("bf: {}", &balance_str);
                    send_notification(&message, &args.notifications.url);
                }

                balancing::process_balancing(
                    &mut storage,
                    &wallet_balances_confirmed,
                    &exchange_balances,
                    module_connected,
                    &assets,
                    &rpc_http_client,
                    &args,
                    &mod_tx,
                );

                let check_exchange_age = now.duration_since(latest_check_exchange);
                if check_exchange_age > std::time::Duration::from_secs(60) {
                    msg_tx.send(Msg::CheckExchange).unwrap();
                    latest_check_exchange = now;
                }

                if let Some(data) = profit_reports.as_mut() {
                    if std::time::Instant::now().duration_since(data.created_at)
                        > std::time::Duration::from_secs(60)
                    {
                        error!("profit reporting timeout");
                        profit_reports = None;
                    }
                }

                if let Some(data) = profit_reports.as_mut() {
                    let balance_wallet_bitcoin_old = data
                        .wallet_balances
                        .get(&DEALER_LBTC)
                        .cloned()
                        .unwrap_or_default();
                    let balance_wallet_usdt_old = data
                        .wallet_balances
                        .get(&DEALER_USDT)
                        .cloned()
                        .unwrap_or_default();
                    let balance_wallet_eurx_old = data
                        .wallet_balances
                        .get(&DEALER_EURX)
                        .cloned()
                        .unwrap_or_default();
                    let balance_exchange_bitcoin_old = data
                        .exchange_balances
                        .get(bitfinex_currency_btc)
                        .cloned()
                        .unwrap_or_default();
                    let balance_exchange_usdt_old = data
                        .exchange_balances
                        .get(bitfinex_currency_usdt)
                        .cloned()
                        .unwrap_or_default();
                    let balance_exchange_eur_old = data
                        .exchange_balances
                        .get(bitfinex_currency_eur)
                        .cloned()
                        .unwrap_or_default();
                    let bitcoins_updated = balance_wallet_bitcoin != balance_wallet_bitcoin_old
                        && balance_exchange_bitcoin != balance_exchange_bitcoin_old;
                    let usdt_updated = balance_wallet_usdt != balance_wallet_usdt_old
                        && balance_exchange_usdt != balance_exchange_usdt_old;
                    let eur_updated = balance_wallet_eurx != balance_wallet_eurx_old
                        && balance_exchange_eur != balance_exchange_eur_old;
                    if bitcoins_updated && (usdt_updated || eur_updated) {
                        let bitcoin_change = balance_wallet_bitcoin + balance_exchange_bitcoin
                            - balance_wallet_bitcoin_old
                            - balance_exchange_bitcoin_old;
                        let usdt_change = balance_wallet_usdt + balance_exchange_usdt
                            - balance_wallet_usdt_old
                            - balance_exchange_usdt_old;
                        let eur_change = balance_wallet_eurx + balance_exchange_eur
                            - balance_wallet_eurx_old
                            - balance_exchange_eur_old;
                        send_notification(
                            &format!(
                                "swap complete, balance change: bitcoin: {:0.8}, usdt: {:0.8}, eurx: {:0.8}",
                                bitcoin_change, usdt_change, eur_change
                            ),
                            &args.notifications.url,
                        );
                        profit_reports = None;
                    }
                }

                let expired_orders = pending_orders
                    .iter()
                    .filter(|(_, timestamp)| {
                        now.duration_since(**timestamp) > std::time::Duration::from_secs(30)
                    })
                    .map(|(cid, _)| *cid)
                    .collect::<Vec<_>>();
                for cid in expired_orders {
                    send_notification(
                        &format!(":fire: bf order {} timeout", cid),
                        &args.notifications.url,
                    );
                    pending_orders.remove(&cid);
                }
            }
            Msg::Cli(data) => {
                let (new_state, amount, name) = match data.req {
                    CliRequest::TestSendUsdt(amount) => {
                        (TransferState::SendUsdtNew, amount, "send usdt")
                    }
                    CliRequest::TestRecvUsdt(amount) => {
                        (TransferState::RecvUsdtNew, amount, "recv usdt")
                    }
                    CliRequest::TestSendBtc(amount) => {
                        (TransferState::SendBtcNew, amount, "send btc")
                    }
                    CliRequest::TestRecvBtc(amount) => {
                        (TransferState::RecvBtcNew, amount, "recv btc")
                    }
                };
                let resp = if storage.balancing.is_some() {
                    CliResponse::Error("already started".to_owned())
                } else {
                    movements = None;
                    storage.balancing = Some(Transfer {
                        amount: Amount::from_bitcoin(amount),
                        created_at: std::time::SystemTime::now(),
                        updated_at: std::time::SystemTime::now(),
                        state: new_state,
                        txid: None,
                        withdraw_id: None,
                    });
                    save_storage(&storage, &storage_path);
                    send_notification(
                        &format!("start balancing, {}, amount: {}", name, amount),
                        &args.notifications.url,
                    );
                    CliResponse::Success("success".to_owned())
                };
                if let Some(resp_tx) = data.resp_tx {
                    let _ = resp_tx.send(resp);
                }
            }
            Msg::CheckExchange => {
                if let Some(balancing) = storage.balancing.as_ref() {
                    if module_connected {
                        let start = balancing
                            .created_at
                            .checked_sub(std::time::Duration::from_secs(10))
                            .unwrap()
                            .duration_since(std::time::UNIX_EPOCH)
                            .unwrap()
                            .as_millis() as i64;
                        send_msg(
                            &mod_tx,
                            proto::to::Msg::Movements(proto::to::Movements {
                                key: args.bitfinex_key.clone(),
                                secret: args.bitfinex_secret.clone(),
                                start: Some(start),
                                end: None,
                                limit: None,
                            }),
                        );
                    }
                }
            }

            Msg::Dealer(msg) => match msg {
                From::Swap(swap) => {
                    hedge_order(
                        &args,
                        &swap.txid,
                        swap.ticker,
                        swap.bitcoin_amount,
                        swap.send_bitcoins,
                        &mut &mut balancing_blocked,
                        &mut profit_reports,
                        &wallet_balances,
                        &exchange_balances,
                        &book_names,
                        &mod_tx,
                        &mut pending_orders,
                    );
                }
                From::WalletBalanceUpdated(_) => {
                    info!("wallet balance updated");
                    msg_tx.send(Msg::ReloadUtxo).unwrap();
                }
            },
            Msg::Exit => {
                return;
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_get_balancing() {
        assert_eq!(get_balancing(0.0, 0.5, &RATIO_BTC), Balancing::None);
        assert_eq!(get_balancing(0.5, 0.0, &RATIO_BTC), Balancing::None);
        assert_eq!(get_balancing(0.5, 0.5, &RATIO_BTC), Balancing::None);
        assert_eq!(get_balancing(0.1, 0.9, &RATIO_BTC), Balancing::Recv(0.3));
        assert_eq!(get_balancing(0.9, 0.1, &RATIO_BTC), Balancing::Send(0.5));
        assert_eq!(get_balancing(5000., 5000., &RATIO_USDT), Balancing::None);
        assert_eq!(
            get_balancing(1000., 9000., &RATIO_USDT),
            Balancing::Recv(5000.0)
        );
        assert_eq!(
            get_balancing(9000., 1000., &RATIO_USDT),
            Balancing::Send(3000.0)
        );
    }
}
