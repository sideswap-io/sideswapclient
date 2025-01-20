use std::time::{Duration, Instant};

use anyhow::ensure;
use serde::Deserialize;
use sideswap_api::PricePair;

use crate::{exchange_pair::ExchangePair, http_client::HttpClient};

mod binance;
mod bitfinex;
mod bitpreco;
mod sswp;

#[derive(Debug, Copy, Clone, Deserialize)]
pub enum PriceSource {
    Binance,
    Bitfinex,
    BitPreco,
    SSWP,
}

pub type PriceCallback = Box<dyn FnMut(Option<PricePair>) -> () + Send>;

async fn get_price(
    client: &HttpClient,
    price_source: PriceSource,
    exchange_pair: ExchangePair,
) -> Result<PricePair, anyhow::Error> {
    match price_source {
        PriceSource::Binance => binance::get_price(client, exchange_pair).await,
        PriceSource::Bitfinex => bitfinex::get_price(client, exchange_pair).await,
        PriceSource::BitPreco => bitpreco::get_price(client, exchange_pair).await,
        PriceSource::SSWP => sswp::get_price(client, exchange_pair).await,
    }
}

fn verify_price_pair(price_pair: PricePair) -> Result<PricePair, anyhow::Error> {
    ensure!(price_pair.ask.is_normal());
    ensure!(price_pair.bid.is_normal());
    ensure!(price_pair.bid > 0.0 && price_pair.ask > 0.0);
    ensure!(price_pair.bid <= price_pair.ask);
    Ok(price_pair)
}

async fn run(price_source: PriceSource, exchange_pair: ExchangePair, mut callback: PriceCallback) {
    let client = HttpClient::new();
    let mut last_success = None;

    loop {
        let res = get_price(&client, price_source, exchange_pair)
            .await
            .and_then(verify_price_pair);

        match res {
            Ok(price) => {
                log::debug!("price download succeed: {price:?}, exchange_pair: {exchange_pair}");

                last_success = Some(Instant::now());

                callback(Some(price));

                tokio::time::sleep(std::time::Duration::from_secs(15)).await;
            }

            Err(err) => {
                log::error!("price download failed: {err}, exchange_pair: {exchange_pair}");

                let expired = last_success
                    .map(|last_success| {
                        Instant::now().duration_since(last_success) > Duration::from_secs(600)
                    })
                    .unwrap_or(true);

                if expired {
                    callback(None);
                }

                tokio::time::sleep(std::time::Duration::from_secs(60)).await;
            }
        }
    }
}

pub fn start(price_source: PriceSource, exchange_pair: ExchangePair, callback: PriceCallback) {
    tokio::spawn(run(price_source, exchange_pair, callback));
}
