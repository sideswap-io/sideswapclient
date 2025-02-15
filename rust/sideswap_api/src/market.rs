use crate::mkt::AssetPair;
use serde::{Deserialize, Serialize};
use sideswap_types::normal_float::NormalFloat;

#[derive(Serialize, Deserialize)]
pub struct MarketDetailsRequest {
    pub asset_pair: AssetPair,
}

#[derive(Serialize, Deserialize)]
pub struct MarketDetailsResponse {
    pub ind_price: Option<NormalFloat>,
}

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum Request {
    MarketDetails(MarketDetailsRequest),
}

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum Response {
    MarketDetails(MarketDetailsResponse),
}

#[derive(Serialize, Deserialize)]
pub struct Error {
    pub code: crate::ErrorCode,
    pub text: String,
}
