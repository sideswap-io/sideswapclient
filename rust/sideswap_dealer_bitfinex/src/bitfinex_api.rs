use serde::Serialize;

pub mod movements;
pub mod order_history;
pub mod submit;
pub mod transfer;
pub mod withdraw;

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
