use anyhow::{anyhow, ensure};

use super::*;

#[derive(Serialize)]
pub struct SubmitRequest {
    #[serde(rename = "type")]
    pub type_: String,
    pub cid: i64,
    pub symbol: String,
    pub amount: String,
}

#[derive(Debug)]
pub struct SubmitResponse {
    pub order_id: i64,
}

impl ApiCall for SubmitRequest {
    type Response = SubmitResponse;

    fn api_path() -> &'static str {
        "v2/auth/w/order/submit"
    }

    fn parse(value: serde_json::Value) -> Result<Self::Response, anyhow::Error> {
        // https://docs.bitfinex.com/reference/rest-auth-submit-order
        let values = value.as_array().ok_or_else(|| anyhow!("array expected"))?;
        let status = get_string(values, 6);
        ensure!(status == "SUCCESS", "Unexpected status: {}", status);
        let order_list = value
            .get(4)
            .ok_or_else(|| anyhow!("expected order list"))?
            .as_array()
            .ok_or_else(|| anyhow!("expected order list vector"))?;
        let first_order = order_list
            .first()
            .ok_or_else(|| anyhow!("empty order list"))?
            .as_array()
            .ok_or_else(|| anyhow!("expected subarray"))?;
        let order_id = get_i64(first_order, 0);
        ensure!(order_id != 0);
        Ok(SubmitResponse { order_id })
    }
}

#[cfg(test)]
mod tests;
