use anyhow::ensure;
use serde::Deserialize;

const TICKER_ENDPOINT: &str = "https://api3.binance.com/api/v3/ticker/price?symbol=BTCBRL";

#[derive(Deserialize)]
struct PriceItem {
    symbol: String,
    price: String,
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
    ensure!(item.symbol == "BTCBRL");
    let price: f64 = item.price.parse()?;
    Ok(LastBitcoinPrices { brl: price })
}
