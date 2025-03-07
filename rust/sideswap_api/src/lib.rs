pub mod fcm_models;
pub mod gdk;
pub mod http_rpc;
pub mod market;
pub mod mkt;
pub mod pegx;

pub use elements::{
    confidential::{AssetBlindingFactor, ValueBlindingFactor},
    Address, Txid,
};
use serde::{Deserialize, Serialize};
use sideswap_types::{
    asset_precision::AssetPrecision, fee_rate::FeeRateSats, utxo_ext::UtxoExt, TransactionHex,
};
use std::{collections::BTreeMap, vec::Vec};

pub const TICKER_LBTC: &str = "L-BTC";

pub const TICKER_USDT: &str = "USDt";
pub const TICKER_EURX: &str = "EURx";
pub const TICKER_MEX: &str = "MEX";
pub const TICKER_DEPIX: &str = "DePix";

pub static PATH_JSON_RPC_WS: &str = "json-rpc-ws";
pub static PATH_JSON_RUST_WS: &str = "rust-rpc-ws";

pub const OS_TYPE_OTHER: i32 = 0;
pub const OS_TYPE_ANDROID: i32 = 1;
pub const OS_TYPE_IOS: i32 = 2;

const SWAP_MARKETS_DEFAULT_SERVER_FEE: f64 = 0.001;

pub fn get_os_type() -> i32 {
    if cfg!(target_os = "android") {
        OS_TYPE_ANDROID
    } else if cfg!(target_os = "ios") {
        OS_TYPE_IOS
    } else {
        OS_TYPE_OTHER
    }
}

#[derive(Serialize, Deserialize, Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub enum SubscribedValueType {
    PegInMinAmount,
    PegInWalletBalance,
    PegOutMinAmount,
    PegOutWalletBalance,
}

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Eq)]
pub enum SubscribedValue {
    PegInMinAmount {
        min_amount: u64,
    },

    PegInWalletBalance {
        /// How much L-BTC is available in the hot Liquid Bitcoin wallet (in sats).
        /// If the peg-in amount is less than or equal to this amount, it will be paid after 2 confirmations.
        /// If the peg-in amount is greater than this amount, it will it will be paid after 102 confirmations.
        /// If the bitcoin transaction is not confirmed within 6 hours, the reservation will be released.
        available: u64,
    },

    PegOutMinAmount {
        min_amount: u64,
    },

    PegOutWalletBalance {
        /// How much BTC is available in the hot Bitcoin wallet (in sats).
        /// If the peg-out amount is less than or equal to this amount, it will be paid after 2 confirmations.
        /// If the peg-out amount is greater than this amount, it is usually paid within 20-30 minutes.
        available: u64,
    },
}

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
pub struct HashN<const LEN: usize>(pub [u8; LEN]);

impl<const LEN: usize> rand::distributions::Distribution<HashN<LEN>>
    for rand::distributions::Standard
{
    fn sample<R: rand::Rng + ?Sized>(&self, rng: &mut R) -> HashN<LEN> {
        HashN(rng.gen())
    }
}

impl<const LEN: usize> std::str::FromStr for HashN<LEN> {
    type Err = hex::FromHexError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut data: [u8; LEN] = [0; LEN];
        hex::decode_to_slice(s, &mut data)?;
        data.reverse();
        Ok(HashN(data))
    }
}

impl<const LEN: usize> std::fmt::Display for HashN<LEN> {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        let mut data = self.0;
        data.reverse();
        write!(f, "{}", hex::encode(data))
    }
}

pub type Hash16 = HashN<16>;
pub type Hash32 = HashN<32>;

pub type AssetId = elements::AssetId;

pub type SessionId = Hash32;
pub type OrderId = Hash32;

#[derive(Debug, Hash, PartialEq, Eq, Clone, Ord, PartialOrd, Serialize, Deserialize)]
pub struct Ticker(pub String);

#[derive(Debug, Hash, PartialEq, Eq, Clone, Ord, PartialOrd, Serialize, Deserialize)]
pub struct ContactKey(pub String);

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

#[derive(Debug, Copy, Clone)]
pub struct ServerFee {
    value: f64,
}

impl ServerFee {
    pub fn new(value: Option<f64>) -> Self {
        let value = value.unwrap_or(SWAP_MARKETS_DEFAULT_SERVER_FEE);
        assert!(value >= 0.0);
        assert!(value < 1.0);
        Self { value }
    }
    pub fn value(&self) -> f64 {
        self.value
    }
}

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
pub struct AmpAssetRestrictions {
    pub allowed_countries: Option<Vec<String>>,
}

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
pub struct Asset {
    pub asset_id: AssetId,
    pub name: String,
    pub ticker: Ticker,
    pub icon: Option<String>, // PNG in base64
    pub precision: AssetPrecision,
    pub icon_url: Option<String>,
    pub instant_swaps: Option<bool>,
    pub domain: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub domain_agent: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub domain_agent_link: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub always_show: Option<bool>,
    pub issuance_prevout: Option<IssuancePrevout>,
    pub issuer_pubkey: Option<String>,
    pub contract: Option<serde_json::Value>,
    pub market_type: Option<MarketType>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub server_fee: Option<f64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub amp_asset_restrictions: Option<AmpAssetRestrictions>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub payjoin: Option<bool>,
}

impl Asset {
    pub fn server_fee(&self) -> ServerFee {
        ServerFee::new(self.server_fee)
    }
}

pub type Assets = Vec<Asset>;

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct AssetsRequestParam {
    pub embedded_icons: Option<bool>,
    pub all_assets: Option<bool>,
    pub amp_asset_restrictions: Option<bool>,
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
    pub fee_rate: FeeRateSats,
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

#[derive(Serialize, Deserialize, Debug)]
pub struct PegReturnAddressRequest {
    pub order_id: OrderId,
    pub address: String,
}

pub type PegReturnAddressResponse = Empty;

#[derive(Serialize, Deserialize, Debug, Clone, PartialEq)]
pub struct Swap {
    pub send_asset: AssetId,
    pub send_amount: i64,
    pub recv_asset: AssetId,
    pub recv_amount: i64,
    pub network_fee: i64,
}

// In milliseconds since UNIX epoch
pub type Timestamp = i64;

// bid < ask
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
    pub payout_txid: Option<Hash32>,
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
    pub return_address: Option<String>,
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
    pub value: FeeRateSats,
}

#[derive(Serialize, Deserialize, Debug, PartialEq)]
pub struct ServerStatus {
    pub min_peg_in_amount: i64,
    pub min_peg_out_amount: i64,
    pub server_fee_percent_peg_in: f64,
    pub server_fee_percent_peg_out: f64,
    pub min_submit_amount: i64,
    pub price_band: f64,
    pub elements_fee_rate: FeeRateSats,
    pub bitcoin_fee_rates: Vec<FeeRate>,
    pub upload_url: String,
    pub policy_asset: AssetId,
    pub peg_out_bitcoin_tx_vsize: usize,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LoginClientRequest {
    pub api_key: Option<String>,
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

#[derive(Serialize, Deserialize, Debug, Clone)]
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

pub type PortfolioPricesRequest = Empty;
#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct PortfolioPricesResponse {
    pub prices_usd: BTreeMap<AssetId, f64>,
}

pub type ConversionRatesRequest = Empty;
#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct ConversionRatesResponse {
    // Example: `"EUR": 0.922` (meaning that 1 USD is equal to 0.922 EUR)
    pub usd_conversion_rates: BTreeMap<String, f64>,
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

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct Own {
    pub index_price: Option<f64>,
    pub private: bool,
    pub two_step: bool,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct OrderCreatedNotification {
    pub order_id: OrderId,
    pub details: Details,
    pub created_at: Timestamp,
    pub expires_at: Option<Timestamp>,
    pub two_step: bool,
    pub own: Option<Own>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct OrderRemovedNotification {
    pub asset_id: AssetId,
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
pub struct Utxo {
    pub txid: elements::Txid,
    pub vout: u32,
    pub asset: AssetId,
    pub asset_bf: AssetBlindingFactor,
    pub value: u64,
    pub value_bf: ValueBlindingFactor,
    pub redeem_script: Option<elements::Script>,
}

impl UtxoExt for Utxo {
    fn value(&self) -> u64 {
        self.value
    }

    fn txid(&self) -> elements::Txid {
        self.txid
    }

    fn vout(&self) -> u32 {
        self.vout
    }

    fn redeem_script(&self) -> Option<&elements::Script> {
        self.redeem_script.as_ref()
    }
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct MakerSignedHalf {
    pub chaining_tx: Option<TransactionHex>,
    pub proposal: LiquidexProposal,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PsetMakerRequest {
    pub order_id: OrderId,
    pub price: f64,
    pub private: bool,
    pub ttl_seconds: Option<u64>,
    pub inputs: Vec<Utxo>,
    pub recv_addr: elements::Address,
    pub change_addr: elements::Address,
    pub signed_half: Option<MakerSignedHalf>,
}
pub type PsetMakerResponse = Empty;

#[derive(Serialize, Deserialize, Debug)]
pub struct PsetTakerRequest {
    pub order_id: OrderId,
    pub price: f64,
    pub inputs: Vec<Utxo>,
    pub recv_addr: elements::Address,
    pub change_addr: elements::Address,
}
pub type PsetTakerResponse = Empty;

#[derive(Serialize, Deserialize, Debug, Clone)]
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
    pub precision: AssetPrecision,
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
    pub inputs: Vec<Utxo>,
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
    pub inputs: Vec<Utxo>,
    pub recv_addr: elements::Address,
    pub change_addr: elements::Address,
}

pub type StartSwapDealerResponse = Empty;

#[derive(Serialize, Deserialize, Debug)]
pub struct BlindedSwapClientNotification {
    pub order_id: OrderId,
    pub pset: String,
    pub nonces: Option<Vec<String>>,
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

#[derive(Serialize, Deserialize, Debug, Clone)]
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

#[derive(Serialize, Deserialize, Debug)]
pub struct NewAssetNotification {
    pub asset: Asset,
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

#[derive(Serialize, Deserialize, Debug)]
pub struct SubscribeValueRequest {
    pub value: SubscribedValueType,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SubscribeValueResponse {}

#[derive(Serialize, Deserialize, Debug)]
pub struct UnsubscribeValueRequest {
    pub value: SubscribedValueType,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct UnsubscribeValueResponse {}

#[derive(Serialize, Deserialize, Debug)]
pub struct SubscribedValueNotification {
    pub value: SubscribedValue,
}

////////////////////////////////////////////////////////////////////////////////

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct LiquidexInput {
    pub asset: AssetId,
    pub satoshi: u64,
    pub asset_blinder: AssetBlindingFactor,
    pub value_blind_proof: elements::secp256k1_zkp::RangeProof,
    pub script: Option<elements::Script>, // AMP only
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct LiquidexOutput {
    pub asset: AssetId,
    pub satoshi: u64,
    pub asset_blinder: AssetBlindingFactor,
    pub value_blind_proof: elements::secp256k1_zkp::RangeProof,
    pub blinding_nonce: Option<String>, // AMP only
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct LiquidexProposal {
    pub inputs: [LiquidexInput; 1],
    pub outputs: [LiquidexOutput; 1],
    pub scalars: [elements::secp256k1_zkp::Tweak; 1],
    pub transaction: TransactionHex,
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
    PegReturnAddress(PegReturnAddressRequest),

    PriceUpdateBroadcast(PriceUpdateBroadcast),
    PriceUpdateSubscribe(PriceUpdateSubscribe),
    LoginClient(LoginClientRequest),
    LoginDealer(LoginDealerRequest),

    VerifyDevice(VerifyDeviceRequest),
    RegisterDevice(RegisterDeviceRequest),
    RegisterAddresses(RegisterAddressesRequest),
    UpdatePushToken(UpdatePushTokenRequest),

    LoadPrices(LoadPricesRequest),
    CancelPrices(CancelPricesRequest),
    PortfolioPrices(PortfolioPricesRequest),
    ConversionRates(ConversionRatesRequest),
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

    Market(mkt::Request),

    SubscribeValue(SubscribeValueRequest),
    UnsubscribeValue(UnsubscribeValueRequest),
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
    PegReturnAddress(PegReturnAddressResponse),

    PriceUpdateBroadcast(Empty),
    PriceUpdateSubscribe(Empty),
    LoginClient(LoginClientResponse),
    LoginDealer(Empty),

    VerifyDevice(VerifyDeviceResponse),
    RegisterDevice(RegisterDeviceResponse),
    RegisterAddresses(Empty),
    UpdatePushToken(Empty),

    LoadPrices(LoadPricesResponse),
    CancelPrices(CancelPricesResponse),
    PortfolioPrices(PortfolioPricesResponse),
    ConversionRates(ConversionRatesResponse),
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

    Market(mkt::Response),

    SubscribeValue(SubscribeValueResponse),
    UnsubscribeValue(UnsubscribeValueResponse),
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

    UpdatePriceStream(SubscribePriceStreamResponse),
    StartSwapDealer(StartSwapDealerNotification),
    BlindedSwapClient(BlindedSwapClientNotification),
    BlindedSwapDealer(BlindedSwapDealerNotification),
    SwapDone(SwapDoneNotification),

    NewAsset(NewAssetNotification),
    MarketDataUpdate(MarketDataUpdateNotification),
    NewSwapPrice(NewSwapPriceNotification),

    Market(mkt::Notification),

    SubscribedValue(SubscribedValueNotification),
}

#[derive(Serialize, Deserialize, Debug, Copy, Clone, PartialEq, Eq)]
pub enum ErrorCode {
    ParseError,
    InvalidRequest,
    MethodNotFound,
    InvalidParams,
    InternalError,
    ServerError,

    UnknownToken,

    // GAID is not allowed for trading the requested AMP asset
    UnregisteredGaid,

    #[serde(other)]
    Unknown,
}

pub fn error_code(code: ErrorCode) -> i32 {
    match code {
        ErrorCode::ParseError => -32700,
        ErrorCode::InvalidRequest => -32600,
        ErrorCode::MethodNotFound => -32601,
        ErrorCode::InvalidParams => -32602,
        ErrorCode::InternalError => -32603,
        ErrorCode::ServerError => -32000,
        ErrorCode::Unknown => 0,
        ErrorCode::UnknownToken => 1,
        ErrorCode::UnregisteredGaid => 2,
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
