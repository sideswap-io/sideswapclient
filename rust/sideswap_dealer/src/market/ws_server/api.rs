use serde::{Deserialize, Serialize};
use sideswap_api::market::{OrdId, TradeDir};

use crate::types::ExchangePair;

pub type ReqId = i64;

// Common

/// Public order
#[derive(Serialize)]
pub struct PubOrder {
    /// Order ID (based on timestamp, globally unique for all orders)
    pub order_id: OrdId,
    /// Trade direction
    pub trade_dir: TradeDir,
    /// Base asset active order amount (same as `active_amount` in OwnOrder)
    pub amount: f64,
    /// Price
    pub price: f64,
}

// Requests

#[derive(Deserialize)]
pub struct SubscribeReq {
    pub exchange_pair: ExchangePair,
}

#[derive(Serialize)]
pub struct SubscribeResp {
    pub orders: Vec<PubOrder>,
}

// Notifications

#[derive(Serialize)]
pub struct ServerConnectedNotif {}

#[derive(Serialize)]
pub struct OrderCreatedNotif {
    pub exchange_pair: ExchangePair,
    pub order: PubOrder,
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

// Top level messages

#[derive(Deserialize)]
pub enum Req {
    Subscribe(SubscribeReq),
}

#[derive(Serialize)]
pub enum Resp {
    Subscribe(SubscribeResp),
}

#[derive(Serialize)]
pub enum ErrorCode {
    /// Something wrong with the request arguments
    InvalidRequest,
    /// Network error
    NetworkError,
    /// Server error
    ServerError,
}

#[derive(Serialize)]
pub enum ErrorDetails {}

#[derive(Serialize)]
pub struct Error {
    pub code: ErrorCode,
    pub text: String,
    pub details: Option<ErrorDetails>,
}

#[derive(Serialize)]
pub enum Notif {
    ServerConnected(ServerConnectedNotif),
    OrderCreated(OrderCreatedNotif),
    OrderRemoved(OrderRemovedNotif),
    MarketPrice(MarketPriceNotif),
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
