use std::{collections::BTreeMap, str::FromStr};

use clap::{App, Arg};
use serde::Deserialize;
use sideswap_api::PricePair;
use sideswap_common::types::Amount;
use sideswap_dealer::{dealer::*, rpc::RpcServer};

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
    interest_sign: f64,

    api_key: Option<String>,
}

fn main() {
    let matches = App::new("sideswap_dealer")
        .arg(Arg::with_name("config").required(true))
        .get_matches();
    let config_path = matches.value_of("config").unwrap();

    log::info!("starting up");

    let mut conf = config::Config::new();
    conf.merge(config::File::with_name(config_path))
        .expect("can't load config");
    conf.merge(config::Environment::with_prefix("app").separator("_"))
        .expect("reading env failed");
    let settings: Settings = conf.try_into().expect("invalid config");

    log4rs::init_file(&settings.log_settings, Default::default()).expect("can't open log settings");

    let tickers = BTreeMap::from([(
        DEALER_DEPIX,
        TickerInfo {
            interest_submit: settings.interest_submit,
            interest_sign: settings.interest_sign,
        },
    )]);

    let env_data = settings.env.data();
    let params = Params {
        env: settings.env,
        server_host: env_data.host.to_owned(),
        server_port: env_data.port,
        server_use_tls: env_data.use_tls,
        rpc: settings.rpc.clone(),
        tickers,
        bitcoin_amount_submit: Amount::from_bitcoin(settings.bitcoin_amount_submit),
        bitcoin_amount_min: Amount::from_bitcoin(settings.bitcoin_amount_min),
        bitcoin_amount_max: Amount::from_bitcoin(settings.bitcoin_amount_max),
        api_key: settings.api_key.clone(),
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
    let api_key = params.api_key.is_some();
    let depix_asset_id =
        sideswap_api::AssetId::from_str(params.env.data().network.depix_asset_id().unwrap())
            .unwrap();
    std::thread::spawn(move || loop {
        let price = prices::download_bitcoin_last_prices();

        match price {
            Ok(v) => {
                if let Some(brl) = v.brl {
                    let price = PricePair { bid: brl, ask: brl };
                    let msg = To::Price(ToPrice {
                        ticker: DEALER_DEPIX,
                        price: Some(price),
                    });
                    dealer_tx_copy.send(msg).unwrap();

                    if api_key {
                        dealer_tx
                            .send(To::BroadcastPriceStream(
                                sideswap_api::BroadcastPriceStreamRequest {
                                    asset: depix_asset_id,
                                    list: vec![
                                        sideswap_api::PriceOffer {
                                            client_send_bitcoins: true,
                                            price: brl / settings.interest_submit,
                                            max_send_amount: Amount::from_bitcoin(1.0).to_sat(), // FIXME: Take into account wallet balance
                                        },
                                        sideswap_api::PriceOffer {
                                            client_send_bitcoins: false,
                                            price: brl * settings.interest_submit,
                                            max_send_amount: Amount::from_bitcoin(brl * 1.0) // FIXME: Take into account wallet balance
                                                .to_sat(),
                                        },
                                    ],
                                    balancing: false,
                                },
                            ))
                            .unwrap();
                    }
                }
            }
            Err(e) => log::error!("price download failed: {}", e),
        }
        std::thread::sleep(std::time::Duration::from_secs(30));
    });

    loop {
        let msg = dealer_rx.recv().unwrap();

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
