use sideswap_api::PricePair;

use crate::{dealer_ticker::DealerTicker, exchange_pair::ExchangePair, http_client::HttpClient};

const PRICE_SSWP_USDT_BID: f64 = 0.70;
const PRICE_SSWP_USDT_ASK: f64 = 0.99;

pub async fn get_price(
    client: &HttpClient,
    exchange_pair: ExchangePair,
) -> Result<PricePair, anyhow::Error> {
    match (exchange_pair.base, exchange_pair.quote) {
        (DealerTicker::SSWP, DealerTicker::LBTC) => {
            let bitcoin_price = super::binance::get_price(
                client,
                ExchangePair {
                    base: DealerTicker::LBTC,
                    quote: DealerTicker::USDt,
                },
            )
            .await?;

            let bitcoin_price = (bitcoin_price.ask + bitcoin_price.bid) / 2.0;

            Ok(PricePair {
                bid: PRICE_SSWP_USDT_BID / bitcoin_price,
                ask: PRICE_SSWP_USDT_ASK / bitcoin_price,
            })
        }

        (DealerTicker::SSWP, DealerTicker::USDt) => Ok(PricePair {
            bid: PRICE_SSWP_USDT_BID,
            ask: PRICE_SSWP_USDT_ASK,
        }),

        _ => panic!("unsupported exchange_pair: {exchange_pair:?}"),
    }
}
