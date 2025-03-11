use std::{path::PathBuf, sync::Arc};

use serde::Deserialize;
use sideswap_common::{
    dealer_ticker::{TickerLoader, WhitelistedAssets},
    rpc::RpcServer,
};

mod api;
mod controller;
mod db;
mod error;
mod worker;
mod ws_server;

#[derive(Debug, Deserialize)]
struct Settings {
    env: sideswap_common::env::Env,
    work_dir: PathBuf,
    rpc: RpcServer,
    ws_server: ws_server::Config,
    whitelisted_assets: Option<WhitelistedAssets>,
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

    sideswap_dealer::logs::init(&settings.work_dir);

    sideswap_common::panic_handler::install_panic_handler();

    let db_file = settings.work_dir.join("db.sqlite");
    let db = db::Db::open_file(db_file).await;

    let ticker_loader = Arc::new(
        TickerLoader::load(
            &settings.work_dir,
            settings.whitelisted_assets.as_ref(),
            settings.env.d().network,
        )
        .await
        .expect("must not fail"),
    );

    let (command_sender, command_receiver) = tokio::sync::mpsc::unbounded_channel();

    let controller = controller::Controller::new(
        settings.env.d().network,
        Arc::clone(&ticker_loader),
        command_sender,
    );

    ws_server::start(settings.ws_server.clone(), controller);

    worker::run(settings, command_receiver, ticker_loader, db).await;
}
