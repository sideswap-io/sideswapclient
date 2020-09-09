use super::*;
use ffi::ffi::*;
use sideswap_api::*;
use std::sync::mpsc::{Receiver, Sender};

const CLIENT_API_KEY: &str = "f8b7a12ee96aa68ee2b12ebfc51d804a4a404c9732652c298d24099a3d922a84";
const DEALER_API_KEY: &str = "74b1331e904f354a1db3133ba6b21d52a4b99c7dfbbf677fa1c58bcbd602976c";

const USER_AGENT: &str = "SideSwapGUI";

const SETTING_COOKIE: &str = "cookie";

#[derive(Debug)]
pub enum Action {
    ServerResponse(ws::WrappedResponse),
    UpdateBalanceTicker,
    CheckServerConnection,

    PegToggle,
    StartPeg(String),
    PegBack,
    WalletPassword(String),
    CancelPassword,

    MatchRfq(String, i64, String),
    MatchQuote(String, i64),
    MatchCancel(String),

    SwapCancel,
    SwapAccept,
    TryAndApply(RpcServer),
    ApplyConfig(i32),
    RemoveConfig(i32),
}

#[derive(
    Eq,
    PartialEq,
    Debug,
    derive_more::Add,
    derive_more::Sub,
    derive_more::Display,
    Copy,
    Clone,
    PartialOrd,
    Ord,
)]
pub struct XbtAmount(pub i64);

const BALANCE_DIVIDER: i64 = 100_000_000;

impl XbtAmount {
    pub fn from_satoshi(value: i64) -> Self {
        XbtAmount(value)
    }

    pub fn from_bitcoins(value: f64) -> Self {
        XbtAmount((value * BALANCE_DIVIDER as f64).round() as i64)
    }

    pub fn to_satoshi(&self) -> i64 {
        self.0
    }

    pub fn to_bitcoin(&self) -> f64 {
        (self.0 as f64) / (BALANCE_DIVIDER as f64)
    }
}

#[derive(Default)]
pub struct DBData {
    pub peg_orders: std::collections::BTreeMap<i32, models::Order>,
    pub peg_address_map: std::collections::BTreeMap<String, i32>,
    pub peg_status_map: std::collections::BTreeMap<i32, PegStatus>,

    pub swap_ids: std::collections::BTreeMap<i32, models::Swap>,
    pub swaps: std::collections::BTreeMap<String, SwapStatusResponse>,

    pub wallets: Vec<models::Wallet>,
}

pub fn init_swap_state() -> ui::SwapState {
    ui::SwapState {
        balances: "".into(),
        encryption: false,
        show_password_prompt: false,
        status: ui::SwapStatus::Failed,
        rfq_offer: Offer {
            swap: Swap {
                order_id: OrderId("".into()),
                sell_asset: "".into(),
                sell_amount: 0,
                buy_asset: "".into(),
                buy_amount: 0,
            },
            created_at: 0,
            expires_at: 0,
        },
        tx_id: "".into(),
        psb_to_sign: "".into(),
        asset_labels: rpc::AssetLabels::new(),
        own_outputs: SwapOutputs::new(),
        contra_outputs: SwapOutputs::new(),
        canceled_by_me: false,
        stage_accepted_by_me: false,
    }
}

fn is_default_rpc(rpc_server: &rpc::RpcServer) -> bool {
    rpc_server.host == "localhost"
        && rpc_server.port == 7041
        && rpc_server.login.is_empty()
        && rpc_server.password.is_empty()
}

fn fill_last_active(rpc_server: &mut rpc::RpcServer, hist: &mut DBData) {
    for wallet in hist.wallets.iter() {
        if wallet.is_active {
            rpc_server.host = wallet.host.clone();
            rpc_server.port = wallet.port.parse::<u16>().unwrap();
            rpc_server.login = wallet.user_name.clone();
            rpc_server.password = wallet.user_pass.clone();
            break;
        }
    }
}

fn fill_default_rpc(rpc_server: &mut rpc::RpcServer) {
    rpc_server.host = "localhost".into();
    rpc_server.port = 7041;

    let mut is_linux = false;
    let mut conf_path = match std::env::consts::FAMILY {
        "unix" => match std::env::consts::OS {
            "macos" => dirs::config_dir(),
            _ => {
                is_linux = true;
                dirs::home_dir()
            }
        },
        _ => dirs::config_dir(),
    }
    .unwrap();

    if is_linux {
        conf_path.push(".elements");
    } else {
        conf_path.push("Elements");
    }

    conf_path.push("liquidv1");
    conf_path.push(".cookie");

    let cookie = std::fs::read_to_string(conf_path).unwrap_or_default();

    let credential: Vec<&str> = cookie.split(':').collect();
    if credential.len() >= 2 {
        rpc_server.login = credential[0].into();
        rpc_server.password = credential[1].into();
    }
}

fn update_wallet_data(
    state: &mut ui::SwapState,
    http_client: &reqwest::blocking::Client,
    rpc_server: &mut rpc::RpcServer,
    ui_sender: &Sender<ui::Update>,
    conn_state: &mut ui::ConnectionState,
    hist: &mut DBData,
) {
    if conn_state.rpc_last_call_success {
        state.encryption =
            rpc::make_rpc_call_status(&http_client, &rpc_server, &rpc::set_wallet_lock())
                == reqwest::StatusCode::OK;

        update_asset_labels(state, &http_client, &rpc_server);
        update_wallet_balances(state, &http_client, &rpc_server, &ui_sender, conn_state);
    } else {
        state.encryption = false;
        state.asset_labels = rpc::AssetLabels::new();
        state.balances = "".into();
        ui::send_swap_update(&state, &ui_sender);
    }

    let wallets = ui::Wallets {
        configs: hist.wallets.to_vec(),
    };
    ui::send_wallets_update(&wallets, &ui_sender);
}

fn save_wallet(
    rpc_server: &mut rpc::RpcServer,
    db: &db::Db,
    hist: &mut DBData,
    is_default: bool,
) -> bool {
    let result = db.create_wallet(&mut models::NewWallet {
        id: None,
        wallet_type: "Elements".into(),
        host: rpc_server.host.clone(),
        port: rpc_server.port.to_string(),
        user_name: if !is_default {
            rpc_server.login.clone()
        } else {
            "".into()
        },
        user_pass: if !is_default {
            rpc_server.password.clone()
        } else {
            "".into()
        },
        is_active: true,
    });

    hist.wallets = db.load_wallets();

    match result {
        Ok(_) => true,
        Err(_e) => false,
    }
}

fn check_rpc_init(
    state: &mut ui::SwapState,
    http_client: &reqwest::blocking::Client,
    rpc_server: &mut rpc::RpcServer,
    ui_sender: &Sender<ui::Update>,
    conn_state: &mut ui::ConnectionState,
    db: &db::Db,
    hist: &mut DBData,
    is_dealer: bool,
) {
    let mut new_config = true;
    if rpc_server.host.is_empty() && !is_dealer {
        fill_last_active(rpc_server, hist);
        new_config = rpc_server.host.is_empty();
    }

    let is_default = rpc_server.host.is_empty() || is_default_rpc(rpc_server);
    if is_default {
        fill_default_rpc(rpc_server);
    }

    conn_state.rpc_last_error_code =
        rpc::make_rpc_call_status(&http_client, &rpc_server, &rpc::ping()).as_u16();
    conn_state.rpc_last_call_success = conn_state.rpc_last_error_code == reqwest::StatusCode::OK;

    if conn_state.rpc_last_call_success && new_config && !is_dealer {
        save_wallet(rpc_server, db, hist, is_default);
    }

    update_wallet_data(state, http_client, rpc_server, ui_sender, conn_state, hist);

    let msg = (|| {
        if !conn_state.rpc_last_call_success && !new_config {
            if conn_state.rpc_last_error_code == 401 {
                return ui::MSG_NODE_RPC_NOT_CONNECTED_AUTH;
            } else {
                return ui::MSG_NODE_RPC_NOT_CONNECTED_NETWORK;
            };
        } else {
            return "".into();
        };
    })();

    ui::show_notification(
        ui::TITLE_NODE_RPC_CONN,
        msg,
        ui::NotificationType::Error,
        conn_state,
        &ui_sender,
    );
}

fn try_new_rpc(
    new_server: &mut rpc::RpcServer,
    state: &mut ui::SwapState,
    http_client: &reqwest::blocking::Client,
    rpc_server: &mut rpc::RpcServer,
    ui_sender: &Sender<ui::Update>,
    conn_state: &mut ui::ConnectionState,
    db: &db::Db,
    hist: &mut DBData,
) {
    let is_default = is_default_rpc(new_server);

    if is_default {
        fill_default_rpc(new_server);
    }

    let try_code = rpc::make_rpc_call_status(&http_client, &new_server, &rpc::ping()).as_u16();

    let response = if try_code == 401 {
        ui::WalletApplyStatus::IncorrectCredential
    } else if try_code == 404 {
        ui::WalletApplyStatus::HostNotFound
    } else if try_code != 200 {
        ui::WalletApplyStatus::UnknownError
    } else {
        let success = save_wallet(new_server, db, hist, is_default);
        if success {
            *rpc_server = new_server.clone();
            conn_state.rpc_last_error_code = try_code;
            conn_state.rpc_last_call_success = true;
            update_wallet_data(state, http_client, rpc_server, ui_sender, conn_state, hist);

            ui::WalletApplyStatus::Applied
        } else {
            ui::WalletApplyStatus::WalletExists
        }
    };

    ui::send_wallet_apply_result(ui::ApplyResult { result: response }, &ui_sender);
}

fn rpc_apply(
    index: i32,
    state: &mut ui::SwapState,
    http_client: &reqwest::blocking::Client,
    rpc_server: &mut rpc::RpcServer,
    ui_sender: &Sender<ui::Update>,
    conn_state: &mut ui::ConnectionState,
    db: &db::Db,
    hist: &mut DBData,
) {
    if index < 0 || index as usize >= hist.wallets.len() {
        return;
    }

    hist.wallets = db.mark_wallet_as_active(hist.wallets[index as usize].id);
    fill_last_active(rpc_server, hist);

    if is_default_rpc(rpc_server) {
        fill_default_rpc(rpc_server);
    }

    conn_state.rpc_last_error_code =
        rpc::make_rpc_call_status(&http_client, &rpc_server, &rpc::ping()).as_u16();
    conn_state.rpc_last_call_success = conn_state.rpc_last_error_code == reqwest::StatusCode::OK;

    update_wallet_data(state, http_client, rpc_server, ui_sender, conn_state, hist);

    let msg = (|| {
        if !conn_state.rpc_last_call_success {
            if conn_state.rpc_last_error_code == 401 {
                return ui::MSG_NODE_RPC_NOT_CONNECTED_AUTH;
            } else {
                return ui::MSG_NODE_RPC_NOT_CONNECTED_NETWORK;
            };
        } else {
            return ui::MSG_NODE_RPC_CONNECTED;
        };
    })();

    let msg_type = if !conn_state.rpc_last_call_success {
        ui::NotificationType::Error
    } else {
        ui::NotificationType::Info
    };

    ui::show_notification(
        ui::TITLE_NODE_RPC_CONN,
        msg,
        msg_type,
        conn_state,
        &ui_sender,
    );
}

fn rpc_remove(
    index: i32,
    state: &mut ui::SwapState,
    http_client: &reqwest::blocking::Client,
    rpc_server: &mut rpc::RpcServer,
    ui_sender: &Sender<ui::Update>,
    conn_state: &mut ui::ConnectionState,
    db: &db::Db,
    hist: &mut DBData,
) {
    if index < 0 || index as usize >= hist.wallets.len() {
        return;
    }
    hist.wallets = db.remove_wallet(hist.wallets[index as usize].id);

    if !hist.wallets.is_empty() {
        fill_last_active(rpc_server, hist);

        if is_default_rpc(rpc_server) {
            fill_default_rpc(rpc_server);
        }

        conn_state.rpc_last_error_code =
            rpc::make_rpc_call_status(&http_client, &rpc_server, &rpc::ping()).as_u16();
        conn_state.rpc_last_call_success =
            conn_state.rpc_last_error_code == reqwest::StatusCode::OK;
    } else {
        conn_state.rpc_last_call_success = false;
    }

    update_wallet_data(state, http_client, rpc_server, ui_sender, conn_state, hist);

    ui::show_notification(
        ui::TITLE_NODE_RPC_CONN,
        "".into(),
        ui::NotificationType::Error,
        conn_state,
        &ui_sender,
    );
}

fn update_asset_labels(
    state: &mut ui::SwapState,
    http_client: &reqwest::blocking::Client,
    rpc_server: &rpc::RpcServer,
) {
    let asset_labels_res = rpc::make_rpc_call::<rpc::AssetLabels>(
        &http_client,
        &rpc_server,
        &rpc::dump_asset_labels(),
    );

    state.asset_labels = match asset_labels_res {
        Ok(res) => res,
        _ => rpc::AssetLabels::new(),
    };
}

fn update_wallet_balances(
    state: &mut ui::SwapState,
    http_client: &reqwest::blocking::Client,
    rpc_server: &rpc::RpcServer,
    ui_sender: &Sender<ui::Update>,
    conn_state: &mut ui::ConnectionState,
) {
    let wallet_balance = rpc::make_rpc_call_silent::<rpc::GetWalletInfo>(
        &http_client,
        &rpc_server,
        &rpc::get_wallet_info(),
    );

    let bal = match wallet_balance {
        Ok(info) => {
            let mut balances = std::collections::HashMap::<String, i64>::new();
            for (label, amount) in &info.balance {
                let balance_code = match state.asset_labels.get(label) {
                    Some(code) => code,
                    None => label,
                };
                balances.insert(
                    balance_code.clone(),
                    XbtAmount::from_bitcoins(amount.clone()).to_satoshi(),
                );
            }
            serde_json::to_string(&balances).unwrap()
        }
        Err(_e) => {
            if conn_state.rpc_last_call_success {
                conn_state.rpc_last_call_success = false;

                conn_state.rpc_last_error_code =
                    rpc::make_rpc_call_status(&http_client, &rpc_server, &rpc::ping()).as_u16();
                conn_state.rpc_last_call_success =
                    conn_state.rpc_last_error_code == reqwest::StatusCode::OK;

                let msg = if conn_state.rpc_last_error_code == 401 {
                    ui::MSG_NODE_RPC_NOT_CONNECTED_AUTH
                } else {
                    ui::MSG_NODE_RPC_NOT_CONNECTED_NETWORK
                };

                ui::show_notification(
                    ui::TITLE_NODE_RPC_CONN,
                    msg,
                    ui::NotificationType::Error,
                    conn_state,
                    &ui_sender,
                );
            }
            String::new()
        }
    };

    state.balances = bal;
    ui::send_swap_update(&state, &ui_sender);
}

fn add_history_peg_order(
    hist: &mut DBData,
    order: models::Order,
    conn: &ws::Sender,
    connected: bool,
    ui_sender: &Sender<ui::Update>,
) {
    if connected {
        request_order_history(&order, conn);
    }
    hist.peg_address_map
        .insert(order.peg_addr.clone(), order.id);
    hist.peg_orders.insert(order.id, order);
    hist::update_ui(&hist, &ui_sender);
}

fn add_history_swap_order_id(
    hist: &mut DBData,
    order: models::Swap,
    conn: &ws::Sender,
    connected: bool,
) {
    if connected {
        send_request(
            &conn,
            Request::SwapStatus(SwapStatusRequest {
                order_id: OrderId(order.order_id.clone()),
            }),
        );
    }
    hist.swap_ids.insert(order.id, order);
}

fn add_history_swap_update(
    hist: &mut DBData,
    order: SwapStatusResponse,
    ui_sender: &Sender<ui::Update>,
) {
    hist.swaps.insert(order.swap.order_id.to_string(), order);
    hist::update_ui(&hist, &ui_sender);
}

fn request_order_history(order: &models::Order, conn: &ws::Sender) {
    let status_request = if order.pegin {
        Request::PegInStatus(PegInStatusRequest {
            order_id: OrderId(order.order_id.clone()),
        })
    } else {
        Request::PegOutStatus(PegOutStatusRequest {
            order_id: OrderId(order.order_id.clone()),
        })
    };
    send_request(&conn, status_request);
}

fn send_request(conn: &ws::Sender, r: Request) -> RequestId {
    let request_id = ws::next_request_id();
    conn.send(ws::WrappedRequest::Request(RequestMessage::Request(
        request_id.clone(),
        r,
    )))
    .unwrap();
    request_id
}

fn request_all_orders_history(hist: &DBData, conn: &ws::Sender) {
    for (_, order) in hist.peg_orders.iter() {
        request_order_history(order, conn);
    }
}

fn accept_swap(
    state: &mut ui::SwapState,
    conn_state: &mut ui::ConnectionState,
    http_client: &reqwest::blocking::Client,
    rpc_server: &rpc::RpcServer,
    conn: &ws::Sender,
    db: &db::Db,
    hist: &mut worker::DBData,
    ui_sender: &Sender<ui::Update>,
) {
    let order = db.create_swap(models::NewSwap {
        order_id: state.rfq_offer.swap.order_id.to_string(),
    });
    add_history_swap_order_id(hist, order, &conn, conn_state.server_connected);

    let asset_labels_res = rpc::make_rpc_call::<rpc::AssetLabels>(
        &http_client,
        &rpc_server,
        &rpc::dump_asset_labels(),
    );
    let is_sell_bitcoin = match asset_labels_res {
        Ok(res) => {
            let mut is_bitcoin = false;
            for (k, v) in res {
                if k == "bitcoin" {
                    is_bitcoin = v == *state.rfq_offer.swap.sell_asset;
                }
            }
            is_bitcoin
        }
        Err(e) => {
            ui::show_notification(
                ui::TITLE_SWAP,
                &e.to_string(),
                ui::NotificationType::Error,
                conn_state,
                &ui_sender,
            );
            return;
        }
    };

    if !is_sell_bitcoin {
        send_psbt(
            &state,
            conn_state,
            &http_client,
            &rpc_server,
            &conn,
            &ui_sender,
        );
    } else {
        send_psbt_with_fee(
            &state,
            conn_state,
            &http_client,
            &rpc_server,
            &conn,
            &ui_sender,
        );
    }
}

fn process_status_update(hist: &mut DBData, status: PegStatus, ui_sender: &Sender<ui::Update>) {
    let order_id = match hist.peg_address_map.get(&status.addr) {
        Some(v) => v,
        None => {
            error!(
                "unexpected order status update: {}",
                serde_json::to_string(&status).unwrap()
            );
            return;
        }
    };
    hist.peg_status_map.insert(*order_id, status);
    hist::update_ui(&hist, &ui_sender);
}

fn process_server_status_update(
    state: &mut ui::PegState,
    status: &ServerStatus,
    ui_sender: &Sender<ui::Update>,
) {
    state.min_pegin_amount = Some(status.min_peg_in_amount);
    state.min_pegout_amount = Some(status.min_peg_out_amount);
    state.server_fee_percent_peg_in = Some(status.server_fee_percent_peg_in);
    state.server_fee_percent_peg_out = Some(status.server_fee_percent_peg_out);
    ui::send_peg_update(&state, &ui_sender);
}

fn send_own_txinfo(
    state: &ui::SwapState,
    conn_state: &mut ui::ConnectionState,
    http_client: &reqwest::blocking::Client,
    rpc_server: &rpc::RpcServer,
    conn: &ws::Sender,
    ui_sender: &Sender<ui::Update>,
) {
    if !conn_state.server_connected {
        ui::show_notification(
            ui::TITLE_SERVER_CONN,
            ui::MSG_NOT_CONNECTED,
            ui::NotificationType::Error,
            conn_state,
            &ui_sender,
        );
        return;
    }

    let new_addr_res =
        rpc::make_rpc_call::<String>(&http_client, &rpc_server, &rpc::get_new_address());
    let new_addr = match new_addr_res {
        Ok(addr) => addr,
        Err(e) => {
            let error = e.to_string();
            ui::show_notification(
                ui::TITLE_SWAP,
                &error,
                ui::NotificationType::Error,
                conn_state,
                &ui_sender,
            );
            return;
        }
    };

    let sell_amount = XbtAmount::from_satoshi(state.rfq_offer.swap.sell_amount);
    let sell_asset = &state.rfq_offer.swap.sell_asset;

    let list_unspend_req = rpc::list_unspent(&sell_amount.to_bitcoin().to_string(), &sell_asset);
    let list_unspend_res =
        rpc::make_rpc_call::<Vec<rpc::RawUtxo>>(&http_client, &rpc_server, &list_unspend_req);
    let utxos = match list_unspend_res {
        Ok(res) => res,
        Err(e) => {
            ui::show_notification(
                ui::TITLE_SWAP,
                &e.to_string(),
                ui::NotificationType::Error,
                conn_state,
                &ui_sender,
            );
            return;
        }
    };

    let mut total_utxos_amount = XbtAmount::from_bitcoins(0.0);
    let mut inputs = Vec::new();
    for utxo in utxos {
        total_utxos_amount = total_utxos_amount + XbtAmount::from_bitcoins(utxo.amount);
        inputs.push(rpc::RawTxInputs {
            txid: utxo.txid,
            vout: utxo.vout,
        })
    }

    let has_change = total_utxos_amount != sell_amount;

    send_request(
        &conn,
        Request::Swap(SwapRequest {
            order_id: state.rfq_offer.swap.order_id.clone(),
            action: SwapAction::TxInfo(SwapTxInfo {
                recv_address: new_addr,
                utxo_count: inputs.len() as i32,
                with_change: has_change,
            }),
        }),
    );
}

fn send_psbt(
    state: &ui::SwapState,
    conn_state: &mut ui::ConnectionState,
    http_client: &reqwest::blocking::Client,
    rpc_server: &rpc::RpcServer,
    conn: &ws::Sender,
    ui_sender: &Sender<ui::Update>,
) {
    if !conn_state.server_connected {
        ui::show_notification(
            ui::TITLE_SERVER_CONN,
            ui::MSG_NOT_CONNECTED,
            ui::NotificationType::Error,
            conn_state,
            &ui_sender,
        );
        return;
    }

    let sell_amount = XbtAmount::from_satoshi(state.rfq_offer.swap.sell_amount);
    let sell_asset = &state.rfq_offer.swap.sell_asset;

    let list_unspend_req = rpc::list_unspent(&sell_amount.to_bitcoin().to_string(), &sell_asset);
    let list_unspend_res =
        rpc::make_rpc_call::<Vec<rpc::RawUtxo>>(&http_client, &rpc_server, &list_unspend_req);
    let utxos = match list_unspend_res {
        Ok(res) => res,
        Err(e) => {
            ui::show_notification(
                ui::TITLE_SWAP,
                &e.to_string(),
                ui::NotificationType::Error,
                conn_state,
                &ui_sender,
            );
            return;
        }
    };

    let mut inputs = Vec::new();
    let mut total_utxos_amount = XbtAmount::from_bitcoins(0.0);
    for utxo in utxos {
        total_utxos_amount = total_utxos_amount + XbtAmount::from_bitcoins(utxo.amount);
        inputs.push(rpc::RawTxInputs {
            txid: utxo.txid,
            vout: utxo.vout,
        })
    }

    let mut out_amount = rpc::RawTxOutputsAmounts::new();
    let mut out_asset = rpc::RawTxOutputsAssets::new();

    for output in &state.own_outputs {
        match output.output_type {
            OutputType::ContraOutput => {
                let addr = match output.addr.clone() {
                    Some(res) => res,
                    None => "".into(),
                };
                out_amount.insert(
                    addr.clone(),
                    XbtAmount::from_satoshi(output.amount.clone()).to_bitcoin(),
                );
                out_asset.insert(addr.clone(), output.asset.clone());
            }
            _ => {}
        }
    }

    let change_amount = total_utxos_amount - sell_amount;
    if change_amount.to_satoshi() < 0 {
        ui::show_notification(
            ui::TITLE_SWAP,
            ui::MSG_NO_UTXO_SELL,
            ui::NotificationType::Error,
            conn_state,
            &ui_sender,
        );
        return;
    }
    if change_amount.to_satoshi() > 0 {
        let change_res =
            rpc::make_rpc_call::<String>(&http_client, &rpc_server, &rpc::get_new_address());
        let change = match change_res {
            Ok(addr) => addr,
            Err(e) => {
                let error = e.to_string();
                ui::show_notification(
                    ui::TITLE_SWAP,
                    &error,
                    ui::NotificationType::Error,
                    conn_state,
                    &ui_sender,
                );
                return;
            }
        };

        out_amount.insert(change.clone(), change_amount.to_bitcoin());
        out_asset.insert(change.clone(), sell_asset.clone());
    }

    let raw_tx_request = rpc::create_raw_tx(&inputs, &out_amount, 0, false, &out_asset);
    let raw_tx_res = rpc::make_rpc_call::<String>(&http_client, &rpc_server, &raw_tx_request);
    let raw_tx = match raw_tx_res {
        Ok(res) => res,
        Err(e) => {
            let error = e.to_string();
            ui::show_notification(
                ui::TITLE_SWAP,
                &error,
                ui::NotificationType::Error,
                conn_state,
                &ui_sender,
            );
            return;
        }
    };

    let conv_psbt_tx_res =
        rpc::make_rpc_call::<String>(&http_client, &rpc_server, &rpc::convert_to_psbt(&raw_tx));
    let conv_psbt_tx = match conv_psbt_tx_res {
        Ok(res) => res,
        Err(e) => {
            let error = e.to_string();
            ui::show_notification(
                ui::TITLE_SWAP,
                &error,
                ui::NotificationType::Error,
                conn_state,
                &ui_sender,
            );
            return;
        }
    };

    let psbt_tx_res = rpc::make_rpc_call::<rpc::PsbtTx>(
        &http_client,
        &rpc_server,
        &rpc::fill_psbt_data(&conv_psbt_tx),
    );
    let psbt_tx = match psbt_tx_res {
        Ok(res) => res.psbt,
        Err(e) => {
            let error = e.to_string();
            ui::show_notification(
                ui::TITLE_SWAP,
                &error,
                ui::NotificationType::Error,
                conn_state,
                &ui_sender,
            );
            return;
        }
    };

    send_request(
        &conn,
        Request::Swap(SwapRequest {
            order_id: state.rfq_offer.swap.order_id.clone(),
            action: SwapAction::Psbt(psbt_tx),
        }),
    );
}

fn send_psbt_with_fee(
    state: &ui::SwapState,
    conn_state: &mut ui::ConnectionState,
    http_client: &reqwest::blocking::Client,
    rpc_server: &rpc::RpcServer,
    conn: &ws::Sender,
    ui_sender: &Sender<ui::Update>,
) {
    if !conn_state.server_connected {
        ui::show_notification(
            ui::TITLE_SERVER_CONN,
            ui::MSG_NOT_CONNECTED,
            ui::NotificationType::Error,
            conn_state,
            &ui_sender,
        );
        return;
    }

    let sell_amount = XbtAmount::from_satoshi(state.rfq_offer.swap.sell_amount);
    let sell_asset = &state.rfq_offer.swap.sell_asset;

    let list_unspend_req = rpc::list_unspent(&sell_amount.to_bitcoin().to_string(), &sell_asset);
    let list_unspend_res =
        rpc::make_rpc_call::<Vec<rpc::RawUtxo>>(&http_client, &rpc_server, &list_unspend_req);
    let utxos = match list_unspend_res {
        Ok(res) => res,
        Err(e) => {
            ui::show_notification(
                ui::TITLE_SWAP,
                &e.to_string(),
                ui::NotificationType::Error,
                conn_state,
                &ui_sender,
            );
            return;
        }
    };

    let mut total_utxos_amount = XbtAmount::from_bitcoins(0.0);
    let mut inputs = Vec::new();
    for utxo in utxos {
        total_utxos_amount = total_utxos_amount + XbtAmount::from_bitcoins(utxo.amount);
        inputs.push(rpc::RawTxInputs {
            txid: utxo.txid,
            vout: utxo.vout,
        })
    }

    let mut out_amount = rpc::RawTxOutputsAmounts::new();
    let mut out_asset = rpc::RawTxOutputsAssets::new();

    for output in &state.own_outputs {
        match output.output_type {
            OutputType::NetworkFee => {
                out_amount.insert(
                    "fee".into(),
                    XbtAmount::from_satoshi(output.amount.clone()).to_bitcoin(),
                );
            }
            _ => {
                let addr = match output.addr.clone() {
                    Some(res) => res,
                    None => "".into(),
                };
                out_amount.insert(
                    addr.clone(),
                    XbtAmount::from_satoshi(output.amount.clone()).to_bitcoin(),
                );
                out_asset.insert(addr.clone(), output.asset.clone());
            }
        }
    }

    let change_amount = total_utxos_amount - sell_amount;
    if change_amount.to_satoshi() < 0 {
        ui::show_notification(
            ui::TITLE_SWAP,
            ui::MSG_NO_UTXO_BUY,
            ui::NotificationType::Error,
            conn_state,
            &ui_sender,
        );
        return;
    }
    if change_amount.to_satoshi() > 0 {
        let change_res =
            rpc::make_rpc_call::<String>(&http_client, &rpc_server, &rpc::get_new_address());
        let change = match change_res {
            Ok(addr) => addr,
            Err(e) => {
                let error = e.to_string();
                ui::show_notification(
                    ui::TITLE_SWAP,
                    &error,
                    ui::NotificationType::Error,
                    conn_state,
                    &ui_sender,
                );
                return;
            }
        };

        out_amount.insert(change.clone(), change_amount.to_bitcoin());
        out_asset.insert(change.clone(), sell_asset.clone());
    }

    let raw_tx_request = rpc::create_raw_tx(&inputs, &out_amount, 0, false, &out_asset);
    let raw_tx_res = rpc::make_rpc_call::<String>(&http_client, &rpc_server, &raw_tx_request);
    let raw_tx = match raw_tx_res {
        Ok(res) => res,
        Err(e) => {
            let error = e.to_string();
            ui::show_notification(
                ui::TITLE_SWAP,
                &error,
                ui::NotificationType::Error,
                conn_state,
                &ui_sender,
            );
            return;
        }
    };

    let conv_psbt_tx_res =
        rpc::make_rpc_call::<String>(&http_client, &rpc_server, &rpc::convert_to_psbt(&raw_tx));
    let conv_psbt_tx = match conv_psbt_tx_res {
        Ok(res) => res,
        Err(e) => {
            let error = e.to_string();
            ui::show_notification(
                ui::TITLE_SWAP,
                &error,
                ui::NotificationType::Error,
                conn_state,
                &ui_sender,
            );
            return;
        }
    };

    let psbt_tx_res = rpc::make_rpc_call::<rpc::PsbtTx>(
        &http_client,
        &rpc_server,
        &rpc::fill_psbt_data(&conv_psbt_tx),
    );
    let psbt_tx = match psbt_tx_res {
        Ok(res) => res.psbt,
        Err(e) => {
            let error = e.to_string();
            ui::show_notification(
                ui::TITLE_SWAP,
                &error,
                ui::NotificationType::Error,
                conn_state,
                &ui_sender,
            );
            return;
        }
    };

    send_request(
        &conn,
        Request::Swap(SwapRequest {
            order_id: state.rfq_offer.swap.order_id.clone(),
            action: SwapAction::Psbt(psbt_tx),
        }),
    );
}

fn sign_psbt(
    state: &ui::SwapState,
    conn_state: &mut ui::ConnectionState,
    http_client: &reqwest::blocking::Client,
    rpc_server: &rpc::RpcServer,
    conn: &ws::Sender,
    ui_sender: &Sender<ui::Update>,
) {
    if !conn_state.server_connected {
        ui::show_notification(
            ui::TITLE_SERVER_CONN,
            ui::MSG_NOT_CONNECTED,
            ui::NotificationType::Error,
            conn_state,
            &ui_sender,
        );
        return;
    }

    let signed_tx_res = rpc::make_rpc_call::<rpc::PsbtTx>(
        &http_client,
        &rpc_server,
        &rpc::sign_psbt(&state.psb_to_sign),
    );
    let signed_tx = match signed_tx_res {
        Ok(res) => res.psbt,
        Err(e) => {
            let error = e.to_string();
            ui::show_notification(
                ui::TITLE_SWAP,
                &error,
                ui::NotificationType::Error,
                conn_state,
                &ui_sender,
            );
            return;
        }
    };

    send_request(
        &conn,
        Request::Swap(SwapRequest {
            order_id: state.rfq_offer.swap.order_id.clone(),
            action: SwapAction::Sign(signed_tx),
        }),
    );
}

fn cleanup_swap_state(state: &mut ui::SwapState) {
    state.rfq_offer = Offer {
        swap: Swap {
            order_id: OrderId("".into()),
            sell_asset: "".into(),
            sell_amount: 0,
            buy_asset: "".into(),
            buy_amount: 0,
        },
        created_at: 0,
        expires_at: 0,
    };
    state.psb_to_sign = "".into();
    state.own_outputs.clear();
    state.contra_outputs.clear();
    state.rfq_offer.created_at = 0;
    state.rfq_offer.expires_at = 0;
    state.canceled_by_me = false;
    state.stage_accepted_by_me = false;
    state.show_password_prompt = false;
}

fn process_swap_update(
    state: &mut ui::SwapState,
    order_id: OrderId,
    msg: SwapState,
    conn_state: &mut ui::ConnectionState,
    http_client: &reqwest::blocking::Client,
    rpc_server: &rpc::RpcServer,
    conn: &ws::Sender,
    db: &db::Db,
    hist: &mut worker::DBData,
    ui_sender: &Sender<ui::Update>,
    is_dealer: bool,
) {
    match msg {
        SwapState::OfferSent(offer) => {
            info!("offer sent {}", &order_id);
            state.status = ui::SwapStatus::OfferSent;
            state.rfq_offer = offer.clone();
        }
        SwapState::OfferRecv(offer) => {
            info!("offer recv {}", &order_id);
            state.status = ui::SwapStatus::OfferRecv;
            state.rfq_offer = offer.clone();
            send_request(
                &conn,
                Request::Swap(SwapRequest {
                    order_id: state.rfq_offer.swap.order_id.clone(),
                    action: SwapAction::Accept,
                }),
            );
        }
        SwapState::WaitTxInfo => {
            info!("sending tx info for {}", &order_id);
            state.status = ui::SwapStatus::WaitTxInfo;
            state.stage_accepted_by_me = true;
            send_own_txinfo(
                &state,
                conn_state,
                &http_client,
                &rpc_server,
                &conn,
                &ui_sender,
            );
        }
        SwapState::WaitPsbt(outputs) => {
            let swap_outputs = outputs.own;
            let swap_outputs_contra = outputs.peer;
            state.status = ui::SwapStatus::WaitPsbt;
            state.own_outputs = swap_outputs.clone();
            state.contra_outputs = swap_outputs_contra.clone();
            state.stage_accepted_by_me = false;

            if is_dealer {
                accept_swap(
                    state,
                    conn_state,
                    &http_client,
                    &rpc_server,
                    &conn,
                    &db,
                    hist,
                    &ui_sender,
                );
            }
        }
        SwapState::WaitSign(psbt) => {
            state.status = ui::SwapStatus::WaitSign;
            state.psb_to_sign = psbt;
            if state.encryption {
                state.stage_accepted_by_me = false;
                state.show_password_prompt = true;
            } else {
                state.stage_accepted_by_me = true;
                sign_psbt(
                    &state,
                    conn_state,
                    &http_client,
                    &rpc_server,
                    &conn,
                    &ui_sender,
                );
            }
        }
        SwapState::Failed(e) => {
            error!("swap {} failed: {:?}", &order_id, e);
            let mut msg_type = ui::NotificationType::Error;
            let ui_message = match state.status {
                ui::SwapStatus::WaitTxInfo => ui::MSG_RESP_NO_UTXO,
                ui::SwapStatus::WaitPsbt => {
                    if state.stage_accepted_by_me {
                        ui::MSG_RESP_NO_PSBT
                    } else {
                        msg_type = ui::NotificationType::Info;
                        ui::MSG_OWN_NO_PSBT
                    }
                }
                ui::SwapStatus::WaitSign => {
                    if state.stage_accepted_by_me {
                        ui::MSG_RESP_NO_SIGN
                    } else {
                        msg_type = ui::NotificationType::Info;
                        ui::MSG_OWN_NO_SIGN
                    }
                }
                _ => ui::MSG_RFQ_CANCELLED,
            };

            if !state.canceled_by_me {
                ui::show_notification(ui::TITLE_SWAP, ui_message, msg_type, conn_state, &ui_sender);
            }

            state.status = ui::SwapStatus::Failed;
            cleanup_swap_state(state);
        }
        SwapState::Done(tx_id) => {
            info!("swap {} succeed, txid: {}", &order_id, &tx_id);
            state.status = ui::SwapStatus::Done;
            state.tx_id = tx_id;
            cleanup_swap_state(state);
            update_wallet_balances(state, &http_client, &rpc_server, &ui_sender, conn_state);
        }
    }
    ui::send_swap_update(&state, &ui_sender);
}

fn process_swap_disconnected(state: &mut ui::SwapState, ui_sender: &Sender<ui::Update>) {
    state.status = ui::SwapStatus::Failed;
    ui::send_swap_update(&state, &ui_sender);
}

pub fn start_processing(
    sender: Sender<Action>,
    receiver: Receiver<Action>,
    ui_sender: Sender<ui::Update>,
    mut params: StartParams,
) {
    let (conn, srv_rx) = ws::start(params.host.clone(), params.port, params.use_tls);
    let sender_copy = sender.clone();
    std::thread::spawn(move || {
        while let Ok(response) = srv_rx.recv() {
            sender_copy.send(Action::ServerResponse(response)).unwrap();
        }
    });

    let mut peg_state = ui::PegState {
        pegin: true,
        peg_addr: "".into(),
        status: ui::Status::Idle,
        server_status: None,
        min_pegin_amount: None,
        min_pegout_amount: None,
        server_fee_percent_peg_in: None,
        server_fee_percent_peg_out: None,
    };
    ui::send_peg_update(&peg_state, &ui_sender);

    let mut conn_state = ui::ConnectionState {
        server_connected: false,
        rpc_last_call_success: false,
        rpc_last_error_code: 0,
    };

    let db = match db::Db::new(&params.db_path) {
        Ok(v) => v,
        Err(e) => {
            ui::show_notification(
                ui::TITLE_DATABASE,
                &format!("opening db failed: {}", e),
                ui::NotificationType::Error,
                &conn_state,
                &ui_sender,
            );
            // Use in-memory sqlite db as fallback
            db::Db::new(":memory:").unwrap()
        }
    };

    let rpc_http_client = reqwest::blocking::Client::builder()
        .timeout(std::time::Duration::from_secs(10))
        .build()
        .expect("http client construction failed");

    let mut hist = DBData::default();
    hist.wallets = db.load_wallets();

    let mut swaps_state = worker::init_swap_state();

    check_rpc_init(
        &mut swaps_state,
        &rpc_http_client,
        &mut params.elements,
        &ui_sender,
        &mut conn_state,
        &db,
        &mut hist,
        params.is_dealer,
    );

    let balance_updater = sender.clone();
    std::thread::spawn(move || loop {
        balance_updater.send(Action::UpdateBalanceTicker).unwrap();
        std::thread::sleep(std::time::Duration::from_secs(5));
    });

    let server_checker = sender.clone();
    std::thread::spawn(move || {
        std::thread::sleep(std::time::Duration::from_secs(5));
        server_checker.send(Action::CheckServerConnection).unwrap();
    });

    let mut peg_addr = None;

    while let Ok(a) = receiver.recv() {
        debug!("new request: {:?}", &a);
        match a {
            Action::PegToggle => {
                if peg_state.status != ui::Status::Idle {
                    error!("unexpected peg toggle call");
                    continue;
                }
                peg_state.pegin = !peg_state.pegin;
                ui::send_peg_update(&peg_state, &ui_sender);
            }

            Action::StartPeg(addr) => {
                if peg_state.status != ui::Status::Idle {
                    error!("unexpected start peg call");
                    continue;
                }
                if !conn_state.server_connected {
                    ui::show_notification(
                        ui::TITLE_SERVER_CONN,
                        ui::MSG_NOT_CONNECTED,
                        ui::NotificationType::Error,
                        &conn_state,
                        &ui_sender,
                    );
                    continue;
                }
                peg_state.status = ui::Status::Waiting;
                peg_addr = Some(addr.clone());
                ui::send_peg_update(&peg_state, &ui_sender);
                if peg_state.pegin {
                    let payload = Request::PegIn(PegInRequest {
                        elements_addr: addr.clone(),
                    });
                    send_request(&conn, payload);
                } else {
                    let payload = Request::PegOut(PegOutRequest {
                        mainchain_addr: addr.clone(),
                    });
                    send_request(&conn, payload);
                }
            }

            Action::PegBack => {
                if peg_state.status != ui::Status::Active {
                    error!("unexpected peg back call");
                    continue;
                }
                peg_state.status = ui::Status::Idle;
                peg_state.peg_addr = String::new();
                ui::send_peg_update(&peg_state, &ui_sender);
            }

            Action::TryAndApply(rpc) => {
                let mut new_rpc = rpc.clone();
                try_new_rpc(
                    &mut new_rpc,
                    &mut swaps_state,
                    &rpc_http_client,
                    &mut params.elements,
                    &ui_sender,
                    &mut conn_state,
                    &db,
                    &mut hist,
                );
            }

            Action::ApplyConfig(index) => {
                rpc_apply(
                    index,
                    &mut swaps_state,
                    &rpc_http_client,
                    &mut params.elements,
                    &ui_sender,
                    &mut conn_state,
                    &db,
                    &mut hist,
                );
            }

            Action::RemoveConfig(index) => {
                rpc_remove(
                    index,
                    &mut swaps_state,
                    &rpc_http_client,
                    &mut params.elements,
                    &ui_sender,
                    &mut conn_state,
                    &db,
                    &mut hist,
                );
            }

            Action::WalletPassword(pass) => {
                // Stores the wallet decryption key in memory for 120 seconds.
                let is_decrypted = rpc::make_rpc_call_status(
                    &rpc_http_client,
                    &params.elements,
                    &rpc::set_wallet_passphrase(&pass, 120),
                ) == reqwest::StatusCode::OK;
                if is_decrypted {
                    swaps_state.show_password_prompt = false;
                    swaps_state.stage_accepted_by_me = true;
                    ui::send_swap_update(&swaps_state, &ui_sender);
                    sign_psbt(
                        &swaps_state,
                        &mut conn_state,
                        &rpc_http_client,
                        &params.elements,
                        &conn,
                        &ui_sender,
                    );
                } else {
                    ui::show_notification(
                        ui::TITLE_SWAP,
                        ui::MSG_INVALID_PSWD,
                        ui::NotificationType::Error,
                        &conn_state,
                        &ui_sender,
                    );
                }
            }

            Action::CancelPassword => {
                swaps_state.show_password_prompt = false;
                ui::send_swap_update(&swaps_state, &ui_sender);
                if !conn_state.server_connected {
                    ui::show_notification(
                        ui::TITLE_SERVER_CONN,
                        ui::MSG_NOT_CONNECTED,
                        ui::NotificationType::Error,
                        &conn_state,
                        &ui_sender,
                    );
                    continue;
                }
                send_request(
                    &conn,
                    Request::Swap(SwapRequest {
                        order_id: swaps_state.rfq_offer.swap.order_id.clone(),
                        action: SwapAction::Cancel,
                    }),
                );
            }

            Action::MatchRfq(deliver_asset, deliver_amount, receive_asset) => {
                if !conn_state.server_connected {
                    ui::show_notification(
                        ui::TITLE_SERVER_CONN,
                        ui::MSG_NOT_CONNECTED,
                        ui::NotificationType::Error,
                        &conn_state,
                        &ui_sender,
                    );
                    continue;
                }

                send_request(
                    &conn,
                    Request::MatchRfq(MatchRfqRequest {
                        rfq: MatchRfq {
                            sell_asset: deliver_asset,
                            sell_amount: deliver_amount,
                            buy_asset: receive_asset,
                        },
                    }),
                );
            }

            Action::MatchQuote(order_id, deliver_amount) => {
                if !conn_state.server_connected {
                    ui::show_notification(
                        ui::TITLE_SERVER_CONN,
                        ui::MSG_NOT_CONNECTED,
                        ui::NotificationType::Error,
                        &conn_state,
                        &ui_sender,
                    );
                    continue;
                }

                send_request(
                    &conn,
                    Request::MatchQuote(MatchQuoteRequest {
                        quote: MatchQuote {
                            order_id: OrderId(order_id.clone()),
                            bid_amount: deliver_amount,
                        },
                    }),
                );
            }

            Action::MatchCancel(order_id) => {
                if !conn_state.server_connected {
                    ui::show_notification(
                        ui::TITLE_SERVER_CONN,
                        ui::MSG_NOT_CONNECTED,
                        ui::NotificationType::Error,
                        &conn_state,
                        &ui_sender,
                    );
                    continue;
                }

                send_request(
                    &conn,
                    Request::MatchRfqCancel(MatchCancelRequest {
                        order_id: OrderId(order_id.clone()),
                    }),
                );
            }

            Action::SwapCancel => {
                if !conn_state.server_connected {
                    ui::show_notification(
                        ui::TITLE_SERVER_CONN,
                        ui::MSG_NOT_CONNECTED,
                        ui::NotificationType::Error,
                        &conn_state,
                        &ui_sender,
                    );
                    continue;
                }
                swaps_state.canceled_by_me = true;
                send_request(
                    &conn,
                    Request::Swap(SwapRequest {
                        order_id: swaps_state.rfq_offer.swap.order_id.clone(),
                        action: SwapAction::Cancel,
                    }),
                );
            }

            Action::SwapAccept => {
                if !conn_state.server_connected {
                    ui::show_notification(
                        ui::TITLE_SERVER_CONN,
                        ui::MSG_NOT_CONNECTED,
                        ui::NotificationType::Error,
                        &conn_state,
                        &ui_sender,
                    );
                    continue;
                }

                swaps_state.stage_accepted_by_me = true;
                accept_swap(
                    &mut swaps_state,
                    &mut conn_state,
                    &rpc_http_client,
                    &params.elements,
                    &conn,
                    &db,
                    &mut hist,
                    &ui_sender,
                );
            }

            Action::UpdateBalanceTicker => {
                update_wallet_balances(
                    &mut swaps_state,
                    &rpc_http_client,
                    &params.elements,
                    &ui_sender,
                    &mut conn_state,
                );
            }
            Action::CheckServerConnection => {
                if !conn_state.server_connected {
                    ui::show_notification(
                        ui::TITLE_SERVER_CONN,
                        ui::MSG_NOT_CONNECTED,
                        ui::NotificationType::Error,
                        &conn_state,
                        &ui_sender,
                    );
                }
            }

            Action::ServerResponse(response) => match response {
                ws::WrappedResponse::Connected => {
                    info!("connected to server");
                    if params.is_dealer {
                        send_request(
                            &conn,
                            Request::LoginDealer(LoginDealerRequest {
                                api_key: DEALER_API_KEY.into(),
                            }),
                        );
                    } else {
                        let cookie = db.get_setting(&SETTING_COOKIE);
                        let pkg_version = env!("CARGO_PKG_VERSION");
                        let git_hash = env!("GIT_HASH").to_owned();
                        let version = format!("{}-{}", &pkg_version, &git_hash);
                        send_request(
                            &conn,
                            Request::LoginClient(LoginClientRequest {
                                api_key: CLIENT_API_KEY.into(),
                                cookie,
                                user_agent: Some(USER_AGENT.to_owned()),
                                version: Some(version),
                            }),
                        );
                    }

                    conn_state.server_connected = true;
                    request_all_orders_history(&hist, &conn);
                    send_request(&conn, Request::ServerStatus);
                    ui::send_peg_update(&peg_state, &ui_sender);
                    ui::show_notification(
                        ui::TITLE_SERVER_CONN,
                        "",
                        ui::NotificationType::Info,
                        &conn_state,
                        &ui_sender,
                    );
                }
                ws::WrappedResponse::Disconnected => {
                    error!("disconnected from server");
                    conn_state.server_connected = false;
                    ui::show_notification(
                        ui::TITLE_SERVER_CONN,
                        ui::MSG_CONN_LOST,
                        ui::NotificationType::Error,
                        &conn_state,
                        &ui_sender,
                    );
                    peg_state.min_pegin_amount = None;
                    peg_state.min_pegout_amount = None;
                    peg_state.server_fee_percent_peg_in = None;
                    peg_state.server_fee_percent_peg_out = None;
                    ui::send_peg_update(&peg_state, &ui_sender);
                    process_swap_disconnected(&mut swaps_state, &ui_sender);
                }
                ws::WrappedResponse::Response(resp) => match resp {
                    ResponseMessage::Response(_req_id, resp) => match resp {
                        Ok(Response::PegIn(resp)) => {
                            peg_state.peg_addr = resp.mainchain_addr.clone();
                            peg_state.status = ui::Status::Active;
                            ui::send_peg_update(&peg_state, &ui_sender);

                            let order = db.create_order(models::NewOrder {
                                order_id: resp.order_id.clone().0,
                                pegin: true,
                                own_addr: peg_addr.clone().expect("peg_addr must exists"),
                                peg_addr: resp.mainchain_addr.clone(),
                                created_at: db::now(),
                            });

                            add_history_peg_order(
                                &mut hist,
                                order,
                                &conn,
                                conn_state.server_connected,
                                &ui_sender,
                            );
                        }
                        Ok(Response::PegOut(resp)) => {
                            peg_state.peg_addr = resp.elements_addr.clone();
                            peg_state.status = ui::Status::Active;
                            ui::send_peg_update(&peg_state, &ui_sender);

                            let order = db.create_order(models::NewOrder {
                                order_id: resp.order_id.clone().0,
                                pegin: false,
                                own_addr: peg_addr.clone().expect("peg_addr must exists"),
                                peg_addr: resp.elements_addr.clone(),
                                created_at: db::now(),
                            });

                            add_history_peg_order(
                                &mut hist,
                                order,
                                &conn,
                                conn_state.server_connected,
                                &ui_sender,
                            );
                        }
                        Ok(Response::PegInStatus(s)) => {
                            process_status_update(&mut hist, s, &ui_sender);
                        }
                        Ok(Response::PegOutStatus(s)) => {
                            process_status_update(&mut hist, s, &ui_sender);
                        }
                        Ok(Response::ServerStatus(s)) => {
                            process_server_status_update(&mut peg_state, &s, &ui_sender);
                        }
                        Ok(Response::Assets(assets)) => {
                            ui::send_assets_update(&assets, &ui_sender);
                        }
                        Ok(Response::Swap(_)) => {}
                        Ok(Response::MatchRfq(msg)) => {
                            let upd = MatchRfqUpdate {
                                order_id: msg.order_id,
                                status: MatchRfqStatus::Pending,
                                buy_amount: None,
                                created_at: msg.created_at,
                                expires_at: msg.expires_at,
                            };
                            ui::send_rfq_update_client(&upd, &ui_sender);
                        }
                        Ok(Response::MatchRfqCancel(_)) => {
                            let upd = MatchRfqUpdate {
                                order_id: OrderId("".into()),
                                status: MatchRfqStatus::Expired,
                                buy_amount: None,
                                created_at: 0,
                                expires_at: 0,
                            };
                            ui::send_rfq_update_client(&upd, &ui_sender);
                        }
                        Ok(Response::MatchQuote(_)) => {}
                        Ok(Response::MatchQuoteCancel(_)) => {}
                        Ok(Response::LoginClient(response)) => {
                            db.update_setting(&SETTING_COOKIE, &response.cookie);

                            send_request(&conn, Request::Assets);
                            for order in db.load_orders() {
                                add_history_peg_order(
                                    &mut hist,
                                    order,
                                    &conn,
                                    conn_state.server_connected,
                                    &ui_sender,
                                );
                            }
                            for swap_order in db.load_swaps() {
                                add_history_swap_order_id(
                                    &mut hist,
                                    swap_order,
                                    &conn,
                                    conn_state.server_connected,
                                );
                            }
                        }
                        Ok(Response::LoginDealer(_)) => {
                            send_request(&conn, Request::Assets);
                            for order in db.load_orders() {
                                add_history_peg_order(
                                    &mut hist,
                                    order,
                                    &conn,
                                    conn_state.server_connected,
                                    &ui_sender,
                                );
                            }
                            for swap_order in db.load_swaps() {
                                add_history_swap_order_id(
                                    &mut hist,
                                    swap_order,
                                    &conn,
                                    conn_state.server_connected,
                                );
                            }
                        }
                        Ok(Response::SwapStatus(msg)) => {
                            add_history_swap_update(&mut hist, msg, &ui_sender);
                        }
                        Err(e) => {
                            if peg_state.status == ui::Status::Waiting {
                                peg_state.status = ui::Status::Idle;
                                ui::send_peg_update(&peg_state, &ui_sender);
                            }

                            ui::show_notification(
                                ui::TITLE_SERVER_RESP,
                                &e.message,
                                ui::NotificationType::Error,
                                &conn_state,
                                &ui_sender,
                            );
                        }
                    },
                    ResponseMessage::Notification(notification) => match notification {
                        Notification::PegInStatus(s) => {
                            process_status_update(&mut hist, s, &ui_sender);
                        }
                        Notification::PegOutStatus(s) => {
                            process_status_update(&mut hist, s, &ui_sender);
                        }
                        Notification::ServerStatus(s) => {
                            process_server_status_update(&mut peg_state, &s, &ui_sender);
                        }
                        Notification::Swap(msg) => {
                            process_swap_update(
                                &mut swaps_state,
                                msg.order_id,
                                msg.state,
                                &mut conn_state,
                                &rpc_http_client,
                                &params.elements,
                                &conn,
                                &db,
                                &mut hist,
                                &ui_sender,
                                params.is_dealer,
                            );
                        }
                        Notification::RfqCreated(msg) => {
                            ui_sender.send(ui::Update::RfqCreated(msg)).unwrap();
                        }
                        Notification::RfqRemoved(msg) => {
                            ui_sender.send(ui::Update::RfqRemoved(msg)).unwrap();
                        }
                        Notification::SwapStatus(msg) => {
                            add_history_swap_update(&mut hist, msg, &ui_sender);
                        }
                        Notification::MatchRfq(msg) => {
                            ui::send_rfq_update_client(&msg, &ui_sender);
                            if msg.status == MatchRfqStatus::Expired {
                                ui::show_notification(
                                    ui::TITLE_SWAP,
                                    ui::MSG_NO_QUOTES,
                                    ui::NotificationType::Info,
                                    &conn_state,
                                    &ui_sender,
                                );
                            }
                        }
                    },
                },
            },
        }
    }
}
