use std::time::Duration;

mod api_server;
mod db;
mod wallet;
mod worker;

#[derive(Debug, serde::Deserialize)]
pub struct Args {
    env: sideswap_common::env::Env,
    work_dir: String,
    mnemonic: String,
    api_server: api_server::Settings,
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

    let Args {
        env,
        work_dir,
        mnemonic,
        api_server,
    } = conf.try_into().expect("invalid config");

    sideswap_common::log_init::init_log(&work_dir);

    let db_path = std::path::Path::new(&work_dir).join("data.sqlite");
    let db = db::Db::open(&db_path).expect("must not fail");

    let (worker_sender, worker_receiver) = crossbeam_channel::unbounded::<worker::Req>();

    let worker_sender_copy = worker_sender.clone();
    let api_server = api_server::Server::new(
        api_server,
        Box::new(move |req| {
            worker_sender_copy
                .send(worker::Req::ApiServer(req))
                .unwrap()
        }),
    );

    let worker_sender_copy = worker_sender.clone();
    let wallet = wallet::start(wallet::Params {
        env,
        mnemonic,
        work_dir,
        callback: Box::new(move |req| {
            worker_sender_copy.send(worker::Req::Wallet(req)).unwrap();
        }),
    });

    let wallet_copy = wallet.clone();
    tokio::spawn(async move {
        loop {
            wallet_copy.send_req(wallet::Req::Timer);
            tokio::time::sleep(Duration::from_secs(1)).await;
        }
    });

    let (ws_sender, ws_receiver, _hint) = sideswap_common::ws::manual::start();

    let worker_sender_copy = worker_sender.clone();
    std::thread::spawn(move || loop {
        let ws_req = ws_receiver.recv().unwrap();
        worker_sender_copy.send(worker::Req::Ws(ws_req)).unwrap();
    });

    std::thread::spawn(move || {
        worker::run(env, worker_receiver, ws_sender, wallet, db);
    });

    sideswap_common::panic_handler::install_panic_handler();

    api_server::run(api_server).await;
}
