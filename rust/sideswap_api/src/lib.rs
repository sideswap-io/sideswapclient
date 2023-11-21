pub mod fcm_models;
pub mod gdk;
pub mod http_rpc;

use elements::{
    confidential::{AssetBlindingFactor, ValueBlindingFactor},
    Txid,
};
use serde::{Deserialize, Serialize};
use std::vec::Vec;

pub const TICKER_BTC: &str = "BTC";
pub const TICKER_LBTC: &str = "L-BTC";
pub const TICKER_USDT: &str = "USDt";
pub const TICKER_EURX: &str = "EURx";
pub const TICKER_LCAD: &str = "LCAD";
pub const TICKER_AUDL: &str = "AUDL";

pub static PATH_JSON_RPC_WS: &str = "json-rpc-ws";
pub static PATH_JSON_RUST_WS: &str = "rust-rpc-ws";

pub const OS_TYPE_OTHER: i32 = 0;
pub const OS_TYPE_ANDROID: i32 = 1;
pub const OS_TYPE_IOS: i32 = 2;

pub const CONTACT_ADDRESSES_UPLOAD_COUNT_DEFAULT: usize = 20;
pub const CONTACT_ADDRESSES_UPLOAD_COUNT_MAX: usize = 20;

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
pub struct PhoneKey(pub String);

#[derive(
    Debug,
    Hash,
    PartialEq,
    Eq,
    Copy,
    Clone,
    Ord,
    PartialOrd,
    serde_with::SerializeDisplay,
    serde_with::DeserializeFromStr,
)]
pub struct Hash32(pub [u8; 32]);

impl std::str::FromStr for Hash32 {
    type Err = hex::FromHexError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut data: [u8; 32] = [0; 32];
        hex::decode_to_slice(s, &mut data)?;
        data.reverse();
        Ok(Hash32(data))
    }
}

impl std::fmt::Display for Hash32 {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        let mut data = self.0;
        data.reverse();
        write!(f, "{}", hex::encode(data))
    }
}

pub type AssetId = elements::AssetId;

pub type SessionId = Hash32;
pub type OrderId = Hash32;

#[derive(Debug, Hash, PartialEq, Eq, Clone, Ord, PartialOrd, Serialize, Deserialize)]
pub struct Ticker(pub String);

#[derive(Debug, Hash, PartialEq, Eq, Clone, Ord, PartialOrd, Serialize, Deserialize)]
pub struct ContactKey(pub String);

#[derive(Debug, Hash, PartialEq, Eq, Clone, Ord, PartialOrd, Serialize, Deserialize)]
pub struct AvatarId(pub String);

#[derive(Debug, Serialize, Deserialize, PartialEq, Eq, Copy, Clone)]
pub enum MarketType {
    Stablecoin,
    Amp,
    Token,
}

impl MarketType {
    pub fn priced_in_bitcoins(&self) -> bool {
        *self != MarketType::Stablecoin
    }
}

#[derive(Serialize, Deserialize, Debug, Clone, Eq, PartialEq)]
pub struct IssuancePrevout {
    pub txid: Txid,
    pub vout: u32,
}

#[derive(Serialize, Deserialize, Debug, Clone, Eq, PartialEq)]
pub struct Asset {
    pub asset_id: AssetId,
    pub name: String,
    pub ticker: Ticker,
    pub icon: Option<String>, // PNG in base64
    pub precision: u8,
    pub icon_url: Option<String>,
    pub instant_swaps: Option<bool>,
    pub domain: Option<String>,
    pub domain_agent: Option<String>,
    pub always_show: Option<bool>,
    pub issuance_prevout: Option<IssuancePrevout>,
    pub issuer_pubkey: Option<String>,
    pub contract: Option<serde_json::Value>,
}

pub type Assets = Vec<Asset>;

#[derive(Serialize, Deserialize, Debug, Clone, Eq, PartialEq)]
pub struct AmpAsset {
    pub asset_id: AssetId,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct AssetsRequestParam {
    pub embedded_icons: bool,
}
pub type AssetsRequest = Option<AssetsRequestParam>;

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct AssetsResponse {
    pub assets: Assets,
}

pub type AmpAssetsRequest = Option<AssetsRequestParam>;

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct AmpAssetsResponse {
    pub assets: Vec<Asset>,
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

#[derive(Serialize, Deserialize, Debug, Copy, Clone)]
pub struct PegOutAmounts {
    pub send_amount: i64,
    pub recv_amount: i64,
    pub is_send_entered: bool,
    pub fee_rate: f64,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PegRequest {
    pub recv_addr: String,
    pub send_amount: Option<i64>,
    pub peg_in: bool,
    pub device_key: Option<String>,
    pub blocks: Option<i32>,
    pub peg_out_amounts: Option<PegOutAmounts>,
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
    pub peg_in: Option<bool>,
}

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
pub struct Swap {
    pub send_asset: AssetId,
    pub send_amount: i64,
    pub recv_asset: AssetId,
    pub recv_amount: i64,
    pub network_fee: i64,
}

#[derive(Serialize, Deserialize, Debug, Clone, Eq, PartialEq)]
pub struct MatchRfq {
    pub send_asset: AssetId,
    pub send_amount: i64,
    pub recv_asset: AssetId,
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
pub struct LocalMessageNotification {
    pub title: String,
    pub body: String,
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

#[derive(Serialize, Deserialize, Debug, Clone, Eq, PartialEq, PartialOrd, Ord)]
pub enum RequestId {
    String(RequestIdString),
    Int(RequestIdInt),
}

#[derive(Serialize, Deserialize, Debug, PartialEq)]
pub struct FeeRate {
    pub blocks: i32,
    pub value: f64,
}

#[derive(Serialize, Deserialize, Debug, PartialEq)]
pub struct ServerStatus {
    pub min_peg_in_amount: i64,
    pub min_peg_out_amount: i64,
    pub server_fee_percent_peg_in: f64,
    pub server_fee_percent_peg_out: f64,
    pub min_submit_amount: i64,
    pub price_band: f64,
    pub elements_fee_rate: f64,
    pub bitcoin_fee_rates: Vec<FeeRate>,
    pub upload_url: String,
    pub policy_asset: AssetId,
    pub peg_out_bitcoin_tx_vsize: i32,
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
    pub country_code: String,
    pub phone_number: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RegisterPhoneResponse {
    pub register_id: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct VerifyPhoneRequest {
    pub register_id: String,
    pub code: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct VerifyPhoneResponse {
    pub phone_key: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct UnregisterPhoneRequest {
    pub phone_key: PhoneKey,
}

pub type UnregisterPhoneResponse = Empty;

#[derive(Serialize, Deserialize, Debug)]
pub struct UploadAvatarRequest {
    pub phone_key: PhoneKey,
    pub image: String,
}
pub type UploadAvatarResponse = Empty;

#[derive(Serialize, Deserialize, Debug)]
pub struct UploadContact {
    pub identifier: String,
    pub name: String,
    pub phones: Vec<String>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct UploadContactsRequest {
    pub phone_key: PhoneKey,
    pub contacts: Vec<UploadContact>,
}
pub type UploadContactsResponse = Empty;

#[derive(Serialize, Deserialize, Debug)]
pub struct Contact {
    pub contact_key: ContactKey,
    pub name: String,
    pub phone: String,
    pub avatar: Option<AvatarId>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ContactTransaction {
    pub contact_key: ContactKey,
    pub txid: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct DownloadContactsRequest {
    pub phone_key: PhoneKey,
}
#[derive(Serialize, Deserialize, Debug, Default)]
pub struct DownloadContactsResponse {
    pub registered: bool,
    pub contacts: Vec<Contact>,
    pub transactions: Vec<ContactTransaction>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ContactCreatedNotification {
    pub contact: Contact,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ContactRemovedNotification {
    pub contact_key: ContactKey,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ContactTransactionCreatedNotification {
    pub tx: ContactTransaction,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct AccountStatusNotification {
    pub registered: bool,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ContactAddrRequest {
    pub phone_key: PhoneKey,
    pub contact_key: ContactKey,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct ContactAddrResponse {
    pub addr: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ContactBroadcastRequest {
    pub raw_tx: String,
    pub phone_key: PhoneKey,
    pub contact_key: ContactKey,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct ContactBroadcastResponse {
    pub txid: String,
}

////////////////////////////////////////////////////////////////////////////////

#[derive(Serialize, Deserialize, Debug)]
pub enum Void {}
pub type Empty = Option<Void>;

////////////////////////////////////////////////////////////////////////////////
// New API

#[derive(Serialize, Deserialize, Debug, PartialEq, Eq, Clone, Copy)]
pub enum OrderSide {
    Maker,
    Taker,
}

#[derive(Serialize, Deserialize, Debug, PartialEq, Eq, Clone, Copy)]
pub enum OrderType {
    Bitcoin,
    Asset,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Details {
    pub asset: AssetId,
    pub bitcoin_amount: i64,
    pub asset_amount: i64,
    pub price: f64,
    pub server_fee: i64,
    pub side: OrderSide,
    pub send_bitcoins: bool,
    pub order_type: OrderType,
    pub market: MarketType,
    pub two_step: Option<bool>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct PriceOrder {
    pub asset: AssetId,
    pub bitcoin_amount: Option<f64>,
    pub asset_amount: Option<f64>,
    pub price: Option<f64>,
    pub index_price: Option<f64>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LoadPricesRequest {
    pub asset: AssetId,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct LoadPricesResponse {
    pub asset: AssetId,
    pub ind: Option<f64>,
    pub last: Option<f64>,
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
    pub details: Details,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct EditRequest {
    pub order_id: OrderId,
    pub price: Option<f64>,
    pub index_price: Option<f64>,
}
pub type EditResponse = Empty;

#[derive(Serialize, Deserialize, Debug)]
pub struct CancelRequest {
    pub order_id: OrderId,
}
pub type CancelResponse = Empty;

#[derive(Serialize, Deserialize, Debug)]
pub struct LoginRequest {
    pub session_id: Option<SessionId>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LoginResponse {
    pub session_id: SessionId,
    pub orders: Vec<OrderCreatedNotification>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SubscribeRequest {
    pub asset: Option<AssetId>,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct SubscribeResponse {
    pub asset: Option<AssetId>,
    pub orders: Vec<OrderCreatedNotification>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct UnsubscribeRequest {
    pub asset: Option<AssetId>,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct UnsubscribeResponse {
    pub asset: Option<AssetId>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Own {
    pub index_price: Option<f64>,
    pub private: bool,
    pub two_step: bool,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct OrderCreatedNotification {
    pub order_id: OrderId,
    pub details: Details,
    pub created_at: Timestamp,
    pub expires_at: Option<Timestamp>,
    pub own: Option<Own>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct OrderRemovedNotification {
    pub order_id: OrderId,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LinkRequest {
    pub order_id: OrderId,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LinkResponse {
    pub order_id: OrderId,
    pub details: Details,
    pub index_price: bool,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct PsetInput {
    pub txid: elements::Txid,
    pub vout: u32,
    pub asset: AssetId,
    pub asset_bf: AssetBlindingFactor,
    pub value: u64,
    pub value_bf: ValueBlindingFactor,
    pub redeem_script: Option<elements::Script>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct MakerSignedHalf {
    pub chaining_tx: Option<sideswap_types::Transaction>,
    pub proposal: LiquidexProposal,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PsetMakerRequest {
    pub order_id: OrderId,
    pub price: f64,
    pub private: bool,
    pub ttl_seconds: Option<u64>,
    pub inputs: Vec<PsetInput>,
    pub recv_addr: elements::Address,
    pub change_addr: elements::Address,
    pub signed_half: Option<MakerSignedHalf>,
}
pub type PsetMakerResponse = Empty;

#[derive(Serialize, Deserialize, Debug)]
pub struct PsetTakerRequest {
    pub order_id: OrderId,
    pub price: f64,
    pub inputs: Vec<PsetInput>,
    pub recv_addr: elements::Address,
    pub change_addr: elements::Address,
}
pub type PsetTakerResponse = Empty;

#[derive(Serialize, Deserialize, Debug)]
pub struct SignNotification {
    pub order_id: OrderId,
    pub pset: String,
    pub details: Details,
    pub nonces: Option<Vec<String>>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SignRequest {
    pub order_id: OrderId,
    pub signed_pset: String,
    pub side: OrderSide,
}
pub type SignResponse = Empty;

#[derive(Serialize, Deserialize, Debug)]
pub struct GetSignRequest {
    pub order_id: OrderId,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct GetSignResponse {
    pub data: SignNotification,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ResolveGaidRequest {
    pub order_id: OrderId,
    pub gaid: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ResolveGaidResponse {
    pub address: elements::Address,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct GaidStatusRequest {
    pub gaid: String,
    pub asset_id: AssetId,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct GaidStatusResponse {
    pub gaid: String,
    pub asset_id: AssetId,
    pub error: Option<String>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct AssetDetailsRequest {
    pub asset_id: AssetId,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct AssetStats {
    pub issued_amount: i64,
    pub burned_amount: i64,
    pub offline_amount: Option<i64>,
    pub has_blinded_issuances: bool,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct ChartStats {
    pub low: f64,
    pub high: f64,
    pub last: f64,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct AssetDetailsResponse {
    pub asset_id: AssetId,
    pub name: String,
    pub ticker: Ticker,
    pub precision: u8,
    pub icon_url: String,
    pub domain: String,
    pub domain_agent: Option<String>,
    pub chain_stats: Option<AssetStats>,
    pub chart_url: Option<String>,
    pub chart_stats: Option<ChartStats>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct CompleteNotification {
    pub order_id: OrderId,
    pub txid: Option<elements::Txid>,
}

#[derive(Serialize, Deserialize, Debug, PartialOrd, PartialEq, Copy, Clone)]
pub struct PriceOffer {
    pub client_send_bitcoins: bool,
    pub price: f64,
    pub max_send_amount: i64,
}

pub type PriceOffers = Vec<PriceOffer>;

#[derive(Serialize, Deserialize, Debug)]
pub struct BroadcastPriceStreamRequest {
    pub asset: AssetId,
    pub list: PriceOffers,
    pub balancing: bool,
}

pub type BroadcastPriceStreamResponse = Empty;

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Eq)]
pub struct SubscribePriceStreamRequest {
    pub subscribe_id: Option<String>,
    pub asset: AssetId,
    pub send_bitcoins: bool,
    pub send_amount: Option<i64>,
    pub recv_amount: Option<i64>,
}

#[derive(Serialize, Deserialize, Debug, PartialEq)]
pub struct SubscribePriceStreamResponse {
    pub subscribe_id: Option<String>,
    pub asset: AssetId,
    pub send_bitcoins: bool,
    pub send_amount: Option<i64>,
    pub recv_amount: Option<i64>,
    pub fixed_fee: Option<i64>,
    pub price: Option<f64>,
    pub error_msg: Option<String>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct UnsubscribePriceStreamRequest {
    pub subscribe_id: Option<String>,
}

pub type UnsubscribePriceStreamResponse = Empty;

// New swap API

#[derive(Serialize, Deserialize, Debug)]
pub struct StartSwapWebRequest {
    pub price: f64,
    pub asset: AssetId,
    pub send_bitcoins: bool,
    pub send_amount: i64,
    pub recv_amount: i64,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct StartSwapWebResponse {
    pub order_id: OrderId,
    pub send_asset: AssetId,
    pub send_amount: i64,
    pub recv_asset: AssetId,
    pub recv_amount: i64,
    pub upload_url: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct StartSwapClientRequest {
    pub price: f64,
    pub asset: AssetId,
    pub send_bitcoins: bool,
    pub send_amount: i64,
    pub recv_amount: i64,
    pub inputs: Vec<PsetInput>,
    pub recv_addr: elements::Address,
    pub change_addr: elements::Address,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct StartSwapClientResponse {
    pub order_id: OrderId,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct StartSwapDealerNotification {
    pub order_id: OrderId,
    pub send_asset: AssetId,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct StartSwapDealerRequest {
    pub order_id: OrderId,
    pub inputs: Vec<PsetInput>,
    pub recv_addr: elements::Address,
    pub change_addr: elements::Address,
}

pub type StartSwapDealerResponse = Empty;

#[derive(Serialize, Deserialize, Debug)]
pub struct BlindedSwapClientNotification {
    pub order_id: OrderId,
    pub pset: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SignedSwapClientRequest {
    pub order_id: OrderId,
    pub pset: String,
}

pub type SignedSwapClientResponse = Empty;

#[derive(Serialize, Deserialize, Debug)]
pub struct BlindedSwapDealerNotification {
    pub order_id: OrderId,
    pub pset: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SignedSwapDealerRequest {
    pub order_id: OrderId,
    pub pset: String,
}

pub type SignedSwapDealerResponse = Empty;

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Eq)]
pub enum SwapDoneStatus {
    Success,
    ClientError,
    DealerError,
    ServerError,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SwapDoneNotification {
    pub order_id: OrderId,
    pub status: SwapDoneStatus,
    pub txid: Option<elements::Txid>,
    pub send_asset: AssetId,
    pub send_amount: i64,
    pub recv_asset: AssetId,
    pub recv_amount: i64,
    pub network_fee: Option<i64>,
    pub price: f64,
}

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
pub struct ChartPoint {
    pub time: String,
    pub open: f64,
    pub close: f64,
    pub high: f64,
    pub low: f64,
    pub volume: f64,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct MarketDataSubscribeRequest {
    pub asset: AssetId,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct MarketDataSubscribeResponse {
    pub asset: AssetId,
    pub data: Vec<ChartPoint>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct MarketDataUnsubscribeRequest {
    pub asset: AssetId,
}

pub type MarketDataUnsubscribeResponse = Empty;

#[derive(Serialize, Deserialize, Debug)]
pub struct MarketDataUpdateNotification {
    pub asset: AssetId,
    pub update: ChartPoint,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct SwapPrice {
    pub asset_id: AssetId,
    pub txid: elements::Txid,
    pub price: f64,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SwapPricesRequest {
    pub token: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SwapPricesResponse {
    pub swap_prices: Vec<SwapPrice>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct NewSwapPriceNotification {
    pub swap_price: SwapPrice,
}

////////////////////////////////////////////////////////////////////////////////

#[derive(Serialize, Deserialize, Debug)]
pub struct LiquidexInput {
    pub asset: AssetId,
    pub satoshi: u64,
    pub asset_blinder: AssetBlindingFactor,
    pub value_blind_proof: elements::secp256k1_zkp::RangeProof,
    pub script: Option<elements::Script>, // AMP only
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LiquidexOutput {
    pub asset: AssetId,
    pub satoshi: u64,
    pub asset_blinder: AssetBlindingFactor,
    pub value_blind_proof: elements::secp256k1_zkp::RangeProof,
    pub blinding_nonce: Option<String>, // AMP only
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LiquidexProposal {
    pub inputs: [LiquidexInput; 1],
    pub outputs: [LiquidexOutput; 1],
    pub scalars: [elements::secp256k1_zkp::Tweak; 1],
    pub transaction: sideswap_types::Transaction,
    pub version: u32,
}

////////////////////////////////////////////////////////////////////////////////

#[derive(Serialize, Deserialize, Debug)]
pub enum Request {
    Ping(Empty),
    ServerStatus(Empty),
    Assets(AssetsRequest),
    AmpAssets(AmpAssetsRequest),
    PegFee(PegFeeRequest),
    Peg(PegRequest),
    PegStatus(PegStatusRequest),

    MatchRfq(MatchRfqRequest),
    PriceUpdateBroadcast(PriceUpdateBroadcast),
    PriceUpdateSubscribe(PriceUpdateSubscribe),
    LoginClient(LoginClientRequest),
    LoginDealer(LoginDealerRequest),

    VerifyDevice(VerifyDeviceRequest),
    RegisterDevice(RegisterDeviceRequest),
    RegisterAddresses(RegisterAddressesRequest),
    UpdatePushToken(UpdatePushTokenRequest),

    RegisterPhone(RegisterPhoneRequest),
    VerifyPhone(VerifyPhoneRequest),
    UnregisterPhone(UnregisterPhoneRequest),
    UploadAvatar(UploadAvatarRequest),
    UploadContacts(UploadContactsRequest),
    DownloadContacts(DownloadContactsRequest),
    ContactAddr(ContactAddrRequest),
    ContactBroadcast(ContactBroadcastRequest),

    LoadPrices(LoadPricesRequest),
    CancelPrices(CancelPricesRequest),
    Submit(SubmitRequest),
    Edit(EditRequest),
    Cancel(CancelRequest),
    Login(LoginRequest),
    Subscribe(SubscribeRequest),
    Unsubscribe(UnsubscribeRequest),
    Link(LinkRequest),
    PsetMaker(PsetMakerRequest),
    PsetTaker(PsetTakerRequest),
    Sign(SignRequest),
    GetSign(GetSignRequest),
    ResolveGaid(ResolveGaidRequest),
    GaidStatus(GaidStatusRequest),
    AssetDetails(AssetDetailsRequest),

    BroadcastPriceStream(BroadcastPriceStreamRequest),
    SubscribePriceStream(SubscribePriceStreamRequest),
    UnsubscribePriceStream(UnsubscribePriceStreamRequest),
    StartSwapWeb(StartSwapWebRequest),
    StartSwapClient(StartSwapClientRequest),
    StartSwapDealer(StartSwapDealerRequest),
    SignedSwapClient(SignedSwapClientRequest),
    SignedSwapDealer(SignedSwapDealerRequest),

    MarketDataSubscribe(MarketDataSubscribeRequest),
    MarketDataUnsubscribe(MarketDataUnsubscribeRequest),
    SwapPrices(SwapPricesRequest),
}

#[derive(Serialize, Deserialize, Debug)]
pub enum Response {
    Ping(Empty),
    ServerStatus(ServerStatus),
    Assets(AssetsResponse),
    AmpAssets(AmpAssetsResponse),
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
    VerifyPhone(VerifyPhoneResponse),
    UnregisterPhone(UnregisterPhoneResponse),
    UploadAvatar(UploadAvatarResponse),
    UploadContacts(UploadContactsResponse),
    DownloadContacts(DownloadContactsResponse),
    ContactAddr(ContactAddrResponse),
    ContactBroadcast(ContactBroadcastResponse),

    LoadPrices(LoadPricesResponse),
    CancelPrices(CancelPricesResponse),
    Submit(SubmitResponse),
    Edit(EditResponse),
    Cancel(CancelResponse),
    Login(LoginResponse),
    Subscribe(SubscribeResponse),
    Unsubscribe(UnsubscribeResponse),
    Link(LinkResponse),
    PsetMaker(PsetMakerResponse),
    PsetTaker(PsetTakerResponse),
    Sign(SignResponse),
    GetSign(GetSignResponse),
    ResolveGaid(ResolveGaidResponse),
    GaidStatus(GaidStatusResponse),
    AssetDetails(AssetDetailsResponse),

    BroadcastPriceStream(BroadcastPriceStreamResponse),
    SubscribePriceStream(SubscribePriceStreamResponse),
    UnsubscribePriceStream(UnsubscribePriceStreamResponse),
    StartSwapWeb(StartSwapWebResponse),
    StartSwapClient(StartSwapClientResponse),
    StartSwapDealer(StartSwapDealerResponse),
    SignedSwapClient(SignedSwapClientResponse),
    SignedSwapDealer(SignedSwapDealerResponse),

    MarketDataSubscribe(MarketDataSubscribeResponse),
    MarketDataUnsubscribe(MarketDataUnsubscribeResponse),
    SwapPrices(SwapPricesResponse),
}

#[derive(Serialize, Deserialize, Debug)]
pub enum Notification {
    ServerStatus(ServerStatus),
    PegStatus(PegStatus),
    PriceUpdate(PriceUpdateNotification),
    LocalMessage(LocalMessageNotification),

    UpdatePrices(LoadPricesResponse),
    OrderCreated(OrderCreatedNotification),
    OrderRemoved(OrderRemovedNotification),
    Sign(SignNotification),
    Complete(CompleteNotification),

    ContactCreated(ContactCreatedNotification),
    ContactRemoved(ContactRemovedNotification),
    ContactTransaction(ContactTransactionCreatedNotification),
    AccountStatus(AccountStatusNotification),

    UpdatePriceStream(SubscribePriceStreamResponse),
    StartSwapDealer(StartSwapDealerNotification),
    BlindedSwapClient(BlindedSwapClientNotification),
    BlindedSwapDealer(BlindedSwapDealerNotification),
    SwapDone(SwapDoneNotification),

    MarketDataUpdate(MarketDataUpdateNotification),
    NewSwapPrice(NewSwapPriceNotification),
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
