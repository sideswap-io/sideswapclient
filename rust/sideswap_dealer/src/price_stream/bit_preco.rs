use anyhow::ensure;
use serde::Deserialize;
use sideswap_api::PricePair;
use sideswap_common::http_client::HttpClient;

use crate::types::{DealerTicker, ExchangePair};

use super::PriceCallback;

const TICKER_ENDPOINT: &str = "https://api.bitpreco.com/btc-brl/ticker";

#[derive(Deserialize)]
struct PriceItem {
    success: bool,
    market: String,
    last: f64,
}

struct LastBitcoinPrices {
    brl: f64,
}

async fn download_bitcoin_last_prices(
    http_client: &HttpClient,
) -> Result<LastBitcoinPrices, anyhow::Error> {
    let item = http_client.get_json::<PriceItem>(TICKER_ENDPOINT).await?;
    ensure!(item.success);
    ensure!(item.market == "BTC-BRL");
    Ok(LastBitcoinPrices { brl: item.last })
}

async fn run(callback: PriceCallback) {
    let http_client = HttpClient::new();

    loop {
        let price = download_bitcoin_last_prices(&http_client).await;

        match price {
            Ok(v) => {
                let base_price = PricePair {
                    bid: v.brl,
                    ask: v.brl,
                };
                callback(Some(base_price));
                tokio::time::sleep(std::time::Duration::from_secs(10)).await;
            }
            Err(e) => {
                log::error!("price download failed: {}", e);
                callback(None);
                tokio::time::sleep(std::time::Duration::from_secs(60)).await;
            }
        }
    }
}

pub fn start(exchange_pair: ExchangePair, callback: PriceCallback) {
    assert!(exchange_pair.base == DealerTicker::LBTC);
    assert!(exchange_pair.quote == DealerTicker::DePix);
    tokio::spawn(run(callback));
}
