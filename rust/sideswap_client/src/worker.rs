use std::collections::{HashMap, HashSet};
use std::sync::{mpsc, Arc};
use std::time::{Duration, Instant};
use std::{
    collections::{BTreeMap, BTreeSet},
    str::FromStr,
};

use crate::ffi::{self, proto, GIT_COMMIT_HASH};
use crate::gdk_json::{self, AddressInfo};
use crate::gdk_ses::{self, ElectrumServer, NotifCallback, WalletInfo};
use crate::gdk_ses_impl::{self};
use crate::settings;
use crate::{gdk_ses_jade, models, swaps};

use anyhow::{anyhow, bail, ensure};
use bitcoin::bip32;
use bitcoin::hashes::Hash;
use bitcoin::secp256k1::global::SECP256K1;
use elements::bitcoin::bip32::ChildNumber;
use elements::AssetId;
use log::{debug, error, info, warn};
use market_worker::REGISTER_PATH;
use rand::Rng;
use serde::{Deserialize, Serialize};
use sideswap_common::env::Env;
use sideswap_common::event_proofs::EventProofs;
use sideswap_common::network::Network;
use sideswap_common::send_tx::coin_select::InOut;
use sideswap_common::types::{self, peg_out_amount, select_utxo_values, Amount};
use sideswap_common::ws::next_request_id;
use sideswap_common::{abort, b64, pin, send_tx};
use sideswap_jade::jade_mng::{self, JadeStatus, JadeStatusCallback};
use sideswap_types::asset_precision::AssetPrecision;
use sideswap_types::fee_rate::FeeRateSats;
use tokio::sync::mpsc::UnboundedSender;

use sideswap_api::{self as api, fcm_models, http_rpc, MarketType, OrderId};
use sideswap_common::ws::manual as ws;

pub struct StartParams {
    pub work_dir: String,
    pub version: String,
}

#[derive(thiserror::Error, Debug)]
pub enum CallError {
    #[error("Backend error: {0}")]
    Backend(sideswap_api::Error),
    #[error("Request timeout")]
    Timeout,
    #[error("Unexpected response")]
    UnexpectedResponse,
}

macro_rules! send_request {
    ($sender:expr, $t:ident, $value:expr) => {
        match $sender.send_request(sideswap_api::Request::$t($value)) {
            Ok(sideswap_api::Response::$t(value)) => Ok(value),
            Ok(_) => Err(CallError::UnexpectedResponse),
            Err(error) => Err(error),
        }
    };
}

macro_rules! send_market_request {
    ($sender:expr, $t:ident, $value:expr) => {
        match $sender.send_request(sideswap_api::Request::Market(
            sideswap_api::mkt::Request::$t($value),
        )) {
            Ok(sideswap_api::Response::Market(sideswap_api::mkt::Response::$t(value))) => Ok(value),
            Ok(_) => Err(CallError::UnexpectedResponse),
            Err(error) => Err(error),
        }
    };
}

mod assets_registry;
mod coin_select;
mod market_worker;
mod wallet;

const CLIENT_API_KEY: &str = "f8b7a12ee96aa68ee2b12ebfc51d804a4a404c9732652c298d24099a3d922a84";

pub const USER_AGENT: &str = "SideSwapApp";

const SERVER_REQUEST_TIMEOUT: std::time::Duration = std::time::Duration::from_secs(5);
const SERVER_REQUEST_POLL_PERIOD: std::time::Duration = std::time::Duration::from_secs(1);

// AMP session stops somewhere between 50 and 125 minutes, check it every 40 minutes
const AMP_CONNECTION_CHECK_PERIOD: std::time::Duration = std::time::Duration::from_secs(2400);

pub const TX_CONF_COUNT_LIQUID: u32 = 2;

const DEFAULT_ICON: &[u8] = include_bytes!("../images/icon_blank.png");

pub type AccountId = i32;

pub const ACCOUNT_ID_REG: AccountId = 0;
pub const ACCOUNT_ID_AMP: AccountId = 1;

struct ActivePeg {
    order_id: api::OrderId,
}

pub struct ServerResp(String, Result<api::Response, api::Error>);

pub type FromCallback = Arc<dyn Fn(proto::from::Msg) -> bool>;

#[derive(Clone)]
struct UiData {
    from_callback: FromCallback,
    ui_stopped: std::sync::Arc<std::sync::atomic::AtomicBool>,
}

#[derive(Default)]
struct UsedAddresses {
    single_sig: [u32; 2],
    multi_sig: u32,
}

#[derive(Clone)]
pub struct XPubInfo {
    single_sig_account: bip32::Xpub,
    multi_sig_service_xpub: bip32::Xpub,
    multi_sig_user_xpub: bip32::Xpub,
}

#[derive(Clone)]
pub struct Wallet {
    login_info: gdk_ses::LoginInfo,
    command_sender: mpsc::Sender<wallet::Command>,
    xpubs: XPubInfo,
}

type AsyncRequests =
    BTreeMap<api::RequestId, Box<dyn FnOnce(&mut Data, Result<api::Response, api::Error>)>>;

#[derive(Debug, Copy, Clone, PartialEq, Eq)]
enum TimerEvent {
    AmpConnectionCheck,
    SyncUtxos,
    SendAck,
}

pub struct Data {
    app_active: bool,
    amp_active: bool,
    amp_connected: bool,
    ws_connected: bool,
    server_status: Option<api::ServerStatus>,
    env: Env,
    ui: UiData,
    market: market_worker::Data,
    assets: BTreeMap<AssetId, api::Asset>,
    amp_assets: BTreeSet<AssetId>,
    msg_sender: mpsc::Sender<Message>,
    ws_sender: UnboundedSender<ws::WrappedRequest>,
    ws_hint: UnboundedSender<()>,
    resp_receiver: mpsc::Receiver<ServerResp>,
    params: StartParams,
    timers: BTreeMap<Instant, TimerEvent>,

    agent: ureq::Agent,
    sync_complete: bool,
    wallet_loaded_sent: bool,
    confirmed_txids: BTreeMap<AccountId, HashSet<elements::Txid>>,
    unconfirmed_txids: BTreeMap<AccountId, HashSet<elements::Txid>>,
    wallets: BTreeMap<AccountId, Wallet>,

    active_swap: Option<ActiveSwap>,
    succeed_swap: Option<elements::Txid>,
    active_extern_peg: Option<ActivePeg>,
    sent_txhash: Option<elements::Txid>,
    peg_out_server_amounts: Option<api::PegOutAmounts>,
    active_submits: BTreeMap<OrderId, api::LinkResponse>,
    active_sign: Option<api::SignNotification>,

    settings: settings::Settings,
    push_token: Option<String>,
    policy_asset: AssetId,
    subscribed_price_stream: Option<api::SubscribePriceStreamRequest>,
    last_blocks: BTreeMap<AccountId, gdk_json::NotificationBlock>,
    used_addresses: UsedAddresses,

    jade_mng: jade_mng::JadeMng,

    async_requests: AsyncRequests,

    network_settings: proto::to::NetworkSettings,
    proxy_settings: proto::to::ProxySettings,

    wallet_event_callback: wallet::EventCallback,
}

pub struct ActiveSwap {
    order_id: OrderId,
    send_asset: AssetId,
    recv_asset: AssetId,
    send_amount: u64,
    recv_amount: u64,
}

pub enum Message {
    Ui(ffi::ToMsg),
    Ws(ws::WrappedResponse),
    WalletEvent(AccountId, wallet::Event),
    WalletNotif(AccountId, gdk_json::Notification),
    BackgroundMessage(String, mpsc::Sender<()>),
    Quit,
}

const XPUB_PATH_ROOT: [u32; 0] = [];
const XPUB_PATH_PASS: [u32; 1] = [0xF0617373];

fn redact_str(v: &mut String) {
    *v = format!("<{} bytes>", v.len());
}

fn redact_to_msg(mut msg: proto::to::Msg) -> proto::to::Msg {
    match &mut msg {
        proto::to::Msg::Login(v) => {
            if let Some(proto::to::login::Wallet::Mnemonic(mnemonic)) = v.wallet.as_mut() {
                redact_str(mnemonic);
            }
        }
        proto::to::Msg::EncryptPin(v) => {
            redact_str(&mut v.pin);
            redact_str(&mut v.mnemonic);
        }
        proto::to::Msg::DecryptPin(v) => {
            redact_str(&mut v.pin);
            redact_str(&mut v.encrypted_data);
        }
        _ => {}
    }
    msg
}

fn redact_from_msg(mut msg: proto::from::Msg) -> proto::from::Msg {
    match &mut msg {
        proto::from::Msg::DecryptPin(v) => {
            if let Some(proto::from::decrypt_pin::Result::Mnemonic(v)) = v.result.as_mut() {
                redact_str(v);
            }
        }
        proto::from::Msg::EncryptPin(v) => {
            if let Some(proto::from::encrypt_pin::Result::Data(v)) = v.result.as_mut() {
                redact_str(&mut v.encrypted_data);
            }
        }
        proto::from::Msg::NewAsset(v) => {
            redact_str(&mut v.icon);
        }
        _ => {}
    }
    msg
}

pub fn get_account(id: AccountId) -> proto::Account {
    proto::Account { id }
}

fn convert_chart_point(point: api::ChartPoint) -> proto::ChartPoint {
    proto::ChartPoint {
        time: point.time,
        open: point.open,
        close: point.close,
        high: point.high,
        low: point.low,
        volume: point.volume,
    }
}

fn confirmed_tx(tx_block: u32, top_block: u32) -> bool {
    tx_block != 0
        && top_block != 0
        && tx_block <= top_block
        && top_block + 1 - tx_block >= TX_CONF_COUNT_LIQUID
}

fn get_tx_item_confs(tx_block: u32, top_block: u32) -> Option<proto::Confs> {
    // Because of race condition reported transaction mined height might be more than last block height
    let tx_block = if tx_block > top_block { 0 } else { tx_block };
    if !confirmed_tx(tx_block, top_block) {
        let count = if tx_block == 0 {
            0
        } else {
            top_block + 1 - tx_block
        };
        Some(proto::Confs {
            count,
            total: TX_CONF_COUNT_LIQUID,
        })
    } else {
        None
    }
}

fn tx_txitem_id(account_id: AccountId, txid: &elements::Txid) -> String {
    format!("{}/{}", account_id, txid)
}

fn peg_txitem_id(send_txid: &str, send_vout: i32) -> String {
    format!("{}/{}", send_txid, send_vout)
}

fn get_peg_item(peg: &api::PegStatus, tx: &api::TxStatus) -> proto::TransItem {
    let peg_details = proto::Peg {
        is_peg_in: peg.peg_in,
        amount_send: tx.amount,
        amount_recv: tx.payout.unwrap_or_default(),
        addr_send: peg.addr.clone(),
        addr_recv: peg.addr_recv.clone(),
        txid_send: tx.tx_hash.clone(),
        txid_recv: tx.payout_txid.clone(),
    };
    let confs = tx.detected_confs.and_then(|count| {
        tx.total_confs.map(|total| proto::Confs {
            count: count as u32,
            total: total as u32,
        })
    });
    let id = peg_txitem_id(&tx.tx_hash, tx.vout);

    proto::TransItem {
        id,
        created_at: tx.created_at,
        confs,
        account: get_account(ACCOUNT_ID_REG), // TODO: This is not accurate for peg-outs from the AMP wallet
        item: Some(proto::trans_item::Item::Peg(peg_details)),
    }
}

fn select_swap_inputs(
    inputs: Vec<gdk_json::UnspentOutput>,
    amount: i64,
) -> Result<Vec<gdk_json::UnspentOutput>, anyhow::Error> {
    let total = inputs.iter().map(|input| input.satoshi).sum::<u64>() as i64;
    ensure!(total >= amount, "not enough UTXOs total amount");
    let inputs = inputs
        .into_iter()
        .map(|input| (input.satoshi as i64, input))
        .collect::<Vec<_>>();
    let inputs = select_utxo_values(inputs, amount);
    Ok(inputs)
}

fn derive_single_sig_address(
    account_xpub: &bip32::Xpub,
    network: Network,
    is_internal: bool,
    pointer: u32,
) -> elements::Address {
    let pub_key = account_xpub
        .derive_pub(
            SECP256K1,
            &[
                ChildNumber::from_normal_idx(is_internal as u32).unwrap(),
                ChildNumber::from_normal_idx(pointer).unwrap(),
            ],
        )
        .unwrap()
        .to_pub();
    let pub_key = elements::bitcoin::PublicKey::new(pub_key.0);
    elements::Address::p2shwpkh(&pub_key, None, network.d().elements_params)
}

fn derive_multi_sig_address(
    multi_sig_service_xpub: &bip32::Xpub,
    multi_sig_user_xpub: &bip32::Xpub,
    network: Network,
    pointer: u32,
) -> elements::Address {
    let pub_key_green = multi_sig_service_xpub
        .derive_pub(SECP256K1, &[ChildNumber::from_normal_idx(pointer).unwrap()])
        .unwrap()
        .to_pub();
    let pub_key_user = multi_sig_user_xpub
        .derive_pub(SECP256K1, &[ChildNumber::from_normal_idx(pointer).unwrap()])
        .unwrap()
        .to_pub();

    let script = elements::script::Builder::new()
        .push_opcode(elements::opcodes::all::OP_PUSHNUM_2)
        .push_slice(&pub_key_green.to_bytes())
        .push_slice(&pub_key_user.to_bytes())
        .push_opcode(elements::opcodes::all::OP_PUSHNUM_2)
        .push_opcode(elements::opcodes::all::OP_CHECKMULTISIG)
        .into_script();

    let script = elements::script::Builder::new()
        .push_int(0)
        .push_slice(&elements::WScriptHash::hash(script.as_bytes())[..])
        .into_script();

    let script_hash = elements::ScriptHash::hash(script.as_bytes());

    elements::Address {
        params: network.d().elements_params,
        payload: elements::address::Payload::ScriptHash(script_hash),
        blinding_pubkey: None,
    }
}

fn load_all_addresses(
    wallet: &Wallet,
    is_internal: bool,
    last_known_pointer: Option<u32>,
) -> Result<(u32, Vec<AddressInfo>), anyhow::Error> {
    let mut result = Vec::new();
    let mut result_pointer = 0;
    let mut last_pointer = None;
    loop {
        debug!(
            "load prev addresses, account_id: {}, is_internal: {}, last_pointer: {:?}",
            wallet.login_info.account_id, is_internal, last_pointer,
        );

        let list = wallet::call_wallet(wallet, move |data| {
            data.ses.get_previous_addresses(last_pointer, is_internal)
        })?;

        let min_pointer = list
            .list
            .iter()
            .map(|addr| addr.pointer)
            .min()
            .unwrap_or_default();
        let max_pointer = list
            .list
            .iter()
            .map(|addr| addr.pointer)
            .max()
            .unwrap_or_default();
        debug!(
            "loaded prev addresses, last_pointer: {:?}, loaded: {}-{}",
            list.last_pointer, min_pointer, max_pointer
        );
        result_pointer = u32::max(result_pointer, max_pointer);
        let mut new_list = list
            .list
            .into_iter()
            .filter(|addr| {
                last_known_pointer.is_none() || addr.pointer > last_known_pointer.unwrap()
            })
            .collect::<Vec<_>>();
        let no_new_addresses = new_list.is_empty();
        result.append(&mut new_list);
        if no_new_addresses || list.last_pointer.is_none() {
            debug!(
                "total loaded: {}, last_pointer: {}",
                result.len(),
                result_pointer
            );
            return Ok((result_pointer, result));
        }
        last_pointer = list.last_pointer;
    }
}

fn convert_to_swap_utxo(utxo: gdk_json::UnspentOutput) -> sideswap_api::Utxo {
    sideswap_api::Utxo {
        txid: utxo.txhash,
        vout: utxo.vout,
        asset: utxo.asset_id,
        asset_bf: utxo.assetblinder,
        value: utxo.satoshi,
        value_bf: utxo.amountblinder,
        redeem_script: Some(gdk_ses_impl::get_redeem_script(&utxo)),
    }
}

impl UiData {
    fn send(&self, msg: proto::from::Msg) {
        debug!(
            "to ui: {}",
            serde_json::to_string(&redact_from_msg(msg.clone())).unwrap()
        );
        let result = (self.from_callback)(msg);
        if !result {
            warn!("posting dart message failed");
            self.ui_stopped
                .store(true, std::sync::atomic::Ordering::Relaxed);
        }
    }
}

#[derive(Serialize, Deserialize)]
struct AssetsCache {
    git_commit_hash: String,
    assets: Vec<api::Asset>,
}

impl Data {
    fn logged_in(&self) -> bool {
        !self.wallets.is_empty()
    }

    fn master_xpub(&mut self) -> bip32::Xpub {
        if self.settings.master_pub_key.is_none() {
            let seed = rand::Rng::gen::<[u8; 32]>(&mut rand::thread_rng());
            let master_priv_key =
                bip32::Xpriv::new_master(bitcoin::Network::Bitcoin, &seed).unwrap();
            let master_pub_key = bitcoin::bip32::Xpub::from_priv(SECP256K1, &master_priv_key);
            self.settings.master_pub_key = Some(master_pub_key);
            self.save_settings();
        }
        self.settings.master_pub_key.unwrap()
    }

    fn load_gdk_assets(&mut self, asset_ids: &[AssetId]) -> Result<Vec<api::Asset>, anyhow::Error> {
        assets_registry::get_assets(self.env, self.master_xpub(), asset_ids)
    }

    fn send_new_transactions(
        &mut self,
        mut items: Vec<models::Transaction>,
        account_id: AccountId,
        top_block: u32,
    ) {
        let confirmed_txids = self.confirmed_txids.entry(account_id).or_default();
        let unconfirmed_txids = self.unconfirmed_txids.entry(account_id).or_default();

        items.retain(|tx| !confirmed_txids.contains(&tx.txid));

        let updated = items
            .into_iter()
            .map(|item| {
                let balances = item
                    .balances
                    .iter()
                    .filter(|balance| balance.value != 0)
                    .map(|balance| proto::Balance {
                        asset_id: balance.asset.to_string(),
                        amount: balance.value,
                    })
                    .collect();
                let confs = get_tx_item_confs(item.block_height, top_block);
                let id = tx_txitem_id(account_id, &item.txid);
                let balances_all = item
                    .balances_all
                    .iter()
                    .map(|balance| proto::Balance {
                        asset_id: balance.asset.to_string(),
                        amount: balance.value,
                    })
                    .collect();
                let tx_details = proto::Tx {
                    balances,
                    memo: item.memo.clone(),
                    network_fee: item.network_fee as i64,
                    txid: item.txid.to_string(),
                    vsize: item.vsize as i64,
                    balances_all,
                };
                (
                    item.txid,
                    proto::TransItem {
                        id,
                        created_at: item.created_at,
                        confs,
                        account: get_account(account_id),
                        item: Some(proto::trans_item::Item::Tx(tx_details)),
                    },
                )
            })
            .collect::<HashMap<_, _>>();

        let removed = unconfirmed_txids
            .iter()
            .filter(|txid| !updated.contains_key(*txid))
            .cloned()
            .collect::<Vec<_>>();

        let mut queue_msgs = Vec::new();

        if let Some(txid) = self.sent_txhash.as_ref() {
            let tx = updated.get(txid);
            if let Some(tx) = tx {
                let result = proto::from::send_result::Result::TxItem(tx.clone());
                queue_msgs.push(proto::from::Msg::SendResult(proto::from::SendResult {
                    result: Some(result),
                }));
                self.sent_txhash = None;
                self.update_sync_interval();
            }
        }

        if let Some(txid) = self.succeed_swap.as_ref() {
            let tx = updated.get(txid);
            if let Some(tx) = tx {
                queue_msgs.push(proto::from::Msg::SwapSucceed(tx.clone()));
                self.succeed_swap = None;
                self.update_sync_interval();
            }
        }

        let assets = updated
            .values()
            .flat_map(|item| match item.item.as_ref().unwrap() {
                proto::trans_item::Item::Tx(tx) => Some(&tx.balances),
                _ => None,
            })
            .flat_map(|balances| balances.iter())
            .map(|balance| AssetId::from_str(&balance.asset_id).unwrap())
            .collect::<BTreeSet<_>>();

        let new_asset_ids = assets
            .iter()
            .filter(|asset| self.assets.get(asset).is_none())
            .cloned()
            .collect::<Vec<_>>();
        if !new_asset_ids.is_empty() {
            let new_assets = self
                .load_gdk_assets(&new_asset_ids)
                .ok()
                .unwrap_or_default();
            for asset_id in new_asset_ids.iter() {
                info!("try add new asset: {}", asset_id);
                let asset = match new_assets.iter().find(|asset| asset.asset_id == *asset_id) {
                    Some(asset) => asset.clone(),
                    None => {
                        warn!("can't find GDK asset {}", asset_id);
                        api::Asset {
                            asset_id: *asset_id,
                            name: format!("{:0.8}...", &asset_id.to_string()),
                            ticker: api::Ticker(format!("{:0.4}", &asset_id.to_string())),
                            icon: None,
                            precision: AssetPrecision::BITCOIN_PRECISION,
                            icon_url: None,
                            instant_swaps: Some(false),
                            domain: None,
                            domain_agent: None,
                            domain_agent_link: None,
                            always_show: None,
                            issuance_prevout: None,
                            issuer_pubkey: None,
                            contract: None,
                            market_type: None,
                            server_fee: None,
                            amp_asset_restrictions: None,
                            payjoin: None,
                        }
                    }
                };
                self.register_asset(asset);
            }
        }

        let confirmed_txids = self.confirmed_txids.get_mut(&account_id).unwrap();
        let unconfirmed_txids = self.unconfirmed_txids.get_mut(&account_id).unwrap();

        unconfirmed_txids.clear();
        for (txid, item) in updated.iter() {
            if item.confs.is_none() {
                confirmed_txids.insert(*txid);
            } else {
                unconfirmed_txids.insert(*txid);
            }
        }

        if !updated.is_empty() {
            let updated = updated.into_values().collect();
            self.ui
                .send(proto::from::Msg::UpdatedTxs(proto::from::UpdatedTxs {
                    items: updated,
                }));
        }
        if !removed.is_empty() {
            let removed = removed.iter().map(|txid| txid.to_string()).collect();
            self.ui
                .send(proto::from::Msg::RemovedTxs(proto::from::RemovedTxs {
                    txids: removed,
                }));
        }

        for msg in queue_msgs.into_iter() {
            self.ui.send(msg);
        }

        // self.process_pending_succeed();
    }

    fn resync_wallet(&mut self, account_id: AccountId) {
        log::debug!("resync wallet {}", account_id);

        // Refresh UTXOs before sending balances, some tests may fail otherwise
        wallet::callback(
            account_id,
            self,
            |data| data.ses.get_utxos(),
            move |data, res| match res {
                Ok(utxos) => market_worker::wallet_utxos(data, account_id, utxos),
                Err(err) => {
                    log::error!("loading utxos failed: {err}");
                }
            },
        );

        wallet::callback(
            account_id,
            self,
            |data| data.ses.get_balances(),
            move |data, res| match res {
                Ok(balances) => {
                    let balances = balances
                        .into_iter()
                        .map(|(asset_id, amount)| proto::Balance {
                            asset_id: asset_id.to_string(),
                            amount,
                        })
                        .collect();
                    data.ui.send(proto::from::Msg::BalanceUpdate(
                        proto::from::BalanceUpdate {
                            account: get_account(account_id),
                            balances,
                        },
                    ));
                }
                Err(err) => {
                    log::error!("balance refresh failed: {err}");
                }
            },
        );

        // TODO: Load transactions lazily to speedup wallet startup
        wallet::callback(
            account_id,
            self,
            |data| data.ses.get_transactions(),
            move |data, res| match res {
                Ok(items) => {
                    if let Some(last_block) = data.last_blocks.get(&account_id) {
                        let top_block = last_block.block_height;
                        data.update_used_addresses(account_id, &items);
                        data.send_new_transactions(items, account_id, top_block);
                    }
                }
                Err(err) => {
                    error!("tx refresh failed: {err}");
                }
            },
        );
    }

    fn send_wallet_loaded(&mut self) {
        if !self.wallet_loaded_sent {
            self.wallet_loaded_sent = true;
            self.ui
                .send(proto::from::Msg::WalletLoaded(proto::Empty {}));
        }
    }

    fn sync_complete(&mut self, account_id: AccountId) {
        // Single-sig account takes 50..90 seconds to sync even if it's cached
        debug!("sync_complete, account_id: {account_id}");
        if !self.sync_complete {
            self.sync_complete = true;
            self.send_wallet_loaded();
            // self.process_pending_requests();
            self.ui
                .send(proto::from::Msg::SyncComplete(proto::Empty {}));
        }
        self.resync_wallet(account_id);
    }

    fn sync_failed(&mut self) {
        self.show_message("electrs connection failed");
    }

    fn resume_peg_monitoring(&mut self) {
        if self.assets.is_empty() || !self.ws_connected {
            return;
        }
        for peg in self.settings.pegs.iter().flatten() {
            self.start_peg_monitoring(peg);
        }
    }

    fn data_path(env: Env, path: &str) -> std::path::PathBuf {
        let env_data = env.d();
        let path = std::path::Path::new(&path).join(env_data.name);
        std::fs::create_dir_all(&path).expect("can't create data path");
        path
    }

    fn get_data_path(&self) -> std::path::PathBuf {
        Data::data_path(self.env, &self.params.work_dir)
    }

    fn cookie_path(&self) -> std::path::PathBuf {
        self.get_data_path().join("sideswap.cookie")
    }
    fn assets_cache_path(&self) -> std::path::PathBuf {
        self.get_data_path().join("assets_cache.json")
    }
    fn assets_cache_path_tmp(&self) -> std::path::PathBuf {
        self.get_data_path().join("assets_cache.json.tmp")
    }
    fn cache_path(&self) -> std::path::PathBuf {
        self.get_data_path().join("cache")
    }
    fn registry_path(&self) -> std::path::PathBuf {
        self.get_data_path().join("registry")
    }

    fn subscribe_price_update(&mut self, asset_id: &AssetId) {
        self.send_request_msg(api::Request::PriceUpdateSubscribe(
            api::PriceUpdateSubscribe { asset: *asset_id },
        ));
    }

    fn register_new_device(&mut self) {
        // register device key if does not exist
        self.make_async_request(
            api::Request::RegisterDevice(api::RegisterDeviceRequest {
                os_type: api::get_os_type(),
            }),
            move |data, res| {
                match res {
                    Ok(api::Response::RegisterDevice(resp)) => {
                        info!("new device_key is registered: {}", resp.device_key);
                        data.settings.device_key = Some(resp.device_key);
                        data.settings.single_sig_registered = Default::default();
                        data.settings.multi_sig_registered = Default::default();
                        data.save_settings();

                        data.finish_ws_connection();
                    }
                    Ok(_) => {
                        log::error!("unexpected RegisterDevice response");
                    }
                    Err(err) => {
                        log::debug!("RegisterDevice failed: {err}");
                    }
                };
            },
        );
    }

    fn finish_ws_connection(&mut self) {
        self.resume_peg_monitoring();
        self.update_push_token();
        // self.send_subscribe_request();
        self.update_address_registrations();
    }

    fn process_ws_connected(&mut self) {
        info!("connected to server, version: {}", &self.params.version);
        // ws_connected must be set to true before any WS requests are sent
        self.ws_connected = true;

        let cookie = std::fs::read_to_string(self.cookie_path()).ok();
        self.make_async_request(
            api::Request::LoginClient(api::LoginClientRequest {
                api_key: Some(CLIENT_API_KEY.to_owned()),
                cookie,
                user_agent: USER_AGENT.to_owned(),
                version: self.params.version.clone(),
            }),
            move |data, res| {
                match res {
                    Ok(api::Response::LoginClient(resp)) => {
                        let res = std::fs::write(data.cookie_path(), &resp.cookie);
                        if let Err(err) = res {
                            error!("can't write cookie: {}", &err);
                        };
                    }
                    Ok(_) => {
                        log::error!("unexpected LoginClient response");
                    }
                    Err(err) => {
                        log::debug!("LoginClient failed: {err}");
                    }
                };
            },
        );

        self.make_async_request(
            api::Request::Assets(Some(api::AssetsRequestParam {
                embedded_icons: Some(false),
                all_assets: Some(true),
                amp_asset_restrictions: Some(true),
            })),
            move |data, res| {
                match res {
                    Ok(api::Response::Assets(resp)) => {
                        let res = data.save_assets_cache(&resp.assets);
                        if let Err(err) = res {
                            log::error!("saving assets cache failed: {err}");
                        }

                        for asset in resp
                            .assets
                            .iter()
                            .filter(|asset| asset.market_type == Some(MarketType::Stablecoin))
                        {
                            data.subscribe_price_update(&asset.asset_id);
                        }

                        data.amp_assets = resp
                            .assets
                            .iter()
                            .filter_map(|v| {
                                if v.market_type == Some(MarketType::Amp) {
                                    Some(v.asset_id)
                                } else {
                                    None
                                }
                            })
                            .collect();

                        data.ui
                            .send(proto::from::Msg::AmpAssets(proto::from::AmpAssets {
                                assets: data
                                    .amp_assets
                                    .iter()
                                    .map(|asset_id| asset_id.to_string())
                                    .collect(),
                            }));

                        data.register_assets_with_gdk_icons(resp.assets);
                    }
                    Ok(_) => {
                        log::error!("unexpected Assets response");
                    }
                    Err(err) => {
                        log::debug!("Assets failed: {err}");
                    }
                };
            },
        );

        self.make_async_request(api::Request::ServerStatus(None), move |data, res| {
            match res {
                Ok(api::Response::ServerStatus(resp)) => {
                    data.process_server_status(resp);
                }
                Ok(_) => {
                    log::error!("unexpected ServerStatus response");
                }
                Err(err) => {
                    log::debug!("ServerStatus failed: {err}");
                }
            };
        });

        self.make_async_request(
            api::Request::Login(api::LoginRequest {
                session_id: self.settings.session_id,
            }),
            move |data, res| {
                match res {
                    Ok(api::Response::Login(resp)) => {
                        for order in resp.orders {
                            // Cancel old orders
                            data.send_request_msg(api::Request::Cancel(api::CancelRequest {
                                order_id: order.order_id,
                            }));
                        }
                        if Some(&resp.session_id) != data.settings.session_id.as_ref() {
                            data.settings.session_id = Some(resp.session_id);
                            data.save_settings();
                        }
                    }
                    Ok(_) => {
                        log::error!("unexpected Login response");
                    }
                    Err(err) => {
                        log::debug!("Login failed: {err}");
                    }
                };
            },
        );

        for req in self.subscribed_price_stream.iter() {
            self.send_request_msg(api::Request::SubscribePriceStream(req.clone()));
        }

        // verify device key if exists
        if let Some(device_key) = &self.settings.device_key {
            self.make_async_request(
                api::Request::VerifyDevice(api::VerifyDeviceRequest {
                    device_key: device_key.clone(),
                }),
                |data, res| {
                    match res {
                        Ok(api::Response::VerifyDevice(resp)) => {
                            match resp.device_state {
                                api::DeviceState::Unregistered => {
                                    warn!("device_key is not registered");
                                    data.settings.device_key = None;
                                    data.save_settings();

                                    data.register_new_device();
                                }
                                api::DeviceState::Registered => {
                                    info!("device_key is registered");

                                    data.finish_ws_connection();
                                }
                            };
                        }
                        Ok(_) => {
                            log::error!("unexpected VerifyDevice response");
                        }
                        Err(err) => {
                            log::debug!("VerifyDevice failed: {err}");
                        }
                    };
                },
            );
        } else {
            self.register_new_device();
        }

        // self.process_pending_requests();
        market_worker::ws_connected(self);

        self.ui
            .send(proto::from::Msg::ServerConnected(proto::Empty {}));
    }

    fn process_ws_disconnected(&mut self) {
        warn!("disconnected from server");
        self.ws_connected = false;

        self.ui
            .send(proto::from::Msg::ServerDisconnected(proto::Empty {}));

        let async_requests = std::mem::take(&mut self.async_requests);
        for request in async_requests.into_values() {
            request(
                self,
                Err(api::Error {
                    code: api::ErrorCode::ServerError,
                    message: "Server disconnected".to_owned(),
                }),
            );
        }

        market_worker::ws_disconnected(self);

        if self.logged_in() {
            self.send_ws_connect();
        }

        remove_timers(self, TimerEvent::SendAck);
    }

    fn process_server_status(&mut self, resp: api::ServerStatus) {
        let bitcoin_fee_rates = resp
            .bitcoin_fee_rates
            .iter()
            .map(|item| proto::FeeRate {
                blocks: item.blocks,
                value: item.value.raw(),
            })
            .collect();
        let status_copy = proto::ServerStatus {
            min_peg_in_amount: resp.min_peg_in_amount,
            min_peg_out_amount: resp.min_peg_out_amount,
            server_fee_percent_peg_in: resp.server_fee_percent_peg_in,
            server_fee_percent_peg_out: resp.server_fee_percent_peg_out,
            bitcoin_fee_rates,
        };
        self.ui.send(proto::from::Msg::ServerStatus(status_copy));
        self.server_status = Some(resp);
    }

    fn process_price_update(&mut self, msg: api::PriceUpdateNotification) {
        let asset = match self.assets.get(&msg.asset) {
            Some(v) => v,
            None => return,
        };
        let price_update = proto::from::PriceUpdate {
            asset: asset.asset_id.to_string(),
            bid: msg.price.bid,
            ask: msg.price.ask,
        };
        self.ui.send(proto::from::Msg::PriceUpdate(price_update));
    }

    fn process_wallet_event(&mut self, account_id: AccountId, event: wallet::Event) {
        let _wallet = match self.get_wallet(account_id) {
            Ok(wallet) => wallet,
            Err(err) => {
                log::debug!("ignore wallet event: {err}");
                return;
            }
        };

        match event {
            wallet::Event::Run(callback) => {
                callback(self);
            }
        }
    }

    fn process_wallet_notif(
        &mut self,
        account_id: AccountId,
        notification: gdk_json::Notification,
    ) {
        if self.get_wallet(account_id).is_err() {
            debug!("ignore notification from a deleted wallet, account_id: {account_id}");
            return;
        }

        match notification.event.as_str() {
            "transaction" => self.resync_wallet(account_id),
            "block" => {
                let unconfirmed_txs = self
                    .unconfirmed_txids
                    .get(&account_id)
                    .map(|unconfirmed_txids| !unconfirmed_txids.is_empty())
                    .unwrap_or(false);
                let old_value = self
                    .last_blocks
                    .insert(account_id, notification.block.unwrap());
                if unconfirmed_txs || old_value.is_none() {
                    self.resync_wallet(account_id)
                }
            }
            "subaccount" => {
                if let Some(subaccount) = notification.subaccount {
                    if subaccount.event_type == "synced" {
                        self.sync_complete(account_id);
                    }
                }
            }
            "sync_failed" => self.sync_failed(), // TODO: Not available from GDK
            _ => {}
        }

        if let Some(gdk_json::NotificationNetwork {
            current_state: gdk_json::ConnectionState::Connected,
            next_state: _,
            wait_ms: _,
        }) = &notification.network
        {
            debug!("request wallet {} login", account_id);
            wallet::callback(
                account_id,
                self,
                |data| data.ses.login(),
                move |data, res| match res {
                    Ok(_) => {
                        if account_id == ACCOUNT_ID_AMP {
                            debug!("AMP connected");
                            // self.process_pending_requests();

                            wallet::callback(
                                account_id,
                                data,
                                |data| data.ses.get_gaid(),
                                move |data, res| match res {
                                    Ok(gaid) => {
                                        data.ui.send(proto::from::Msg::RegisterAmp(
                                            proto::from::RegisterAmp {
                                                result: Some(
                                                    proto::from::register_amp::Result::AmpId(gaid),
                                                ),
                                            },
                                        ));
                                    }
                                    Err(err) => log::error!("loading gaid failed: {err}"),
                                },
                            );

                            data.amp_connected = true;

                            replace_timers(
                                data,
                                AMP_CONNECTION_CHECK_PERIOD,
                                TimerEvent::AmpConnectionCheck,
                            );
                        }
                        data.resync_wallet(account_id);
                    }
                    Err(err) => {
                        data.show_message(&format!("connection failed: {err}"));
                    }
                },
            );
        }

        if let Some(gdk_json::NotificationNetwork {
            current_state: gdk_json::ConnectionState::Disconnected,
            next_state: _,
            wait_ms: _,
        }) = &notification.network
        {
            if account_id == ACCOUNT_ID_AMP {
                debug!("AMP disconnected");
                self.amp_connected = false;
                remove_timers(self, TimerEvent::AmpConnectionCheck);
            }
        }
    }

    fn try_process_pegout_amount(
        &mut self,
        req: proto::to::PegOutAmount,
    ) -> Result<proto::from::peg_out_amount::Amounts, anyhow::Error> {
        ensure!(self.ws_connected, "not connected");

        let utxos = wallet::call(req.account.id, self, |data| data.ses.get_utxos())?
            .unspent_outputs
            .remove(&self.policy_asset)
            .unwrap_or_default();

        let wallet = self.get_wallet(req.account.id)?;
        assert!(utxos.iter().all(|utxo| utxo.asset_id == self.policy_asset));
        let balance = utxos.iter().map(|utxo| utxo.satoshi).sum::<u64>();

        let server_status = self
            .server_status
            .as_ref()
            .ok_or(anyhow!("server_status is not known"))?;

        let deduct_fee = req.is_send_entered && balance == req.amount as u64;

        let amount = if deduct_fee {
            let coin_select = send_tx::coin_select::normal_tx::try_coin_select(
                send_tx::coin_select::normal_tx::Args {
                    multisig_wallet: !wallet.login_info.single_sig,
                    policy_asset: self.policy_asset,
                    use_all_utxos: false,
                    wallet_utxos: utxos
                        .iter()
                        .map(|utxo| InOut {
                            asset_id: utxo.asset_id,
                            value: utxo.satoshi,
                        })
                        .collect(),
                    user_outputs: vec![InOut {
                        asset_id: self.policy_asset,
                        value: req.amount as u64,
                    }],
                    deduct_fee: Some(0),
                },
            )?;

            req.amount as u64 - coin_select.network_fee.value
        } else {
            req.amount as u64
        };

        let fee_rate = FeeRateSats::from_raw(req.fee_rate);

        let amounts = peg_out_amount(types::PegOutAmountReq {
            amount: amount as i64,
            is_send_entered: req.is_send_entered,
            fee_rate,
            min_peg_out_amount: server_status.min_peg_out_amount,
            server_fee_percent_peg_out: server_status.server_fee_percent_peg_out,
            peg_out_bitcoin_tx_vsize: server_status.peg_out_bitcoin_tx_vsize,
        })?;

        self.peg_out_server_amounts = Some(api::PegOutAmounts {
            send_amount: amounts.send_amount,
            recv_amount: amounts.recv_amount,
            is_send_entered: req.is_send_entered,
            fee_rate,
        });

        Ok(proto::from::peg_out_amount::Amounts {
            send_amount: amounts.send_amount,
            recv_amount: amounts.recv_amount,
            fee_rate: req.fee_rate,
            account: req.account,
            is_send_entered: req.is_send_entered,
        })
    }

    fn process_pegout_amount(&mut self, req: proto::to::PegOutAmount) {
        let res = match self.try_process_pegout_amount(req) {
            Ok(amounts) => proto::from::peg_out_amount::Result::Amounts(amounts),
            Err(err) => {
                error!("peg-out amount failed: {}", err.to_string());
                proto::from::peg_out_amount::Result::ErrorMsg(err.to_string())
            }
        };
        let amounts_result = proto::from::PegOutAmount { result: Some(res) };
        self.ui.send(proto::from::Msg::PegOutAmount(amounts_result));
    }

    fn try_process_pegout_request(
        &mut self,
        req: proto::to::PegOutRequest,
    ) -> Result<OrderId, anyhow::Error> {
        ensure!(self.ws_connected, "not connected");
        let server_status = self
            .server_status
            .as_ref()
            .ok_or(anyhow!("server_status is not known"))?;
        ensure!(
            req.send_amount >= server_status.min_peg_out_amount,
            "min {}",
            Amount::from_sat(server_status.min_peg_out_amount)
                .to_bitcoin()
                .to_string()
        );

        let peg_out_server_amounts = self
            .peg_out_server_amounts
            .take()
            .ok_or_else(|| anyhow!("peg_out_server_amounts is None"))?;

        let device_key = self
            .settings
            .device_key
            .as_ref()
            .ok_or_else(|| anyhow!("device_key is None"))?
            .clone();

        let resp = send_request!(
            self,
            Peg,
            api::PegRequest {
                recv_addr: req.recv_addr.clone(),
                send_amount: None,
                peg_in: false,
                device_key: Some(device_key),
                blocks: Some(req.blocks),
                peg_out_amounts: Some(peg_out_server_amounts),
            }
        )?;

        self.add_peg_monitoring(resp.order_id, settings::PegDir::Out);

        let payment = wallet::PegoutPayment {
            policy_asset: self.policy_asset,
            send_amount: peg_out_server_amounts.send_amount,
            peg_addr: resp.peg_addr,
        };
        wallet::call(req.account.id, self, move |data| {
            wallet::process_peg_out_payment(data.ses.as_mut(), payment)
        })?;

        Ok(resp.order_id)
    }

    fn process_pegout_request(&mut self, req: proto::to::PegOutRequest) {
        let result = self.try_process_pegout_request(req);
        match result {
            Ok(order_id) => {
                self.active_extern_peg = Some(ActivePeg { order_id });
            }
            Err(e) => {
                error!("starting peg-out failed: {}", e.to_string());
                self.ui.send(proto::from::Msg::SwapFailed(e.to_string()));
            }
        }
    }

    fn try_process_pegin_request(&mut self) -> Result<proto::from::PeginWaitTx, anyhow::Error> {
        ensure!(self.ws_connected, "not connected");

        let device_key = self
            .settings
            .device_key
            .as_ref()
            .ok_or_else(|| anyhow!("device_key is None"))?
            .clone();

        let account_id = ACCOUNT_ID_REG;

        let recv_addr =
            wallet::call(account_id, self, |data| data.ses.get_receive_address())?.address;

        let resp = send_request!(
            self,
            Peg,
            api::PegRequest {
                recv_addr: recv_addr.to_string(),
                send_amount: None,
                peg_in: true,
                device_key: Some(device_key),
                blocks: None,
                peg_out_amounts: None,
            }
        )?;

        self.add_peg_monitoring(resp.order_id, settings::PegDir::In);

        let msg = proto::from::PeginWaitTx {
            peg_addr: resp.peg_addr,
            recv_addr: recv_addr.to_string(),
        };

        self.active_extern_peg = Some(ActivePeg {
            order_id: resp.order_id,
        });
        Ok(msg)
    }

    fn process_pegin_request(&mut self) {
        let result = self.try_process_pegin_request();
        match result {
            Ok(v) => {
                self.ui.send(proto::from::Msg::PeginWaitTx(v));
            }
            Err(e) => {
                error!("starting peg-in failed: {}", e.to_string());
                self.ui.send(proto::from::Msg::SwapFailed(e.to_string()));
            }
        }
    }

    fn continue_swap_request(
        &mut self,
        req: proto::to::SwapRequest,
        inputs: gdk_json::UnspentOutputs,
        recv_addr: gdk_json::AddressInfo,
        change_addr: gdk_json::AddressInfo,
    ) -> Result<(), anyhow::Error> {
        let asset = AssetId::from_str(&req.asset)
            .map_err(|_| anyhow!("invalid asset id: {}", req.asset))?;

        let (send_asset, recv_asset) = if req.send_bitcoins {
            (self.policy_asset, asset)
        } else {
            (asset, self.policy_asset)
        };
        let send_amount = req.send_amount;
        let recv_amount = req.recv_amount;

        let inputs = inputs
            .unspent_outputs
            .get(&send_asset)
            .cloned()
            .unwrap_or_default();

        let inputs = select_swap_inputs(inputs, send_amount)?
            .into_iter()
            .map(convert_to_swap_utxo)
            .collect();

        let swap_resp = send_request!(
            self,
            StartSwapClient,
            api::StartSwapClientRequest {
                price: req.price,
                asset,
                send_bitcoins: req.send_bitcoins,
                send_amount,
                recv_amount,
                inputs,
                recv_addr: recv_addr.address,
                change_addr: change_addr.address,
            }
        )?;

        self.active_swap = Some(ActiveSwap {
            order_id: swap_resp.order_id,
            send_asset,
            recv_asset,
            send_amount: send_amount as u64,
            recv_amount: recv_amount as u64,
        });

        Ok(())
    }

    fn process_instant_swap_request(&mut self, req: proto::to::SwapRequest) {
        info!(
            "start swap request: asset: {}, send_bitcoins: {}, send_amount: {}, recv_amount: {}, raw_price: {}",
            req.asset, &req.send_bitcoins, req.send_amount, req.recv_amount, req.price
        );

        let account_id = ACCOUNT_ID_REG;

        wallet::callback(
            account_id,
            self,
            |data| {
                let inputs = data.ses.get_utxos()?;
                let recv_addr = data.ses.get_receive_address()?;
                let change_addr = data.ses.get_change_address()?;
                Ok((inputs, recv_addr, change_addr))
            },
            move |data, res| {
                let res = match res {
                    Ok((inputs, recv_addr, change_addr)) => {
                        data.continue_swap_request(req, inputs, recv_addr, change_addr)
                    }
                    Err(err) => Err(err),
                };
                if let Err(err) = res {
                    error!("swap request failed: {}", err.to_string());
                    data.ui.send(proto::from::Msg::SwapFailed(err.to_string()));
                }
            },
        );
    }

    #[allow(dead_code)]
    fn send_rest_request(
        &self,
        request: http_rpc::RequestMsg,
        url: &str,
    ) -> Result<http_rpc::ResponseMsg, anyhow::Error> {
        info!("send swap request to {}", &url);
        let request = serde_json::to_value(&request).unwrap();
        let response = self.agent.post(url).send_json(request)?;
        if response.status() >= 400 && response.status() < 500 {
            let msg = serde_json::from_str::<http_rpc::ErrorMsg>(&response.into_string()?)?;
            bail!("{}", msg.error.message);
        }
        ensure!(
            response.status() == 200,
            "unexpected status: {}",
            response.status()
        );
        let msg = serde_json::from_str::<http_rpc::ResponseMsg>(&response.into_string()?)?;
        Ok(msg)
    }

    fn process_get_recv_address(&mut self, account: proto::Account) {
        let account_id = account.id;
        wallet::callback(
            account_id,
            self,
            |data| data.ses.get_receive_address(),
            move |data, res| match res {
                Ok(addr_info) => {
                    data.ui
                        .send(proto::from::Msg::RecvAddress(proto::from::RecvAddress {
                            addr: proto::Address {
                                addr: addr_info.address.to_string(),
                            },
                            account: get_account(account_id),
                        }));
                }
                Err(err) => data.show_message(&err.to_string()),
            },
        );
    }

    fn process_create_tx(&mut self, req: proto::CreateTx) {
        let account_id = req.account.id;
        wallet::callback(
            account_id,
            self,
            |data| data.ses.create_tx(&mut data.created_tx_cache, req),
            move |data, res| {
                let res = match res {
                    Ok(created_tx) => proto::from::create_tx_result::Result::CreatedTx(created_tx),
                    Err(err) => proto::from::create_tx_result::Result::ErrorMsg(err.to_string()),
                };
                data.ui.send(proto::from::Msg::CreateTxResult(
                    proto::from::CreateTxResult { result: Some(res) },
                ));
            },
        );
    }

    fn process_send_tx(&mut self, req: proto::to::SendTx) {
        let account_id = req.account.id;
        let assets = self.assets.clone();
        wallet::callback(
            account_id,
            self,
            move |data| {
                data.ses
                    .send_tx(&mut data.created_tx_cache, &req.id, &assets)
            },
            move |data, res| match res {
                Ok(txid) => {
                    data.sent_txhash = Some(txid);
                    data.update_sync_interval();
                }
                Err(err) => data
                    .ui
                    .send(proto::from::Msg::SendResult(proto::from::SendResult {
                        result: Some(proto::from::send_result::Result::ErrorMsg(err.to_string())),
                    })),
            },
        );
    }

    fn process_blinded_values(
        &mut self,
        proto::to::BlindedValues { txid }: proto::to::BlindedValues,
    ) {
        let txid = elements::Txid::from_str(&txid).expect("must be valid txid");

        let mut res_receivers = Vec::new();
        for wallet in self.wallets.values() {
            let txid = txid.clone();
            let res_receiver =
                wallet::send_wallet(wallet, move |data| data.ses.get_blinded_values(&txid));
            res_receivers.push(res_receiver);
        }

        let blinding_values = res_receivers
            .iter()
            .filter_map(|res_receiver| res_receiver.recv().expect("channel must be open").ok())
            .flatten()
            .collect::<Vec<_>>();

        let result = proto::from::blinded_values::Result::BlindedValues(blinding_values.join(","));
        let blinded_values = proto::from::BlindedValues {
            txid: txid.to_string(),
            result: Some(result),
        };
        self.ui
            .send(proto::from::Msg::BlindedValues(blinded_values));
    }

    // logins

    fn get_notif_callback(&self) -> NotifCallback {
        let msg_sender = self.msg_sender.clone();

        Box::new(move |account_id, details| {
            let result = msg_sender.send(Message::WalletNotif(account_id, details));
            if let Err(e) = result {
                error!("sending notification message failed: {}", e);
            }
        })
    }

    fn electrum_server(&self) -> ElectrumServer {
        match self.network_settings.selected.as_ref() {
            Some(proto::to::network_settings::Selected::Sideswap(_)) | None => {
                ElectrumServer::SideSwap
            }
            Some(proto::to::network_settings::Selected::SideswapCn(_)) => {
                ElectrumServer::SideSwapCn
            }
            Some(proto::to::network_settings::Selected::Blockstream(_)) => {
                ElectrumServer::Blockstream
            }
            Some(proto::to::network_settings::Selected::Custom(
                proto::to::network_settings::Custom {
                    host,
                    port,
                    use_tls,
                },
            )) => ElectrumServer::Custom {
                host: host.clone(),
                port: *port as u16,
                use_tls: *use_tls,
            },
        }
    }

    fn proxy(&self) -> Option<String> {
        match self.proxy_settings.proxy.as_ref() {
            Some(proto::to::proxy_settings::Proxy { host, port }) => Some(format!("{host}:{port}")),
            None => std::env::var("SOCKS_SERVER").ok(),
        }
    }

    fn try_register(
        &mut self,
        req: &proto::to::Login,
        cache_dir: &str,
    ) -> Result<settings::RegInfo, anyhow::Error> {
        let wallet_info = match req.wallet.as_ref().unwrap() {
            proto::to::login::Wallet::Mnemonic(mnemonic) => WalletInfo::Mnemonic(mnemonic.clone()),
            proto::to::login::Wallet::JadeId(jade_id) => {
                let name = format!("Jade {}", jade_id);
                let jade = self.jade_mng.open(jade_id)?;
                gdk_ses_impl::unlock_hw(self.env, &jade)?;

                let _status = jade.start_status(JadeStatus::MasterBlindingKey);
                let resp = jade.master_blinding_key()?;
                let master_blinding_key = hex::encode(resp);

                WalletInfo::HwData(gdk_ses::HwData {
                    env: self.env,
                    name,
                    jade: std::sync::Arc::new(jade),
                    master_blinding_key,
                    xpubs: BTreeMap::new(),
                })
            }
        };

        let info_amp = gdk_ses::LoginInfo {
            account_id: ACCOUNT_ID_AMP,
            env: self.env,
            cache_dir: cache_dir.to_owned(),
            wallet_info: wallet_info.clone(),
            single_sig: false,
            electrum_server: self.electrum_server(),
            proxy: self.proxy(),
        };

        let mut wallet_amp = gdk_ses_impl::start_processing(info_amp, None)?;

        wallet_amp.register()?;

        wallet_amp.login()?;

        let new_address = wallet_amp.get_receive_address()?;
        let multi_sig_service_xpub = new_address.service_xpub.expect("must be set");
        let multi_sig_user_path = new_address.user_path[0..3].to_vec();

        let jade_watch_only = if let Some(hw_data) = wallet_info.hw_data() {
            let username = format!("sswp_{}", hex::encode(rand::thread_rng().gen::<[u8; 10]>()));
            let password = hex::encode(rand::thread_rng().gen::<[u8; 16]>());

            wallet_amp.set_watch_only(&username, &password)?;

            let single_sig_account_path = self.env.d().network.d().single_sig_account_path.to_vec();

            let network = gdk_ses_impl::get_jade_network(hw_data.env);

            let root_xpub = hw_data.resolve_xpub(network, &XPUB_PATH_ROOT)?;
            let password_xpub = hw_data.resolve_xpub(network, &XPUB_PATH_PASS)?;
            let single_sig_account_xpub =
                hw_data.resolve_xpub(network, &single_sig_account_path)?;
            let multi_sig_user_xpub = hw_data.resolve_xpub(network, &multi_sig_user_path)?;

            Some(settings::WatchOnly {
                master_blinding_key: hw_data.master_blinding_key.clone(),

                root_xpub,
                single_sig_account_xpub,
                multi_sig_user_xpub,
                password_xpub,

                username,
                password,
            })
        } else {
            None
        };

        Ok(settings::RegInfo {
            jade_watch_only,
            multi_sig_service_xpub,
            multi_sig_user_path,
        })
    }

    fn try_process_login_request(&mut self, req: proto::to::Login) -> Result<(), anyhow::Error> {
        debug!("process login request...");

        let cache_dir = self.cache_path().to_str().unwrap().to_owned();

        let reg_info = match self.settings.reg_info_v3.clone() {
            Some(reg_info) => reg_info,
            None => {
                let reg_info = self.try_register(&req, &cache_dir)?;
                self.settings.reg_info_v3 = Some(reg_info.clone());
                self.save_settings();
                reg_info
            }
        };

        let wallet = req.wallet.ok_or_else(|| anyhow!("empty login request"))?;

        let wallet_info = match wallet {
            proto::to::login::Wallet::Mnemonic(mnemonic) => WalletInfo::Mnemonic(mnemonic),
            proto::to::login::Wallet::JadeId(jade_id) => {
                let name = format!("Jade {}", jade_id);
                let jade = self.jade_mng.open(&jade_id)?;
                let jade_watch_only = reg_info
                    .jade_watch_only
                    .as_ref()
                    .ok_or_else(|| anyhow!("jade_watch_only is not set"))?;

                let xpubs = BTreeMap::from([
                    (XPUB_PATH_ROOT.to_vec(), jade_watch_only.root_xpub),
                    (XPUB_PATH_PASS.to_vec(), jade_watch_only.password_xpub),
                    (
                        self.env.d().network.d().single_sig_account_path.to_vec(),
                        jade_watch_only.single_sig_account_xpub,
                    ),
                    (
                        reg_info.multi_sig_user_path.clone(),
                        jade_watch_only.multi_sig_user_xpub,
                    ),
                ]);

                WalletInfo::HwData(gdk_ses::HwData {
                    env: self.env,
                    name,
                    jade: std::sync::Arc::new(jade),
                    master_blinding_key: jade_watch_only.master_blinding_key.clone(),
                    xpubs,
                })
            }
        };

        let wallet_reg = {
            let info_reg = gdk_ses::LoginInfo {
                account_id: ACCOUNT_ID_REG,
                env: self.env,
                cache_dir: cache_dir.clone(),
                wallet_info: wallet_info.clone(),
                single_sig: true,
                electrum_server: self.electrum_server(),
                proxy: self.proxy(),
            };

            gdk_ses_impl::start_processing(info_reg, Some(self.get_notif_callback()))?
        };

        let wallet_amp_res = {
            let info_amp = gdk_ses::LoginInfo {
                account_id: ACCOUNT_ID_AMP,
                env: self.env,
                cache_dir,
                wallet_info: wallet_info.clone(),
                single_sig: false,
                electrum_server: self.electrum_server(),
                proxy: self.proxy(),
            };

            if let Some(watch_only) = reg_info.clone().jade_watch_only {
                gdk_ses_jade::start_processing(info_amp, self.get_notif_callback(), watch_only)
            } else {
                gdk_ses_impl::start_processing(info_amp, Some(self.get_notif_callback()))
            }
        };

        let single_sig_account_path = self.env.d().network.d().single_sig_account_path;
        let multi_sig_service_xpub =
            bip32::Xpub::from_str(&reg_info.multi_sig_service_xpub).expect("must be valid");
        let multi_sig_user_path = reg_info.multi_sig_user_path.clone();

        let (single_sig_account, multi_sig_user_xpub) =
            if let Some(watch_only) = reg_info.jade_watch_only.as_ref() {
                (
                    watch_only.single_sig_account_xpub,
                    watch_only.multi_sig_user_xpub,
                )
            } else {
                let mnemonic = wallet_info.mnemonic().expect("mnemonic must be set");
                let mnemonic = bip39::Mnemonic::parse(mnemonic)?;
                let seed = mnemonic.to_seed("");
                let bitcoin_network = self.env.d().network.d().bitcoin_network;
                let master_key = bip32::Xpriv::new_master(bitcoin_network, &seed).unwrap();

                let register_priv = master_key
                    .derive_priv(
                        SECP256K1,
                        &REGISTER_PATH
                            .iter()
                            .map(|num| ChildNumber::from(*num))
                            .collect::<Vec<_>>(),
                    )
                    .unwrap()
                    .private_key;
                let single_sig_xpriv = master_key
                    .derive_priv(
                        SECP256K1,
                        &single_sig_account_path
                            .iter()
                            .map(|num| ChildNumber::from(*num))
                            .collect::<Vec<_>>(),
                    )
                    .unwrap();
                let multi_sig_xpriv = master_key
                    .derive_priv(
                        SECP256K1,
                        &multi_sig_user_path
                            .iter()
                            .map(|num| ChildNumber::from(*num))
                            .collect::<Vec<_>>(),
                    )
                    .unwrap();

                let event_proofs = self
                    .settings
                    .event_proofs
                    .as_ref()
                    .map(|event_proofs| {
                        serde_json::from_value::<EventProofs>(event_proofs.clone())
                            .expect("must not fail")
                    })
                    .unwrap_or_else(|| {
                        EventProofs::new(self.env, register_priv.public_key(&SECP256K1))
                    });

                market_worker::set_xprivs(
                    self,
                    market_worker::Xprivs {
                        register_priv,
                        single_sig_xpriv,
                        multi_sig_xpriv,
                        event_proofs,
                        ack_succeed: false,
                        expected_nonce: None,
                    },
                );

                (
                    bip32::Xpub::from_priv(SECP256K1, &single_sig_xpriv),
                    bip32::Xpub::from_priv(SECP256K1, &multi_sig_xpriv),
                )
            };

        let xpubs = XPubInfo {
            single_sig_account,
            multi_sig_service_xpub,
            multi_sig_user_xpub,
        };

        let (command_sender, command_receiver) = mpsc::channel();
        self.wallets.insert(
            wallet_reg.login_info().account_id,
            Wallet {
                login_info: wallet_reg.login_info().clone(),
                command_sender,
                xpubs: xpubs.clone(),
            },
        );
        wallet::start(
            wallet_reg,
            command_receiver,
            self.wallet_event_callback.clone(),
        );

        match wallet_amp_res {
            Ok(wallet_amp) => {
                let (command_sender, command_receiver) = mpsc::channel();
                self.wallets.insert(
                    wallet_amp.login_info().account_id,
                    Wallet {
                        login_info: wallet_amp.login_info().clone(),
                        command_sender,
                        xpubs,
                    },
                );
                wallet::start(
                    wallet_amp,
                    command_receiver,
                    self.wallet_event_callback.clone(),
                );
            }
            Err(err) => {
                self.show_message(&format!("AMP connection failed: {err}"));
            }
        }

        if self.skip_wallet_sync() {
            info!("skip wallet sync delay");
            self.send_wallet_loaded();
        }

        self.send_ws_connect();

        Ok(())
    }

    fn process_login_request(&mut self, req: proto::to::Login) {
        debug!("process login request...");
        let res = self.try_process_login_request(req);
        let res = match res {
            Ok(()) => proto::from::login::Result::Success(proto::Empty {}),
            Err(err) => proto::from::login::Result::ErrorMsg(err.to_string()),
        };
        self.ui.send(proto::from::Msg::Login(proto::from::Login {
            result: Some(res),
        }));
    }

    fn restart_websocket(&mut self) {
        self.ws_connected = false;
        debug!("restart WS connection");
        self.ws_sender.send(ws::WrappedRequest::Disconnect).unwrap();
    }

    fn process_logout_request(&mut self) {
        debug!("process logout request...");

        self.wallets.clear();

        // TODO: Clear other fields
        self.sync_complete = false;
        self.wallet_loaded_sent = false;
        self.confirmed_txids.clear();
        self.unconfirmed_txids.clear();
        self.active_swap = None;
        self.succeed_swap = None;
        self.active_extern_peg = None;
        self.sent_txhash = None;
        self.peg_out_server_amounts = None;
        self.active_submits = BTreeMap::new();
        self.active_sign = None;
        self.used_addresses = Default::default();
        self.market = market_worker::new();

        self.settings = settings::Settings::default();
        self.save_settings();

        self.ui.send(proto::from::Msg::Logout(proto::Empty {}));

        // Required because new device_key is needed
        // TODO: Do something better when multi-wallets are added
        self.restart_websocket();
    }

    fn recreate_wallets(&mut self) {
        let mut wallets = std::mem::take(&mut self.wallets);

        for wallet in wallets.values_mut() {
            let mut new_login_info = wallet.login_info.clone();
            new_login_info.electrum_server = self.electrum_server();
            new_login_info.proxy = self.proxy();

            let wallet_res = gdk_ses_impl::start_processing(
                new_login_info.clone(),
                Some(self.get_notif_callback()),
            );
            match wallet_res {
                Ok(new_wallet) => {
                    let (command_sender, command_receiver) = mpsc::channel();
                    wallet::start(
                        new_wallet,
                        command_receiver,
                        self.wallet_event_callback.clone(),
                    );
                    wallet.login_info = new_login_info;
                    wallet.command_sender = command_sender;
                }
                Err(err) => {
                    self.show_message(&format!("changing network failed: {err}"));
                }
            }
        }

        self.wallets = wallets;
    }

    fn process_network_settings(&mut self, req: proto::to::NetworkSettings) {
        let electrum_server_old = self.electrum_server();
        self.network_settings = req;
        let electrum_server_new = self.electrum_server();
        if electrum_server_new != electrum_server_old {
            debug!("new electrum server: {electrum_server_new:?}");
            self.recreate_wallets();
        }
    }

    fn process_proxy_settings(&mut self, req: proto::to::ProxySettings) {
        let proxy_old = self.proxy();
        self.proxy_settings = req;
        let proxy_new = self.proxy();
        if proxy_new != proxy_old {
            debug!("new proxy: {proxy_new:?}");
            self.recreate_wallets();
            self.restart_websocket();
        }
    }

    fn process_encrypt_pin(&self, req: proto::to::EncryptPin) {
        let result = match pin::encrypt_pin(&req.mnemonic, &req.pin, self.proxy().as_ref()) {
            Ok(v) => {
                let data = serde_json::from_str::<pin::PinData>(&v).expect("must not fail");
                proto::from::encrypt_pin::Result::Data(proto::from::encrypt_pin::Data {
                    salt: data.salt,
                    encrypted_data: data.encrypted_data,
                    pin_identifier: data.pin_identifier,
                    hmac: data.hmac,
                })
            }
            Err(e) => proto::from::encrypt_pin::Result::Error(e.to_string()),
        };
        self.ui
            .send(proto::from::Msg::EncryptPin(proto::from::EncryptPin {
                result: Some(result),
            }));
    }

    fn process_decrypt_pin(&self, req: proto::to::DecryptPin) {
        // Workaround when UI sends an empty string
        let hmac = req.hmac.unwrap_or_default();
        let hmac = (!hmac.is_empty()).then_some(hmac);

        let details = pin::PinData {
            salt: req.salt,
            encrypted_data: req.encrypted_data,
            pin_identifier: req.pin_identifier,
            hmac,
        };
        let data = serde_json::to_string(&details).expect("must not fail");
        let result = match pin::decrypt_pin(&data, &req.pin, self.proxy().as_ref()) {
            Ok(v) => proto::from::decrypt_pin::Result::Mnemonic(v),
            Err(e) => {
                let error_code = match &e {
                    pin::Error::WrongPin => proto::from::decrypt_pin::ErrorCode::WrongPin,
                    pin::Error::NetworkError(_) => {
                        proto::from::decrypt_pin::ErrorCode::NetworkError
                    }
                    pin::Error::InvalidData(_) => proto::from::decrypt_pin::ErrorCode::InvalidData,
                };
                proto::from::decrypt_pin::Result::Error(proto::from::decrypt_pin::Error {
                    error_msg: e.to_string(),
                    error_code: error_code.into(),
                })
            }
        };
        self.ui
            .send(proto::from::Msg::DecryptPin(proto::from::DecryptPin {
                result: Some(result),
            }));
    }

    fn process_app_state(&mut self, req: proto::to::AppState) {
        self.app_active = req.active;
        if req.active {
            self.check_ws_connection();
        }
        self.update_amp_connection();
    }

    fn process_peg_status(&mut self, status: api::PegStatus) {
        let pegs = status
            .list
            .iter()
            .map(|tx| get_peg_item(&status, tx))
            .collect::<Vec<_>>();

        let mut queue_msgs = Vec::new();

        if let Some(peg) = self.active_extern_peg.as_ref() {
            if peg.order_id == status.order_id {
                if let Some(first_peg) = status.list.first() {
                    let peg_item = get_peg_item(&status, first_peg);
                    queue_msgs.push(proto::from::Msg::SwapSucceed(peg_item));
                    self.active_extern_peg = None;
                }
            }
        }

        self.ui
            .send(proto::from::Msg::UpdatedPegs(proto::from::UpdatedPegs {
                order_id: status.order_id.to_string(),
                items: pegs,
            }));

        for msg in queue_msgs.into_iter() {
            self.ui.send(msg);
        }
    }

    fn process_asset_details_response(&mut self, msg: api::AssetDetailsResponse) {
        let stats = msg.chain_stats.map(|v| proto::from::asset_details::Stats {
            burned_amount: v.burned_amount,
            issued_amount: v.issued_amount,
            offline_amount: v.offline_amount.unwrap_or_default(),
            has_blinded_issuances: v.has_blinded_issuances,
        });
        let from = proto::from::AssetDetails {
            asset_id: msg.asset_id.to_string(),
            stats,
            chart_url: msg.chart_url,
        };
        self.ui.send(proto::from::Msg::AssetDetails(from));
    }

    fn process_set_memo(&mut self, req: proto::to::SetMemo) {
        wallet::callback(
            req.account.id,
            self,
            move |data| data.ses.set_memo(&req.txid, &req.memo),
            move |_data, res| {
                if let Err(err) = res {
                    log::error!("setting memo failed: {err}");
                }
            },
        );
    }

    fn try_load_all_addresses(
        &mut self,
        account: &proto::Account,
    ) -> Result<Vec<AddressInfo>, anyhow::Error> {
        if account.id == ACCOUNT_ID_AMP {
            self.refresh_amp_addresses()?;

            // Loading multi-sig addresses is slow, use locally cached list
            let addresses = self
                .settings
                .amp_prev_addrs_v2
                .as_ref()
                .map(|data| data.list.clone())
                .unwrap_or_default();

            Ok(addresses)
        } else {
            let wallet = self.get_wallet(account.id)?;

            // Loading single-sig addresses is fast, load them from GDK
            let mut list = load_all_addresses(wallet, false, None)?.1;
            let mut internal = load_all_addresses(wallet, true, None)?.1;
            list.append(&mut internal);

            Ok(list)
        }
    }

    fn try_process_load_utxos(
        &mut self,
        account: &proto::Account,
    ) -> Result<Vec<proto::from::load_utxos::Utxo>, anyhow::Error> {
        // Load utxos before loading address (to prevent a race)
        let inputs = wallet::call(account.id, self, |data| data.ses.get_utxos())?
            .unspent_outputs
            .into_values()
            .flat_map(|utxos| utxos.into_iter())
            .collect::<Vec<_>>();

        let addresses = self.try_load_all_addresses(account)?;

        #[derive(PartialEq, Eq, PartialOrd, Ord)]
        struct AddressPointer {
            pointer: u32,
            is_internal: bool,
        }

        let addresses = addresses
            .into_iter()
            .map(|address| {
                (
                    AddressPointer {
                        pointer: address.pointer,
                        is_internal: address.is_internal.unwrap_or_default(),
                    },
                    address,
                )
            })
            .collect::<BTreeMap<_, _>>();

        let mut utxos = Vec::new();
        for input in inputs {
            let address = addresses
                .get(&AddressPointer {
                    pointer: input.pointer,
                    is_internal: input.is_internal,
                })
                .ok_or_else(|| {
                    anyhow!("address {}/{} not found", input.pointer, input.is_internal)
                })?;

            utxos.push(proto::from::load_utxos::Utxo {
                txid: input.txhash.to_string(),
                vout: input.vout,
                asset_id: input.asset_id.to_string(),
                amount: input.satoshi,
                address: address.address.to_string(),
                is_internal: input.is_internal,
                is_confidential: input.is_confidential.unwrap_or_default(),
            });
        }

        Ok(utxos)
    }

    fn process_load_utxos(&mut self, account: proto::Account) {
        let result = self.try_process_load_utxos(&account);
        let (utxos, error_msg) = match result {
            Ok(utxos) => (utxos, None),
            Err(e) => {
                error!("loading utxos failed: {}", e);
                (Vec::new(), Some(e.to_string()))
            }
        };
        self.ui
            .send(proto::from::Msg::LoadUtxos(proto::from::LoadUtxos {
                account,
                utxos,
                error_msg,
            }));
    }

    fn try_process_load_addresses(
        &mut self,
        account: &proto::Account,
    ) -> Result<Vec<proto::from::load_addresses::Address>, anyhow::Error> {
        let addresses = self.try_load_all_addresses(account)?;

        let addresses = addresses
            .into_iter()
            .map(|addr| proto::from::load_addresses::Address {
                address: addr.address.to_string(),
                unconfidential_address: addr.unconfidential_address.to_string(),
                index: addr.pointer,
                is_internal: addr.is_internal.unwrap_or_default(),
            })
            .collect();

        Ok(addresses)
    }

    fn process_load_addresses(&mut self, account: proto::Account) {
        let result = self.try_process_load_addresses(&account);
        let (addresses, error_msg) = match result {
            Ok(utxos) => (utxos, None),
            Err(e) => {
                error!("loading addresses failed: {}", e);
                (Vec::new(), Some(e.to_string()))
            }
        };
        self.ui.send(proto::from::Msg::LoadAddresses(
            proto::from::LoadAddresses {
                account,
                addresses,
                error_msg,
            },
        ));
    }

    fn process_update_push_token(&mut self, req: proto::to::UpdatePushToken) {
        self.push_token = Some(req.token);
        self.update_push_token();
    }

    fn find_own_address_info(
        &mut self,
        addr: &elements::Address,
    ) -> Result<AddressInfo, anyhow::Error> {
        let addr_info = self
            .settings
            .amp_prev_addrs_v2
            .as_ref()
            .and_then(|data| data.list.iter().find(|info| info.address == *addr))
            .cloned();
        if let Some(addr_info) = addr_info {
            return Ok(addr_info);
        }

        self.refresh_amp_addresses()?;

        let addr_info = self
            .settings
            .amp_prev_addrs_v2
            .as_ref()
            .and_then(|data| data.list.iter().find(|info| info.address == *addr))
            .cloned();

        addr_info.ok_or_else(|| anyhow!("Not found"))
    }

    fn refresh_amp_addresses(&mut self) -> Result<(), anyhow::Error> {
        let last_old_pointer = self
            .settings
            .amp_prev_addrs_v2
            .as_ref()
            .map(|v| v.last_pointer);
        let wallet = self.get_wallet(ACCOUNT_ID_AMP)?;
        let (last_new_pointer, new_list) = load_all_addresses(wallet, false, last_old_pointer)?;

        let amp_prev_addrs = self
            .settings
            .amp_prev_addrs_v2
            .get_or_insert_with(Default::default);
        amp_prev_addrs.last_pointer = last_new_pointer;
        amp_prev_addrs.list.extend(new_list);
        self.save_settings();
        Ok(())
    }

    fn process_asset_details(&mut self, req: proto::AssetId) {
        self.send_request_msg(api::Request::AssetDetails(api::AssetDetailsRequest {
            asset_id: AssetId::from_str(&req.asset_id).unwrap(),
        }));
    }

    fn process_subscribe_price_stream(&mut self, req: proto::to::SubscribePriceStream) {
        let req = api::SubscribePriceStreamRequest {
            subscribe_id: None,
            asset: AssetId::from_str(&req.asset_id).unwrap(),
            send_bitcoins: req.send_bitcoins,
            send_amount: req.send_amount,
            recv_amount: req.recv_amount,
        };
        if self.subscribed_price_stream.as_ref() != Some(&req) {
            self.subscribed_price_stream = Some(req.clone());
            self.send_request_msg(api::Request::SubscribePriceStream(req));
        }
    }

    fn process_unsubscribe_price_stream(&mut self) {
        if self.subscribed_price_stream.is_some() {
            self.subscribed_price_stream = None;
            self.send_request_msg(api::Request::UnsubscribePriceStream(
                api::UnsubscribePriceStreamRequest { subscribe_id: None },
            ));
        }
    }

    fn process_portfolio_prices(&mut self) {
        self.make_async_request(api::Request::PortfolioPrices(None), move |data, res| {
            if let Ok(api::Response::PortfolioPrices(resp)) = res {
                let prices_usd = resp
                    .prices_usd
                    .into_iter()
                    .map(|(asset_id, price)| (asset_id.to_string(), price))
                    .collect();
                data.ui.send(proto::from::Msg::PortfolioPrices(
                    proto::from::PortfolioPrices { prices_usd },
                ));
            }
        });
    }

    fn process_conversion_rates(&mut self) {
        self.make_async_request(api::Request::ConversionRates(None), move |data, res| {
            if let Ok(api::Response::ConversionRates(resp)) = res {
                let usd_conversion_rates = resp.usd_conversion_rates.into_iter().collect();
                data.ui.send(proto::from::Msg::ConversionRates(
                    proto::from::ConversionRates {
                        usd_conversion_rates,
                    },
                ));
            }
        });
    }

    fn process_update_price_stream(&self, msg: api::SubscribePriceStreamResponse) {
        let msg = proto::from::UpdatePriceStream {
            asset_id: msg.asset.to_string(),
            send_bitcoins: msg.send_bitcoins,
            send_amount: msg.send_amount,
            recv_amount: msg.recv_amount,
            price: msg.price,
            error_msg: msg.error_msg,
        };
        self.ui.send(proto::from::Msg::UpdatePriceStream(msg));
    }

    fn blinded_swap_client_continue(
        &mut self,
        order_id: OrderId,
        pset: String,
    ) -> Result<(), anyhow::Error> {
        send_request!(
            self,
            SignedSwapClient,
            api::SignedSwapClientRequest { order_id, pset }
        )?;
        Ok(())
    }

    fn try_process_blinded_swap_client(
        &mut self,
        msg: api::BlindedSwapClientNotification,
    ) -> Result<(), anyhow::Error> {
        let account_id = ACCOUNT_ID_REG;

        let active_swap = self
            .active_swap
            .as_ref()
            .ok_or_else(|| anyhow!("unexpected swap request"))?;
        ensure!(active_swap.order_id == msg.order_id);

        let amounts = swaps::Amounts {
            send_asset: active_swap.send_asset,
            recv_asset: active_swap.recv_asset,
            send_amount: active_swap.send_amount,
            recv_amount: active_swap.recv_amount,
        };

        let send_amp = self.amp_assets.contains(&amounts.send_asset);
        let recv_amp = self.amp_assets.contains(&amounts.recv_asset);
        ensure!(!send_amp && !recv_amp, "AMP assets are not allowed");

        let assets = self.assets.clone();
        let order_id = msg.order_id;
        wallet::callback(
            account_id,
            self,
            move |data| {
                data.ses
                    .verify_and_sign_pset(&amounts, &msg.pset, &[], &assets)
            },
            move |data, res| {
                let res = match res {
                    Ok(pset) => data.blinded_swap_client_continue(order_id, pset),
                    Err(err) => Err(err),
                };
                if let Err(err) = res {
                    error!("instant swap failed: {}", err.to_string());
                    data.ui.send(proto::from::Msg::SwapFailed(err.to_string()));
                }
            },
        );

        Ok(())
    }

    fn process_blinded_swap_client(&mut self, msg: api::BlindedSwapClientNotification) {
        let res = self.try_process_blinded_swap_client(msg);
        if let Err(err) = res {
            error!("processing blinded swap failed: {}", err.to_string());
            self.ui.send(proto::from::Msg::SwapFailed(err.to_string()));
        }
    }

    fn process_instant_swap_done(&mut self, msg: api::SwapDoneNotification) {
        match self.active_swap.as_ref() {
            Some(v) if v.order_id == msg.order_id => v,
            _ => return,
        };
        let _active_swap = self.active_swap.take().unwrap();

        let error = match msg.status {
            api::SwapDoneStatus::Success => None,
            api::SwapDoneStatus::ClientError => Some("Transaction not signed in time"),
            api::SwapDoneStatus::DealerError => Some("Unexpected dealer error"),
            api::SwapDoneStatus::ServerError => Some("Unexpected server error"),
        };
        match (error, msg.txid) {
            (None, Some(txid)) => {
                debug!("instant swap succeed, txid: {}", txid);
                self.succeed_swap = Some(txid);
                self.update_sync_interval();
            }
            (Some(e), None) => {
                self.ui.send(proto::from::Msg::SwapFailed(e.to_owned()));
            }
            _ => {
                self.ui
                    .send(proto::from::Msg::SwapFailed("server error".to_owned()));
            }
        };
    }

    fn process_local_message(&mut self, msg: api::LocalMessageNotification) {
        self.ui
            .send(proto::from::Msg::LocalMessage(proto::from::LocalMessage {
                title: msg.title,
                body: msg.body,
            }));
    }

    fn process_new_asset(&mut self, msg: api::NewAssetNotification) {
        self.register_assets_with_gdk_icons(vec![msg.asset]);
    }

    // message processing

    fn send_request_msg(&self, request: api::Request) -> api::RequestId {
        let request_id = next_request_id();
        self.ws_sender
            .send(ws::WrappedRequest::Request(api::RequestMessage::Request(
                request_id.clone(),
                request,
            )))
            .unwrap();
        request_id
    }

    fn send_request(&self, request: api::Request) -> Result<api::Response, CallError> {
        // Blocking requests use string ids
        let active_id = sideswap_common::ws::next_id().to_string();
        self.ws_sender
            .send(ws::WrappedRequest::Request(api::RequestMessage::Request(
                api::RequestId::String(active_id.clone()),
                request,
            )))
            .unwrap();

        let started = std::time::Instant::now();
        loop {
            let resp = self.resp_receiver.recv_timeout(SERVER_REQUEST_POLL_PERIOD);
            match resp {
                Ok(ServerResp(req_id, result)) => {
                    if req_id != active_id {
                        warn!("discard old response: {:?}", result);
                        continue;
                    }
                    return result.map_err(CallError::Backend);
                }
                Err(_) => {
                    let spent_time = std::time::Instant::now().duration_since(started);
                    if spent_time > SERVER_REQUEST_TIMEOUT {
                        error!("request timeout");
                        abort!(CallError::Timeout);
                    }
                }
            };
        }
    }

    fn make_async_request(
        &mut self,
        req: api::Request,
        resp: impl FnOnce(&mut Data, Result<api::Response, api::Error>) + 'static,
    ) {
        if !self.ws_connected {
            resp(
                self,
                Err(api::Error {
                    code: api::ErrorCode::ServerError,
                    message: "Not connected".to_owned(),
                }),
            );
            return;
        }
        let request_id = next_request_id();
        self.ws_sender
            .send(ws::WrappedRequest::Request(api::RequestMessage::Request(
                request_id.clone(),
                req,
            )))
            .unwrap();
        self.async_requests.insert(request_id, Box::new(resp));
    }

    fn show_message(&self, text: &str) {
        info!("show message: {}", text);
        let msg = proto::from::ShowMessage {
            text: text.to_owned(),
        };
        self.ui.send(proto::from::Msg::ShowMessage(msg));
    }

    fn check_ws_connection(&mut self) {
        debug!("check ws connection");
        if !self.ws_connected {
            debug!("ws is not connected, send reconnect hint");
            let _ = self.ws_hint.send(());
            return;
        }
        let ping_response = send_request!(self, Ping, None);
        if ping_response.is_err() {
            debug!("WS connection check failed, reconnecting...");
            self.restart_websocket();
        }
    }

    fn check_amp_connection(&mut self) {
        if !self.amp_connected {
            return;
        }

        wallet::callback(
            ACCOUNT_ID_AMP,
            self,
            |data| {
                if data.ses.get_previous_addresses(None, false).is_ok() {
                    debug!("AMP connection check succeed");
                    return Ok(true);
                }
                warn!("AMP connection check failed");
                data.ses.disconnect();
                data.ses.connect();
                Ok(false)
            },
            move |data, res| match res {
                Ok(is_connected) => {
                    data.amp_connected = is_connected;

                    if is_connected {
                        replace_timers(
                            data,
                            AMP_CONNECTION_CHECK_PERIOD,
                            TimerEvent::AmpConnectionCheck,
                        );
                    }
                }
                Err(err) => {
                    log::error!("AMP connection check failed unexpectedly: {err}");
                }
            },
        );
    }

    fn send_ws_connect(&self) {
        // TODO: Add a new env type
        let (host, port, use_tls) = if self.network_settings.selected.as_ref()
            == Some(&proto::to::network_settings::Selected::SideswapCn(
                proto::Empty {},
            )) {
            ("cn.sideswap.io".to_owned(), 443, true)
        } else {
            let env_data = self.env.d();
            (env_data.host.to_owned(), env_data.port, env_data.use_tls)
        };

        self.ws_sender
            .send(ws::WrappedRequest::Connect {
                host,
                port,
                use_tls,
                proxy: self.proxy(),
            })
            .unwrap();
    }

    fn update_amp_connection(&mut self) {
        // let amp_active = self.app_active || self.pending_amp_sign_requests();
        let amp_active = self.app_active;

        if self.amp_active == amp_active {
            return;
        }
        self.amp_active = amp_active;

        wallet::callback(
            ACCOUNT_ID_AMP,
            self,
            move |data| {
                if amp_active {
                    log::debug!("request AMP connect");
                    data.ses.connect();
                } else {
                    log::debug!("request AMP disconnect");
                    data.ses.disconnect();
                }
                Ok(())
            },
            move |_data, _res| {},
        );
    }

    fn process_push_message(&mut self, req: String, _pending_sign: Option<mpsc::Sender<()>>) {
        let _msg = match serde_json::from_str::<fcm_models::FcmMessage>(&req) {
            Ok(v) => v,
            Err(e) => {
                error!("parsing FCM message failed: {}", e);
                return;
            }
        };
    }

    fn skip_wallet_sync(&self) -> bool {
        true
    }

    fn process_ui(&mut self, msg: ffi::ToMsg) {
        debug!(
            "from ui: {}",
            serde_json::to_string(&redact_to_msg(msg.clone())).unwrap()
        );
        match msg {
            proto::to::Msg::Login(req) => self.process_login_request(req),
            proto::to::Msg::Logout(_) => self.process_logout_request(),
            proto::to::Msg::NetworkSettings(req) => self.process_network_settings(req),
            proto::to::Msg::ProxySettings(req) => self.process_proxy_settings(req),
            proto::to::Msg::EncryptPin(req) => self.process_encrypt_pin(req),
            proto::to::Msg::DecryptPin(req) => self.process_decrypt_pin(req),
            proto::to::Msg::AppState(req) => self.process_app_state(req),
            proto::to::Msg::PushMessage(req) => self.process_push_message(req, None),
            proto::to::Msg::PegInRequest(_) => self.process_pegin_request(),
            proto::to::Msg::PegOutAmount(req) => self.process_pegout_amount(req),
            proto::to::Msg::PegOutRequest(req) => self.process_pegout_request(req),
            proto::to::Msg::SwapRequest(req) => self.process_instant_swap_request(req),
            proto::to::Msg::GetRecvAddress(req) => self.process_get_recv_address(req),
            proto::to::Msg::CreateTx(req) => self.process_create_tx(req),
            proto::to::Msg::SendTx(req) => self.process_send_tx(req),
            proto::to::Msg::BlindedValues(req) => self.process_blinded_values(req),
            proto::to::Msg::SetMemo(req) => self.process_set_memo(req),
            proto::to::Msg::LoadUtxos(req) => self.process_load_utxos(req),
            proto::to::Msg::LoadAddresses(req) => self.process_load_addresses(req),
            proto::to::Msg::UpdatePushToken(req) => self.process_update_push_token(req),
            proto::to::Msg::AssetDetails(req) => self.process_asset_details(req),
            proto::to::Msg::SubscribePriceStream(req) => self.process_subscribe_price_stream(req),
            proto::to::Msg::UnsubscribePriceStream(_) => self.process_unsubscribe_price_stream(),
            proto::to::Msg::PortfolioPrices(_) => self.process_portfolio_prices(),
            proto::to::Msg::ConversionRates(_) => self.process_conversion_rates(),
            proto::to::Msg::JadeRescan(_) => self.process_jade_rescan_request(),
            proto::to::Msg::GaidStatus(msg) => self.process_gaid_status_req(msg),
            proto::to::Msg::MarketSubscribe(msg) => market_worker::market_subscribe(self, msg),
            proto::to::Msg::MarketUnsubscribe(msg) => market_worker::market_unsubscribe(self, msg),
            proto::to::Msg::OrderSubmit(msg) => market_worker::order_submit(self, msg),
            proto::to::Msg::OrderEdit(msg) => market_worker::order_edit(self, msg),
            proto::to::Msg::OrderCancel(msg) => market_worker::order_cancel(self, msg),
            proto::to::Msg::StartQuotes(msg) => market_worker::start_quotes(self, msg, None, None),
            proto::to::Msg::StartOrder(msg) => market_worker::start_order(self, msg),
            proto::to::Msg::StopQuotes(msg) => market_worker::stop_quotes(self, msg),
            proto::to::Msg::AcceptQuote(msg) => market_worker::accept_quote(self, msg),
            proto::to::Msg::ChartsSubscribe(msg) => market_worker::charts_subscribe(self, msg),
            proto::to::Msg::ChartsUnsubscribe(msg) => market_worker::charts_unsubscribe(self, msg),
            proto::to::Msg::LoadHistory(msg) => market_worker::load_history(self, msg),
        }
    }

    fn process_ws_resp(&mut self, resp: api::Response) {
        match resp {
            api::Response::Ping(_) => {}
            api::Response::ServerStatus(_) => {}
            api::Response::Assets(_) => {}
            api::Response::AmpAssets(_) => {}
            api::Response::PegFee(_) => {}
            api::Response::Peg(_) => {}
            api::Response::PegStatus(msg) => self.process_peg_status(msg),
            api::Response::PegReturnAddress(_) => {}
            api::Response::PriceUpdateBroadcast(_) => {}
            api::Response::PriceUpdateSubscribe(_) => {}
            api::Response::LoginClient(_) => {}
            api::Response::LoginDealer(_) => {}
            api::Response::VerifyDevice(_) => {}
            api::Response::RegisterDevice(_) => {}
            api::Response::RegisterAddresses(_) => {}
            api::Response::UpdatePushToken(_) => {}
            api::Response::LoadPrices(_) => {}
            api::Response::CancelPrices(_) => {}
            api::Response::PortfolioPrices(_) => {}
            api::Response::ConversionRates(_) => {}
            api::Response::Submit(_) => {}
            api::Response::Edit(_) => {}
            api::Response::Cancel(_) => {}
            api::Response::Login(_) => {}
            api::Response::Subscribe(_) => {}
            api::Response::Unsubscribe(_) => {}
            api::Response::Link(_) => {}
            api::Response::PsetMaker(_) => {}
            api::Response::PsetTaker(_) => {}
            api::Response::Sign(_) => {}
            api::Response::GetSign(_) => {}
            api::Response::ResolveGaid(_) => {}
            api::Response::GaidStatus(_) => {}
            api::Response::AssetDetails(msg) => self.process_asset_details_response(msg),
            api::Response::BroadcastPriceStream(_) => {}
            api::Response::SubscribePriceStream(msg) => self.process_update_price_stream(msg),
            api::Response::UnsubscribePriceStream(_) => {}
            api::Response::StartSwapWeb(_) => {}
            api::Response::StartSwapClient(_) => {}
            api::Response::StartSwapDealer(_) => {}
            api::Response::SignedSwapClient(_) => {}
            api::Response::SignedSwapDealer(_) => {}
            api::Response::MarketDataSubscribe(_) => {}
            api::Response::MarketDataUnsubscribe(_) => {}
            api::Response::SwapPrices(_) => {}
            api::Response::Market(resp) => market_worker::process_resp(self, resp),
        }
    }

    fn process_ws_msg(&mut self, msg: api::ResponseMessage) {
        match msg {
            api::ResponseMessage::Response(Some(req_id), res) => {
                if let Some(callback) = self.async_requests.remove(&req_id) {
                    callback(self, res);
                } else {
                    match res {
                        Ok(resp) => {
                            self.process_ws_resp(resp);
                        }
                        Err(err) => {
                            log::error!("ws request failed: {err}, id: {req_id:?}");
                        }
                    }
                }
            }
            api::ResponseMessage::Response(None, res) => {
                log::error!("ws request id is not set: {res:?}");
            }
            api::ResponseMessage::Notification(msg) => self.process_ws_notification(msg),
        }
    }

    fn process_ws(&mut self, resp: ws::WrappedResponse) {
        match resp {
            ws::WrappedResponse::Connected => self.process_ws_connected(),
            ws::WrappedResponse::Disconnected => self.process_ws_disconnected(),
            ws::WrappedResponse::Response(msg) => self.process_ws_msg(msg),
        }
    }

    fn process_ws_notification(&mut self, notification: api::Notification) {
        match notification {
            api::Notification::Market(notif) => market_worker::process_notif(self, notif),
            api::Notification::PegStatus(status) => self.process_peg_status(status),
            api::Notification::ServerStatus(resp) => self.process_server_status(resp),
            api::Notification::PriceUpdate(msg) => self.process_price_update(msg),
            api::Notification::Sign(_) => {}
            api::Notification::Complete(_) => {}
            api::Notification::OrderCreated(_) => {}
            api::Notification::OrderRemoved(_) => {}
            api::Notification::UpdatePrices(_) => {}
            api::Notification::UpdatePriceStream(msg) => self.process_update_price_stream(msg),
            api::Notification::BlindedSwapClient(msg) => self.process_blinded_swap_client(msg),
            api::Notification::SwapDone(msg) => self.process_instant_swap_done(msg),
            api::Notification::LocalMessage(msg) => self.process_local_message(msg),
            api::Notification::NewAsset(msg) => self.process_new_asset(msg),
            api::Notification::MarketDataUpdate(_) => {}
            api::Notification::StartSwapDealer(_) => {}
            api::Notification::BlindedSwapDealer(_) => {}
            api::Notification::NewSwapPrice(_) => {}
        }
    }

    fn add_missing_gdk_assets(&mut self, asset_ids: &[AssetId]) {
        // Do not replace existing asset information (like market_type)
        let new_asset_ids = asset_ids
            .iter()
            .copied()
            .filter(|asset_id| !self.assets.contains_key(asset_id))
            .collect::<Vec<_>>();
        if !new_asset_ids.is_empty() {
            let new_assets = self
                .load_gdk_assets(&new_asset_ids)
                .ok()
                .unwrap_or_default();
            for asset in new_assets {
                self.register_asset(asset);
            }
        }
    }

    pub fn register_asset(&mut self, asset: api::Asset) {
        let asset_id = asset.asset_id;
        let unregistered = asset.asset_id != self.policy_asset && asset.domain.is_none();
        let amp_asset_restrictions =
            asset
                .amp_asset_restrictions
                .clone()
                .map(|info| proto::AmpAssetRestrictions {
                    allowed_countries: info.allowed_countries.unwrap_or_default(),
                });
        let asset_copy = proto::Asset {
            asset_id: asset.asset_id.to_string(),
            name: asset.name.clone(),
            ticker: asset.ticker.0.clone(),
            icon: asset
                .icon
                .clone()
                .unwrap_or_else(|| b64::encode(DEFAULT_ICON)),
            precision: u32::from(asset.precision.value()),
            swap_market: asset.market_type == Some(MarketType::Stablecoin),
            amp_market: asset.market_type == Some(MarketType::Amp),
            domain: asset.domain.clone(),
            domain_agent: asset.domain_agent.clone(),
            domain_agent_link: asset.domain_agent_link.clone(),
            unregistered,
            instant_swaps: asset.instant_swaps.unwrap_or(false),
            always_show: asset.always_show,
            amp_asset_restrictions,
            payjoin: asset.payjoin,
        };

        self.assets.insert(asset_id, asset);

        self.ui.send(proto::from::Msg::NewAsset(asset_copy));
    }

    pub fn register_assets_with_gdk_icons(&mut self, mut assets: api::Assets) {
        let asset_ids = assets
            .iter()
            .map(|asset| asset.asset_id)
            .collect::<Vec<_>>();
        let gdk_assets = self.load_gdk_assets(&asset_ids).ok().unwrap_or_default();
        let gdk_icons = gdk_assets
            .into_iter()
            .map(|asset| (asset.asset_id, asset.icon))
            .collect::<BTreeMap<_, _>>();

        for asset in assets.iter_mut() {
            asset.icon = gdk_icons.get(&asset.asset_id).cloned().flatten();
        }

        for asset in assets {
            self.register_asset(asset);
        }
    }

    pub fn save_assets_cache(&self, assets: &[api::Asset]) -> Result<(), anyhow::Error> {
        // Save asset cache so that deleting default assets work without releasing new app version
        let cache = AssetsCache {
            git_commit_hash: GIT_COMMIT_HASH.to_owned(),
            assets: assets
                .iter()
                .filter(|asset| asset.always_show.unwrap_or_default())
                .cloned()
                .collect(),
        };
        let data = serde_json::to_string(&cache).expect("must not fail");
        std::fs::write(self.assets_cache_path_tmp(), data)?;
        std::fs::rename(self.assets_cache_path_tmp(), self.assets_cache_path())?;
        log::debug!("saved {} to assets cache", cache.assets.len());
        Ok(())
    }

    pub fn load_assets_cache(&self) -> Result<Vec<api::Asset>, anyhow::Error> {
        let data = std::fs::read(self.assets_cache_path())?;
        let cache = serde_json::from_slice::<AssetsCache>(&data)?;
        // Ignore asset cache from older builds, it can contain outdated data
        ensure!(cache.git_commit_hash == GIT_COMMIT_HASH);
        log::debug!("loaded {} from assets cache", cache.assets.len());
        Ok(cache.assets)
    }

    pub fn load_default_assets(&mut self) {
        let assets = self.load_assets_cache().unwrap_or_else(|err| {
            log::debug!("loading assets cache failed: {err}, use default cache instead");
            let data = match self.env.d().network {
                Network::Liquid => include_str!("../data/assets.json"),
                Network::LiquidTestnet => include_str!("../data/assets-testnet.json"),
            };
            serde_json::from_str::<api::Assets>(data).expect("must not fail")
        });
        self.register_assets_with_gdk_icons(assets);
    }

    // pegs monitoring

    fn start_peg_monitoring(&self, peg: &settings::Peg) {
        let request = match peg.dir {
            settings::PegDir::In => api::Request::PegStatus(api::PegStatusRequest {
                order_id: peg.order_id,
                peg_in: None,
            }),
            settings::PegDir::Out => api::Request::PegStatus(api::PegStatusRequest {
                order_id: peg.order_id,
                peg_in: None,
            }),
        };
        self.send_request_msg(request);
    }

    fn add_peg_monitoring(&mut self, order_id: OrderId, dir: settings::PegDir) {
        let peg = settings::Peg { order_id, dir };
        if self.ws_connected {
            self.start_peg_monitoring(&peg);
        }
        self.settings.pegs.get_or_insert_with(Vec::new).push(peg);
        self.save_settings();
    }

    fn update_push_token(&mut self) {
        if let (Some(push_token), true, Some(device_key)) = (
            &self.push_token,
            self.ws_connected,
            &self.settings.device_key,
        ) {
            self.make_async_request(
                api::Request::UpdatePushToken(api::UpdatePushTokenRequest {
                    device_key: device_key.clone(),
                    push_token: push_token.clone(),
                }),
                move |_data, res| {
                    if let Err(e) = res {
                        error!("updating push token failed: {}", e.to_string());
                    }
                },
            );
        };
    }

    fn update_used_addresses(
        &mut self,
        account_id: AccountId,
        transactions: &[models::Transaction],
    ) {
        let pointer_external = transactions
            .iter()
            .map(|tx| tx.max_pointer_external)
            .max()
            .unwrap_or_default();
        let pointer_internal = transactions
            .iter()
            .map(|tx| tx.max_pointer_internal)
            .max()
            .unwrap_or_default();
        if account_id == ACCOUNT_ID_REG {
            self.used_addresses.single_sig = [pointer_external, pointer_internal];
        } else if account_id == ACCOUNT_ID_AMP {
            self.used_addresses.multi_sig = pointer_external;
        }
        self.update_address_registrations();
    }

    fn update_address_registrations(&mut self) {
        let count = 100;

        for is_internal in [false, true] {
            if let (true, Some(device_key), Some(wallet)) = (
                self.ws_connected,
                &self.settings.device_key,
                self.wallets.get(&ACCOUNT_ID_REG),
            ) {
                let first = self.settings.single_sig_registered[is_internal as usize];
                let last = self.used_addresses.single_sig[is_internal as usize] + count;

                let addresses = (first..last)
                    .map(|pointer| {
                        derive_single_sig_address(
                            &wallet.xpubs.single_sig_account,
                            self.env.d().network,
                            is_internal,
                            pointer,
                        )
                        .to_string()
                    })
                    .collect::<Vec<_>>();

                self.make_async_request(
                    api::Request::RegisterAddresses(api::RegisterAddressesRequest {
                        device_key: device_key.clone(),
                        addresses,
                    }),
                    move |data, res| match res {
                        Ok(_) => {
                            data.settings.single_sig_registered.as_mut()[is_internal as usize] =
                                last;
                            data.save_settings();
                        }
                        Err(err) => {
                            error!("addresses registration failed: {}", err.message);
                        }
                    },
                );
            }
        }

        if let (true, Some(device_key), Some(wallet)) = (
            self.ws_connected,
            &self.settings.device_key,
            self.wallets.get(&ACCOUNT_ID_AMP),
        ) {
            let first = self.settings.multi_sig_registered;
            let last = self.used_addresses.multi_sig + count;

            let addresses = (first..last)
                .map(|pointer| {
                    derive_multi_sig_address(
                        &wallet.xpubs.multi_sig_service_xpub,
                        &wallet.xpubs.multi_sig_user_xpub,
                        self.env.d().network,
                        pointer,
                    )
                    .to_string()
                })
                .collect::<Vec<_>>();

            self.make_async_request(
                api::Request::RegisterAddresses(api::RegisterAddressesRequest {
                    device_key: device_key.clone(),
                    addresses,
                }),
                move |data, res| match res {
                    Ok(_) => {
                        data.settings.multi_sig_registered = last;
                        data.save_settings();
                    }
                    Err(err) => {
                        error!("addresses registration failed: {}", err.message);
                    }
                },
            );
        }
    }

    fn save_settings(&self) {
        let result = settings::save_settings(&self.settings, &self.get_data_path());
        if let Err(e) = result {
            error!("saving settings failed: {}", e);
        }
    }

    fn update_sync_interval(&mut self) {
        // TODO: Revert when possible
        // let pending_tx = self.sent_txhash.is_some() || self.succeed_swap.is_some();
        // let interval = if pending_tx { 1 } else { 7 };
        // for wallet in self.wallets.values() {
        // wallet.ses.update_sync_interval(interval);
        // }
    }

    fn process_background_message(&mut self, data: String, pending_sign: mpsc::Sender<()>) {
        self.process_push_message(data, Some(pending_sign));
    }

    fn get_wallet(&self, account_id: AccountId) -> Result<&Wallet, anyhow::Error> {
        self.wallets
            .get(&account_id)
            .ok_or_else(|| anyhow!("wallet not found"))
    }

    fn process_jade_rescan_request(&mut self) {
        let ports_result = self.jade_mng.ports();
        match ports_result {
            Ok(ports) => {
                let ports = ports
                    .iter()
                    .map(|data| proto::from::jade_ports::Port {
                        jade_id: data.jade_id.clone(),
                        port: data.port_name.clone(),
                    })
                    .collect();
                self.ui
                    .send(proto::from::Msg::JadePorts(proto::from::JadePorts {
                        ports,
                    }))
            }
            Err(e) => error!("jade port scan failed: {e}"),
        }
    }

    fn process_gaid_status_req(&mut self, msg: proto::to::GaidStatus) {
        self.make_async_request(
            api::Request::GaidStatus(api::GaidStatusRequest {
                gaid: msg.gaid.clone(),
                asset_id: AssetId::from_str(&msg.asset_id).unwrap(),
            }),
            move |data, res| {
                let error_opt = match res {
                    Ok(api::Response::GaidStatus(resp)) => resp.error,
                    Ok(_) => Some("Unexpected response".to_string()),
                    Err(err) => Some(err.to_string()),
                };
                data.ui
                    .send(proto::from::Msg::GaidStatus(proto::from::GaidStatus {
                        gaid: msg.gaid,
                        asset_id: msg.asset_id,
                        error: error_opt,
                    }));
            },
        );
    }
}

fn process_timer_event(data: &mut Data, event: TimerEvent) {
    log::debug!("process timer event: {event:?}");
    match event {
        TimerEvent::AmpConnectionCheck => {
            data.check_amp_connection();
        }
        TimerEvent::SyncUtxos => {
            market_worker::sync_utxos(data);
        }
        TimerEvent::SendAck => {
            market_worker::send_ack(data);
        }
    }
}

fn remove_timers(data: &mut Data, removed: TimerEvent) {
    data.timers.retain(|_timer, event| *event != removed);
}

fn add_timer(data: &mut Data, timeout: Duration, event: TimerEvent) {
    data.timers.insert(Instant::now() + timeout, event);
}

fn replace_timers(data: &mut Data, timeout: Duration, event: TimerEvent) {
    remove_timers(data, event);
    add_timer(data, timeout, event);
}

fn recv_message(data: &mut Data, msg_receiver: &mpsc::Receiver<Message>) -> Option<Message> {
    loop {
        if let Some(timer) = data.timers.keys().next() {
            let now = Instant::now();
            let duration = timer.duration_since(now);
            match msg_receiver.recv_timeout(duration) {
                Ok(msg) => break Some(msg),
                Err(err) => match err {
                    mpsc::RecvTimeoutError::Timeout => {
                        let (_timer, event) = data.timers.pop_first().expect("must exist");
                        process_timer_event(data, event);
                        continue;
                    }
                    mpsc::RecvTimeoutError::Disconnected => break None,
                },
            }
        } else {
            break msg_receiver.recv().ok();
        }
    }
}

pub fn start_processing(
    env: Env,
    msg_sender: mpsc::Sender<Message>,
    msg_receiver: mpsc::Receiver<Message>,
    from_callback: FromCallback,
    params: StartParams,
) {
    let ui = UiData {
        from_callback,
        ui_stopped: Default::default(),
    };
    let env_settings = proto::from::EnvSettings {
        policy_asset_id: env.nd().policy_asset.asset_id().to_string(),
        usdt_asset_id: env.nd().known_assets.usdt.asset_id().to_string(),
        eurx_asset_id: env.nd().known_assets.eurx.asset_id().to_string(),
    };
    ui.send(proto::from::Msg::EnvSettings(env_settings));

    let (resp_sender, resp_receiver) = mpsc::channel::<ServerResp>();
    let msg_sender_copy = msg_sender.clone();
    let ws_resp_callback = Box::new(move |resp| {
        // Filter requests with string ids (they only used with blocking requests)
        if let ws::WrappedResponse::Response(api::ResponseMessage::Response(
            Some(api::RequestId::String(id)),
            res,
        )) = resp
        {
            let res = resp_sender.send(ServerResp(id, res));
            if let Err(err) = res {
                log::error!("sending resp message failed: {err}");
            }
        } else {
            let res = msg_sender_copy.send(Message::Ws(resp));
            if let Err(err) = res {
                log::error!("sending ws message failed: {err}");
            }
        }
    });
    let (ws_sender, ws_hint) = ws::start(ws_resp_callback);

    let ui_copy = ui.clone();
    let jade_status_callback: JadeStatusCallback =
        std::sync::Arc::new(Box::new(move |status: Option<JadeStatus>| {
            let status: i32 = match status {
                None => proto::from::jade_status::Status::Idle,
                Some(status) => match status {
                    JadeStatus::Connecting => proto::from::jade_status::Status::Connecting,
                    JadeStatus::ReadStatus => proto::from::jade_status::Status::ReadStatus,
                    JadeStatus::AuthUser => proto::from::jade_status::Status::AuthUser,
                    JadeStatus::MasterBlindingKey => {
                        proto::from::jade_status::Status::MasterBlindingKey
                    }
                    JadeStatus::SignMessage => proto::from::jade_status::Status::SignMessage,
                    JadeStatus::SignTx(tx_type) => match tx_type {
                        jade_mng::TxType::Normal => proto::from::jade_status::Status::SignTx,
                        jade_mng::TxType::Swap => proto::from::jade_status::Status::SignSwap,
                        jade_mng::TxType::MakerUtxo => {
                            proto::from::jade_status::Status::SignSwapOutput
                        }
                        jade_mng::TxType::OfflineSwap => {
                            proto::from::jade_status::Status::SignOfflineSwap
                        }
                    },
                },
            }
            .into();
            ui_copy.send(proto::from::Msg::JadeStatus(proto::from::JadeStatus {
                status,
            }));
        }));

    let settings_path = Data::data_path(env, &params.work_dir);
    let mut settings = settings::load_settings(&settings_path).unwrap_or_default();
    settings::prune(&mut settings);

    let policy_asset = env.nd().policy_asset.asset_id();

    let msg_sender_copy = msg_sender.clone();
    let wallet_event_callback = Arc::new(move |account_id, event| {
        let res = msg_sender_copy.send(Message::WalletEvent(account_id, event));
        if let Err(err) = res {
            log::debug!("sending wallet event failed: {err}");
        }
    });

    let market = market_worker::new();

    let mut data = Data {
        app_active: true,
        amp_active: true,
        amp_connected: false,
        ws_connected: false,
        server_status: None,
        env,
        ui,
        market,
        assets: BTreeMap::new(),
        amp_assets: BTreeSet::new(),
        msg_sender,
        ws_sender,
        ws_hint,
        resp_receiver,
        params,
        timers: BTreeMap::new(),
        agent: ureq::agent(),
        sync_complete: false,
        wallet_loaded_sent: false,
        confirmed_txids: BTreeMap::new(),
        unconfirmed_txids: BTreeMap::new(),
        wallets: BTreeMap::new(),
        active_swap: None,
        succeed_swap: None,
        active_extern_peg: None,
        sent_txhash: None,
        peg_out_server_amounts: None,
        active_submits: BTreeMap::new(),
        active_sign: None,
        settings,
        push_token: None,
        policy_asset,
        subscribed_price_stream: None,
        last_blocks: BTreeMap::new(),
        used_addresses: Default::default(),
        jade_mng: jade_mng::JadeMng::new(jade_status_callback),
        async_requests: BTreeMap::new(),
        network_settings: Default::default(),
        proxy_settings: Default::default(),
        wallet_event_callback,
    };

    debug!("proxy: {:?}", data.proxy());

    let registry_path = data.registry_path();
    let master_xpub = data.master_xpub();
    assets_registry::init(env, &registry_path, master_xpub);

    data.load_default_assets();

    while let Some(msg) = recv_message(&mut data, &msg_receiver) {
        let started = std::time::Instant::now();

        match msg {
            Message::Ui(msg) => data.process_ui(msg),
            Message::Ws(resp) => data.process_ws(resp),
            Message::WalletEvent(account_id, event) => data.process_wallet_event(account_id, event),
            Message::WalletNotif(account_id, msg) => data.process_wallet_notif(account_id, msg),
            Message::BackgroundMessage(msg, sender) => data.process_background_message(msg, sender),
            Message::Quit => {
                warn!("quit message received, exit");
                break;
            }
        }

        let stopped = std::time::Instant::now();
        let processing_time = stopped.duration_since(started);
        if processing_time > std::time::Duration::from_millis(100) {
            warn!("processing time: {} seconds", processing_time.as_secs_f64());
        }

        if data
            .ui
            .ui_stopped
            .load(std::sync::atomic::Ordering::Relaxed)
        {
            warn!("ui stopped, exit");
            break;
        }
    }
}
