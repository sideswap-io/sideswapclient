use elements::{
    confidential::{AssetBlindingFactor, ValueBlindingFactor},
    Address, AssetId, OutPoint, Txid,
};
use serde::{Deserialize, Serialize};
use sideswap_types::{
    duration_ms::DurationMs, normal_float::NormalFloat, timestamp_ms::TimestampMs,
};

use crate::{ChartPoint, MarketType, Utxo};

// Common types

#[derive(Serialize, Deserialize, Debug, Copy, Clone, Ord, PartialOrd, Eq, PartialEq, Hash)]
pub struct AssetPair {
    pub base: AssetId,
    pub quote: AssetId,
}

impl AssetPair {
    pub fn asset(&self, asset_type: AssetType) -> AssetId {
        match asset_type {
            AssetType::Base => self.base,
            AssetType::Quote => self.quote,
        }
    }
}

#[derive(Serialize, Deserialize, Debug, Copy, Clone, Ord, PartialOrd, Eq, PartialEq, Hash)]
pub struct OrdId(u64);

impl std::fmt::Display for OrdId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        self.0.fmt(f)
    }
}

impl OrdId {
    pub fn new(value: u64) -> OrdId {
        OrdId(value)
    }

    pub fn value(self) -> u64 {
        self.0
    }
}

#[derive(Serialize, Deserialize, Debug, Copy, Clone, Ord, PartialOrd, Eq, PartialEq, Hash)]
pub struct QuoteId(u64);

impl QuoteId {
    pub fn new(value: u64) -> QuoteId {
        QuoteId(value)
    }

    pub fn value(self) -> u64 {
        self.0
    }
}

#[derive(Serialize, Deserialize, Debug, Copy, Clone, Ord, PartialOrd, Eq, PartialEq, Hash)]
pub struct HistId(u64);

impl HistId {
    pub fn new(value: u64) -> HistId {
        HistId(value)
    }

    pub fn value(self) -> u64 {
        self.0
    }
}

#[derive(Serialize, Deserialize, Debug, Copy, Clone, Ord, PartialOrd, Eq, PartialEq)]
pub enum AssetType {
    Base,
    Quote,
}

impl AssetType {
    pub fn inv(self) -> AssetType {
        match self {
            AssetType::Base => AssetType::Quote,
            AssetType::Quote => AssetType::Base,
        }
    }
}

#[derive(Serialize, Deserialize, Debug, Copy, Clone, Ord, PartialOrd, Eq, PartialEq)]
pub enum TradeDir {
    Sell,
    Buy,
}

impl TradeDir {
    pub fn inv(self) -> TradeDir {
        match self {
            TradeDir::Sell => TradeDir::Buy,
            TradeDir::Buy => TradeDir::Sell,
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MarketInfo {
    pub asset_pair: AssetPair,
    pub fee_asset: AssetType,
    #[serde(rename = "type")]
    pub type_: MarketType,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct OwnOrder {
    pub order_id: OrdId,
    pub asset_pair: AssetPair,
    pub price: NormalFloat,
    pub orig_amount: u64,
    pub active_amount: u64,
    pub trade_dir: TradeDir,
    pub private_id: Option<Box<String>>,
}

#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct PublicOrder {
    pub order_id: OrdId,
    pub asset_pair: AssetPair,
    pub trade_dir: TradeDir,
    pub amount: u64,
    pub price: NormalFloat,
    pub online: bool,
}

#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct MakerSwapInfo {
    pub order_id: OrdId,
    pub price: NormalFloat,
    pub base_amount: u64,
    pub quote_amount: u64,
}

pub type InputWitness = Vec<Vec<u8>>;

#[derive(Serialize, Deserialize, Debug)]
pub enum QuoteStatus {
    Success {
        quote_id: QuoteId,
        base_amount: u64,
        quote_amount: u64,
        server_fee: u64,
        fixed_fee: u64,
        ttl: DurationMs,
    },
    LowBalance {
        asset_id: AssetId,
        required: u64,
        available: u64,
    },
    Error {
        error_msg: String,
    },
}

#[derive(Clone, Copy, Debug, Serialize, Deserialize)]
pub enum HistStatus {
    Mempool,
    Confirmed,
    TxConflict,
    TxNotFound,
    Elapsed,
    Cancelled,
    UtxoInvalidated,
    Replaced,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct HistoryOrder {
    pub id: HistId,
    pub order_id: OrdId,
    pub asset_pair: AssetPair,
    pub trade_dir: TradeDir,
    pub base_amount: u64,
    pub quote_amount: u64,
    pub price: NormalFloat,
    pub txid: Option<Txid>,
    pub status: HistStatus,
}

// Requests/responses

#[derive(Serialize, Deserialize, Debug)]
pub struct ListMarketsRequest {}

#[derive(Serialize, Deserialize, Debug)]
pub struct ListMarketsResponse {
    pub markets: Vec<MarketInfo>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RegisterRequest {}

#[derive(Serialize, Deserialize, Debug)]
pub struct RegisterResponse {
    pub token: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LoginRequest {
    pub token: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LoginResponse {
    pub orders: Vec<OwnOrder>,
    pub utxos: Vec<OutPoint>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SubscribeRequest {
    pub asset_pair: AssetPair,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SubscribeResponse {
    pub orders: Vec<PublicOrder>,
    pub timestamp: TimestampMs,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct UnsubscribeRequest {
    pub asset_pair: AssetPair,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct UnsubscribeResponse {}

#[derive(Serialize, Deserialize, Debug)]
pub struct AddUtxosRequest {
    pub utxos: Vec<Utxo>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct AddUtxosResponse {}

#[derive(Serialize, Deserialize, Debug)]
pub struct RemoveUtxosRequest {
    pub utxos: Vec<OutPoint>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RemoveUtxosResponse {}

#[derive(Serialize, Deserialize, Debug)]
pub struct AddOrderRequest {
    pub asset_pair: AssetPair,
    pub base_amount: u64,
    pub price: NormalFloat,
    pub trade_dir: TradeDir,
    pub ttl: Option<DurationMs>,
    pub receive_address: Address,
    pub change_address: Address,
    pub private: bool,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct AddOrderResponse {
    pub order: OwnOrder,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct EditOrderRequest {
    pub order_id: OrdId,
    pub base_amount: Option<u64>,
    pub price: Option<NormalFloat>,
    pub receive_address: Option<Address>,
    pub change_address: Option<Address>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct EditOrderResponse {
    pub order: OwnOrder,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct AddOfflineRequest {
    pub asset_pair: AssetPair,
    pub ttl: Option<DurationMs>,
    pub funding_tx: Option<sideswap_types::Transaction>,
    pub private: bool,

    pub input_utxo: Utxo,
    pub input_witness: InputWitness,

    pub output_address: Address,
    pub output_amount: u64,
    pub output_asset_bf: AssetBlindingFactor,
    pub output_value_bf: ValueBlindingFactor,
    pub output_ephemeral_sk: elements::secp256k1_zkp::SecretKey,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct AddOfflineResponse {
    pub order: OwnOrder,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct CancelOrderRequest {
    pub order_id: OrdId,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct CancelOrderResponse {}

#[derive(Serialize, Deserialize, Debug)]
pub struct ResolveGaidRequest {
    pub asset_id: AssetId,
    pub gaid: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ResolveGaidResponse {
    pub address: Address,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct StartQuotesRequest {
    pub asset_pair: AssetPair,
    pub asset_type: AssetType,
    pub amount: u64,
    pub trade_dir: TradeDir,
    pub utxos: Vec<Utxo>,
    pub receive_address: Address,
    pub change_address: Address,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct StartQuotesResponse {
    pub fee_asset: AssetType,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct StopQuotesRequest {}

#[derive(Serialize, Deserialize, Debug)]
pub struct StopQuotesResponse {}

#[derive(Serialize, Deserialize, Debug)]
pub struct MakerSignRequest {
    pub quote_id: QuoteId,
    pub pset: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct MakerSignResponse {}

#[derive(Serialize, Deserialize, Debug)]
pub struct GetQuoteRequest {
    pub quote_id: QuoteId,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct GetQuoteResponse {
    pub pset: String,
    pub ttl: DurationMs,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct TakerSignRequest {
    pub quote_id: QuoteId,
    pub pset: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct TakerSignResponse {
    pub txid: Txid,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ChartSubRequest {
    pub asset_pair: AssetPair,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ChartSubResponse {
    pub data: Vec<ChartPoint>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ChartUnsubRequest {
    pub asset_pair: AssetPair,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ChartUnsubResponse {}

#[derive(Serialize, Deserialize, Debug)]
pub struct LoadHistoryRequest {
    pub skip: usize,
    pub count: usize,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LoadHistoryResponse {
    pub list: Vec<HistoryOrder>,
    pub total: usize,
}

// Notifications

#[derive(Serialize, Deserialize, Debug)]
pub struct MarketAddedNotif {
    pub market: MarketInfo,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct MarketRemovedNotif {
    pub asset_pair: AssetPair,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct OwnOrderCreatedNotif {
    pub order: OwnOrder,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct OwnOrderRemovedNotif {
    pub order_id: OrdId,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct UtxoAddedNotif {
    pub utxo: OutPoint,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct UtxoRemovedNotif {
    pub utxo: OutPoint,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PublicOrderCreatedNotif {
    pub order: PublicOrder,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PublicOrderRemovedNotif {
    pub order_id: OrdId,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct QuoteNotif {
    pub asset_pair: AssetPair,
    pub asset_type: AssetType,
    pub amount: u64,
    pub trade_dir: TradeDir,
    pub status: QuoteStatus,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct MakerSignNotif {
    pub quote_id: QuoteId,
    pub orders: Vec<MakerSwapInfo>,
    pub pset: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct MarketPriceNotif {
    pub asset_pair: AssetPair,
    pub ind_price: Option<NormalFloat>,
    pub last_price: Option<NormalFloat>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ChartUpdateNotif {
    pub asset_pair: AssetPair,
    pub update: ChartPoint,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct HistoryUpdatedNotif {
    pub order: HistoryOrder,
    pub is_new: bool,
}

// Top level messages

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "snake_case")]
pub enum Request {
    ListMarkets(ListMarketsRequest),
    Register(RegisterRequest),
    Login(LoginRequest),
    Subscribe(SubscribeRequest),
    Unsubscribe(UnsubscribeRequest),
    AddUtxos(AddUtxosRequest),
    RemoveUtxos(RemoveUtxosRequest),
    AddOrder(AddOrderRequest),
    EditOrder(EditOrderRequest),
    AddOffline(AddOfflineRequest),
    CancelOrder(CancelOrderRequest),
    ResolveGaid(ResolveGaidRequest),
    StartQuotes(StartQuotesRequest),
    StopQuotes(StopQuotesRequest),
    MakerSign(MakerSignRequest),
    GetQuote(GetQuoteRequest),
    TakerSign(TakerSignRequest),
    ChartSub(ChartSubRequest),
    ChartUnsub(ChartUnsubRequest),
    LoadHistory(LoadHistoryRequest),
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "snake_case")]
pub enum Response {
    ListMarkets(ListMarketsResponse),
    Register(RegisterResponse),
    Login(LoginResponse),
    Subscribe(SubscribeResponse),
    Unsubscribe(UnsubscribeResponse),
    AddUtxos(AddUtxosResponse),
    RemoveUtxos(RemoveUtxosResponse),
    AddOrder(AddOrderResponse),
    EditOrder(EditOrderResponse),
    AddOffline(AddOfflineResponse),
    CancelOrder(CancelOrderResponse),
    ResolveGaid(ResolveGaidResponse),
    StartQuotes(StartQuotesResponse),
    StopQuotes(StopQuotesResponse),
    MakerSign(MakerSignResponse),
    GetQuote(GetQuoteResponse),
    TakerSign(TakerSignResponse),
    ChartSub(ChartSubResponse),
    ChartUnsub(ChartUnsubResponse),
    LoadHistory(LoadHistoryResponse),
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "snake_case")]
pub enum Notification {
    MarketAdded(MarketAddedNotif),
    MarketRemoved(MarketRemovedNotif),
    UtxoAdded(UtxoAddedNotif),
    UtxoRemoved(UtxoRemovedNotif),
    OwnOrderCreated(OwnOrderCreatedNotif),
    OwnOrderRemoved(OwnOrderRemovedNotif),
    PublicOrderCreated(PublicOrderCreatedNotif),
    PublicOrderRemoved(PublicOrderRemovedNotif),
    Quote(QuoteNotif),
    MakerSign(MakerSignNotif),
    MarketPrice(MarketPriceNotif),
    ChartUpdate(ChartUpdateNotif),
    HistoryUpdated(HistoryUpdatedNotif),
}
