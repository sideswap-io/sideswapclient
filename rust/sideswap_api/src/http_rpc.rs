use super::*;

use serde::{Deserialize, Serialize};

pub type Id = Option<String>;

#[derive(Debug, Hash, PartialEq, Eq, Clone, Ord, PartialOrd, Serialize, Deserialize)]
pub struct SubmitId(pub String);

#[derive(Serialize, Deserialize)]
pub struct SwapStartRequest {
    pub order_id: OrderId,
    pub inputs: Vec<PsetInput>,
    pub recv_addr: elements::Address,
    pub change_addr: elements::Address,
    pub send_asset: AssetId,
    pub send_amount: i64,
    pub recv_asset: AssetId,
    pub recv_amount: i64,
    pub api_key: Option<String>,
}

#[derive(Serialize, Deserialize)]
pub struct SwapStartResponse {
    pub submit_id: SubmitId,
    pub pset: String,
}

#[derive(Serialize, Deserialize)]
pub struct SwapSignRequest {
    pub order_id: OrderId,
    pub submit_id: SubmitId,
    pub pset: String,
}

#[derive(Serialize, Deserialize)]
pub struct SwapSignResponse {
    pub txid: elements::Txid,
}

#[derive(Serialize, Deserialize)]
#[serde(tag = "method", content = "params")]
#[serde(rename_all = "snake_case")]
pub enum Request {
    SwapStart(SwapStartRequest),
    SwapSign(SwapSignRequest),
}

#[derive(Serialize, Deserialize)]
#[serde(tag = "method", content = "result")]
#[serde(rename_all = "snake_case")]
pub enum Response {
    SwapStart(SwapStartResponse),
    SwapSign(SwapSignResponse),
}

#[derive(Serialize, Deserialize)]
pub struct RequestMsg {
    pub id: Id,
    #[serde(flatten)]
    pub request: Request,
}

#[derive(Serialize, Deserialize)]
pub struct RequestStubMsg {
    pub id: Id,
}

#[derive(Serialize, Deserialize)]
pub struct ResponseMsg {
    pub id: Id,
    #[serde(flatten)]
    pub response: Response,
}

#[derive(Serialize, Deserialize)]
pub struct Error {
    pub code: i32,
    pub message: String,
}

#[derive(Serialize, Deserialize)]
pub struct ErrorMsg {
    pub id: Id,
    pub error: Error,
}
