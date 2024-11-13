use std::collections::BTreeMap;
use std::sync::mpsc::{channel, Sender};
use std::time::Duration;

use serde::Deserialize;
use sideswap_api::market::{AssetPair, TradeDir};
use sideswap_api::PricePair;
use sideswap_common::channel_helpers::UncheckedUnboundedSender;
use sideswap_common::network::Network;
use sideswap_common::types::{btc_to_sat, MAX_BTC_AMOUNT};
use sideswap_dealer::dealer::apply_interest;
use sideswap_dealer::types::{get_dealer_asset_id, DealerTicker, ExchangePair};
use sideswap_dealer::utxo_data::UtxoData;
use sideswap_dealer::{market, utxo_data};
use sideswap_types::normal_float::NormalFloat;
use tokio::sync::mpsc::unbounded_channel;

mod wallet;

#[derive(Debug, Deserialize)]
enum PriceSource {
    Fixed,
}

#[derive(Debug, Deserialize)]
struct Market {
    base: DealerTicker,
    quote: DealerTicker,
    interest: f64,
    source: PriceSource,
}

#[derive(Debug, serde::Deserialize)]
struct Settings {
    env: sideswap_common::env::Env,
    work_dir: String,
    mnemonic: bip39::Mnemonic,
    markets: Vec<Market>,
}

struct Data {
    settings: Settings,
    network: Network,
    market_command_sender: UncheckedUnboundedSender<market::Command>,
    wallet_command_sender: Sender<wallet::Command>,
    submit_prices: BTreeMap<ExchangePair, PricePair>,
    utxo_data: UtxoData,
}

enum Msg {
    Price {
        exchange_pair: ExchangePair,
        base_price: Option<PricePair>,
    },
}

impl Market {
    fn exchange_pair(&self) -> ExchangePair {
        ExchangePair {
            base: self.base,
            quote: self.quote,
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

fn process_wallet_event(data: &mut Data, event: wallet::Event) {
    match event {
        wallet::Event::Utxos { utxo_data } => {
            data.market_command_sender.send(market::Command::Utxos {
                utxos: utxo_data.utxos().to_vec(),
            });
            data.utxo_data = utxo_data;
        }
        wallet::Event::Address { address } => data
            .market_command_sender
            .send(market::Command::NewAddress { address }),
    }
}

fn process_market_event(data: &mut Data, event: market::Event) {
    match event {
        market::Event::SignSwap {
            quote_id,
            pset,
            blinding_nonces: _,
        } => {
            log::info!("sign swap, quote_id: {}", quote_id.value());

            let pset = data.utxo_data.sign_pset(pset);

            data.market_command_sender
                .send(market::Command::SignedSwap { quote_id, pset });
        }

        market::Event::GetNewAddress => {
            data.wallet_command_sender
                .send(wallet::Command::NewAdddress)
                .expect("must be open");
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

    let network = settings.env.d().network;

    let (msg_sender, mut msg_receiver) = unbounded_channel::<Msg>();

    let (market_command_sender, market_command_receiver) = unbounded_channel::<market::Command>();
    let (market_event_sender, mut market_event_receiver) = unbounded_channel::<market::Event>();
    let market_params = market::Params {
        env: settings.env,
        server_url: settings.env.base_server_ws_url(),
        work_dir: settings.work_dir.clone(),
    };
    tokio::spawn(market::run(
        market_params,
        market_command_receiver,
        market_event_sender,
    ));

    let (wallet_command_sender, wallet_command_receiver) = channel::<wallet::Command>();
    let (wallet_event_sender, mut wallet_event_receiver) = unbounded_channel::<wallet::Event>();
    let wallet_params = wallet::Params {
        network,
        work_dir: settings.work_dir.clone(),
        mnemonic: settings.mnemonic.clone(),
    };
    wallet::start(wallet_params, wallet_command_receiver, wallet_event_sender);

    for market in settings.markets.iter() {
        let exchange_pair = market.exchange_pair();
        let msg_sender = msg_sender.clone();
        match market.source {
            PriceSource::Fixed => {
                msg_sender
                    .send(Msg::Price {
                        exchange_pair,
                        base_price: Some(PricePair {
                            bid: 75000.0, // FIXME:
                            ask: 75000.0, // FIXME:
                        }),
                    })
                    .expect("channel must be open");
            }
        }
    }

    let mut data = Data {
        settings,
        network,
        market_command_sender: market_command_sender.into(),
        wallet_command_sender,
        submit_prices: BTreeMap::new(),
        utxo_data: UtxoData::new(utxo_data::Params {
            confifential_only: true,
        }),
    };

    let mut interval = tokio::time::interval(Duration::from_secs(1));

    loop {
        tokio::select! {
            msg = msg_receiver.recv() => {
                let msg = msg.expect("channel must be open");
                process_msg(&mut data, msg);
            },

             event = wallet_event_receiver.recv() => {
                 let event = event.expect("must be open");
                 process_wallet_event(&mut data, event);
            },

            event = market_event_receiver.recv() => {
                let event = event.expect("channel must be open");
                process_market_event(&mut data, event);
            },

            _ = interval.tick() => {
                process_timer(&mut data);
            },
        }
    }
}
