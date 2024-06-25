#![recursion_limit = "1024"]

mod bitfinex_api;
mod bitfinex_worker;
mod module;

pub mod proto {
    #![allow(non_snake_case)]
    include!(concat!(
        env!("OUT_DIR"),
        "/sideswap.proxy.bitfinex.proto.rs"
    ));
}

use axum::extract::State;
use axum::routing::get;

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
use serde::{Deserialize, Serialize};
use sideswap_api::*;
use sideswap_common::*;
use sideswap_dealer::dealer;
use sideswap_dealer::dealer::*;
use sideswap_dealer::rpc;
use std::collections::BTreeMap;
use std::collections::BTreeSet;
use std::net::TcpListener;
use storage::*;
use types::Amount;

#[derive(Debug, Clone, Hash, PartialEq, Eq, PartialOrd, Ord, Deserialize)]
pub struct ExchangeTicker(String);

const DEALER_TICKERS: [DealerTicker; 2] = [DealerTicker::USDt, DealerTicker::EURx];

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

const PRICE_EXPIRED: std::time::Duration = std::time::Duration::from_secs(300);

const INTEREST_SUBMIT_USDT: f64 = 1.0075 - pset::INSTANT_SWAPS_SERVER_FEE;
const INTEREST_SUBMIT_EURX: f64 = 1.0040 - pset::INSTANT_SWAPS_SERVER_FEE;

const MIN_HEDGE_AMOUNT: f64 = 0.0002;

const BITFINEX_FEE_PROD: f64 = 0.0017;
const BITFINEX_FEE_TEST: f64 = 0.002;

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

    env: sideswap_common::env::Env,

    bitcoin_amount_submit: f64,
    bitcoin_amount_min: f64,
    bitcoin_amount_max: f64,

    proxy_log_file: String,
    proxy_port: u16,

    server_url: String,

    status_port: u16,

    rpc: rpc::RpcServer,

    #[serde(rename = "apikey")]
    api_key: Option<String>,

    notifications: NotificationSettings,

    #[serde(rename = "bitfinexkey")]
    bitfinex_key: String,
    #[serde(rename = "bitfinexsecret")]
    bitfinex_secret: String,

    bitfinex_bookname_usdt: String,
    bitfinex_bookname_eurx: String,

    bitfinex_withdraw_address: elements::Address,
    bitfinex_fund_address: elements::Address,

    bitfinex_currency_btc: ExchangeTicker,
    bitfinex_currency_lbtc: ExchangeTicker,
    bitfinex_currency_usdt: ExchangeTicker,
    bitfinex_currency_eur: ExchangeTicker,

    storage_path: String,
    balancing_enabled: bool,
}

enum Msg {
    Timer,
    ModuleConnected,
    ModuleDisconnected,
    ModuleMessage(proto::from::Msg),
    BfWorker(bitfinex_worker::Response),
    Cli(CliRequestData),
    Exit,
    CheckExchange,
    Dealer(From),
}

#[derive(Clone, Copy)]
struct Price {
    pub bid: f64,
    pub ask: f64,
    pub timestamp: std::time::Instant,
}

fn send_msg(tx: &module::Sender, msg: proto::to::Msg) {
    let msg = proto::To { msg: Some(msg) };
    let mut buf = Vec::new();
    msg.encode(&mut buf).expect("encoding message failed");
    tx.send(module::WrappedRequest::Data(buf))
        .expect("sending must succeed");
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

fn get_exchange_balance(exchange_balances: &ExchangeBalances, name: &ExchangeTicker) -> f64 {
    exchange_balances.get(name).cloned().unwrap_or_default() * BF_RESERVE
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
    resp_tx: Option<crossbeam_channel::Sender<CliResponse>>,
}

fn send_cli_request(msg_tx: &crossbeam_channel::Sender<Msg>, req: CliRequest) {
    msg_tx
        .send(Msg::Cli(CliRequestData { req, resp_tx: None }))
        .unwrap();
}

fn process_cli_client(
    msg_tx: crossbeam_channel::Sender<Msg>,
    stream: std::net::TcpStream,
) -> Result<(), anyhow::Error> {
    let mut websocket = tungstenite::accept(stream)?;
    loop {
        let msg = match websocket.read() {
            Ok(v) => v,
            Err(_) => return Ok(()),
        };
        if msg.is_text() || msg.is_binary() {
            let req = msg.to_text()?.to_owned();
            let req = serde_json::from_str::<CliRequest>(&req);
            let (resp_tx, resp_rx) = crossbeam_channel::unbounded::<CliResponse>();
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
            websocket.write(tungstenite::protocol::Message::Text(resp))?;
        }
    }
}

fn start_cli(msg_tx: crossbeam_channel::Sender<Msg>) {
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

async fn health(State(status): State<HealthStatus>) -> String {
    status
        .lock()
        .unwrap()
        .clone()
        .unwrap_or("NoError".to_owned())
}

pub async fn start_webserver(
    status_port: u16,
    status: HealthStatus,
) -> Result<(), Box<dyn std::error::Error + Send + Sync>> {
    let app = axum::Router::new()
        .route("/health", get(health))
        .with_state(status);

    let addr: std::net::SocketAddr = ([0, 0, 0, 0], status_port).into();
    let listener = tokio::net::TcpListener::bind(addr).await?;
    axum::serve(listener, app).await?;

    Ok(())
}

struct ProfitsReport {
    wallet_balances: WalletBalances,
    exchange_balances: ExchangeBalances,
    created_at: std::time::Instant,
}

fn hedge_order(
    args: &Args,
    swap: SwapSucceed,
    balancing_blocked: &mut std::time::Instant,
    profit_reports: &mut Option<ProfitsReport>,
    wallet_balances: &WalletBalances,
    exchange_balances: &ExchangeBalances,
    book_names: &BTreeMap<DealerTicker, String>,
    bf_sender: &crossbeam_channel::Sender<bitfinex_worker::Request>,
    pending_orders: &mut PendingOrders,
) {
    info!(
        "hedge swap, txid: {}, ticker: {}, send_bitcoins: {}, bitcoin_amount: {}",
        &swap.txid,
        swap.ticker,
        swap.dealer_send_bitcoins,
        swap.bitcoin_amount.to_bitcoin()
    );
    *balancing_blocked = std::time::Instant::now();
    let bf_fee = if args.env.d().mainnet {
        BITFINEX_FEE_PROD
    } else {
        BITFINEX_FEE_TEST
    };
    let signed_bitcoin_amount = if swap.dealer_send_bitcoins {
        Amount::from_bitcoin(swap.bitcoin_amount.to_bitcoin() / (1.0 - bf_fee)).to_bitcoin()
    } else {
        -swap.bitcoin_amount.to_bitcoin()
    };
    if swap.bitcoin_amount.to_bitcoin() >= MIN_HEDGE_AMOUNT {
        *profit_reports = Some(ProfitsReport {
            wallet_balances: wallet_balances.clone(),
            exchange_balances: exchange_balances.clone(),
            created_at: std::time::Instant::now(),
        });
        let cid = types::timestamp_now();
        let bookname = book_names.get(&swap.ticker).expect("bookname must be know");
        info!(
            "swap succeed, txid: {}, send order request, amount: {}, bookname: {}, cid: {}",
            swap.txid, signed_bitcoin_amount, bookname, cid
        );
        bf_sender
            .send(bitfinex_worker::Request::OrderSubmit(
                bitfinex_worker::OrderSubmit {
                    market_type: bitfinex_worker::MarketType::ExchangeMarket,
                    symbol: bookname.clone(),
                    cid,
                    amount: signed_bitcoin_amount,
                },
            ))
            .unwrap();
        pending_orders.insert(cid, std::time::Instant::now());
    } else {
        debug!(
            "skip hedging as amount is too low: {}",
            signed_bitcoin_amount
        );
    }
}

struct DealerState {
    network: sideswap_common::network::Network,
    server_connected: bool,
    module_connected: bool,
    wallet_balances: WalletBalances,
    wallet_balances_confirmed: WalletBalances,
    exchange_balances: ExchangeBalances,
    exchange_balances_reported: ExchangeBalances,
    profit_reports: Option<ProfitsReport>,
    pending_orders: PendingOrders,
    failed_orders_count: u32,
    failed_orders_total: f64,
}

fn main() {
    let matches = App::new("sideswap_dealer")
        .arg(Arg::with_name("config").required(true))
        .get_matches();
    let config_path = matches.value_of("config").unwrap();

    let mut conf = config::Config::new();
    conf.merge(config::File::with_name(config_path))
        .expect("can't load config");
    conf.merge(config::Environment::with_prefix("app").separator("_"))
        .expect("reading env failed");
    let args: Args = conf.try_into().expect("invalid config");

    let tickers = BTreeSet::from([DealerTicker::USDt, DealerTicker::EURx]);

    let params = Params {
        env: args.env,
        server_url: args.server_url.clone(),
        rpc: args.rpc.clone(),
        tickers,
        bitcoin_amount_submit: Amount::from_bitcoin(args.bitcoin_amount_submit),
        bitcoin_amount_min: Amount::from_bitcoin(args.bitcoin_amount_min),
        bitcoin_amount_max: Amount::from_bitcoin(args.bitcoin_amount_max),
        api_key: args.api_key.clone(),
    };

    log4rs::init_file(&args.log_settings, Default::default()).expect("can't open log settings");

    info!("starting up");

    sideswap_common::panic_handler::install_panic_handler();

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

    let (msg_tx, msg_rx) = crossbeam_channel::unbounded::<Msg>();

    let msg_tx_copy = msg_tx.clone();
    let (mod_tx, mod_rx) = module::start(args.proxy_port);
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

    let (bf_sender, bf_receiver) = crossbeam_channel::unbounded::<bitfinex_worker::Request>();
    let bf_settings = bitfinex_worker::Settings {
        bitfinex_key: args.bitfinex_key.clone(),
        bitfinex_secret: args.bitfinex_secret.clone(),
    };
    let msg_tx_copy = msg_tx.clone();
    std::thread::spawn(move || {
        bitfinex_worker::run(bf_settings, bf_receiver, |resp| {
            msg_tx_copy.send(Msg::BfWorker(resp)).unwrap();
        });
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

    let (dealer_tx, dealer_rx) = start(params.clone());
    let msg_tx_copy = msg_tx.clone();
    std::thread::spawn(move || {
        for msg in dealer_rx {
            msg_tx_copy.send(Msg::Dealer(msg)).unwrap();
        }
    });

    let mut state = DealerState {
        network: args.env.d().network,
        server_connected: false,
        module_connected: false,
        wallet_balances: WalletBalances::new(),
        wallet_balances_confirmed: WalletBalances::new(),
        exchange_balances: ExchangeBalances::new(),
        exchange_balances_reported: ExchangeBalances::new(),
        profit_reports: None,
        pending_orders: PendingOrders::new(),
        failed_orders_count: 0,
        failed_orders_total: 0.0,
    };

    let bitfinex_currency_btc = &args.bitfinex_currency_btc;
    let bitfinex_currency_usdt = &args.bitfinex_currency_usdt;
    let bitfinex_currency_eur = &args.bitfinex_currency_eur;

    let book_names = [
        (DealerTicker::USDt, args.bitfinex_bookname_usdt.clone()),
        (DealerTicker::EURx, args.bitfinex_bookname_eurx.clone()),
    ]
    .iter()
    .cloned()
    .collect::<BTreeMap<_, _>>();
    let book_tickers = book_names
        .iter()
        .map(|(ticker, book)| (book.clone(), *ticker))
        .collect::<BTreeMap<_, _>>();

    let rpc_http_client = ureq::AgentBuilder::new()
        .timeout(std::time::Duration::from_secs(20))
        .build();

    let mut module_prices = ModulePrices::new();
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

    loop {
        let msg = msg_rx.recv().unwrap();
        let now = std::time::Instant::now();

        match msg {
            Msg::ModuleConnected => {
                state.module_connected = true;
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
                state.module_connected = false;
                info!("disconnected from module");
                send_notification("module connection offline", &args.notifications.url);
                module_prices.clear();
                msg_tx.send(Msg::Timer).unwrap();
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
                        let ticker = *book_tickers
                            .get(&book_update.book_name)
                            .expect("book ticker must be known");
                        let old_module_price = module_prices.insert(ticker, price);
                        if old_module_price.is_none() {
                            info!("received price");
                            send_notification(
                                &format!(
                                    "module price refreshed: {}/{} for {}",
                                    price.ask, price.bid, ticker,
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
                        let pending_order = state.pending_orders.remove(&msg.cid);
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
                        let old_balance = state.exchange_balances.get(&currency);
                        if old_balance != Some(&msg.balance) {
                            info!("exchange balance updated: {}: {}", &currency.0, msg.balance);
                            let old_value = state.exchange_balances.insert(currency, msg.balance);
                            if old_value.is_some() {
                                msg_tx.send(Msg::CheckExchange).unwrap();
                            }
                        }
                    }
                    proto::from::Msg::Withdraw(_)
                    | proto::from::Msg::Movements(_)
                    | proto::from::Msg::Transfer(_) => {
                        unreachable!()
                    }

                    proto::from::Msg::Error(msg) => {
                        send_notification(
                            &format!("module failed: {}", msg.error),
                            &args.notifications.url,
                        );
                    }
                }
            }

            Msg::BfWorker(resp) => match resp {
                bitfinex_worker::Response::Withdraw(msg) => {
                    balancing::process_withdraw(&mut storage, msg, &args);
                }
                bitfinex_worker::Response::Transfer(msg) => {
                    balancing::process_transfer(&mut storage, msg, &args);
                }
                bitfinex_worker::Response::Movements(msg) => {
                    balancing::process_movements(&mut storage, msg, &args, &mut movements);
                }
                bitfinex_worker::Response::OrderSubmit(req, res) => match res {
                    Ok(order) => {
                        info!("order submit succeed, order_id: {}", order.order_id);
                    }
                    Err(err) => {
                        error!("order submit failed: {}", err);
                        state.failed_orders_count += 1;
                        state.failed_orders_total += req.amount;

                        send_notification(
                            &format!(
                                "bfx order(s) submit failed, count: {}, total: {} btc",
                                state.failed_orders_count, state.failed_orders_total,
                            ),
                            &args.notifications.url,
                        );
                    }
                },
            },

            Msg::Timer => {
                for &ticker in params.tickers.iter() {
                    let price = module_prices.get(&ticker).map(|module_price| {
                        let submit_interest = if ticker == DealerTicker::USDt {
                            INTEREST_SUBMIT_USDT
                        } else if ticker == DealerTicker::EURx {
                            INTEREST_SUBMIT_EURX
                        } else {
                            panic!("unexpected asset");
                        };

                        let base_price = PricePair {
                            bid: module_price.bid,
                            ask: module_price.ask,
                        };
                        let submit_price = apply_interest(&base_price, submit_interest);

                        let exchange_btc_amount = get_exchange_balance(
                            &state.exchange_balances,
                            &args.bitfinex_currency_btc,
                        );
                        let exchange_asset_currency = match ticker {
                            DealerTicker::USDt => &args.bitfinex_currency_usdt,
                            DealerTicker::EURx => &args.bitfinex_currency_eur,
                            _ => panic!(),
                        };
                        // Show that the dealer will buy any amount of EURx as needed
                        let exchange_asset_amount = if ticker == DealerTicker::EURx {
                            10.0 * module_price.ask
                        } else {
                            get_exchange_balance(&state.exchange_balances, exchange_asset_currency)
                        };

                        dealer::DealerPrice {
                            submit_price,
                            limit_btc_dealer_send: exchange_asset_amount / submit_price.ask,
                            limit_btc_dealer_recv: exchange_btc_amount,
                            balancing: storage.balancing.is_some(),
                        }
                    });

                    dealer_tx
                        .send(To::Price(ToPrice { ticker, price }))
                        .unwrap();

                    if let Some(price) = module_prices.get(&ticker) {
                        dealer_tx
                            .send(To::IndexPriceUpdate(PriceUpdateBroadcast {
                                asset: get_dealer_asset_id(state.network, ticker),
                                price: PricePair {
                                    bid: price.bid,
                                    ask: price.ask,
                                },
                            }))
                            .unwrap();
                    }
                }

                let balance_wallet_bitcoin = state
                    .wallet_balances
                    .get(&DealerTicker::LBTC)
                    .cloned()
                    .unwrap_or_default();
                let balance_wallet_usdt = state
                    .wallet_balances
                    .get(&DealerTicker::USDt)
                    .cloned()
                    .unwrap_or_default();
                let balance_wallet_eurx = state
                    .wallet_balances
                    .get(&DealerTicker::EURx)
                    .cloned()
                    .unwrap_or_default();
                let balance_exchange_bitcoin = state
                    .exchange_balances
                    .get(bitfinex_currency_btc)
                    .cloned()
                    .unwrap_or_default();
                let balance_exchange_usdt = state
                    .exchange_balances
                    .get(bitfinex_currency_usdt)
                    .cloned()
                    .unwrap_or_default();
                let balance_exchange_eur = state
                    .exchange_balances
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
                    (!state.module_connected).then_some("ModuleOffline"),
                    (!state.server_connected).then_some("ServerOffline"),
                    (module_prices.len() != DEALER_TICKERS.len()).then_some("PriceExpired"),
                    (balance_wallet_bitcoin < MIN_BALANCE_BITCOIN).then_some("WalletBitcoinLow"),
                    (balance_exchange_bitcoin < MIN_BALANCE_BITCOIN)
                        .then_some("ExchangeBitcoinLow"),
                    (balance_wallet_usdt < MIN_BALANCE_TETHER).then_some("WalletTetherLow"),
                    (balance_exchange_usdt < MIN_BALANCE_TETHER).then_some("ExchangeTetherLow"),
                    balancing_expired.then_some("BalancingStuck"),
                    (state.failed_orders_count != 0).then_some("FailedOrderSubmit"),
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

                let usdt_price = module_prices.get(&DealerTicker::USDt).cloned();
                if storage.balancing.is_none()
                    && args.env.d().mainnet
                    && now.duration_since(balancing_blocked) > std::time::Duration::from_secs(60)
                    && args.balancing_enabled
                    && usdt_price.is_some()
                {
                    let usdt_price = usdt_price.unwrap();
                    let usdt_price = (usdt_price.bid + usdt_price.ask) / 2.0;
                    let balancing = get_balancing(
                        balance_wallet_bitcoin,
                        balance_exchange_bitcoin,
                        balance_wallet_usdt,
                        balance_exchange_usdt,
                        usdt_price,
                    );

                    match balancing {
                        AssetBalancing::None => {}
                        AssetBalancing::RecvBtc(amount) => {
                            send_cli_request(&msg_tx, CliRequest::TestRecvBtc(amount))
                        }
                        AssetBalancing::SendBtc(amount) => {
                            send_cli_request(&msg_tx, CliRequest::TestSendBtc(amount))
                        }
                        AssetBalancing::RecvUsdt(amount) => {
                            send_cli_request(&msg_tx, CliRequest::TestRecvUsdt(amount))
                        }
                        AssetBalancing::SendUsdt(amount) => {
                            send_cli_request(&msg_tx, CliRequest::TestSendUsdt(amount))
                        }
                    };
                }

                for ticker in DEALER_TICKERS.iter() {
                    let module_price = module_prices.get(ticker);
                    if let Some(module_price) = module_price {
                        let price_age = now.duration_since(module_price.timestamp);
                        if price_age > PRICE_EXPIRED && args.env.d().mainnet {
                            warn!("price expired");
                            send_notification(
                                &format!("module price expired for {}", ticker),
                                &args.notifications.url,
                            );
                            module_prices.remove(ticker);
                            dealer_tx
                                .send(To::Price(ToPrice {
                                    ticker: *ticker,
                                    price: None,
                                }))
                                .unwrap();
                        }
                    }
                }

                if state.exchange_balances_reported != state.exchange_balances {
                    state.exchange_balances_reported = state.exchange_balances.clone();
                    let balances = state
                        .exchange_balances_reported
                        .iter()
                        .map(|(curr, amount)| format!("{}: {:.8}", curr.0, amount))
                        .collect::<Vec<_>>();
                    let balance_str = balances.join(", ");
                    let message = format!("bf: {}", &balance_str);
                    send_notification(&message, &args.notifications.url);
                }

                balancing::process_balancing(
                    &mut storage,
                    &state.wallet_balances_confirmed,
                    &state.exchange_balances,
                    state.module_connected,
                    &rpc_http_client,
                    &args,
                    &mod_tx,
                    &bf_sender,
                );

                let check_exchange_age = now.duration_since(latest_check_exchange);
                if check_exchange_age > std::time::Duration::from_secs(60) {
                    msg_tx.send(Msg::CheckExchange).unwrap();
                    latest_check_exchange = now;
                }

                if let Some(data) = state.profit_reports.as_mut() {
                    if std::time::Instant::now().duration_since(data.created_at)
                        > std::time::Duration::from_secs(60)
                    {
                        error!("profit reporting timeout");
                        state.profit_reports = None;
                    }
                }

                if let Some(data) = state.profit_reports.as_mut() {
                    let balance_wallet_bitcoin_old = data
                        .wallet_balances
                        .get(&DealerTicker::LBTC)
                        .cloned()
                        .unwrap_or_default();
                    let balance_wallet_usdt_old = data
                        .wallet_balances
                        .get(&DealerTicker::USDt)
                        .cloned()
                        .unwrap_or_default();
                    let balance_wallet_eurx_old = data
                        .wallet_balances
                        .get(&DealerTicker::EURx)
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
                        state.profit_reports = None;
                    }
                }

                let expired_orders = state
                    .pending_orders
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
                    state.pending_orders.remove(&cid);
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
                    if state.module_connected {
                        let start = balancing
                            .created_at
                            .checked_sub(std::time::Duration::from_secs(10))
                            .unwrap()
                            .duration_since(std::time::UNIX_EPOCH)
                            .unwrap()
                            .as_millis() as i64;
                        bf_sender
                            .send(bitfinex_worker::Request::Movements(proto::to::Movements {
                                key: args.bitfinex_key.clone(),
                                secret: args.bitfinex_secret.clone(),
                                start: Some(start),
                                end: None,
                                limit: None,
                            }))
                            .unwrap();
                    }
                }
            }

            Msg::Dealer(msg) => match msg {
                From::Swap(swap) => {
                    hedge_order(
                        &args,
                        swap,
                        &mut balancing_blocked,
                        &mut state.profit_reports,
                        &state.wallet_balances,
                        &state.exchange_balances,
                        &book_names,
                        &bf_sender,
                        &mut state.pending_orders,
                    );
                }

                From::ServerConnected(_) => {
                    info!("connected to server");
                    send_notification("connected to the server", &args.notifications.url);

                    state.server_connected = true;
                }

                From::ServerDisconnected(_) => {
                    warn!("disconnected from server");
                    send_notification("disconnected from the server", &args.notifications.url);
                    state.server_connected = false;
                }

                From::Utxos(unspent_with_zc) => {
                    let convert_balances = |amounts: &BTreeMap<AssetId, f64>| {
                        let get_balance = |ticker: DealerTicker| -> (DealerTicker, f64) {
                            let asset_id = get_dealer_asset_id(state.network, ticker);
                            let amount = amounts.get(&asset_id).copied().unwrap_or_default();
                            (ticker, amount)
                        };

                        BTreeMap::from([
                            get_balance(DealerTicker::LBTC),
                            get_balance(DealerTicker::USDt),
                            get_balance(DealerTicker::EURx),
                        ])
                    };

                    let mut asset_amounts = BTreeMap::<AssetId, f64>::new();
                    let mut asset_amounts_confirmed = BTreeMap::<AssetId, f64>::new();
                    for item in unspent_with_zc.iter() {
                        let asset_amount = asset_amounts.entry(item.asset).or_default();
                        let asset_amount_confirmed =
                            asset_amounts_confirmed.entry(item.asset).or_default();
                        let amount = Amount::from_rpc(&item.amount).to_bitcoin();
                        *asset_amount += amount;
                        if item.confirmations > 0 {
                            *asset_amount_confirmed += amount;
                        }
                    }

                    let wallet_balances_new = convert_balances(&asset_amounts);
                    state.wallet_balances_confirmed = convert_balances(&asset_amounts_confirmed);

                    if state.wallet_balances != wallet_balances_new {
                        state.wallet_balances = wallet_balances_new;
                        let balances = state
                            .wallet_balances
                            .iter()
                            .map(|(ticker, balance)| format!("{}: {:.8}", ticker, balance))
                            .collect::<Vec<_>>();
                        let balance_str = balances.join(", ");
                        let message = format!("ss: {}", &balance_str);
                        send_notification(&message, &args.notifications.url);
                    }
                }
            },
            Msg::Exit => {
                return;
            }
        }
    }
}
