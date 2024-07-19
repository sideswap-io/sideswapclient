use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub struct StartRegisterReq {
    pub gaid: String,
}

#[derive(Serialize, Deserialize)]
pub struct StartRegisterResp {
    pub request_id: String,
}

#[derive(Serialize, Deserialize)]
pub struct FinishRegisterReq {
    pub request_id: String,
}

#[derive(Serialize, Deserialize)]
pub struct FinishRegisterResp {}

#[derive(Serialize, Deserialize)]
pub enum Request {
    StartRegister(StartRegisterReq),
    FinishRegister(FinishRegisterReq),
}

#[derive(Serialize, Deserialize)]
pub enum Response {
    StartRegister(StartRegisterResp),
    FinishRegister(FinishRegisterResp),
}

#[derive(Debug, Serialize, Deserialize)]
pub enum ErrorCode {
    InternalServer,

    UserCancelled,

    NotFound,

    ClientError,

    #[serde(other)]
    Unknown,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct Error {
    pub code: ErrorCode,
    pub text: String,
}
