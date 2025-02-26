use std::{
    sync::Arc,
    time::{Duration, Instant},
};

use anyhow::ensure;
use serde::Deserialize;
use sideswap_api::PricePair;

use crate::{
    dealer_ticker::{DealerTicker, TickerLoader},
    env::Env,
    exchange_pair::ExchangePair,
    http_client::HttpClient,
    types::{asset_int_amount_, MAX_BTC_AMOUNT},
};

mod binance;
mod bitfinex;
mod bitpreco;
mod fixed;
mod sideswap;

#[derive(Debug, Copy, Clone, Deserialize)]
pub enum PriceSource {
    Binance,
    Bitfinex,
    BitPreco,
    SideSwap,
    Fixed,
}

pub type PriceCallback = Box<dyn FnMut(Option<PricePair>) -> () + Send>;

#[derive(Debug, Clone, Deserialize)]
pub struct Market {
    pub source: PriceSource,
    pub base: DealerTicker,
    pub quote: DealerTicker,
    pub interest: f64,
    pub fixed: Option<fixed::Params>,
    pub bid_amount: Option<f64>,
    pub ask_amount: Option<f64>,
}

impl Market {
    pub fn exchange_pair(&self) -> ExchangePair {
        ExchangePair {
            base: self.base,
            quote: self.quote,
        }
    }

    pub fn bid_amount_f64(&self) -> f64 {
        self.bid_amount.unwrap_or(MAX_BTC_AMOUNT)
    }

    pub fn ask_amount_f64(&self) -> f64 {
        self.ask_amount.unwrap_or(MAX_BTC_AMOUNT)
    }

    pub fn bid_amount_sats(&self, ticker_loader: &TickerLoader) -> u64 {
        let base_precision = ticker_loader.precision(self.base);
        asset_int_amount_(self.bid_amount_f64(), base_precision)
    }

    pub fn ask_amount_sats(&self, ticker_loader: &TickerLoader) -> u64 {
        let base_precision = ticker_loader.precision(self.base);
        asset_int_amount_(self.ask_amount_f64(), base_precision)
    }
}

pub type Markets = Vec<Market>;

async fn get_price(
    env: Env,
    client: &HttpClient,
    market: &Market,
    ticker_loader: &TickerLoader,
) -> Result<PricePair, anyhow::Error> {
    match market.source {
        PriceSource::Binance => binance::get_price(client, market).await,
        PriceSource::Bitfinex => bitfinex::get_price(client, market).await,
        PriceSource::BitPreco => bitpreco::get_price(client, market).await,
        PriceSource::SideSwap => sideswap::get_price(env, client, market, ticker_loader).await,
        PriceSource::Fixed => fixed::get_price(client, market).await,
    }
}

fn verify_price_pair(price_pair: PricePair) -> Result<PricePair, anyhow::Error> {
    ensure!(price_pair.ask.is_normal());
    ensure!(price_pair.bid.is_normal());
    ensure!(price_pair.bid > 0.0 && price_pair.ask > 0.0);
    ensure!(price_pair.bid <= price_pair.ask);
    Ok(price_pair)
}

async fn run(
    env: Env,
    market: Market,
    ticker_loader: Arc<TickerLoader>,
    mut callback: PriceCallback,
) {
    let client = HttpClient::new();
    let mut last_success = None;
    let exchange_pair = market.exchange_pair();

    loop {
        let res = get_price(env, &client, &market, &ticker_loader)
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

pub fn start(env: Env, market: Market, ticker_loader: Arc<TickerLoader>, callback: PriceCallback) {
    tokio::spawn(run(env, market, ticker_loader, callback));
}
