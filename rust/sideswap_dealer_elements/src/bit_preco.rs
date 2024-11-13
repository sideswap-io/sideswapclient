use anyhow::ensure;
use serde::Deserialize;
use sideswap_api::PricePair;
use sideswap_dealer::types::DealerTicker;

use crate::{ExchangePair, PriceCallback};

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

fn download_bitcoin_last_prices(
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

pub fn start(exchange_pair: ExchangePair, callback: PriceCallback) {
    let http_client = ureq::AgentBuilder::new()
        .timeout(std::time::Duration::from_secs(20))
        .build();

    assert!(exchange_pair.base == DealerTicker::LBTC);
    assert!(exchange_pair.quote == DealerTicker::DePix);

    std::thread::spawn(move || loop {
        let price = download_bitcoin_last_prices(&http_client);

        match price {
            Ok(v) => {
                let base_price = PricePair {
                    bid: v.brl,
                    ask: v.brl,
                };
                callback(Some(base_price));
                std::thread::sleep(std::time::Duration::from_secs(10));
            }
            Err(e) => {
                log::error!("price download failed: {}", e);
                callback(None);
                std::thread::sleep(std::time::Duration::from_secs(60));
            }
        }
    });
}
