use anyhow::ensure;
use serde::Deserialize;
use sideswap_api::PricePair;

use crate::{dealer_ticker::DealerTicker, http_client::HttpClient};

use super::Market;

#[derive(Deserialize)]
struct PriceItem {
    success: bool,
    market: String,
    last: f64,
    //timestamp: String,
}

pub async fn get_price(client: &HttpClient, market: &Market) -> Result<PricePair, anyhow::Error> {
    let exchange_pair = market.exchange_pair();

    let (url, expected_market) = match (exchange_pair.base, exchange_pair.quote) {
        (DealerTicker::LBTC, DealerTicker::DEPIX) => {
            ("https://api.bitpreco.com/btc-brl/ticker", "BTC-BRL")
        }
        (DealerTicker::USDT, DealerTicker::DEPIX) => {
            ("https://api.bitpreco.com/usdt-brl/ticker", "USDT-BRL")
        }
        _ => panic!("unexpected exchange_pair {exchange_pair}"),
    };

    let price = client.get_json::<PriceItem>(url).await?;

    ensure!(price.success);
    ensure!(price.market == expected_market);

    // let naive_date_time =
    //     chrono::NaiveDateTime::parse_from_str(&latest.timestamp, "%Y-%m-%d %H:%M:%S")?;
    // let date_time_utc = chrono::Utc.from_utc_datetime(&naive_date_time);
    // let timestamp = date_time_utc.timestamp() + 3 * 3600; // Convert from the BRT timezone to UTC
    // verify!(timestamp > 0, Error::Protocol("time is negative"));
    // let timestamp = timestamp as u64;

    // let now = std::time::SystemTime::now()
    //     .duration_since(std::time::UNIX_EPOCH)
    //     .expect("should not fail")
    //     .as_secs();
    // let valid_period_forward = 10;
    // // Delays of up to 5000 seconds sometimes occur, so use a large value here
    // let valid_period_back = 10800; // 3 hours
    // verify!(
    //     timestamp <= now + valid_period_forward && timestamp > now - valid_period_back,
    //     Error::InvalidTimestamp { timestamp, now }
    // );

    Ok(PricePair {
        bid: price.last,
        ask: price.last,
    })
}
