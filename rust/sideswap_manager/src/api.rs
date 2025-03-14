use std::collections::BTreeMap;

use serde::{Deserialize, Serialize};
use sideswap_api::{mkt::QuoteId, OrderId};
use sideswap_common::dealer_ticker::DealerTicker;
use sideswap_types::duration_ms::DurationMs;

#[derive(Debug, Serialize)]
pub enum ErrorCode {
    /// Something wrong with the request arguments
    InvalidRequest,
    /// Server error
    ServerError,
    /// Network error
    NetworkError,
}

#[derive(Debug, Serialize)]
pub struct ErrorDetails {}

#[derive(Debug, Serialize)]
pub struct Error {
    /// Error message text
    pub text: String,
    /// Error code
    pub code: ErrorCode,
    /// Error details
    pub details: Option<ErrorDetails>,
}

// Common

pub type ReqId = i64;

/// In asset precison
pub type Balances = BTreeMap<DealerTicker, f64>;

#[derive(Serialize)]
pub enum SwapStatus {
    Mempool,
    Confirmed,
    NotFound,
}

#[derive(Serialize)]
pub struct Swap {
    pub txid: elements::Txid,
    pub status: SwapStatus,
}

// Requests

#[derive(Deserialize)]
pub struct NewAddressReq {}

#[derive(Serialize)]
pub struct NewAddressResp {
    pub address: elements::Address,
}

#[derive(Deserialize)]
pub struct GetQuoteReq {
    pub send_asset: DealerTicker,
    pub recv_asset: DealerTicker,
    pub send_amount: f64,
    pub receive_address: elements::Address,
}

#[derive(Serialize)]
pub struct GetQuoteResp {
    pub quote_id: QuoteId,
    pub recv_amount: f64,
    pub ttl: DurationMs,
    pub txid: elements::Txid,
}

#[derive(Deserialize)]
pub struct AcceptQuoteReq {
    pub quote_id: QuoteId,
}

#[derive(Serialize)]
pub struct AcceptQuoteResp {
    pub txid: elements::Txid,
}

#[derive(Deserialize)]
pub struct NewPegReq {
    pub recv_addr: String,
    pub peg_in: bool,
    pub blocks: Option<i32>,
}

#[derive(Serialize)]
pub struct NewPegResp {
    pub order_id: OrderId,
    pub peg_addr: String,
}

#[derive(Deserialize)]
pub struct DelPegReq {
    pub order_id: OrderId,
}

#[derive(Serialize)]
pub struct DelPegResp {}

#[derive(Deserialize)]
pub struct GetSwapsReq {}

#[derive(Serialize)]
pub struct GetSwapsResp {
    pub swaps: Vec<Swap>,
}

// Notifications

/// Wallet balances
#[derive(Debug, Serialize, PartialEq, Clone)]
pub struct BalancesNotif {
    pub balances: Balances,
}

// Top level WS messages

#[derive(Deserialize)]
pub enum Req {
    NewAddress(NewAddressReq),
    GetQuote(GetQuoteReq),
    AcceptQuote(AcceptQuoteReq),
    NewPeg(NewPegReq),
    DelPeg(DelPegReq),
    GetSwaps(GetSwapsReq),
}

#[derive(Serialize)]
pub enum Resp {
    NewAddress(NewAddressResp),
    GetQuote(GetQuoteResp),
    AcceptQuote(AcceptQuoteResp),
    NewPeg(NewPegResp),
    DelPeg(DelPegResp),
    GetSwaps(GetSwapsResp),
}

#[derive(Serialize, Clone)]
pub enum Notif {
    Balances(BalancesNotif),
    PegStatus(sideswap_api::PegStatus),
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
