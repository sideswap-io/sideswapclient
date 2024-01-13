mod api_server;
mod wallet;
mod worker;

#[derive(Debug, serde::Deserialize)]
pub struct Args {
    env: sideswap_common::env::Env,
    work_dir: String,
    mnemonic: String,
    api_server: api_server::Settings,
    session_id: sideswap_api::SessionId,
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
        session_id,
    } = conf.try_into().expect("invalid config");

    sideswap_client::ffi::init_log(&work_dir);

    let (worker_sender, worker_receiver) = crossbeam_channel::unbounded::<worker::Req>();

    let worker_sender_copy = worker_sender.clone();
    let api_server = api_server::Server::new(
        api_server,
        Box::new(move |req| {
            worker_sender_copy
                .send(worker::Req::ApiServer(req))
                .unwrap()
                .into()
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

    let (ws_sender, ws_receiver, _hint) = sideswap_common::ws::manual::start(None);

    let worker_sender_copy = worker_sender.clone();
    std::thread::spawn(move || loop {
        let ws_req = ws_receiver.recv().unwrap();
        worker_sender_copy.send(worker::Req::Ws(ws_req)).unwrap();
    });

    std::thread::spawn(move || {
        worker::run(env, worker_receiver, ws_sender, wallet, session_id);
    });

    std::panic::set_hook(Box::new(|i| {
        log::error!("sideswap panic detected: {:?}", i);
        std::process::abort();
    }));

    api_server::run(api_server).await;
}
