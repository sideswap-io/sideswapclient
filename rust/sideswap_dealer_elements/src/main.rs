use std::{collections::BTreeMap, time::Duration};

use serde::Deserialize;
use sideswap_api::{
    market::{AssetPair, TradeDir},
    PricePair,
};
use sideswap_common::{
    channel_helpers::UncheckedUnboundedSender,
    network::Network,
    types::{btc_to_sat, Amount, MAX_BTC_AMOUNT},
};
use sideswap_dealer::{
    dealer::{self, apply_interest},
    market,
    rpc::{self, RpcServer},
    types::{get_dealer_asset_id, DealerTicker, ExchangePair},
    utxo_data::{self, UtxoData},
};
use sideswap_types::normal_float::NormalFloat;
use tokio::sync::mpsc::unbounded_channel;

mod binance;
mod bit_preco;

#[derive(Debug, Deserialize)]
enum PriceSource {
    BitPreco,
    Binance,
}

#[derive(Debug, Deserialize)]
struct Market {
    base: DealerTicker,
    quote: DealerTicker,
    interest: f64,
    source: PriceSource,
}

#[derive(Debug, Deserialize)]
struct Settings {
    work_dir: String,
    env: sideswap_common::env::Env,
    rpc: RpcServer,

    bitcoin_amount_submit: f64,
    bitcoin_amount_max: f64,
    bitcoin_amount_min: f64,

    api_key: Option<String>,

    markets: Vec<Market>,
}

struct Data {
    network: Network,
    settings: Settings,
    dealer_sender: UncheckedUnboundedSender<dealer::To>,
    market_command_sender: UncheckedUnboundedSender<market::Command>,
    submit_prices: BTreeMap<ExchangePair, PricePair>,
    utxo_data: UtxoData,
}

enum Msg {
    Price {
        exchange_pair: ExchangePair,
        base_price: Option<PricePair>,
    },
}

type PriceCallback = Box<dyn Fn(Option<PricePair>) -> () + Send>;

impl Market {
    fn exchange_pair(&self) -> ExchangePair {
        ExchangePair {
            base: self.base,
            quote: self.quote,
        }
    }
}

fn process_from_dealer(data: &mut Data, from: dealer::From) {
    match from {
        dealer::From::Swap(swap) => {
            log::info!(
                "swap succeed, bitcoin_amount: {}",
                swap.bitcoin_amount.to_bitcoin()
            );
        }
        dealer::From::ServerConnected(_) => {}
        dealer::From::ServerDisconnected(_) => {}
        dealer::From::Utxos(utxo_data, _unspent) => {
            data.utxo_data = utxo_data;

            data.market_command_sender.send(market::Command::Utxos {
                utxos: data.utxo_data.utxos().to_vec(),
            });
        }
    }
}

fn process_market_event(data: &mut Data, event: market::Event) {
    match event {
        market::Event::SignSwap {
            quote_id,
            pset,
            blinding_nonces: _,
        } => {
            let pset = data.utxo_data.sign_pset(pset);
            data.market_command_sender
                .send(market::Command::SignedSwap { quote_id, pset });
        }

        market::Event::GetNewAddress => {
            let rpc_server = data.settings.rpc.clone();
            let command_sender = data.market_command_sender.clone();
            tokio::spawn(async move {
                let address = rpc::make_rpc_call(&rpc_server, rpc::GetNewAddressCall {})
                    .await
                    .expect("getting new address failed");
                command_sender.send(market::Command::NewAddress { address });
            });
        }

        market::Event::SwapSucceed {
            asset_pair: AssetPair { base, quote },
            trade_dir,
            base_amount,
            quote_amount,
            price,
            txid,
        } => {
            log::info!("market swap, base: {base}, quote: {quote}, base amount: {base_amount}, quote amount: {quote_amount}, price: {price}, txid: {txid}, trade_dir: {trade_dir:?}");
        }
    }
}

fn process_msg(data: &mut Data, msg: Msg) {
    match msg {
        Msg::Price {
            exchange_pair,
            base_price,
        } => {
            let market = data
                .settings
                .markets
                .iter()
                .find(|market| {
                    market.base == exchange_pair.base && market.quote == exchange_pair.quote
                })
                .expect("must be known market");

            match base_price {
                Some(base_price) => {
                    let submit_price = apply_interest(&base_price, market.interest);
                    data.submit_prices.insert(exchange_pair, submit_price);
                }
                None => {
                    data.submit_prices.remove(&exchange_pair);
                }
            }
        }
    }
}

fn submit_dealer_prices(data: &mut Data) {
    for market in data.settings.markets.iter() {
        if market.base == DealerTicker::LBTC {
            let exchange_pair = market.exchange_pair();

            let submit_price = data.submit_prices.get(&exchange_pair);

            let price = submit_price.map(|price| dealer::DealerPrice {
                submit_price: *price,
                limit_btc_dealer_send: MAX_BTC_AMOUNT,
                limit_btc_dealer_recv: MAX_BTC_AMOUNT,
                balancing: false,
            });
            let msg = dealer::To::Price(dealer::ToPrice {
                ticker: market.quote,
                price,
            });
            data.dealer_sender.send(msg);
        }
    }
}

fn submit_market_prices(data: &mut Data) {
    let mut orders = Vec::new();

    for market in data.settings.markets.iter() {
        let exchange_pair = market.exchange_pair();

        let submit_price = data.submit_prices.get(&exchange_pair);

        if let Some(submit_price) = submit_price {
            let asset_pair = AssetPair {
                base: get_dealer_asset_id(data.network, market.base),
                quote: get_dealer_asset_id(data.network, market.quote),
            };

            orders.push(market::Order {
                asset_pair,
                trade_dir: TradeDir::Buy,
                base_amount: btc_to_sat(MAX_BTC_AMOUNT),
                price: NormalFloat::new(submit_price.bid).expect("must be valid"),
            });

            orders.push(market::Order {
                asset_pair,
                trade_dir: TradeDir::Sell,
                base_amount: btc_to_sat(MAX_BTC_AMOUNT),
                price: NormalFloat::new(submit_price.ask).expect("must be valid"),
            });
        }
    }

    data.market_command_sender
        .send(market::Command::Orders { orders });
}

fn process_timer(data: &mut Data) {
    submit_dealer_prices(data);

    submit_market_prices(data);
}

#[tokio::main]
async fn main() {
    let args = std::env::args().collect::<Vec<_>>();
    assert!(
        args.len() == 2,
        "Specify a single argument for the path to the config file"
    );
    let config_path = &args[1];

    let mut conf = config::Config::new();
    conf.merge(config::File::with_name(config_path))
        .expect("can't load config");
    conf.merge(config::Environment::with_prefix("app").separator("_"))
        .expect("reading env failed");
    let settings: Settings = conf.try_into().expect("invalid config");
    assert!(!settings.markets.is_empty());

    sideswap_dealer::logs::init(&settings.work_dir);

    log::info!("started");

    sideswap_common::panic_handler::install_panic_handler();

    let server_url = settings.env.base_server_ws_url();

    let (msg_sender, mut msg_receiver) = unbounded_channel::<Msg>();

    let tickers = settings
        .markets
        .iter()
        .filter_map(|market| (market.base == DealerTicker::LBTC).then_some(market.quote))
        .collect();
    log::debug!("tickers: {tickers:?}");

    let params = dealer::Params {
        env: settings.env,
        server_url: server_url.clone(),
        rpc: settings.rpc.clone(),
        tickers,
        bitcoin_amount_submit: Amount::from_bitcoin(settings.bitcoin_amount_submit),
        bitcoin_amount_min: Amount::from_bitcoin(settings.bitcoin_amount_min),
        bitcoin_amount_max: Amount::from_bitcoin(settings.bitcoin_amount_max),
        api_key: settings.api_key.clone(),
    };
    let (dealer_sender, mut dealer_receiver) = dealer::spawn_async(params);

    for market in settings.markets.iter() {
        let exchange_pair = market.exchange_pair();
        let msg_sender = msg_sender.clone();
        match market.source {
            PriceSource::BitPreco => bit_preco::start(
                exchange_pair,
                Box::new(move |base_price| {
                    msg_sender
                        .send(Msg::Price {
                            exchange_pair,
                            base_price,
                        })
                        .expect("channel must be open");
                }),
            ),
            PriceSource::Binance => binance::start(
                exchange_pair,
                Box::new(move |base_price| {
                    msg_sender
                        .send(Msg::Price {
                            exchange_pair,
                            base_price,
                        })
                        .expect("channel must be open");
                }),
            ),
        }
    }

    let (market_command_sender, market_command_receiver) = unbounded_channel::<market::Command>();
    let (market_event_sender, mut market_event_receiver) = unbounded_channel::<market::Event>();
    let market_params = market::Params {
        env: settings.env,
        server_url,
        work_dir: settings.work_dir.clone(),
    };
    tokio::spawn(market::run(
        market_params,
        market_command_receiver,
        market_event_sender,
    ));

    let mut data = Data {
        network: settings.env.d().network,
        settings,
        dealer_sender: dealer_sender.into(),
        market_command_sender: market_command_sender.into(),
        submit_prices: BTreeMap::new(),
        utxo_data: UtxoData::new(utxo_data::Params {
            confifential_only: true,
        }),
    };

    let mut interval = tokio::time::interval(Duration::from_secs(1));

    loop {
        tokio::select! {
            from = dealer_receiver.recv() => {
                let from = from.expect("channel must be open");
                process_from_dealer(&mut data, from);
            },

            event = market_event_receiver.recv() => {
                let event = event.expect("channel must be open");
                process_market_event(&mut data, event);
            },

            msg = msg_receiver.recv() => {
                let msg = msg.expect("channel must be open");
                process_msg(&mut data, msg);
            },

            _ = interval.tick() => {
                process_timer(&mut data);
            },
        }
    }
}
