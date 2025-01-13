mod balancing;
mod bfx_ws_api;
mod bitfinex_api;
mod bitfinex_worker;
mod cli;
mod external_prices;
mod storage;

use axum::extract::State;
use axum::routing::get;
use balancing::*;
use bitfinex_api::movements::Movements;
use elements::AssetId;
use log::{debug, error, info, warn};
use serde::Deserialize;
use sideswap_api::mkt::AssetPair;
use sideswap_api::mkt::TradeDir;
use sideswap_api::PricePair;
use sideswap_api::PriceUpdateBroadcast;
use sideswap_common::channel_helpers::UncheckedUnboundedSender;
use sideswap_common::network::Network;
use sideswap_common::types::btc_to_sat;
use sideswap_common::types::sat_to_btc;
use sideswap_common::types::timestamp_now;
use sideswap_common::types::Amount;
use sideswap_common::types::MAX_BTC_AMOUNT;
use sideswap_common::web_notif::send_many;
use sideswap_dealer::dealer_rpc;
use sideswap_dealer::dealer_rpc::*;
use sideswap_dealer::market;
use sideswap_dealer::rpc;
use sideswap_dealer::types::dealer_ticker_to_asset_id;
use sideswap_dealer::types::DealerTicker;
use sideswap_dealer::utxo_data;
use sideswap_dealer::utxo_data::UtxoData;
use sideswap_types::normal_float::NormalFloat;
use std::collections::BTreeMap;
use std::collections::BTreeSet;
use std::sync::Arc;
use std::time::Duration;
use std::time::Instant;
use storage::Transfer;
use storage::TransferState;
use tokio::sync::mpsc::unbounded_channel;
use tokio::sync::mpsc::UnboundedSender;

#[derive(Debug, Clone, Copy, Hash, PartialEq, Eq, PartialOrd, Ord)]
pub enum ExchangeTicker {
    BTC,
    LBTC,
    USDt,
    EUR,
}

impl ExchangeTicker {
    const ALL: [ExchangeTicker; 4] = [
        ExchangeTicker::BTC,
        ExchangeTicker::LBTC,
        ExchangeTicker::USDt,
        ExchangeTicker::EUR,
    ];

    fn name(self) -> &'static str {
        match self {
            ExchangeTicker::BTC => "BTC",
            ExchangeTicker::LBTC => "L-BTC",
            ExchangeTicker::USDt => "USDt",
            ExchangeTicker::EUR => "EUR",
        }
    }

    fn bfx_name_prod(self) -> &'static str {
        match self {
            ExchangeTicker::BTC => "BTC",
            ExchangeTicker::LBTC => "LBT",
            ExchangeTicker::USDt => "UST",
            ExchangeTicker::EUR => "EUR",
        }
    }

    fn bfx_name_test(self) -> &'static str {
        match self {
            ExchangeTicker::BTC => "TESTBTC",
            ExchangeTicker::LBTC => "TESTLBT",
            ExchangeTicker::USDt => "TESTUSDT",
            ExchangeTicker::EUR => "TESTEUR",
        }
    }

    fn bfx_name(self, network: Network) -> &'static str {
        match network {
            Network::Liquid => self.bfx_name_prod(),
            Network::LiquidTestnet => self.bfx_name_test(),
        }
    }

    fn find_bfx_name(network: Network, name: &str) -> Option<ExchangeTicker> {
        ExchangeTicker::ALL
            .iter()
            .find(|item| item.bfx_name(network) == name)
            .copied()
    }
}

impl std::fmt::Display for ExchangeTicker {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        self.name().fmt(f)
    }
}

const DEALER_TICKERS: [DealerTicker; 2] = [DealerTicker::USDt, DealerTicker::EURx];

const BITFINEX_WALLET_EXCHANGE: &str = "exchange";

const BITFINEX_METHOD_USDT: &str = "tetherusl";
const BITFINEX_METHOD_LBTC: &str = "LBT";

const BITFINEX_STATUS_COMPLETED: &str = "COMPLETED";

const MIN_BALANCE_BITCOIN: f64 = 0.05;
const MIN_BALANCE_TETHER: f64 = 2500.;

const BF_RESERVE: f64 = 0.99;

const INTEREST_BTC_USDT: f64 = 1.0055;
const INTEREST_BTC_EURX: f64 = 1.002;
const INTEREST_EURX_USDT: f64 = 1.002;

const MIN_HEDGE_AMOUNT: f64 = 0.0002;

const BITFINEX_FEE_PROD: f64 = 0.0017;
const BITFINEX_FEE_TEST: f64 = 0.002;

#[derive(Debug, Deserialize, Clone)]
pub struct NotificationSettings {
    pub url: Option<String>,
}

type ExchangeBalances = BTreeMap<ExchangeTicker, f64>;
type AllExchangeBalances = BTreeMap<String, f64>;
type BfxPrices = BTreeMap<ExchangePair, Price>;
type ExternalPrices = BTreeMap<ExchangePair, f64>;
type PendingOrders = BTreeMap<i64, Instant>;

#[derive(Debug, Deserialize)]
pub struct Settings {
    env: sideswap_common::env::Env,

    bitcoin_amount_submit: f64,
    bitcoin_amount_min: f64,
    bitcoin_amount_max: f64,

    server_url: Option<String>,

    status_port: u16,

    #[serde(rename = "apikey")]
    api_key: Option<String>,

    #[serde(rename = "bitfinexkey")]
    bitfinex_key: String,
    #[serde(rename = "bitfinexsecret")]
    bitfinex_secret: String,

    bitfinex_withdraw_address: elements::Address,
    bitfinex_fund_address: elements::Address,

    work_dir: String,
    storage_path: String,
    balancing_enabled: bool,

    rpc: rpc::RpcServer,

    notifications: NotificationSettings,

    external_prices: Option<external_prices::Settings>,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
enum ExchangePair {
    BtcUsdt,
    BtcEur,
    EurUsdt,
}

impl std::fmt::Display for ExchangePair {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        self.name().fmt(f)
    }
}

impl ExchangePair {
    const ALL: [ExchangePair; 3] = [
        ExchangePair::BtcUsdt,
        ExchangePair::BtcEur,
        ExchangePair::EurUsdt,
    ];

    fn name(self) -> &'static str {
        match self {
            ExchangePair::BtcUsdt => "L-BTC/USDt",
            ExchangePair::BtcEur => "L-BTC/EURx",
            ExchangePair::EurUsdt => "EURx/USDt",
        }
    }

    fn bfx_bookname(self) -> &'static str {
        match self {
            ExchangePair::BtcUsdt => "tBTCUST",
            ExchangePair::BtcEur => "tBTCEUR",
            ExchangePair::EurUsdt => "tEURUST",
        }
    }

    fn dealer_ticker(self) -> Option<DealerTicker> {
        match self {
            ExchangePair::BtcUsdt => Some(DealerTicker::USDt),
            ExchangePair::BtcEur => Some(DealerTicker::EURx),
            ExchangePair::EurUsdt => None,
        }
    }

    fn find_ticker(ticker: DealerTicker) -> Option<ExchangePair> {
        ExchangePair::ALL
            .iter()
            .find(|item| item.dealer_ticker() == Some(ticker))
            .copied()
    }

    fn find_bookname(bookname: &str) -> Option<ExchangePair> {
        ExchangePair::ALL
            .iter()
            .find(|item| item.bfx_bookname() == bookname)
            .copied()
    }
}

#[derive(Clone)]
struct BfSettings {
    bitfinex_key: String,
    bitfinex_secret: String,
}

enum Msg {
    BfWorker(bitfinex_worker::Response),
    Cli(cli::RequestData),
    CheckExchange,
    External(ExchangePair, Result<f64, anyhow::Error>),
}

#[derive(Clone, Copy)]
struct Price {
    bid: f64,
    ask: f64,
}

struct ProfitsReport {
    wallet_balances: WalletBalances,
    exchange_balances: ExchangeBalances,
    created_at: Instant,
}

type HealthStatus = Arc<std::sync::Mutex<Option<String>>>;

struct Data {
    settings: Settings,
    network: sideswap_common::network::Network,
    policy_asset: AssetId,
    server_connected: bool,
    bfx_connected: bool,
    wallet_balances: WalletBalances,
    wallet_balances_confirmed: WalletBalances,
    exchange_balances: ExchangeBalances,
    all_exchange_balances: AllExchangeBalances,
    all_exchange_balances_reported: AllExchangeBalances,
    profit_reports: Option<ProfitsReport>,
    pending_orders: PendingOrders,
    failed_orders_count: u32,
    failed_orders_total: f64,
    bfx_prices: BfxPrices,
    external_prices: ExternalPrices,
    health_text: HealthStatus,
    storage: storage::Storage,
    balancing_blocked: Instant,
    latest_check_exchange: Instant,
    movements: Option<Movements>,
    msg_tx: UnboundedSender<Msg>,
    dealer_command_sender: UnboundedSender<dealer_rpc::Command>,
    bf_sender: UnboundedSender<bitfinex_worker::Request>,
    market_command_sender: UncheckedUnboundedSender<market::Command>,
    utxo_data: UtxoData,
}

fn send_notification(msg: &str, slack_url: &Option<String>) {
    info!("send notification: {}", msg);
    if let Some(url) = slack_url.clone() {
        let msg = msg.to_owned();
        tokio::spawn(async move {
            let result = send_many(&msg, &url, 3, std::time::Duration::from_secs(15)).await;
            if let Err(e) = result {
                error!("sending slack notification failed: {}", &e);
            }
        });
    }
}

fn get_exchange_balance(exchange_balances: &ExchangeBalances, name: &ExchangeTicker) -> f64 {
    exchange_balances.get(name).cloned().unwrap_or_default() * BF_RESERVE
}

fn save_storage(storage: &storage::Storage, path: &str) {
    let path_tmp = format!("{}.tmp", path);
    use std::io::prelude::*;
    let data = serde_json::to_vec(storage).unwrap();
    let mut f = std::fs::File::create(&path_tmp).expect("can't create storage file");
    f.write_all(data.as_slice()).expect("storage write failed");
    std::mem::drop(f);
    std::fs::rename(path_tmp, path).expect("renaming new file failed");
}

fn load_storage(path: &str) -> Option<storage::Storage> {
    if !std::path::Path::new(path).exists() {
        return None;
    }
    let data = std::fs::read_to_string(path).expect("reading failed");
    let storage = serde_json::from_str(&data).expect("parsing storage failed");
    Some(storage)
}

async fn health(State(status): State<HealthStatus>) -> String {
    status
        .lock()
        .unwrap()
        .clone()
        .unwrap_or("NoError".to_owned())
}

pub async fn start_webserver(status_port: u16, status: HealthStatus) {
    let app = axum::Router::new()
        .route("/health", get(health))
        .with_state(status);

    let addr: std::net::SocketAddr = ([0, 0, 0, 0], status_port).into();
    let listener = tokio::net::TcpListener::bind(addr)
        .await
        .expect("must not fail");

    axum::serve(listener, app).await.expect("must not fail");
}

fn hedge_order(data: &mut Data, swap: SwapSucceed) {
    info!(
        "hedge swap, txid: {}, ticker: {}, send_bitcoins: {}, bitcoin_amount: {}",
        &swap.txid,
        swap.ticker,
        swap.dealer_send_bitcoins,
        swap.bitcoin_amount.to_bitcoin()
    );
    data.balancing_blocked = Instant::now();
    let bf_fee = if data.settings.env.d().mainnet {
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
        data.profit_reports = Some(ProfitsReport {
            wallet_balances: data.wallet_balances.clone(),
            exchange_balances: data.exchange_balances.clone(),
            created_at: Instant::now(),
        });
        let cid = timestamp_now();
        let bookname = ExchangePair::find_ticker(swap.ticker)
            .expect("bookname must be know")
            .bfx_bookname();
        info!(
            "swap succeed, txid: {}, send order request, amount: {}, bookname: {}, cid: {}",
            swap.txid, signed_bitcoin_amount, bookname, cid
        );
        data.bf_sender
            .send(bitfinex_worker::Request::OrderSubmit(
                bitfinex_worker::OrderSubmit {
                    market_type: bitfinex_worker::MarketType::ExchangeMarket,
                    symbol: bookname.to_owned(),
                    cid,
                    amount: signed_bitcoin_amount,
                },
            ))
            .unwrap();
        data.pending_orders.insert(cid, Instant::now());
    } else {
        debug!(
            "skip hedging as amount is too low: {}",
            signed_bitcoin_amount
        );
    }
}

fn get_bfx_price(data: &Data, exchange_pair: ExchangePair) -> Option<Price> {
    // How much difference can we tolerate
    const MAX_DIFF: f64 = 0.015;

    let bfx = data.bfx_prices.get(&exchange_pair).copied();
    let external = data.external_prices.get(&exchange_pair).copied();

    match (&bfx, &external) {
        // Compare against external price source
        (Some(bfx_price), Some(external)) => {
            let ask_diff = f64::abs((bfx_price.ask - external) / external);
            let bid_diff = f64::abs((bfx_price.bid - external) / external);
            // Normal difference is around 0.0002
            if ask_diff <= MAX_DIFF && bid_diff <= MAX_DIFF {
                bfx
            } else {
                log::warn!(
                    "price discrepancy: bid: {}, ask: {}, external: {}",
                    bfx_price.bid,
                    bfx_price.ask,
                    external
                );
                None
            }
        }
        _ => bfx,
    }
}

async fn process_dealer_event(data: &mut Data, event: Event) {
    match event {
        Event::Swap(swap) => {
            hedge_order(data, swap);
        }

        Event::ServerConnected(_) => {
            info!("connected to server");
            send_notification("connected to the server", &data.settings.notifications.url);

            data.server_connected = true;
        }

        Event::ServerDisconnected(_) => {
            warn!("disconnected from server");
            send_notification(
                "disconnected from the server",
                &data.settings.notifications.url,
            );
            data.server_connected = false;
        }

        Event::Utxos(utxo_data, unspent) => {
            data.utxo_data = utxo_data;

            data.market_command_sender.send(market::Command::Utxos {
                utxos: data.utxo_data.utxos().to_vec(),
            });

            let convert_balances = |amounts: &BTreeMap<AssetId, f64>| {
                let get_balance = |ticker: DealerTicker| -> (DealerTicker, f64) {
                    let asset_id = dealer_ticker_to_asset_id(data.network, ticker);
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
            for item in unspent.iter() {
                let asset_amount = asset_amounts.entry(item.asset).or_default();
                let asset_amount_confirmed = asset_amounts_confirmed.entry(item.asset).or_default();
                let amount = item.amount.to_btc();
                *asset_amount += amount;
                if item.confirmations > 0 {
                    *asset_amount_confirmed += amount;
                }
            }

            let wallet_balances_new = convert_balances(&asset_amounts);
            data.wallet_balances_confirmed = convert_balances(&asset_amounts_confirmed);

            if data.wallet_balances != wallet_balances_new {
                data.wallet_balances = wallet_balances_new;
                let balances = data
                    .wallet_balances
                    .iter()
                    .map(|(ticker, balance)| format!("{}: {:.8}", ticker, balance))
                    .collect::<Vec<_>>();
                let balance_str = balances.join(", ");
                let message = format!("ss: {}", &balance_str);
                send_notification(&message, &data.settings.notifications.url);
            }
        }
    }
}

fn submit_dealer_prices(data: &mut Data) {
    for ticker in [DealerTicker::USDt, DealerTicker::EURx] {
        let exchange_pair = ExchangePair::find_ticker(ticker).expect("must exist");
        let price = get_bfx_price(&data, exchange_pair).map(|bfx_price| {
            let submit_interest = if ticker == DealerTicker::USDt {
                INTEREST_BTC_USDT
            } else if ticker == DealerTicker::EURx {
                INTEREST_BTC_EURX
            } else {
                panic!("unexpected asset");
            };

            let base_price = PricePair {
                bid: bfx_price.bid,
                ask: bfx_price.ask,
            };
            let submit_price = apply_interest(&base_price, submit_interest);

            let exchange_btc_amount =
                get_exchange_balance(&data.exchange_balances, &ExchangeTicker::BTC);
            let exchange_asset_currency = match ticker {
                DealerTicker::USDt => &ExchangeTicker::USDt,
                DealerTicker::EURx => &ExchangeTicker::EUR,
                _ => panic!(),
            };
            // Show that the dealer will buy any amount of EURx as needed
            let exchange_asset_amount = if ticker == DealerTicker::EURx {
                10.0 * bfx_price.ask
            } else {
                get_exchange_balance(&data.exchange_balances, exchange_asset_currency)
            };

            dealer_rpc::DealerPrice {
                submit_price,
                limit_btc_dealer_send: exchange_asset_amount / submit_price.ask,
                limit_btc_dealer_recv: exchange_btc_amount,
                balancing: data.storage.balancing.is_some(),
            }
        });

        data.dealer_command_sender
            .send(Command::Price(UpdatePrice { ticker, price }))
            .unwrap();

        if let Some(price) = data.bfx_prices.get(&exchange_pair) {
            data.dealer_command_sender
                .send(Command::IndexPriceUpdate(PriceUpdateBroadcast {
                    asset: dealer_ticker_to_asset_id(data.network, ticker),
                    price: PricePair {
                        bid: price.bid,
                        ask: price.ask,
                    },
                }))
                .unwrap();
        }
    }
}

fn submit_market_prices(data: &mut Data) {
    let assets = &data.settings.env.nd().known_assets;

    let mut orders = Vec::new();

    for &exchange_pair in ExchangePair::ALL.iter() {
        let (asset_pair, interest) = match exchange_pair {
            ExchangePair::BtcUsdt => (
                AssetPair {
                    base: data.policy_asset,
                    quote: assets.usdt.asset_id(),
                },
                INTEREST_BTC_USDT,
            ),
            ExchangePair::BtcEur => (
                AssetPair {
                    base: data.policy_asset,
                    quote: assets.eurx.asset_id(),
                },
                INTEREST_BTC_EURX,
            ),
            ExchangePair::EurUsdt => (
                AssetPair {
                    base: assets.eurx.asset_id(),
                    quote: assets.usdt.asset_id(),
                },
                INTEREST_EURX_USDT,
            ),
        };

        let bfx_price = match get_bfx_price(&data, exchange_pair) {
            Some(price) => price,
            None => continue,
        };

        let base_price = PricePair {
            bid: bfx_price.bid,
            ask: bfx_price.ask,
        };

        let submit_price = apply_interest(&base_price, interest);

        let (base_amount_buy, base_amount_sell) = match exchange_pair {
            ExchangePair::BtcUsdt => {
                let btc_amount =
                    get_exchange_balance(&data.exchange_balances, &ExchangeTicker::BTC);
                let usdt_amount =
                    get_exchange_balance(&data.exchange_balances, &ExchangeTicker::USDt);
                (btc_amount, usdt_amount / submit_price.ask)
            }
            // Show that the dealer will buy or sell any amount of EURx as needed
            ExchangePair::EurUsdt | ExchangePair::BtcEur => (MAX_BTC_AMOUNT, MAX_BTC_AMOUNT),
        };

        orders.push(market::AutomaticOrder {
            asset_pair,
            trade_dir: TradeDir::Buy,
            base_amount: btc_to_sat(base_amount_buy),
            price: NormalFloat::new(submit_price.bid).expect("must be valid"),
        });

        orders.push(market::AutomaticOrder {
            asset_pair,
            trade_dir: TradeDir::Sell,
            base_amount: btc_to_sat(base_amount_sell),
            price: NormalFloat::new(submit_price.ask).expect("must be valid"),
        });
    }

    data.market_command_sender
        .send(market::Command::AutomaticOrders { orders });
}

async fn process_timer(data: &mut Data) {
    submit_dealer_prices(data);

    submit_market_prices(data);

    let now = Instant::now();

    let balance_wallet_bitcoin = data
        .wallet_balances
        .get(&DealerTicker::LBTC)
        .cloned()
        .unwrap_or_default();
    let balance_wallet_usdt = data
        .wallet_balances
        .get(&DealerTicker::USDt)
        .cloned()
        .unwrap_or_default();
    let balance_wallet_eurx = data
        .wallet_balances
        .get(&DealerTicker::EURx)
        .cloned()
        .unwrap_or_default();
    let balance_exchange_bitcoin = data
        .exchange_balances
        .get(&ExchangeTicker::BTC)
        .cloned()
        .unwrap_or_default();
    let balance_exchange_usdt = data
        .exchange_balances
        .get(&ExchangeTicker::USDt)
        .cloned()
        .unwrap_or_default();
    let balance_exchange_eur = data
        .exchange_balances
        .get(&ExchangeTicker::EUR)
        .cloned()
        .unwrap_or_default();
    let balancing_expired = data
        .storage
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
        (!data.bfx_connected).then_some("BfxOffline"),
        (!data.server_connected).then_some("ServerOffline"),
        (data.bfx_prices.len() != ExchangePair::ALL.len()).then_some("PriceExpired"),
        (balance_wallet_bitcoin < MIN_BALANCE_BITCOIN).then_some("WalletBitcoinLow"),
        (balance_exchange_bitcoin < MIN_BALANCE_BITCOIN).then_some("ExchangeBitcoinLow"),
        (balance_wallet_usdt < MIN_BALANCE_TETHER).then_some("WalletTetherLow"),
        (balance_exchange_usdt < MIN_BALANCE_TETHER).then_some("ExchangeTetherLow"),
        balancing_expired.then_some("BalancingStuck"),
        (data.failed_orders_count != 0).then_some("FailedOrderSubmit"),
        (data.external_prices.len() != 3).then_some("ExternalPrices"),
    ]
    .iter()
    .flatten()
    .map(|v| v.to_owned())
    .collect::<Vec<_>>();
    *data.health_text.lock().unwrap() = if status.is_empty() {
        None
    } else {
        Some(status.join(","))
    };

    let usdt_price = data.bfx_prices.get(&ExchangePair::BtcUsdt).cloned();
    if data.storage.balancing.is_none()
        && data.settings.env.d().mainnet
        && now.duration_since(data.balancing_blocked) > std::time::Duration::from_secs(60)
        && data.settings.balancing_enabled
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
                cli::send_request(&data.msg_tx, cli::Request::TestRecvBtc(amount))
            }
            AssetBalancing::SendBtc(amount) => {
                cli::send_request(&data.msg_tx, cli::Request::TestSendBtc(amount))
            }
            AssetBalancing::RecvUsdt(amount) => {
                cli::send_request(&data.msg_tx, cli::Request::TestRecvUsdt(amount))
            }
            AssetBalancing::SendUsdt(amount) => {
                cli::send_request(&data.msg_tx, cli::Request::TestSendUsdt(amount))
            }
        };
    }

    if data.all_exchange_balances_reported != data.all_exchange_balances {
        data.all_exchange_balances_reported = data.all_exchange_balances.clone();
        let balances = data
            .all_exchange_balances_reported
            .iter()
            .map(|(curr, amount)| format!("{}: {:.8}", curr, amount))
            .collect::<Vec<_>>();
        let balance_str = balances.join(", ");
        let message = format!("bfx: {}", &balance_str);
        send_notification(&message, &data.settings.notifications.url);
    }

    balancing::process_balancing(
        &mut data.storage,
        &data.wallet_balances_confirmed,
        &data.exchange_balances,
        data.bfx_connected,
        &data.settings,
        &data.bf_sender,
    )
    .await;

    let check_exchange_age = now.duration_since(data.latest_check_exchange);
    if check_exchange_age > std::time::Duration::from_secs(60) {
        data.msg_tx.send(Msg::CheckExchange).unwrap();
        data.latest_check_exchange = now;
    }

    if let Some(profits) = data.profit_reports.as_mut() {
        if Instant::now().duration_since(profits.created_at) > std::time::Duration::from_secs(60) {
            error!("profit reporting timeout");
            data.profit_reports = None;
        }
    }

    if let Some(profits) = data.profit_reports.as_mut() {
        let balance_wallet_bitcoin_old = profits
            .wallet_balances
            .get(&DealerTicker::LBTC)
            .cloned()
            .unwrap_or_default();
        let balance_wallet_usdt_old = profits
            .wallet_balances
            .get(&DealerTicker::USDt)
            .cloned()
            .unwrap_or_default();
        let balance_wallet_eurx_old = profits
            .wallet_balances
            .get(&DealerTicker::EURx)
            .cloned()
            .unwrap_or_default();
        let balance_exchange_bitcoin_old = profits
            .exchange_balances
            .get(&ExchangeTicker::BTC)
            .cloned()
            .unwrap_or_default();
        let balance_exchange_usdt_old = profits
            .exchange_balances
            .get(&ExchangeTicker::USDt)
            .cloned()
            .unwrap_or_default();
        let balance_exchange_eur_old = profits
            .exchange_balances
            .get(&ExchangeTicker::EUR)
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
                &data.settings.notifications.url,
            );
            data.profit_reports = None;
        }
    }

    let expired_orders = data
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
            &data.settings.notifications.url,
        );
        data.pending_orders.remove(&cid);
    }
}

fn process_bf_worker(data: &mut Data, resp: bitfinex_worker::Response) {
    match resp {
        bitfinex_worker::Response::Withdraw { withdraw_id } => {
            balancing::process_withdraw(&mut data.storage, withdraw_id, &data.settings);
        }
        bitfinex_worker::Response::Transfer { success } => {
            balancing::process_transfer(&mut data.storage, success, &data.settings);
        }
        bitfinex_worker::Response::Movements(msg) => {
            balancing::process_movements(
                &mut data.storage,
                msg,
                &data.settings,
                &mut data.movements,
            );
        }
        bitfinex_worker::Response::OrderSubmit(req, res) => match res {
            Ok(order) => {
                info!("order submit succeed, order_id: {}", order.order_id);
            }
            Err(err) => {
                error!("order submit failed: {}", err);
                data.failed_orders_count += 1;
                data.failed_orders_total += req.amount;

                send_notification(
                    &format!(
                        "bfx order(s) submit failed, count: {}, total: {} btc",
                        data.failed_orders_count, data.failed_orders_total,
                    ),
                    &data.settings.notifications.url,
                );
            }
        },
    }
}

async fn process_bf_event(data: &mut Data, event: bfx_ws_api::Event) {
    match event {
        bfx_ws_api::Event::Connected => {
            data.bfx_connected = true;
            info!("connected to bfx ws");
            send_notification("bfx ws connection online", &data.settings.notifications.url);

            data.msg_tx.send(Msg::CheckExchange).unwrap();
        }

        bfx_ws_api::Event::Disconnected { reason } => {
            data.bfx_connected = false;
            info!("disconnected from bfx ws: {reason}");
            send_notification(
                &format!("bfx ws connection offline: {reason}"),
                &data.settings.notifications.url,
            );
            data.bfx_prices.clear();
            process_timer(data).await;
        }

        bfx_ws_api::Event::WalletBalance {
            wallet_type,
            currency,
            balance,
        } => {
            if wallet_type == bfx_ws_api::WalletType::Exchange {
                info!("exchange balance updated: {}: {}", &currency, balance);
                data.all_exchange_balances.insert(currency.clone(), balance);

                let exchange_ticker = ExchangeTicker::find_bfx_name(data.network, &currency);

                // Some exchange balances are ignored (i.e. USD)
                if let Some(exchange_ticker) = exchange_ticker {
                    let old_balance = data.exchange_balances.get(&exchange_ticker);
                    if old_balance != Some(&balance) {
                        let old_value = data.exchange_balances.insert(exchange_ticker, balance);
                        if old_value.is_some() {
                            data.msg_tx.send(Msg::CheckExchange).unwrap();
                        }
                    }
                }
            }
        }

        bfx_ws_api::Event::OrderCancel {
            symbol,
            cid,
            id,
            amount_orig,
            price_avg,
        } => {
            info!(
                "order created, cid: {}, id: {}, amount: {}, price: {}, symbol: {}",
                cid, id, amount_orig, price_avg, symbol
            );
            let pending_order = data.pending_orders.remove(&cid);
            match pending_order {
                Some(v) => debug!(
                    "order created: {}, {} seconds",
                    cid,
                    std::time::Instant::now().duration_since(v).as_secs_f64()
                ),
                None => debug!("unexpected order: {}", cid),
            }
        }

        bfx_ws_api::Event::BookUpdate { symbol, bid, ask } => {
            let price = Price { bid, ask };
            // debug!("updated price, bid: {}, ask: {}", price.bid, price.ask);
            let exchange_pair =
                ExchangePair::find_bookname(&symbol).expect("book ticker must be known");
            let old_bfx_price = data.bfx_prices.insert(exchange_pair, price);
            if old_bfx_price.is_none() {
                info!("received price");
                send_notification(
                    &format!(
                        "bfx price refreshed: {}/{} for {}",
                        price.ask, price.bid, exchange_pair,
                    ),
                    &data.settings.notifications.url,
                );
            }
        }
    }
}

fn process_msg(data: &mut Data, msg: Msg) {
    match msg {
        Msg::BfWorker(resp) => {
            process_bf_worker(data, resp);
        }

        Msg::Cli(req) => {
            let (new_state, amount, name) = match req.req {
                cli::Request::TestSendUsdt(amount) => {
                    (TransferState::SendUsdtNew, amount, "send usdt")
                }
                cli::Request::TestRecvUsdt(amount) => {
                    (TransferState::RecvUsdtNew, amount, "recv usdt")
                }
                cli::Request::TestSendBtc(amount) => {
                    (TransferState::SendBtcNew, amount, "send btc")
                }
                cli::Request::TestRecvBtc(amount) => {
                    (TransferState::RecvBtcNew, amount, "recv btc")
                }
            };
            let resp = if data.storage.balancing.is_some() {
                cli::Response::Error("already started".to_owned())
            } else {
                data.movements = None;
                data.storage.balancing = Some(Transfer {
                    amount: Amount::from_bitcoin(amount),
                    created_at: std::time::SystemTime::now(),
                    updated_at: std::time::SystemTime::now(),
                    state: new_state,
                    txid: None,
                    withdraw_id: None,
                });
                save_storage(&data.storage, &data.settings.storage_path);
                send_notification(
                    &format!("start balancing, {}, amount: {}", name, amount),
                    &data.settings.notifications.url,
                );
                cli::Response::Success("success".to_owned())
            };
            if let Some(resp_tx) = req.resp_tx {
                let res = resp_tx.send(resp);
                if res.is_err() {
                    log::debug!("cli channel is closed");
                }
            }
        }

        Msg::CheckExchange => {
            if let Some(balancing) = data.storage.balancing.as_ref() {
                if data.bfx_connected {
                    let start = balancing
                        .created_at
                        .checked_sub(std::time::Duration::from_secs(10))
                        .unwrap()
                        .duration_since(std::time::UNIX_EPOCH)
                        .unwrap()
                        .as_millis() as i64;
                    data.bf_sender
                        .send(bitfinex_worker::Request::Movements {
                            start: Some(start),
                            end: None,
                            limit: None,
                        })
                        .unwrap();
                }
            }
        }

        Msg::External(ticker, price_res) => match price_res {
            Ok(price) => {
                data.external_prices.insert(ticker, price);
                get_bfx_price(&data, ticker);
            }
            Err(err) => {
                log::warn!("external price loading failed: {err}");
                data.external_prices.remove(&ticker);
            }
        },
    }
}

fn process_market_event(data: &mut Data, event: market::Event) {
    match event {
        market::Event::SignSwap { quote_id, pset } => {
            let pset = data.utxo_data.sign_pset(pset);
            data.market_command_sender
                .send(market::Command::SignedSwap { quote_id, pset });
        }

        market::Event::NewAddress { res_sender } => {
            let rpc_server = data.settings.rpc.clone();
            tokio::spawn(async move {
                let res = rpc::make_rpc_call(&rpc_server, rpc::GetNewAddressCall {})
                    .await
                    .map_err(|err| anyhow::anyhow!("address loading failed: {err}"));
                res_sender.send(res);
            });
        }

        market::Event::SwapSucceed {
            asset_pair: AssetPair { base, quote },
            trade_dir,
            base_amount,
            quote_amount,
            price,
            txid,
        } => {
            let usdt_asset = data.network.d().known_assets.usdt.asset_id();
            let eurx_asset = data.network.d().known_assets.eurx.asset_id();
            let exchange_pair = if base == data.policy_asset && quote == usdt_asset {
                ExchangePair::BtcUsdt
            } else if base == data.policy_asset && quote == eurx_asset {
                ExchangePair::BtcEur
            } else if base == eurx_asset && quote == usdt_asset {
                ExchangePair::EurUsdt
            } else {
                panic!("unknown asset pair: base: {base}, quote: {quote}");
            };
            let base_amount_float = sat_to_btc(base_amount);
            let quote_amount_float = sat_to_btc(quote_amount);

            send_notification(
                &format!(
                    "market swap, {exchange_pair}, base amount: {base_amount_float}, quote amount: {quote_amount_float}, price: {price}, txid: {txid}",
                ),
                &data.settings.notifications.url,
            );

            match exchange_pair {
                ExchangePair::BtcUsdt | ExchangePair::BtcEur => {
                    info!("start hedging for {exchange_pair}");

                    let bitcoin_amount =
                        sideswap_common::types::Amount::from_bitcoin(base_amount_float);

                    let dealer_send_bitcoins = match trade_dir {
                        TradeDir::Sell => true,
                        TradeDir::Buy => false,
                    };

                    let ticker = exchange_pair.dealer_ticker().expect("must be set");

                    hedge_order(
                        data,
                        SwapSucceed {
                            txid,
                            ticker,
                            bitcoin_amount,
                            dealer_send_bitcoins,
                        },
                    );
                }
                ExchangePair::EurUsdt => {
                    info!("skip hedging for {exchange_pair}");
                }
            }
        }

        market::Event::BroadcastTx { tx } => {
            let rpc_server = data.settings.rpc.clone();
            tokio::spawn(async move {
                let res = rpc::make_rpc_call(&rpc_server, rpc::SendRawTransactionCall { tx }).await;
                match res {
                    Ok(txid) => log::debug!("tx broadcast succeed: {txid}"),
                    Err(err) => log::error!("tx broadcast failed: {err}"),
                }
            });
        }
    }
}

#[tokio::main]
async fn main() {
    let args = std::env::args().collect::<Vec<_>>();
    assert!(
        args.len() == 2,
        "Specify a single argument for the path to the config file"
    );
    let config_path = &args[1];

    let mut conf = config::Config::new();
    conf.merge(config::File::with_name(config_path))
        .expect("can't load config");
    conf.merge(config::Environment::with_prefix("app").separator("_"))
        .expect("reading env failed");
    let settings: Settings = conf.try_into().expect("invalid config");

    let server_url = settings
        .server_url
        .clone()
        .unwrap_or_else(|| settings.env.base_server_ws_url());

    let params = Params {
        env: settings.env,
        server_url: server_url.clone(),
        rpc: settings.rpc.clone(),
        tickers: BTreeSet::from(DEALER_TICKERS),
        bitcoin_amount_submit: Amount::from_bitcoin(settings.bitcoin_amount_submit),
        bitcoin_amount_min: Amount::from_bitcoin(settings.bitcoin_amount_min),
        bitcoin_amount_max: Amount::from_bitcoin(settings.bitcoin_amount_max),
        api_key: settings.api_key.clone(),
    };

    sideswap_dealer::logs::init(&settings.work_dir);

    sideswap_common::panic_handler::install_panic_handler();

    let storage = load_storage(&settings.storage_path).unwrap_or_default();
    let storage_path = settings.storage_path.clone();
    save_storage(&storage, &storage_path);

    let (msg_tx, mut msg_rx) = unbounded_channel::<Msg>();

    let bf_settings = BfSettings {
        bitfinex_key: settings.bitfinex_key.clone(),
        bitfinex_secret: settings.bitfinex_secret.clone(),
    };

    let (bf_sender, bf_receiver) = unbounded_channel::<bitfinex_worker::Request>();
    let msg_tx_copy = UncheckedUnboundedSender::from(msg_tx.clone());
    let bf_settings_copy = bf_settings.clone();
    tokio::task::spawn(bitfinex_worker::run(
        bf_settings_copy,
        bf_receiver,
        move |resp| {
            msg_tx_copy.send(Msg::BfWorker(resp));
        },
    ));

    if let Some(settings) = settings.external_prices.clone() {
        tokio::spawn(external_prices::reload(
            settings,
            UncheckedUnboundedSender::from(msg_tx.clone()),
        ));
    }

    let term_signal = sideswap_dealer::signals::TermSignal::new();

    let (dealer_command_sender, mut dealer_event_receiver) = spawn_async(params.clone());

    let health_text = HealthStatus::default();
    tokio::task::spawn(start_webserver(
        settings.status_port,
        Arc::clone(&health_text),
    ));

    let disable_new_swaps = match settings.env {
        sideswap_common::env::Env::Prod => true,
        sideswap_common::env::Env::Testnet
        | sideswap_common::env::Env::LocalLiquid
        | sideswap_common::env::Env::LocalTestnet => false,
    };

    let market_params = market::Params {
        env: settings.env,
        disable_new_swaps,
        server_url: server_url.clone(),
        work_dir: settings.work_dir.clone(),
        web_server: None,
        ws_server: None,
    };
    let (market_command_sender, mut market_event_receiver) = market::start(market_params);

    let network = settings.env.d().network;
    let mut data = Data {
        settings,
        network,
        policy_asset: network.d().policy_asset.asset_id(),
        server_connected: false,
        bfx_connected: false,
        wallet_balances: WalletBalances::new(),
        wallet_balances_confirmed: WalletBalances::new(),
        exchange_balances: ExchangeBalances::new(),
        all_exchange_balances: AllExchangeBalances::new(),
        all_exchange_balances_reported: AllExchangeBalances::new(),
        profit_reports: None,
        pending_orders: PendingOrders::new(),
        failed_orders_count: 0,
        failed_orders_total: 0.0,
        bfx_prices: BfxPrices::new(),
        external_prices: ExternalPrices::new(),
        health_text,
        storage,
        balancing_blocked: Instant::now(),
        latest_check_exchange: Instant::now(),
        movements: None,
        msg_tx,
        dealer_command_sender,
        bf_sender,
        market_command_sender: market_command_sender.into(),
        utxo_data: UtxoData::new(utxo_data::Params {
            confifential_only: true,
        }),
    };

    let (_bfx_command_sender, bfx_command_receiver) = unbounded_channel::<bfx_ws_api::Command>();
    let (bfx_event_sender, mut bfx_event_receiver) = unbounded_channel::<bfx_ws_api::Event>();
    tokio::spawn(bfx_ws_api::run(
        bf_settings.clone(),
        bfx_command_receiver,
        bfx_event_sender,
    ));

    let msg_tx_copy = data.msg_tx.clone();
    std::thread::spawn(|| {
        cli::start(msg_tx_copy);
    });

    send_notification("dealer started", &data.settings.notifications.url);

    let mut interval = tokio::time::interval(Duration::from_secs(1));

    loop {
        tokio::select! {
            msg = msg_rx.recv() => {
                let msg = msg.expect("channel must be open");
                process_msg(&mut data, msg);
            },

            event = dealer_event_receiver.recv() => {
                let event = event.expect("channel must be open");
                process_dealer_event(&mut data, event).await;
            },

            event = bfx_event_receiver.recv() => {
                let event = event.expect("channel must be open");
                process_bf_event(&mut data, event).await;
            },

            event = market_event_receiver.recv() => {
                let event = event.expect("channel must be open");
                process_market_event(&mut data, event);
            },

            _ = interval.tick() => {
                process_timer(&mut data).await;
            },

            _ = term_signal.recv() => {
                break;
            },
        }
    }
}
