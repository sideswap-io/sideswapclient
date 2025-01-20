use std::collections::BTreeMap;

use poem_openapi::{Enum, Object};
use serde::{Deserialize, Serialize};
use sideswap_api::mkt::{AssetType, OrdId, QuoteId, QuoteSubId};
use sideswap_common::{dealer_ticker::DealerTicker, exchange_pair::ExchangePair};
use sideswap_types::duration_ms::DurationMs;

#[derive(Debug, Serialize, Enum)]
pub enum ErrorCode {
    /// Something wrong with the request arguments
    InvalidRequest,
    /// Server error
    ServerError,
}

#[derive(Debug, Serialize, Object)]
pub struct ErrorDetails {}

#[derive(Debug, Serialize, Object)]
pub struct Error {
    /// Error message text
    pub text: String,
    /// Error code
    pub code: ErrorCode,
    /// Error details
    pub details: Option<ErrorDetails>,
}

// Common

/// History order status
#[derive(Debug, Serialize, Enum)]
pub enum HistOrderStatus {
    /// The swap transaction is in the mempool
    Mempool,
    /// The swap transaction is confirmed
    Confirmed,
    /// The swap transaction conflicted with another confirmed transaction
    TxConflict,
    /// The swap transaction status is not known
    TxNotFound,
    /// The order has expired
    Elapsed,
    /// The order has been cancelled by the user
    Cancelled,
    /// The offline transaction inputs have been spent
    UtxoInvalidated,
    /// The offline transaction has been replaced by a newer offline transaction
    Replaced,
}

pub type ReqId = i64;

/// Trade direction of the base asset
#[derive(Debug, Serialize, Deserialize, Enum)]
pub enum TradeDir {
    Sell,
    Buy,
}

/// Available market
#[derive(Debug, Object)]
pub struct Market {
    /// Base asset ticker (for example L-BTC or USDt).
    pub base: String,
    /// Quote asset ticker (for example USDt or MEX).
    pub quote: String,
}

#[derive(Debug, Object)]
pub struct Asset {
    /// Asset ID
    pub asset_id: String,
    /// Asset name (from the GDK registry)
    pub name: String,
    /// Asset ticker (from the GDK registry)
    pub ticker: String,
    /// Asset precision (in the [0..8] range)
    pub precision: u8,
}

/// Get market metadata
#[derive(Debug, Object)]
pub struct Metadata {
    /// Whether the upstream connection to the server is active or not.
    /// Without it most API requests will fail.
    pub server_connected: bool,
    /// Hard-coded list of some known assets (L-BTC, USDt, MEX etc) with their details.
    pub assets: Vec<Asset>,
    /// List of the stablecoin and AMP markets (but only where both base and quote assets are known).
    pub markets: Vec<Market>,
}

/// Public order
#[derive(Debug, Serialize, Object)]
pub struct PublicOrder {
    /// Order ID (based on timestamp, globally unique for all orders)
    pub order_id: u64,
    /// Trade direction
    pub trade_dir: TradeDir,
    /// Base asset active order amount (same as `active_amount` in OwnOrder)
    pub amount: f64,
    /// Price
    pub price: f64,
    /// Online/offline order
    pub online: bool,
}

#[derive(Debug, Serialize, Object)]
pub struct OwnOrder {
    /// Order ID (based on timestamp, globally unique for all orders)
    pub order_id: u64,
    /// Client order id. If set, will be unique among all active and recent history orders.
    pub client_order_id: Option<Box<String>>,
    /// Base asset ticker
    pub base: String,
    /// Quote asset ticker
    pub quote: String,
    /// Trade direction
    pub trade_dir: TradeDir,
    /// Base asset amount specified when the order was created.
    /// If the order is partially matched, the matched amount is deducted from the `orig_amount` and the order remains active.
    /// If the order is fully matched, it is removed.
    /// Can be larger than the available wallet balance.
    pub orig_amount: f64,
    /// Active order amount.
    /// All submitted orders are sorted by price and then UTXOs amounts are checked, starting from the top orders.
    /// For sell orders the base asset UTXOs are checked and for buy orders the quote asset.
    /// If zero, the order will not be listed in the public book.
    pub active_amount: f64,
    /// Order price (must be positive)
    pub price: f64,
}

#[derive(Debug, Serialize, Object)]
pub struct HistoryOrder {
    /// Unique id (based on timestamp, globally unique for all orders)
    pub id: u64,
    /// Order ID
    pub order_id: u64,
    /// Client order id
    pub client_order_id: Option<Box<String>>,
    /// Base asset ticker
    pub base: String,
    /// Quote asset ticker
    pub quote: String,
    /// Trade direction
    pub trade_dir: TradeDir,
    /// Base asset amount
    pub base_amount: f64,
    /// Quote amount. Will be 0 if txid is not set.
    pub quote_amount: f64,
    /// Order price
    pub price: f64,
    /// Txid is set when the order is partially or fully matched
    pub txid: Option<String>,
    /// Status
    pub status: HistOrderStatus,
}

#[derive(Debug, Object)]
pub struct OrderBook {
    /// List of the public orders
    pub orders: Vec<PublicOrder>,
}

#[derive(Debug, Object)]
pub struct OwnOrders {
    /// List of all active own orders, from all markets
    pub orders: Vec<OwnOrder>,
}

#[derive(Debug, Object)]
pub struct HistoryOrders {
    /// List of history orders (newest to oldest)
    pub orders: Vec<HistoryOrder>,
    /// Total number of orders after filtering (in the start_time..end_time range)
    pub total: usize,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub enum QuoteStatus {
    Success {
        quote_id: QuoteId,
        base_amount: f64,
        quote_amount: f64,
        server_fee: f64,
        fixed_fee: f64,
        deliver_asset: DealerTicker,
        receive_asset: DealerTicker,
        deliver_amount: f64,
        receive_amount: f64,
        ttl: DurationMs,
    },
    LowBalance {
        base_amount: f64,
        quote_amount: f64,
        server_fee: f64,
        fixed_fee: f64,
        deliver_asset: DealerTicker,
        receive_asset: DealerTicker,
        deliver_amount: f64,
        receive_amount: f64,
        available: f64,
    },
    Error {
        error_msg: String,
    },
}

// Requests

#[derive(Deserialize)]
pub struct SubscribeReq {
    pub exchange_pair: ExchangePair,
}

#[derive(Serialize)]
pub struct SubscribeResp {
    pub orders: Vec<PublicOrder>,
}

#[derive(Deserialize)]
pub struct StartQuotesReq {
    pub exchange_pair: ExchangePair,
    pub asset_type: AssetType,
    pub amount: f64,
    pub trade_dir: TradeDir,
    pub order_id: Option<OrdId>,
    pub private_id: Option<Box<String>>,
}

#[derive(Serialize)]
pub struct StartQuotesResp {
    pub quote_sub_id: QuoteSubId,
    pub fee_asset: AssetType,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct StopQuotesReq {}

#[derive(Serialize, Deserialize, Debug)]
pub struct StopQuotesResp {}

#[derive(Serialize, Deserialize, Debug)]
pub struct AcceptQuoteReq {
    pub quote_id: QuoteId,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct AcceptQuoteResp {
    pub txid: elements::Txid,
}

// Notifications

/// Wallet balances
#[derive(Debug, Serialize, Object)]
pub struct BalancesNotif {
    /// Total wallet balances (unconfirmed and confirmed transactions).
    pub balance: BTreeMap<String, f64>,
}

#[derive(Serialize)]
pub struct ServerConnectedNotif {
    pub own_orders: Vec<OwnOrder>,
}

#[derive(Serialize)]
pub struct OrderCreatedNotif {
    pub exchange_pair: ExchangePair,
    pub order: PublicOrder,
}

#[derive(Serialize)]
pub struct OrderRemovedNotif {
    pub exchange_pair: ExchangePair,
    pub order_id: OrdId,
}

#[derive(Serialize)]
pub struct MarketPriceNotif {
    pub exchange_pair: ExchangePair,
    pub ind_price: Option<f64>,
    pub last_price: Option<f64>,
}

#[derive(Serialize)]
pub struct OwnOrderCreatedNotif {
    pub order: OwnOrder,
}

#[derive(Serialize)]
pub struct OwnOrderRemovedNotif {
    pub order_id: OrdId,
}

#[derive(Serialize)]
pub struct HistoryUpdatedNotif {
    pub order: HistoryOrder,
    pub is_new: bool,
}

#[derive(Clone, Serialize, Deserialize, Debug)]
pub struct QuoteNotif {
    pub quote_sub_id: QuoteSubId,
    pub status: QuoteStatus,
}

// Top level WS messages

#[derive(Deserialize)]
pub enum Req {
    Subscribe(SubscribeReq),
    StartQuotes(StartQuotesReq),
    StopQuotes(StopQuotesReq),
    AcceptQuote(AcceptQuoteReq),
}

#[derive(Serialize)]
pub enum Resp {
    Subscribe(SubscribeResp),
    StartQuotes(StartQuotesResp),
    StopQuotes(StopQuotesResp),
    AcceptQuote(AcceptQuoteResp),
}

#[derive(Serialize)]
pub enum Notif {
    Balances(BalancesNotif),
    ServerConnected(ServerConnectedNotif),
    OrderCreated(OrderCreatedNotif),
    OrderRemoved(OrderRemovedNotif),
    OwnOrderCreated(OwnOrderCreatedNotif),
    OwnOrderRemoved(OwnOrderRemovedNotif),
    MarketPrice(MarketPriceNotif),
    HistoryUpdated(HistoryUpdatedNotif),
    Quote(QuoteNotif),
}

#[derive(Deserialize)]
pub enum To {
    Req { id: ReqId, req: Req },
}

#[derive(Serialize)]
pub enum From {
    Resp { id: ReqId, resp: Resp },
    Error { id: ReqId, err: Error },
    Notif { notif: Notif },
}
