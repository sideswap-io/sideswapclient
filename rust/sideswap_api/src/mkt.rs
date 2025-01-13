use elements::{
    confidential::{AssetBlindingFactor, ValueBlindingFactor},
    Address, AssetId, OutPoint, Txid,
};
use serde::{Deserialize, Serialize};
use sideswap_types::{
    duration_ms::DurationMs, normal_float::NormalFloat, timestamp_ms::TimestampMs, TransactionHex,
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

#[derive(Serialize, Deserialize, Debug, Copy, Clone, Ord, PartialOrd, Eq, PartialEq, Hash)]
pub struct QuoteSubId(u64);

impl QuoteSubId {
    pub fn new(value: u64) -> QuoteSubId {
        QuoteSubId(value)
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

    pub fn base_trade_dir(self, asset_type: AssetType) -> TradeDir {
        match asset_type {
            AssetType::Base => self,
            AssetType::Quote => self.inv(),
        }
    }

    pub fn send_asset(base_trade_dir: TradeDir) -> AssetType {
        match base_trade_dir {
            TradeDir::Sell => AssetType::Base,
            TradeDir::Buy => AssetType::Quote,
        }
    }

    pub fn recv_asset(base_trade_dir: TradeDir) -> AssetType {
        match base_trade_dir {
            TradeDir::Sell => AssetType::Quote,
            TradeDir::Buy => AssetType::Base,
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
    pub created_at: TimestampMs,
    pub client_order_id: Option<Box<String>>,
    pub asset_pair: AssetPair,
    pub price: NormalFloat,
    pub orig_amount: u64,
    pub active_amount: u64,
    pub trade_dir: TradeDir,
    pub ttl: Option<DurationMs>,
    pub private_id: Option<Box<String>>,
    pub online: bool,
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
        base_amount: u64,
        quote_amount: u64,
        server_fee: u64,
        fixed_fee: u64,
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
    pub client_order_id: Option<Box<String>>,
    pub asset_pair: AssetPair,
    pub trade_dir: TradeDir,
    pub base_amount: u64,
    pub quote_amount: u64,
    pub price: NormalFloat,
    pub txid: Option<Txid>,
    pub status: HistStatus,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct WalletKey {
    pub public_key: elements::secp256k1_zkp::PublicKey,
    pub signature: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ClientEvent {
    AddOrder {
        asset_pair: AssetPair,
        base_amount: u64,
        #[serde(skip_serializing_if = "Option::is_none")]
        min_price: Option<NormalFloat>,
        #[serde(skip_serializing_if = "Option::is_none")]
        max_price: Option<NormalFloat>,
        trade_dir: TradeDir,
        #[serde(skip_serializing_if = "Option::is_none")]
        ttl: Option<DurationMs>,
        receive_address: Address,
        change_address: Address,
        private: bool,
        #[serde(skip_serializing_if = "Option::is_none")]
        client_order_id: Option<Box<String>>,
    },
    EditOrder {
        order_id: OrdId,
        #[serde(skip_serializing_if = "Option::is_none")]
        base_amount: Option<u64>,
        #[serde(skip_serializing_if = "Option::is_none")]
        min_price: Option<NormalFloat>,
        #[serde(skip_serializing_if = "Option::is_none")]
        max_price: Option<NormalFloat>,
        #[serde(skip_serializing_if = "Option::is_none")]
        receive_address: Option<Address>,
        #[serde(skip_serializing_if = "Option::is_none")]
        change_address: Option<Address>,
    },
    Ack {
        nonce: u32,
    },
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ServerEvent {
    OrderCreated {
        order_id: OrdId,
        created_at: TimestampMs,
    },
    OrderEdited {
        order_id: OrdId,
        updated_at: TimestampMs,
    },
    OrderRemoved {
        order_id: OrdId,
    },
    NewSwap {
        created_at: TimestampMs,
        order_id: OrdId,
        hist_id: HistId,
        base_amount: u64,
        quote_amount: u64,
        price: NormalFloat,
        txid: Txid,
    },
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum EventWithSignature {
    Client {
        event: ClientEvent,
        signature: String,
    },
    Server {
        event: ServerEvent,
    },
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum EventWithoutSignature {
    Client { event: ClientEvent },
    Server { event: ServerEvent },
}

// Requests/responses

#[derive(Serialize, Deserialize, Debug)]
pub struct ListMarketsRequest {}

#[derive(Serialize, Deserialize, Debug)]
pub struct ListMarketsResponse {
    pub markets: Vec<MarketInfo>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ChallengeRequest {}

#[derive(Serialize, Deserialize, Debug)]
pub struct ChallengeResponse {
    pub challenge: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RegisterRequest {
    pub wallet_key: Option<WalletKey>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RegisterResponse {
    pub token: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LoginRequest {
    pub token: String,
    #[serde(default)]
    pub is_mobile: bool,
    #[serde(default)]
    pub is_jade: bool,
    #[serde(default)]
    pub event_count: usize,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LoginResponse {
    pub orders: Vec<OwnOrder>,
    pub utxos: Vec<OutPoint>,
    pub new_events: Vec<EventWithSignature>,
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
pub struct AddUtxosResponse {
    // The list of known UTXOs
    pub utxos: Vec<OutPoint>,
}

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
    pub client_order_id: Option<Box<String>>,
    pub signature: Option<String>,
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
    pub signature: Option<String>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct EditOrderResponse {
    pub order: OwnOrder,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct AddOfflineRequest {
    pub asset_pair: AssetPair,
    pub funding_tx: Option<TransactionHex>,
    pub private: bool,
    pub client_order_id: Option<Box<String>>,
    pub ttl: Option<DurationMs>,

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
    pub order_id: Option<OrdId>,
    pub private_id: Option<Box<String>>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct StartQuotesResponse {
    pub quote_sub_id: QuoteSubId,
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
pub struct GetOrderRequest {
    pub order_id: OrdId,
    pub private_id: Option<Box<String>>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct GetOrderResponse {
    pub asset_pair: AssetPair,
    pub trade_dir: TradeDir,
    pub amount: u64,
    pub price: NormalFloat,
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
    pub start_time: Option<TimestampMs>,
    pub end_time: Option<TimestampMs>,
    pub skip: Option<usize>,
    pub count: Option<usize>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LoadHistoryResponse {
    pub list: Vec<HistoryOrder>,
    pub total: usize,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct GetTransactionRequest {
    pub txid: Txid,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct GetTransactionResponse {
    pub tx: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct AckRequest {
    pub nonce: u32,
    pub signature: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct AckResponse {}

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
    pub asset_pair: AssetPair,
    pub order_id: OrdId,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct QuoteNotif {
    pub quote_sub_id: QuoteSubId,
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

#[derive(Serialize, Deserialize, Debug)]
pub struct NewEventNotif {
    pub event: EventWithSignature,
}

// Top level messages

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "snake_case")]
pub enum Request {
    ListMarkets(ListMarketsRequest),
    Challenge(ChallengeRequest),
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
    GetOrder(GetOrderRequest),
    ChartSub(ChartSubRequest),
    ChartUnsub(ChartUnsubRequest),
    LoadHistory(LoadHistoryRequest),
    GetTransaction(GetTransactionRequest),
    Ack(AckRequest),
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "snake_case")]
pub enum Response {
    ListMarkets(ListMarketsResponse),
    Challenge(ChallengeResponse),
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
    GetOrder(GetOrderResponse),
    ChartSub(ChartSubResponse),
    ChartUnsub(ChartUnsubResponse),
    LoadHistory(LoadHistoryResponse),
    GetTransaction(GetTransactionResponse),
    Ack(AckResponse),
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
    NewEvent(NewEventNotif),
}
