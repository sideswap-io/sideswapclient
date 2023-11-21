use bitcoin::bip32::ExtendedPubKey;
use sideswap_api::AssetId;
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

    #[serde(skip_serializing_if = "Option::is_none")]
    pub proxy: Option<String>,

    #[serde(skip_serializing_if = "Option::is_none")]
    pub use_tor: Option<bool>,
}

#[derive(Serialize)]
pub struct LoginUser {
    // GDK is expecting JSON without mnemonic field for HW wallets (null is not enough)
    #[serde(skip_serializing_if = "Option::is_none")]
    pub mnemonic: Option<String>,

    #[serde(skip_serializing_if = "Option::is_none")]
    pub username: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub password: Option<String>,
}

#[derive(Deserialize)]
pub struct LoginUserResult {
    pub wallet_hash_id: String,
}

#[derive(Deserialize, Clone, Debug)]
pub struct Subaccount {
    pub hidden: bool,
    pub name: String,
    pub pointer: i32,
    pub receiving_id: String,
    #[serde(rename = "type")]
    pub type_: String,
}

#[derive(Deserialize, Debug)]
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

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct UnspentOutput {
    pub subaccount: u32,
    pub address_type: AddressType,
    pub block_height: Option<u32>,
    pub txhash: elements::Txid,
    #[serde(rename = "pt_idx")]
    pub vout: u32,
    pub pointer: u32,

    /// Example:
    /// Single-sig: a9146e9cd3e71b8f0af32068e2fd33c433ac4da5ebaa87
    /// AMP: 522103cab1a2a707d13ff3fcc9d08f888724e01c37d54ad8e8d9b274cb33eaebe3461321037888f798b59ff4e1122bdf52ad4c541be32ca755311746b67af2bc5e58df188b52ae
    pub prevout_script: elements::Script,

    pub asset_id: elements::AssetId,
    pub satoshi: u64,
    pub is_internal: bool,
    pub is_blinded: bool,
    pub is_confidential: Option<bool>, // Not set for unblinded multi-sig outputs

    pub asset_tag: sideswap_types::AssetCommitment,
    pub commitment: sideswap_types::ValueCommitment,
    pub amountblinder: elements::confidential::ValueBlindingFactor,
    pub assetblinder: elements::confidential::AssetBlindingFactor,
    // Use string because for unblinded single-sig output it's "00"
    // while for multi-sig it's "000000000000000000000000000000000000000000000000000000000000000000".
    pub nonce_commitment: String,

    #[serde(skip_serializing_if = "Option::is_none")]
    pub script: Option<elements::Script>, // Present in multi-sig only
    #[serde(skip_serializing_if = "Option::is_none")]
    pub script_type: Option<u32>, // Present in multi-sig only
    #[serde(skip_serializing_if = "Option::is_none")]
    pub subtype: Option<u32>, // Present in multi-sig only
    #[serde(skip_serializing_if = "Option::is_none")]
    pub user_status: Option<u32>, // Present in multi-sig only

    #[serde(skip_serializing_if = "Option::is_none")]
    pub public_key: Option<elements::bitcoin::PublicKey>, // Present in single-sig only
    #[serde(skip_serializing_if = "Option::is_none")]
    pub user_path: Option<Vec<u32>>, // Present in single-sig only

    #[serde(skip_serializing_if = "Option::is_none")]
    pub user_sighash: Option<u8>, // Not present normally
}

#[derive(Deserialize)]
pub struct UnspentOutputsResult {
    pub unspent_outputs: std::collections::BTreeMap<AssetId, Vec<UnspentOutput>>,
}

#[derive(Deserialize)]
pub struct UnspentOutputsResultJson {
    pub unspent_outputs: std::collections::BTreeMap<AssetId, Vec<serde_json::Value>>,
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
    pub is_partial: Option<bool>,
    pub transaction: Option<String>,
    pub transaction_inputs: Option<Vec<SignTxSigningInput>>,
    pub transaction_outputs: Option<Vec<SignTxOutput>>,
    // use_ae_protocol is already declared
}

#[derive(Deserialize, Debug)]
pub struct SignTxSigningInput {
    // Set for all
    pub txhash: String,
    pub pt_idx: u32,
    pub asset_id: AssetId,
    pub satoshi: u64,

    pub redeem_script: Option<elements::Script>, // Set for all except Jade

    // Set for own inputs only
    pub address_type: Option<AddressType>,
    pub ae_host_commitment: Option<String>,
    pub ae_host_entropy: Option<String>,
    pub assetblinder: Option<elements::confidential::AssetBlindingFactor>,
    pub amountblinder: Option<elements::confidential::ValueBlindingFactor>,
    pub asset_tag: Option<String>,
    pub user_path: Option<Vec<u32>>,
    pub public_key: Option<elements::bitcoin::PublicKey>,
    pub prevout_script: Option<String>,
    pub commitment: Option<String>,
    pub user_sighash: Option<u8>,

    // Set for non-own inputs only
    pub skip_signing: Option<bool>,
    pub value_blind_proof: Option<String>,
    pub asset_blind_proof: Option<String>,
}

#[derive(Serialize, Deserialize, Debug, Clone, Copy)]
pub enum AddressType {
    /// Single-sig
    #[serde(rename = "p2sh-p2wpkh")]
    P2shP2wpkh, // Single-sig

    /// AMP
    #[serde(rename = "p2wsh")]
    P2wsh,
}

#[derive(Deserialize, Debug)]
pub struct SignTxOutput {
    pub scriptpubkey: String,
    pub address: Option<String>,
    pub address_type: Option<AddressType>,
    pub is_change: Option<bool>,
    pub is_internal: Option<bool>,
    pub asset_id: AssetId,
    pub satoshi: u64,

    pub blinding_key: Option<String>,
    pub assetblinder: Option<elements::confidential::AssetBlindingFactor>,
    pub amountblinder: Option<elements::confidential::ValueBlindingFactor>,
    pub user_path: Option<Vec<u32>>,
}

#[derive(Deserialize, Debug)]
pub struct TransactionInput {
    pub asset_id: Option<AssetId>,
    pub satoshi: Option<u64>,
    pub assetblinder: Option<elements::confidential::AssetBlindingFactor>,
    pub amountblinder: Option<elements::confidential::ValueBlindingFactor>,
    pub is_relevant: bool,
}

#[derive(Deserialize, Debug)]
pub struct TransactionOutput {
    pub asset_id: Option<AssetId>,
    pub satoshi: Option<u64>,
    pub assetblinder: Option<elements::confidential::AssetBlindingFactor>,
    pub amountblinder: Option<elements::confidential::ValueBlindingFactor>,
    pub is_relevant: bool,
    pub is_internal: bool,
    pub pointer: Option<u32>,
}

#[derive(Deserialize, Debug)]
pub struct Transaction {
    pub txhash: elements::Txid,
    pub block_height: u32,
    pub created_at_ts: i64,
    pub fee: u32,
    pub transaction_vsize: u32,
    pub transaction_weight: u32,
    pub memo: String,
    pub inputs: Vec<TransactionInput>,
    pub outputs: Vec<TransactionOutput>,
}

#[derive(Deserialize, Debug)]
pub struct TransactionList {
    pub transactions: Vec<Transaction>,
}

pub type BalanceList = BTreeMap<sideswap_api::AssetId, i64>;

#[derive(Serialize, Debug)]
pub struct RecvAddrOpt {
    pub subaccount: i32,
    pub is_internal: Option<bool>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct AddressInfo {
    pub address: elements::Address,
    pub subaccount: u32,
    pub address_type: AddressType,
    pub pointer: u32,
    pub user_path: Vec<u32>,
    pub unconfidential_address: String,
    pub blinding_key: String,
    pub is_confidential: bool,
    pub scriptpubkey: String, // Same format for all nested segwit addresses, for example: a9145c35160c7cbe5a5a7daec0b2e4dff056991ce4d087

    // Single-sig only:
    pub is_internal: Option<bool>,
    pub public_key: Option<elements::bitcoin::PublicKey>,

    // Normally AMP only, example: 52210305b9d4acd4c6cd5a5a9eb5e9a4dcd74a7b962eb0109cab264ea7412d6901bfa42102945512944638fe25e24962866d19ec858fdc70dd5a68ae801d54b5c36231f2e652ae
    pub script: Option<elements::Script>,
    pub branch: Option<u32>,
    pub script_type: Option<u32>,
    pub service_xpub: Option<String>,
    pub subtype: Option<u32>,

    #[serde(skip_serializing_if = "Option::is_none")]
    pub tx_count: Option<u32>, // Set only from GA_get_previous_addresses
}

#[derive(Deserialize, Serialize, Debug)]
pub struct TxAddressee {
    pub address: String,
    pub satoshi: u64,
    pub asset_id: AssetId,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub is_greedy: Option<bool>,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct TxInternalAddressee {
    #[serde(flatten)]
    pub address_info: AddressInfo,

    pub satoshi: u64,
    pub asset_id: AssetId,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub is_greedy: Option<bool>,
}

#[derive(Serialize, Debug)]
pub struct CreateTransactionOpt {
    pub subaccount: i32,
    pub addressees: Vec<TxAddressee>,
    pub utxos: BTreeMap<AssetId, Vec<UnspentOutput>>,
    // #[serde(skip_serializing_if = "Option::is_none")]
    // pub utxo_strategy: Option<gdk_common::model::UtxoStrategy>,
    pub is_partial: bool,
    pub used_utxos: Option<Vec<UnspentOutput>>,
}

#[derive(Serialize, Debug)]
pub struct CreateInternalTransactionOpt {
    pub subaccount: i32,
    pub addressees: Vec<TxInternalAddressee>,
    pub utxos: BTreeMap<AssetId, Vec<UnspentOutput>>,
}

#[derive(Deserialize, Debug)]
pub struct CreateTransactionResult {
    pub addressees: Vec<TxAddressee>,
    pub transaction_outputs: Vec<CreatedTransactionOutput>,
    pub transaction: Option<sideswap_types::Transaction>,
    pub fee: Option<u64>,
    pub fee_rate: Option<u64>,
    pub transaction_vsize: Option<u64>,
    pub transaction_weight: Option<u64>,
    pub error: String,
}

#[derive(Deserialize, Debug)]
pub struct CreatedTransactionOutput {
    pub address: Option<String>,
    pub asset_id: Option<elements::AssetId>, // Mandatory in GDK c++, missing in GDK rust
    pub satoshi: u64,
    pub is_change: Option<bool>,
    pub amountblinder: Option<elements::confidential::ValueBlindingFactor>,
    pub assetblinder: Option<elements::confidential::AssetBlindingFactor>,
    pub eph_private_key: Option<secp256k1::SecretKey>,
    pub scriptpubkey: String,
}

#[derive(Deserialize, Debug)]
pub struct SignTransactionResult {
    pub transaction_inputs: Vec<UnspentOutput>,
    pub transaction_outputs: Vec<CreatedTransactionOutput>,
    pub transaction: Option<sideswap_types::Transaction>,
    pub fee: Option<u64>,
    pub error: String,
}

#[derive(Serialize, Debug)]
pub struct PsetDetailsOpt {
    pub psbt: String,
    pub utxos: Vec<UnspentOutput>,
}

#[derive(Deserialize, Debug)]
pub struct PsetInputOutput {
    pub asset_id: AssetId,
    pub satoshi: u64,
    pub subaccount: Option<i32>,
}

#[derive(Deserialize, Debug)]
pub struct PsetDetailsResult {
    pub satoshi: BTreeMap<AssetId, i64>,
    pub transaction_inputs: Vec<PsetInputOutput>,
    pub transaction_outputs: Vec<PsetInputOutput>,
    pub fee: Option<i64>,
}

#[derive(Serialize, Debug)]
pub struct SignPsetOpt {
    pub psbt: String,
    pub utxos: Vec<UnspentOutput>,
    pub blinding_nonces: Vec<String>,
}

#[derive(Deserialize, Debug)]
pub struct SignPsetResult {
    pub psbt: String,
}

#[derive(Deserialize, Debug)]
pub struct SendTransactionResult {
    pub txhash: elements::Txid,
}

#[derive(Serialize, Debug)]
pub enum SwapType {
    #[serde(rename = "liquidex")]
    LiquiDex,
}

#[derive(Serialize, Debug)]
pub enum SwapInputOutputType {
    #[serde(rename = "liquidex_v1")]
    LiquiDexV1,
}

#[derive(Serialize, Debug)]
pub struct SwapLiquiDexV1Receive {
    pub asset_id: AssetId,
    pub satoshi: u64,
}

#[derive(Serialize, Debug)]
pub struct SwapLiquiDexV1 {
    pub receive: Vec<SwapLiquiDexV1Receive>,
    pub send: Vec<serde_json::Value>,
}

#[derive(Serialize, Debug)]
pub struct CreateSwapTransactionOpt {
    pub swap_type: SwapType,
    pub input_type: SwapInputOutputType,
    pub output_type: SwapInputOutputType,
    pub liquidex_v1: SwapLiquiDexV1,
}

#[derive(Deserialize, Debug)]
pub struct LiquiDexV1Result {
    pub proposal: serde_json::Value,
}

#[derive(Deserialize, Debug)]
pub struct CreateSwapTransactionResult {
    pub liquidex_v1: LiquiDexV1Result,
}

#[derive(Serialize, Debug)]
#[serde(rename_all = "snake_case")]
pub enum ReconnectHint {
    Connect,
    Disconnect,
}

#[derive(Serialize, Debug)]
pub struct ReconnectHintOpt {
    pub hint: ReconnectHint,
}

#[derive(Deserialize, Debug)]
pub struct NotificationBlock {
    pub block_hash: String,
    pub block_height: u32,
    pub initial_timestamp: Option<u32>,
    pub previous_hash: String,
}

#[derive(Deserialize, Debug)]
pub struct NotificationTransaction {
    pub subaccounts: Vec<i32>,
    pub txhash: String,
}

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
pub struct NotificationSubaccount {
    pub event_type: String,
    pub pointer: u32,
}

#[derive(Deserialize, Debug)]
pub struct Notification {
    pub event: String,
    pub block: Option<NotificationBlock>,
    pub transaction: Option<NotificationTransaction>,
    pub network: Option<NotificationNetwork>,
    pub subaccount: Option<NotificationSubaccount>,
}

#[derive(Deserialize)]
pub struct ErrorDetailsResult {
    pub details: String,
}

// Auth handler resolvers

#[derive(Serialize)]
pub struct GetXPubsRes {
    pub xpubs: Vec<ExtendedPubKey>,
}

#[derive(Serialize)]
pub struct MasterBlindingKeyRes {
    pub master_blinding_key: String,
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
    pub signatures: Vec<Option<String>>,
    pub signer_commitments: Vec<String>,

    // Outputs
    pub asset_commitments: Vec<Option<String>>,
    pub value_commitments: Vec<Option<String>>,
    pub assetblinders: Vec<Option<elements::confidential::AssetBlindingFactor>>,
    pub amountblinders: Vec<Option<elements::confidential::ValueBlindingFactor>>,
}

#[derive(Serialize)]
pub struct PreviousAddressesOpts {
    pub subaccount: i32,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub last_pointer: Option<u32>,
}

#[derive(Deserialize)]
pub struct PreviousAddresses {
    pub last_pointer: Option<u32>,
    pub list: Vec<AddressInfo>,
}

#[derive(Serialize)]
pub enum CreateSwapType {
    #[serde(rename = "liquidex")]
    Liquidex,
}

#[derive(Serialize)]
pub enum CreateSwapInputType {
    #[serde(rename = "liquidex_v1")]
    LiquidexV1,
}

#[derive(Serialize)]
pub struct LiquidexReceive {
    pub asset_id: AssetId,
    pub satoshi: u64,
}

#[derive(Serialize)]
pub struct LiquidexOpts {
    pub receive: Vec<LiquidexReceive>,
    pub send: Vec<UnspentOutput>,
}

#[derive(Serialize)]
pub struct CreateSwapOpts {
    pub swap_type: CreateSwapType,
    pub input_type: CreateSwapInputType,
    pub output_type: CreateSwapInputType,
    pub liquidex_v1: LiquidexOpts,
    pub receive_address: Option<AddressInfo>,
}

#[derive(Deserialize)]
pub struct LiquidexSwap {
    pub proposal: sideswap_api::LiquidexProposal,
}

#[derive(Deserialize)]
pub struct CreateSwap {
    pub liquidex_v1: LiquidexSwap,
}
