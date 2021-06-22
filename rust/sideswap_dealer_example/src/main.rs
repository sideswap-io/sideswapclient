use clap::{App, Arg};
use serde::Deserialize;
use sideswap_api::PricePair;
use sideswap_common::*;
use sideswap_dealer::{dealer::*, rpc::RpcServer};

mod prices;

#[macro_use]
extern crate log;
#[macro_use]
extern crate anyhow;

#[derive(Debug, Deserialize)]
pub struct Settings {
    log_settings: String,
    env: types::Env,
    rpc: RpcServer,

    bitcoin_amount_submit: f64,
    bitcoin_amount_max: f64,
    bitcoin_amount_min: f64,

    interest_submit: f64,
    interest_sign: f64,
}

fn main() {
    let matches = App::new("sideswap_dealer")
        .arg(Arg::with_name("config").required(true))
        .get_matches();
    let config_path = matches.value_of("config").unwrap();

    info!("starting up");

    let mut conf = config::Config::new();
    conf.merge(config::File::with_name(config_path))
        .expect("can't load config");
    conf.merge(config::Environment::with_prefix("app").separator("_"))
        .expect("reading env failed");
    let settings: Settings = conf.try_into().expect("invalid config");

    log4rs::init_file(&settings.log_settings, Default::default()).expect("can't open log settings");

    let tickers = vec![DEALER_USDT].into_iter().collect();

    let env_data = settings.env.data();
    let params = Params {
        env: settings.env,
        server_host: env_data.host.to_owned(),
        server_port: env_data.port,
        server_use_tls: env_data.use_tls,
        rpc: settings.rpc.clone(),
        interest_submit: settings.interest_submit,
        interest_sign: settings.interest_sign,
        tickers,
        bitcoin_amount_submit: types::Amount::from_bitcoin(settings.bitcoin_amount_submit),
        bitcoin_amount_min: types::Amount::from_bitcoin(settings.bitcoin_amount_min),
        bitcoin_amount_max: types::Amount::from_bitcoin(settings.bitcoin_amount_max),
    };

    let (dealer_tx, dealer_rx) = start(params.clone());

    dealer_tx
        .send(To::LimitBalance(ToLimitBalance {
            ticker: DEALER_LBTC,
            balance: settings.bitcoin_amount_max,
            recv_limit: true,
        }))
        .unwrap();
    dealer_tx
        .send(To::LimitBalance(ToLimitBalance {
            ticker: DEALER_LBTC,
            balance: settings.bitcoin_amount_max,
            recv_limit: false,
        }))
        .unwrap();

    let dealer_tx_copy = dealer_tx.clone();
    std::thread::spawn(move || loop {
        let price = prices::download_bitcoin_last_usd_price();
        match price {
            Ok(v) => {
                let price = PricePair { bid: v, ask: v };
                let msg = To::Price(ToPrice {
                    ticker: DEALER_USDT,
                    price: Some(price),
                });
                dealer_tx_copy.send(msg).unwrap();
            }
            Err(e) => error!("price download failed: {}", e),
        }
        std::thread::sleep(std::time::Duration::from_secs(10));
    });

    loop {
        let msg = dealer_rx.recv().unwrap();

        match msg {
            From::Swap(swap) => {
                info!("swap succeed: {}", swap.bitcoin_amount.to_bitcoin());
            }
            From::WalletBalanceUpdated(_) => {
                info!("wallet balance updated");
            }
        }
    }
}
