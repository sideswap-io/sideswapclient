use super::hist;
use super::models::Wallet;
use serde::Serialize;
use sideswap_api::*;
use std::sync::mpsc;

#[derive(Serialize)]
pub enum NotificationType {
    Info,
    Error,
}

#[derive(Serialize, Clone)]
pub struct ConnectionState {
    pub server_connected: bool,
    pub rpc_last_call_success: bool,
    pub rpc_last_error_code: u16,
}

#[derive(Serialize)]
pub struct Notification {
    title: String,
    msg: String,
    msg_type: NotificationType,
    conn_state: ConnectionState,
}

#[derive(Debug, Serialize, Eq, PartialEq, Clone)]
pub enum Status {
    Idle,
    Waiting,
    Active,
}

#[derive(Debug, Serialize, Eq, PartialEq, Clone)]
pub enum WalletApplyStatus {
    WalletExists,
    HostNotFound,
    IncorrectCredential,
    UnknownError,
    Applied,
}

#[derive(Serialize, Clone)]
pub struct ApplyResult {
    pub result: WalletApplyStatus,
}

#[derive(Serialize, Clone)]
pub struct PegState {
    pub pegin: bool,
    pub peg_addr: String,
    pub status: Status,
    pub server_status: Option<PegStatus>,
    pub min_pegin_amount: Option<i64>,
    pub min_pegout_amount: Option<i64>,
    pub server_fee_percent_peg_in: Option<f64>,
    pub server_fee_percent_peg_out: Option<f64>,
}

#[derive(Serialize)]
pub struct MatchState {
    pub status: SwapStatus,
}

#[derive(Serialize, Clone)]
pub enum SwapStatus {
    ReviewOffer,
    WaitTxInfo,
    WaitPsbt,
    WaitSign,
    Failed,
    Done,
}

#[derive(Serialize, Clone)]
pub struct SwapState {
    pub status: SwapStatus,
    pub balances: String,
    pub encryption: bool,
    pub show_password_prompt: bool,
    pub rfq_offer: Offer,
    pub tx_id: String,
    pub asset_labels: std::collections::HashMap<String, String>,
    pub canceled_by_me: bool,
    pub network_fee: i64,
    pub server_fee: i64,
    pub swap_in_progress: bool,
    pub unconfirmed_balances: String,
    pub price: Option<f64>,
    pub deliver_amount: Option<i64>,
}

#[derive(Serialize, Clone)]
pub struct Wallets {
    pub configs: Vec<Wallet>,
}

#[derive(Serialize, Clone)]
pub struct ActiveWallet {
    pub index: i16,
}

pub type Receiver = mpsc::Receiver<Update>;
pub type Sender = mpsc::Sender<Update>;

pub enum Update {
    PegUpdate(PegState),
    SwapState(SwapState),
    AssetUpdate(AssetsResponse),
    RfqUpdateClient(MatchRfqUpdate),
    Notification(Notification),
    History(hist::State),
    WalletListUpdate(Wallets),
    WalletApplyResult(ApplyResult),
    AssetImage(String, Vec<u8>),
}

pub static TITLE_NODE_OFFLINE: &'static str = "Elements node offline";
pub static TITLE_NODE_ONLINE: &'static str = "Elements node online";
pub static TITLE_SERVER_CONN: &'static str = "Server connection";
pub static TITLE_SWAP: &'static str = "SWAP";
pub static TITLE_PEG: &'static str = "PEG";
pub static TITLE_DATABASE: &'static str = "DATABASE";
pub static TITLE_SERVER_RESP: &'static str = "Server response";

pub static MSG_NOT_CONNECTED: &'static str = "Not connected. Please make sure you have access to <a href=\"https://sideswap.io/\">sideswap server</a>.";
pub static MSG_NODE_RPC_NOT_CONNECTED_NETWORK: &'static str =
    "Please check your network configuration.";
pub static MSG_NODE_RPC_NOT_CONNECTED_AUTH: &'static str =
    "Invalid authentication data. Please check login/passsword data accuracy.";
pub static MSG_NODE_RPC_CONNECTED: &'static str =
    "You have successfully connected to your Elements node.";
pub static MSG_NO_UTXO_SELL: &'static str = "Not enough UTXO to sell.";
pub static MSG_NO_UTXO_BUY: &'static str = "Not enough UTXO to buy.";
pub static MSG_SUCCESS: &'static str = "Success.";
pub static MSG_UNEXPECTED: &'static str = "Unexpected response.";
pub static MSG_INVALID_PSWD: &'static str = "Invalid password.";
pub static MSG_CONN_LOST: &'static str = "Connection to server lost.";
pub static MSG_NO_QUOTES: &'static str = "No quotes were received.";

pub static MSG_CLIENT_ERROR: &'static str = "Sign failed.";
pub static MSG_DEALER_ERROR: &'static str = "Dealer failed to sign.";
pub static MSG_SERVER_ERROR: &'static str = "Unknown server error.";
pub static MSG_TIMEOUT: &'static str = "Swap elapsed without being accepted.";
pub static MSG_CANCELLED: &'static str = "Cancelled.";

pub fn show_notification(
    title: &str,
    msg: &str,
    msg_type: NotificationType,
    conn_state: &ConnectionState,
    ui_sender: &Sender,
) {
    let data = Notification {
        title: title.into(),
        msg: msg.into(),
        msg_type,
        conn_state: conn_state.clone(),
    };
    ui_sender.send(Update::Notification(data)).unwrap();
}

pub fn send_peg_update(state: &PegState, ui_sender: &Sender) {
    ui_sender.send(Update::PegUpdate(state.clone())).unwrap();
}

pub fn send_swap_update(state: &SwapState, ui_sender: &Sender) {
    ui_sender.send(Update::SwapState(state.clone())).unwrap();
}

pub fn send_assets_update(assets: &AssetsResponse, ui_sender: &Sender) {
    ui_sender.send(Update::AssetUpdate(assets.clone())).unwrap();
}

pub fn send_rfq_update_client(update: &MatchRfqUpdate, ui_sender: &Sender) {
    ui_sender
        .send(Update::RfqUpdateClient(update.clone()))
        .unwrap();
}

pub fn send_wallets_update(wallets: &Wallets, ui_sender: &Sender) {
    ui_sender
        .send(Update::WalletListUpdate(wallets.clone()))
        .unwrap();
}

pub fn send_wallet_apply_result(apply_status: ApplyResult, ui_sender: &Sender) {
    ui_sender
        .send(Update::WalletApplyResult(apply_status))
        .unwrap();
}

pub fn send_update_image_asset(name: String, image: Vec<u8>, ui_sender: &Sender) {
    ui_sender.send(Update::AssetImage(name, image)).unwrap();
}
