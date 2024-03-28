use serde::Serialize;

pub struct Bitfinex {
    bitfinex_key: String,
    bitfinex_secret: String,
}

pub trait ApiCall: Serialize {
    type Response;

    fn api_path() -> &'static str;

    fn parse(value: serde_json::Value) -> Result<Self::Response, anyhow::Error>;
}

fn get_string(list: &[serde_json::Value], index: usize) -> String {
    list.get(index)
        .and_then(|value| value.as_str())
        .map(|s| s.to_owned())
        .unwrap_or_default()
}

fn get_i64(list: &[serde_json::Value], index: usize) -> i64 {
    list.get(index)
        .and_then(|value| value.as_i64())
        .unwrap_or_default()
}

fn get_f64(list: &[serde_json::Value], index: usize) -> f64 {
    list.get(index)
        .and_then(|value| value.as_f64())
        .unwrap_or_default()
}

#[derive(Serialize)]
pub struct MovementsRequest {
    #[serde(skip_serializing_if = "Option::is_none")]
    pub start: Option<i64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub end: Option<i64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub limit: Option<i32>,
}

#[derive(Debug)]
pub struct Movement {
    pub id: i64,
    pub currency: String,
    pub currency_name: String,
    pub mts_started: i64,
    pub mts_updated: i64,
    pub status: String,
    pub amount: f64,
    pub fees: f64,
    pub destination_address: String,
    pub transaction_id: String,
    pub withdraw_transaction_note: String,
}

pub type MovementsResponse = Vec<Movement>;

impl ApiCall for MovementsRequest {
    type Response = MovementsResponse;

    fn api_path() -> &'static str {
        "v2/auth/r/movements/hist"
    }

    fn parse(value: serde_json::Value) -> Result<Self::Response, anyhow::Error> {
        // https://docs.bitfinex.com/reference/rest-auth-movements
        let values = value.as_array().ok_or_else(|| anyhow!("array expected"))?;
        values
            .iter()
            .map(|item| -> Result<Movement, anyhow::Error> {
                let list = item.as_array().ok_or_else(|| anyhow!("array expected"))?;
                Ok(Movement {
                    id: get_i64(list, 0),
                    currency: get_string(list, 1),
                    currency_name: get_string(list, 2),
                    mts_started: get_i64(list, 5),
                    mts_updated: get_i64(list, 6),
                    status: get_string(list, 9),
                    amount: get_f64(list, 12),
                    fees: get_f64(list, 13),
                    destination_address: get_string(list, 16),
                    transaction_id: get_string(list, 20),
                    withdraw_transaction_note: get_string(list, 21),
                })
            })
            .collect()
    }
}

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

impl Bitfinex {
    pub fn new(bitfinex_key: String, bitfinex_secret: String) -> Self {
        Self {
            bitfinex_key,
            bitfinex_secret,
        }
    }

    pub fn make_request<T: ApiCall>(&self, request: T) -> Result<T::Response, anyhow::Error> {
        let body = serde_json::to_string(&request).expect("should not fail");
        let nonce = std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)
            .unwrap()
            .as_micros()
            .to_string();
        let api_path = T::api_path();
        let signature_payload = format!("/api/{api_path}{nonce}{body}");
        let key = ring::hmac::Key::new(ring::hmac::HMAC_SHA384, self.bitfinex_secret.as_bytes());
        let tag = ring::hmac::sign(&key, signature_payload.as_bytes());
        let endpoint = format!("https://api.bitfinex.com/{api_path}");
        let signature = hex::encode(tag.as_ref());

        debug!("bf request: {body}, nonce: {nonce}, path: {api_path}");
        let res = ureq::request("POST", &endpoint)
            .set("Content-Type", "application/json")
            .set("accept", "application/json")
            .set("bfx-nonce", &nonce)
            .set("bfx-apikey", &self.bitfinex_key)
            .set("bfx-signature", &signature)
            .send_bytes(body.as_bytes());

        match res {
            Ok(resp) => {
                let resp: serde_json::Value = resp.into_json()?;
                debug!(
                    "bf response: {}, api_path: {api_path}",
                    serde_json::to_string(&resp).unwrap()
                );
                let resp = T::parse(resp)?;
                Ok(resp)
            }
            Err(err) => match err {
                ureq::Error::Status(status, resp) => {
                    let err_text = resp.into_string()?;
                    bail!("bf error: {err_text}, http_status: {status}")
                }
                ureq::Error::Transport(err) => {
                    bail!("bf error (transport): {err}")
                }
            },
        }
    }
}
