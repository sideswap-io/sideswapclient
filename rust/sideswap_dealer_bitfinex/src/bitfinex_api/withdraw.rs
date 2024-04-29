use super::*;

#[derive(Serialize)]
pub struct WithdrawRequest {
    pub wallet: String,
    pub method: String,
    pub amount: String,
    pub address: String,
}

#[derive(Debug)]
pub struct WithdrawResponse {
    pub mts: i64,
    pub type_: String,
    pub message_id: i64,
    pub code: i64,
    pub status: String,
    pub text: String,

    pub withdrawal_id: i64,
    pub method: String,
    pub payment_id: String,
    pub wallet: String,
    pub amount: f64,
    pub withdrawal_fee: f64,
}

impl ApiCall for WithdrawRequest {
    type Response = WithdrawResponse;

    fn api_path() -> &'static str {
        "v2/auth/w/withdraw"
    }

    fn parse(value: serde_json::Value) -> Result<Self::Response, anyhow::Error> {
        // https://docs.bitfinex.com/reference/rest-auth-withdraw
        let list = value.as_array().ok_or_else(|| anyhow!("array expected"))?;
        ensure!(list.len() >= 8);
        let sublist = list[4]
            .as_array()
            .ok_or_else(|| anyhow!("subarray expected"))?;
        ensure!(sublist.len() >= 9);

        Ok(WithdrawResponse {
            mts: get_i64(list, 0),
            type_: get_string(list, 1),
            message_id: get_i64(list, 2),
            code: get_i64(list, 5),
            status: get_string(list, 6),
            text: get_string(list, 7),

            withdrawal_id: get_i64(sublist, 0),
            method: get_string(sublist, 2),
            payment_id: get_string(sublist, 3),
            wallet: get_string(sublist, 4),
            amount: get_f64(sublist, 5),
            withdrawal_fee: get_f64(sublist, 8),
        })
    }
}
