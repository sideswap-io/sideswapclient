use std::collections::BTreeSet;

use serde::Deserialize;
use sideswap_api::PricePair;
use sideswap_common::types::Amount;
use sideswap_dealer::{
    dealer::{self, *},
    rpc::RpcServer,
};

mod prices;

#[derive(Debug, Deserialize)]
pub struct Settings {
    log_settings: String,
    env: sideswap_common::env::Env,
    rpc: RpcServer,

    bitcoin_amount_submit: f64,
    bitcoin_amount_max: f64,
    bitcoin_amount_min: f64,

    interest_submit: f64,

    api_key: Option<String>,
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

    log4rs::init_file(&settings.log_settings, Default::default()).expect("can't open log settings");

    log::info!("starting up");

    sideswap_common::panic_handler::install_panic_handler();

    let tickers = BTreeSet::from([DealerTicker::DePIX]);

    let params = Params {
        env: settings.env,
        server_url: settings.env.base_server_ws_url(),
        rpc: settings.rpc.clone(),
        tickers,
        bitcoin_amount_submit: Amount::from_bitcoin(settings.bitcoin_amount_submit),
        bitcoin_amount_min: Amount::from_bitcoin(settings.bitcoin_amount_min),
        bitcoin_amount_max: Amount::from_bitcoin(settings.bitcoin_amount_max),
        api_key: settings.api_key.clone(),
    };

    let (dealer_tx, mut dealer_rx) = spawn_async(params);

    let dealer_tx_copy = dealer_tx;
    std::thread::spawn(move || {
        let http_client = ureq::AgentBuilder::new()
            .timeout(std::time::Duration::from_secs(20))
            .build();

        loop {
            let price = prices::download_bitcoin_last_prices(&http_client);

            match price {
                Ok(v) => {
                    let base_price = PricePair {
                        bid: v.brl,
                        ask: v.brl,
                    };
                    let submit_price = apply_interest(&base_price, settings.interest_submit);
                    let price = dealer::DealerPrice {
                        submit_price,
                        limit_btc_dealer_send: 1000.0,
                        limit_btc_dealer_recv: 1000.0,
                        balancing: false,
                    };
                    let msg = To::Price(ToPrice {
                        ticker: DealerTicker::DePIX,
                        price: Some(price),
                    });
                    dealer_tx_copy.send(msg).unwrap();
                    std::thread::sleep(std::time::Duration::from_secs(10));
                }
                Err(e) => {
                    log::error!("price download failed: {}", e);
                    std::thread::sleep(std::time::Duration::from_secs(60));
                }
            }
        }
    });

    loop {
        let msg = dealer_rx.recv().await.unwrap();

        match msg {
            From::Swap(swap) => {
                log::info!(
                    "swap succeed, bitcoin_amount: {}",
                    swap.bitcoin_amount.to_bitcoin()
                );
            }
            From::ServerConnected(_) => {}
            From::ServerDisconnected(_) => {}
            From::Utxos(_) => {}
        }
    }
}
