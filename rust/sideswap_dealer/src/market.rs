//! New market swap API (replaces both old swap API and instant swaps)

use std::{
    collections::{BTreeMap, BTreeSet},
    time::Duration,
};

use controller::Controller;
use elements::{
    confidential::{AssetBlindingFactor, ValueBlindingFactor},
    pset::PartiallySignedTransaction,
    Address, AssetId, OutPoint, Txid,
};
use sideswap_api::{
    mkt::{
        self, AssetPair, AssetType, HistId, MarketInfo, Notification, OrdId, QuoteId, QuoteSubId,
        Request, TradeDir,
    },
    Asset, AssetsRequestParam, MarketType, RequestId, ResponseMessage, Utxo,
};
use sideswap_common::{
    b64,
    channel_helpers::{UncheckedOneshotSender, UncheckedUnboundedSender},
    dealer_ticker::{dealer_ticker_from_asset_id, dealer_ticker_to_asset_id, DealerTicker},
    exchange_pair::ExchangePair,
    make_market_request, make_request,
    network::Network,
    types::{asset_float_amount_, asset_int_amount_},
    verify,
    ws::{
        auto::{WrappedRequest, WrappedResponse},
        ws_req_sender::{self, WsReqSender},
    },
};
use sideswap_types::{
    asset_precision::AssetPrecision,
    normal_float::{NormalFloat, NotNormalError},
    timestamp_ms::TimestampMs,
    utxo_ext::UtxoExt,
};
use tokio::sync::{
    mpsc::{unbounded_channel, UnboundedReceiver, UnboundedSender},
    oneshot,
};

mod api;
mod api_helpers;
mod controller;
mod persistent_state;
mod web_server;
mod ws_server;

pub use web_server::Config as WebServerConfig;
pub use ws_server::Config as WsServerConfig;

#[derive(Debug, Clone)]
pub struct Params {
    pub env: sideswap_common::env::Env,
    pub disable_new_swaps: bool,
    pub server_url: String,
    pub work_dir: String,
    pub web_server: Option<WebServerConfig>,
    pub ws_server: Option<WsServerConfig>,
}

// Public messages

pub struct AutomaticOrder {
    pub asset_pair: AssetPair,
    pub trade_dir: TradeDir,
    pub base_amount: u64,
    pub price: NormalFloat,
}

pub enum Command {
    AutomaticOrders {
        orders: Vec<AutomaticOrder>,
    },
    Utxos {
        utxos: Vec<Utxo>,
    },
    Gaid {
        gaid: String,
    },
    SignedSwap {
        quote_id: QuoteId,
        pset: PartiallySignedTransaction,
    },
}

pub enum Event {
    SignSwap {
        quote_id: QuoteId,
        pset: PartiallySignedTransaction,
    },
    NewAddress {
        res_sender: UncheckedOneshotSender<Result<Address, anyhow::Error>>,
    },
    SwapSucceed {
        asset_pair: AssetPair,
        trade_dir: TradeDir,
        base_amount: u64,
        quote_amount: u64,
        price: NormalFloat,
        txid: Txid,
    },
    BroadcastTx {
        tx: String,
    },
}

// Private messages

struct Market {
    base: DealerTicker,
    quote: DealerTicker,
}

struct Metadata {
    server_connected: bool,
    assets: Vec<Asset>,
    markets: Vec<Market>,
}

type Balance = BTreeMap<DealerTicker, f64>;

#[derive(Clone, Default, PartialEq)]
struct Balances {
    balance: Balance,
}

#[derive(Clone)]
struct PublicOrder {
    order_id: OrdId,
    trade_dir: TradeDir,
    amount: f64,
    price: NormalFloat,
    online: bool,
}

#[derive(Clone)]
struct OrderBook {
    orders: Vec<PublicOrder>,
}

#[derive(Clone)]
struct OwnOrders {
    orders: Vec<OwnOrder>,
}

#[derive(Clone)]
struct OwnOrder {
    exchange_pair: ExchangePair,
    order_id: OrdId,
    client_order_id: Option<Box<String>>,
    trade_dir: TradeDir,
    orig_amount: f64,
    active_amount: f64,
    price: NormalFloat,
}

struct HistoryOrders {
    orders: Vec<HistoryOrder>,
    total: usize,
}

#[derive(Clone)]
struct HistoryOrder {
    id: HistId,
    order_id: OrdId,
    client_order_id: Option<Box<String>>,
    exchange_pair: ExchangePair,
    trade_dir: TradeDir,
    base_amount: f64,
    quote_amount: f64,
    price: NormalFloat,
    txid: Option<Txid>,
    status: mkt::HistStatus,
}

struct StartQuotesReq {
    client_id: ClientId,
    asset_pair: AssetPair,
    asset_type: AssetType,
    amount: u64,
    trade_dir: TradeDir,
    order_id: Option<OrdId>,
    private_id: Option<Box<String>>,
    receive_address: Address,
    change_address: Address,
}

struct StartQuotesResp {
    quote_sub_id: QuoteSubId,
    fee_asset: AssetType,
}

struct AcceptQuoteReq {
    quote_id: QuoteId,
}

struct AcceptQuoteResp {
    txid: elements::Txid,
}

#[derive(Debug, thiserror::Error)]
enum Error {
    #[error("WS request error: {0}")]
    WsRequestError(#[from] ws_req_sender::Error),
    #[error("Unexpected response, expected: {0}")]
    UnexpectedResponse(&'static str),
    #[error("Server connection is down")]
    ServerDisconnected,
    #[error("Channel closed, please report bug")]
    ChannelClosed,
    #[error("Unknown ticker: {0}")]
    UnknownTicker(String),
    #[error("Invalid float: {0}")]
    InvalidFloat(NotNormalError),
    #[error("No gaid")]
    NoGaid,
    #[error("Wallet error: {0}")]
    WalletError(anyhow::Error),
    #[error("Unknown order id")]
    UnknownOrderId,
    #[error("Unknown asset id: {0}")]
    UnknownAssetId(AssetId),
    #[error("Invalid asset amount: {0} (asset_precison: {1})")]
    InvalidAssetAmount(f64, AssetPrecision),
}

impl Error {
    fn text(&self) -> String {
        self.to_string()
    }

    fn code(&self) -> api::ErrorCode {
        match self {
            Error::ChannelClosed
            | Error::WsRequestError(_)
            | Error::UnexpectedResponse(_)
            | Error::NoGaid
            | Error::WalletError(_)
            | Error::ServerDisconnected => api::ErrorCode::ServerError,
            Error::UnknownTicker(_)
            | Error::InvalidFloat(_)
            | Error::UnknownOrderId
            | Error::UnknownAssetId(_)
            | Error::InvalidAssetAmount(_, _) => api::ErrorCode::InvalidRequest,
        }
    }

    fn details(&self) -> Option<api::ErrorDetails> {
        match self {
            Error::ChannelClosed
            | Error::WsRequestError(_)
            | Error::UnexpectedResponse(_)
            | Error::NoGaid
            | Error::WalletError(_)
            | Error::ServerDisconnected
            | Error::UnknownTicker(_)
            | Error::InvalidFloat(_)
            | Error::UnknownOrderId
            | Error::UnknownAssetId(_)
            | Error::InvalidAssetAmount(_, _) => None,
        }
    }
}

impl From<mkt::HistStatus> for api::HistOrderStatus {
    fn from(value: mkt::HistStatus) -> Self {
        match value {
            mkt::HistStatus::Mempool => api::HistOrderStatus::Mempool,
            mkt::HistStatus::Confirmed => api::HistOrderStatus::Confirmed,
            mkt::HistStatus::TxConflict => api::HistOrderStatus::TxConflict,
            mkt::HistStatus::TxNotFound => api::HistOrderStatus::TxNotFound,
            mkt::HistStatus::Elapsed => api::HistOrderStatus::Elapsed,
            mkt::HistStatus::Cancelled => api::HistOrderStatus::Cancelled,
            mkt::HistStatus::UtxoInvalidated => api::HistOrderStatus::UtxoInvalidated,
            mkt::HistStatus::Replaced => api::HistOrderStatus::Replaced,
        }
    }
}

impl From<sideswap_api::Asset> for api::Asset {
    fn from(value: sideswap_api::Asset) -> Self {
        api::Asset {
            asset_id: value.asset_id.to_string(),
            name: value.name,
            ticker: value.ticker.0,
            precision: value.precision.value(),
        }
    }
}

#[derive(Clone)]
enum ClientEvent {
    Balances {
        balances: Balances,
    },
    ServerConnected {
        own_orders: OwnOrders,
    },
    OrderAdded {
        exchange_pair: ExchangePair,
        order: PublicOrder,
    },
    OrderRemoved {
        exchange_pair: ExchangePair,
        order_id: OrdId,
    },
    OwnOrderAdded {
        order: OwnOrder,
    },
    OwnOrderRemoved {
        order_id: OrdId,
    },
    MarketPrice {
        exchange_pair: ExchangePair,
        ind_price: Option<NormalFloat>,
        last_price: Option<NormalFloat>,
    },
    HistoryUpdated {
        order: HistoryOrder,
        is_new: bool,
    },
    Quote {
        notif: api::QuoteNotif,
    },
}

enum ClientCommand {
    Metadata {
        res_sender: UncheckedOneshotSender<Metadata>,
    },
    GetAsset {
        asset_id: AssetId,
        res_sender: UncheckedOneshotSender<Result<Asset, Error>>,
    },
    GetGaid {
        res_sender: UncheckedOneshotSender<Result<String, Error>>,
    },
    NewAddress {
        res_sender: UncheckedOneshotSender<Result<Address, anyhow::Error>>,
    },
    Balances {
        res_sender: UncheckedOneshotSender<Balances>,
    },
    OrderBook {
        exchange_pair: ExchangePair,
        res_sender: UncheckedOneshotSender<Result<OrderBook, Error>>,
    },
    GetOwnOrder {
        order_id: OrdId,
        res_sender: UncheckedOneshotSender<Result<OwnOrder, Error>>,
    },
    GetOwnOrders {
        res_sender: UncheckedOneshotSender<Result<OwnOrders, Error>>,
    },
    GetHistory {
        start_time: Option<TimestampMs>,
        end_time: Option<TimestampMs>,
        skip: Option<usize>,
        count: Option<usize>,
        res_sender: UncheckedOneshotSender<Result<HistoryOrders, Error>>,
    },

    ResolveGaid {
        asset_id: AssetId,
        gaid: String,
        res_sender: UncheckedOneshotSender<Result<Address, Error>>,
    },

    SubmitOrder {
        exchange_pair: ExchangePair,
        base_amount: f64,
        price: NormalFloat,
        trade_dir: TradeDir,
        client_order_id: Option<Box<String>>,
        receive_address: Address,
        change_address: Address,
        res_sender: UncheckedOneshotSender<Result<OwnOrder, Error>>,
    },
    EditOrder {
        order_id: OrdId,
        base_amount: Option<u64>,
        price: Option<NormalFloat>,
        res_sender: UncheckedOneshotSender<Result<OwnOrder, Error>>,
    },
    CancelOrder {
        order_id: OrdId,
        res_sender: UncheckedOneshotSender<Result<(), Error>>,
    },

    ClientConnected {
        client_id: ClientId,
        event_sender: UncheckedUnboundedSender<ClientEvent>,
    },
    ClientDisconnected {
        client_id: ClientId,
    },
    WsSubscribe {
        client_id: ClientId,
        exchange_pair: ExchangePair,
        res_sender: UncheckedOneshotSender<Result<OrderBook, Error>>,
    },
    WsStartQuotes {
        req: StartQuotesReq,
        res_sender: UncheckedOneshotSender<Result<StartQuotesResp, Error>>,
    },
    WsStopQuotes {},
    WsAcceptQuote {
        req: AcceptQuoteReq,
        res_sender: UncheckedOneshotSender<Result<AcceptQuoteResp, Error>>,
    },
}

#[derive(Copy, Clone, PartialEq, Eq, PartialOrd, Ord)]
struct ClientId(u64);

#[derive(Default)]
struct OrderData {
    dealer_orders: Vec<AutomaticOrder>,
    server_orders: BTreeMap<OrdId, mkt::OwnOrder>,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Mode {
    PriceStream,
    WebServer,
}

impl Mode {
    fn check_ws_edit_allowed(self) {
        match self {
            Mode::PriceStream => {
                panic!("Web server is not allowed to control orders");
            }
            Mode::WebServer => {}
        }
    }
}

type ClientSender = UncheckedUnboundedSender<ClientEvent>;

struct PublicSubscribe {
    orders: BTreeMap<OrdId, PublicOrder>,
    clients: BTreeMap<ClientId, ClientSender>,
    last_price: Option<NormalFloat>,
    ind_price: Option<NormalFloat>,
}

type OrderGroupKey = (AssetPair, TradeDir);

struct StartedQuote {
    client_id: ClientId,
    quote_sub_id: QuoteSubId,
    fee_asset: AssetType,
    base_trade_dir: TradeDir,
}

struct AcceptingQuote {
    res_sender: UncheckedOneshotSender<Result<AcceptQuoteResp, Error>>,
}

struct Data {
    network: Network,
    mode: Mode,
    work_dir: String,
    state: persistent_state::Data,

    ws: WsReqSender,
    async_requests: BTreeMap<RequestId, WsCallback>,

    wallet_utxos: Vec<Utxo>, // Only confidential UTXOs here
    server_utxos: BTreeSet<OutPoint>,

    // Kept in sync with wallet_utxos
    balances: Balances,

    gaid: Option<String>,
    assets: Vec<Asset>,
    amp_assets: BTreeSet<AssetId>,

    orders: BTreeMap<OrderGroupKey, OrderData>,

    event_sender: UncheckedUnboundedSender<Event>,

    markets: BTreeMap<AssetPair, MarketInfo>,

    clients: BTreeMap<ClientId, ClientSender>,

    subscribed: BTreeMap<ExchangePair, PublicSubscribe>,

    started_quote: Option<StartedQuote>,

    accepting_quotes: BTreeMap<QuoteId, AcceptingQuote>,
}

impl From<tokio::sync::oneshot::error::RecvError> for Error {
    fn from(_value: tokio::sync::oneshot::error::RecvError) -> Self {
        Error::ChannelClosed
    }
}

impl<T> From<tokio::sync::mpsc::error::SendError<T>> for Error {
    fn from(_value: tokio::sync::mpsc::error::SendError<T>) -> Self {
        Error::ChannelClosed
    }
}

fn get_exchange_pair(asset_pair: &AssetPair, network: Network) -> Option<ExchangePair> {
    let base = dealer_ticker_from_asset_id(network, &asset_pair.base)?;
    let quote = dealer_ticker_from_asset_id(network, &asset_pair.quote)?;
    Some(ExchangePair { base, quote })
}

fn convert_public_order(order: &mkt::PublicOrder, base_precision: AssetPrecision) -> PublicOrder {
    PublicOrder {
        order_id: order.order_id,
        trade_dir: order.trade_dir,
        amount: asset_float_amount_(order.amount, base_precision),
        price: order.price,
        online: order.online,
    }
}

fn convert_own_order(order: &mkt::OwnOrder, network: Network) -> Option<OwnOrder> {
    let exchange_pair = get_exchange_pair(&order.asset_pair, network)?;
    let base_precision = exchange_pair.base.asset_precision();

    Some(OwnOrder {
        exchange_pair,
        order_id: order.order_id,
        client_order_id: order.client_order_id.clone(),
        trade_dir: order.trade_dir,
        orig_amount: asset_float_amount_(order.orig_amount, base_precision),
        active_amount: asset_float_amount_(order.active_amount, base_precision),
        price: order.price,
    })
}

fn convert_history_order(order: &mkt::HistoryOrder, network: Network) -> Option<HistoryOrder> {
    let exchange_pair = get_exchange_pair(&order.asset_pair, network)?;
    let base_precision = exchange_pair.base.asset_precision();
    let quote_precision = exchange_pair.quote.asset_precision();

    Some(HistoryOrder {
        id: order.id,
        order_id: order.order_id,
        client_order_id: order.client_order_id.clone(),
        exchange_pair,
        trade_dir: order.trade_dir,
        base_amount: asset_float_amount_(order.base_amount, base_precision),
        quote_amount: asset_float_amount_(order.quote_amount, quote_precision),
        price: order.price,
        txid: order.txid,
        status: order.status,
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

fn save_state(data: &Data) {
    persistent_state::save(&data.work_dir, &data.state);
}

type WsCallback = Box<dyn FnOnce(&mut Data, Result<mkt::Response, Error>) + Send>;

fn ws_callback(data: &mut Data, req: mkt::Request, callback: WsCallback) {
    if !data.ws.connected() {
        callback(
            data,
            Err(Error::WsRequestError(ws_req_sender::Error::Disconnected)),
        );
        return;
    }

    let request_id = data.ws.send_request(sideswap_api::Request::Market(req));
    data.async_requests.insert(request_id, callback);
}

async fn try_login(data: &mut Data) -> Result<mkt::LoginResponse, anyhow::Error> {
    let assets = make_request!(
        data.ws,
        Assets,
        Some(AssetsRequestParam {
            embedded_icons: Some(false),
            all_assets: Some(true),
            amp_asset_restrictions: Some(false)
        })
    )?;

    for asset in assets.assets.iter() {
        let ticker = dealer_ticker_from_asset_id(data.network, &asset.asset_id);
        if let Some(ticker) = ticker {
            let expected = ticker.asset_precision();
            let actual = asset.precision;
            assert_eq!(
                expected, actual,
                "invalid asset precision: {actual}, expected: {expected}, ticker: {ticker}"
            );
        }
    }

    data.amp_assets = assets
        .assets
        .iter()
        .filter_map(|asset| (asset.market_type == Some(MarketType::Amp)).then_some(asset.asset_id))
        .collect();

    data.assets = assets.assets;

    let resp = make_market_request!(data.ws, ListMarkets, mkt::ListMarketsRequest {})?;
    data.markets = resp
        .markets
        .into_iter()
        .map(|market| (market.asset_pair, market))
        .collect();

    if let Some(token) = &data.state.token {
        let res = make_market_request!(
            data.ws,
            Login,
            mkt::LoginRequest {
                token: token.clone(),
                is_mobile: false,
                is_jade: false,
                event_count: 0,
            }
        );

        match res {
            Ok(resp) => return Ok(resp),
            Err(err) if err.error_code() == sideswap_api::ErrorCode::UnknownToken => {
                log::warn!("token not found: {err}");
                data.state.token = None;
            }
            Err(err) => {
                anyhow::bail!("unexpected login error: {err}");
            }
        }
    }

    log::debug!("register...");

    let mkt::RegisterResponse { token } =
        make_market_request!(data.ws, Register, mkt::RegisterRequest { wallet_key: None })?;

    let resp = make_market_request!(
        data.ws,
        Login,
        mkt::LoginRequest {
            token: token.clone(),
            is_mobile: false,
            is_jade: false,
            event_count: 0,
        }
    )?;

    data.state.token = Some(token);
    save_state(data);

    Ok(resp)
}

async fn process_ws_connected(data: &mut Data) {
    let mkt::LoginResponse {
        orders,
        utxos,
        new_events: _,
    } = try_login(data).await.expect("login failed unexpectedly");

    for orders in data.orders.values_mut() {
        orders.server_orders.clear();
    }

    for order in orders {
        data.orders
            .entry((order.asset_pair, order.trade_dir))
            .or_default()
            .server_orders
            .insert(order.order_id, order);
    }

    data.server_utxos = utxos.into_iter().collect();

    for event_sender in data.clients.values() {
        event_sender.send(ClientEvent::ServerConnected {
            own_orders: get_own_orders(data).expect("must not fail"),
        });
    }
}

fn process_ws_disconnected(data: &mut Data) {
    for market in data.orders.values_mut() {
        market.server_orders.clear();
    }

    // This will disconnect all WS clients, we need to force them to re-subscribe
    data.clients.clear();
    data.subscribed.clear();
    data.started_quote = None;

    let async_requests = std::mem::take(&mut data.async_requests);
    for request in async_requests.into_values() {
        request(
            data,
            Err(Error::WsRequestError(ws_req_sender::Error::Disconnected)),
        );
    }
}

fn process_sign_notif(data: &mut Data, notif: mkt::MakerSignNotif) {
    let pset = b64::decode(&notif.pset).expect("invalid base64 pset");
    let pset =
        elements::encode::deserialize::<PartiallySignedTransaction>(&pset).expect("invalid pset");

    // FIXME: Verify PSET amounts

    data.event_sender.send(Event::SignSwap {
        quote_id: notif.quote_id,
        pset,
    });
}

struct GetQuoteAmounts {
    exchange_pair: ExchangePair,
    base_trade_dir: TradeDir,
    fee_asset: AssetType,
    base_amount: u64,
    quote_amount: u64,
    server_fee: u64,
    fixed_fee: u64,
}

struct QuoteAmounts {
    base_amount: f64,
    quote_amount: f64,
    server_fee: f64,
    fixed_fee: f64,
    deliver_asset: DealerTicker,
    receive_asset: DealerTicker,
    deliver_amount: f64,
    receive_amount: f64,
}

fn get_quote_amounts(
    GetQuoteAmounts {
        exchange_pair,
        base_trade_dir,
        fee_asset,
        base_amount,
        quote_amount,
        server_fee,
        fixed_fee,
    }: GetQuoteAmounts,
) -> QuoteAmounts {
    let total_fee = server_fee + fixed_fee;

    let (deliver_amount, receive_amount) = match (base_trade_dir, fee_asset) {
        (TradeDir::Sell, AssetType::Base) => (base_amount + total_fee, quote_amount),
        (TradeDir::Sell, AssetType::Quote) => (base_amount, quote_amount - total_fee),
        (TradeDir::Buy, AssetType::Base) => (quote_amount, base_amount - total_fee),
        (TradeDir::Buy, AssetType::Quote) => (quote_amount + total_fee, base_amount),
    };

    let fee_asset = exchange_pair.asset(fee_asset);

    let (deliver_asset, receive_asset) = match base_trade_dir {
        TradeDir::Sell => (exchange_pair.base, exchange_pair.quote),
        TradeDir::Buy => (exchange_pair.quote, exchange_pair.base),
    };

    QuoteAmounts {
        base_amount: asset_float_amount_(base_amount, exchange_pair.base.asset_precision()),
        quote_amount: asset_float_amount_(quote_amount, exchange_pair.quote.asset_precision()),
        server_fee: asset_float_amount_(server_fee, fee_asset.asset_precision()),
        fixed_fee: asset_float_amount_(fixed_fee, fee_asset.asset_precision()),
        deliver_asset,
        receive_asset,
        deliver_amount: asset_float_amount_(deliver_amount, deliver_asset.asset_precision()),
        receive_amount: asset_float_amount_(receive_amount, receive_asset.asset_precision()),
    }
}

fn process_quote(data: &mut Data, notif: mkt::QuoteNotif) {
    let started_quote = match data.started_quote.as_ref() {
        Some(started_quote) => started_quote,
        None => return,
    };

    if started_quote.quote_sub_id != notif.quote_sub_id {
        return;
    }

    let client = data
        .clients
        .get(&started_quote.client_id)
        .expect("must exist");

    let exchange_pair = get_exchange_pair(&notif.asset_pair, data.network).expect("must be known");
    let fee_asset = started_quote.fee_asset;
    let base_trade_dir = started_quote.base_trade_dir;

    let notif = api::QuoteNotif {
        quote_sub_id: notif.quote_sub_id,
        status: match notif.status {
            mkt::QuoteStatus::Success {
                quote_id,
                base_amount,
                quote_amount,
                server_fee,
                fixed_fee,
                ttl,
            } => {
                let QuoteAmounts {
                    base_amount,
                    quote_amount,
                    server_fee,
                    fixed_fee,
                    deliver_asset,
                    receive_asset,
                    deliver_amount,
                    receive_amount,
                } = get_quote_amounts(GetQuoteAmounts {
                    exchange_pair,
                    base_trade_dir,
                    fee_asset,
                    base_amount,
                    quote_amount,
                    server_fee,
                    fixed_fee,
                });
                api::QuoteStatus::Success {
                    quote_id,
                    base_amount,
                    quote_amount,
                    server_fee,
                    fixed_fee,
                    deliver_asset,
                    receive_asset,
                    deliver_amount,
                    receive_amount,
                    ttl,
                }
            }
            mkt::QuoteStatus::LowBalance {
                base_amount,
                quote_amount,
                server_fee,
                fixed_fee,
                available,
            } => {
                let QuoteAmounts {
                    base_amount,
                    quote_amount,
                    server_fee,
                    fixed_fee,
                    deliver_asset,
                    receive_asset,
                    deliver_amount,
                    receive_amount,
                } = get_quote_amounts(GetQuoteAmounts {
                    exchange_pair,
                    base_trade_dir,
                    fee_asset,
                    base_amount,
                    quote_amount,
                    server_fee,
                    fixed_fee,
                });

                let available = asset_float_amount_(available, deliver_asset.asset_precision());

                api::QuoteStatus::LowBalance {
                    base_amount,
                    quote_amount,
                    server_fee,
                    fixed_fee,
                    deliver_asset,
                    receive_asset,
                    deliver_amount,
                    receive_amount,
                    available,
                }
            }
            mkt::QuoteStatus::Error { error_msg } => api::QuoteStatus::Error { error_msg },
        },
    };
    client.send(ClientEvent::Quote { notif });
}

fn process_market_notif(data: &mut Data, notif: Notification) {
    match notif {
        Notification::MarketAdded(notif) => {
            data.markets.insert(notif.market.asset_pair, notif.market);
        }

        Notification::MarketRemoved(notif) => {
            data.markets.remove(&notif.asset_pair);
        }

        Notification::OwnOrderCreated(notif) => {
            let order = convert_own_order(&notif.order, data.network).expect("must not fail");

            data.orders
                .entry((notif.order.asset_pair, notif.order.trade_dir))
                .or_default()
                .server_orders
                .insert(notif.order.order_id, notif.order);

            for event_sender in data.clients.values() {
                event_sender.send(ClientEvent::OwnOrderAdded {
                    order: order.clone(),
                });
            }
        }

        Notification::OwnOrderRemoved(notif) => {
            for market in data.orders.values_mut() {
                market.server_orders.remove(&notif.order_id);
            }

            for event_sender in data.clients.values() {
                event_sender.send(ClientEvent::OwnOrderRemoved {
                    order_id: notif.order_id,
                });
            }
        }

        Notification::UtxoAdded(notif) => {
            data.server_utxos.insert(notif.utxo);
        }

        Notification::UtxoRemoved(notif) => {
            data.server_utxos.remove(&notif.utxo);
        }

        Notification::PublicOrderCreated(notif) => {
            let exchange_pair =
                get_exchange_pair(&notif.order.asset_pair, data.network).expect("must be known");
            let subscribed = data
                .subscribed
                .get_mut(&exchange_pair)
                .expect("must be known");

            let base_precision = exchange_pair.base.asset_precision();
            let order = convert_public_order(&notif.order, base_precision);

            for event_sender in subscribed.clients.values() {
                event_sender.send(ClientEvent::OrderAdded {
                    exchange_pair,
                    order: order.clone(),
                });
            }

            subscribed.orders.insert(order.order_id, order);
        }

        Notification::PublicOrderRemoved(notif) => {
            let exchange_pair =
                get_exchange_pair(&notif.asset_pair, data.network).expect("must be known");
            let subscribed = data
                .subscribed
                .get_mut(&exchange_pair)
                .expect("must be known");

            for event_sender in subscribed.clients.values() {
                event_sender.send(ClientEvent::OrderRemoved {
                    exchange_pair,
                    order_id: notif.order_id,
                });
            }

            subscribed.orders.remove(&notif.order_id);
        }

        Notification::MakerSign(notif) => {
            process_sign_notif(data, notif);
        }

        Notification::Quote(notif) => {
            process_quote(data, notif);
        }

        Notification::MarketPrice(notif) => {
            let exchange_pair =
                get_exchange_pair(&notif.asset_pair, data.network).expect("must be known");
            let subscribed = data
                .subscribed
                .get_mut(&exchange_pair)
                .expect("must be known");

            subscribed.ind_price = notif.ind_price;
            subscribed.last_price = notif.last_price;

            for event_sender in subscribed.clients.values() {
                event_sender.send(ClientEvent::MarketPrice {
                    exchange_pair,
                    ind_price: notif.ind_price,
                    last_price: notif.last_price,
                });
            }
        }

        Notification::ChartUpdate(_) => {}

        Notification::HistoryUpdated(notif) => {
            if let Some(txid) = notif.order.txid {
                if notif.is_new {
                    data.event_sender.send(Event::SwapSucceed {
                        asset_pair: notif.order.asset_pair,
                        trade_dir: notif.order.trade_dir,
                        base_amount: notif.order.base_amount,
                        quote_amount: notif.order.quote_amount,
                        price: notif.order.price,
                        txid,
                    });
                }

                let order =
                    convert_history_order(&notif.order, data.network).expect("must not fail");

                for event_sender in data.clients.values() {
                    event_sender.send(ClientEvent::HistoryUpdated {
                        order: order.clone(),
                        is_new: notif.is_new,
                    });
                }
            }
        }

        Notification::NewEvent(_) => {}

        Notification::TxBroadcast(notif) => {
            data.event_sender.send(Event::BroadcastTx { tx: notif.tx });
        }
    }
}

async fn process_ws_event(data: &mut Data, event: WrappedResponse) {
    match event {
        WrappedResponse::Connected => {
            process_ws_connected(data).await;
        }

        WrappedResponse::Disconnected => {
            process_ws_disconnected(data);
        }

        WrappedResponse::Response(ResponseMessage::Response(req_id, res)) => {
            let req_id = req_id.expect("mut be set");
            let ws_callback = data.async_requests.remove(&req_id);
            if let Some(callback) = ws_callback {
                let res = match res {
                    Ok(sideswap_api::Response::Market(resp)) => Ok(resp),
                    Ok(_) => Err(Error::WsRequestError(
                        ws_req_sender::Error::UnexpectedResponse,
                    )),
                    Err(err) => Err(Error::WsRequestError(ws_req_sender::Error::BackendError(
                        err.message,
                        err.code,
                    ))),
                };
                callback(data, res);
            }
        }

        WrappedResponse::Response(ResponseMessage::Notification(
            sideswap_api::Notification::Market(notif),
        )) => {
            process_market_notif(data, notif);
        }

        WrappedResponse::Response(ResponseMessage::Notification(_)) => {}
    }
}

async fn subscribe(
    data: &mut Data,
    exchange_pair: ExchangePair,
    client_id: Option<ClientId>,
) -> Result<OrderBook, Error> {
    verify!(data.ws.connected(), Error::ServerDisconnected);

    let new_market = !data.subscribed.contains_key(&exchange_pair);

    if new_market {
        let asset_pair = AssetPair {
            base: dealer_ticker_to_asset_id(data.network, exchange_pair.base),
            quote: dealer_ticker_to_asset_id(data.network, exchange_pair.quote),
        };

        let resp = make_market_request!(data.ws, Subscribe, mkt::SubscribeRequest { asset_pair })?;
        let base_precision = exchange_pair.base.asset_precision();
        let orders = resp
            .orders
            .into_iter()
            .map(|order| (order.order_id, convert_public_order(&order, base_precision)))
            .collect();

        data.subscribed.insert(
            exchange_pair,
            PublicSubscribe {
                orders,
                clients: BTreeMap::new(),
                ind_price: None,
                last_price: None,
            },
        );
    }

    let subscribed = data.subscribed.get_mut(&exchange_pair).expect("must exist");

    let order_book = OrderBook {
        orders: subscribed.orders.values().cloned().collect(),
    };

    if let Some(client_id) = client_id {
        let client_event = data.clients.get(&client_id).expect("must exist");
        subscribed.clients.insert(client_id, client_event.clone());

        if !new_market {
            client_event.send(ClientEvent::MarketPrice {
                exchange_pair,
                ind_price: subscribed.ind_price,
                last_price: subscribed.last_price,
            });
        }
    }

    Ok(order_book)
}

fn start_quotes(
    data: &mut Data,
    StartQuotesReq {
        client_id,
        asset_pair,
        asset_type,
        amount,
        trade_dir,
        order_id,
        private_id,
        receive_address,
        change_address,
    }: StartQuotesReq,
    res_sender: UncheckedOneshotSender<Result<StartQuotesResp, Error>>,
) {
    stop_quotes(data);

    let base_trade_dir = trade_dir.base_trade_dir(asset_type);
    let send_asset = TradeDir::send_asset(base_trade_dir);
    let send_asset_id = asset_pair.asset(send_asset);

    let utxos = data
        .wallet_utxos
        .iter()
        .filter(|utxo| utxo.asset == send_asset_id)
        .cloned()
        .collect();

    ws_callback(
        data,
        Request::StartQuotes(mkt::StartQuotesRequest {
            asset_pair,
            asset_type,
            amount,
            trade_dir,
            utxos,
            receive_address,
            change_address,
            order_id,
            private_id,
        }),
        Box::new(move |data, res| {
            let res = match res {
                Ok(mkt::Response::StartQuotes(resp)) => {
                    data.started_quote = Some(StartedQuote {
                        client_id,
                        quote_sub_id: resp.quote_sub_id,
                        fee_asset: resp.fee_asset,
                        base_trade_dir,
                    });

                    Ok(StartQuotesResp {
                        quote_sub_id: resp.quote_sub_id,
                        fee_asset: resp.fee_asset,
                    })
                }
                Ok(_) => Err(Error::UnexpectedResponse("StartQuotes")),
                Err(err) => Err(err),
            };
            res_sender.send(res);
        }),
    );
}

fn stop_quotes(data: &mut Data) {
    data.started_quote = None;

    ws_callback(
        data,
        Request::StopQuotes(mkt::StopQuotesRequest {}),
        Box::new(move |_data, res| {
            let res = match res {
                Ok(mkt::Response::StopQuotes(_resp)) => Ok(()),
                Ok(_) => Err(Error::UnexpectedResponse("StopQuotes")),
                Err(err) => Err(err),
            };
            if let Err(err) = res {
                log::error!("stopping quotes failed: {err}");
            }
        }),
    );
}

fn accept_quote(
    data: &mut Data,
    AcceptQuoteReq { quote_id }: AcceptQuoteReq,
    res_sender: UncheckedOneshotSender<Result<AcceptQuoteResp, Error>>,
) {
    ws_callback(
        data,
        Request::GetQuote(mkt::GetQuoteRequest { quote_id }),
        Box::new(move |data, res| {
            let res = match res {
                Ok(mkt::Response::GetQuote(resp)) => Ok(resp),
                Ok(_) => Err(Error::UnexpectedResponse("GetQuote")),
                Err(err) => Err(err),
            };
            match res {
                Ok(resp) => {
                    sign_accepted_quote(data, quote_id, resp, res_sender);
                }
                Err(err) => {
                    res_sender.send(Err(err));
                }
            }
        }),
    );
}

fn sign_accepted_quote(
    data: &mut Data,
    quote_id: QuoteId,
    mkt::GetQuoteResponse { pset, ttl: _ }: mkt::GetQuoteResponse,
    res_sender: UncheckedOneshotSender<Result<AcceptQuoteResp, Error>>,
) {
    data.accepting_quotes
        .insert(quote_id, AcceptingQuote { res_sender });

    // FIXME: Verify PSET amounts

    let pset = b64::decode(&pset).expect("invalid base64 pset");
    let pset =
        elements::encode::deserialize::<PartiallySignedTransaction>(&pset).expect("invalid pset");

    data.event_sender.send(Event::SignSwap { quote_id, pset });
}

fn signed_accepted_quote(
    data: &mut Data,
    quote_id: QuoteId,
    pset: String,
    AcceptingQuote { res_sender }: AcceptingQuote,
) {
    ws_callback(
        data,
        Request::TakerSign(mkt::TakerSignRequest { quote_id, pset }),
        Box::new(move |data, res| {
            let res = match res {
                Ok(mkt::Response::TakerSign(resp)) => {
                    stop_quotes(data);
                    Ok(AcceptQuoteResp { txid: resp.txid })
                }
                Ok(_) => Err(Error::UnexpectedResponse("TakerSign")),
                Err(err) => Err(err),
            };
            res_sender.send(res);
        }),
    );
}

async fn new_address(event_sender: &UncheckedUnboundedSender<Event>) -> Result<Address, Error> {
    let (res_sender, res_receiver) = oneshot::channel();
    event_sender.send(Event::NewAddress {
        res_sender: res_sender.into(),
    });
    let address = res_receiver.await?.map_err(Error::WalletError)?;
    Ok(address)
}

fn get_own_order(data: &Data, order_id: OrdId) -> Result<OwnOrder, Error> {
    verify!(data.ws.connected(), Error::ServerDisconnected);
    let order = data
        .orders
        .values()
        .find_map(|orders| orders.server_orders.get(&order_id))
        .ok_or(Error::UnknownOrderId)?;
    let order = convert_own_order(order, data.network).expect("must not fail");
    Ok(order)
}

fn get_own_orders(data: &Data) -> Result<OwnOrders, Error> {
    verify!(data.ws.connected(), Error::ServerDisconnected);
    let orders = data
        .orders
        .values()
        .flat_map(|orders| orders.server_orders.values())
        .map(|order| convert_own_order(order, data.network).expect("must not fail"))
        .collect::<Vec<_>>();
    Ok(OwnOrders { orders })
}

fn get_asset(data: &Data, asset_id: &AssetId) -> Result<Asset, Error> {
    verify!(data.ws.connected(), Error::ServerDisconnected);
    let asset = data
        .assets
        .iter()
        .find(|asset| asset.asset_id == *asset_id)
        .cloned()
        .ok_or(Error::UnknownAssetId(*asset_id))?;
    Ok(asset)
}

fn get_gaid(data: &Data) -> Result<String, Error> {
    data.gaid.clone().ok_or(Error::NoGaid)
}

async fn process_client_command(data: &mut Data, command: ClientCommand) {
    match command {
        ClientCommand::Metadata { res_sender } => {
            res_sender.send(Metadata {
                server_connected: data.ws.connected(),
                assets: data
                    .assets
                    .iter()
                    .filter(|asset| {
                        dealer_ticker_from_asset_id(data.network, &asset.asset_id).is_some()
                    })
                    .cloned()
                    .collect(),
                markets: data
                    .markets
                    .values()
                    .filter_map(|market| -> Option<Market> {
                        let exchange_pair = get_exchange_pair(&market.asset_pair, data.network)?;
                        Some(Market {
                            base: exchange_pair.base,
                            quote: exchange_pair.quote,
                        })
                    })
                    .collect(),
            });
        }

        ClientCommand::GetAsset {
            asset_id,
            res_sender,
        } => {
            let res = get_asset(data, &asset_id);
            res_sender.send(res);
        }

        ClientCommand::GetGaid { res_sender } => {
            let res = get_gaid(data);
            res_sender.send(res);
        }

        ClientCommand::NewAddress { res_sender } => {
            data.event_sender.send(Event::NewAddress {
                res_sender: res_sender.into(),
            });
        }

        ClientCommand::Balances { res_sender } => {
            res_sender.send(data.balances.clone());
        }

        ClientCommand::OrderBook {
            exchange_pair,
            res_sender,
        } => {
            // This will block only when a new market added
            let res = subscribe(data, exchange_pair, None).await;
            res_sender.send(res);
        }

        ClientCommand::GetOwnOrder {
            order_id,
            res_sender,
        } => {
            let res = get_own_order(data, order_id);
            res_sender.send(res);
        }

        ClientCommand::GetOwnOrders { res_sender } => {
            let res = get_own_orders(data);
            res_sender.send(res);
        }

        ClientCommand::GetHistory {
            start_time,
            end_time,
            skip,
            count,
            res_sender,
        } => {
            let network = data.network;
            data.ws.callback_request(
                sideswap_api::Request::Market(Request::LoadHistory(mkt::LoadHistoryRequest {
                    start_time,
                    end_time,
                    skip,
                    count,
                })),
                Box::new(move |res| {
                    let res = match res {
                        Ok(sideswap_api::Response::Market(mkt::Response::LoadHistory(resp))) => {
                            Ok(HistoryOrders {
                                orders: resp
                                    .list
                                    .iter()
                                    .map(|order| {
                                        convert_history_order(order, network)
                                            .expect("must not fail")
                                    })
                                    .collect(),
                                total: resp.total,
                            })
                        }
                        Ok(_) => Err(Error::UnexpectedResponse("LoadHistory")),
                        Err(err) => Err(Error::WsRequestError(err)),
                    };
                    res_sender.send(res);
                }),
            );
        }

        ClientCommand::ResolveGaid {
            asset_id,
            gaid,
            res_sender,
        } => {
            data.ws.callback_request(
                sideswap_api::Request::Market(Request::ResolveGaid(mkt::ResolveGaidRequest {
                    asset_id,
                    gaid,
                })),
                Box::new(move |res| {
                    let res = match res {
                        Ok(sideswap_api::Response::Market(mkt::Response::ResolveGaid(resp))) => {
                            Ok(resp.address.clone())
                        }
                        Ok(_) => Err(Error::UnexpectedResponse("ResolveGaid")),
                        Err(err) => Err(Error::WsRequestError(err)),
                    };
                    res_sender.send(res);
                }),
            );
        }

        ClientCommand::SubmitOrder {
            exchange_pair,
            base_amount,
            price,
            trade_dir,
            client_order_id,
            res_sender,
            receive_address,
            change_address,
        } => {
            data.mode.check_ws_edit_allowed();

            let base_precision = exchange_pair.base.asset_precision();
            let base_amount = asset_int_amount_(base_amount, base_precision);
            let network = data.network;

            let asset_pair = AssetPair {
                base: dealer_ticker_to_asset_id(data.network, exchange_pair.base),
                quote: dealer_ticker_to_asset_id(data.network, exchange_pair.quote),
            };

            data.ws.callback_request(
                sideswap_api::Request::Market(Request::AddOrder(mkt::AddOrderRequest {
                    asset_pair,
                    base_amount,
                    price,
                    trade_dir,
                    ttl: None,
                    receive_address,
                    change_address,
                    private: false,
                    client_order_id,
                    signature: None,
                })),
                Box::new(move |res| {
                    let res = match res {
                        Ok(sideswap_api::Response::Market(mkt::Response::AddOrder(resp))) => {
                            let order =
                                convert_own_order(&resp.order, network).expect("must not fail");
                            Ok(order)
                        }
                        Ok(_) => Err(Error::UnexpectedResponse("AddOrder")),
                        Err(err) => Err(Error::WsRequestError(err)),
                    };
                    res_sender.send(res);
                }),
            );
        }

        ClientCommand::EditOrder {
            order_id,
            base_amount,
            price,
            res_sender,
        } => {
            data.mode.check_ws_edit_allowed();

            let network = data.network;
            data.ws.callback_request(
                sideswap_api::Request::Market(Request::EditOrder(mkt::EditOrderRequest {
                    order_id,
                    base_amount,
                    price,
                    receive_address: None,
                    change_address: None,
                    signature: None,
                })),
                Box::new(move |res| {
                    let res = match res {
                        Ok(sideswap_api::Response::Market(mkt::Response::EditOrder(resp))) => {
                            let order =
                                convert_own_order(&resp.order, network).expect("must not fail");
                            Ok(order)
                        }
                        Ok(_) => Err(Error::UnexpectedResponse("EditOrder")),
                        Err(err) => Err(Error::WsRequestError(err)),
                    };
                    res_sender.send(res);
                }),
            );
        }

        ClientCommand::CancelOrder {
            order_id,
            res_sender,
        } => {
            data.mode.check_ws_edit_allowed();

            data.ws.callback_request(
                sideswap_api::Request::Market(Request::CancelOrder(mkt::CancelOrderRequest {
                    order_id,
                })),
                Box::new(move |res| {
                    let res = match res {
                        Ok(sideswap_api::Response::Market(mkt::Response::CancelOrder(_resp))) => {
                            Ok(())
                        }
                        Ok(_) => Err(Error::UnexpectedResponse("CancelOrder")),
                        Err(err) => Err(Error::WsRequestError(err)),
                    };
                    res_sender.send(res);
                }),
            );
        }

        ClientCommand::ClientConnected {
            client_id,
            event_sender,
        } => {
            if data.ws.connected() {
                event_sender.send(ClientEvent::ServerConnected {
                    own_orders: get_own_orders(data).expect("must not fail"),
                });
            }

            event_sender.send(ClientEvent::Balances {
                balances: data.balances.clone(),
            });

            let prev_data = data.clients.insert(client_id, event_sender);
            assert!(prev_data.is_none());
        }

        ClientCommand::ClientDisconnected { client_id } => {
            // The client may be already disconnected by us
            data.clients.remove(&client_id);

            for subscribed in data.subscribed.values_mut() {
                subscribed.clients.remove(&client_id);
            }

            let quote_client_id = data
                .started_quote
                .as_ref()
                .map(|started_quote| started_quote.client_id);
            if quote_client_id == Some(client_id) {
                stop_quotes(data);
            }
        }

        ClientCommand::WsSubscribe {
            client_id,
            exchange_pair,
            res_sender,
        } => {
            let res = subscribe(data, exchange_pair, Some(client_id)).await;
            res_sender.send(res);
        }

        ClientCommand::WsStartQuotes { req, res_sender } => {
            start_quotes(data, req, res_sender);
        }

        ClientCommand::WsStopQuotes {} => {
            stop_quotes(data);
        }

        ClientCommand::WsAcceptQuote { req, res_sender } => {
            accept_quote(data, req, res_sender);
        }
    }
}

fn process_command(data: &mut Data, command: Command) {
    match command {
        Command::AutomaticOrders { orders } => {
            match data.mode {
                Mode::PriceStream => {}
                Mode::WebServer => {
                    assert!(orders.is_empty(), "Please disable automatic price streaming as the web server is used to control orders");
                }
            }

            for market in data.orders.values_mut() {
                market.dealer_orders.clear();
            }

            for order in orders {
                data.orders
                    .entry((order.asset_pair, order.trade_dir))
                    .or_default()
                    .dealer_orders
                    .push(order);
            }
        }

        Command::Utxos { utxos } => {
            data.wallet_utxos = utxos
                .into_iter()
                .filter(|utxo| {
                    utxo.asset_bf != AssetBlindingFactor::zero()
                        && utxo.value_bf != ValueBlindingFactor::zero()
                })
                .collect();

            let mut balance = BTreeMap::<AssetId, u64>::new();
            for utxo in data.wallet_utxos.iter() {
                *balance.entry(utxo.asset).or_default() += utxo.value;
            }

            let balance = balance
                .into_iter()
                .filter_map(|(asset_id, balance)| -> Option<(DealerTicker, f64)> {
                    let ticker = dealer_ticker_from_asset_id(data.network, &asset_id)?;
                    let value = asset_float_amount_(balance, ticker.asset_precision());
                    Some((ticker, value))
                })
                .collect::<BTreeMap<_, _>>();

            let new_balances = Balances { balance };

            if new_balances != data.balances {
                for event_sender in data.clients.values() {
                    event_sender.send(ClientEvent::Balances {
                        balances: new_balances.clone(),
                    });
                }
            }

            data.balances = new_balances;
        }

        Command::Gaid { gaid } => {
            data.gaid = Some(gaid);
        }

        Command::SignedSwap { quote_id, pset } => {
            let pset = elements::encode::serialize(&pset);
            let pset = b64::encode(&pset);

            let accepting_quote = data.accepting_quotes.remove(&quote_id);

            if let Some(accepting_quote) = accepting_quote {
                signed_accepted_quote(data, quote_id, pset, accepting_quote);
            } else {
                data.ws.callback_request(
                    sideswap_api::Request::Market(Request::MakerSign(mkt::MakerSignRequest {
                        quote_id,
                        pset,
                    })),
                    Box::new(|res| {
                        if let Err(err) = res {
                            log::error!("MakerSign failed: {err}");
                        }
                    }),
                );
            }
        }
    }
}

async fn try_sync_utxos(data: &mut Data) -> Result<(), anyhow::Error> {
    let wallet_outputs = data
        .wallet_utxos
        .iter()
        .map(UtxoExt::outpoint)
        .collect::<BTreeSet<_>>();

    let removed = data
        .server_utxos
        .difference(&wallet_outputs)
        .copied()
        .collect::<Vec<_>>();

    if !removed.is_empty() {
        let count = removed.len();
        for utxo in removed.iter() {
            log::debug!("try to remove utxo: {utxo}");
        }
        make_market_request!(
            data.ws,
            RemoveUtxos,
            mkt::RemoveUtxosRequest { utxos: removed }
        )?;
        log::debug!("removed {count} utxos");
    }

    let mut added = Vec::new();
    for utxo in data.wallet_utxos.iter() {
        if !data.server_utxos.contains(&utxo.outpoint()) {
            log::debug!("try to add utxo: {}", utxo.outpoint());
            added.push(utxo.clone());
        }
    }

    if !added.is_empty() {
        let count = added.len();
        make_market_request!(data.ws, AddUtxos, mkt::AddUtxosRequest { utxos: added })?;
        log::debug!("added {count} utxos");
    }

    Ok(())
}

async fn try_sync_market(data: &mut Data, key: &OrderGroupKey) -> Result<(), anyhow::Error> {
    let market = data
        .orders
        .get_mut(key)
        .ok_or_else(|| anyhow::anyhow!("can't find group {key:?}"))?;

    // Drop removed orders
    while market.server_orders.len() > market.dealer_orders.len() {
        let order = market.server_orders.last_key_value().expect("must exist").1;

        make_market_request!(
            data.ws,
            CancelOrder,
            mkt::CancelOrderRequest {
                order_id: order.order_id
            }
        )?;

        market.server_orders.pop_last();
    }

    // Sync existing orders
    for (dealer_order, server_order) in market
        .dealer_orders
        .iter_mut()
        .zip(market.server_orders.values_mut())
    {
        if dealer_order.base_amount != server_order.orig_amount
            || dealer_order.price != server_order.price
        {
            let resp = make_market_request!(
                data.ws,
                EditOrder,
                mkt::EditOrderRequest {
                    order_id: server_order.order_id,
                    base_amount: Some(dealer_order.base_amount),
                    price: Some(dealer_order.price),
                    receive_address: None,
                    change_address: None,
                    signature: None,
                }
            )?;

            *server_order = resp.order;
        }
    }

    // Add new orders
    while market.dealer_orders.len() > market.server_orders.len() {
        let dealer_order = &market.dealer_orders[market.server_orders.len()];

        // TODO: Reuse addresses?

        let recv_asset = match dealer_order.trade_dir {
            TradeDir::Sell => dealer_order.asset_pair.quote,
            TradeDir::Buy => dealer_order.asset_pair.base,
        };

        let receive_address = if data.amp_assets.contains(&recv_asset) {
            let gaid = data
                .gaid
                .as_ref()
                .ok_or_else(|| anyhow::anyhow!("no gaid"))?;

            let resp = make_market_request!(
                data.ws,
                ResolveGaid,
                mkt::ResolveGaidRequest {
                    asset_id: recv_asset,
                    gaid: gaid.clone(),
                }
            )?;

            resp.address
        } else {
            new_address(&data.event_sender).await?
        };

        let change_address = new_address(&data.event_sender).await?;

        let resp = make_market_request!(
            data.ws,
            AddOrder,
            mkt::AddOrderRequest {
                asset_pair: dealer_order.asset_pair,
                base_amount: dealer_order.base_amount,
                price: dealer_order.price,
                trade_dir: dealer_order.trade_dir,
                ttl: None,
                receive_address,
                change_address,
                private: false,
                client_order_id: None,
                signature: None,
            }
        )?;

        market.server_orders.insert(resp.order.order_id, resp.order);
    }

    Ok(())
}

async fn process_timer(data: &mut Data) {
    if data.ws.connected() {
        let res = try_sync_utxos(data).await;
        if let Err(err) = res {
            log::warn!("utxo sync failed: {err}");
        }

        match data.mode {
            Mode::PriceStream => {
                // Sync orders
                let keys = data.orders.keys().copied().collect::<Vec<_>>();
                for key in keys.iter() {
                    let res = try_sync_market(data, key).await;
                    if let Err(err) = res {
                        log::error!("market sync failed: {err}");
                    }
                }
            }

            Mode::WebServer => {
                // Do nothing, web server is used to manage the orders
            }
        }
    }
}

async fn run(
    params: Params,
    mut command_receiver: UnboundedReceiver<Command>,
    event_sender: UnboundedSender<Event>,
) {
    let (req_sender, req_receiver) = unbounded_channel::<WrappedRequest>();
    let (resp_sender, resp_receiver) = unbounded_channel::<WrappedResponse>();
    tokio::spawn(sideswap_common::ws::auto::run(
        params.server_url.clone(),
        req_receiver,
        resp_sender,
    ));
    let ws = WsReqSender::new(req_sender, resp_receiver);

    let (client_sender, mut client_receiver) = unbounded_channel::<ClientCommand>();

    let network = params.env.d().network;

    let controller = Controller::new(network, client_sender.clone());

    if let Some(config) = params.web_server.clone() {
        web_server::start(config, controller.clone());
    }

    if let Some(config) = params.ws_server.clone() {
        ws_server::start(config, controller);
    }

    // FIXME: Allow using web server with automatic price streaming

    let mode = if params.web_server.is_some() {
        Mode::WebServer
    } else {
        Mode::PriceStream
    };

    let state = persistent_state::load(&params.work_dir);

    let mut data = Data {
        network,
        mode,
        work_dir: params.work_dir,
        state,
        ws,
        async_requests: BTreeMap::new(),
        wallet_utxos: Vec::new(),
        server_utxos: BTreeSet::new(),
        balances: Balances::default(),
        gaid: None,
        assets: Vec::new(),
        amp_assets: BTreeSet::new(),
        orders: BTreeMap::new(),
        event_sender: event_sender.into(),
        markets: BTreeMap::new(),
        clients: BTreeMap::new(),
        subscribed: BTreeMap::new(),
        started_quote: None,
        accepting_quotes: BTreeMap::new(),
    };

    let mut interval = tokio::time::interval(Duration::from_secs(1));

    loop {
        tokio::select! {
            event = data.ws.recv() => {
                process_ws_event(&mut data, event).await;
            },

            command = command_receiver.recv() => {
                match command {
                    Some(command) => {
                        process_command(&mut data, command);
                    },
                    None => {
                        log::debug!("stop worker thread");
                        break;
                    },
                }
            },

            command = client_receiver.recv() => {
                let command = command.expect("channel must be open");
                process_client_command(&mut data, command).await;
            },

            _ = interval.tick() => {
                process_timer(&mut data).await;
            },
        }
    }
}

async fn run_disabled(
    mut command_receiver: UnboundedReceiver<Command>,
    _event_sender: UnboundedSender<Event>,
) {
    while let Some(_command) = command_receiver.recv().await {}
}

pub fn start(params: Params) -> (UnboundedSender<Command>, UnboundedReceiver<Event>) {
    let (command_sender, command_receiver) = unbounded_channel::<Command>();
    let (event_sender, event_receiver) = unbounded_channel::<Event>();

    if !params.disable_new_swaps {
        tokio::spawn(run(params, command_receiver, event_sender));
    } else {
        tokio::spawn(run_disabled(command_receiver, event_sender));
    }

    (command_sender, event_receiver)
}
