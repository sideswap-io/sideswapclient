use serde::{Deserialize, Serialize};
use std::vec::Vec;

pub const TICKER_BTC: &str = "BTC";
pub const TICKER_LBTC: &str = "L-BTC";
pub const TICKER_USDT: &str = "USDt";
pub const TICKER_EURX: &str = "EURx";

pub static PATH_JSON_RPC_WS: &str = "json-rpc-ws";
pub static PATH_JSON_RUST_WS: &str = "rust-rpc-ws";

pub const OS_TYPE_OTHER: i32 = 0;
pub const OS_TYPE_ANDROID: i32 = 1;
pub const OS_TYPE_IOS: i32 = 2;

pub fn get_os_type() -> i32 {
    if cfg!(target_os = "android") {
        OS_TYPE_ANDROID
    } else if cfg!(target_os = "ios") {
        OS_TYPE_IOS
    } else {
        OS_TYPE_OTHER
    }
}

#[derive(Debug, Hash, PartialEq, Eq, Clone, Ord, PartialOrd, Serialize, Deserialize)]
pub struct OrderId(pub String);

#[derive(Debug, Hash, PartialEq, Eq, Clone, Ord, PartialOrd, Serialize, Deserialize)]
pub struct PhoneKey(pub String);

#[derive(Debug, Hash, PartialEq, Eq, Clone, Ord, PartialOrd, Serialize, Deserialize)]
pub struct AssetId(pub String);

#[derive(Debug, Hash, PartialEq, Eq, Clone, Ord, PartialOrd, Serialize, Deserialize)]
pub struct Ticker(pub String);

impl std::fmt::Display for OrderId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0)
    }
}

#[derive(Serialize, Deserialize, Debug, Clone, Eq, PartialEq)]
pub struct Asset {
    pub asset_id: AssetId,
    pub name: String,
    pub ticker: Ticker,
    pub icon: Option<String>, // PNG in base64
    pub precision: u8,
    pub icon_url: Option<String>,
}

pub type Assets = Vec<Asset>;

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct AssetsRequestParam {
    pub embedded_icons: bool,
}
pub type AssetsRequest = Option<AssetsRequestParam>;
#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct AssetsResponse {
    pub assets: Assets,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PegFeeRequest {
    pub send_amount: i64,
    pub peg_in: bool,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PegFeeResponse {
    pub recv_amount: i64,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PegRequest {
    pub recv_addr: String,
    pub send_amount: Option<i64>,
    pub peg_in: bool,
    pub device_key: Option<String>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PegResponse {
    pub order_id: OrderId,
    pub peg_addr: String,
    pub created_at: Timestamp,
    pub expires_at: Timestamp,
    pub recv_amount: Option<i64>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PegStatusRequest {
    pub order_id: OrderId,
    pub peg_in: bool,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SwapStatusRequest {
    pub order_id: OrderId,
}

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
pub struct Swap {
    pub send_asset: AssetId,
    pub send_amount: i64,
    pub recv_asset: AssetId,
    pub recv_amount: i64,
    pub network_fee: i64,
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "snake_case")]
pub enum SwapAction {
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
#[serde(rename_all = "snake_case")]
pub enum SwapState {
    WaitPsbt(Swap),
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
    pub send_asset: AssetId,
    pub send_amount: i64,
    pub recv_asset: AssetId,
    pub utxo_count: i32,
    pub with_change: bool,
}

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Eq)]
pub struct MatchQuote {
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
}
#[derive(Serialize, Deserialize, Debug, Copy, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub enum RfqRejectReason {
    ServerError,
    NoDealer,
    AmountLow,
    AmountHigh,
}

pub type SentQuote = Result<MatchQuote, RfqRejectReason>;

pub type RecvQuote = Result<MatchRfqQuote, RfqRejectReason>;

#[derive(Serialize, Deserialize, Debug)]
pub struct MatchQuoteRequest {
    pub order_id: OrderId,
    pub quote: SentQuote,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct MatchCancelRequest {
    pub order_id: OrderId,
}

#[derive(Serialize, Deserialize, Debug, Copy, Clone, PartialEq)]
pub struct PricePair {
    pub bid: f64,
    pub ask: f64,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PriceUpdateBroadcast {
    pub asset: AssetId,
    pub price: PricePair,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PriceUpdateSubscribe {
    pub asset: AssetId,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PriceUpdateNotification {
    pub asset: AssetId,
    pub price: PricePair,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct MatchRfqAcceptRequest {
    pub order_id: OrderId,
    pub recv_amount: i64,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct RfqCreatedNotification {
    pub order_id: OrderId,
    pub rfq: MatchRfq,
}

#[derive(Serialize, Deserialize, Debug, Eq, PartialEq)]
pub enum RfqStatus {
    Cancelled,
    Rejected,
    Accepted,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RfqRemovedNotification {
    pub order_id: OrderId,
    pub status: RfqStatus,
}

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Eq)]
pub struct MatchRfqQuote {
    pub recv_amount: i64,
    pub network_fee: i64,
}

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Eq)]
pub struct MatchRfqUpdate {
    pub order_id: OrderId,
    pub quote: RecvQuote,
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
    pub payout: Option<i64>,
    pub tx_state: PegTxState,
    pub tx_state_code: i32,
    pub detected_confs: Option<i32>,
    pub total_confs: Option<i32>,
    pub created_at: Timestamp,
    // Must be set if tx_state is PegTxState::Done
    pub payout_txid: Option<String>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct PegStatus {
    pub order_id: OrderId,
    pub peg_in: bool,
    pub addr: String,
    pub addr_recv: String,
    pub list: Vec<TxStatus>,
    pub created_at: Timestamp,
    pub expires_at: Timestamp,
}

pub type RequestIdInt = i64;
pub type RequestIdString = String;

#[derive(Serialize, Deserialize, Debug, Clone, Eq, PartialEq)]
pub enum RequestId {
    String(RequestIdString),
    Int(RequestIdInt),
}

#[derive(Serialize, Deserialize, Debug, PartialEq)]
pub struct ServerStatus {
    pub min_peg_in_amount: i64,
    pub min_peg_out_amount: i64,
    pub server_fee_percent_peg_in: f64,
    pub server_fee_percent_peg_out: f64,
    pub elements_fee_rate: f64,
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
pub enum DeviceState {
    Unregistered,
    Registered,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct VerifyDeviceRequest {
    pub device_key: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct VerifyDeviceResponse {
    pub device_state: DeviceState,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RegisterDeviceRequest {
    pub os_type: i32,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RegisterDeviceResponse {
    pub device_key: String,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct RegisterAddressesRequest {
    pub device_key: String,
    pub addresses: Vec<String>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct UpdatePushTokenRequest {
    pub device_key: String,
    pub push_token: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RegisterPhoneRequest {
    pub number: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RegisterPhoneResponse {
    pub phone_key: PhoneKey,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct VerifyPhoneRequest {
    pub phone_key: PhoneKey,
    pub code: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub enum Void {}
pub type Empty = Option<Void>;

////////////////////////////////////////////////////////////////////////////////
// New API

#[derive(Serialize, Deserialize, Debug, PartialEq, Eq, Clone, Copy)]
pub enum OrderSide {
    Requestor,
    Responder,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct PriceOrder {
    pub asset: AssetId,
    pub bitcoin_amount: f64,
    pub price: f64,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct AmountOrder {
    pub req_asset: AssetId,
    pub req_amount: i64,
    pub resp_asset: AssetId,
    pub resp_amount: i64,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LoadPricesRequest {
    pub asset: AssetId,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct LoadPricesResponse {
    pub asset: AssetId,
    pub ind: Option<f64>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct CancelPricesRequest {
    pub asset: AssetId,
}
pub type CancelPricesResponse = Empty;

#[derive(Serialize, Deserialize, Debug)]
pub struct SubmitRequest {
    pub order: PriceOrder,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct SubmitResponse {
    pub order_id: OrderId,
    pub submit_link: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct EditRequest {
    pub order_id: OrderId,
    pub price: f64,
}
pub type EditResponse = Empty;

#[derive(Serialize, Deserialize, Debug)]
pub struct CancelRequest {
    pub order_id: OrderId,
}
pub type CancelResponse = Empty;

#[derive(Serialize, Deserialize, Debug)]
pub struct SubscribeRequest {
    pub session_id: Option<String>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SubscribeResponse {
    pub session_id: String,
    pub orders: Vec<OrderCreatedNotification>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SubscribePriceRequest {
    pub asset_id: AssetId,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct SubscribePriceResponse {
    pub asset_id: AssetId,
    pub price: Option<f64>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct UnsubscribePriceRequest {
    pub asset_id: AssetId,
}
pub type UnsubscribePriceResponse = Empty;

#[derive(Serialize, Deserialize, Debug)]
pub struct OrderCreatedNotification {
    pub order_id: OrderId,
    pub submit_link: String,
    pub order: PriceOrder,
    pub created_at: Timestamp,
    pub expires_at: Timestamp,
    pub own: bool,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct OrderRemovedNotification {
    pub order_id: OrderId,
    pub submit_link: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LinkRequest {
    pub order_id: OrderId,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct LinkResponse {
    pub order: AmountOrder,
    pub submitted: PriceOrder,
    pub side: OrderSide,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct AddrRequest {
    pub order_id: OrderId,
    pub pset: String,
    pub recv_addr: String,
    pub change_addr: String,
}
pub type AddrResponse = Empty;

#[derive(Serialize, Deserialize, Debug)]
pub struct SignNotification {
    pub order_id: OrderId,
    pub pset: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SignRequest {
    pub order_id: OrderId,
    pub signed_pset: String,
    pub side: OrderSide,
}
pub type SignResponse = Empty;

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct CompleteNotification {
    pub order_id: OrderId,
    pub txid: Option<String>,
}

////////////////////////////////////////////////////////////////////////////////

#[derive(Serialize, Deserialize, Debug)]
pub enum Request {
    ServerStatus(Empty),
    Assets(AssetsRequest),
    PegFee(PegFeeRequest),
    Peg(PegRequest),
    PegStatus(PegStatusRequest),

    MatchRfq(MatchRfqRequest),
    MatchRfqCancel(MatchCancelRequest),
    MatchRfqAccept(MatchRfqAcceptRequest),
    MatchQuote(MatchQuoteRequest),
    PriceUpdateBroadcast(PriceUpdateBroadcast),
    PriceUpdateSubscribe(PriceUpdateSubscribe),
    Swap(SwapRequest),
    LoginClient(LoginClientRequest),
    LoginDealer(LoginDealerRequest),

    VerifyDevice(VerifyDeviceRequest),
    RegisterDevice(RegisterDeviceRequest),
    RegisterAddresses(RegisterAddressesRequest),
    UpdatePushToken(UpdatePushTokenRequest),

    RegisterPhone(RegisterPhoneRequest),
    VerifyPhone(VerifyPhoneRequest),

    LoadPrices(LoadPricesRequest),
    CancelPrices(CancelPricesRequest),
    Submit(SubmitRequest),
    Edit(EditRequest),
    Cancel(CancelRequest),
    Subscribe(SubscribeRequest),
    Link(LinkRequest),
    Addr(AddrRequest),
    Sign(SignRequest),
}

#[derive(Serialize, Deserialize, Debug)]
pub enum Response {
    ServerStatus(ServerStatus),
    Assets(AssetsResponse),
    PegFee(PegFeeResponse),
    Peg(PegResponse),
    PegStatus(PegStatus),

    MatchRfq(MatchRfqResponse),
    MatchRfqCancel(Empty),
    MatchRfqAccept(Empty),
    MatchQuote(Empty),
    PriceUpdateBroadcast(Empty),
    PriceUpdateSubscribe(Empty),
    Swap(Empty),
    LoginClient(LoginClientResponse),
    LoginDealer(Empty),

    VerifyDevice(VerifyDeviceResponse),
    RegisterDevice(RegisterDeviceResponse),
    RegisterAddresses(Empty),
    UpdatePushToken(Empty),

    RegisterPhone(RegisterPhoneResponse),
    VerifyPhone(Empty),

    LoadPrices(LoadPricesResponse),
    CancelPrices(CancelPricesResponse),
    Submit(SubmitResponse),
    Edit(EditResponse),
    Cancel(CancelResponse),
    Subscribe(SubscribeResponse),
    Link(LinkResponse),
    Addr(AddrResponse),
    Sign(SignResponse),
}

#[derive(Serialize, Deserialize, Debug)]
pub enum Notification {
    ServerStatus(ServerStatus),
    PegStatus(PegStatus),
    Swap(SwapNotification),
    MatchRfq(MatchRfqUpdate),
    RfqCreated(RfqCreatedNotification),
    RfqRemoved(RfqRemovedNotification),
    PriceUpdate(PriceUpdateNotification),

    UpdatePrices(LoadPricesResponse),
    OrderCreated(OrderCreatedNotification),
    OrderRemoved(OrderRemovedNotification),
    Sign(SignNotification),
    Complete(CompleteNotification),
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

#[derive(Serialize, Deserialize, Debug)]
pub enum TxType {
    Send,
    Recv,
    Swap,
    Redeposit,
    Unknown,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct FcmMessageTx {
    pub txid: String,
    pub tx_type: TxType,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct FcmMessagePeg {
    pub order_id: OrderId,
    pub peg_in: bool,
    pub tx_hash: String,
    pub vout: i32,
    pub created_at: Timestamp,
    pub payout_txid: Option<String>,
    pub payout: i64,
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "snake_case")]
pub enum FcmMessage {
    Tx(FcmMessageTx),
    PegDetected(FcmMessagePeg),
    PegPayout(FcmMessagePeg),
}
