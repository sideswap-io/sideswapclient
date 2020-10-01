use serde::Deserialize;
use std::collections::BTreeMap;

const TICKER_ENDPOINT: &str = "https://blockchain.info/ticker";

#[derive(Deserialize)]
pub struct PriceItem {
    pub last: f64,
}

pub type PriceItems = BTreeMap<String, PriceItem>;

pub fn get_bitcoin_last_usd_price(msg: &str) -> Result<f64, anyhow::Error> {
    let items = serde_json::from_str::<PriceItems>(&msg)?;
    let item = match items.get("USD") {
        Some(v) => v,
        None => bail!("can't find USD price"),
    };
    Ok(item.last)
}

pub fn download_bitcoin_last_usd_price() -> Result<f64, anyhow::Error> {
    let http_client = reqwest::blocking::Client::builder()
        .timeout(std::time::Duration::from_secs(3))
        .build()
        .expect("http client construction failed");
    let body = http_client.get(TICKER_ENDPOINT).send()?.text()?;
    get_bitcoin_last_usd_price(&body)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn price_msg() {
        let price_msg = r#" {
            "USD" : {"15m" : 10688.74, "last" : 10688.74, "buy" : 10688.74, "sell" : 10688.74, "symbol" : "$"},
            "EUR" : {"15m" : 9133.0, "last" : 9133.0, "buy" : 9133.0, "sell" : 9133.0, "symbol" : "€"}
          }
        "#;
        assert_eq!(get_bitcoin_last_usd_price(price_msg).unwrap(), 10688.74);
    }
}
