use super::*;

#[derive(Serialize)]
pub struct TransferRequest {
    pub from: String,
    pub to: String,
    pub currency: String,
    pub currency_to: String,
    pub amount: String,
}

#[derive(Debug)]
pub struct TransferResponse {
    pub mts: i64,
    pub type_: String,
    pub message_id: i64,
    pub code: i64,
    pub status: String,
    pub text: String,

    pub mts_update: i64,
    pub wallet_from: String,
    pub wallet_to: String,
    pub currency: String,
    pub currency_to: String,
    pub amount: f64,
}

impl ApiCall for TransferRequest {
    type Response = TransferResponse;

    fn api_path() -> &'static str {
        "v2/auth/w/transfer"
    }

    fn parse(value: serde_json::Value) -> Result<Self::Response, anyhow::Error> {
        // https://docs.bitfinex.com/reference/rest-auth-transfer
        let list = value.as_array().ok_or_else(|| anyhow!("array expected"))?;
        ensure!(list.len() >= 8);
        let sublist = list[4]
            .as_array()
            .ok_or_else(|| anyhow!("subarray expected"))?;
        ensure!(sublist.len() >= 8);

        Ok(TransferResponse {
            mts: get_i64(list, 0),
            type_: get_string(list, 1),
            message_id: get_i64(list, 2),
            code: get_i64(list, 5),
            status: get_string(list, 6),
            text: get_string(list, 7),

            mts_update: get_i64(sublist, 0),
            wallet_from: get_string(sublist, 1),
            wallet_to: get_string(sublist, 2),
            currency: get_string(sublist, 4),
            currency_to: get_string(sublist, 5),
            amount: get_f64(sublist, 7),
        })
    }
}
