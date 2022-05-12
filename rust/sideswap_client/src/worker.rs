use super::*;
use bitcoin::hashes::hex::ToHex;
use gdk_common::model::TransactionMeta;
use gdk_common::session::Session;
use gdk_electrum::{ElectrumSession, NativeNotif};
use settings::{Peg, PegDir};
use sideswap_api::*;
use sideswap_common::env::Env;
use sideswap_common::types::*;
use sideswap_common::*;
use std::{
    collections::{BTreeMap, BTreeSet, VecDeque},
    str::FromStr,
};
use std::{
    collections::{HashMap, HashSet},
    sync::Mutex,
};
use types::Amount;

const CLIENT_API_KEY: &str = "f8b7a12ee96aa68ee2b12ebfc51d804a4a404c9732652c298d24099a3d922a84";

const USER_AGENT: &str = "SideSwapApp";

const SERVER_REQUEST_TIMEOUT: std::time::Duration = std::time::Duration::from_secs(5);
const SERVER_REQUEST_POLL_PERIOD: std::time::Duration = std::time::Duration::from_secs(1);

const DESKTOP_IDLE_TIMER: std::time::Duration = std::time::Duration::from_secs(600);

const ACCOUNT: u32 = 0;

const BALANCE_NUM_CONFS: u32 = 0;

pub const TX_CONF_COUNT: u32 = 2;

const EXTRA_ADDRESS_COUNT: u32 = 100;
const MAX_REGISTER_ADDRESS_COUNT: u32 = 100;

const DEFAULT_ICON: &[u8] = include_bytes!("../images/icon_blank.png");

const AUTO_SIGN_ALLOWED_INDEX_PRICE_CHANGE: f64 = 0.1;

pub type AccountId = i32;

pub const ACCOUNT_ID_REGULAR: AccountId = 0;
pub const ACCOUNT_ID_AMP: AccountId = 1;
pub const ACCOUNT_ID_JADE_FIRST: AccountId = 2;

pub const ENABLE_JADE: bool = false;

pub fn get_account(id: AccountId) -> ffi::proto::Account {
    ffi::proto::Account { id }
}

pub fn get_created_tx(
    req: &ffi::proto::CreateTx,
    hex: &str,
    addressees: &[gdk_common::model::AddressAmount],
) -> Result<ffi::proto::CreatedTx, anyhow::Error> {
    let tx: elements::Transaction = elements::encode::deserialize(&hex::decode(hex)?)?;

    let network_fee = tx.all_fees().values().cloned().sum::<u64>() as i64;
    let vsize = (tx.get_weight() + 3) / 4;
    let fee_per_byte = network_fee as f64 / vsize as f64;

    ensure!(addressees.iter().all(|v| v.asset_id.is_some()));
    let addressees = addressees
        .iter()
        .map(|v| ffi::proto::AddressAmount {
            address: v.address.clone(),
            amount: v.satoshi as i64,
            asset_id: v.asset_id().unwrap().to_string(),
        })
        .collect();

    Ok(ffi::proto::CreatedTx {
        req: req.clone(),
        input_count: tx.input.len() as i32,
        output_count: tx.output.len() as i32,
        size: tx.get_size() as i64,
        vsize: vsize as i64,
        network_fee,
        fee_per_byte,
        addressees,
    })
}

fn convert_chart_point(point: ChartPoint) -> ffi::proto::ChartPoint {
    ffi::proto::ChartPoint {
        time: point.time,
        open: point.open,
        close: point.close,
        high: point.high,
        low: point.low,
        volume: point.volume,
    }
}

struct ActivePeg {
    order_id: OrderId,
}

enum AddrType {
    External,
    Internal,
}

struct SendTx {
    tx_signed: TransactionMeta,
    contact_key: Option<ContactKey>,
}

pub struct PegPayment {
    pub sent_amount: i64,
    pub sent_txid: sideswap_api::Txid,
    pub signed_tx: String,
}

pub struct Context {
    mnemonic: String,
    session: ElectrumSession,
    wallet_hash_id: String,
    sync_complete: bool,
    wallet_loaded_sent: bool,
    txs: BTreeMap<AccountId, HashMap<Txid, models::Transaction>>,
    orders_last: BTreeMap<OrderId, ffi::proto::Order>,
    orders_sent: BTreeMap<OrderId, ffi::proto::Order>,
    desktop: bool,
    send_utxo_updates: bool,
    stopped: std::sync::Arc<std::sync::atomic::AtomicBool>,
    jades: BTreeMap<sideswap_jade::Port, amp::Amp>,

    succeed_swap: Option<Txid>,
    pending_txs: bool,

    active_swap: Option<ActiveSwap>,

    send_tx: Option<SendTx>,
    active_extern_peg: Option<ActivePeg>,
    sent_txhash: Option<Txid>,

    active_submit: Option<LinkResponse>,
    active_sign: Option<SignNotification>,

    phone_key: Option<PhoneKey>,

    subscribes: BTreeSet<Option<AssetId>>,

    agent: ureq::Agent,
}

impl Drop for Context {
    fn drop(&mut self) {
        self.stopped
            .store(true, std::sync::atomic::Ordering::Relaxed);
    }
}

pub struct ServerResp(Option<RequestId>, Result<Response, Error>);

struct SubmitData {
    order_id: OrderId,
    side: OrderSide,
    asset: AssetId,
    asset_precision: u8,
    order_type: OrderType,
    bitcoin_amount: Amount,
    asset_amount: Amount,
    price: f64,
    server_fee: Amount,
    sell_bitcoin: bool,
    txouts: BTreeSet<TxOut>,
    auto_sign: bool,
    txid: Option<String>,
    index_price: bool,
    market: MarketType,
    signed: bool,
}

struct UiData {
    from_sender: crossbeam_channel::Sender<ffi::FromMsg>,
    ui_stopped: std::sync::atomic::AtomicBool,
}

pub struct Data {
    secp: elements_pset::secp256k1_zkp::Secp256k1<elements_pset::secp256k1_zkp::All>,
    connected: bool,
    amp_connected: bool,
    server_status: Option<ServerStatus>,
    env: Env,
    ui: UiData,
    assets: BTreeMap<AssetId, Asset>,
    amp_assets: BTreeSet<AssetId>,
    assets_old: Vec<Asset>,
    msg_sender: crossbeam_channel::Sender<Message>,
    ws_sender: crossbeam_channel::Sender<ws::WrappedRequest>,
    ws_hint: tokio::sync::mpsc::UnboundedSender<()>,
    amp: amp::Amp,
    resp_receiver: crossbeam_channel::Receiver<ServerResp>,
    params: ffi::StartParams,
    notif_context: *mut NotifContext,
    ctx: Option<Context>,
    settings: settings::Settings,
    push_token: Option<String>,
    liquid_asset_id: AssetId,
    submit_data: BTreeMap<OrderId, SubmitData>,
    pending_signs: BTreeMap<OrderId, Option<crossbeam_channel::Sender<()>>>,
    visible_submit: Option<OrderId>,
    waiting_submit: Option<OrderId>,
    processed_signs: BTreeSet<OrderId>,
    pending_sign_requests: VecDeque<SignNotification>,
    pending_sign_prompts: VecDeque<SignNotification>,
    pending_submits: Vec<ffi::proto::to::SubmitOrder>,
    pending_links: Vec<ffi::proto::to::LinkOrder>,
    downloaded_links: Vec<LinkResponse>,
    shown_succeed: BTreeSet<OrderId>,
    pending_succeed: VecDeque<ffi::proto::TransItem>,
    subscribed_price_stream: Option<SubscribePriceStreamRequest>,
    app_active: bool,
    amp_active: bool,
    subscribed_market_data: Option<AssetId>,
    last_ui_msg_at: std::time::Instant,
}

pub struct ActiveSwap {
    order_id: OrderId,
    send_asset: AssetId,
    recv_asset: AssetId,
    send_amount: u64,
    recv_amount: u64,
}

#[derive(Debug)]
pub enum Message {
    Ui(ffi::ToMsg),
    ServerConnected,
    ServerDisconnected,
    ServerNotification(Notification),
    Notif(serde_json::Value),
    PegStatus(PegStatus),
    Subscribe(SubscribeResponse),
    Unsubscribe(UnsubscribeResponse),
    MarketDataResponse(MarketDataSubscribeResponse),
    AssetDetails(AssetDetailsResponse),
    BackgroundMessage(String, crossbeam_channel::Sender<()>),
    Amp(worker::AccountId, amp::From),
    IdleTimer,
    ScanJade(Vec<sideswap_jade::Port>),
}

#[derive(Debug)]
pub struct SwapInputs {
    pub inputs: Vec<PsetInput>,
    pub change_addr: String,
}

struct NotifContext(Mutex<crossbeam_channel::Sender<serde_json::Value>>);

extern "C" fn notification_callback(context: *const libc::c_void, json: *const libc::c_char) {
    let context = unsafe { &*(context as *const NotifContext) };
    let json = unsafe { std::ffi::CStr::from_ptr(json) };
    let json = serde_json::Value::from_str(json.to_str().unwrap()).unwrap();
    let result = context.0.lock().unwrap().send(json);
    if let Err(e) = result {
        warn!("sending failed: {}", e);
    }
}

macro_rules! send_request {
    ($sender:expr, $t:ident, $value:expr) => {
        match $sender.send_request(Request::$t($value)) {
            Ok(Response::$t(value)) => Ok(value),
            Ok(_) => Err(anyhow!("unexpected response type")),
            Err(error) => Err(error),
        }
    };
}

fn redact_to_msg(mut msg: ffi::proto::to::Msg) -> ffi::proto::to::Msg {
    match &mut msg {
        ffi::proto::to::Msg::Login(v) => v.mnemonic = "<redacted>".to_owned(),
        ffi::proto::to::Msg::EncryptPin(v) => v.mnemonic = "<redacted>".to_owned(),
        ffi::proto::to::Msg::DecryptPin(v) => {
            v.pin = "<redacted>".to_owned();
            v.salt = "<redacted>".to_owned();
            v.encrypted_data = "<redacted>".to_owned();
            v.pin_identifier = "<redacted>".to_owned();
        }
        _ => {}
    }
    msg
}

fn redact_from_msg(mut msg: ffi::proto::from::Msg) -> ffi::proto::from::Msg {
    match &mut msg {
        ffi::proto::from::Msg::DecryptPin(v) => match v.result.as_mut().unwrap() {
            ffi::proto::from::decrypt_pin::Result::Mnemonic(v) => *v = "<redacted>".to_owned(),
            _ => {}
        },
        ffi::proto::from::Msg::NewAsset(v) => v.icon = "<redacted>".to_owned(),
        _ => {}
    }
    msg
}

impl UiData {
    fn send(&self, msg: ffi::proto::from::Msg) {
        debug!(
            "to ui: {}",
            serde_json::to_string(&redact_from_msg(msg.clone())).unwrap()
        );
        let result = self.from_sender.send(msg);
        if let Err(e) = result {
            warn!("posting dart message failed: {}", e);
            self.ui_stopped
                .store(true, std::sync::atomic::Ordering::Relaxed);
        }
    }
}

fn get_tx_item_confs(
    tx: &gdk_common::model::TxListItem,
    top_block: u32,
) -> Option<ffi::proto::Confs> {
    let confs = if tx.block_height == 0 || tx.block_height > top_block {
        0
    } else {
        top_block - tx.block_height + 1
    };
    if confs < TX_CONF_COUNT {
        Some(ffi::proto::Confs {
            count: confs,
            total: TX_CONF_COUNT,
        })
    } else {
        None
    }
}

fn get_tx_item(tx: &gdk_common::model::TxListItem, top_block: u32) -> models::Transaction {
    let created_at = tx.created_at_ts as i64 / 1000;
    let count = if tx.block_height == 0 || tx.block_height > top_block {
        0
    } else {
        top_block - tx.block_height + 1
    };
    let pending_confs = if count < worker::TX_CONF_COUNT {
        Some(count as u8)
    } else {
        None
    };
    let balances = tx
        .satoshi
        .iter()
        .map(|(asset_id, balance)| models::Balance {
            asset: sideswap_api::AssetId::from_str(&asset_id).unwrap(),
            value: *balance,
        })
        .collect::<Vec<_>>();
    let tx_item = models::Transaction {
        txid: sideswap_api::Txid::from_str(&tx.txhash).unwrap(),
        network_fee: tx.fee as u32,
        memo: tx.memo.clone(),
        balances,
        created_at,
        pending_confs: pending_confs,
        size: tx.transaction_size as u32,
        vsize: tx.transaction_vsize as u32,
    };
    tx_item
}

fn peg_txitem_id(send_txid: &str, send_vout: i32) -> String {
    format!("{}/{}", send_txid, send_vout)
}

fn get_peg_item(peg: &PegStatus, tx: &TxStatus) -> ffi::proto::TransItem {
    let peg_details = ffi::proto::Peg {
        is_peg_in: peg.peg_in,
        amount_send: tx.amount,
        amount_recv: tx.payout.unwrap_or_default(),
        addr_send: peg.addr.clone(),
        addr_recv: peg.addr_recv.clone(),
        txid_send: tx.tx_hash.clone(),
        txid_recv: tx.payout_txid.clone(),
    };
    let confs = tx.detected_confs.and_then(|count| {
        tx.total_confs.map(|total| ffi::proto::Confs {
            count: count as u32,
            total: total as u32,
        })
    });
    let id = peg_txitem_id(&tx.tx_hash, tx.vout);
    let tx_item = ffi::proto::TransItem {
        id,
        created_at: tx.created_at,
        confs,
        item: Some(ffi::proto::trans_item::Item::Peg(peg_details)),
    };
    tx_item
}

impl Data {
    fn load_gdk_asset(&self, asset_id: &AssetId) -> Result<Asset, anyhow::Error> {
        let ctx = self.ctx.as_ref().ok_or_else(|| anyhow!("ctx is not set"))?;
        let assets = ctx
            .session
            .refresh_assets(&gdk_common::model::RefreshAssets {
                icons: true,
                assets: true,
                refresh: false,
            })
            .or_else(|_| {
                ctx.session
                    .refresh_assets(&gdk_common::model::RefreshAssets {
                        icons: true,
                        assets: true,
                        refresh: true,
                    })
            })
            .map_err(|e| anyhow!("loading asset list failed: {}", e))?;
        let gdk_assets = serde_json::from_value::<sideswap_api::gdk::GdkAssets>(assets)?;
        let icon = gdk_assets
            .icons
            .get(asset_id)
            .cloned()
            .unwrap_or_else(|| base64::encode(DEFAULT_ICON));
        let v = gdk_assets
            .assets
            .get(asset_id)
            .ok_or_else(|| anyhow!("asset not found"))?;
        let default_ticker = || Ticker(format!("{:0.4}", &asset_id.to_string()));
        let default_name = || format!("{:0.8}...", &asset_id.to_string());
        let asset = Asset {
            asset_id: asset_id.clone(),
            name: v.name.clone().unwrap_or_else(default_name),
            ticker: v.ticker.clone().unwrap_or_else(default_ticker),
            icon: Some(icon),
            precision: v.precision.unwrap_or_default(),
            icon_url: None,
            instant_swaps: Some(false),
            domain: v.entity.as_ref().and_then(|v| v.domain.as_ref()).cloned(),
            domain_agent: None,
        };
        Ok(asset)
    }

    fn try_add_asset(&mut self, asset_id: &AssetId) -> Result<(), anyhow::Error> {
        if self.assets.get(asset_id).is_some() {
            return Ok(());
        }
        let asset = self.load_gdk_asset(asset_id)?;
        self.register_asset(asset, false, false, false);
        Ok(())
    }

    fn send_new_transactions(&mut self, items: Vec<models::Transaction>, amp: AccountId) {
        let ctx = match self.ctx.as_mut() {
            Some(v) => v,
            None => return,
        };
        let txs = ctx.txs.entry(amp).or_default();
        let mut updated_txids = txs
            .values()
            .filter(|tx| tx.pending_confs.is_some())
            .map(|tx| tx.txid.clone())
            .collect::<HashSet<_>>();
        for tx in items.into_iter() {
            let old_tx = txs.get(&tx.txid);
            if old_tx != Some(&tx) {
                updated_txids.insert(tx.txid.clone());
                txs.insert(tx.txid.clone(), tx);
            }
        }

        let mut updated = HashMap::<sideswap_api::Txid, ffi::proto::TransItem>::new();
        let mut removed = HashSet::new();
        for txid in updated_txids {
            let mut found = false;
            for (account, txs) in ctx.txs.iter() {
                let tx = txs.get(&txid);
                if let Some(item) = tx {
                    found = true;
                    let merged_tx = updated.entry(item.txid).or_insert_with(|| {
                        let tx_details = ffi::proto::Tx {
                            balances: Vec::new(),
                            memo: item.memo.clone(),
                            network_fee: item.network_fee as i64,
                            txid: item.txid.to_string(),
                            size: item.size as i64,
                            vsize: item.vsize as i64,
                        };
                        let confs = item.pending_confs.map(|confs| ffi::proto::Confs {
                            count: confs as u32,
                            total: worker::TX_CONF_COUNT,
                        });
                        ffi::proto::TransItem {
                            id: item.txid.to_string(),
                            created_at: item.created_at,
                            confs,
                            item: Some(ffi::proto::trans_item::Item::Tx(tx_details)),
                        }
                    });
                    let balances = match merged_tx.item.as_mut().unwrap() {
                        ffi::proto::trans_item::Item::Tx(v) => &mut v.balances,
                        ffi::proto::trans_item::Item::Peg(_) => unreachable!(),
                    };
                    for balance in item.balances.iter().filter(|balance| balance.value != 0) {
                        balances.push(ffi::proto::TxBalance {
                            asset_id: balance.asset.to_string(),
                            amount: balance.value,
                            account: worker::get_account(*account),
                        });
                    }
                }
            }
            if !found {
                removed.insert(txid);
            }
        }

        for item in updated.values() {
            let submit_data = self
                .submit_data
                .values()
                .find(|submit_data| submit_data.txid.as_ref() == Some(&item.id));
            if let Some(submit_data) = submit_data {
                let shown = self.shown_succeed.contains(&submit_data.order_id);
                if !shown {
                    self.pending_succeed.push_back(item.clone());
                    self.shown_succeed.insert(submit_data.order_id.clone());
                }
            }
        }

        let mut queue_msgs = Vec::new();

        if let Some(txid) = ctx.sent_txhash.as_ref() {
            let tx = updated.get(txid);
            if let Some(tx) = tx {
                let result = ffi::proto::from::send_result::Result::TxItem(tx.clone());
                queue_msgs.push(ffi::proto::from::Msg::SendResult(
                    ffi::proto::from::SendResult {
                        result: Some(result),
                    },
                ));
                ctx.sent_txhash = None;
                Data::update_sync_interval(&ctx);
            }
        }

        if let Some(txid) = ctx.succeed_swap.as_ref() {
            let tx = updated.get(txid);
            if let Some(tx) = tx {
                queue_msgs.push(ffi::proto::from::Msg::SwapSucceed(tx.clone()));
                ctx.succeed_swap = None;
                Data::update_sync_interval(&ctx);
            }
        }

        let assets = updated
            .values()
            .flat_map(|item| match item.item.as_ref().unwrap() {
                ffi::proto::trans_item::Item::Tx(tx) => Some(&tx.balances),
                _ => None,
            })
            .flat_map(|balances| balances.iter())
            .map(|balance| AssetId::from_str(&balance.asset_id).unwrap())
            .collect::<BTreeSet<_>>();

        let new_asset_ids = assets
            .iter()
            .filter(|asset| self.assets.get(&asset).is_none())
            .cloned()
            .collect::<Vec<_>>();
        if !new_asset_ids.is_empty() {
            for asset_id in new_asset_ids.iter() {
                info!("try add new asset: {}", asset_id);
                let (asset, unregistered) = match self.load_gdk_asset(asset_id) {
                    Ok(asset) => (asset, false),
                    Err(e) => {
                        warn!("can't load GDK asset {}: {}", asset_id, e);
                        (
                            Asset {
                                asset_id: asset_id.clone(),
                                name: format!("{:0.8}...", &asset_id.to_string()),
                                ticker: Ticker(format!("{:0.4}", &asset_id.to_string())),
                                icon: Some(base64::encode(DEFAULT_ICON)),
                                precision: 8,
                                icon_url: None,
                                instant_swaps: Some(false),
                                domain: None,
                                domain_agent: None,
                            },
                            true,
                        )
                    }
                };
                self.register_asset(asset, false, false, unregistered);
            }
        }

        if !updated.is_empty() {
            let updated = updated.into_values().collect();
            self.ui.send(ffi::proto::from::Msg::UpdatedTxs(
                ffi::proto::from::UpdatedTxs { items: updated },
            ));
        }
        if !removed.is_empty() {
            let removed = removed.iter().map(|txid| txid.to_string()).collect();
            self.ui.send(ffi::proto::from::Msg::RemovedTxs(
                ffi::proto::from::RemovedTxs { txids: removed },
            ));
        }

        for msg in queue_msgs.into_iter() {
            self.ui.send(msg);
        }
    }

    fn try_update_tx_list(&mut self) -> Result<(), anyhow::Error> {
        if self.assets.is_empty() || self.ctx.is_none() {
            return Ok(());
        }
        let ctx = self.ctx.as_mut().unwrap();
        let opt = gdk_common::model::GetTransactionsOpt {
            first: 0,
            count: usize::MAX,
            subaccount: ACCOUNT,
            num_confs: None,
        };
        let txs = ctx
            .session
            .get_transactions(&opt)
            .map_err(|e| anyhow!("{}", e))?
            .0;
        let (top_block, _) = ctx
            .session
            .block_status()
            .map_err(|e| anyhow!("block_status failed: {}", e.to_string()))?;

        ctx.pending_txs = txs
            .iter()
            .find(|tx| get_tx_item_confs(tx, top_block).is_some())
            .is_some();

        let txs = txs
            .iter()
            .map(|tx| get_tx_item(tx, top_block))
            .collect::<Vec<_>>();

        self.send_new_transactions(txs, ACCOUNT_ID_REGULAR);
        self.update_address_registrations();
        self.process_pending_succeed();
        self.update_balances();

        Ok(())
    }

    fn update_tx_list(&mut self) {
        if let Err(e) = self.try_update_tx_list() {
            error!("updating tx list failed: {}", e);
        }
    }

    fn send_wallet_loaded(&mut self) {
        if let Some(ctx) = self.ctx.as_mut() {
            if !ctx.wallet_loaded_sent {
                ctx.wallet_loaded_sent = true;
                self.ui
                    .send(ffi::proto::from::Msg::WalletLoaded(ffi::proto::Empty {}));
            }
        }
    }

    fn sync_complete(&mut self) {
        if let Some(ctx) = self.ctx.as_mut() {
            if !ctx.sync_complete {
                ctx.sync_complete = true;
                self.send_wallet_loaded();
                self.process_pending_requests();
                self.ui
                    .send(ffi::proto::from::Msg::SyncComplete(ffi::proto::Empty {}));
            }
        }
    }

    fn sync_failed(&mut self) {
        self.show_message("electrs connection failed");
    }

    fn resume_peg_monitoring(&mut self) {
        if self.assets.is_empty() || self.ctx.is_none() || !self.connected {
            return;
        }
        for peg in self.settings.pegs.iter().flatten() {
            self.start_peg_monitoring(peg);
        }
    }

    fn get_blinded_value(unblinded: &elements::TxOutSecrets) -> String {
        [
            unblinded.value.to_string(),
            unblinded.asset.to_string(),
            unblinded.value_bf.to_string(),
            unblinded.asset_bf.to_string(),
        ]
        .join(",")
    }

    fn get_blinded_values(&self, txid: &str) -> Result<Vec<String>, anyhow::Error> {
        let ctx = self.ctx.as_ref().expect("wallet must be set");
        let wallet = ctx
            .session
            .wallet
            .as_ref()
            .expect("wallet must be set")
            .read()
            .unwrap();
        let txid = gdk_common::be::BETxid::Elements(elements::Txid::from_str(txid)?);
        let store = wallet.store.read().unwrap();
        let tx = store
            .cache
            .accounts
            .get(&ACCOUNT)
            .unwrap()
            .all_txs
            .get(&txid)
            .ok_or(anyhow!("not found"))?;
        let tx = match &tx.tx {
            gdk_common::be::BETransaction::Bitcoin(_) => bail!("unexpected tx type"),
            gdk_common::be::BETransaction::Elements(v) => v,
        };
        let mut out_points = tx
            .input
            .iter()
            .map(|v| v.previous_output.clone())
            .collect::<Vec<_>>();
        for vout in 0..tx.output.len() {
            out_points.push(elements::OutPoint {
                txid: tx.txid(),
                vout: vout as u32,
            });
        }
        let result: Vec<String> = out_points
            .iter()
            .flat_map(|out_point| {
                store
                    .cache
                    .accounts
                    .get(&ACCOUNT)
                    .unwrap()
                    .unblinded
                    .get(out_point)
                    .map(Data::get_blinded_value)
            })
            .collect();
        Ok(result)
    }

    fn try_update_balances(&mut self) -> Result<(), anyhow::Error> {
        let ctx = self.ctx.as_mut().ok_or_else(|| anyhow!("no wallet"))?;
        let balance_opts = gdk_common::model::GetBalanceOpt {
            subaccount: ACCOUNT,
            num_confs: BALANCE_NUM_CONFS,
            confidential_utxos_only: None,
        };
        let balances = ctx
            .session
            .get_balance(&balance_opts)
            .map_err(|e| anyhow!("{}", e))?;
        let balances = balances
            .into_iter()
            .map(|(asset_id, balance)| ffi::proto::Balance {
                asset_id,
                amount: balance,
            })
            .collect();
        self.ui.send(ffi::proto::from::Msg::BalanceUpdate(
            ffi::proto::from::BalanceUpdate {
                account: get_account(ACCOUNT_ID_REGULAR),
                balances,
            },
        ));

        if ctx.send_utxo_updates {
            let balance_opts = gdk_common::model::GetUnspentOpt {
                subaccount: ACCOUNT,
                num_confs: Some(BALANCE_NUM_CONFS),
                confidential_utxos_only: None,
                all_coins: None,
            };
            let utxos = ctx
                .session
                .get_unspent_outputs(&balance_opts)
                .map_err(|e| anyhow!("{}", e))?
                .0;
            let utxos = utxos
                .into_iter()
                .map(|(asset_id, utxos)| {
                    utxos
                        .into_iter()
                        .map(move |utxo| ffi::proto::from::utxo_update::Utxo {
                            txid: utxo.txhash,
                            vout: utxo.pt_idx,
                            asset_id: asset_id.clone(),
                            amount: utxo.satoshi,
                        })
                })
                .flatten()
                .collect::<Vec<_>>();
            self.ui.send(ffi::proto::from::Msg::UtxoUpdate(
                ffi::proto::from::UtxoUpdate {
                    account: get_account(ACCOUNT_ID_REGULAR),
                    utxos,
                },
            ));
        }

        Ok(())
    }

    fn update_balances(&mut self) {
        if let Err(e) = self.try_update_balances() {
            error!("updating balances failed: {}", e);
        }
    }

    fn data_path(env: Env, path: &str) -> std::path::PathBuf {
        let env_data = env.data();
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
    fn assets_path(&self) -> std::path::PathBuf {
        self.get_data_path().join("assets.json")
    }
    fn cache_path(&self) -> std::path::PathBuf {
        self.get_data_path().join("cache")
    }

    fn subscribe_price_update(&self, asset_id: &AssetId) {
        let result = send_request!(
            self,
            PriceUpdateSubscribe,
            PriceUpdateSubscribe {
                asset: asset_id.clone(),
            }
        );
        if let Err(e) = result {
            error!("price subscribe failed: {}", e);
        }
    }

    fn try_process_ws_connected(&mut self) -> Result<(), anyhow::Error> {
        info!("connected to server, version: {}", &self.params.version);
        let cookie = std::fs::read_to_string(self.cookie_path()).ok();
        let resp = send_request!(
            self,
            LoginClient,
            LoginClientRequest {
                api_key: CLIENT_API_KEY.into(),
                cookie,
                user_agent: USER_AGENT.to_owned(),
                version: self.params.version.clone(),
            }
        )?;

        if let Err(e) = std::fs::write(self.cookie_path(), &resp.cookie) {
            error!("can't write cookie: {}", &e);
        };

        let assets = send_request!(self, Assets, None)?.assets;
        for asset in assets
            .iter()
            .filter(|asset| asset.asset_id != self.liquid_asset_id)
        {
            self.subscribe_price_update(&asset.asset_id);
        }

        if assets != self.assets_old {
            if let Err(e) = self.save_assets(&assets) {
                error!("can't save assets file: {}", &e);
            }
            self.register_assets(assets, false);
        }

        let amp_assets = send_request!(self, AmpAssets, None)?.assets;
        let amp_assets_copy = amp_assets.iter().map(|v| v.asset_id.to_string()).collect();
        self.ui.send(ffi::proto::from::Msg::AmpAssets(
            ffi::proto::from::AmpAssets {
                assets: amp_assets_copy,
            },
        ));
        self.amp_assets = amp_assets.iter().map(|v| v.asset_id).collect();
        self.register_assets(amp_assets, true);

        let server_status = send_request!(self, ServerStatus, None)?;
        self.process_server_status(server_status);

        // verify device key if exists
        if let Some(device_key) = &self.settings.device_key {
            let verify_request = VerifyDeviceRequest {
                device_key: device_key.clone(),
            };
            let verify_resp = send_request!(self, VerifyDevice, verify_request)?;
            match verify_resp.device_state {
                DeviceState::Unregistered => {
                    warn!("device_key is not registered");
                    self.settings.device_key = None;
                    self.save_settings();
                }
                DeviceState::Registered => {
                    info!("device_key is registered");
                }
            };
        }

        // register device key if not exists
        if self.settings.device_key == None {
            let register_req = RegisterDeviceRequest {
                os_type: get_os_type(),
            };
            let register_resp = send_request!(self, RegisterDevice, register_req)?;
            self.settings.device_key = Some(register_resp.device_key);
            self.settings.last_external = None;
            self.settings.last_internal = None;
            self.save_settings();
            self.update_address_registrations();
        }

        let login_req = LoginRequest {
            session_id: self.settings.session_id.clone(),
        };
        let login_resp = send_request!(self, Login, login_req)?;
        for order in login_resp.orders {
            self.add_order(order, false);
        }
        self.sync_order_list();
        if Some(&login_resp.session_id) != self.settings.session_id.as_ref() {
            self.settings.session_id = Some(login_resp.session_id);
            self.save_settings();
        }

        for req in self.subscribed_price_stream.iter() {
            self.send_request_msg(Request::SubscribePriceStream(req.clone()));
        }

        if let Some(asset_id) = self.subscribed_market_data {
            self.send_request_msg(Request::MarketDataSubscribe(MarketDataSubscribeRequest {
                asset: asset_id,
            }));
        }

        Ok(())
    }

    fn process_ws_connected(&mut self) {
        info!("connected to server");
        if let Err(e) = self.try_process_ws_connected() {
            error!("connection failed: {}", &e);
            self.restart_websocket();
            return;
        }
        self.connected = true;
        self.process_pending_requests();
        self.resume_peg_monitoring();
        self.update_push_token();
        self.update_address_registrations();
        self.download_contacts();
        self.process_unregister_phone_requests();
        self.send_subscribe_request();

        self.ui
            .send(ffi::proto::from::Msg::ServerConnected(ffi::proto::Empty {}));
    }

    fn process_ws_disconnected(&mut self) {
        warn!("disconnected from server");
        self.connected = false;

        if let Some(ctx) = self.ctx.as_mut() {
            ctx.orders_last.clear();
        }
        self.sync_order_list();

        self.ui.send(ffi::proto::from::Msg::ServerDisconnected(
            ffi::proto::Empty {},
        ));

        if let Some(_) = self.ctx.as_mut() {
            self.ws_sender.send(ws::WrappedRequest::Connect).unwrap();
        }
    }

    fn process_server_status(&mut self, resp: ServerStatus) {
        let bitcoin_fee_rates = resp
            .bitcoin_fee_rates
            .iter()
            .map(|item| ffi::proto::FeeRate {
                blocks: item.blocks,
                value: item.value,
            })
            .collect();
        let status_copy = ffi::proto::ServerStatus {
            min_peg_in_amount: resp.min_peg_in_amount,
            min_peg_out_amount: resp.min_peg_out_amount,
            server_fee_percent_peg_in: resp.server_fee_percent_peg_in,
            server_fee_percent_peg_out: resp.server_fee_percent_peg_out,
            bitcoin_fee_rates,
        };
        self.ui
            .send(ffi::proto::from::Msg::ServerStatus(status_copy));
        self.server_status = Some(resp);
    }

    fn process_price_update(&mut self, msg: PriceUpdateNotification) {
        let asset = match self.assets.get(&msg.asset) {
            Some(v) => v,
            None => return,
        };
        let price_update = ffi::proto::from::PriceUpdate {
            asset: asset.asset_id.to_string(),
            bid: msg.price.bid,
            ask: msg.price.ask,
        };
        self.ui
            .send(ffi::proto::from::Msg::PriceUpdate(price_update));
    }

    fn process_wallet_notif(&mut self, msg: serde_json::Value) {
        let pending_txs = self.ctx.as_ref().map(|v| v.pending_txs).unwrap_or(false);
        let msg = msg.as_object().expect("expected object notification");
        let event = msg
            .get("event")
            .expect("expected event filed")
            .as_str()
            .expect("expected string event");
        match event {
            "transaction" => self.update_tx_list(),
            "block" => {
                if pending_txs {
                    self.update_tx_list()
                }
            }
            "sync_complete" => self.sync_complete(),
            "sync_failed" => self.sync_failed(),
            _ => {}
        }
    }

    fn make_pegout_payment(
        &mut self,
        send_amount: i64,
        peg_addr: &str,
    ) -> Result<PegPayment, anyhow::Error> {
        let balance = self.get_balance(&self.liquid_asset_id);
        let ctx = self.ctx.as_mut().expect("wallet must be set");
        ensure!(balance.to_sat() >= send_amount, "Insufficient balance");
        let send_all = balance.to_sat() == send_amount;

        let address_amount = gdk_common::model::AddressAmount {
            address: peg_addr.to_owned(),
            satoshi: send_amount as u64,
            asset_id: Some(self.liquid_asset_id.to_string()),
        };

        let utxos = ctx
            .session
            .get_unspent_outputs(&gdk_common::model::GetUnspentOpt {
                subaccount: ACCOUNT,
                num_confs: Some(BALANCE_NUM_CONFS),
                confidential_utxos_only: None,
                all_coins: None,
            })
            .map_err(|_| anyhow!("loading UTXO failed"))?;

        let mut details = gdk_common::model::CreateTransaction {
            addressees: vec![address_amount],
            fee_rate: None,
            subaccount: ACCOUNT,
            send_all,
            previous_transaction: None,
            memo: None,
            utxos,
            num_confs: 0,
            confidential_utxos_only: false,
            utxo_strategy: gdk_common::model::UtxoStrategy::Default,
        };
        let tx_detail_unsigned = ctx
            .session
            .create_transaction(&mut details)
            .map_err(|e| anyhow!("{}", e))?;
        let sent_amount = if send_all {
            send_amount - tx_detail_unsigned.fee as i64
        } else {
            send_amount
        };
        let server_status = self
            .server_status
            .as_ref()
            .ok_or(anyhow!("server_status is not known"))?;
        ensure!(
            sent_amount >= server_status.min_peg_out_amount,
            "min {}",
            Amount::from_sat(server_status.min_peg_out_amount)
                .to_bitcoin()
                .to_string()
        );
        let tx_detail_signed = ctx.session.sign_transaction(&tx_detail_unsigned).unwrap();
        let ctx = self.ctx.as_mut().expect("wallet must be set");
        let sent_txid = match ctx.session.send_transaction(&tx_detail_signed) {
            Ok(v) => sideswap_api::Txid::from_str(&v.txid).unwrap(),
            Err(e) => bail!("broadcast failed: {}", e.to_string()),
        };
        let payment = PegPayment {
            sent_amount,
            sent_txid,
            signed_tx: tx_detail_signed.hex,
        };
        Ok(payment)
    }

    fn try_process_pegout_request(
        &mut self,
        req: ffi::proto::to::PegOutRequest,
    ) -> Result<OrderId, anyhow::Error> {
        ensure!(self.connected, "not connected");
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

        let device_key = self
            .settings
            .device_key
            .as_ref()
            .expect("device_key must exists")
            .clone();
        // First output is the target output
        let request = Request::Peg(PegRequest {
            recv_addr: req.recv_addr.clone(),
            send_amount: None,
            peg_in: false,
            device_key: Some(device_key),
            blocks: Some(req.blocks),
        });

        let resp = self.send_request(request);
        let resp = match resp {
            Ok(Response::Peg(resp)) => resp,
            Ok(_) => bail!("unexpected server response"),
            Err(e) => bail!("server error: {}", e.to_string()),
        };

        self.add_peg_monitoring(resp.order_id, PegDir::Out);

        match req.account.id {
            ACCOUNT_ID_REGULAR => {
                self.make_pegout_payment(req.send_amount, &resp.peg_addr)?;
            }
            ACCOUNT_ID_AMP => {
                self.amp
                    .make_pegout_payment(req.send_amount, &resp.peg_addr)?;
            }
            _ => {
                let jade = self
                    .get_jade(req.account.id)
                    .ok_or_else(|| anyhow!("unknown account"))?;
                jade.make_pegout_payment(req.send_amount, &resp.peg_addr)?;
            }
        };

        Ok(resp.order_id)
    }

    fn process_pegout_request(&mut self, req: ffi::proto::to::PegOutRequest) {
        let result = self.try_process_pegout_request(req);
        match result {
            Ok(order_id) => {
                let ctx = self.ctx.as_mut().expect("wallet must be set");
                ctx.active_extern_peg = Some(ActivePeg { order_id });
            }
            Err(e) => {
                error!("starting peg-out failed: {}", e.to_string());
                self.ui
                    .send(ffi::proto::from::Msg::SwapFailed(e.to_string()));
            }
        }
    }

    fn try_process_pegin_request(
        &mut self,
    ) -> Result<ffi::proto::from::PeginWaitTx, anyhow::Error> {
        ensure!(self.connected, "not connected");
        let ctx = self.ctx.as_mut().expect("wallet must be set");
        let device_key = self
            .settings
            .device_key
            .as_ref()
            .expect("device_key must exists")
            .clone();
        let recv_addr = ctx
            .session
            .get_receive_address(&gdk_common::model::GetAddressOpt {
                subaccount: ACCOUNT,
                address_type: None,
            })
            .expect("can't get new address")
            .address;
        let request = Request::Peg(PegRequest {
            recv_addr: recv_addr.clone(),
            send_amount: None,
            peg_in: true,
            device_key: Some(device_key),
            blocks: None,
        });
        let resp = self.send_request(request);
        let resp = match resp {
            Ok(Response::Peg(resp)) => resp,
            Ok(_) => bail!("unexpected server response"),
            Err(e) => bail!("server error: {}", e.to_string()),
        };

        self.add_peg_monitoring(resp.order_id.clone(), PegDir::In);

        let msg = ffi::proto::from::PeginWaitTx {
            peg_addr: resp.peg_addr,
            recv_addr: recv_addr.clone(),
        };

        let ctx = self.ctx.as_mut().expect("wallet must be set");
        ctx.active_extern_peg = Some(ActivePeg {
            order_id: resp.order_id,
        });
        Ok(msg)
    }

    fn process_pegin_request(&mut self) {
        let result = self.try_process_pegin_request();
        match result {
            Ok(v) => {
                self.ui.send(ffi::proto::from::Msg::PeginWaitTx(v));
            }
            Err(e) => {
                error!("starting peg-in failed: {}", e.to_string());
                self.ui
                    .send(ffi::proto::from::Msg::SwapFailed(e.to_string()));
            }
        }
    }

    fn get_inputs(
        &self,
        send_asset: &AssetId,
        send_amount: i64,
    ) -> Result<Vec<PsetInput>, anyhow::Error> {
        let ctx = self.ctx.as_ref().ok_or_else(|| anyhow!("wallet empty"))?;
        let mut all_utxos = ctx
            .session
            .get_unspent_outputs(&gdk_common::model::GetUnspentOpt {
                subaccount: ACCOUNT,
                num_confs: Some(BALANCE_NUM_CONFS),
                confidential_utxos_only: None,
                all_coins: None,
            })
            .map_err(|_| anyhow!("getting unspent outputs failed"))?;
        let mut asset_utxos = all_utxos
            .0
            .remove(&send_asset.to_string())
            .ok_or_else(|| anyhow!("Insufficient balance"))?;
        let utxo_amounts: Vec<_> = asset_utxos.iter().map(|v| v.satoshi as i64).collect();
        let total: i64 = utxo_amounts.iter().sum();
        ensure!(total >= send_amount, "Insufficient balance");
        let selected = types::select_utxo(utxo_amounts, send_amount);
        let selected_amount: i64 = selected.iter().cloned().sum();
        ensure!(selected_amount >= send_amount);

        let change_amount = selected_amount - send_amount;

        debug!(
            "load swap inputs: selected: {}, change: {}",
            selected_amount, change_amount
        );

        let wallet = ctx
            .session
            .wallet
            .as_ref()
            .expect("wallet must be set")
            .read()
            .unwrap();
        let store_read = wallet.store.read().expect("store must be set");
        let acc_store = store_read.account_cache(ACCOUNT).unwrap();
        let account = wallet.accounts.get(&ACCOUNT).unwrap();

        let mut inputs = Vec::new();
        for amount in selected {
            let index = asset_utxos
                .iter()
                .position(|v| v.satoshi as i64 == amount)
                .expect("utxo must exists");
            let utxo = asset_utxos.swap_remove(index);

            let unblinded = acc_store
                .unblinded
                .get(&elements::OutPoint {
                    txid: elements::Txid::from_str(&utxo.txhash).unwrap(),
                    vout: utxo.pt_idx,
                })
                .ok_or_else(|| anyhow!("can't find unblinded"))?;

            let public_key = account
                .xpub
                .derive_pub(&self.secp, &utxo.derivation_path)
                .unwrap()
                .public_key;
            let redeem_script = sideswap_common::pset::p2shwpkh_redeem_script(&public_key).to_hex();
            inputs.push(PsetInput {
                txid: Txid::from_str(&utxo.txhash).unwrap(),
                vout: utxo.pt_idx,
                asset: send_asset.clone(),
                asset_bf: Hash32::from_str(&unblinded.asset_bf.to_string()).unwrap(),
                value: unblinded.value,
                value_bf: Hash32::from_str(&unblinded.value_bf.to_string()).unwrap(),
                redeem_script: Some(redeem_script),
            });
        }
        Ok(inputs)
    }

    fn try_process_swap_request(
        &mut self,
        req: ffi::proto::to::SwapRequest,
    ) -> Result<(), anyhow::Error> {
        ensure!(self.connected, "not connected");
        info!(
            "start swap request: asset: {}, send_bitcoins: {}, send_amount: {}, recv_amount: {}, raw_price: {}",
            req.asset, &req.send_bitcoins, req.send_amount, req.recv_amount, req.price
        );
        let asset = AssetId::from_str(&req.asset)
            .map_err(|_| anyhow!("invalid asset id: {}", req.asset))?;
        let (send_asset, recv_asset) = if req.send_bitcoins {
            (self.liquid_asset_id, asset)
        } else {
            (asset, self.liquid_asset_id)
        };
        let send_amount = req.send_amount;
        let recv_amount = req.recv_amount;

        let inputs = self.get_inputs(&send_asset, send_amount)?;

        let ctx = self.ctx.as_ref().ok_or_else(|| anyhow!("wallet empty"))?;

        let recv_addr = ctx
            .session
            .get_receive_address(&gdk_common::model::GetAddressOpt {
                subaccount: ACCOUNT,
                address_type: None,
            })
            .unwrap()
            .address;

        let change_addr = ctx
            .session
            .get_receive_address(&gdk_common::model::GetAddressOpt {
                subaccount: ACCOUNT,
                address_type: None,
            })
            .unwrap()
            .address;

        let swap_resp = send_request!(
            self,
            StartSwapClient,
            StartSwapClientRequest {
                price: req.price,
                asset,
                send_bitcoins: req.send_bitcoins,
                send_amount,
                recv_amount,
                inputs,
                recv_addr,
                change_addr,
            }
        )?;

        let ctx = self.ctx.as_mut().expect("wallet must be set");
        ctx.active_swap = Some(ActiveSwap {
            order_id: swap_resp.order_id,
            send_asset,
            recv_asset,
            send_amount: send_amount as u64,
            recv_amount: recv_amount as u64,
        });

        Ok(())
    }

    fn process_swap_request(&mut self, req: ffi::proto::to::SwapRequest) {
        let result = self.try_process_swap_request(req);
        if let Err(e) = result {
            error!("swap request failed: {}", e.to_string());
            self.ui
                .send(ffi::proto::from::Msg::SwapFailed(e.to_string()));
        }
    }

    fn send_rest_request(
        &self,
        request: http_rpc::RequestMsg,
        url: &str,
    ) -> Result<http_rpc::ResponseMsg, anyhow::Error> {
        let ctx = self.ctx.as_ref().ok_or_else(|| anyhow!("wallet empty"))?;
        info!("send swap request to {}", &url);
        let request = serde_json::to_value(&request).unwrap();
        let response = ctx.agent.post(&url).send_json(request);
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

    fn try_process_swap_accept(
        &mut self,
        req: ffi::proto::SwapDetails,
    ) -> Result<(), anyhow::Error> {
        let order_id = OrderId::from_str(&req.order_id).unwrap();
        let send_asset = AssetId::from_str(&req.send_asset)
            .map_err(|_| anyhow!("invalid asset id: {}", req.send_asset))?;
        let recv_asset = AssetId::from_str(&req.recv_asset)
            .map_err(|_| anyhow!("invalid asset id: {}", req.recv_asset))?;
        let send_amount = req.send_amount;
        let recv_amount = req.recv_amount;
        let upload_url = req.upload_url;

        let inputs = self.get_inputs(&send_asset, send_amount)?;

        let ctx = self.ctx.as_ref().ok_or_else(|| anyhow!("wallet empty"))?;

        let recv_addr = ctx
            .session
            .get_receive_address(&gdk_common::model::GetAddressOpt {
                subaccount: ACCOUNT,
                address_type: None,
            })
            .unwrap()
            .address;

        let change_addr = ctx
            .session
            .get_receive_address(&gdk_common::model::GetAddressOpt {
                subaccount: ACCOUNT,
                address_type: None,
            })
            .unwrap()
            .address;

        let request = http_rpc::RequestMsg {
            id: None,
            request: http_rpc::Request::SwapStart(http_rpc::SwapStartRequest {
                order_id: order_id.clone(),
                inputs,
                recv_addr,
                change_addr,
                send_asset,
                send_amount,
                recv_asset,
                recv_amount,
            }),
        };
        let response = self.send_rest_request(request, &upload_url)?;
        let response = match response.response {
            http_rpc::Response::SwapStart(v) => v,
            _ => bail!("unexpected start response"),
        };

        let blinded_pset = elements_pset::encode::deserialize::<
            elements_pset::pset::PartiallySignedTransaction,
        >(&base64::decode(&response.pset)?)?;

        let amounts = swaps::Amounts {
            send_asset,
            recv_asset,
            send_amount: send_amount as u64,
            recv_amount: recv_amount as u64,
        };

        let wallet = ctx.session.wallet.as_ref().expect("wallet must be set");
        let wallet = wallet.read().unwrap();
        let account = wallet.accounts.get(&ACCOUNT).unwrap();

        let send_amp = self.amp_assets.contains(&send_asset);
        let recv_amp = self.amp_assets.contains(&recv_asset);
        ensure!(!send_amp && !recv_amp, "AMP assets are not allowed");

        let signed_pset =
            swaps::sign_and_verify_pset(&self.secp, account, &amounts, &blinded_pset, recv_amp)?;
        let signed_pset = elements_pset::encode::serialize(&signed_pset);

        let request = http_rpc::RequestMsg {
            id: None,
            request: http_rpc::Request::SwapSign(http_rpc::SwapSignRequest {
                order_id: order_id.clone(),
                submit_id: response.submit_id,
                pset: base64::encode(&signed_pset),
            }),
        };
        let response = self.send_rest_request(request, &upload_url)?;
        let response = match response.response {
            http_rpc::Response::SwapSign(v) => v,
            _ => bail!("unexpected start response"),
        };

        drop(wallet);

        let ctx = self.ctx.as_mut().ok_or_else(|| anyhow!("wallet empty"))?;
        ctx.succeed_swap = Some(response.txid);
        Data::update_sync_interval(&ctx);

        Ok(())
    }

    fn process_swap_accept(&mut self, req: ffi::proto::SwapDetails) {
        let result = self.try_process_swap_accept(req);
        if let Err(e) = result {
            error!("swap request failed: {}", e.to_string());
            self.ui
                .send(ffi::proto::from::Msg::SwapFailed(e.to_string()));
        }
    }

    fn process_get_recv_address(&mut self, req: ffi::proto::Account) {
        match req.id {
            ACCOUNT_ID_REGULAR => {}
            ACCOUNT_ID_AMP => {
                self.send_amp(amp::To::GetRecvAddr);
                return;
            }
            _ => {
                self.send_jade(req.id, amp::To::GetRecvAddr);
                return;
            }
        };

        let wallet = self.ctx.as_mut().expect("wallet must be set");
        let addr = wallet
            .session
            .get_receive_address(&gdk_common::model::GetAddressOpt {
                subaccount: ACCOUNT,
                address_type: None,
            })
            .expect("can't get new address")
            .address;
        self.ui.send(ffi::proto::from::Msg::RecvAddress(
            ffi::proto::from::RecvAddress {
                addr: ffi::proto::Address { addr },
                account: get_account(req.id),
            },
        ));
    }

    fn create_tx(
        &mut self,
        req: ffi::proto::CreateTx,
    ) -> Result<ffi::proto::CreatedTx, anyhow::Error> {
        let ctx = self.ctx.as_ref().expect("wallet must be set");
        let (address, contact_key) = if req.is_contact {
            let phone_key = ctx
                .phone_key
                .as_ref()
                .ok_or_else(|| anyhow!("phone is not verified"))?
                .clone();
            let contact_key = ContactKey(req.addr.clone());
            let addr_req = ContactAddrRequest {
                phone_key,
                contact_key: contact_key.clone(),
            };
            let addr_resp = send_request!(self, ContactAddr, addr_req)
                .map_err(|e| anyhow!("can't get contact address: {}", e))?;
            (addr_resp.addr, Some(contact_key))
        } else {
            (req.addr.clone(), None)
        };

        let send_asset = AssetId::from_str(&req.balance.asset_id).unwrap();
        let send_amount = req.balance.amount;
        let amount = gdk_common::model::AddressAmount {
            address,
            satoshi: req.balance.amount as u64,
            asset_id: Some(send_asset.to_string()),
        };
        let utxos = ctx
            .session
            .get_unspent_outputs(&gdk_common::model::GetUnspentOpt {
                subaccount: ACCOUNT,
                num_confs: Some(BALANCE_NUM_CONFS),
                confidential_utxos_only: None,
                all_coins: None,
            })
            .map_err(|_| anyhow!("loading UTXO failed"))?;
        let bitcoin_balance = utxos
            .0
            .get(&self.liquid_asset_id.to_string())
            .map(|inputs| inputs.iter().map(|input| input.satoshi).sum::<u64>())
            .unwrap_or_default() as i64;
        let balance = utxos
            .0
            .get(&send_asset.to_string())
            .map(|inputs| inputs.iter().map(|input| input.satoshi).sum::<u64>())
            .unwrap_or_default() as i64;
        ensure!(send_amount > 0, "invalid send amount");
        ensure!(balance >= send_amount, "Insufficient balance");
        ensure!(bitcoin_balance > 0, "Insufficient L-BTC to pay network fee");
        let send_all = balance == send_amount;
        let ctx = self.ctx.as_mut().expect("wallet must be set");
        let mut details = gdk_common::model::CreateTransaction {
            addressees: vec![amount],
            fee_rate: None,
            subaccount: ACCOUNT,
            send_all,
            previous_transaction: None,
            memo: None,
            utxos,
            num_confs: 0,
            confidential_utxos_only: false,
            utxo_strategy: gdk_common::model::UtxoStrategy::Default,
        };
        let tx_detail_unsigned = ctx
            .session
            .create_transaction(&mut details)
            .map_err(|e| anyhow!("{}", e))?;
        let network_fee = tx_detail_unsigned.fee as i64;
        ensure!(network_fee > 0, "network fee is 0");

        let tx_signed = ctx
            .session
            .sign_transaction(&tx_detail_unsigned)
            .map_err(|e| anyhow!("transaction sign failed: {}", e.to_string()))?;

        let addressees = &tx_signed
            .create_transaction
            .as_ref()
            .ok_or_else(|| anyhow!("create_transaction is not set"))?
            .addressees;
        let result = get_created_tx(&req, &tx_signed.hex, addressees)?;

        ctx.send_tx = Some(SendTx {
            tx_signed,
            contact_key,
        });

        Ok(result)
    }

    fn send_tx(&mut self, _req: ffi::proto::to::SendTx) -> Result<(), anyhow::Error> {
        let ctx = self.ctx.as_mut().expect("wallet must be set");
        let send_tx = ctx.send_tx.take().ok_or(anyhow!("no transaction found"))?;
        let tx_detail_signed = send_tx.tx_signed;
        let txid = sideswap_api::Txid::from_str(&tx_detail_signed.txid).unwrap();

        match send_tx.contact_key {
            Some(contact_key) => {
                let phone_key = ctx
                    .phone_key
                    .as_ref()
                    .ok_or_else(|| anyhow!("phone is not verified"))?
                    .clone();
                let broadcast_req = ContactBroadcastRequest {
                    phone_key,
                    contact_key,
                    raw_tx: tx_detail_signed.hex.clone(),
                };
                send_request!(self, ContactBroadcast, broadcast_req)
                    .map_err(|e| anyhow!("broadcast failed: {}", e))?;
            }
            None => {
                ctx.session
                    .send_transaction(&tx_detail_signed)
                    .map_err(|e| anyhow!("send failed: {}", e.to_string()))?;
            }
        };
        let ctx = self.ctx.as_mut().expect("wallet must be set");
        ctx.sent_txhash = Some(txid);
        Data::update_sync_interval(&ctx);
        Ok(())
    }

    fn process_create_tx(&mut self, req: ffi::proto::CreateTx) {
        match req.account.id {
            ACCOUNT_ID_REGULAR => {}
            ACCOUNT_ID_AMP => {
                self.send_amp(amp::To::CreateTx(req));
                return;
            }
            _ => {
                self.send_jade(req.account.id, amp::To::CreateTx(req));
                return;
            }
        };

        let result = match self.create_tx(req) {
            Ok(tx) => ffi::proto::from::create_tx_result::Result::CreatedTx(tx),
            Err(e) => ffi::proto::from::create_tx_result::Result::ErrorMsg(e.to_string()),
        };
        let send_result = ffi::proto::from::CreateTxResult {
            result: Some(result),
        };
        self.ui
            .send(ffi::proto::from::Msg::CreateTxResult(send_result));
    }

    fn process_send_tx(&mut self, req: ffi::proto::to::SendTx) {
        match req.account.id {
            ACCOUNT_ID_REGULAR => {}
            ACCOUNT_ID_AMP => {
                self.send_amp(amp::To::SendTx);
                return;
            }
            _ => {
                self.send_jade(req.account.id, amp::To::SendTx);
                return;
            }
        };

        let result = self.send_tx(req);
        if let Err(e) = result {
            let result = ffi::proto::from::send_result::Result::ErrorMsg(e.to_string());
            self.ui.send(ffi::proto::from::Msg::SendResult(
                ffi::proto::from::SendResult {
                    result: Some(result),
                },
            ));
        }
    }

    fn process_blinded_values(&self, req: ffi::proto::to::BlindedValues) {
        let result = self
            .amp
            .get_blinded_values(&req.txid)
            .unwrap_or_default()
            .into_iter()
            .chain(
                self.get_blinded_values(&req.txid)
                    .unwrap_or_default()
                    .into_iter(),
            )
            .collect::<Vec<_>>()
            .join(",");
        let result = ffi::proto::from::blinded_values::Result::BlindedValues(result);
        let blinded_values = ffi::proto::from::BlindedValues {
            txid: req.txid,
            result: Some(result),
        };
        self.ui
            .send(ffi::proto::from::Msg::BlindedValues(blinded_values));
    }

    // logins

    fn create_session(
        &mut self,
        network: &ffi::proto::NetworkSettings,
        mnemonic: &str,
    ) -> Result<(ElectrumSession, gdk_common::model::LoginData), anyhow::Error> {
        let parsed_network = envs::get_network(self.env);
        let url = match network.selected.as_ref().unwrap() {
            ffi::proto::network_settings::Selected::Sideswap(_)
                if self.env.data().network == env::Network::Mainnet =>
            {
                Ok(gdk_electrum::interface::ElectrumUrl::Tls(
                    "electrs.sideswap.io:12001".to_owned(),
                    true,
                ))
            }
            ffi::proto::network_settings::Selected::Sideswap(_)
                if self.env.data().network == env::Network::Testnet =>
            {
                Ok(gdk_electrum::interface::ElectrumUrl::Tls(
                    "electrs.sideswap.io:12002".to_owned(),
                    true,
                ))
            }
            ffi::proto::network_settings::Selected::Sideswap(_) => {
                gdk_electrum::determine_electrum_url_from_net(&parsed_network)
            }
            ffi::proto::network_settings::Selected::Blockstream(_) => {
                gdk_electrum::determine_electrum_url_from_net(&parsed_network)
            }
            ffi::proto::network_settings::Selected::Custom(custom) => {
                let url = format!("{}:{}", custom.host, custom.port);
                gdk_electrum::determine_electrum_url(
                    &Some(url),
                    Some(custom.use_tls),
                    Some(custom.use_tls),
                )
            }
        }
        .map_err(|e| anyhow!("invalid network settings: {}", e))?;

        let cache_path = self.cache_path();
        let cache_path = cache_path.to_str().unwrap();

        let mut session = ElectrumSession::create_session(parsed_network, &cache_path, None, url);

        session.notify = NativeNotif(Some((
            notification_callback,
            self.notif_context as *const libc::c_void,
        )));

        session.connect(&serde_json::Value::Null).unwrap();

        let mnemonic = gdk_common::mnemonic::Mnemonic::from(mnemonic.to_owned());

        let login_data = session.login(&mnemonic, None).unwrap();

        Ok((session, login_data))
    }

    fn process_login_request(&mut self, req: ffi::proto::to::Login) {
        debug!("process login request...");

        self.ws_sender.send(ws::WrappedRequest::Connect).unwrap();

        let login_info = amp::LoginInfo {
            env: self.env,
            mnemonic: Some(req.mnemonic.clone()),
        };
        self.send_amp(amp::To::Login(login_info));

        // Looks like this request does not fail even if wrong network settings are used
        let (session, login_data) = self.create_session(&req.network, &req.mnemonic).unwrap();

        let phone_key = req.phone_key.map(PhoneKey);

        let ctx = Context {
            mnemonic: req.mnemonic,
            session,
            wallet_hash_id: login_data.wallet_hash_id,
            sync_complete: false,
            wallet_loaded_sent: false,
            txs: BTreeMap::new(),
            orders_last: BTreeMap::new(),
            orders_sent: BTreeMap::new(),
            desktop: req.desktop,
            send_utxo_updates: req.send_utxo_updates.unwrap_or_default(),
            stopped: std::sync::Arc::default(),
            jades: BTreeMap::new(),
            succeed_swap: None,
            pending_txs: false,
            active_swap: None,
            send_tx: None,
            active_extern_peg: None,
            sent_txhash: None,
            active_submit: None,
            active_sign: None,
            phone_key,
            subscribes: BTreeSet::new(),
            agent: ureq::agent(),
        };

        if req.desktop && ENABLE_JADE {
            let stopped_copy = ctx.stopped.clone();
            let msg_sender_copy = self.msg_sender.clone();
            std::thread::spawn(move || {
                debug!("start scan jade thread");
                while !stopped_copy.load(std::sync::atomic::Ordering::Relaxed) {
                    std::thread::sleep(std::time::Duration::from_secs(10));
                    let ports_result = sideswap_jade::Handle::ports();
                    match &ports_result {
                        Ok(v) => debug!("jade ports scan succeed: {:?}", v),
                        Err(e) => warn!("jade ports scan failed: {}", e),
                    }
                    let _ =
                        msg_sender_copy.send(Message::ScanJade(ports_result.unwrap_or_default()));
                }
                debug!("quit scan jade thread");
            });
        }

        self.ctx = Some(ctx);

        if self.skip_wallet_sync() {
            info!("skip wallet sync delay");
            self.send_wallet_loaded();
        }

        self.process_pending_requests();
        self.update_tx_list();
        self.resume_peg_monitoring();
        self.update_address_registrations();
        self.download_contacts();

        if let Some(ctx) = self.ctx.as_ref() {
            let result = ctx
                .session
                .refresh_assets(&gdk_common::model::RefreshAssets {
                    icons: true,
                    assets: true,
                    refresh: true,
                });
            if let Err(e) = result {
                error!("assets loading failed: {}", e);
            }
        }
    }

    fn restart_websocket(&mut self) {
        self.connected = false;
        debug!("restart WS connection");
        self.ws_sender.send(ws::WrappedRequest::Disconnect).unwrap();
    }

    fn process_logout_request(&mut self) {
        debug!("process logout request...");

        self.send_amp(amp::To::Logout);

        let _ = self.ctx.as_mut().unwrap().session.disconnect();

        self.ctx = None;

        let persistent = self.settings.persistent.take();
        self.settings = settings::Settings::default();
        self.settings.persistent = persistent;
        self.save_settings();

        self.restart_websocket();
    }

    fn try_change_network(
        &mut self,
        req: ffi::proto::to::ChangeNetwork,
    ) -> Result<(), anyhow::Error> {
        // TODO: Verify that network setting changed
        debug!("process change network request...");
        let ctx = self
            .ctx
            .as_mut()
            .ok_or_else(|| anyhow!("wallet must be set"))?;
        let _ = ctx.session.disconnect();
        let mnemonic = self
            .ctx
            .as_ref()
            .ok_or_else(|| anyhow!("wallet is not known"))?
            .mnemonic
            .clone();

        let (session, _) = self.create_session(&req.network, &mnemonic)?;

        self.ctx.as_mut().unwrap().session = session;

        Ok(())
    }

    fn process_change_network(&mut self, req: ffi::proto::to::ChangeNetwork) {
        let result = self.try_change_network(req);
        if let Err(e) = result {
            self.show_message(&format!("changing network failed: {}", e.to_string()));
        }
    }

    fn process_encrypt_pin(&self, req: ffi::proto::to::EncryptPin) {
        let details = gdk_common::model::PinSetDetails {
            pin: req.pin,
            mnemonic: req.mnemonic,
            device_id: String::new(),
        };
        let result = match ElectrumSession::encrypt_pin(&details) {
            Ok(v) => {
                ffi::proto::from::encrypt_pin::Result::Data(ffi::proto::from::encrypt_pin::Data {
                    salt: v.salt,
                    encrypted_data: v.encrypted_data,
                    pin_identifier: v.pin_identifier,
                })
            }
            Err(e) => ffi::proto::from::encrypt_pin::Result::Error(e.to_string()),
        };
        self.ui.send(ffi::proto::from::Msg::EncryptPin(
            ffi::proto::from::EncryptPin {
                result: Some(result),
            },
        ));
    }

    fn process_decrypt_pin(&self, req: ffi::proto::to::DecryptPin) {
        let details = gdk_common::model::PinGetDetails {
            salt: req.salt,
            encrypted_data: req.encrypted_data,
            pin_identifier: req.pin_identifier,
        };
        let result = match ElectrumSession::decrypt_pin(req.pin, &details) {
            Ok(v) => ffi::proto::from::decrypt_pin::Result::Mnemonic(v.get_mnemonic_str()),
            Err(e) => ffi::proto::from::decrypt_pin::Result::Error(e.to_string()),
        };
        self.ui.send(ffi::proto::from::Msg::DecryptPin(
            ffi::proto::from::DecryptPin {
                result: Some(result),
            },
        ));
    }

    fn process_app_state(&mut self, req: ffi::proto::to::AppState) {
        self.app_active = req.active;
        self.update_amp_connection_status();
        if req.active {
            self.check_connection();
        }
    }

    fn process_peg_status(&mut self, status: PegStatus) {
        let ctx = match self.ctx.as_mut() {
            Some(v) => v,
            None => return,
        };

        let pegs = status
            .list
            .iter()
            .map(|tx| get_peg_item(&status, &tx))
            .collect::<Vec<_>>();

        let mut queue_msgs = Vec::new();

        if let Some(peg) = ctx.active_extern_peg.as_ref() {
            if peg.order_id == status.order_id {
                if let Some(first_peg) = status.list.first() {
                    let peg_item = get_peg_item(&status, first_peg);
                    queue_msgs.push(ffi::proto::from::Msg::SwapSucceed(peg_item));
                    ctx.active_extern_peg = None;
                }
            }
        }

        self.ui.send(ffi::proto::from::Msg::UpdatedPegs(
            ffi::proto::from::UpdatedPegs {
                order_id: status.order_id.to_string(),
                items: pegs,
            },
        ));

        for msg in queue_msgs.into_iter() {
            self.ui.send(msg);
        }
    }

    fn process_subscribe_response(&mut self, msg: SubscribeResponse) {
        for order in msg.orders {
            self.add_order(order, false);
        }
        self.sync_order_list();
    }

    fn process_unsubscribe_response(&mut self, msg: UnsubscribeResponse) {
        // Remove non-own orders from the market that was just unsubscribed
        if let Some(ctx) = self.ctx.as_mut() {
            ctx.orders_last.retain(|_, order| {
                order.own
                    || match &msg.asset {
                        Some(asset_id) => order.asset_id != asset_id.to_string(),
                        None => !order.token_market,
                    }
            });
        }
        self.sync_order_list();
    }

    fn process_market_data_response(&mut self, msg: MarketDataSubscribeResponse) {
        let data = msg.data.into_iter().map(convert_chart_point).collect();
        self.ui.send(ffi::proto::from::Msg::MarketDataSubscribe(
            ffi::proto::from::MarketDataSubscribe {
                asset_id: msg.asset.to_string(),
                data,
            },
        ));
    }

    fn process_asset_details_response(&mut self, msg: AssetDetailsResponse) {
        let stats = msg
            .chain_stats
            .map(|v| ffi::proto::from::asset_details::Stats {
                burned_amount: v.burned_amount,
                issued_amount: v.issued_amount,
                offline_amount: v.offline_amount.unwrap_or_default(),
                has_blinded_issuances: v.has_blinded_issuances,
            });
        let chart_stats = msg
            .chart_stats
            .map(|v| ffi::proto::from::asset_details::ChartStats {
                low: v.low,
                high: v.high,
                last: v.last,
            });
        let from = ffi::proto::from::AssetDetails {
            asset_id: msg.asset_id.to_string(),
            stats,
            chart_url: msg.chart_url,
            chart_stats,
        };
        self.ui.send(ffi::proto::from::Msg::AssetDetails(from));
    }

    fn process_set_memo(&mut self, req: ffi::proto::to::SetMemo) {
        let wallet = self.ctx.as_mut().expect("wallet must be set");
        wallet
            .session
            .set_transaction_memo(&req.txid, &req.memo)
            .expect("setting memo failed");
    }

    fn process_update_push_token(&mut self, req: ffi::proto::to::UpdatePushToken) {
        self.push_token = Some(req.token);
        self.update_push_token();
    }

    fn get_contact_addresses(&self) -> Vec<String> {
        let ctx = self.ctx.as_ref().unwrap();
        let wallet = ctx.session.wallet.as_ref().expect("wallet must be set");
        let indices = wallet
            .read()
            .unwrap()
            .accounts
            .get(&ACCOUNT)
            .unwrap()
            .store
            .read()
            .expect("read store must succeed")
            .cache
            .accounts
            .get(&ACCOUNT)
            .unwrap()
            .indexes
            .clone();
        let start_index = indices.external;
        let end_index = indices.external + CONTACT_ADDRESSES_UPLOAD_COUNT_DEFAULT as u32;
        let mut addresses = Vec::new();
        for pointer in start_index..end_index {
            addresses.push(Data::get_address(
                &wallet.read().unwrap(),
                AddrType::External,
                pointer,
                true,
            ));
        }
        addresses
    }

    fn process_register_phone(&mut self, req: ffi::proto::to::RegisterPhone) {
        let ctx = self.ctx.as_ref().unwrap();
        let register_req = RegisterPhoneRequest {
            number: req.number,
            wallet_hash_id: ctx.wallet_hash_id.clone(),
            addresses: self.get_contact_addresses(),
        };
        let resp = send_request!(self, RegisterPhone, register_req);
        let result = match resp {
            Ok(v) => ffi::proto::from::register_phone::Result::PhoneKey(v.phone_key.0),
            Err(e) => ffi::proto::from::register_phone::Result::ErrorMsg(e.to_string()),
        };
        let from = ffi::proto::from::RegisterPhone {
            result: Some(result),
        };
        self.ui.send(ffi::proto::from::Msg::RegisterPhone(from));
    }

    fn process_verify_phone(&mut self, req: ffi::proto::to::VerifyPhone) {
        let phone_key = PhoneKey(req.phone_key);
        let verify_req = VerifyPhoneRequest {
            phone_key: phone_key.clone(),
            code: req.code,
        };
        let resp = send_request!(self, VerifyPhone, verify_req);
        let verify_succeed = resp.is_ok();
        let result = match resp {
            Ok(_) => ffi::proto::from::verify_phone::Result::Success(ffi::proto::Empty {}),
            Err(e) => ffi::proto::from::verify_phone::Result::ErrorMsg(e.to_string()),
        };
        let from = ffi::proto::from::VerifyPhone {
            result: Some(result),
        };
        self.ui.send(ffi::proto::from::Msg::VerifyPhone(from));
        if verify_succeed {
            let ctx = self.ctx.as_mut().unwrap();
            ctx.phone_key = Some(phone_key);
            self.download_contacts();
        }
    }

    fn process_unregister_phone(&mut self, req: ffi::proto::to::UnregisterPhone) {
        self.settings
            .get_persistent()
            .unregister_phone_requests
            .get_or_insert_with(|| BTreeSet::new())
            .insert(PhoneKey(req.phone_key));
        self.save_settings();
        self.process_unregister_phone_requests();
    }

    fn process_upload_avatar(&mut self, req: ffi::proto::to::UploadAvatar) {
        let upload_req = UploadAvatarRequest {
            phone_key: PhoneKey(req.phone_key),
            image: req.image,
        };
        let resp = send_request!(self, UploadAvatar, upload_req);
        let result = ffi::proto::GenericResponse {
            success: resp.is_ok(),
            error_msg: resp.err().map(|e| e.to_string()),
        };
        self.ui.send(ffi::proto::from::Msg::UploadAvatar(result));
    }

    fn process_upload_contacts(&mut self, req: ffi::proto::to::UploadContacts) {
        let contacts = req
            .contacts
            .into_iter()
            .map(|item| UploadContact {
                identifier: item.identifier,
                name: item.name,
                phones: item.phones,
            })
            .collect();
        let upload_req = UploadContactsRequest {
            phone_key: PhoneKey(req.phone_key),
            contacts,
        };
        let resp = send_request!(self, UploadContacts, upload_req);
        let result = ffi::proto::GenericResponse {
            success: resp.is_ok(),
            error_msg: resp.err().map(|e| e.to_string()),
        };
        self.ui.send(ffi::proto::from::Msg::UploadContacts(result));
    }

    fn get_balance(&self, asset: &AssetId) -> Amount {
        self.ctx
            .as_ref()
            .and_then(|ctx| {
                let balance_opts = gdk_common::model::GetBalanceOpt {
                    subaccount: ACCOUNT,
                    num_confs: BALANCE_NUM_CONFS,
                    confidential_utxos_only: None,
                };
                ctx.session
                    .get_balance(&balance_opts)
                    .ok()
                    .unwrap_or_default()
                    .get(&asset.to_string())
                    .map(|balance| Amount::from_sat(*balance))
            })
            .unwrap_or_default()
    }

    fn try_process_submit_order(
        &mut self,
        req: ffi::proto::to::SubmitOrder,
    ) -> Result<(), anyhow::Error> {
        debug!(
            "submit order, bitcoin_amount: {:?}, asset_amount: {:?}",
            req.bitcoin_amount, req.asset_amount
        );
        let asset = AssetId::from_str(&req.asset_id).unwrap();
        let is_amp = self.amp_assets.contains(&asset);

        if is_amp {
            ensure!(
                req.account.id == ACCOUNT_ID_AMP,
                "AMP asset order is expected to be from AMP account"
            );
        } else {
            ensure!(
                req.account.id == ACCOUNT_ID_REGULAR,
                "Non AMP asset order is expected to be from non-AMP account"
            );
        }
        let bitcoin_amount = match req.bitcoin_amount {
            Some(v) => {
                let bitcoin_balance = self.get_balance(&self.liquid_asset_id);
                if bitcoin_balance.to_bitcoin() == -v {
                    let bitcoin_amount = types::get_max_bitcoin_amount(bitcoin_balance)?;
                    let server_fee = types::get_server_fee(bitcoin_amount);
                    debug!(
                        "bitcoin_balance: {}, bitcoin_amount: {}, server_fee: {}",
                        bitcoin_balance.to_bitcoin(),
                        bitcoin_amount.to_bitcoin(),
                        server_fee.to_bitcoin(),
                    );
                    Some(-bitcoin_amount.to_bitcoin())
                } else {
                    Some(v)
                }
            }
            None => None,
        };
        let order = PriceOrder {
            asset,
            bitcoin_amount,
            asset_amount: req.asset_amount,
            price: Some(req.price),
            index_price: req.index_price,
        };
        let submit_req = SubmitRequest { order };
        let resp = send_request!(self, Submit, submit_req)?;

        self.try_process_link_order(resp.order_id)
    }

    fn try_process_link_order(&mut self, order_id: OrderId) -> Result<(), anyhow::Error> {
        let link_req = LinkRequest {
            order_id: order_id.clone(),
        };
        let resp = send_request!(self, Link, link_req)?;
        self.downloaded_links.push(resp);
        Ok(())
    }

    fn try_process_downloaded_link(
        &mut self,
        resp: LinkResponse,
    ) -> Result<Option<ffi::proto::from::Msg>, anyhow::Error> {
        let order_id = resp.order_id;
        let details = &resp.details;

        self.try_add_asset(&details.asset)?;

        let (send_amount, send_asset) = if details.send_bitcoins {
            (
                details.bitcoin_amount + details.server_fee,
                &self.liquid_asset_id,
            )
        } else {
            (details.asset_amount, &details.asset)
        };

        let is_amp = self.amp_assets.contains(&send_asset);
        let available_balance = if is_amp {
            self.amp.get_balance(&send_asset)
        } else {
            self.get_balance(send_asset)
        };
        debug!(
            "available_balance: {}, send_amount: {}",
            available_balance.to_sat(),
            send_amount
        );
        let send_asset = if resp.details.send_bitcoins {
            &self.liquid_asset_id
        } else {
            &resp.details.asset
        };

        if available_balance.to_sat() < send_amount {
            return Ok(Some(ffi::proto::from::Msg::InsufficientFunds(
                ffi::proto::from::ShowInsufficientFunds {
                    asset_id: send_asset.to_string(),
                    available: available_balance.to_sat(),
                    required: send_amount,
                },
            )));
        }

        let step = if details.side == OrderSide::Maker {
            ffi::proto::from::submit_review::Step::Submit
        } else {
            ffi::proto::from::submit_review::Step::Quote
        };
        let auto_sign = self
            .submit_data
            .get(&order_id)
            .map(|submit| submit.auto_sign)
            .unwrap_or(false);
        let submit_review = ffi::proto::from::SubmitReview {
            order_id: order_id.to_string(),
            asset: details.asset.to_string(),
            bitcoin_amount: details.bitcoin_amount,
            asset_amount: details.asset_amount,
            price: details.price,
            sell_bitcoin: details.send_bitcoins,
            server_fee: details.server_fee,
            step: step as i32,
            index_price: resp.index_price,
            auto_sign,
        };
        debug!("send for review quote prompt, order_id: {}", order_id);
        self.ui
            .send(ffi::proto::from::Msg::SubmitReview(submit_review));
        self.visible_submit = Some(order_id.clone());
        let ctx = self.ctx.as_mut().ok_or(anyhow!("no context found"))?;
        ctx.active_submit = Some(resp);
        Ok(None)
    }

    fn process_submit_order(&mut self, req: ffi::proto::to::SubmitOrder) {
        // Fix problem with iOS when app is resumed from background
        //self.restart_websocket();
        self.pending_submits.push(req);
        self.process_pending_requests();
    }

    fn process_link_order(&mut self, req: ffi::proto::to::LinkOrder) {
        self.pending_links.push(req);
        self.process_pending_requests();
    }

    fn verify_amounts(&self, details: &Details) -> Result<(), anyhow::Error> {
        ensure!(details.asset != self.liquid_asset_id);
        ensure!(details.price > 0.0);
        ensure!(details.bitcoin_amount >= types::MIN_BITCOIN_AMOUNT.to_sat());
        ensure!(details.server_fee >= types::MIN_SERVER_FEE.to_sat());
        ensure!(details.asset_amount > 0);
        ensure!(details.server_fee < details.bitcoin_amount);
        let asset = self
            .assets
            .get(&details.asset)
            .ok_or(anyhow!("unknown asset"))?;
        ensure!(asset.precision <= 8);
        // Verify price
        match details.order_type {
            OrderType::Bitcoin => {
                // Allow only assets with precision 8 when bitcoin_amount is fixed
                ensure!(asset.precision == 8);
                let expected_asset_amount = types::asset_amount(
                    details.bitcoin_amount,
                    details.price,
                    asset.precision,
                    details.market,
                );
                ensure!(
                    expected_asset_amount == details.asset_amount,
                    "unexpected asset amount: {}, expected: {}, bitcoin amount: {}, price: {}",
                    details.asset_amount,
                    expected_asset_amount,
                    details.bitcoin_amount,
                    details.price
                );
            }
            OrderType::Asset => {
                // Allow assets with any precision when asset_amount is fixed
                let expected_bitcoin_amount = types::bitcoin_amount(
                    details.asset_amount,
                    details.price,
                    asset.precision,
                    details.market,
                );
                ensure!(
                    expected_bitcoin_amount == details.bitcoin_amount,
                    "unexpected bitcoin amount: {}, expected: {}, asset amount: {}, price: {}",
                    details.bitcoin_amount,
                    expected_bitcoin_amount,
                    details.asset_amount,
                    details.price
                );
            }
        };
        let server_fee = types::get_server_fee(Amount::from_sat(details.bitcoin_amount));
        ensure!(details.server_fee == server_fee.to_sat());
        Ok(())
    }

    fn get_electrum_swap_inputs(&self, send_asset: &AssetId) -> Result<SwapInputs, anyhow::Error> {
        let ctx = self.ctx.as_ref().ok_or(anyhow!("no context found"))?;

        let change_addr = ctx
            .session
            .get_receive_address(&gdk_common::model::GetAddressOpt {
                subaccount: ACCOUNT,
                address_type: None,
            })
            .unwrap()
            .address;

        let mut all_utxos = ctx
            .session
            .get_unspent_outputs(&gdk_common::model::GetUnspentOpt {
                subaccount: ACCOUNT,
                num_confs: Some(BALANCE_NUM_CONFS),
                confidential_utxos_only: None,
                all_coins: None,
            })
            .map_err(|_| anyhow!("getting unspent outputs failed"))?;
        let all_asset_utxos = all_utxos
            .0
            .remove(&send_asset.to_string())
            .unwrap_or_default();

        let wallet = ctx
            .session
            .wallet
            .as_ref()
            .expect("wallet must be set")
            .read()
            .unwrap();
        let store_read = wallet.store.read().expect("store must be set");
        let acc_store = store_read.account_cache(ACCOUNT).unwrap();
        let account = wallet.accounts.get(&ACCOUNT).unwrap();

        let mut inputs = Vec::new();
        for utxo in all_asset_utxos {
            let unblinded = acc_store
                .unblinded
                .get(&elements::OutPoint {
                    txid: elements::Txid::from_str(&utxo.txhash).unwrap(),
                    vout: utxo.pt_idx,
                })
                .ok_or_else(|| anyhow!("can't find unblinded"))?;

            let public_key = account
                .xpub
                .derive_pub(&self.secp, &utxo.derivation_path)
                .unwrap()
                .public_key;
            let redeem_script = sideswap_common::pset::p2shwpkh_redeem_script(&public_key).to_hex();

            inputs.push(PsetInput {
                txid: Txid::from_str(&utxo.txhash).unwrap(),
                vout: utxo.pt_idx,
                asset: send_asset.clone(),
                asset_bf: Hash32::from_str(&unblinded.asset_bf.to_string()).unwrap(),
                value: unblinded.value,
                value_bf: Hash32::from_str(&unblinded.value_bf.to_string()).unwrap(),
                redeem_script: Some(redeem_script.to_string()),
            });
        }

        Ok(SwapInputs {
            inputs,
            change_addr,
        })
    }

    fn get_electrum_recv_address(&self, change_addr: &str) -> Result<String, anyhow::Error> {
        // GDK rust sometimes returns same address, get new address in a loop until unique address is received.
        loop {
            let ctx = self.ctx.as_ref().ok_or(anyhow!("no context found"))?;
            let recv_addr = ctx
                .session
                .get_receive_address(&gdk_common::model::GetAddressOpt {
                    subaccount: ACCOUNT,
                    address_type: None,
                })
                .map_err(|e| anyhow!("{}", e))?
                .address;
            if change_addr != recv_addr {
                return Ok(recv_addr);
            }
        }
    }

    fn try_process_submit_decision(
        &mut self,
        req: ffi::proto::to::SubmitDecision,
    ) -> Result<bool, anyhow::Error> {
        if !req.accept {
            return Ok(true);
        }
        let ctx = self.ctx.as_mut().ok_or(anyhow!("no context found"))?;
        let is_sign = ctx
            .active_sign
            .as_ref()
            .map(|sign| sign.order_id.to_string() == req.order_id)
            .unwrap_or(false);
        if is_sign {
            let sign_msg = ctx.active_sign.take().unwrap();
            return self.try_sign(sign_msg);
        }
        let resp = ctx.active_submit.take().ok_or(anyhow!("data not found"))?;
        let index_price = resp.index_price;
        let details = resp.details;
        let side = details.side;
        let order_id = OrderId::from_str(&req.order_id)?;
        let asset = self
            .assets
            .get(&details.asset)
            .ok_or(anyhow!("unknown asset"))?;
        self.verify_amounts(&details)?;

        let asset_amount = Amount::from_sat(details.asset_amount);
        let bitcoin_asset = self.liquid_asset_id.clone();
        let (send_asset, send_amount, recv_asset) = if details.send_bitcoins {
            (
                bitcoin_asset,
                details.bitcoin_amount + details.server_fee,
                details.asset,
            )
        } else {
            (details.asset.clone(), asset_amount.to_sat(), bitcoin_asset)
        };
        let is_send_amp = self.amp_assets.contains(&send_asset);
        let is_recv_amp = self.amp_assets.contains(&recv_asset);

        let swap_inputs = if is_send_amp {
            self.amp.get_swap_inputs(&send_asset)
        } else {
            self.get_electrum_swap_inputs(&send_asset)
        }?;

        let (recv_addr, recv_gaid) = if is_recv_amp {
            (None, Some(self.amp.get_gaid()?))
        } else {
            (
                Some(self.get_electrum_recv_address(&swap_inputs.change_addr)?),
                None,
            )
        };

        let reserved_txouts = self
            .submit_data
            .values()
            .flat_map(|item| item.txouts.iter())
            .collect::<BTreeSet<_>>();
        let filtered_utxos = swap_inputs
            .inputs
            .iter()
            .filter(|utxo| {
                reserved_txouts
                    .get(&TxOut::new(utxo.txid, utxo.vout))
                    .is_none()
            })
            .cloned()
            .collect::<Vec<_>>();
        let filtered_amount = filtered_utxos.iter().map(|utxo| utxo.value).sum::<u64>() as i64;
        let mut asset_utxos = if filtered_amount >= send_amount {
            filtered_utxos
        } else {
            swap_inputs.inputs
        };
        let change_addr = swap_inputs.change_addr;

        let utxo_amounts: Vec<_> = asset_utxos.iter().map(|v| v.value as i64).collect();
        let total: i64 = utxo_amounts.iter().sum();
        ensure!(total >= send_amount, "Insufficient funds");

        let selected = types::select_utxo(utxo_amounts, send_amount);
        let selected_amount: i64 = selected.iter().cloned().sum();
        assert!(selected_amount >= send_amount);

        let mut inputs = Vec::<PsetInput>::new();

        for amount in selected {
            let index = asset_utxos
                .iter()
                .position(|v| v.value as i64 == amount)
                .expect("utxo must exists");
            let utxo = asset_utxos.swap_remove(index);

            inputs.push(utxo);
        }

        let txouts = inputs
            .iter()
            .map(|input| TxOut {
                txid: input.txid.clone(),
                vout: input.vout,
            })
            .collect::<BTreeSet<_>>();

        if details.side == OrderSide::Maker {
            let addr_req = PsetMakerRequest {
                order_id: order_id.clone(),
                price: details.price,
                private: req.private.unwrap_or(false),
                ttl_seconds: req.ttl_seconds,
                inputs,
                recv_addr,
                recv_gaid,
                change_addr,
            };
            send_request!(self, PsetMaker, addr_req)?;
        } else {
            let addr_req = PsetTakerRequest {
                order_id: order_id.clone(),
                price: details.price,
                inputs,
                recv_addr,
                recv_gaid,
                change_addr,
            };
            send_request!(self, PsetTaker, addr_req)?;
        };

        let bitcoin_amount = Amount::from_sat(details.bitcoin_amount);
        let sell_bitcoin = details.send_bitcoins;
        let price = details.price;
        let server_fee = Amount::from_sat(details.server_fee);
        let auto_sign = req.auto_sign.unwrap_or(false) && side == OrderSide::Maker;

        let submit_data = SubmitData {
            order_id: order_id.clone(),
            side,
            asset: details.asset,
            asset_precision: asset.precision,
            order_type: details.order_type,
            bitcoin_amount,
            asset_amount,
            price,
            server_fee,
            sell_bitcoin,
            txouts,
            auto_sign,
            txid: None,
            index_price,
            market: details.market,
            signed: false,
        };
        self.submit_data
            .insert(submit_data.order_id.clone(), submit_data);
        let done = side == OrderSide::Maker;

        Ok(done)
    }

    fn process_submit_decision(&mut self, req: ffi::proto::to::SubmitDecision) {
        let result = self.try_process_submit_decision(req);
        let result = match result {
            Ok(true) => {
                ffi::proto::from::submit_result::Result::SubmitSucceed(ffi::proto::Empty {})
            }
            Ok(false) => {
                self.waiting_submit = std::mem::replace(&mut self.visible_submit, None);
                self.process_pending_sign_prompts();
                self.process_pending_succeed();
                return;
            }
            Err(e) => {
                error!("submit failed: {}", e);
                ffi::proto::from::submit_result::Result::Error(e.to_string())
            }
        };
        let from = ffi::proto::from::SubmitResult {
            result: Some(result),
        };
        self.ui.send(ffi::proto::from::Msg::SubmitResult(from));
        self.visible_submit = None;
        self.process_pending_sign_prompts();
        self.process_pending_succeed();
    }

    fn try_sign(&mut self, msg: SignNotification) -> Result<bool, anyhow::Error> {
        let ctx = self.ctx.as_ref().ok_or_else(|| anyhow!("no wallet"))?;
        let submit_data = self
            .submit_data
            .get(&msg.order_id)
            .ok_or_else(|| anyhow!("no keys found"))?;
        ensure!(submit_data.order_id == msg.order_id, "unexpected order_id");
        let amounts = if submit_data.sell_bitcoin {
            swaps::Amounts {
                send_asset: self.liquid_asset_id,
                recv_asset: submit_data.asset,
                send_amount: (submit_data.bitcoin_amount + submit_data.server_fee).to_sat() as u64,
                recv_amount: submit_data.asset_amount.to_sat() as u64,
            }
        } else {
            swaps::Amounts {
                send_asset: submit_data.asset,
                recv_asset: self.liquid_asset_id,
                send_amount: submit_data.asset_amount.to_sat() as u64,
                recv_amount: (submit_data.bitcoin_amount - submit_data.server_fee).to_sat() as u64,
            }
        };
        let send_amp = self.amp_assets.contains(&amounts.send_asset);
        let recv_amp = self.amp_assets.contains(&amounts.recv_asset);

        let wallet = ctx.session.wallet.as_ref().expect("wallet must be set");
        let wallet = wallet.read().unwrap();
        let account = wallet.accounts.get(&ACCOUNT).unwrap();
        let blinded_pset = elements_pset::encode::deserialize::<
            elements_pset::pset::PartiallySignedTransaction,
        >(&base64::decode(&msg.pset)?)?;

        let pset_amp_utxos = if send_amp || recv_amp {
            self.amp
                .verify_pset(&amounts, &msg.pset, send_amp, recv_amp)?
        } else {
            Vec::new()
        };

        if send_amp {
            swaps::verify_pset_recv_output(&self.secp, account, &amounts, &blinded_pset)?;
        }

        let signed_pset = if send_amp {
            let nonces = msg
                .nonces
                .as_ref()
                .ok_or_else(|| anyhow!("blinding keys should be known"))?;
            self.amp.sign_pset(&msg.pset, nonces, pset_amp_utxos)?
        } else {
            let signed_pset = swaps::sign_and_verify_pset(
                &self.secp,
                account,
                &amounts,
                &blinded_pset,
                recv_amp,
            )?;
            base64::encode(elements_pset::encode::serialize(&signed_pset))
        };

        send_request!(
            self,
            Sign,
            SignRequest {
                order_id: msg.order_id.clone(),
                signed_pset,
                side: submit_data.side,
            }
        )?;

        let submit_data = self.submit_data.get_mut(&msg.order_id).unwrap();
        submit_data.signed = true;

        Ok(false)
    }

    fn try_process_sign(&mut self, msg: SignNotification) -> Result<(), anyhow::Error> {
        let existing = self.processed_signs.contains(&msg.order_id);
        debug!(
            "try_process_sign, order_id: {}, existing: {}",
            msg.order_id, existing
        );
        if existing {
            return Ok(());
        }
        self.processed_signs.insert(msg.order_id.clone());

        self.verify_amounts(&msg.details)?;
        let order_id = msg.order_id.clone();
        let submit_data = self
            .submit_data
            .get_mut(&msg.order_id)
            .ok_or_else(|| anyhow!("no keys found"))?;
        ensure!(order_id == submit_data.order_id);
        let price_change = f64::abs(msg.details.price - submit_data.price) / submit_data.price;
        ensure!(submit_data.sell_bitcoin == msg.details.send_bitcoins);
        ensure!(submit_data.order_type == msg.details.order_type);
        ensure!(submit_data.asset == msg.details.asset);
        match submit_data.order_type {
            OrderType::Bitcoin => {
                ensure!(submit_data.server_fee.to_sat() == msg.details.server_fee);
                ensure!(submit_data.bitcoin_amount.to_sat() == msg.details.bitcoin_amount);
            }
            OrderType::Asset => {
                ensure!(submit_data.asset_amount.to_sat() == msg.details.asset_amount);
            }
        };
        ensure!(submit_data.side == msg.details.side);
        ensure!(price_change == 0.0 || submit_data.side != OrderSide::Taker);

        // Maker: Auto-sign is only allowed if price does not change (or changes within 10% for price tracking orders).
        // Taker: Auto-sign is always used because price was already reviewed earlier (and can't change since that).
        let allowed_price_change = if submit_data.index_price {
            AUTO_SIGN_ALLOWED_INDEX_PRICE_CHANGE
        } else {
            0.0
        };
        let auto_sign_allowed = submit_data.side == OrderSide::Taker
            || (submit_data.side == OrderSide::Maker
                && submit_data.auto_sign
                && price_change <= allowed_price_change);
        debug!(
            "auto sign allowed: {}, current price: {}, selected price: {}",
            auto_sign_allowed, submit_data.price, msg.details.price,
        );
        // Always update to the selected amounts.
        // They are checked to be valid for the selected price.
        // And we only need to review them if auto-sign is not allowed.
        // Price could change if user edit it on web page for external requests.
        // Or if taker reviewed and accepted order that was edited later.
        submit_data.price = msg.details.price;
        submit_data.asset_amount = Amount::from_sat(msg.details.asset_amount);
        submit_data.bitcoin_amount = Amount::from_sat(msg.details.bitcoin_amount);
        submit_data.server_fee = Amount::from_sat(msg.details.server_fee);
        if !auto_sign_allowed {
            self.pending_sign_prompts.push_back(msg);
            self.process_pending_sign_prompts();
        } else {
            self.try_sign(msg)?;
        }
        Ok(())
    }

    fn process_sign(&mut self, msg: SignNotification) {
        debug!("process sign, order_id: {}", msg.order_id);
        if msg.details.side == OrderSide::Taker {
            let result = self.try_process_sign(msg);
            if let Err(e) = result {
                self.show_message(&format!("sign failed: {}", e.to_string()));
            }
            return;
        }

        self.pending_sign_requests.push_back(msg);
        self.update_amp_connection_status();
        self.process_pending_requests();
    }

    fn process_pending_sign_prompts(&mut self) {
        debug!(
            "process_pending_sign_prompts: sign_prompts: {}, visible_submit: {}",
            self.pending_sign_prompts.len(),
            self.visible_submit.is_some(),
        );
        let ctx = match self.ctx.as_mut() {
            Some(v) => v,
            None => return,
        };
        loop {
            if self.visible_submit.is_some() {
                return;
            }
            let msg = self.pending_sign_prompts.pop_front();
            let msg = match msg {
                Some(v) => v,
                None => return,
            };
            let submit_data = match self.submit_data.get(&msg.order_id) {
                Some(v) => v,
                None => continue,
            };
            let step = ffi::proto::from::submit_review::Step::Sign;
            let submit_review = ffi::proto::from::SubmitReview {
                order_id: msg.order_id.to_string(),
                asset: submit_data.asset.to_string(),
                bitcoin_amount: submit_data.bitcoin_amount.to_sat(),
                asset_amount: submit_data.asset_amount.to_sat(),
                price: submit_data.price,
                server_fee: submit_data.server_fee.to_sat(),
                sell_bitcoin: submit_data.sell_bitcoin,
                step: step as i32,
                index_price: submit_data.index_price,
                auto_sign: submit_data.auto_sign,
            };
            debug!("send for review sign prompt for {}", msg.order_id);
            self.ui
                .send(ffi::proto::from::Msg::SubmitReview(submit_review));
            self.visible_submit = Some(msg.order_id.clone());
            ctx.active_sign = Some(msg);
        }
    }

    fn process_pending_succeed(&mut self) {
        if self.visible_submit.is_some() {
            return;
        }
        loop {
            let item = self.pending_succeed.pop_front();
            let item = match item {
                Some(v) => v,
                None => return,
            };
            self.ui.send(ffi::proto::from::Msg::SubmitResult(
                ffi::proto::from::SubmitResult {
                    result: Some(ffi::proto::from::submit_result::Result::SwapSucceed(item)),
                },
            ));
            if !self.pending_succeed.is_empty() {
                std::thread::sleep(std::time::Duration::from_secs(3));
            }
        }
    }

    fn try_edit_order_price(
        &mut self,
        order_id: OrderId,
        price: Option<f64>,
        index_price: Option<f64>,
    ) -> Result<(), anyhow::Error> {
        send_request!(
            self,
            Edit,
            EditRequest {
                order_id: order_id.clone(),
                price: price,
                index_price: index_price,
            }
        )?;
        if let Some(price) = price {
            // Update order to allow auto-sign to proceed
            if let Some(submit_data) = self.submit_data.get_mut(&order_id) {
                submit_data.price = price;
                match submit_data.order_type {
                    OrderType::Bitcoin => {
                        let asset_amount = Amount::from_sat(types::asset_amount(
                            submit_data.bitcoin_amount.to_sat(),
                            price,
                            submit_data.asset_precision,
                            submit_data.market,
                        ));
                        submit_data.asset_amount = asset_amount;
                    }
                    OrderType::Asset => {
                        let bitcoin_amount = Amount::from_sat(types::bitcoin_amount(
                            submit_data.asset_amount.to_sat(),
                            price,
                            submit_data.asset_precision,
                            submit_data.market,
                        ));
                        submit_data.bitcoin_amount = bitcoin_amount;
                        submit_data.server_fee = types::get_server_fee(bitcoin_amount);
                    }
                }
            }
        }
        Ok(())
    }

    fn try_edit_order_auto_sign(
        &mut self,
        order_id: OrderId,
        auto_sign: bool,
    ) -> Result<(), anyhow::Error> {
        let ctx = self.ctx.as_mut().ok_or(anyhow!("no context found"))?;
        let submit = self
            .submit_data
            .get_mut(&order_id)
            .ok_or_else(|| anyhow!("submit data not found"))?;
        let order = ctx
            .orders_last
            .get_mut(&order_id)
            .ok_or_else(|| anyhow!("order not found"))?;
        submit.auto_sign = auto_sign;
        order.auto_sign = auto_sign;
        Ok(())
    }

    fn process_edit_order(&mut self, req: ffi::proto::to::EditOrder) {
        let order_id = OrderId::from_str(&req.order_id).unwrap();
        let data = req.data.unwrap();
        let (price, index_price, auto_sign) = match data {
            ffi::proto::to::edit_order::Data::Price(v) => (Some(v), None, None),
            ffi::proto::to::edit_order::Data::IndexPrice(v) => (None, Some(v), None),
            ffi::proto::to::edit_order::Data::AutoSign(v) => (None, None, Some(v)),
        };

        let edit_result = if let Some(auto_sign) = auto_sign {
            self.try_edit_order_auto_sign(order_id, auto_sign)
        } else {
            self.try_edit_order_price(order_id, price, index_price)
        };
        let result = ffi::proto::GenericResponse {
            success: edit_result.is_ok(),
            error_msg: edit_result.err().map(|e| e.to_string()),
        };
        self.ui.send(ffi::proto::from::Msg::EditOrder(result));
        self.sync_order_list();
    }

    fn process_cancel_order(&mut self, req: ffi::proto::to::CancelOrder) {
        let cancel_result = send_request!(
            self,
            Cancel,
            CancelRequest {
                order_id: OrderId::from_str(&req.order_id).unwrap(),
            }
        );
        let result = ffi::proto::GenericResponse {
            success: cancel_result.is_ok(),
            error_msg: cancel_result.err().map(|e| e.to_string()),
        };
        self.ui.send(ffi::proto::from::Msg::CancelOrder(result));
    }

    fn process_subscribe(&mut self, req: ffi::proto::to::Subscribe) {
        let ctx = match self.ctx.as_ref() {
            Some(v) => v,
            None => return,
        };
        let new_subscribes = req
            .markets
            .iter()
            .map(|market| {
                market
                    .asset_id
                    .as_ref()
                    .map(|asset_id| AssetId::from_str(asset_id).unwrap())
            })
            .collect();

        for unsubscribe in ctx.subscribes.difference(&new_subscribes) {
            self.send_request_msg(Request::Unsubscribe(UnsubscribeRequest {
                asset: unsubscribe.clone(),
            }));
        }
        for subscribe in new_subscribes.difference(&ctx.subscribes) {
            self.send_request_msg(Request::Subscribe(SubscribeRequest {
                asset: subscribe.clone(),
            }));
        }

        let ctx = self.ctx.as_mut().unwrap();
        ctx.subscribes = new_subscribes;
    }

    fn process_asset_details(&mut self, req: ffi::proto::AssetId) {
        self.send_request_msg(Request::AssetDetails(AssetDetailsRequest {
            asset_id: AssetId::from_str(&req.asset_id).unwrap(),
        }));
    }

    fn process_subscribe_price(&mut self, req: ffi::proto::AssetId) {
        let asset = AssetId::from_str(&req.asset_id).unwrap();
        self.send_request_msg(Request::LoadPrices(LoadPricesRequest { asset }));
    }

    fn process_unsubscribe_price(&mut self, req: ffi::proto::AssetId) {
        let asset = AssetId::from_str(&req.asset_id).unwrap();
        self.send_request_msg(Request::CancelPrices(CancelPricesRequest { asset }));
    }

    fn process_subscribe_price_stream(&mut self, req: ffi::proto::to::SubscribePriceStream) {
        let req = SubscribePriceStreamRequest {
            subscribe_id: None,
            asset: AssetId::from_str(&req.asset_id).unwrap(),
            send_bitcoins: req.send_bitcoins,
            send_amount: req.send_amount,
            recv_amount: req.recv_amount,
        };
        if self.subscribed_price_stream.as_ref() != Some(&req) {
            self.subscribed_price_stream = Some(req.clone());
            self.send_request_msg(Request::SubscribePriceStream(req));
        }
    }

    fn process_unsubscribe_price_stream(&mut self) {
        if self.subscribed_price_stream.is_some() {
            self.subscribed_price_stream = None;
            self.send_request_msg(Request::UnsubscribePriceStream(
                UnsubscribePriceStreamRequest { subscribe_id: None },
            ));
        }
    }

    fn process_market_data_subscribe(&mut self, req: ffi::proto::to::MarketDataSubscribe) {
        let asset_id = AssetId::from_str(&req.asset_id).unwrap();
        self.process_market_data_unsubscribe();
        if self.connected {
            self.send_request_msg(Request::MarketDataSubscribe(MarketDataSubscribeRequest {
                asset: asset_id,
            }));
        }
        self.subscribed_market_data = Some(asset_id);
    }

    fn process_market_data_unsubscribe(&mut self) {
        if let (true, Some(asset_id)) = (self.connected, self.subscribed_market_data) {
            self.send_request_msg(Request::MarketDataUnsubscribe(
                MarketDataUnsubscribeRequest { asset: asset_id },
            ));
        }
        self.subscribed_market_data = None;
    }

    fn send_subscribe_request(&self) {
        let ctx = match self.ctx.as_ref() {
            Some(v) => v,
            None => return,
        };
        for subscribe in ctx.subscribes.iter() {
            self.send_request_msg(Request::Subscribe(SubscribeRequest {
                asset: subscribe.clone(),
            }));
        }
    }

    fn process_complete(&mut self, msg: CompleteNotification) {
        self.ui.send(ffi::proto::from::Msg::OrderComplete(
            ffi::proto::from::OrderComplete {
                order_id: msg.order_id.to_string(),
                txid: msg.txid.map(|v| v.to_string()),
            },
        ));

        match msg.txid {
            Some(v) => {
                let submit_data = match self.submit_data.get_mut(&msg.order_id) {
                    Some(v) => v,
                    None => return,
                };
                submit_data.txid = Some(v.to_string())
            }
            None => {
                let submit = self.submit_data.remove(&msg.order_id);
                if self.visible_submit.as_ref() == Some(&msg.order_id)
                    || (self.visible_submit.is_none()
                        && self.waiting_submit.as_ref() == Some(&msg.order_id))
                {
                    let is_maker = submit
                        .as_ref()
                        .map(|v| v.side == OrderSide::Maker)
                        .unwrap_or(false);
                    let signed = submit.as_ref().map(|v| v.signed).unwrap_or(false);
                    self.ui.send(ffi::proto::from::Msg::SubmitResult(
                        ffi::proto::from::SubmitResult {
                            result: Some(ffi::proto::from::submit_result::Result::Error(
                                if is_maker {
                                    "Failed to sign".to_owned()
                                } else if !signed {
                                    "Order removed".to_owned()
                                } else {
                                    "Counterparty failed to sign".to_owned()
                                },
                            )),
                        },
                    ));
                    self.visible_submit = None;
                    self.process_pending_sign_prompts();
                    self.process_pending_succeed();
                }
            }
        }
    }

    fn add_order(&mut self, msg: OrderCreatedNotification, from_notification: bool) {
        let add_asset_result = self.try_add_asset(&msg.details.asset);
        if let Err(e) = add_asset_result {
            error!("adding asset for new order failed: {}", e);
        }
        if msg.own.is_some() {
            let adding_result = self.add_missing_submit_data(&msg.order_id, &msg.details);
            if let Err(e) = adding_result {
                error!("adding missing submit data failed: {}", e);
            }
        }
        let ctx = match self.ctx.as_mut() {
            Some(v) => v,
            None => return,
        };

        let private = msg.own.as_ref().map(|v| v.private).unwrap_or(false);
        let swap_market = self.assets.get(&msg.details.asset).is_some();
        let amp_market = self.amp_assets.get(&msg.details.asset).is_some();
        let token_market = !swap_market && !amp_market;
        let auto_sign = self
            .submit_data
            .get(&msg.order_id)
            .map(|submit| submit.auto_sign)
            .unwrap_or(false);
        let own = msg.own.is_some();
        let index_price = msg.own.as_ref().and_then(|v| v.index_price);
        let order = ffi::proto::Order {
            order_id: msg.order_id.to_string(),
            asset_id: msg.details.asset.to_string(),
            bitcoin_amount: msg.details.bitcoin_amount,
            send_bitcoins: msg.details.send_bitcoins,
            server_fee: msg.details.server_fee,
            asset_amount: msg.details.asset_amount,
            price: msg.details.price,
            created_at: msg.created_at,
            expires_at: msg.expires_at,
            private,
            auto_sign,
            own,
            token_market,
            from_notification,
            index_price,
        };
        ctx.orders_last.insert(msg.order_id, order);
    }

    fn remove_order(&mut self, order_id: &OrderId) {
        let ctx = match self.ctx.as_mut() {
            Some(v) => v,
            None => return,
        };
        ctx.orders_last.remove(order_id);
    }

    fn process_order_created(&mut self, msg: OrderCreatedNotification) {
        self.add_order(msg, true);
        self.sync_order_list();
    }

    fn process_order_removed(&mut self, msg: OrderRemovedNotification) {
        self.remove_order(&msg.order_id);
        self.sync_order_list();
    }

    fn process_update_prices(&self, msg: LoadPricesResponse) {
        let index_price = ffi::proto::from::IndexPrice {
            asset_id: msg.asset.to_string(),
            ind: msg.ind,
            last: msg.last,
        };
        self.ui.send(ffi::proto::from::Msg::IndexPrice(index_price));
    }

    fn process_contact_created(&mut self, contact: Contact) {
        let contact = ffi::proto::Contact {
            contact_key: contact.contact_key.0,
            name: contact.name,
            phone: contact.phone,
        };
        self.ui.send(ffi::proto::from::Msg::ContactCreated(contact));
    }

    fn process_contact_removed(&mut self, contact_key: ContactKey) {
        let contact_removed = ffi::proto::from::ContactRemoved {
            contact_key: contact_key.0,
        };
        self.ui
            .send(ffi::proto::from::Msg::ContactRemoved(contact_removed));
    }

    fn process_contact_tx(&mut self, tx: ContactTransaction) {
        let contact_transaction = ffi::proto::ContactTransaction {
            contact_key: tx.contact_key.0,
            txid: tx.txid,
        };
        self.ui.send(ffi::proto::from::Msg::ContactTransaction(
            contact_transaction,
        ));
    }

    fn process_account_status(&mut self, registered: bool) {
        let account_status = ffi::proto::from::AccountStatus { registered };
        self.ui
            .send(ffi::proto::from::Msg::AccountStatus(account_status));
    }

    fn process_update_price_stream(&self, msg: SubscribePriceStreamResponse) {
        let msg = ffi::proto::from::UpdatePriceStream {
            asset_id: msg.asset.to_string(),
            send_bitcoins: msg.send_bitcoins,
            send_amount: msg.send_amount,
            recv_amount: msg.recv_amount,
            price: msg.price,
            error_msg: msg.error_msg,
        };
        self.ui.send(ffi::proto::from::Msg::UpdatePriceStream(msg));
    }

    fn try_process_blinded_swap_client(
        &self,
        msg: BlindedSwapClientNotification,
    ) -> Result<(), anyhow::Error> {
        let ctx = self
            .ctx
            .as_ref()
            .ok_or_else(|| anyhow!("unexpected swap request"))?;
        let active_swap = ctx
            .active_swap
            .as_ref()
            .ok_or_else(|| anyhow!("unexpected swap request"))?;
        ensure!(active_swap.order_id == msg.order_id);
        let blinded_pset = elements_pset::encode::deserialize::<
            elements_pset::pset::PartiallySignedTransaction,
        >(&base64::decode(&msg.pset)?)?;

        let amounts = swaps::Amounts {
            send_asset: active_swap.send_asset,
            recv_asset: active_swap.recv_asset,
            send_amount: active_swap.send_amount,
            recv_amount: active_swap.recv_amount,
        };

        let wallet = ctx.session.wallet.as_ref().expect("wallet must be set");
        let wallet = wallet.read().unwrap();
        let account = wallet.accounts.get(&ACCOUNT).unwrap();

        let send_amp = self.amp_assets.contains(&amounts.send_asset);
        let recv_amp = self.amp_assets.contains(&amounts.recv_asset);
        ensure!(!send_amp && !recv_amp, "AMP assets are not allowed");

        let signed_pset =
            swaps::sign_and_verify_pset(&self.secp, account, &amounts, &blinded_pset, recv_amp)?;
        let signed_pset = elements_pset::encode::serialize(&signed_pset);

        send_request!(
            self,
            SignedSwapClient,
            SignedSwapClientRequest {
                order_id: msg.order_id,
                pset: base64::encode(&signed_pset),
            }
        )?;

        Ok(())
    }

    fn process_blinded_swap_client(&mut self, msg: BlindedSwapClientNotification) {
        let result = self.try_process_blinded_swap_client(msg);
        if let Err(e) = result {
            error!("processing blinded swap failed: {}", e.to_string());
            self.ui
                .send(ffi::proto::from::Msg::SwapFailed(e.to_string()));
        }
    }

    fn process_swap_done(&mut self, msg: SwapDoneNotification) {
        let ctx = match self.ctx.as_mut() {
            Some(v) => v,
            None => return,
        };
        match ctx.active_swap.as_ref() {
            Some(v) if v.order_id == msg.order_id => v,
            _ => return,
        };
        let _active_swap = ctx.active_swap.take().unwrap();

        let error = match msg.status {
            SwapDoneStatus::Success => None,
            SwapDoneStatus::ClientError => Some("client error"),
            SwapDoneStatus::DealerError => Some("dealer error"),
            SwapDoneStatus::ServerError => Some("server error"),
        };
        match (error, msg.txid) {
            (None, Some(txid)) => {
                debug!("instant swap succeed, txid: {}", txid);
                ctx.succeed_swap = Some(txid);
                Data::update_sync_interval(&ctx);
            }
            (Some(e), None) => {
                self.ui
                    .send(ffi::proto::from::Msg::SwapFailed(e.to_owned()));
            }
            _ => {
                self.ui
                    .send(ffi::proto::from::Msg::SwapFailed("server error".to_owned()));
            }
        };
    }

    fn process_local_message(&mut self, msg: LocalMessageNotification) {
        self.ui.send(ffi::proto::from::Msg::LocalMessage(
            ffi::proto::from::LocalMessage {
                title: msg.title,
                body: msg.body,
            },
        ));
    }

    fn process_market_data_update(&mut self, msg: MarketDataUpdateNotification) {
        self.ui.send(ffi::proto::from::Msg::MarketDataUpdate(
            ffi::proto::from::MarketDataUpdate {
                asset_id: msg.asset.to_string(),
                update: convert_chart_point(msg.update),
            },
        ));
    }

    // message processing

    fn send_request_msg(&self, request: Request) -> RequestId {
        let request_id = ws::next_request_id();
        self.ws_sender
            .send(ws::WrappedRequest::Request(RequestMessage::Request(
                request_id.clone(),
                request,
            )))
            .unwrap();
        request_id
    }

    fn send_request(&self, request: Request) -> Result<Response, anyhow::Error> {
        let active_request_id = self.send_request_msg(request);

        let started = std::time::Instant::now();
        loop {
            let resp = self.resp_receiver.recv_timeout(SERVER_REQUEST_POLL_PERIOD);
            match resp {
                Ok(ServerResp(Some(request_id), result)) => {
                    if request_id != active_request_id {
                        warn!("discard old response: {:?}", result);
                        continue;
                    }
                    return result.map_err(|e| anyhow!("{}", e.message));
                }
                Ok(ServerResp(None, _)) => {
                    // should not happen
                    error!("invalid response: request id is empty");
                    continue;
                }
                Err(_) => {
                    let spent_time = std::time::Instant::now().duration_since(started);
                    if spent_time > SERVER_REQUEST_TIMEOUT {
                        error!("request timeout");
                        bail!("request timeout");
                    }
                }
            };
        }
    }

    fn show_message(&self, text: &str) {
        info!("show message: {}", text);
        let msg = ffi::proto::from::ShowMessage {
            text: text.to_owned(),
        };
        self.ui.send(ffi::proto::from::Msg::ShowMessage(msg));
    }

    fn check_connection(&mut self) {
        debug!("check ws connection");
        if !self.connected {
            debug!("ws is not connected, send reconnect hint");
            let _ = self.ws_hint.send(());
            return;
        }
        let ping_response = send_request!(self, Ping, None);
        if ping_response.is_err() {
            debug!("restart connection");
            self.restart_websocket();
        }
    }

    fn update_amp_connection_status(&mut self) {
        let amp_submits = self.amp_submits();
        let new_amp_active = self.app_active
            || (!self.pending_signs.is_empty() && amp_submits)
            || (!self.pending_sign_requests.is_empty() && amp_submits);
        if new_amp_active != self.amp_active {
            self.amp_active = new_amp_active;
            self.send_amp(amp::To::AppState(new_amp_active));
            if !self.amp_active {
                self.amp_connected = false;
            }
        }
    }

    fn process_push_message(
        &mut self,
        req: String,
        pending_sign: Option<crossbeam_channel::Sender<()>>,
    ) {
        let msg = match serde_json::from_str::<fcm_models::FcmMessage>(&req) {
            Ok(v) => v,
            Err(e) => {
                error!("parsing FCM message failed: {}", e);
                return;
            }
        };
        match msg {
            fcm_models::FcmMessage::Sign(data) => {
                info!("FCM sign request received, order_id: {}", data.order_id);
                // Make sure old pending_sign is kept if needed
                let pending_sign = self
                    .pending_signs
                    .remove(&data.order_id)
                    .unwrap_or(pending_sign);
                self.pending_signs.insert(data.order_id, pending_sign);
                self.update_amp_connection_status();
                self.check_connection();
                self.process_pending_requests();
            }
            _ => {}
        }
    }

    fn add_missing_submit_data(
        &mut self,
        order_id: &OrderId,
        details: &Details,
    ) -> Result<(), anyhow::Error> {
        if self.submit_data.get(&order_id).is_none() {
            let asset = self
                .assets
                .get(&details.asset)
                .ok_or(anyhow!("unknown asset"))?;
            self.verify_amounts(&details)?;
            let asset_amount = Amount::from_sat(details.asset_amount);
            let bitcoin_amount = Amount::from_sat(details.bitcoin_amount);
            let sell_bitcoin = details.send_bitcoins == (details.side == OrderSide::Maker);
            let price = details.price;
            let server_fee = Amount::from_sat(details.server_fee);

            // Auto sign is disabled after app restart
            let submit_data = SubmitData {
                order_id: order_id.clone(),
                side: OrderSide::Maker,
                asset: details.asset.clone(),
                asset_precision: asset.precision,
                order_type: details.order_type,
                bitcoin_amount,
                asset_amount,
                price,
                server_fee,
                sell_bitcoin,
                txouts: BTreeSet::new(),
                auto_sign: false,
                txid: None,
                index_price: false,
                market: details.market,
                signed: false,
            };
            self.submit_data
                .insert(submit_data.order_id.clone(), submit_data);
        }
        Ok(())
    }

    fn download_sign_request(&mut self, order_id: OrderId) -> Result<(), anyhow::Error> {
        debug!("download_sign_request, order_id: {}", order_id);
        let sign = send_request!(
            self,
            GetSign,
            GetSignRequest {
                order_id: order_id.clone()
            }
        )?;
        // Make sure that asset is known if app is restarted
        self.try_add_asset(&sign.data.details.asset)?;
        self.add_missing_submit_data(&order_id, &sign.data.details)?;
        self.process_sign(sign.data);

        Ok(())
    }

    fn skip_wallet_sync(&self) -> bool {
        self.pending_submits.is_empty() && self.pending_links.is_empty()
    }

    fn amp_submits(&self) -> bool {
        self.submit_data
            .values()
            .find(|item| self.amp_assets.contains(&item.asset))
            .is_some()
    }

    fn amp_links(&self) -> bool {
        self.downloaded_links
            .iter()
            .find(|item| self.amp_assets.contains(&item.details.asset))
            .is_some()
    }

    fn process_pending_requests(&mut self) {
        let amp_submits = self.amp_submits();
        debug!(
            "process_pending_requests, signs: {}, submits: {}, links: {}, sign_requests: {}, sign_prompts: {}, connected: {}, amp connected: {}, amp_submits: {}",
            self.pending_signs.len(),
            self.pending_submits.len(),
            self.pending_links.len(),
            self.pending_sign_requests.len(),
            self.pending_sign_prompts.len(),
            self.connected,
            self.amp_connected,
            amp_submits,
        );
        if !self.connected {
            debug!("wait until WS is connected");
            return;
        }
        if !self.amp_connected && amp_submits {
            debug!("delay processing AMP submits until AMP is connected");
            return;
        }
        let ctx = match self.ctx.as_ref() {
            Some(v) => v,
            None => return,
        };
        let sync_complete = ctx.sync_complete;

        let pending_signs = std::mem::replace(&mut self.pending_signs, BTreeMap::new());
        for (order_id, pending_sign) in pending_signs.into_iter() {
            if self.processed_signs.get(&order_id).is_none() {
                let result = self.download_sign_request(order_id);
                if let Err(e) = result {
                    self.show_message(&format!("sign failed: {}", e));
                }
                if let Some(pending_sign) = pending_sign {
                    let _ = pending_sign.send(());
                }
            }
        }

        if !sync_complete {
            return;
        }

        let pending_submits = std::mem::replace(&mut self.pending_submits, Vec::new());
        for req in pending_submits.into_iter() {
            let result = self.try_process_submit_order(req);
            if let Err(e) = result {
                self.ui.send(ffi::proto::from::Msg::SubmitResult(
                    ffi::proto::from::SubmitResult {
                        result: Some(ffi::proto::from::submit_result::Result::Error(
                            e.to_string(),
                        )),
                    },
                ));
            }
        }

        let pending_links = std::mem::replace(&mut self.pending_links, Vec::new());
        for req in pending_links.into_iter() {
            let result = self.try_process_link_order(OrderId::from_str(&req.order_id).unwrap());
            if let Err(e) = result {
                self.show_message(&e.to_string());
            }
        }

        let amp_links = self.amp_links();
        if !self.amp_connected && amp_links {
            debug!("delay processing AMP links until AMP is connected");
            return;
        }

        let downloaded_links = std::mem::replace(&mut self.downloaded_links, Vec::new());
        for resp in downloaded_links.into_iter() {
            let result = self.try_process_downloaded_link(resp);
            match result {
                Ok(Some(v)) => self.ui.send(v),
                Ok(None) => {}
                Err(e) => self.show_message(&e.to_string()),
            };
        }

        self.process_pending_sign_prompts();

        while let Some(msg) = self.pending_sign_requests.pop_front() {
            if self.processed_signs.get(&msg.order_id).is_some() {
                continue;
            }
            let result = self.try_process_sign(msg);
            if let Err(e) = result {
                self.show_message(&format!("sign failed: {}", e.to_string()));
            }
        }

        // Stop AMP only after processing background sign requests
        self.update_amp_connection_status();
    }

    fn process_ui(&mut self, msg: ffi::ToMsg) {
        debug!(
            "from ui: {}",
            serde_json::to_string(&redact_to_msg(msg.clone())).unwrap()
        );
        self.reset_idle_timer();
        match msg {
            ffi::proto::to::Msg::Login(req) => self.process_login_request(req),
            ffi::proto::to::Msg::Logout(_) => self.process_logout_request(),
            ffi::proto::to::Msg::ChangeNetwork(req) => self.process_change_network(req),
            ffi::proto::to::Msg::EncryptPin(req) => self.process_encrypt_pin(req),
            ffi::proto::to::Msg::DecryptPin(req) => self.process_decrypt_pin(req),
            ffi::proto::to::Msg::AppState(req) => self.process_app_state(req),
            ffi::proto::to::Msg::PushMessage(req) => self.process_push_message(req, None),
            ffi::proto::to::Msg::PegInRequest(_) => self.process_pegin_request(),
            ffi::proto::to::Msg::PegOutRequest(req) => self.process_pegout_request(req),
            ffi::proto::to::Msg::SwapRequest(req) => self.process_swap_request(req),
            ffi::proto::to::Msg::SwapAccept(req) => self.process_swap_accept(req),
            ffi::proto::to::Msg::GetRecvAddress(req) => self.process_get_recv_address(req),
            ffi::proto::to::Msg::CreateTx(req) => self.process_create_tx(req),
            ffi::proto::to::Msg::SendTx(req) => self.process_send_tx(req),
            ffi::proto::to::Msg::BlindedValues(req) => self.process_blinded_values(req),
            ffi::proto::to::Msg::SetMemo(req) => self.process_set_memo(req),
            ffi::proto::to::Msg::UpdatePushToken(req) => self.process_update_push_token(req),
            ffi::proto::to::Msg::RegisterPhone(req) => self.process_register_phone(req),
            ffi::proto::to::Msg::VerifyPhone(req) => self.process_verify_phone(req),
            ffi::proto::to::Msg::UnregisterPhone(req) => self.process_unregister_phone(req),
            ffi::proto::to::Msg::UploadAvatar(req) => self.process_upload_avatar(req),
            ffi::proto::to::Msg::UploadContacts(req) => self.process_upload_contacts(req),
            ffi::proto::to::Msg::SubmitOrder(req) => self.process_submit_order(req),
            ffi::proto::to::Msg::LinkOrder(req) => self.process_link_order(req),
            ffi::proto::to::Msg::SubmitDecision(req) => self.process_submit_decision(req),
            ffi::proto::to::Msg::EditOrder(req) => self.process_edit_order(req),
            ffi::proto::to::Msg::CancelOrder(req) => self.process_cancel_order(req),
            ffi::proto::to::Msg::Subscribe(req) => self.process_subscribe(req),
            ffi::proto::to::Msg::AssetDetails(req) => self.process_asset_details(req),
            ffi::proto::to::Msg::SubscribePrice(req) => self.process_subscribe_price(req),
            ffi::proto::to::Msg::UnsubscribePrice(req) => self.process_unsubscribe_price(req),
            ffi::proto::to::Msg::SubscribePriceStream(req) => {
                self.process_subscribe_price_stream(req)
            }
            ffi::proto::to::Msg::UnsubscribePriceStream(_) => {
                self.process_unsubscribe_price_stream()
            }
            ffi::proto::to::Msg::MarketDataSubscribe(req) => {
                self.process_market_data_subscribe(req)
            }
            ffi::proto::to::Msg::MarketDataUnsubscribe(_) => self.process_market_data_unsubscribe(),
            ffi::proto::to::Msg::JadeAction(msg) => self.process_jade_action_request(msg),
        }
    }

    fn process_ws_notification(&mut self, notification: Notification) {
        match notification {
            Notification::PegStatus(status) => self.process_peg_status(status),
            Notification::ServerStatus(resp) => self.process_server_status(resp),
            Notification::PriceUpdate(msg) => self.process_price_update(msg),
            Notification::Sign(msg) => self.process_sign(msg),
            Notification::Complete(msg) => self.process_complete(msg),
            Notification::OrderCreated(msg) => self.process_order_created(msg),
            Notification::OrderRemoved(msg) => self.process_order_removed(msg),
            Notification::UpdatePrices(msg) => self.process_update_prices(msg),
            Notification::ContactCreated(msg) => self.process_contact_created(msg.contact),
            Notification::ContactRemoved(msg) => self.process_contact_removed(msg.contact_key),
            Notification::ContactTransaction(msg) => self.process_contact_tx(msg.tx),
            Notification::AccountStatus(msg) => self.process_account_status(msg.registered),
            Notification::UpdatePriceStream(msg) => self.process_update_price_stream(msg),
            Notification::BlindedSwapClient(msg) => self.process_blinded_swap_client(msg),
            Notification::SwapDone(msg) => self.process_swap_done(msg),
            Notification::LocalMessage(msg) => self.process_local_message(msg),
            Notification::MarketDataUpdate(msg) => self.process_market_data_update(msg),
            _ => {}
        }
    }

    pub fn register_asset(
        &mut self,
        asset: Asset,
        swap_market: bool,
        amp_market: bool,
        unregistered: bool,
    ) {
        let asset_id = asset.asset_id.clone();
        let asset_copy = ffi::proto::Asset {
            asset_id: asset.asset_id.to_string(),
            name: asset.name.clone(),
            ticker: asset.ticker.0.clone(),
            icon: asset
                .icon
                .as_ref()
                .expect("asset icon must be embedded")
                .clone(),
            precision: asset.precision as u32,
            swap_market,
            amp_market,
            domain: asset.domain.clone(),
            domain_agent: asset.domain_agent.clone(),
            unregistered,
        };

        self.assets.insert(asset_id.clone(), asset.clone());

        self.ui.send(ffi::proto::from::Msg::NewAsset(asset_copy));
    }

    pub fn register_assets(&mut self, assets: Assets, amp_market: bool) {
        for asset in assets {
            let swap_market = !amp_market && asset.asset_id != self.liquid_asset_id;
            self.register_asset(asset, swap_market, amp_market, false);
        }
    }

    pub fn load_assets(&mut self) -> Result<(), anyhow::Error> {
        let str = match std::fs::read(self.assets_path()) {
            Ok(v) => v,
            Err(e) => {
                if self.env == Env::Prod {
                    include_bytes!("../data/assets.json").to_vec()
                } else {
                    bail!("can't load assets: {}", e)
                }
            }
        };
        let assets = serde_json::from_slice::<Assets>(&str)?;
        self.assets_old = assets.clone();
        self.register_assets(assets, false);
        Ok(())
    }

    pub fn save_assets(&self, assets: &Assets) -> Result<(), anyhow::Error> {
        let str = serde_json::to_string(&assets)?;
        std::fs::write(self.assets_path(), &str)?;
        Ok(())
    }

    // pegs monitoring

    fn start_peg_monitoring(&self, peg: &Peg) {
        let request = match peg.dir {
            PegDir::In => Request::PegStatus(PegStatusRequest {
                order_id: peg.order_id.clone(),
                peg_in: None,
            }),
            PegDir::Out => Request::PegStatus(PegStatusRequest {
                order_id: peg.order_id.clone(),
                peg_in: None,
            }),
        };
        self.send_request_msg(request);
    }

    fn add_peg_monitoring(&mut self, order_id: OrderId, dir: PegDir) {
        let peg = Peg { order_id, dir };
        if self.connected {
            self.start_peg_monitoring(&peg);
        }
        self.settings
            .pegs
            .get_or_insert_with(|| Vec::new())
            .push(peg);
        self.save_settings();
    }

    fn update_push_token(&mut self) {
        match (&self.push_token, self.connected, &self.settings.device_key) {
            (Some(push_token), true, Some(device_key)) => {
                let update_req = UpdatePushTokenRequest {
                    device_key: device_key.clone(),
                    push_token: push_token.clone(),
                };
                let update_resp = send_request!(self, UpdatePushToken, update_req);
                if let Err(e) = update_resp {
                    error!("updating push token failed: {}", e.to_string());
                }
            }
            _ => {}
        };
    }

    fn get_address(
        wallet: &gdk_electrum::interface::WalletCtx,
        addr_type: AddrType,
        pointer: u32,
        confidential: bool,
    ) -> String {
        let is_change = match addr_type {
            AddrType::External => false,
            AddrType::Internal => true,
        };
        let addr = wallet
            .accounts
            .get(&ACCOUNT)
            .unwrap()
            .derive_address(is_change, pointer)
            .expect("address derive must succeed");
        let addr = match addr {
            gdk_common::be::BEAddress::Bitcoin(_) => panic!("unexpected addr type"),
            gdk_common::be::BEAddress::Elements(v) => v,
        };
        if confidential {
            addr.to_string()
        } else {
            addr.to_unconfidential().to_string()
        }
    }

    fn update_address_registrations(&mut self) {
        match (self.connected, &self.settings.device_key, &self.ctx) {
            (true, Some(device_key), Some(ctx)) => loop {
                // Register in batches
                let wallet = ctx.session.wallet.as_ref().expect("wallet must be set");
                let indices = wallet
                    .read()
                    .unwrap()
                    .accounts
                    .get(&ACCOUNT)
                    .unwrap()
                    .store
                    .read()
                    .expect("read store must succeed")
                    .cache
                    .accounts
                    .get(&ACCOUNT)
                    .unwrap()
                    .indexes
                    .clone();
                let last_external = self.settings.last_external.unwrap_or_default();
                let last_internal = self.settings.last_internal.unwrap_or_default();
                let new_external = std::cmp::min(
                    indices.external + EXTRA_ADDRESS_COUNT,
                    last_external + MAX_REGISTER_ADDRESS_COUNT,
                );
                let external_count = if new_external > last_external {
                    new_external - last_external
                } else {
                    0
                };
                let new_internal = std::cmp::min(
                    indices.internal + EXTRA_ADDRESS_COUNT,
                    last_internal + MAX_REGISTER_ADDRESS_COUNT - external_count,
                );
                let mut addresses = std::vec::Vec::<String>::new();
                for pointer in last_external..new_external {
                    addresses.push(Data::get_address(
                        &wallet.read().unwrap(),
                        AddrType::External,
                        pointer,
                        false,
                    ));
                }
                for pointer in last_internal..new_internal {
                    addresses.push(Data::get_address(
                        &wallet.read().unwrap(),
                        AddrType::Internal,
                        pointer,
                        false,
                    ));
                }
                if addresses.is_empty() {
                    break;
                }
                let addr_req = RegisterAddressesRequest {
                    device_key: device_key.clone(),
                    addresses,
                };
                let new_count = addr_req.addresses.len();
                let addr_resp = send_request!(self, RegisterAddresses, addr_req);
                match addr_resp {
                    Ok(_) => {
                        debug!("new addresses succesfully registered, count: {}, total external: {}, total internal: {}",
                                new_count, new_external, new_internal);
                        self.settings.last_external = Some(new_external);
                        self.settings.last_internal = Some(new_internal);
                        self.save_settings();
                    }
                    Err(e) => {
                        error!("address update failed: {}", e);
                        break;
                    }
                }
            },
            _ => {}
        }
    }

    fn download_contacts(&mut self) {
        let phone_key = self
            .ctx
            .as_ref()
            .and_then(|ctx| ctx.phone_key.as_ref())
            .cloned();
        match (self.connected, phone_key) {
            (true, Some(phone_key)) => {
                let download_contacts_req = DownloadContactsRequest { phone_key };
                let download_contacts_result =
                    send_request!(self, DownloadContacts, download_contacts_req);
                match download_contacts_result {
                    Ok(data) => {
                        self.process_account_status(data.registered);
                        for contact in data.contacts {
                            self.process_contact_created(contact);
                        }
                        for tx in data.transactions {
                            self.process_contact_tx(tx);
                        }
                    }
                    Err(e) => {
                        error!("address update failed: {}", e);
                    }
                }
            }
            _ => {}
        }
    }

    fn process_unregister_phone_requests(&mut self) {
        if !self.connected {
            return;
        }
        let phone_keys = self
            .settings
            .get_persistent()
            .unregister_phone_requests
            .iter()
            .flatten()
            .cloned()
            .collect::<Vec<_>>();
        for phone_key in phone_keys {
            let result = send_request!(
                self,
                UnregisterPhone,
                UnregisterPhoneRequest {
                    phone_key: phone_key.clone()
                }
            );
            if result.is_ok() {
                info!("unregister phone request succeed");
                self.settings
                    .get_persistent()
                    .unregister_phone_requests
                    .as_mut()
                    .unwrap()
                    .remove(&phone_key);
                self.save_settings();
            }
        }
    }

    fn save_settings(&self) {
        let result = settings::save_settings(&self.settings, &self.get_data_path());
        if let Err(e) = result {
            error!("saving settings failed: {}", e);
        }
    }

    fn update_sync_interval(ctx: &Context) {
        let pending_tx = ctx.sent_txhash.is_some() || ctx.succeed_swap.is_some();
        let interval = if pending_tx { 1 } else { 7 };
        ctx.session.sync_interval.store(interval);
    }

    fn sync_order_list(&mut self) {
        let ctx = match self.ctx.as_mut() {
            Some(v) => v,
            None => return,
        };
        debug!(
            "sync order list, last: {}, sent: {}",
            ctx.orders_last.len(),
            ctx.orders_sent.len()
        );
        let removed = ctx
            .orders_sent
            .keys()
            .filter(|order_id| !ctx.orders_last.contains_key(order_id))
            .cloned()
            .collect::<Vec<_>>();
        for order_id in removed {
            ctx.orders_sent.remove(&order_id);
            let order_removed = ffi::proto::from::OrderRemoved {
                order_id: order_id.to_string(),
            };
            self.ui
                .send(ffi::proto::from::Msg::OrderRemoved(order_removed));
        }
        for (order_id, order) in ctx.orders_last.iter() {
            let order_sent = ctx.orders_sent.get(order_id);
            if order_sent != Some(order) {
                let new = order_sent.is_none() && order.from_notification;
                ctx.orders_sent.insert(order_id.clone(), order.clone());
                self.ui.send(ffi::proto::from::Msg::OrderCreated(
                    ffi::proto::from::OrderCreated {
                        order: order.clone(),
                        new,
                    },
                ));
            }
        }
    }

    fn process_background_message(
        &mut self,
        data: String,
        pending_sign: crossbeam_channel::Sender<()>,
    ) {
        self.process_push_message(data, Some(pending_sign));
    }

    // AMP processing

    fn send_amp(&self, msg: amp::To) {
        self.amp.send(msg);
    }

    fn send_jade(&self, account_id: AccountId, msg: amp::To) {
        if let Some(jade) = self.get_jade(account_id) {
            jade.send(msg);
        }
    }

    fn process_amp_register_result(&mut self, result: Result<String, String>) {
        let result = match result {
            Ok(v) => ffi::proto::from::register_amp::Result::AmpId(v),
            Err(e) => ffi::proto::from::register_amp::Result::ErrorMsg(e),
        };
        self.ui.send(ffi::proto::from::Msg::RegisterAmp(
            ffi::proto::from::RegisterAmp {
                result: Some(result),
            },
        ));
    }

    fn process_amp_balance(&mut self, account: AccountId, balances: BTreeMap<AssetId, u64>) {
        let balances = balances
            .into_iter()
            .map(|(asset_id, balance)| ffi::proto::Balance {
                asset_id: asset_id.to_string(),
                amount: balance as i64,
            })
            .collect();
        let balances_update = ffi::proto::from::BalanceUpdate {
            account: get_account(account),
            balances,
        };
        self.ui
            .send(ffi::proto::from::Msg::BalanceUpdate(balances_update));
    }

    fn process_amp_transactions(&mut self, account: AccountId, items: Vec<models::Transaction>) {
        self.send_new_transactions(items, account);
    }

    fn process_amp_recv_addr(&mut self, account: AccountId, addr: String) {
        self.ui.send(ffi::proto::from::Msg::RecvAddress(
            ffi::proto::from::RecvAddress {
                addr: ffi::proto::Address { addr },
                account: get_account(account),
            },
        ));
    }

    fn process_amp_create_tx_result(&mut self, result: ffi::proto::from::CreateTxResult) {
        self.ui.send(ffi::proto::from::Msg::CreateTxResult(result));
    }

    fn process_amp_send_tx_result(&mut self, result: ffi::proto::from::SendResult) {
        self.ui.send(ffi::proto::from::Msg::SendResult(result));
    }

    fn process_amp_sent_tx(&mut self, txid: sideswap_api::Txid) {
        if let Some(ctx) = self.ctx.as_mut() {
            ctx.sent_txhash = Some(txid);
            Data::update_sync_interval(&ctx);
        }
    }

    fn process_amp_connection_status(&mut self, connected: bool) {
        self.amp_connected = connected;
        if connected {
            self.process_pending_requests();
        }
    }

    fn process_amp_jade_updated(&mut self, msg: ffi::proto::from::JadeUpdated) {
        self.ui.send(ffi::proto::from::Msg::JadeUpdated(msg));
    }

    fn process_amp_fatal_jade_error(&mut self, port: sideswap_jade::Port) {
        if let Some(ctx) = self.ctx.as_mut() {
            let jade = ctx.jades.remove(&port);
            if let Some(jade) = jade {
                let id = jade.get_account_id();
                self.ui.send(ffi::proto::from::Msg::JadeRemoved(
                    ffi::proto::from::JadeRemoved {
                        account: get_account(id),
                    },
                ))
            }
        }
    }

    fn process_amp_message(&mut self, account: AccountId, msg: amp::From) {
        match msg {
            amp::From::Register(result) => self.process_amp_register_result(result),
            amp::From::Balances(balances) => self.process_amp_balance(account, balances),
            amp::From::Transactions(items) => self.process_amp_transactions(account, items),
            amp::From::RecvAddr(addr) => self.process_amp_recv_addr(account, addr),
            amp::From::CreateTx(result) => self.process_amp_create_tx_result(result),
            amp::From::SendTx(result) => self.process_amp_send_tx_result(result),
            amp::From::SentTx(txid) => self.process_amp_sent_tx(txid),
            amp::From::Error(msg) => self.show_message(&msg),
            amp::From::JadeUpdated(msg) => self.process_amp_jade_updated(msg),
            amp::From::FatalJadeError(port) => self.process_amp_fatal_jade_error(port),
            amp::From::ConnectionStatus(connected) => self.process_amp_connection_status(connected),
        }
    }

    fn reset_idle_timer(&mut self) {
        self.last_ui_msg_at = std::time::Instant::now();
        self.process_idle_timer();
    }

    fn process_idle_timer(&mut self) {
        let is_desktop = self.ctx.as_ref().map(|ctx| ctx.desktop).unwrap_or(false);
        if is_desktop {
            let ui_idle =
                std::time::Instant::now().duration_since(self.last_ui_msg_at) > DESKTOP_IDLE_TIMER;
            let new_app_active = !ui_idle;
            if self.app_active != new_app_active {
                info!("update desktop app status, active: {}", new_app_active);
                self.app_active = new_app_active;
                self.update_amp_connection_status();
            }
        }
    }

    fn get_jade(&self, account: AccountId) -> Option<&amp::Amp> {
        self.ctx.as_ref().and_then(|ctx| {
            ctx.jades
                .values()
                .find(|jade| jade.get_account_id() == account)
        })
    }

    fn process_jade_action_request(&mut self, msg: ffi::proto::to::JadeAction) {
        match msg.action() {
            ffi::proto::to::jade_action::Action::Unlock => {
                self.send_jade(msg.account.id, amp::To::JadeUnlock(self.env))
            }
            ffi::proto::to::jade_action::Action::Login => self.send_jade(
                msg.account.id,
                amp::To::Login(amp::LoginInfo {
                    env: self.env,
                    mnemonic: None,
                }),
            ),
        }
    }

    fn process_scan_jade(&mut self, ports: Vec<sideswap_jade::Port>) {
        if let Some(ctx) = self.ctx.as_mut() {
            for port in ports {
                if ctx.jades.get(&port).is_none() {
                    // FIXME: Always use new ID here
                    let account_id = ACCOUNT_ID_JADE_FIRST + ctx.jades.len() as i32;
                    let wallet = amp::start_processing(
                        &self.params.work_dir,
                        account_id,
                        self.msg_sender.clone(),
                        Some(port.clone()),
                    );
                    ctx.jades.insert(port, wallet);
                }
            }
            for jade in ctx.jades.values() {
                jade.send(amp::To::JadeRefreshStatus);
            }
        }
    }
}

pub fn start_processing(
    env: Env,
    msg_sender: crossbeam_channel::Sender<Message>,
    msg_receiver: crossbeam_channel::Receiver<Message>,
    from_sender: crossbeam_channel::Sender<ffi::FromMsg>,
    params: ffi::StartParams,
) {
    let ui = UiData {
        from_sender,
        ui_stopped: std::sync::atomic::AtomicBool::new(false),
    };
    let env_settings = ffi::proto::from::EnvSettings {
        policy_asset_id: env.data().policy_asset.to_owned(),
        usdt_asset_id: env.data().network.usdt_asset_id().to_owned(),
        eurx_asset_id: env.data().network.eurx_asset_id().to_owned(),
    };
    ui.send(ffi::proto::from::Msg::EnvSettings(env_settings));

    let amp = amp::start_processing(&params.work_dir, ACCOUNT_ID_AMP, msg_sender.clone(), None);

    gdk_electrum::store::REGTEST_ENV
        .store(!env.data().mainnet, std::sync::atomic::Ordering::Relaxed);

    let env_data = env.data();
    let (resp_sender, resp_receiver) = crossbeam_channel::unbounded::<ServerResp>();
    let (ws_sender, ws_receiver, ws_hint) = ws::start(
        env_data.host.to_owned(),
        env_data.port,
        env_data.use_tls,
        true,
    );

    let msg_sender_copy = msg_sender.clone();
    std::thread::spawn(move || {
        while let Ok(msg) = ws_receiver.recv() {
            match msg {
                ws::WrappedResponse::Connected => {
                    msg_sender_copy.send(Message::ServerConnected).unwrap();
                }
                ws::WrappedResponse::Disconnected => {
                    msg_sender_copy.send(Message::ServerDisconnected).unwrap();
                }
                ws::WrappedResponse::Response(ResponseMessage::Notification(notif)) => {
                    msg_sender_copy
                        .send(Message::ServerNotification(notif))
                        .unwrap();
                }

                // Ignored responses
                ws::WrappedResponse::Response(ResponseMessage::Response(
                    _,
                    Ok(Response::UnsubscribePriceStream(_)),
                )) => {}
                ws::WrappedResponse::Response(ResponseMessage::Response(
                    _,
                    Ok(Response::MarketDataUnsubscribe(_)),
                )) => {}

                ws::WrappedResponse::Response(ResponseMessage::Response(
                    _,
                    Ok(Response::PegStatus(msg)),
                )) => msg_sender_copy.send(Message::PegStatus(msg)).unwrap(),
                ws::WrappedResponse::Response(ResponseMessage::Response(
                    _,
                    Ok(Response::Subscribe(msg)),
                )) => msg_sender_copy.send(Message::Subscribe(msg)).unwrap(),
                ws::WrappedResponse::Response(ResponseMessage::Response(
                    _,
                    Ok(Response::Unsubscribe(msg)),
                )) => msg_sender_copy.send(Message::Unsubscribe(msg)).unwrap(),

                ws::WrappedResponse::Response(ResponseMessage::Response(
                    _,
                    Ok(Response::MarketDataSubscribe(msg)),
                )) => msg_sender_copy
                    .send(Message::MarketDataResponse(msg))
                    .unwrap(),

                ws::WrappedResponse::Response(ResponseMessage::Response(
                    _,
                    Ok(Response::LoadPrices(msg)),
                )) => msg_sender_copy
                    .send(Message::ServerNotification(Notification::UpdatePrices(msg)))
                    .unwrap(),
                ws::WrappedResponse::Response(ResponseMessage::Response(
                    _,
                    Ok(Response::AssetDetails(msg)),
                )) => msg_sender_copy.send(Message::AssetDetails(msg)).unwrap(),
                ws::WrappedResponse::Response(ResponseMessage::Response(
                    _,
                    Ok(Response::SubscribePriceStream(msg)),
                )) => msg_sender_copy
                    .send(Message::ServerNotification(
                        Notification::UpdatePriceStream(msg),
                    ))
                    .unwrap(),
                ws::WrappedResponse::Response(ResponseMessage::Response(req_id, result)) => {
                    resp_sender.send(ServerResp(req_id, result)).unwrap();
                }
            }
        }
    });

    let (notif_sender, notif_receiver) = crossbeam_channel::unbounded::<serde_json::Value>();
    let msg_sender_copy = msg_sender.clone();
    std::thread::spawn(move || {
        while let Ok(msg) = notif_receiver.recv() {
            let send_result = msg_sender_copy.send(Message::Notif(msg));
            if send_result.is_err() {
                warn!("worker stopped, quit...");
                break;
            }
        }
    });
    let notif_context = Box::new(NotifContext(Mutex::new(notif_sender)));
    let notif_context = Box::into_raw(notif_context);

    let msg_sender_copy = msg_sender.clone();
    std::thread::spawn(move || loop {
        std::thread::sleep(DESKTOP_IDLE_TIMER);
        let send_result = msg_sender_copy.send(Message::IdleTimer);
        if send_result.is_err() {
            warn!("worker stopped, quit idle timer thread...");
            break;
        }
    });

    let settings_path = Data::data_path(env, &params.work_dir);
    let mut settings = settings::load_settings(&settings_path).unwrap_or_default();
    settings::prune(&mut settings);

    let liquid_asset_id = AssetId::from_str(env.data().policy_asset).unwrap();

    let mut state = Data {
        secp: elements_pset::secp256k1_zkp::Secp256k1::new(),
        connected: false,
        amp_connected: false,
        server_status: None,
        env,
        ui,
        assets: BTreeMap::new(),
        amp_assets: BTreeSet::new(),
        assets_old: Vec::new(),
        msg_sender,
        ws_sender,
        ws_hint,
        amp,
        resp_receiver,
        params,
        notif_context,
        ctx: None,
        settings,
        push_token: None,
        liquid_asset_id,
        submit_data: BTreeMap::new(),
        pending_signs: BTreeMap::new(),
        visible_submit: None,
        waiting_submit: None,
        processed_signs: BTreeSet::new(),
        pending_sign_requests: VecDeque::new(),
        pending_sign_prompts: VecDeque::new(),
        pending_submits: Vec::new(),
        pending_links: Vec::new(),
        downloaded_links: Vec::new(),
        shown_succeed: BTreeSet::new(),
        pending_succeed: VecDeque::new(),
        subscribed_price_stream: None,
        app_active: true,
        amp_active: true,
        subscribed_market_data: None,
        last_ui_msg_at: std::time::Instant::now(),
    };

    if let Err(e) = state.load_assets() {
        error!("can't load assets: {}", &e);
    }

    while let Ok(a) = msg_receiver.recv() {
        let started = std::time::Instant::now();

        match a {
            Message::Notif(msg) => state.process_wallet_notif(msg),
            Message::Ui(msg) => state.process_ui(msg),
            Message::ServerConnected => state.process_ws_connected(),
            Message::ServerDisconnected => state.process_ws_disconnected(),
            Message::ServerNotification(msg) => state.process_ws_notification(msg),
            Message::PegStatus(msg) => state.process_peg_status(msg),
            Message::Subscribe(msg) => state.process_subscribe_response(msg),
            Message::Unsubscribe(msg) => state.process_unsubscribe_response(msg),
            Message::MarketDataResponse(msg) => state.process_market_data_response(msg),
            Message::AssetDetails(msg) => state.process_asset_details_response(msg),
            Message::BackgroundMessage(data, sender) => {
                state.process_background_message(data, sender)
            }
            Message::Amp(account, msg) => state.process_amp_message(account, msg),
            Message::IdleTimer => state.process_idle_timer(),
            Message::ScanJade(ports) => state.process_scan_jade(ports),
        }

        let stopped = std::time::Instant::now();
        let processing_time = stopped.duration_since(started);
        if processing_time > std::time::Duration::from_millis(100) {
            debug!("processing time: {} seconds", processing_time.as_secs_f64());
        }

        if state
            .ui
            .ui_stopped
            .load(std::sync::atomic::Ordering::Relaxed)
        {
            warn!("ui stopped, exit");
            break;
        }
    }

    if let Some(ctx) = state.ctx.as_mut() {
        let result = ctx.session.disconnect();
        if let Err(e) = result {
            warn!("disconnect failed: {}", e);
        }
    }
}
