use sideswap_api::{AssetId, BlindingFactor, Txid};
use std::collections::BTreeMap;

use serde::{Deserialize, Serialize};
#[derive(Serialize)]
pub struct InitConfig {
    pub datadir: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub log_level: Option<String>,
}

#[derive(Serialize)]
pub struct GetSubaccountsOpts {
    pub refresh: Option<bool>,
}

#[derive(Serialize)]
pub struct ConnectConfig {
    pub name: String,
}

#[derive(Serialize)]
pub struct LoginUser {
    // GDK is expecting JSON without mnemonic field for HW wallets (null is not enough)
    #[serde(skip_serializing_if = "Option::is_none")]
    pub mnemonic: Option<String>,
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
pub struct HwDevice {
    pub device: Option<HwDeviceDetails>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct HwDeviceDetails {
    pub name: String,
    pub supports_ae_protocol: i32,
    pub supports_arbitrary_scripts: bool,
    pub supports_host_unblinding: bool,
    pub supports_liquid: i32,
    pub supports_low_r: bool,
}

#[derive(Deserialize)]
pub struct TwoFactorConfig {
    pub all_methods: Vec<String>,
    pub any_enabled: bool,
}

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
    pub required_data: Option<RequiredData>,
    pub status: Status,
}

#[derive(Deserialize, Debug)]
#[serde(rename_all = "snake_case")]
pub enum HwAction {
    GetXpubs,
    GetBlindingPublicKeys,
    GetBlindingNonces,
    SignTx,
    SignMessage,
    GetMasterBlindingKey,
}

#[derive(Deserialize, Debug)]
pub struct RequiredData {
    pub action: HwAction,
    pub device: HwDeviceDetails,

    // GetXpubs
    pub paths: Option<Vec<Vec<u32>>>,

    // SignMessage
    pub path: Option<Vec<u32>>,
    pub message: Option<String>,
    pub use_ae_protocol: Option<bool>,
    pub ae_host_commitment: Option<String>,
    pub ae_host_entropy: Option<String>,

    // GetBlindingNonces
    pub blinding_keys_required: Option<bool>,
    pub scripts: Option<Vec<String>>,
    pub public_keys: Option<Vec<String>>,

    // SignTx
    pub signing_inputs: Option<Vec<SignTxSigningInput>>,
    pub transaction: Option<SignTxTransaction>,
    pub transaction_outputs: Option<Vec<SignTxOutput>>,
    // use_ae_protocol is already declared
}

#[derive(Deserialize, Debug)]
pub struct SignTxSigningInput {
    pub ae_host_commitment: String,
    pub ae_host_entropy: String,
    pub asset_id: AssetId,
    pub satoshi: u64,
    pub txhash: String,
    pub pt_idx: u32,
    pub assetblinder: Option<BlindingFactor>,
    pub amountblinder: Option<BlindingFactor>,
    pub user_path: Vec<u32>,
    pub script: String,
    pub prevout_script: String,
    pub commitment: String,
}

#[derive(Deserialize, Debug)]
pub struct SignTxOutput {
    pub asset_id: AssetId,
    pub satoshi: u64,
    pub is_fee: bool,
    pub is_change: bool,
    pub script: String,
    pub public_key: Option<String>,
    pub user_path: Option<Vec<u32>>,
}

#[derive(Deserialize, Debug)]
pub struct SignTxTransaction {
    pub transaction: String,
    pub fee: u64,
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
    pub transaction_size: u32,
    pub transaction_vsize: u32,
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

#[derive(Deserialize, Debug)]
pub struct CreatedTransactionOutput {
    pub address: Option<String>,
    pub asset_id: String,
    pub satoshi: u64,
    pub is_change: bool,
    pub is_fee: bool,
}

#[derive(Deserialize, Debug)]
pub struct SignTransactionResult {
    pub transaction_outputs: Vec<CreatedTransactionOutput>,
    pub transaction: String,
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

#[derive(Deserialize, Debug, PartialEq, Eq)]
#[serde(rename_all = "snake_case")]
pub enum ConnectionState {
    Disconnected,
    Connected,
    Exited,
}

#[derive(Deserialize, Debug)]
pub struct NotificationNetwork {
    pub current_state: ConnectionState,
    pub next_state: ConnectionState,
    pub wait_ms: u64,
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

// Auth handler resolvers

#[derive(Serialize)]
pub struct GetXPubsRes {
    pub xpubs: Vec<String>,
}

#[derive(Serialize)]
pub struct SignMessage {
    pub signature: String,
    pub signer_commitment: String,
}

#[derive(Serialize)]
pub struct GetBlindingNonces {
    pub nonces: Vec<String>,
    pub public_keys: Vec<String>,
}

#[derive(Serialize)]
pub struct GetBlindingPublicKeys {
    pub public_keys: Vec<String>,
}

#[derive(Serialize)]
pub struct SignTx {
    // Inputs
    pub signatures: Vec<String>,
    pub signer_commitments: Vec<String>,

    // Outputs
    pub asset_commitments: Vec<Option<String>>,
    pub value_commitments: Vec<Option<String>>,
    pub assetblinders: Vec<Option<BlindingFactor>>,
    pub amountblinders: Vec<Option<BlindingFactor>>,
}

#[derive(Serialize)]
pub struct PreviousAddressesOpts {
    pub subaccount: i32,
    pub last_pointer: u32,
}

#[derive(Deserialize)]
pub struct PreviousAddress {
    pub address: String,
    pub address_type: String,
    pub branch: u32,
    pub pointer: u32,
    pub script: String,
    pub script_type: u32,
    pub subaccount: i32,
    pub subtype: i32,
    pub tx_count: u32,
}

#[derive(Deserialize)]
pub struct PreviousAddresses {
    pub last_pointer: u32,
    pub list: Vec<PreviousAddress>,
    pub subaccount: i32,
}
