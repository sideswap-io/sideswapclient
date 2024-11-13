use serde::Deserialize;
use sideswap_api::PricePair;
use sideswap_common::http_client::HttpClient;
use sideswap_dealer::types::DealerTicker;

use crate::{ExchangePair, PriceCallback};

#[derive(Deserialize)]
struct TickerPrice {
    price: String,
}

async fn current_price(client: &HttpClient, url: &str) -> Result<f64, anyhow::Error> {
    let resp = client.get_json::<TickerPrice>(url).await?;
    let price = resp.price.parse()?;
    Ok(price)
}

pub async fn run(url: String, callback: PriceCallback) {
    let client = HttpClient::new();

    loop {
        let res = current_price(&client, &url).await;

        match res {
            Ok(price) => {
                let base_price = PricePair {
                    bid: price,
                    ask: price,
                };
                callback(Some(base_price));
                tokio::time::sleep(std::time::Duration::from_secs(15)).await;
            }
            Err(e) => {
                log::error!("binance price download failed: {}", e);
                callback(None);
                tokio::time::sleep(std::time::Duration::from_secs(60)).await;
            }
        }
    }
}

pub fn start(exchange_pair: ExchangePair, callback: PriceCallback) {
    let symbol = match (exchange_pair.base, exchange_pair.quote) {
        (DealerTicker::LBTC, DealerTicker::USDt) => "BTCUSDT",
        (DealerTicker::LBTC, DealerTicker::EURx) => "BTCEUR",
        (DealerTicker::EURx, DealerTicker::USDt) => "EURUSDT",
        _ => panic!("unsupported exchange_pair: {exchange_pair:?}"),
    };

    let url = format!("https://api.binance.com/api/v3/ticker/price?symbol={symbol}");

    tokio::spawn(run(url, callback));
}
