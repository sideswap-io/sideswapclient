use std::collections::BTreeMap;

use serde::{Deserialize, Serialize};
use sideswap_api::mkt::QuoteId;
use sideswap_common::dealer_ticker::DealerTicker;
use sideswap_types::duration_ms::DurationMs;

#[derive(Debug, Serialize)]
pub enum ErrorCode {
    /// Something wrong with the request arguments
    InvalidRequest,
    /// Server error
    ServerError,
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
}

#[derive(Serialize)]
pub struct GetQuoteResp {
    pub quote_id: QuoteId,
    pub recv_amount: f64,
    pub ttl: DurationMs,
}

#[derive(Deserialize)]
pub struct AcceptQuoteReq {
    pub quote_id: QuoteId,
}

#[derive(Serialize)]
pub struct AcceptQuoteResp {
    pub txid: elements::Txid,
}

// Notifications

/// Wallet balances
#[derive(Debug, Serialize, PartialEq, Clone)]
pub struct BalancesNotif {
    /// Total wallet balances (unconfirmed and confirmed transactions).
    pub trusted: Balances,
    pub untrusted_pending: Balances,
}

// Top level WS messages

#[derive(Deserialize)]
pub enum Req {
    NewAddress(NewAddressReq),
    GetQuote(GetQuoteReq),
    AcceptQuote(AcceptQuoteReq),
}

#[derive(Serialize)]
pub enum Resp {
    NewAddress(NewAddressResp),
    GetQuote(GetQuoteResp),
    AcceptQuote(AcceptQuoteResp),
}

#[derive(Serialize, Clone)]
pub enum Notif {
    Balances(BalancesNotif),
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
