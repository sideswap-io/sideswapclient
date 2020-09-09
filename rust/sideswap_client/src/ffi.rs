use super::worker::Action;
use super::*;
use std::sync::mpsc::Sender;

#[cxx::bridge(namespace = lsw)]
pub mod ffi {
    #[derive(Clone)]
    pub struct RpcServer {
        host: String,
        port: u16,
        login: String,
        password: String,
    }

    struct StartParams {
        host: String,
        port: i32,
        use_tls: bool,
        mainnet: bool,
        db_path: String,
        is_dealer: bool,
        elements: RpcServer,
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
        fn check_xbt_address(addr: &str, mainnet: bool) -> bool;
        fn check_elements_address(addr: &str, mainnet: bool) -> bool;
        fn pegin_toggle(client: &Client);
        fn start_peg(client: &Client, addr: String);
        fn peg_back(client: &Client);
        fn wallet_password(client: &Client, password: String);
        fn cancel_passphrase(client: &Client);
        fn get_qr_code(addr: &str) -> String;

        fn rfq(client: &Client, deliver_asset: String, deliver_amount: i64, receive_asset: String);
        fn quote(client: &Client, order_id: String, proposal: i64);
        fn rfq_cancel(client: &Client, order_id: String);

        fn swap_cancel(client: &Client);
        fn swap_accept(client: &Client);

        fn try_and_apply(client: &Client, rpc_params: RpcServer);
        fn apply_config(client: &Client, index: i32);
        fn remove_config(client: &Client, index: i32);
    }
}

pub struct Client {
    sender: Sender<Action>,
}

fn create(params: ffi::StartParams) -> Box<Client> {
    if std::env::var_os("RUST_LOG").is_none() {
        std::env::set_var("RUST_LOG", "debug,hyper=info");
    }
    env_logger::init();
    info!("started");

    let params = super::settings::parse_args(params);

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
        super::worker::start_processing(sender_copy, receiver, ui_sender, params);
    });

    Box::new(Client { sender })
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
    client.sender.send(Action::TryAndApply(rpc_params)).unwrap();
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

fn quote(client: &Client, order_id: String, proposal: i64) {
    client
        .sender
        .send(Action::MatchQuote(order_id, proposal))
        .unwrap();
}

fn rfq_cancel(client: &Client, order_id: String) {
    client.sender.send(Action::MatchCancel(order_id)).unwrap();
}

fn cancel_passphrase(client: &Client) {
    client.sender.send(Action::CancelPassword).unwrap();
}

fn check_xbt_address(addr: &str, mainnet: bool) -> bool {
    match addr.parse::<bitcoin::Address>() {
        Ok(a) => a.network == bitcoin::Network::Bitcoin || !mainnet,
        Err(_) => false,
    }
}

fn check_elements_address(addr_str: &str, mainnet: bool) -> bool {
    let addr = match addr_str.parse::<elements::Address>() {
        Ok(v) => v,
        Err(_) => return false,
    };
    if !addr.is_blinded() {
        return false;
    }
    if mainnet {
        *addr.params == elements::AddressParams::LIQUID
    } else {
        *addr.params == elements::AddressParams::ELEMENTS
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

impl std::fmt::Debug for ffi::RpcServer {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("RpcServer")
            .field("host", &self.host)
            .field("port", &self.port)
            .field("login", &self.login)
            .field("password", &self.password)
            .finish()
    }
}
