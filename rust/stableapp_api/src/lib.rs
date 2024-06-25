use serde::{Deserialize, Serialize};

// Common

#[derive(Clone, Serialize, Deserialize)]
pub enum TxType {
    Received,
    Sent,
    Swap,
    Internal,
    Unknown,
}

// Requests

#[derive(Serialize, Deserialize, Debug)]
pub struct RegisterPhoneReq {
    pub country_code: String,
    pub phone_number: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RegisterPhoneResp {
    pub register_id: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct VerifyPhoneReq {
    pub register_id: String,
    pub code: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct VerifyPhoneResp {
    pub phone_key: String,
}

// Notifications

#[derive(Serialize, Deserialize)]
pub struct GaidNotif {
    pub gaid: String,
}

// Top level messages

#[derive(Debug, Serialize, Deserialize)]
pub enum ErrorCode {
    /// Something wrong with the request arguments.
    InvalidRequest,
    /// Server error.
    Server,
    /// Wrong SMS code.
    WrongSmsCode,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct Error {
    pub code: ErrorCode,
    pub message: String,
}

pub trait Request: serde::Serialize + serde::de::DeserializeOwned {
    const NAME: &'static str;
    type Resp: serde::Serialize + serde::de::DeserializeOwned;
}

impl Request for RegisterPhoneReq {
    const NAME: &'static str = "register_phone";
    type Resp = RegisterPhoneResp;
}

impl Request for VerifyPhoneReq {
    const NAME: &'static str = "verify_phone";
    type Resp = VerifyPhoneResp;
}

#[derive(Serialize, Deserialize)]
pub enum Notif {
    Gaid(GaidNotif),
}
