use serde::Deserialize;
use std::collections::BTreeMap;

const TICKER_ENDPOINT: &str = "https://blockchain.info/ticker";

#[derive(Deserialize)]
struct PriceItem {
    last: f64,
}

type PriceItems = BTreeMap<String, PriceItem>;

pub struct LastBitcoinPrices {
    pub usd: Option<f64>,
    pub brl: Option<f64>,
}

pub fn download_bitcoin_last_prices() -> Result<LastBitcoinPrices, anyhow::Error> {
    let http_client = ureq::AgentBuilder::new()
        .timeout(std::time::Duration::from_secs(20))
        .build();
    let items = http_client
        .get(TICKER_ENDPOINT)
        .call()?
        .into_json::<PriceItems>()?;
    let get_last = |name| items.get(name).map(|item| item.last);
    Ok(LastBitcoinPrices {
        usd: get_last("USD"),
        brl: get_last("BRL"),
    })
}
