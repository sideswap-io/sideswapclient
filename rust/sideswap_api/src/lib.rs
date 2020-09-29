use serde::{Deserialize, Serialize};
use std::vec::Vec;

pub const TICKER_BITCOIN: &str = "L-BTC";

pub static PATH_JSON_RPC: &str = "json-rpc";
pub static PATH_RUST_RPC: &str = "rust-rpc";
pub static PATH_JSON_RPC_WS: &str = "json-rpc-ws";
pub static PATH_JSON_RUST_WS: &str = "rust-rpc-ws";

#[derive(Debug, Hash, PartialEq, Eq, Clone, Ord, PartialOrd, Serialize, Deserialize)]
pub struct OrderId(pub String);

impl std::fmt::Display for OrderId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0)
    }
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct Asset {
    pub asset_id: String,
    pub name: String,
    pub ticker: String,
    pub icon: String, // PNG in base64
    pub precision: u8,
}

pub type Assets = Vec<Asset>;

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct AssetsResponse {
    pub assets: Assets,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PegInRequest {
    pub elements_addr: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PegInResponse {
    pub order_id: OrderId,
    pub mainchain_addr: String,
    pub created_at: Timestamp,
    pub expires_at: Timestamp,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PegOutRequest {
    pub mainchain_addr: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PegOutResponse {
    pub order_id: OrderId,
    pub elements_addr: String,
    pub created_at: Timestamp,
    pub expires_at: Timestamp,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PegInStatusRequest {
    pub order_id: OrderId,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PegOutStatusRequest {
    pub order_id: OrderId,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SwapStatusRequest {
    pub order_id: OrderId,
}

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
pub struct Swap {
    pub send_asset: String,
    pub send_amount: i64,
    pub recv_asset: String,
    pub recv_amount: i64,
    pub server_fee: i64,
    pub network_fee: i64,
}

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
pub struct Offer {
    pub swap: Swap,
    pub created_at: Timestamp,
    pub expires_at: Timestamp,
    pub accept_required: bool,
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "snake_case")]
pub enum SwapAction {
    Accept,
    Cancel,
    Psbt(String),
    Sign(String),
}

#[derive(Serialize, Deserialize, Debug, Clone, Eq, PartialEq)]
pub enum SwapError {
    Cancelled,
    Timeout,
    ServerError,
    DealerError,
    ClientError,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct AssetAmount {
    pub asset: String,
    pub amount: i64,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(rename_all = "snake_case")]
pub enum SwapState {
    ReviewOffer(Offer),
    WaitPsbt,
    WaitSign(String),
    Failed(SwapError),
    Done(String),
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SwapRequest {
    pub order_id: OrderId,
    pub action: SwapAction,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SwapNotification {
    pub order_id: OrderId,
    pub state: SwapState,
}

#[derive(Serialize, Deserialize, Debug, Clone, Eq, PartialEq)]
pub struct MatchRfq {
    pub send_asset: String,
    pub send_amount: i64,
    pub recv_asset: String,
    pub utxo_count: i32,
    pub with_change: bool,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct MatchQuote {
    pub order_id: OrderId,
    pub send_amount: i64,
    pub utxo_count: i32,
    pub with_change: bool,
}

// In milliseconds since UNIX epoch
pub type Timestamp = i64;

#[derive(Serialize, Deserialize, Debug)]
pub struct MatchRfqRequest {
    pub rfq: MatchRfq,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct MatchRfqResponse {
    pub order_id: OrderId,
    pub created_at: Timestamp,
    pub expires_at: Timestamp,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct MatchQuoteRequest {
    pub quote: MatchQuote,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct MatchCancelRequest {
    pub order_id: OrderId,
}

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
pub enum MatchRfqStatus {
    Pending,
    Expired,
    Succeed,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct RfqCreatedNotification {
    pub order_id: OrderId,
    pub rfq: MatchRfq,
    pub created_at: Timestamp,
    pub expires_at: Timestamp,
}

#[derive(Serialize, Deserialize, Debug, Eq, PartialEq)]
pub enum RfqStatus {
    Expired,
    Cancelled,
    Rejected,
    Accepted,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RfqRemovedNotification {
    pub order_id: OrderId,
    pub status: RfqStatus,
}

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
pub struct MatchRfqUpdate {
    pub order_id: OrderId,
    pub status: MatchRfqStatus,
    pub recv_amount: Option<i64>,
    pub created_at: Timestamp,
    pub expires_at: Timestamp,
}

#[derive(Serialize, Deserialize, Debug, Copy, Clone)]
pub enum PegTxState {
    InsufficientAmount,
    Detected,
    Processing,
    Done,
}

#[derive(Serialize, Deserialize, Debug, Copy, Clone, PartialEq)]
pub enum SwapStatus {
    Pending,
    Cancelled,
    Timeout,
    ServerError,
    DealerError,
    ClientError,
    Broadcast,
    Settled,
}

pub fn peg_tx_state_code(state: PegTxState) -> i32 {
    match state {
        PegTxState::InsufficientAmount => 1,
        PegTxState::Detected => 2,
        PegTxState::Processing => 3,
        PegTxState::Done => 4,
    }
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct TxStatus {
    pub tx_hash: String,
    pub vout: i32,
    pub status: String,
    pub amount: i64,
    pub tx_state: PegTxState,
    pub tx_state_code: i32,
    pub detected_confs: Option<i32>,
    pub total_confs: Option<i32>,
    pub created_at: Timestamp,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct PegStatus {
    pub order_id: OrderId,
    pub addr: String,
    pub list: Vec<TxStatus>,
    pub created_at: Timestamp,
    pub expires_at: Timestamp,
}

#[derive(Serialize, Deserialize, Debug, PartialEq)]
pub struct SwapStatusResponse {
    pub order_id: OrderId,
    pub swap: Swap,
    pub status: SwapStatus,
    pub txid: Option<String>,
    pub created_at: Timestamp,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub enum RequestId {
    String(String),
    Int(i64),
}

#[derive(Serialize, Deserialize, Debug, PartialEq)]
pub struct ServerStatus {
    pub min_peg_in_amount: i64,
    pub min_peg_out_amount: i64,
    pub server_fee_percent_peg_in: f64,
    pub server_fee_percent_peg_out: f64,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LoginClientRequest {
    pub api_key: String,
    pub cookie: Option<String>,
    pub user_agent: String,
    pub version: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LoginClientResponse {
    pub cookie: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LoginDealerRequest {
    pub api_key: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub enum EmptyValue {}
pub type Empty = Option<EmptyValue>;

#[derive(Serialize, Deserialize, Debug)]
pub enum Request {
    ServerStatus(Empty),
    Assets(Empty),
    PegIn(PegInRequest),
    PegOut(PegOutRequest),
    PegInStatus(PegInStatusRequest),
    PegOutStatus(PegOutStatusRequest),
    MatchRfq(MatchRfqRequest),
    MatchRfqCancel(MatchCancelRequest),
    MatchQuote(MatchQuoteRequest),
    MatchQuoteCancel(MatchCancelRequest),
    Swap(SwapRequest),
    SwapStatus(SwapStatusRequest),
    LoginClient(LoginClientRequest),
    LoginDealer(LoginDealerRequest),
}

#[derive(Serialize, Deserialize, Debug)]
pub enum Response {
    ServerStatus(ServerStatus),
    Assets(AssetsResponse),
    PegIn(PegInResponse),
    PegOut(PegOutResponse),
    PegInStatus(PegStatus),
    PegOutStatus(PegStatus),
    MatchRfq(MatchRfqResponse),
    MatchRfqCancel(Empty),
    MatchQuote(Empty),
    MatchQuoteCancel(Empty),
    Swap(Empty),
    SwapStatus(SwapStatusResponse),
    LoginClient(LoginClientResponse),
    LoginDealer(Empty),
}

#[derive(Serialize, Deserialize, Debug)]
pub enum Notification {
    ServerStatus(ServerStatus),
    PegInStatus(PegStatus),
    PegOutStatus(PegStatus),
    Swap(SwapNotification),
    MatchRfq(MatchRfqUpdate),
    RfqCreated(RfqCreatedNotification),
    RfqRemoved(RfqRemovedNotification),
    SwapStatus(SwapStatusResponse),
}

#[derive(Serialize, Deserialize, Debug, Copy, Clone)]
pub enum ErrorCode {
    ParseError,
    InvalidRequest,
    MethodNotFound,
    InvalidParams,
    InternalError,
    ServerError,
}

pub fn error_code(code: ErrorCode) -> i32 {
    match code {
        ErrorCode::ParseError => -32700,
        ErrorCode::InvalidRequest => -32600,
        ErrorCode::MethodNotFound => -32601,
        ErrorCode::InvalidParams => -32602,
        ErrorCode::InternalError => -32603,
        ErrorCode::ServerError => -32000,
    }
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Error {
    pub code: ErrorCode,
    pub message: String,
}

impl std::fmt::Display for Error {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{:?}: {}", self.code, self.message)
    }
}

impl std::error::Error for Error {}

#[derive(Serialize, Deserialize, Debug)]
pub enum RequestMessage {
    Request(RequestId, Request),
}

#[derive(Serialize, Deserialize, Debug)]
pub enum ResponseMessage {
    Response(Option<RequestId>, Result<Response, Error>),
    Notification(Notification),
}
