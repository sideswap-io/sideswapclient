use super::worker::Action;
use super::*;
use clap::{App, Arg};
use sideswap_common::{rpc, types::Env};
use std::sync::mpsc::Sender;

#[cxx::bridge(namespace = lsw)]
pub mod ffi {
    struct RpcServer {
        host: String,
        port: u16,
        login: String,
        password: String,
    }

    struct StartParams {
        data_path: String,
    }

    extern "C" {
        fn update_state(data: &str);
        fn update_history(data: &str);
        fn update_walletinfo(data: &str);
        fn show_notification(data: &str);
        fn tx_broadcasted(data: &str);
        fn update_assets(data: &str);
        fn update_rfq_client(data: &str);
        fn update_wallets_list(data: &str);
        fn apply_wallets_result(data: &str);
    }

    extern "Rust" {
        type Client;
        fn create(params: StartParams) -> Box<Client>;
        fn check_bitcoin_address(client: &Client, addr: &str) -> bool;
        fn check_elements_address(client: &Client, addr: &str) -> bool;
        fn pegin_toggle(client: &Client);
        fn start_peg(client: &Client, addr: String);
        fn peg_back(client: &Client);
        fn wallet_password(client: &Client, password: String);
        fn cancel_passphrase(client: &Client);
        fn get_qr_code(addr: &str) -> String;

        fn rfq(client: &Client, deliver_asset: String, deliver_amount: i64, receive_asset: String);
        fn rfq_cancel(client: &Client);

        fn swap_cancel(client: &Client);
        fn swap_accept(client: &Client);

        fn try_and_apply(client: &Client, rpc_params: RpcServer);
        fn apply_config(client: &Client, index: i32);
        fn remove_config(client: &Client, index: i32);
    }
}

pub struct Client {
    sender: Sender<Action>,
    env: Env,
}

fn create(params: ffi::StartParams) -> Box<Client> {
    if cfg!(debug_assertions) && std::env::var_os("RUST_LOG").is_none() {
        std::env::set_var("RUST_LOG", "debug,hyper=info");
    }
    env_logger::init();
    info!("started");

    let matches = App::new("sideswap")
        .arg(
            Arg::with_name("staging")
                .long("staging")
                .conflicts_with("local"),
        )
        .arg(
            Arg::with_name("local")
                .long("local")
                .conflicts_with("staging"),
        )
        .get_matches();

    let env = if matches.is_present("staging") {
        Env::Staging
    } else if matches.is_present("local") {
        Env::Local
    } else {
        Env::Prod
    };

    let (sender, receiver) = std::sync::mpsc::channel::<Action>();

    let (ui_sender, ui_receiver) = std::sync::mpsc::channel::<ui::Update>();

    std::thread::spawn(move || {
        for msg in ui_receiver {
            match msg {
                ui::Update::PegUpdate(v) => {
                    let data = serde_json::to_string(&v).unwrap();
                    debug!("state: {}", &data);
                    ffi::update_state(&data);
                }
                ui::Update::SwapState(v) => {
                    let data = serde_json::to_string(&v).unwrap();
                    debug!("swap state: {}", &data);
                    ffi::update_walletinfo(&data);
                }
                ui::Update::AssetUpdate(v) => {
                    let data = serde_json::to_string(&v).unwrap();
                    debug!("assets info: {}", &data);
                    ffi::update_assets(&data);
                }
                ui::Update::RfqUpdateClient(v) => {
                    let data = serde_json::to_string(&v).unwrap();
                    debug!("match orders info: {}", &data);
                    ffi::update_rfq_client(&data);
                }
                ui::Update::Notification(v) => {
                    let data = serde_json::to_string(&v).unwrap();
                    debug!("show msg: {}", &data);
                    ffi::show_notification(&data);
                }
                ui::Update::History(v) => {
                    let data = serde_json::to_string(&v).unwrap();
                    debug!("history: {}", &data);
                    ffi::update_history(&data);
                }
                ui::Update::WalletListUpdate(v) => {
                    let data = serde_json::to_string(&v).unwrap();
                    debug!("wallet list info: {}", &data);
                    ffi::update_wallets_list(&data);
                }
                ui::Update::WalletApplyResult(v) => {
                    let data = serde_json::to_string(&v).unwrap();
                    debug!("wallet apply status info: {}", &data);
                    ffi::apply_wallets_result(&data);
                }
                ui::Update::RfqCreated(_) => {}
                ui::Update::RfqRemoved(_) => {}
            }
        }
    });

    let sender_copy = sender.clone();
    std::thread::spawn(move || {
        super::worker::start_processing(env, sender_copy, receiver, ui_sender, params);
    });

    Box::new(Client { sender, env })
}

fn pegin_toggle(client: &Client) {
    client.sender.send(Action::PegToggle).unwrap();
}

fn start_peg(client: &Client, addr: String) {
    client.sender.send(Action::StartPeg(addr)).unwrap();
}

fn peg_back(client: &Client) {
    client.sender.send(Action::PegBack).unwrap();
}

fn swap_cancel(client: &Client) {
    client.sender.send(Action::SwapCancel).unwrap();
}

fn swap_accept(client: &Client) {
    client.sender.send(Action::SwapAccept).unwrap();
}

fn try_and_apply(client: &Client, rpc_params: ffi::RpcServer) {
    let rpc_server = rpc::RpcServer {
        host: rpc_params.host,
        port: rpc_params.port,
        login: rpc_params.login,
        password: rpc_params.password,
    };
    client.sender.send(Action::TryAndApply(rpc_server)).unwrap();
}

fn apply_config(client: &Client, index: i32) {
    client.sender.send(Action::ApplyConfig(index)).unwrap();
}

fn remove_config(client: &Client, index: i32) {
    client.sender.send(Action::RemoveConfig(index)).unwrap();
}

fn wallet_password(client: &Client, password: String) {
    client
        .sender
        .send(Action::WalletPassword(password))
        .unwrap();
}

fn rfq(client: &Client, deliver_asset: String, deliver_amount: i64, receive_asset: String) {
    client
        .sender
        .send(Action::MatchRfq(
            deliver_asset,
            deliver_amount,
            receive_asset,
        ))
        .unwrap();
}

fn rfq_cancel(client: &Client) {
    client.sender.send(Action::MatchCancel).unwrap();
}

fn cancel_passphrase(client: &Client) {
    client.sender.send(Action::CancelPassword).unwrap();
}

fn check_bitcoin_address(client: &Client, addr: &str) -> bool {
    let addr = match addr.parse::<bitcoin::Address>() {
        Ok(a) => a,
        Err(_) => return false,
    };
    match client.env {
        Env::Local => addr.network == bitcoin::Network::Regtest,
        Env::Prod | Env::Staging => addr.network == bitcoin::Network::Bitcoin,
    }
}

fn check_elements_address(client: &Client, addr: &str) -> bool {
    let addr = match addr.parse::<elements::Address>() {
        Ok(v) => v,
        Err(_) => return false,
    };
    if !addr.is_blinded() {
        return false;
    }
    match client.env {
        Env::Local => *addr.params == elements::AddressParams::ELEMENTS,
        Env::Prod | Env::Staging => *addr.params == elements::AddressParams::LIQUID,
    }
}

fn get_qr_code(addr: &str) -> String {
    use qrcode::QrCode;
    let code = QrCode::new(addr).unwrap();

    code.render().light_color("0").dark_color("1").build()
}

impl Drop for Client {
    fn drop(&mut self) {
        debug!("stopped");
    }
}
