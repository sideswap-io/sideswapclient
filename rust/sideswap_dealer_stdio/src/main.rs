use serde::Deserialize;
use sideswap_common::*;
use sideswap_dealer::{dealer, rpc::RpcServer};
use std::collections::BTreeSet;

#[derive(Debug, Deserialize)]
pub struct Settings {
    log_settings: String,
    env: sideswap_common::env::Env,
    rpc: RpcServer,

    bitcoin_amount_submit: f64,
    bitcoin_amount_max: f64,
    bitcoin_amount_min: f64,

    api_key: Option<String>,
}

fn get_req() -> dealer::To {
    let mut req = String::new();
    let res = std::io::stdin().read_line(&mut req).unwrap();
    assert!(res > 0);
    log::debug!("req: {req}");
    serde_json::from_str::<dealer::To>(&req).expect("must be valid")
}

fn ignore_resp(resp: &dealer::From) -> bool {
    match resp {
        dealer::From::Utxos(_) => true,
        dealer::From::Swap(_) => false,
        dealer::From::ServerConnected(_) => false,
        dealer::From::ServerDisconnected(_) => false,
    }
}

fn send_resp(resp: dealer::From) {
    let resp = serde_json::to_string(&resp).expect("must be valid");
    log::debug!("resp: {resp}");
    println!("{}", resp);
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

    let tickers = BTreeSet::from([dealer::DealerTicker::USDt]);

    let params = dealer::Params {
        env: settings.env,
        server_url: settings.env.base_server_ws_url(),
        rpc: settings.rpc.clone(),
        tickers,
        bitcoin_amount_submit: types::Amount::from_bitcoin(settings.bitcoin_amount_submit),
        bitcoin_amount_min: types::Amount::from_bitcoin(settings.bitcoin_amount_min),
        bitcoin_amount_max: types::Amount::from_bitcoin(settings.bitcoin_amount_max),
        api_key: settings.api_key,
    };

    let (dealer_tx, mut dealer_rx) = dealer::spawn_async(params);

    std::thread::spawn(move || loop {
        let req = get_req();
        dealer_tx.send(req).unwrap();
    });

    loop {
        let resp = dealer_rx.recv().await.unwrap();
        if !ignore_resp(&resp) {
            send_resp(resp);
        }
    }
}
