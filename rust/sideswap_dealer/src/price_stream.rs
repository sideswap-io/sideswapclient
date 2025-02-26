use std::{collections::BTreeMap, sync::Arc};

use sideswap_api::{
    mkt::{AssetPair, TradeDir},
    PricePair,
};
use sideswap_common::{
    dealer_ticker::{DealerTicker, TickerLoader},
    env::Env,
    exchange_pair::ExchangePair,
    price_stream,
};
use sideswap_types::normal_float::NormalFloat;
use tokio::sync::mpsc::{unbounded_channel, UnboundedReceiver};

use crate::{dealer_rpc, market};

enum Msg {
    Price {
        exchange_pair: ExchangePair,
        base_price: Option<PricePair>,
    },
}

pub struct Data {
    markets: price_stream::Markets,
    submit_prices: BTreeMap<ExchangePair, PricePair>,
    msg_receiver: UnboundedReceiver<Msg>,
}

impl Data {
    pub fn new(env: Env, markets: price_stream::Markets, ticker_loader: Arc<TickerLoader>) -> Data {
        let (msg_sender, msg_receiver) = unbounded_channel::<Msg>();

        for market in markets.iter() {
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

            price_stream::start(env, market.clone(), Arc::clone(&ticker_loader), callback);
        }

        Data {
            markets,
            submit_prices: BTreeMap::new(),
            msg_receiver,
        }
    }

    pub fn dealer_prices(&self) -> Vec<dealer_rpc::UpdatePrice> {
        let mut updates = Vec::new();

        for market in self.markets.iter() {
            if market.base == DealerTicker::LBTC {
                let exchange_pair = market.exchange_pair();
                let submit_price = self.submit_prices.get(&exchange_pair);
                let price = submit_price.map(|price| dealer_rpc::DealerPrice {
                    submit_price: *price,
                    limit_btc_dealer_send: market.ask_amount_f64(),
                    limit_btc_dealer_recv: market.bid_amount_f64(),
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

    pub fn market_prices(&self, ticker_loader: &TickerLoader) -> Vec<market::AutomaticOrder> {
        let mut orders = Vec::new();

        for market in self.markets.iter() {
            let exchange_pair = market.exchange_pair();
            let submit_price = self.submit_prices.get(&exchange_pair);
            if let Some(submit_price) = submit_price {
                let asset_pair = AssetPair {
                    base: *ticker_loader.asset_id(market.base),
                    quote: *ticker_loader.asset_id(market.quote),
                };

                {
                    let bid_amount = market.bid_amount_sats(ticker_loader);
                    if bid_amount > 0 {
                        orders.push(market::AutomaticOrder {
                            asset_pair,
                            trade_dir: TradeDir::Buy,
                            base_amount: bid_amount,
                            price: NormalFloat::new(submit_price.bid).expect("must be valid"),
                        });
                    }
                }

                {
                    let ask_amount = market.ask_amount_sats(ticker_loader);
                    orders.push(market::AutomaticOrder {
                        asset_pair,
                        trade_dir: TradeDir::Sell,
                        base_amount: ask_amount,
                        price: NormalFloat::new(submit_price.ask).expect("must be valid"),
                    });
                }
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
                    .markets
                    .iter()
                    .find(|market| {
                        market.base == exchange_pair.base && market.quote == exchange_pair.quote
                    })
                    .expect("must be known market");

                match base_price {
                    Some(base_price) => {
                        let submit_price = dealer_rpc::apply_interest(&base_price, market.interest);
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
        if self.markets.is_empty() {
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
