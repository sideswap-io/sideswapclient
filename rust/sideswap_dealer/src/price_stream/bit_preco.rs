use anyhow::ensure;
use serde::Deserialize;
use sideswap_api::PricePair;
use sideswap_common::http_client::HttpClient;

use crate::types::{DealerTicker, ExchangePair};

use super::PriceCallback;

#[derive(Debug, Copy, Clone)]
enum Market {
    BtcBrl,
    UsdtBrl,
}

const TICKER_ENDPOINT_BTC_BRL: &str = "https://api.bitpreco.com/btc-brl/ticker";
const TICKER_ENDPOINT_USDT_BRL: &str = "https://api.bitpreco.com/usdt-brl/ticker";

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
    market: Market,
) -> Result<LastBitcoinPrices, anyhow::Error> {
    let endpoint = match market {
        Market::BtcBrl => TICKER_ENDPOINT_BTC_BRL,
        Market::UsdtBrl => TICKER_ENDPOINT_USDT_BRL,
    };
    let item = http_client.get_json::<PriceItem>(endpoint).await?;
    ensure!(item.success);
    let expected_market = match market {
        Market::BtcBrl => "BTC-BRL",
        Market::UsdtBrl => "USDT-BRL",
    };
    ensure!(item.market == expected_market);
    Ok(LastBitcoinPrices { brl: item.last })
}

async fn run(callback: PriceCallback, market: Market) {
    let http_client = HttpClient::new();

    loop {
        let price = download_bitcoin_last_prices(&http_client, market).await;

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
    let market = match (exchange_pair.base, exchange_pair.quote) {
        (DealerTicker::LBTC, DealerTicker::DePix) => Market::BtcBrl,
        (DealerTicker::USDt, DealerTicker::DePix) => Market::UsdtBrl,
        _ => panic!("unexpected exchange_pair {exchange_pair}"),
    };
    tokio::spawn(run(callback, market));
}
