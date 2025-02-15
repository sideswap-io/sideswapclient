use serde::Deserialize;
use sideswap_api::PricePair;

use crate::{dealer_ticker::DealerTicker, exchange_pair::ExchangePair, http_client::HttpClient};

use super::Market;

#[derive(Debug, Clone, Deserialize)]
pub struct Params {
    pub bid: f64,
    pub ask: f64,
}

pub async fn get_price(client: &HttpClient, market: &Market) -> Result<PricePair, anyhow::Error> {
    let exchange_pair = market.exchange_pair();

    let params = market.fixed.as_ref().expect("fixed field must be set");

    assert!(params.bid <= params.ask);

    match exchange_pair.quote {
        DealerTicker::LBTC => {
            let bitcoin_price = super::binance::get_price_for_exchange_pair(
                client,
                ExchangePair {
                    base: DealerTicker::LBTC,
                    quote: DealerTicker::USDt,
                },
            )
            .await?;

            let bitcoin_price = (bitcoin_price.ask + bitcoin_price.bid) / 2.0;

            Ok(PricePair {
                bid: params.bid / bitcoin_price,
                ask: params.ask / bitcoin_price,
            })
        }

        DealerTicker::USDt => Ok(PricePair {
            bid: params.bid,
            ask: params.ask,
        }),

        _ => panic!("unsupported exchange_pair: {exchange_pair:?}"),
    }
}
