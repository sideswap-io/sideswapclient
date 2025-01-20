use serde::Deserialize;
use sideswap_api::PricePair;

use crate::{dealer_ticker::DealerTicker, exchange_pair::ExchangePair, http_client::HttpClient};

#[derive(Deserialize)]
struct TickerPrice {
    price: String,
}

pub async fn get_price(
    client: &HttpClient,
    exchange_pair: ExchangePair,
) -> Result<PricePair, anyhow::Error> {
    let symbol = match (exchange_pair.base, exchange_pair.quote) {
        (DealerTicker::LBTC, DealerTicker::USDt) => "BTCUSDT",
        (DealerTicker::LBTC, DealerTicker::EURx) => "BTCEUR",
        (DealerTicker::EURx, DealerTicker::USDt) => "EURUSDT",
        (DealerTicker::LBTC, DealerTicker::MEX) => "BTCMXN",
        (DealerTicker::USDt, DealerTicker::MEX) => "USDTMXN",
        _ => panic!("unsupported exchange_pair: {exchange_pair:?}"),
    };

    let url = format!("https://api.binance.com/api/v3/ticker/price?symbol={symbol}");

    let resp = client.get_json::<TickerPrice>(&url).await?;

    let price = resp.price.parse::<f64>()?;

    Ok(PricePair {
        bid: price,
        ask: price,
    })
}
