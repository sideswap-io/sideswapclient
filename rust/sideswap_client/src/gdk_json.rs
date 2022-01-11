use sideswap_api::{AssetId, BlindingFactor, Txid};
use std::collections::BTreeMap;

use serde::{Deserialize, Serialize};
#[derive(Serialize)]
pub struct InitConfig {
    pub datadir: String,
}

#[derive(Serialize)]
pub struct ConnectConfig {
    pub name: String,
    pub log_level: Option<String>,
}

#[derive(Serialize)]
pub struct LoginUser {
    pub mnemonic: String,
}

#[derive(Deserialize)]
pub struct LoginUserResult {
    pub wallet_hash_id: String,
}

#[derive(Deserialize, Clone)]
pub struct Subaccount {
    pub hidden: bool,
    pub name: String,
    pub pointer: i32,
    pub receiving_id: String,
    #[serde(rename = "type")]
    pub type_: String,
}

#[derive(Deserialize)]
pub struct GetSubaccountsResult {
    pub subaccounts: Vec<Subaccount>,
}

#[derive(Serialize)]
pub struct CreateSubaccount {
    pub name: String,
    #[serde(rename = "type")]
    pub type_: String,
}

#[derive(Deserialize)]
pub struct CreateSubaccountResult {}

#[derive(Serialize)]
pub struct ListTransactions {
    pub subaccount: i32,
    pub first: i32,
    pub count: i32,
}

#[derive(Serialize)]
pub struct HwDevice {}

#[derive(Serialize)]
pub struct UnspentOutputsArgs {
    pub subaccount: i32,
    pub num_confs: i32,
}

#[derive(Deserialize)]
pub struct UnspentOutput {
    pub txhash: Txid,
    pub pt_idx: u32,
    pub asset_id: AssetId,
    pub satoshi: u64,
    pub amountblinder: Option<BlindingFactor>,
    pub assetblinder: Option<BlindingFactor>,
}

pub type UnspentOutputs = std::collections::BTreeMap<AssetId, Vec<UnspentOutput>>;

#[derive(Deserialize)]
pub struct UnspentOutputsParsedResult {
    pub unspent_outputs: UnspentOutputs,
}

#[derive(Deserialize)]
pub struct UnspentOutputsJsonResult {
    pub unspent_outputs: serde_json::Value,
}

#[derive(Deserialize)]
pub struct UnspentOutputsJsonMapResult {
    pub unspent_outputs: BTreeMap<sideswap_api::AssetId, Vec<serde_json::Value>>,
}

#[derive(Deserialize, Debug, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum Status {
    Done,
    Error,
    RequestCode,
    ResolveCode,
    Call,
}

#[derive(Deserialize, Debug)]
pub struct AuthHandler<T> {
    pub result: Option<T>,
    pub error: Option<String>,
    pub status: Status,
}

#[derive(Deserialize, Debug)]
pub struct TransactionInput {
    pub asset_id: Option<AssetId>,
    pub satoshi: Option<u64>,
    pub assetblinder: Option<BlindingFactor>,
    pub amountblinder: Option<BlindingFactor>,
}

#[derive(Deserialize, Debug)]
pub struct TransactionOutput {
    pub asset_id: Option<AssetId>,
    pub satoshi: Option<u64>,
    pub assetblinder: Option<BlindingFactor>,
    pub amountblinder: Option<BlindingFactor>,
}

#[derive(Deserialize, Debug)]
pub struct Transaction {
    pub txhash: sideswap_api::Txid,
    pub block_height: u32,
    pub created_at_ts: i64,
    pub fee: u32,
    pub memo: String,
    pub inputs: Vec<TransactionInput>,
    pub outputs: Vec<TransactionOutput>,
}

#[derive(Deserialize, Debug)]
pub struct TransactionList {
    pub transactions: Vec<Transaction>,
}

pub type BalanceList = BTreeMap<sideswap_api::AssetId, u64>;

#[derive(Serialize, Debug)]
pub struct RecvAddrOpt {
    pub subaccount: i32,
}

#[derive(Deserialize, Debug)]
pub struct RecvAddrResult {
    pub address: String,
}

#[derive(Serialize, Debug)]
pub struct TxAddressee {
    pub address: String,
    pub satoshi: u64,
    pub asset_id: AssetId,
}

#[derive(Serialize, Debug)]
pub struct CreateTransactionOpt {
    pub subaccount: i32,
    pub addressees: Vec<TxAddressee>,
    pub utxos: serde_json::Value,
    pub send_all: bool,
}

#[derive(Deserialize, Debug)]
pub struct CreateTransactionResult {
    pub fee: u64,
}

#[derive(Serialize, Debug)]
pub struct PsetDetailsOpt {
    pub psbt: String,
    pub utxos: Vec<serde_json::Value>,
}

#[derive(Deserialize, Debug)]
pub struct PsetInput {
    pub asset_id: AssetId,
    pub satoshi: u64,
    pub subaccount: i32,
}

#[derive(Deserialize, Debug)]
pub struct PsetDetailsResult {
    pub inputs: Vec<PsetInput>,
    pub outputs: Vec<PsetInput>,
}

#[derive(Serialize, Debug)]
pub struct SignPsetOpt {
    pub psbt: String,
    pub utxos: Vec<serde_json::Value>,
    pub blinding_nonces: Vec<String>,
}

#[derive(Deserialize, Debug)]
pub struct SignPsetResult {
    pub psbt: String,
}

#[derive(Deserialize, Debug)]
pub struct SendTransactionResult {
    pub txhash: sideswap_api::Txid,
}

#[derive(Serialize, Debug)]
#[serde(rename_all = "snake_case")]
pub enum ReconnectHint {
    Now,
    Disable,
}

#[derive(Serialize, Debug)]
pub struct ReconnectHintOpt {
    pub hint: ReconnectHint,
}

#[derive(Deserialize, Debug)]
pub struct NotificationBlock {
    pub block_hash: String,
    pub block_height: u32,
    pub initial_timestamp: u32,
    pub previous_hash: String,
}

#[derive(Deserialize, Debug)]
pub struct NotificationTransaction {
    pub subaccounts: Vec<i32>,
    pub txhash: String,
}

// {"event":"network","network":{"connected":false,"elapsed":2,"limit":false,"waiting":4}}
// {"event":"network","network":{"connected":true,"heartbeat_timeout":false,"login_required":true}}

#[derive(Deserialize, Debug)]
pub struct NotificationNetwork {
    pub connected: bool,
    pub login_required: Option<bool>,
}

#[derive(Deserialize, Debug)]
pub struct Notification {
    pub block: Option<NotificationBlock>,
    pub transaction: Option<NotificationTransaction>,
    pub network: Option<NotificationNetwork>,
}

#[derive(Deserialize)]
pub struct ErrorDetailsResult {
    pub details: String,
}
