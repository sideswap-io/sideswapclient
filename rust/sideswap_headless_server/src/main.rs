use std::collections::BTreeMap;
use std::sync::{Arc, Mutex};

use sideswap_api::AssetId;
use sideswap_client::ffi::proto;
use sideswap_client::ffi::{blocking_recv_msg, send_msg};

use crate::worker::WorkerReq;

mod api_server;
mod error;
mod worker;

#[derive(Debug, serde::Deserialize)]
pub struct Args {
    env: sideswap_common::env::Env,
    work_dir: String,
    mnemonic: String,
    api_server: api_server::Settings,
}

#[derive(serde::Serialize, Clone, Copy)]
enum Status {
    Active,
    Expired,
    Succeed,
}

#[derive(serde::Serialize, Clone)]
struct OrderStatus {
    status: Status,
    txid: Option<String>,
}

pub struct Context {
    orders: Mutex<BTreeMap<String, proto::Order>>,
    statuses: Mutex<BTreeMap<String, OrderStatus>>,
    req_sender: crossbeam_channel::Sender<crate::WorkerReq>,
}

#[derive(serde::Deserialize)]
pub struct NewOrder {
    asset_id: AssetId,
    asset_amount: i64,
    price: f64,
    private: Option<bool>,
    ttl_seconds: Option<u64>,
}

#[tokio::main]
async fn main() {
    let matches = clap::App::new("sideswap_headless_server")
        .arg(clap::Arg::with_name("config").required(true))
        .get_matches();
    let config_path = matches.value_of("config").unwrap();

    let mut conf = config::Config::new();
    conf.merge(config::File::with_name(config_path))
        .expect("can't load config");
    conf.merge(config::Environment::with_prefix("app").separator("_"))
        .expect("reading env failed");
    let args: Args = conf.try_into().expect("invalid config");

    let start_params = sideswap_client::ffi::StartParams {
        work_dir: args.work_dir.clone(),
        version: "1.0.0".to_owned(),
        disable_device_key: Some(true),
    };

    let client = sideswap_client::ffi::sideswap_client_start_impl(
        args.env,
        start_params,
        sideswap_client::ffi::SIDESWAP_DART_PORT_DISABLED,
    );
    assert!(client != 0);

    send_msg(
        client,
        proto::to::Msg::Login(proto::to::Login {
            wallet: Some(proto::to::login::Wallet::Mnemonic(args.mnemonic.clone())),
            network: proto::NetworkSettings {
                selected: Some(proto::network_settings::Selected::Sideswap(proto::Empty {})),
            },
            phone_key: None,
            send_utxo_updates: None,
            force_auto_sign_maker: None,
        }),
    );

    let (req_sender, req_receiver) = crossbeam_channel::unbounded::<WorkerReq>();

    let context = Arc::new(Context {
        orders: Default::default(),
        statuses: Default::default(),
        req_sender: req_sender.clone(),
    });

    let api_server = api_server::Server::new(Arc::clone(&context));

    std::thread::spawn(move || loop {
        let msg = blocking_recv_msg(client);
        req_sender.send(WorkerReq::FromMsg(msg)).unwrap();
    });

    std::thread::spawn(move || {
        worker::run(client, req_receiver, api_server);
    });

    api_server::run(args.api_server, context).await;
}
