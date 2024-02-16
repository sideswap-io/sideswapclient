use anyhow::ensure;
use serde::Deserialize;

const TICKER_ENDPOINT: &str = "https://api.bitpreco.com/btc-brl/ticker";

#[derive(Deserialize)]
struct PriceItem {
    success: bool,
    market: String,
    last: f64,
}

pub struct LastBitcoinPrices {
    pub brl: f64,
}

pub fn download_bitcoin_last_prices(
    http_client: &ureq::Agent,
) -> Result<LastBitcoinPrices, anyhow::Error> {
    let item = http_client
        .get(TICKER_ENDPOINT)
        .call()?
        .into_json::<PriceItem>()?;
    ensure!(item.success);
    ensure!(item.market == "BTC-BRL");
    Ok(LastBitcoinPrices { brl: item.last })
}
