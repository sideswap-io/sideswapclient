use elements::{
    confidential::{AssetBlindingFactor, ValueBlindingFactor},
    secp256k1_zkp,
};
use serde::{Deserialize, Serialize};
use serde_bytes::ByteBuf;

use crate::byte_array::{ByteArray, ByteArray32, ByteArray33};

#[derive(serde::Serialize)]
pub enum Never {}

pub type EmptyRequest = Option<Never>;

#[derive(Debug, Clone, Deserialize)]
pub struct AssetId([u8; 32]);

impl From<elements::AssetId> for AssetId {
    fn from(value: elements::AssetId) -> Self {
        let mut arr: [u8; 32] = value.into_inner().0;
        arr.reverse();
        Self(arr)
    }
}

impl Serialize for AssetId {
    fn serialize<S: serde::Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        serializer.serialize_bytes(&self.0)
    }
}

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct PublicKey(ByteArray33);

impl From<secp256k1_zkp::PublicKey> for PublicKey {
    fn from(value: secp256k1_zkp::PublicKey) -> Self {
        Self(ByteArray::<33>(value.serialize()))
    }
}

#[derive(Debug, Deserialize)]
#[serde(rename_all = "SCREAMING_SNAKE_CASE")]
pub enum StatusNetwork {
    All,
    Main,
    Test,
}

#[derive(Debug, PartialEq, Eq, Deserialize)]
#[serde(rename_all = "SCREAMING_SNAKE_CASE")]
pub enum State {
    Ready,
    Temp,
    Unsaved,
    Locked,
    Uninit,
}

#[derive(Debug, Clone, Copy, Serialize)]
pub enum JadeNetwork {
    // Bitcoin mainnet
    #[serde(rename = "mainnet")]
    Mainnet,

    // Bitcoin testnet
    #[serde(rename = "testnet")]
    Testnet,

    // Liquid mainnet
    #[serde(rename = "liquid")]
    Liquid,

    // Liquid testnet
    #[serde(rename = "testnet-liquid")]
    TestnetLiquid,
}

#[derive(Debug)]
pub struct SignMessageReq {
    pub path: Vec<u32>,
    pub message: String,
    pub ae_host_commitment: ByteArray32,
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
    pub network: JadeNetwork,
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
    pub network: JadeNetwork,
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
    pub ae_host_commitment: ByteArray32,
}
pub type RespSignMessage = ByteBuf;

#[derive(Debug, Serialize)]
pub struct ReqGetSignature {
    pub ae_host_entropy: Option<ByteArray32>,
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
    pub abf: AssetBlindingFactor,
    pub vbf: ValueBlindingFactor,
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
#[serde(rename_all = "snake_case")]
pub enum TxType {
    Swap,
    SendPayment,
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
    pub network: JadeNetwork,
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
    pub asset_generator: secp256k1_zkp::Generator,
    pub value_commitment: secp256k1_zkp::PedersenCommitment,
    pub blinding_key: PublicKey,
    pub abf: AssetBlindingFactor,
    pub vbf: ValueBlindingFactor,
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

    pub ae_host_commitment: ByteArray32,
    pub ae_host_entropy: ByteArray32,

    pub asset_id: AssetId,
    pub value: u64,
    pub abf: AssetBlindingFactor,
    pub vbf: ValueBlindingFactor,
    pub asset_generator: secp256k1_zkp::Generator,
    pub value_commitment: secp256k1_zkp::PedersenCommitment,
}

#[derive(Debug, Serialize)]
pub struct ReqTxInputEmpty {}

pub type RespTxInput = ByteBuf;
