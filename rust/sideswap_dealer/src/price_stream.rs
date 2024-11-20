use std::collections::BTreeMap;

use serde::Deserialize;
use sideswap_api::{
    market::{AssetPair, TradeDir},
    PricePair,
};
use sideswap_common::{
    env::Env,
    network::Network,
    types::{btc_to_sat, MAX_BTC_AMOUNT},
};
use sideswap_types::normal_float::NormalFloat;
use tokio::sync::mpsc::{unbounded_channel, UnboundedReceiver};

use crate::{
    dealer_rpc::{self, apply_interest},
    market,
    types::{dealer_ticker_to_asset_id, DealerTicker, ExchangePair},
};

mod binance;
mod bit_preco;

type PriceCallback = Box<dyn Fn(Option<PricePair>) -> () + Send>;

#[derive(Debug, Clone, Deserialize)]
pub enum PriceSource {
    Binance,
    BitPreco,
}

#[derive(Debug, Clone, Deserialize)]
pub struct Market {
    pub source: PriceSource,
    pub base: DealerTicker,
    pub quote: DealerTicker,
    pub interest: f64,
}

impl Market {
    pub fn exchange_pair(&self) -> ExchangePair {
        ExchangePair {
            base: self.base,
            quote: self.quote,
        }
    }
}

pub type Config = Vec<Market>;

enum Msg {
    Price {
        exchange_pair: ExchangePair,
        base_price: Option<PricePair>,
    },
}

pub struct Data {
    network: Network,
    config: Config,
    submit_prices: BTreeMap<ExchangePair, PricePair>,
    msg_receiver: UnboundedReceiver<Msg>,
}

impl Data {
    pub fn new(env: Env, config: Config) -> Data {
        let (msg_sender, msg_receiver) = unbounded_channel::<Msg>();

        for market in config.iter() {
            let exchange_pair = market.exchange_pair();
            let msg_sender_copy = msg_sender.clone();
            let callback = Box::new(move |base_price| {
                let res = msg_sender_copy.send(Msg::Price {
                    exchange_pair,
                    base_price,
                });
                if let Err(err) = res {
                    log::error!("price channel closed: {err}");
                }
            });
            match market.source {
                PriceSource::Binance => binance::start(exchange_pair, callback),
                PriceSource::BitPreco => bit_preco::start(exchange_pair, callback),
            }
        }

        Data {
            network: env.d().network,
            config,
            submit_prices: BTreeMap::new(),
            msg_receiver,
        }
    }

    pub fn dealer_prices(&self) -> Vec<dealer_rpc::UpdatePrice> {
        let mut updates = Vec::new();

        for market in self.config.iter() {
            if market.base == DealerTicker::LBTC {
                let exchange_pair = market.exchange_pair();
                let submit_price = self.submit_prices.get(&exchange_pair);
                let price = submit_price.map(|price| dealer_rpc::DealerPrice {
                    submit_price: *price,
                    limit_btc_dealer_send: MAX_BTC_AMOUNT,
                    limit_btc_dealer_recv: MAX_BTC_AMOUNT,
                    balancing: false,
                });
                updates.push(dealer_rpc::UpdatePrice {
                    ticker: market.quote,
                    price,
                });
            }
        }

        updates
    }

    pub fn market_prices(&self) -> Vec<market::AutomaticOrder> {
        let mut orders = Vec::new();

        for market in self.config.iter() {
            let exchange_pair = market.exchange_pair();
            let submit_price = self.submit_prices.get(&exchange_pair);
            if let Some(submit_price) = submit_price {
                let asset_pair = AssetPair {
                    base: dealer_ticker_to_asset_id(self.network, market.base),
                    quote: dealer_ticker_to_asset_id(self.network, market.quote),
                };
                orders.push(market::AutomaticOrder {
                    asset_pair,
                    trade_dir: TradeDir::Buy,
                    base_amount: btc_to_sat(MAX_BTC_AMOUNT),
                    price: NormalFloat::new(submit_price.bid).expect("must be valid"),
                });
                orders.push(market::AutomaticOrder {
                    asset_pair,
                    trade_dir: TradeDir::Sell,
                    base_amount: btc_to_sat(MAX_BTC_AMOUNT),
                    price: NormalFloat::new(submit_price.ask).expect("must be valid"),
                });
            }
        }

        orders
    }

    fn process_msg(&mut self, msg: Msg) {
        match msg {
            Msg::Price {
                exchange_pair,
                base_price,
            } => {
                let market = self
                    .config
                    .iter()
                    .find(|market| {
                        market.base == exchange_pair.base && market.quote == exchange_pair.quote
                    })
                    .expect("must be known market");

                match base_price {
                    Some(base_price) => {
                        let submit_price = apply_interest(&base_price, market.interest);
                        self.submit_prices.insert(exchange_pair, submit_price);
                    }
                    None => {
                        self.submit_prices.remove(&exchange_pair);
                    }
                }
            }
        }
    }

    // Cancel-safe.
    pub async fn run(&mut self) {
        // Prevent busy loop if config is empty
        if self.config.is_empty() {
            std::future::pending::<()>().await;
        }

        // Must be cancel-safe!
        loop {
            let msg = self
                .msg_receiver
                .recv()
                .await
                .expect("channel must be open");

            self.process_msg(msg);
        }
    }
}
