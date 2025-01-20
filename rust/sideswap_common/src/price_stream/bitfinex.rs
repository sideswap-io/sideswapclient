use anyhow::anyhow;
use sideswap_api::PricePair;

use crate::{dealer_ticker::DealerTicker, exchange_pair::ExchangePair, http_client::HttpClient};

pub async fn get_price(
    client: &HttpClient,
    exchange_pair: ExchangePair,
) -> Result<PricePair, anyhow::Error> {
    let symbol = match (exchange_pair.base, exchange_pair.quote) {
        (DealerTicker::LBTC, DealerTicker::USDt) => "tBTCUST",
        (DealerTicker::LBTC, DealerTicker::EURx) => "tBTCEUR",
        (DealerTicker::EURx, DealerTicker::USDt) => "tEURUST",
        _ => panic!("unsupported exchange_pair: {exchange_pair:?}"),
    };

    let url = format!("https://api-pub.bitfinex.com/v2/ticker/{symbol}");

    // See https://docs.bitfinex.com/reference/rest-public-ticker
    // Example response:
    // [101080,30.64732822,101090,45.65487143,1454,0.01459458,101080,392.5568356,102100,97332]

    let resp = client.get_json::<serde_json::Value>(&url).await?;

    let resp = resp
        .as_array()
        .ok_or_else(|| anyhow!("unexpected response"))?;

    let bid = resp
        .get(0)
        .ok_or_else(|| anyhow!("no bid value"))?
        .as_f64()
        .ok_or_else(|| anyhow!("f64 expected in bid"))?;

    let ask = resp
        .get(2)
        .ok_or_else(|| anyhow!("no ask value"))?
        .as_f64()
        .ok_or_else(|| anyhow!("f64 expected in ask"))?;

    Ok(PricePair { bid, ask })
}
