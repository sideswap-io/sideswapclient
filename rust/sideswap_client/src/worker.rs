use super::*;
use rpc::RpcServer;
use sideswap_api::*;
use sideswap_common::*;
use std::sync::mpsc::{Receiver, Sender};
use types::Amount;
use types::Env;

const CLIENT_API_KEY: &str = "f8b7a12ee96aa68ee2b12ebfc51d804a4a404c9732652c298d24099a3d922a84";

const USER_AGENT: &str = "SideSwapGUI";

const SETTING_COOKIE: &str = "cookie";

type BalanceResult = Result<rpc::GetWalletInfo, reqwest::StatusCode>;

#[derive(Debug)]
pub enum Action {
    ServerResponse(ws::WrappedResponse),
    UpdateBalanceTicker,
    UpdateBalanceResult(BalanceResult),
    CheckServerConnection,

    PegToggle,
    StartPeg(String),
    PegBack,
    WalletPassword(String),
    CancelPassword,

    MatchRfq(String, i64, String),
    MatchCancel,

    SwapCancel,
    SwapAccept,
    TryAndApply(RpcServer),
    ApplyConfig(i32),
    RemoveConfig(i32),
}

enum BalanceUpdate {
    Update(RpcServer),
}

pub struct ActiveRfq {
    rfq: MatchRfq,
    inputs: Vec<rpc::RawTxInputs>,
    total_utxos_amount: Amount,
}

pub struct InternalState {
    active_rfq: Option<ActiveRfq>,
    tx_info: Option<Swap>,
    psbt: Option<String>,
    assets: Vec<Asset>,
    active_order_id: Option<OrderId>,
}

fn is_bitcoin(asset_id: &str, assets: &Assets) -> bool {
    assets
        .iter()
        .find(|reg_asset| reg_asset.asset_id == asset_id)
        .expect("asset must exists")
        .ticker
        == TICKER_BITCOIN
}

fn rfq_price(state: &InternalState, rfq_update: &MatchRfqUpdate) -> Option<f64> {
    rfq_update.recv_amount.map(|bid_amount| {
        let active_rfq = &state
            .active_rfq
            .as_ref()
            .expect("active_rfq must be set")
            .rfq;
        if is_bitcoin(&active_rfq.send_asset, &state.assets) {
            bid_amount as f64 / active_rfq.send_amount as f64
        } else {
            active_rfq.send_amount as f64 / bid_amount as f64
        }
    })
}

#[derive(Default)]
pub struct DbData {
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
                send_asset: "".into(),
                send_amount: 0,
                recv_asset: "".into(),
                recv_amount: 0,
                network_fee: 0,
                server_fee: 0,
            },
            created_at: 0,
            expires_at: 0,
            accept_required: true,
        },
        tx_id: "".into(),
        asset_labels: rpc::AssetLabels::new(),
        canceled_by_me: false,
        network_fee: 0,
        server_fee: 0,
        swap_in_progress: false,
        unconfirmed_balances: "".into(),
        price: None,
        deliver_amount: None,
    }
}

fn fill_last_active(rpc_server: &mut rpc::RpcServer, hist: &DbData) {
    for wallet in hist.wallets.iter() {
        if wallet.is_active {
            rpc_server.host = wallet.host.clone();
            rpc_server.port = wallet.port.parse::<u16>().unwrap_or_default();
            rpc_server.login = wallet.user_name.clone();
            rpc_server.password = wallet.user_pass.clone();
            break;
        }
    }
}

fn is_current_node_default(hist: &DbData) -> bool {
    let mut current = RpcServer {
        host: String::new(),
        port: 0,
        login: String::new(),
        password: String::new(),
    };

    fill_last_active(&mut current, &hist);

    rpc::is_default_rpc(&current)
}

fn update_wallet_data(
    state: &mut ui::SwapState,
    http_client: &reqwest::blocking::Client,
    rpc_server: &mut rpc::RpcServer,
    ui_sender: &Sender<ui::Update>,
    conn_state: &mut ui::ConnectionState,
    hist: &mut DbData,
) {
    if conn_state.rpc_last_call_success {
        state.encryption =
            rpc::make_rpc_call_status(&http_client, &rpc_server, &rpc::set_wallet_lock())
                == reqwest::StatusCode::OK;

        update_asset_labels(state, &http_client, &rpc_server);
        update_wallet_balances(state, &http_client, rpc_server, &ui_sender, conn_state);
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
    hist: &mut DbData,
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

fn try_to_reconnect_rpc(
    state: &mut ui::SwapState,
    http_client: &reqwest::blocking::Client,
    rpc_server: &mut rpc::RpcServer,
    ui_sender: &Sender<ui::Update>,
    conn_state: &mut ui::ConnectionState,
    db: &db::Db,
    hist: &mut DbData,
) -> bool {
    let mut new_config = true;
    if rpc_server.host.is_empty() {
        fill_last_active(rpc_server, hist);
        new_config = rpc_server.host.is_empty();
    }

    let is_default = rpc_server.host.is_empty() || rpc::is_default_rpc(rpc_server);

    conn_state.rpc_last_error_code =
        rpc::make_rpc_call_status(&http_client, &rpc_server, &rpc::ping()).as_u16();
    conn_state.rpc_last_call_success = conn_state.rpc_last_error_code == reqwest::StatusCode::OK;

    if conn_state.rpc_last_call_success && new_config {
        save_wallet(rpc_server, db, hist, is_default);
    }

    update_wallet_data(state, http_client, rpc_server, ui_sender, conn_state, hist);

    new_config
}

fn check_rpc_init(
    state: &mut ui::SwapState,
    http_client: &reqwest::blocking::Client,
    rpc_server: &mut rpc::RpcServer,
    ui_sender: &Sender<ui::Update>,
    conn_state: &mut ui::ConnectionState,
    db: &db::Db,
    hist: &mut DbData,
) {
    let new_config = try_to_reconnect_rpc(
        state,
        http_client,
        rpc_server,
        ui_sender,
        conn_state,
        db,
        hist,
    );

    let msg = (|| {
        if !conn_state.rpc_last_call_success && !new_config && !hist.wallets.is_empty() {
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
        ui::TITLE_NODE_OFFLINE,
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
    hist: &mut DbData,
) {
    let is_default = rpc::is_default_rpc(new_server);

    let try_code = rpc::make_rpc_call_status(&http_client, &new_server, &rpc::ping()).as_u16();

    let mut msg = "".into();

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

            msg = ui::MSG_NODE_RPC_CONNECTED;

            ui::WalletApplyStatus::Applied
        } else {
            ui::WalletApplyStatus::WalletExists
        }
    };

    ui::show_notification(
        ui::TITLE_NODE_ONLINE,
        msg,
        ui::NotificationType::Info,
        conn_state,
        &ui_sender,
    );

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
    hist: &mut DbData,
) {
    if index < 0 || index as usize >= hist.wallets.len() {
        return;
    }

    hist.wallets = db.mark_wallet_as_active(hist.wallets[index as usize].id);
    fill_last_active(rpc_server, hist);

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

    let title = if !conn_state.rpc_last_call_success {
        ui::TITLE_NODE_OFFLINE
    } else {
        ui::TITLE_NODE_ONLINE
    };

    ui::show_notification(title, msg, msg_type, conn_state, &ui_sender);
}

fn rpc_remove(
    index: i32,
    state: &mut ui::SwapState,
    http_client: &reqwest::blocking::Client,
    rpc_server: &mut rpc::RpcServer,
    ui_sender: &Sender<ui::Update>,
    conn_state: &mut ui::ConnectionState,
    db: &db::Db,
    hist: &mut DbData,
) {
    if index < 0 || index as usize >= hist.wallets.len() {
        return;
    }
    hist.wallets = db.remove_wallet(hist.wallets[index as usize].id);

    if !hist.wallets.is_empty() {
        fill_last_active(rpc_server, hist);

        conn_state.rpc_last_error_code =
            rpc::make_rpc_call_status(&http_client, &rpc_server, &rpc::ping()).as_u16();
        conn_state.rpc_last_call_success =
            conn_state.rpc_last_error_code == reqwest::StatusCode::OK;
    } else {
        conn_state.rpc_last_call_success = false;
    }

    update_wallet_data(state, http_client, rpc_server, ui_sender, conn_state, hist);

    ui::show_notification(
        ui::TITLE_NODE_OFFLINE,
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

fn get_wallet_balance(
    http_client: &reqwest::blocking::Client,
    rpc_server: &rpc::RpcServer,
) -> BalanceResult {
    rpc::make_rpc_call_silent::<rpc::GetWalletInfo>(
        &http_client,
        &rpc_server,
        &rpc::get_wallet_info(),
    )
    .map_err(|_e| rpc::make_rpc_call_status(&http_client, &rpc_server, &rpc::ping()))
}

fn update_wallet_balances(
    state: &mut ui::SwapState,
    http_client: &reqwest::blocking::Client,
    rpc_server: &mut rpc::RpcServer,
    ui_sender: &Sender<ui::Update>,
    conn_state: &mut ui::ConnectionState,
) {
    let balance = get_wallet_balance(&http_client, &rpc_server);
    update_wallet_balances_impl(state, ui_sender, conn_state, balance);
}

fn update_wallet_balances_impl(
    state: &mut ui::SwapState,
    ui_sender: &Sender<ui::Update>,
    conn_state: &mut ui::ConnectionState,
    wallet_balance: BalanceResult,
) {
    let bal = match wallet_balance {
        Ok(info) => {
            let mut balances = std::collections::BTreeMap::<String, i64>::new();
            for (label, amount) in &info.balance {
                let balance_code = match state.asset_labels.get(label) {
                    Some(code) => code,
                    None => label,
                };
                balances.insert(balance_code.clone(), Amount::from_rpc(&amount).to_sat());
            }
            serde_json::to_string(&balances).unwrap()
        }
        Err(status) => {
            if conn_state.rpc_last_call_success {
                conn_state.rpc_last_call_success = false;

                conn_state.rpc_last_error_code = status.as_u16();
                conn_state.rpc_last_call_success =
                    conn_state.rpc_last_error_code == reqwest::StatusCode::OK;

                if !conn_state.rpc_last_call_success {
                    let msg = if conn_state.rpc_last_error_code == 401 {
                        ui::MSG_NODE_RPC_NOT_CONNECTED_AUTH
                    } else {
                        ui::MSG_NODE_RPC_NOT_CONNECTED_NETWORK
                    };

                    ui::show_notification(
                        ui::TITLE_NODE_OFFLINE,
                        msg,
                        ui::NotificationType::Error,
                        conn_state,
                        &ui_sender,
                    );
                }
            }
            String::new()
        }
    };

    state.balances = if !state.unconfirmed_balances.is_empty() && bal == state.unconfirmed_balances
    {
        String::new()
    } else {
        state.unconfirmed_balances.clear();
        bal
    };
    ui::send_swap_update(&state, &ui_sender);
}

fn add_history_peg_order(
    hist: &mut DbData,
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
    hist: &mut DbData,
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
    hist: &mut DbData,
    order: SwapStatusResponse,
    ui_sender: &Sender<ui::Update>,
) {
    hist.swaps.insert(order.order_id.to_string(), order);
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

fn request_all_orders_history(hist: &DbData, conn: &ws::Sender) {
    for (_, order) in hist.peg_orders.iter() {
        request_order_history(order, conn);
    }
}

fn accept_swap(
    state: &InternalState,
    conn_state: &mut ui::ConnectionState,
    conn: &ws::Sender,
    db: &db::Db,
    hist: &mut worker::DbData,
) {
    let active_order_id = state
        .active_order_id
        .as_ref()
        .expect("active_order_id must be set");
    send_request(
        &conn,
        Request::Swap(SwapRequest {
            order_id: active_order_id.clone(),
            action: SwapAction::Accept,
        }),
    );

    let order = db.create_swap(models::NewSwap {
        order_id: active_order_id.clone().0,
    });
    add_history_swap_order_id(hist, order, &conn, conn_state.server_connected);
}

fn process_status_update(hist: &mut DbData, status: PegStatus, ui_sender: &Sender<ui::Update>) {
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

fn send_psbt(
    ui: &ui::SwapState,
    state: &InternalState,
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

    let sell_amount = Amount::from_sat(ui.rfq_offer.swap.send_amount);
    let sell_asset = &ui.rfq_offer.swap.send_asset;

    let mut out_amount = rpc::RawTxOutputsAmounts::new();
    let mut out_asset = rpc::RawTxOutputsAssets::new();

    let tx_info = state.tx_info.as_ref().expect("tx_info must exists");

    out_amount.insert(
        new_addr.clone(),
        Amount::from_sat(tx_info.recv_amount).to_rpc(),
    );
    out_asset.insert(new_addr, tx_info.recv_asset.clone());

    let active_rfq = state.active_rfq.as_ref().expect("active rfq must exists");
    let change_amount = active_rfq.total_utxos_amount - sell_amount;
    if change_amount.to_sat() < 0 {
        ui::show_notification(
            ui::TITLE_SWAP,
            ui::MSG_NO_UTXO_SELL,
            ui::NotificationType::Error,
            conn_state,
            &ui_sender,
        );
        return;
    }
    if change_amount.to_sat() > 0 {
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

        out_amount.insert(change.clone(), change_amount.to_rpc());
        out_asset.insert(change.clone(), sell_asset.clone());
    }

    let raw_tx_request = rpc::create_raw_tx(&active_rfq.inputs, &out_amount, 0, false, &out_asset);
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

    let active_order_id = state
        .active_order_id
        .as_ref()
        .expect("active_order_id must be set");
    send_request(
        &conn,
        Request::Swap(SwapRequest {
            order_id: active_order_id.clone(),
            action: SwapAction::Psbt(psbt_tx),
        }),
    );
}

fn sign_psbt(
    state: &InternalState,
    psbt: &str,
    ui: &mut ui::SwapState,
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

    let signed_tx_res =
        rpc::make_rpc_call::<rpc::PsbtTx>(&http_client, &rpc_server, &rpc::sign_psbt(&psbt));
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

    ui.unconfirmed_balances = ui.balances.clone();

    let active_order_id = state
        .active_order_id
        .as_ref()
        .expect("active_order_id must be set");
    send_request(
        &conn,
        Request::Swap(SwapRequest {
            order_id: active_order_id.clone(),
            action: SwapAction::Sign(signed_tx),
        }),
    );
}

fn cleanup_swap_state(state: &mut ui::SwapState) {
    state.rfq_offer = Offer {
        swap: Swap {
            send_asset: "".into(),
            send_amount: 0,
            recv_asset: "".into(),
            recv_amount: 0,
            server_fee: 0,
            network_fee: 0,
        },
        created_at: 0,
        expires_at: 0,
        accept_required: false,
    };
    state.rfq_offer.created_at = 0;
    state.rfq_offer.expires_at = 0;
    state.canceled_by_me = false;
    state.show_password_prompt = false;
}

fn process_swap_update(
    state: &mut InternalState,
    ui: &mut ui::SwapState,
    order_id: OrderId,
    msg: SwapState,
    conn_state: &mut ui::ConnectionState,
    http_client: &reqwest::blocking::Client,
    rpc_server: &mut rpc::RpcServer,
    conn: &ws::Sender,
    ui_sender: &Sender<ui::Update>,
) {
    match msg {
        SwapState::ReviewOffer(offer) => {
            info!("offer recv {}", &order_id);
            ui.status = ui::SwapStatus::ReviewOffer;
            ui.server_fee = offer.swap.server_fee;
            ui.network_fee = offer.swap.network_fee;
            ui.rfq_offer = offer.clone();
            ui.swap_in_progress = false;
            state.tx_info = Some(offer.swap);
        }
        SwapState::WaitPsbt => {
            ui.status = ui::SwapStatus::WaitPsbt;
            send_psbt(
                &ui,
                &state,
                conn_state,
                &http_client,
                &rpc_server,
                &conn,
                &ui_sender,
            );
        }
        SwapState::WaitSign(psbt) => {
            ui.status = ui::SwapStatus::WaitSign;
            if ui.encryption {
                state.psbt = Some(psbt);
                ui.show_password_prompt = true;
            } else {
                sign_psbt(
                    &state,
                    &psbt,
                    ui,
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
            let msg_type = ui::NotificationType::Error;
            let ui_message = match e {
                SwapError::Cancelled => ui::MSG_CANCELLED,
                SwapError::Timeout => ui::MSG_TIMEOUT,
                SwapError::ServerError => ui::MSG_SERVER_ERROR,
                SwapError::DealerError => ui::MSG_DEALER_ERROR,
                SwapError::ClientError => ui::MSG_CLIENT_ERROR,
            };
            if e != SwapError::Cancelled {
                ui::show_notification(ui::TITLE_SWAP, ui_message, msg_type, conn_state, &ui_sender);
            }
            ui.status = ui::SwapStatus::Failed;
            ui.swap_in_progress = false;
            cleanup_swap_state(ui);
            ui.unconfirmed_balances.clear();
        }
        SwapState::Done(tx_id) => {
            info!("swap {} succeed, txid: {}", &order_id, &tx_id);
            ui.status = ui::SwapStatus::Done;
            ui.tx_id = tx_id;
            ui.swap_in_progress = false;
            cleanup_swap_state(ui);
            update_wallet_balances(ui, &http_client, rpc_server, &ui_sender, conn_state);
        }
    }
    ui::send_swap_update(&ui, &ui_sender);
}

fn process_swap_disconnected(state: &mut ui::SwapState, ui_sender: &Sender<ui::Update>) {
    state.status = ui::SwapStatus::Failed;
    ui::send_swap_update(&state, &ui_sender);
}

pub fn start_processing(
    env: Env,
    sender: Sender<Action>,
    receiver: Receiver<Action>,
    ui_sender: Sender<ui::Update>,
    params: ffi::ffi::StartParams,
) {
    let env_data = types::env_data(env);
    let (conn, srv_rx) = ws::start(env_data.host.to_owned(), env_data.port, env_data.use_tls);
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

    let db_path = std::path::Path::new(&params.data_path)
        .join(env_data.db_name)
        .to_str()
        .expect("invalid db_path")
        .to_owned();
    let db = match db::Db::new(&db_path) {
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
        .timeout(std::time::Duration::from_secs(5))
        .build()
        .expect("http client construction failed");

    let mut hist = DbData::default();
    hist.wallets = db.load_wallets();

    let mut swaps_state = worker::init_swap_state();

    let mut active_rpc = RpcServer {
        host: "".to_owned(),
        port: 0,
        login: "".to_owned(),
        password: "".to_owned(),
    };
    check_rpc_init(
        &mut swaps_state,
        &rpc_http_client,
        &mut active_rpc,
        &ui_sender,
        &mut conn_state,
        &db,
        &mut hist,
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

    let mut state = InternalState {
        active_rfq: None,
        tx_info: None,
        psbt: None,
        assets: Vec::new(),
        active_order_id: None,
    };

    let rpc_http_client_copy = rpc_http_client.clone();
    let (bal_tx, bal_rx) = std::sync::mpsc::channel::<BalanceUpdate>();
    let sender_copy = sender.clone();
    std::thread::spawn(move || {
        for msg in bal_rx {
            match msg {
                BalanceUpdate::Update(addr) => {
                    let balance = get_wallet_balance(&rpc_http_client_copy, &addr);
                    sender_copy
                        .send(Action::UpdateBalanceResult(balance))
                        .unwrap();
                }
            }
        }
    });

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
                    &mut active_rpc,
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
                    &mut active_rpc,
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
                    &mut active_rpc,
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
                    &mut active_rpc,
                    &rpc::set_wallet_passphrase(&pass, 120),
                ) == reqwest::StatusCode::OK;
                if is_decrypted {
                    swaps_state.show_password_prompt = false;
                    ui::send_swap_update(&swaps_state, &ui_sender);
                    let psbt = state.psbt.as_ref().expect("psbt must exists");
                    sign_psbt(
                        &state,
                        &psbt,
                        &mut swaps_state,
                        &mut conn_state,
                        &rpc_http_client,
                        &active_rpc,
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
                let active_order_id = state
                    .active_order_id
                    .as_ref()
                    .expect("active_order_id must be set");
                send_request(
                    &conn,
                    Request::Swap(SwapRequest {
                        order_id: active_order_id.clone(),
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

                let sell_amount = Amount::from_sat(deliver_amount);
                let sell_asset = &deliver_asset;

                let list_unspend_req =
                    rpc::list_unspent(&sell_amount.to_bitcoin().to_string(), &sell_asset);
                let list_unspend_res = rpc::make_rpc_call::<Vec<rpc::RawUtxo>>(
                    &rpc_http_client,
                    &active_rpc,
                    &list_unspend_req,
                );
                let utxos = match list_unspend_res {
                    Ok(res) => res,
                    Err(e) => {
                        ui::show_notification(
                            ui::TITLE_SWAP,
                            &e.to_string(),
                            ui::NotificationType::Error,
                            &conn_state,
                            &ui_sender,
                        );
                        return;
                    }
                };

                let mut total_utxos_amount = Amount::from_bitcoin(0.0);
                let mut inputs = Vec::new();
                for utxo in utxos {
                    total_utxos_amount = total_utxos_amount + Amount::from_rpc(&utxo.amount);
                    inputs.push(rpc::RawTxInputs {
                        txid: utxo.txid,
                        vout: utxo.vout,
                    })
                }
                let with_change = total_utxos_amount != sell_amount;
                let rfq = MatchRfq {
                    send_asset: deliver_asset,
                    send_amount: deliver_amount,
                    recv_asset: receive_asset,
                    utxo_count: inputs.len() as i32,
                    with_change,
                };

                send_request(
                    &conn,
                    Request::MatchRfq(MatchRfqRequest { rfq: rfq.clone() }),
                );

                state.active_rfq = Some(ActiveRfq {
                    inputs,
                    total_utxos_amount,
                    rfq,
                });
            }

            Action::MatchCancel => {
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

                let active_order_id = state
                    .active_order_id
                    .as_ref()
                    .expect("active_order_id must be set");
                send_request(
                    &conn,
                    Request::MatchRfqCancel(MatchCancelRequest {
                        order_id: active_order_id.clone(),
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

                let active_order_id = state
                    .active_order_id
                    .as_ref()
                    .expect("active_order_id must be set");
                send_request(
                    &conn,
                    Request::Swap(SwapRequest {
                        order_id: active_order_id.clone(),
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

                accept_swap(&state, &mut conn_state, &conn, &db, &mut hist);
                swaps_state.swap_in_progress = true;
            }

            Action::UpdateBalanceTicker => {
                bal_tx
                    .send(BalanceUpdate::Update(active_rpc.clone()))
                    .unwrap();
            }
            Action::UpdateBalanceResult(result) => {
                update_wallet_balances_impl(&mut swaps_state, &ui_sender, &mut conn_state, result);

                if !conn_state.rpc_last_call_success
                    && !hist.wallets.is_empty()
                    && is_current_node_default(&hist)
                {
                    active_rpc.host.clear();
                    try_to_reconnect_rpc(
                        &mut swaps_state,
                        &rpc_http_client,
                        &mut active_rpc,
                        &ui_sender,
                        &mut conn_state,
                        &db,
                        &mut hist,
                    );

                    if conn_state.rpc_last_call_success {
                        ui::show_notification(
                            ui::TITLE_NODE_ONLINE,
                            ui::MSG_NODE_RPC_CONNECTED,
                            ui::NotificationType::Info,
                            &conn_state,
                            &ui_sender,
                        );
                    }
                }
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
                    let cookie = db.get_setting(&SETTING_COOKIE);
                    let pkg_version = env!("CARGO_PKG_VERSION");
                    let git_hash = env!("GIT_HASH").to_owned();
                    let version = format!("{}-{}", &pkg_version, &git_hash);
                    send_request(
                        &conn,
                        Request::LoginClient(LoginClientRequest {
                            api_key: CLIENT_API_KEY.into(),
                            cookie,
                            user_agent: USER_AGENT.to_owned(),
                            version: version,
                        }),
                    );

                    conn_state.server_connected = true;
                    request_all_orders_history(&hist, &conn);
                    send_request(&conn, Request::ServerStatus(None));
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
                        Ok(Response::Assets(assets_resp)) => {
                            types::check_assets(env, &assets_resp.assets);
                            ui::send_assets_update(&assets_resp, &ui_sender);
                            state.assets = assets_resp.assets;
                        }
                        Ok(Response::Swap(_)) => {}
                        Ok(Response::MatchRfq(msg)) => {
                            state.active_order_id = Some(msg.order_id.clone());
                            let upd = MatchRfqUpdate {
                                order_id: msg.order_id,
                                status: MatchRfqStatus::Pending,
                                recv_amount: None,
                                created_at: msg.created_at,
                                expires_at: msg.expires_at,
                            };
                            ui::send_rfq_update_client(&upd, &ui_sender);
                        }
                        Ok(Response::MatchRfqCancel(_)) => {
                            let upd = MatchRfqUpdate {
                                order_id: OrderId("".into()),
                                status: MatchRfqStatus::Expired,
                                recv_amount: None,
                                created_at: 0,
                                expires_at: 0,
                            };
                            ui::send_rfq_update_client(&upd, &ui_sender);
                        }
                        Ok(Response::MatchQuote(_)) => {}
                        Ok(Response::MatchQuoteCancel(_)) => {}
                        Ok(Response::LoginClient(response)) => {
                            db.update_setting(&SETTING_COOKIE, &response.cookie);

                            send_request(&conn, Request::Assets(None));
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
                            send_request(&conn, Request::Assets(None));
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
                                &mut state,
                                &mut swaps_state,
                                msg.order_id,
                                msg.state,
                                &mut conn_state,
                                &rpc_http_client,
                                &mut active_rpc,
                                &conn,
                                &ui_sender,
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

                            let active_rfq = &state
                                .active_rfq
                                .as_ref()
                                .expect("active_rfq must be set")
                                .rfq;
                            swaps_state.price = rfq_price(&state, &msg);
                            swaps_state.deliver_amount = Some(active_rfq.send_amount);
                            ui::send_swap_update(&swaps_state, &ui_sender);

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
