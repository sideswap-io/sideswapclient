use serde_bytes::ByteBuf;

#[derive(Debug, serde::Deserialize)]
#[serde(rename_all = "SCREAMING_SNAKE_CASE")]
pub enum Network {
    All,
    Main,
    Test,
}

#[derive(Debug, serde::Deserialize, PartialEq, Eq)]
#[serde(rename_all = "SCREAMING_SNAKE_CASE")]
pub enum State {
    Ready,
    Temp,
    Unsaved,
    Locked,
    Uninit,
}

#[derive(serde::Serialize)]
pub struct Req<T> {
    pub id: String,
    pub method: String,
    pub params: Option<T>,
}

#[derive(serde::Deserialize)]
pub struct Resp<T> {
    pub id: String,
    pub result: Option<T>,
    pub error: Option<Error>,
}

#[derive(serde::Deserialize)]
pub struct Error {
    pub code: i32,
    pub message: String,
}

#[derive(Debug, serde::Deserialize)]
#[serde(rename_all = "SCREAMING_SNAKE_CASE")]
pub struct RespVersionInfo {
    pub jade_version: String,
    pub jade_state: State,
    pub jade_networks: Network,
    pub jade_has_pin: bool,
}

#[derive(Debug, serde::Serialize)]
pub struct ReqAuthUser {
    pub network: String,
}

#[derive(Debug, serde::Deserialize)]
pub struct RespAuthUser {
    pub http_request: RespHttpReq,
}

#[derive(Debug, serde::Deserialize)]
pub struct RespHttpReq {
    pub params: RespHttpRequestParams,
    #[serde(rename = "on-reply")]
    pub on_reply: String,
}

#[derive(Debug, serde::Deserialize)]
pub struct RespHttpRequestParams {
    pub urls: Vec<String>,
    pub method: String,
    pub accept: String,
    pub data: ciborium::value::Value,
}

pub type RespAuthComplete = bool;

#[derive(Debug, serde::Serialize)]
pub struct ReqGetXPub {
    pub network: String,
    pub path: Vec<u32>,
}
pub type RespGetXPub = String;

#[derive(Debug, serde::Serialize)]
pub struct ReqSignMessage {
    pub path: Vec<u32>,
    pub message: String,
    pub ae_host_commitment: ByteBuf,
}
pub type RespSignMessage = ByteBuf;

#[derive(Debug, serde::Serialize)]
pub struct ReqGetSignature {
    pub ae_host_entropy: ByteBuf,
}
pub type RespGetSignature = ciborium::value::Value;

#[derive(Debug, serde::Serialize)]
pub struct ReqGetSharedNonce {
    pub script: ByteBuf,
    pub their_pubkey: ByteBuf,
}
pub type RespGetSharedNonce = ByteBuf;

#[derive(Debug, serde::Serialize)]
pub struct ReqGetBlindingKey {
    pub script: ByteBuf,
}
pub type RespGetBlindingKey = ByteBuf;

#[derive(Debug, serde::Serialize)]
pub struct ReqGetBlindingFactor {
    pub hash_prevouts: ByteBuf,
    pub output_index: u32,
    #[serde(rename = "type")]
    pub type_: String,
}
pub type RespGetBlindingFactor = ByteBuf;

#[derive(Debug, serde::Serialize)]
pub struct ReqGetCommitments {
    pub asset_id: ByteBuf,
    pub value: u64,
    pub hash_prevouts: ByteBuf,
    pub output_index: u32,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub vbf: Option<ByteBuf>,
}
#[derive(Debug, serde::Deserialize)]
pub struct RespGetCommitments {
    pub abf: ByteBuf,
    pub vbf: ByteBuf,
    pub asset_generator: ByteBuf,
    pub value_commitment: ByteBuf,
    pub asset_id: ByteBuf,
    pub value: u64,
}

#[derive(Debug, serde::Serialize)]
pub struct ReqSignTx {
    pub network: String,
    pub use_ae_signatures: bool,
    pub txn: ByteBuf,
    pub num_inputs: u32,
    pub trusted_commitments: Vec<TrustedCommitment>,
    pub change: Vec<Option<Change>>,
}
pub type RespSignTx = bool;

#[derive(Debug, serde::Serialize, Clone)]
pub struct TrustedCommitment {
    #[serde(skip_serializing_if = "Option::is_none")]
    pub asset_id: Option<ByteBuf>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub value: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub asset_generator: Option<ByteBuf>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub blinding_key: Option<ByteBuf>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub abf: Option<ByteBuf>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub vbf: Option<ByteBuf>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub value_commitment: Option<ByteBuf>,
}

#[derive(Debug, serde::Serialize)]
pub struct Change {
    pub csv_blocks: u32,
    pub path: Vec<u32>,
    pub recovery_xpub: Option<String>,
}

#[derive(Debug, serde::Serialize)]
pub struct ReqTxInput {
    pub is_witness: bool,
    pub path: Vec<u32>,
    pub script: ByteBuf,
    pub value_commitment: ByteBuf,
    pub ae_host_commitment: ByteBuf,
}
pub type RespTxInput = ByteBuf;
