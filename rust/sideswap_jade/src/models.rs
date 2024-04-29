use serde::{Deserialize, Serialize};
use serde_bytes::ByteBuf;

#[derive(serde::Serialize)]
pub enum Never {}

pub type EmptyRequest = Option<Never>;

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct AssetId(serde_bytes::ByteBuf);

impl From<elements::AssetId> for AssetId {
    fn from(value: elements::AssetId) -> Self {
        let mut arr: [u8; 32] = value.into_inner().as_ref().try_into().unwrap();
        arr.reverse();
        Self(serde_bytes::ByteBuf::from(arr))
    }
}

impl From<AssetId> for elements::AssetId {
    fn from(value: AssetId) -> Self {
        let mut arr = value.0;
        arr.reverse();
        elements::AssetId::from_slice(&arr).unwrap()
    }
}

#[derive(Debug, Deserialize)]
#[serde(rename_all = "SCREAMING_SNAKE_CASE")]
pub enum StatusNetwork {
    All,
    Main,
    Test,
}

#[derive(Debug, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "SCREAMING_SNAKE_CASE")]
pub enum State {
    Ready,
    Temp,
    Unsaved,
    Locked,
    Uninit,
}

#[derive(Debug, Clone, Copy)]
pub enum JadeNetwork {
    // Mainnet,       // Bitcoin mainnet
    // Testnet,       // Bitcoin testnet
    Liquid,        // Liquid mainnet
    TestnetLiquid, // Liquid testnet
}

impl JadeNetwork {
    pub fn name(&self) -> &'static str {
        match self {
            // JadeNetwork::Mainnet => "mainnet",
            // JadeNetwork::Testnet => "testnet",
            JadeNetwork::Liquid => "liquid",
            JadeNetwork::TestnetLiquid => "testnet-liquid",
        }
    }
}

#[derive(Debug)]
pub struct SignMessageReq {
    pub path: Vec<u32>,
    pub message: String,
    pub ae_host_commitment: Vec<u8>,
}

// Other fields:
// Text("JADE_OTA_MAX_CHUNK"), Integer(Integer(4096))
// Text("JADE_CONFIG"), Text("BLE")
// Text("BOARD_TYPE"), Text("JADE_V1.1")
// Text("JADE_FEATURES"), Text("SB")
// Text("IDF_VERSION"), Text("v5.0.2")
// Text("CHIP_FEATURES"), Text("32000000")
// Text("BATTERY_STATUS"), Integer(Integer(5))

#[derive(Debug, Deserialize)]
#[serde(rename_all = "SCREAMING_SNAKE_CASE")]
pub struct RespVersionInfo {
    pub jade_version: String,
    pub jade_state: State,
    pub jade_networks: StatusNetwork,
    pub jade_has_pin: bool,
    pub efusemac: String, // Example: 083AF2012345
}

#[derive(Debug, Serialize)]
pub struct ReqAuthUser {
    pub network: String,
}

#[derive(Debug, Deserialize)]
pub struct RespAuthUser {
    pub http_request: RespHttpReq,
}

#[derive(Debug, Deserialize)]
pub struct RespHttpReq {
    pub params: RespHttpRequestParams,
    #[serde(rename = "on-reply")]
    pub on_reply: String,
}

#[derive(Debug, Deserialize)]
pub struct RespHttpRequestParams {
    pub urls: Vec<String>,
    pub method: String,
    pub accept: String,
    pub data: ciborium::value::Value,
}

pub type RespAuthComplete = bool;

#[derive(Debug, Serialize)]
pub struct ReqGetXPub {
    pub network: String,
    pub path: Vec<u32>,
}
pub type RespGetXPub = String;

#[derive(Debug, Serialize)]
pub struct ReqGetMasterBlindingKey {}
pub type RespGetMasterBlindingKey = Vec<u8>;

#[derive(Debug, Serialize)]
pub struct ReqSignMessage {
    pub path: Vec<u32>,
    pub message: String,
    pub ae_host_commitment: ByteBuf,
}
pub type RespSignMessage = ByteBuf;

#[derive(Debug, Serialize)]
pub struct ReqGetSignature {
    pub ae_host_entropy: Option<ByteBuf>,
}
pub type RespGetSignature = ciborium::value::Value;

#[derive(Debug, Serialize)]
pub struct ReqGetSharedNonce {
    pub script: ByteBuf,
    pub their_pubkey: ByteBuf,
}
pub type RespGetSharedNonce = ByteBuf;

#[derive(Debug, Serialize)]
pub struct ReqGetBlindingKey {
    pub script: ByteBuf,
}
pub type RespGetBlindingKey = ByteBuf;

#[derive(Debug, Serialize)]
pub struct ReqGetBlindingFactor {
    pub hash_prevouts: ByteBuf,
    pub output_index: u32,
    #[serde(rename = "type")]
    pub type_: String,
}
pub type RespGetBlindingFactor = ByteBuf;

#[derive(Debug, Serialize)]
pub struct ReqGetCommitments {
    pub asset_id: AssetId,
    pub value: u64,
    pub hash_prevouts: ByteBuf,
    pub output_index: u32,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub vbf: Option<ByteBuf>,
}
#[derive(Debug, Deserialize)]
pub struct RespGetCommitments {
    pub abf: ByteBuf,
    pub vbf: ByteBuf,
    pub asset_generator: ByteBuf,
    pub value_commitment: ByteBuf,
    pub asset_id: AssetId,
    pub value: u64,
}

#[derive(Debug, Serialize)]
pub struct AdditionalInfoSummary {
    pub asset_id: AssetId,
    pub satoshi: u64,
}

#[derive(Debug, Serialize)]
pub enum TxType {
    #[serde(rename = "swap")]
    Swap,
}

#[derive(Debug, Serialize)]
pub struct ReqSignTxAdditionalInfo {
    pub is_partial: bool,
    pub tx_type: TxType,
    pub wallet_input_summary: Vec<AdditionalInfoSummary>,
    pub wallet_output_summary: Vec<AdditionalInfoSummary>,
}

#[derive(Debug, Serialize)]
pub struct AssetEntity {
    pub domain: String,
}

#[derive(Debug, Serialize)]
pub struct Prevout {
    pub txid: String, // Jade expects string here!
    pub vout: u32,
}

#[derive(Debug, Serialize)]
pub struct AssetInfo {
    pub asset_id: String, // Jade expects string here!
    pub contract: ciborium::Value,
    pub issuance_prevout: Prevout,
}

#[derive(Debug, Serialize)]
pub struct ReqSignTx {
    pub network: String,
    pub use_ae_signatures: bool,
    pub txn: ByteBuf,
    pub num_inputs: u32,
    pub trusted_commitments: Vec<Option<TrustedCommitment>>,
    pub change: Vec<Option<Output>>,
    pub asset_info: Vec<AssetInfo>,
    pub additional_info: Option<ReqSignTxAdditionalInfo>,
}

pub type RespSignTx = bool;

#[derive(Debug, Serialize, Clone)]
pub struct TrustedCommitment {
    pub asset_id: AssetId,
    pub value: u64,
    pub asset_generator: ByteBuf,
    pub value_commitment: ByteBuf,
    pub blinding_key: ByteBuf,
    pub abf: elements::confidential::AssetBlindingFactor,
    pub vbf: elements::confidential::ValueBlindingFactor,
}

#[derive(Debug, Serialize)]
pub enum OutputVariant {
    #[serde(rename = "pkh(k)")]
    P2pkh,
    #[serde(rename = "wpkh(k)")]
    P2wpkh,
    #[serde(rename = "sh(wpkh(k))")]
    P2wpkhP2sh,
    #[serde(rename = "wsh(multi(k))")]
    MultiP2wsh,
    #[serde(rename = "sh(multi(k))")]
    MultiP2sh,
    #[serde(rename = "sh(wsh(multi(k)))")]
    MultiP2wshP2sh,
}

#[derive(Debug, Serialize)]
pub struct Output {
    pub variant: Option<OutputVariant>,
    pub path: Vec<u32>,
    pub recovery_xpub: Option<String>,
    pub is_change: bool,
}

#[derive(Debug, Serialize)]
pub struct ReqTxInput {
    pub is_witness: bool,
    pub path: Vec<u32>,
    pub script: ByteBuf,
    pub sighash: Option<u8>,
    pub value_commitment: ByteBuf,

    pub ae_host_commitment: ByteBuf,
    pub ae_host_entropy: ByteBuf,

    pub value: u64,
    pub abf: elements::confidential::AssetBlindingFactor,
    pub vbf: elements::confidential::ValueBlindingFactor,
    pub asset_id: AssetId,
    pub asset_generator: ByteBuf,
}

#[derive(Debug, Serialize)]
pub struct ReqTxInputEmpty {}

pub type RespTxInput = ByteBuf;
