use super::*;
use settings::{Peg, PegDir};
use sideswap_api::*;
use sideswap_common::env::Env;
use sideswap_common::types::*;
use sideswap_common::*;
use std::collections::{HashMap, HashSet};
use std::{
    collections::{BTreeMap, BTreeSet, VecDeque},
    str::FromStr,
};
use types::Amount;

const CLIENT_API_KEY: &str = "f8b7a12ee96aa68ee2b12ebfc51d804a4a404c9732652c298d24099a3d922a84";

const USER_AGENT: &str = "SideSwapApp";

const SERVER_REQUEST_TIMEOUT: std::time::Duration = std::time::Duration::from_secs(5);
const SERVER_REQUEST_POLL_PERIOD: std::time::Duration = std::time::Duration::from_secs(1);

const IDLE_TIMER: std::time::Duration = std::time::Duration::from_secs(60);

// AMP session stops somewhere between 50 and 125 minutes (and take into account DESKTOP_IDLE_TIMER)
const AMP_CONNECTION_CHECK_PERIOD: std::time::Duration =
    std::time::Duration::from_secs(2400 - IDLE_TIMER.as_secs());

pub const TX_CONF_COUNT_LIQUID: u32 = 2;

const MAX_REGISTER_ADDRESS_COUNT: u32 = 100;

const DEFAULT_ICON: &[u8] = include_bytes!("../images/icon_blank.png");

const AUTO_SIGN_ALLOWED_INDEX_PRICE_CHANGE: f64 = 0.1;

pub type AccountId = i32;

pub const ACCOUNT_ID_REG: AccountId = 0;
pub const ACCOUNT_ID_AMP: AccountId = 1;

#[cfg(any(target_os = "linux", target_os = "windows", target_os = "macos"))]
pub const ENABLE_JADE: bool = true;
#[cfg(any(target_os = "android", target_os = "ios"))]
pub const ENABLE_JADE: bool = false;

struct ActivePeg {
    order_id: OrderId,
}

pub struct PegPayment {
    pub sent_amount: i64,
    pub sent_txid: sideswap_api::Txid,
    pub signed_tx: String,
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
    two_step: bool,
    txid: Option<Txid>,
    index_price: bool,
    market: MarketType,
    signed: bool,
}

struct UiData {
    from_sender: crossbeam_channel::Sender<ffi::FromMsg>,
    ui_stopped: std::sync::atomic::AtomicBool,
}

#[derive(Debug, Eq, PartialEq, Clone, Copy)]
enum JadeState {
    Idle,
    Connecting,
    Unlocking,
    Connected,
}

struct JadeData {
    port: sideswap_jade::Port,
    state: JadeState,
}

pub struct Data {
    app_active: bool,
    amp_active: bool,
    amp_connected: bool,
    connected: bool,
    server_status: Option<ServerStatus>,
    env: Env,
    ui: UiData,
    assets: BTreeMap<AssetId, Asset>,
    amp_assets: BTreeSet<AssetId>,
    assets_old: Vec<Asset>,
    msg_sender: crossbeam_channel::Sender<Message>,
    ws_sender: crossbeam_channel::Sender<ws::WrappedRequest>,
    ws_hint: tokio::sync::mpsc::UnboundedSender<()>,
    resp_receiver: crossbeam_channel::Receiver<ServerResp>,
    params: ffi::StartParams,

    agent: ureq::Agent,
    sync_complete: bool,
    wallet_loaded_sent: bool,
    confirmed_txids: BTreeMap<AccountId, HashSet<Txid>>,
    unconfirmed_txids: BTreeMap<AccountId, HashSet<Txid>>,
    orders_last: BTreeMap<OrderId, ffi::proto::Order>,
    orders_sent: BTreeMap<OrderId, ffi::proto::Order>,
    send_utxo_updates: bool,
    wallets: BTreeMap<AccountId, Box<dyn gdk_ses::GdkSes>>,
    phone_key: Option<PhoneKey>,
    subscribes: BTreeSet<Option<AssetId>>,

    active_swap: Option<ActiveSwap>,
    succeed_swap: Option<Txid>,
    active_extern_peg: Option<ActivePeg>,
    sent_txhash: Option<Txid>,
    peg_out_server_amounts: Option<PegOutAmounts>,
    active_submits: BTreeMap<OrderId, LinkResponse>,
    active_sign: Option<SignNotification>,

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
    subscribed_market_data: Option<AssetId>,
    last_connection_check: std::time::Instant,
    last_blocks: BTreeMap<AccountId, gdk_json::NotificationBlock>,

    jades: Vec<JadeData>,
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
    Notif(AccountId, gdk_json::Notification),
    PegStatus(PegStatus),
    Subscribe(SubscribeResponse),
    Unsubscribe(UnsubscribeResponse),
    MarketDataResponse(MarketDataSubscribeResponse),
    AssetDetails(AssetDetailsResponse),
    BackgroundMessage(String, crossbeam_channel::Sender<()>),
    IdleTimer,
    ScanJade(Vec<sideswap_jade::Port>),
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

fn confirmed_tx(tx_block: u32, top_block: u32) -> bool {
    tx_block != 0
        && top_block != 0
        && tx_block <= top_block
        && top_block + 1 - tx_block >= TX_CONF_COUNT_LIQUID
}

fn get_tx_item_confs(tx_block: u32, top_block: u32) -> Option<ffi::proto::Confs> {
    // Because of race condition reported transaction mined height might be more than last block height
    let tx_block = if tx_block > top_block { 0 } else { tx_block };
    if !confirmed_tx(tx_block, top_block) {
        let count = if tx_block == 0 {
            0
        } else {
            top_block + 1 - tx_block
        };
        Some(ffi::proto::Confs {
            count,
            total: TX_CONF_COUNT_LIQUID,
        })
    } else {
        None
    }
}

fn tx_txitem_id(account_id: AccountId, txid: &Txid) -> String {
    format!("{}/{}", account_id, txid)
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
        account: get_account(ACCOUNT_ID_REG), // FIXME: Use correct account_id here (for peg-outs from AMP wallet)
        item: Some(ffi::proto::trans_item::Item::Peg(peg_details)),
    };
    tx_item
}

fn convert_jade_state(state: &JadeState) -> ffi::proto::from::jade_ports::State {
    match state {
        JadeState::Idle => ffi::proto::from::jade_ports::State::Idle,
        JadeState::Connecting => ffi::proto::from::jade_ports::State::Connecting,
        JadeState::Unlocking => ffi::proto::from::jade_ports::State::Unlocking,
        JadeState::Connected => ffi::proto::from::jade_ports::State::Connected,
    }
}

fn get_registry_config(env: Env) -> gdk_registry::param::Config {
    let network = match env.data().network {
        env::Network::Mainnet => gdk_registry::param::ElementsNetwork::Liquid,
        env::Network::Testnet => gdk_registry::param::ElementsNetwork::LiquidTestnet,
        env::Network::Regtest | env::Network::Local => {
            gdk_registry::param::ElementsNetwork::ElementsRegtest
        }
    };
    gdk_registry::param::Config {
        proxy: None,
        url: env.data().asset_registry_url.to_owned(),
        network,
    }
}

fn select_swap_inputs(
    inputs: Vec<sideswap_api::PsetInput>,
    amount: i64,
) -> Result<Vec<sideswap_api::PsetInput>, anyhow::Error> {
    let total = inputs.iter().map(|input| input.value).sum::<u64>() as i64;
    ensure!(total >= amount, "not enough UTXOs total amount");
    let inputs = inputs
        .into_iter()
        .map(|input| (input.value as i64, input))
        .collect::<Vec<_>>();
    let inputs = select_utxo_values(inputs, amount);
    Ok(inputs)
}

fn load_all_addresses(
    wallet: &mut dyn gdk_ses::GdkSes,
    is_internal: bool,
    last_known_pointer: Option<u32>,
) -> Result<(u32, Vec<String>), anyhow::Error> {
    let mut result = Vec::new();
    let mut result_pointer = 0;
    let mut last_pointer = None;
    loop {
        debug!(
            "load prev addresses, account_id: {}, is_internal: {}, last_pointer: {:?}",
            wallet.login_info().account_id,
            is_internal,
            last_pointer,
        );
        let list = wallet.get_previous_addresses(last_pointer, is_internal)?;
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
            .map(|addr| addr.address)
            .collect::<Vec<_>>();
        let no_new_addresses = new_list.is_empty();
        result.append(&mut new_list);
        if no_new_addresses || list.last_pointer.is_none() {
            debug!(
                "total loaded: {}, last_pointer: {}",
                result.len(),
                result_pointer
            );
            ensure!(!result.is_empty());
            return Ok((result_pointer, result));
        }
        last_pointer = list.last_pointer;
    }
}

fn start_wallet_processing(info: gdk_ses::LoginInfo) -> Box<dyn gdk_ses::GdkSes> {
    if info.account_id == ACCOUNT_ID_REG {
        gdk_rust::start_processing(info)
    } else {
        gdk_cpp::start_processing(info)
    }
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

impl Data {
    fn master_xpub(&mut self) -> bitcoin::util::bip32::ExtendedPubKey {
        if self.settings.master_pub_key.is_none() {
            let seed = rand::Rng::gen::<[u8; 32]>(&mut rand::thread_rng());
            let master_priv_key =
                bitcoin::util::bip32::ExtendedPrivKey::new_master(bitcoin::Network::Bitcoin, &seed)
                    .unwrap();
            let master_pub_key =
                bitcoin::util::bip32::ExtendedPubKey::from_private(swaps::secp(), &master_priv_key);
            self.settings.master_pub_key = Some(master_pub_key);
            self.save_settings();
        }
        self.settings.master_pub_key.clone().unwrap()
    }

    fn load_gdk_asset(&mut self, asset_ids: &[AssetId]) -> Result<Vec<Asset>, anyhow::Error> {
        let asset_ids_copy = asset_ids
            .iter()
            .map(|asset_id| elements::AssetId::from_slice(&asset_id.0).unwrap())
            .collect::<Vec<_>>();
        let loaded_assets = gdk_registry::get_assets(gdk_registry::GetAssetsParams {
            assets_id: asset_ids_copy.clone(),
            xpub: self.master_xpub(),
            config: get_registry_config(self.env),
        })?;
        let result = asset_ids
            .iter()
            .zip(asset_ids_copy.iter())
            .filter_map(|(asset_id, asset_id_copy)| {
                loaded_assets.assets.get(asset_id_copy).map(|v| {
                    let icon = loaded_assets
                        .icons
                        .get(asset_id_copy)
                        .cloned()
                        .unwrap_or_else(|| base64::encode(DEFAULT_ICON));
                    let default_ticker = || format!("{:0.4}", &asset_id.to_string());
                    Asset {
                        asset_id: asset_id.clone(),
                        name: v.name.clone(),
                        ticker: Ticker(v.ticker.clone().unwrap_or_else(default_ticker)),
                        icon: Some(icon),
                        precision: v.precision,
                        icon_url: None,
                        instant_swaps: Some(false),
                        domain: v.entity["domain"].as_str().map(|s| s.to_owned()),
                        domain_agent: None,
                    }
                })
            })
            .collect();
        Ok(result)
    }

    fn get_and_register_address(
        &self,
        wallet: &dyn gdk_ses::GdkSes,
    ) -> Result<String, anyhow::Error> {
        let addr = wallet.get_recv_address()?;
        self.register_addresses(&[addr.clone()]);
        Ok(addr)
    }

    fn get_and_register_uniq_address(
        &self,
        wallet: &dyn gdk_ses::GdkSes,
        old_addr: &str,
    ) -> Result<String, anyhow::Error> {
        // GDK rust sometimes return same address, that is workaround for this
        for _ in 0..10 {
            let addr = self.get_and_register_address(wallet)?;
            if addr != old_addr {
                return Ok(addr);
            }
        }
        bail!("can't receive new address");
    }

    fn try_add_asset(&mut self, asset_id: &AssetId) -> Result<(), anyhow::Error> {
        if self.assets.get(asset_id).is_some() {
            return Ok(());
        }
        let asset = self
            .load_gdk_asset(&[*asset_id])?
            .into_iter()
            .next()
            .ok_or_else(|| anyhow!("asset not found in gdk registry: {}", asset_id))?;
        self.register_asset(asset, false, false, false);
        Ok(())
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
                    .map(|balance| ffi::proto::Balance {
                        asset_id: balance.asset.to_string(),
                        amount: balance.value,
                    })
                    .collect();
                let confs = get_tx_item_confs(item.block_height, top_block);
                let id = tx_txitem_id(account_id, &item.txid);
                let balances_all = item
                    .balances_all
                    .iter()
                    .map(|balance| ffi::proto::Balance {
                        asset_id: balance.asset.to_string(),
                        amount: balance.value,
                    })
                    .collect();
                let tx_details = ffi::proto::Tx {
                    balances,
                    memo: item.memo.clone(),
                    network_fee: item.network_fee as i64,
                    txid: item.txid.to_string(),
                    size: item.size as i64,
                    vsize: item.vsize as i64,
                    balances_all,
                };
                (
                    item.txid,
                    ffi::proto::TransItem {
                        id,
                        created_at: item.created_at,
                        confs,
                        account: get_account(account_id),
                        item: Some(ffi::proto::trans_item::Item::Tx(tx_details)),
                    },
                )
            })
            .collect::<HashMap<_, _>>();

        let removed = unconfirmed_txids
            .iter()
            .filter(|txid| !updated.contains_key(txid))
            .cloned()
            .collect::<Vec<_>>();

        for (txid, item) in updated.iter() {
            let submit_data = self
                .submit_data
                .values()
                .find(|submit_data| submit_data.txid.as_ref() == Some(&txid));
            // FIXME: Show transaction popup from correct account
            if let Some(submit_data) = submit_data {
                let shown = self.shown_succeed.contains(&submit_data.order_id);
                if !shown {
                    self.pending_succeed.push_back(item.clone());
                    self.shown_succeed.insert(submit_data.order_id.clone());
                }
            }
        }

        let mut queue_msgs = Vec::new();

        if let Some(txid) = self.sent_txhash.as_ref() {
            let tx = updated.get(txid);
            if let Some(tx) = tx {
                let result = ffi::proto::from::send_result::Result::TxItem(tx.clone());
                queue_msgs.push(ffi::proto::from::Msg::SendResult(
                    ffi::proto::from::SendResult {
                        result: Some(result),
                    },
                ));
                self.sent_txhash = None;
                self.update_sync_interval();
            }
        }

        if let Some(txid) = self.succeed_swap.as_ref() {
            let tx = updated.get(txid);
            if let Some(tx) = tx {
                queue_msgs.push(ffi::proto::from::Msg::SwapSucceed(tx.clone()));
                self.succeed_swap = None;
                self.update_sync_interval();
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
            let new_assets = self.load_gdk_asset(&new_asset_ids).ok().unwrap_or_default();
            for asset_id in new_asset_ids.iter() {
                info!("try add new asset: {}", asset_id);
                let (asset, unregistered) =
                    match new_assets.iter().find(|asset| asset.asset_id == *asset_id) {
                        Some(asset) => (asset.clone(), false),
                        None => {
                            warn!("can't find GDK asset {}", asset_id);
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

        self.process_pending_succeed();
    }

    fn send_gaid_id(&mut self) {
        match self
            .get_wallet_mut(ACCOUNT_ID_AMP)
            .and_then(|wallet| wallet.get_gaid())
        {
            Ok(gaid) => {
                self.ui.send(ffi::proto::from::Msg::RegisterAmp(
                    ffi::proto::from::RegisterAmp {
                        result: Some(ffi::proto::from::register_amp::Result::AmpId(gaid)),
                    },
                ));
            }
            Err(e) => error!("loading gaid failed: {}", e),
        }
    }

    fn resync_wallet(&mut self, account_id: AccountId) {
        debug!("resync wallet {}", account_id);

        match self
            .get_wallet_mut(account_id)
            .and_then(|wallet| wallet.get_balances())
        {
            Ok(balances) => {
                let balances = balances
                    .into_iter()
                    .map(|(asset_id, amount)| ffi::proto::Balance {
                        asset_id: asset_id.to_string(),
                        amount,
                    })
                    .collect();

                self.ui.send(ffi::proto::from::Msg::BalanceUpdate(
                    ffi::proto::from::BalanceUpdate {
                        account: get_account(account_id),
                        balances,
                    },
                ));
            }
            Err(e) => {
                error!("balance refresh failed: {}", e);
            }
        }

        if self.send_utxo_updates {
            match self
                .get_wallet_mut(account_id)
                .and_then(|wallet| wallet.get_utxos())
            {
                Ok(utxos) => {
                    self.ui.send(ffi::proto::from::Msg::UtxoUpdate(utxos));
                }
                Err(e) => {
                    error!("utxo refresh failed: {}", e);
                }
            }
        }

        // TODO: Load transactions lazily to speedup wallet startup
        if let Some(last_block) = self.last_blocks.get(&account_id) {
            let top_block = last_block.block_height;
            match self
                .get_wallet_mut(account_id)
                .and_then(|wallet| wallet.get_transactions())
            {
                Ok(items) => {
                    self.send_new_transactions(items, account_id, top_block);
                }
                Err(e) => {
                    error!("tx refresh failed: {}", e);
                }
            }
        }
    }

    fn send_wallet_loaded(&mut self) {
        if !self.wallet_loaded_sent {
            self.wallet_loaded_sent = true;
            self.ui
                .send(ffi::proto::from::Msg::WalletLoaded(ffi::proto::Empty {}));
        }
    }

    fn sync_complete(&mut self, account_id: AccountId) {
        if !self.sync_complete {
            self.sync_complete = true;
            self.send_wallet_loaded();
            self.process_pending_requests();
            self.resync_wallet(account_id);
            self.ui
                .send(ffi::proto::from::Msg::SyncComplete(ffi::proto::Empty {}));
            self.update_address_registrations();
        }
    }

    fn sync_failed(&mut self) {
        self.show_message("electrs connection failed");
    }

    fn resume_peg_monitoring(&mut self) {
        if self.assets.is_empty() || !self.connected {
            return;
        }
        for peg in self.settings.pegs.iter().flatten() {
            self.start_peg_monitoring(peg);
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
    fn registry_path(&self) -> std::path::PathBuf {
        self.get_data_path().join("registry")
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

        // register device key if does not exist
        if self.settings.device_key == None {
            let register_req = RegisterDeviceRequest {
                os_type: get_os_type(),
            };
            let register_resp = send_request!(self, RegisterDevice, register_req)?;
            self.settings.device_key = Some(register_resp.device_key);
            self.settings.last_external_new = None;
            self.settings.last_internal_new = None;
            self.settings.last_external_amp_new = None;
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

        self.orders_last.clear();
        self.sync_order_list();

        self.ui.send(ffi::proto::from::Msg::ServerDisconnected(
            ffi::proto::Empty {},
        ));

        self.ws_sender.send(ws::WrappedRequest::Connect).unwrap();
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

    fn process_wallet_notif(
        &mut self,
        account_id: AccountId,
        notification: gdk_json::Notification,
    ) {
        if self.get_wallet_ref(account_id).is_err() {
            debug!("ignore notification from deleted wallet");
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
            "sync_complete" => self.sync_complete(account_id),
            "sync_failed" => self.sync_failed(),
            _ => {}
        }

        if let (
            Some(gdk_json::NotificationNetwork {
                current_state: gdk_json::ConnectionState::Connected,
                next_state: _,
                wait_ms: _,
            }),
            Ok(wallet),
        ) = (&notification.network, self.get_wallet_mut(account_id))
        {
            debug!("request wallet {} login", account_id);
            let connect_result = wallet.login();
            match connect_result {
                Ok(_) => {
                    if account_id == ACCOUNT_ID_AMP {
                        self.send_gaid_id();
                        debug!("AMP connected");
                        self.amp_connected = true;
                        self.process_pending_requests();
                    }
                    self.resync_wallet(account_id);
                }
                Err(e) => {
                    self.show_message(&format!("connection failed: {}", e));
                }
            }
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
            }
        }
    }

    fn try_process_pegout_amount(
        &mut self,
        req: ffi::proto::to::PegOutAmount,
    ) -> Result<ffi::proto::from::peg_out_amount::Amounts, anyhow::Error> {
        ensure!(self.connected, "not connected");

        let wallet = self.get_wallet_mut(req.account.id)?;
        let utxos = wallet
            .get_utxos()?
            .utxos
            .into_iter()
            .filter(|utxo| utxo.asset_id == self.env.data().policy_asset)
            .collect::<Vec<_>>();
        let balance = utxos.iter().map(|utxo| utxo.amount).sum::<u64>() as i64;

        let amount = if req.is_send_entered && balance == req.amount {
            let fake_addr = swaps::generate_fake_p2sh_address(self.env).to_string();
            let liquid_asset_id = self.liquid_asset_id;
            let wallet = self.get_wallet_mut(req.account.id)?;
            let network_fee = wallet.get_tx_fee(liquid_asset_id, req.amount, &fake_addr)?;
            req.amount - network_fee
        } else {
            req.amount
        };

        let server_status = self
            .server_status
            .as_ref()
            .ok_or(anyhow!("server_status is not known"))?;

        let amounts = peg_out_amount(types::PegOutAmountReq {
            amount,
            is_send_entered: req.is_send_entered,
            fee_rate: req.fee_rate,
            min_peg_out_amount: server_status.min_peg_out_amount,
            server_fee_percent_peg_out: server_status.server_fee_percent_peg_out,
            peg_out_bitcoin_tx_vsize: server_status.peg_out_bitcoin_tx_vsize,
        })?;

        self.peg_out_server_amounts = Some(PegOutAmounts {
            send_amount: amounts.send_amount,
            recv_amount: amounts.recv_amount,
            is_send_entered: req.is_send_entered,
            fee_rate: req.fee_rate,
        });

        Ok(ffi::proto::from::peg_out_amount::Amounts {
            send_amount: amounts.send_amount,
            recv_amount: amounts.recv_amount,
            fee_rate: req.fee_rate,
            account: req.account,
            is_send_entered: req.is_send_entered,
        })
    }

    fn process_pegout_amount(&mut self, req: ffi::proto::to::PegOutAmount) {
        let result = match self.try_process_pegout_amount(req) {
            Ok(amounts) => ffi::proto::from::peg_out_amount::Result::Amounts(amounts),
            Err(e) => {
                error!("peg-out amount failed: {}", e.to_string());
                ffi::proto::from::peg_out_amount::Result::ErrorMsg(e.to_string())
            }
        };
        let amounts_result = ffi::proto::from::PegOutAmount {
            result: Some(result),
        };
        self.ui
            .send(ffi::proto::from::Msg::PegOutAmount(amounts_result));
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

        let peg_out_server_amounts = self
            .peg_out_server_amounts
            .take()
            .ok_or_else(|| anyhow!("peg_out_server_amounts is None"))?;

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
            peg_out_amounts: Some(peg_out_server_amounts),
        });

        let resp = self.send_request(request);
        let resp = match resp {
            Ok(Response::Peg(resp)) => resp,
            Ok(_) => bail!("unexpected server response"),
            Err(e) => bail!("server error: {}", e.to_string()),
        };

        self.add_peg_monitoring(resp.order_id, PegDir::Out);

        let wallet = self.get_wallet_mut(req.account.id)?;
        wallet.make_pegout_payment(
            req.send_amount,
            &resp.peg_addr,
            peg_out_server_amounts.send_amount,
        )?;

        Ok(resp.order_id)
    }

    fn process_pegout_request(&mut self, req: ffi::proto::to::PegOutRequest) {
        let result = self.try_process_pegout_request(req);
        match result {
            Ok(order_id) => {
                self.active_extern_peg = Some(ActivePeg { order_id });
            }
            Err(e) => {
                error!("starting peg-out failed: {}", e.to_string());
                self.ui
                    .send(ffi::proto::from::Msg::SwapFailed(e.to_string()));
            }
        }
        self.update_address_registrations();
    }

    fn try_process_pegin_request(
        &mut self,
    ) -> Result<ffi::proto::from::PeginWaitTx, anyhow::Error> {
        ensure!(self.connected, "not connected");
        let device_key = self
            .settings
            .device_key
            .as_ref()
            .expect("device_key must exists")
            .clone();
        let recv_addr =
            self.get_and_register_address(self.get_wallet_ref(ACCOUNT_ID_REG)?.as_ref())?;
        let request = Request::Peg(PegRequest {
            recv_addr: recv_addr.clone(),
            send_amount: None,
            peg_in: true,
            device_key: Some(device_key),
            blocks: None,
            peg_out_amounts: None,
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

        self.active_extern_peg = Some(ActivePeg {
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

        let inputs = self
            .get_wallet_mut(ACCOUNT_ID_REG)?
            .get_swap_inputs(&send_asset)?;
        let inputs = select_swap_inputs(inputs, send_amount)?;

        let wallet = self.get_wallet_ref(ACCOUNT_ID_REG)?;
        let change_addr = self.get_and_register_address(wallet.as_ref())?;
        let recv_addr = self.get_and_register_uniq_address(wallet.as_ref(), &change_addr)?;

        let swap_resp = send_request!(
            self,
            StartSwapClient,
            StartSwapClientRequest {
                price: req.price,
                asset,
                send_bitcoins: req.send_bitcoins,
                send_amount,
                recv_amount,
                inputs: inputs,
                recv_addr,
                change_addr,
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
        info!("send swap request to {}", &url);
        let request = serde_json::to_value(&request).unwrap();
        let response = self.agent.post(&url).send_json(request)?;
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

        let inputs = self
            .get_wallet_mut(ACCOUNT_ID_REG)?
            .get_swap_inputs(&send_asset)?;
        let inputs = select_swap_inputs(inputs, send_amount)?;

        let wallet = self.get_wallet_ref(ACCOUNT_ID_REG)?;
        let change_addr = self.get_and_register_address(wallet.as_ref())?;
        let recv_addr = self.get_and_register_uniq_address(wallet.as_ref(), &change_addr)?;

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

        let amounts = swaps::Amounts {
            send_asset,
            recv_asset,
            send_amount: send_amount as u64,
            recv_amount: recv_amount as u64,
        };

        let send_amp = self.amp_assets.contains(&send_asset);
        let recv_amp = self.amp_assets.contains(&recv_asset);
        ensure!(!send_amp && !recv_amp, "AMP assets are not allowed");

        let wallet = self.get_wallet_mut(ACCOUNT_ID_REG)?;

        let signed_pset = wallet.verify_and_sign_pset(&amounts, &response.pset, &[])?;

        let request = http_rpc::RequestMsg {
            id: None,
            request: http_rpc::Request::SwapSign(http_rpc::SwapSignRequest {
                order_id: order_id.clone(),
                submit_id: response.submit_id,
                pset: signed_pset,
            }),
        };
        let response = self.send_rest_request(request, &upload_url)?;
        let response = match response.response {
            http_rpc::Response::SwapSign(v) => v,
            _ => bail!("unexpected start response"),
        };

        self.succeed_swap = Some(response.txid);
        self.update_sync_interval();

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

    fn process_get_recv_address(&mut self, account: ffi::proto::Account) {
        let result = self
            .get_wallet_ref(account.id)
            .and_then(|wallet| self.get_and_register_address(wallet.as_ref()));
        match result {
            Ok(addr) => {
                self.ui.send(ffi::proto::from::Msg::RecvAddress(
                    ffi::proto::from::RecvAddress {
                        addr: ffi::proto::Address { addr },
                        account,
                    },
                ));
                self.update_address_registrations();
            }
            Err(e) => {
                self.show_message(&e.to_string());
            }
        }
    }

    fn process_create_tx(&mut self, req: ffi::proto::CreateTx) {
        let result = match self
            .get_wallet_mut(req.account.id)
            .and_then(|wallet| wallet.create_tx(req))
        {
            Ok(tx) => ffi::proto::from::create_tx_result::Result::CreatedTx(tx),
            Err(e) => ffi::proto::from::create_tx_result::Result::ErrorMsg(e.to_string()),
        };
        self.ui.send(ffi::proto::from::Msg::CreateTxResult(
            ffi::proto::from::CreateTxResult {
                result: Some(result),
            },
        ));
        self.update_address_registrations();
    }

    fn process_send_tx(&mut self, req: ffi::proto::to::SendTx) {
        let result = self
            .get_wallet_mut(req.account.id)
            .and_then(|wallet| wallet.send_tx());

        match result {
            Ok(txid) => {
                self.sent_txhash = Some(txid);
                self.update_sync_interval();
            }
            Err(e) => self.ui.send(ffi::proto::from::Msg::SendResult(
                ffi::proto::from::SendResult {
                    result: Some(ffi::proto::from::send_result::Result::ErrorMsg(
                        e.to_string(),
                    )),
                },
            )),
        }
    }

    fn process_blinded_values(&self, req: ffi::proto::to::BlindedValues) {
        let blinded_values = self
            .wallets
            .values()
            .map(|wallet| wallet.get_blinded_values(&req.txid).ok().into_iter())
            .flatten()
            .flatten()
            .collect::<Vec<_>>();
        let result =
            ffi::proto::from::blinded_values::Result::BlindedValues(blinded_values.join(","));
        let blinded_values = ffi::proto::from::BlindedValues {
            txid: req.txid,
            result: Some(result),
        };
        self.ui
            .send(ffi::proto::from::Msg::BlindedValues(blinded_values));
    }

    // logins

    fn process_login_request(
        &mut self,
        mnemonic: Option<&String>,
        send_utxo_updates: Option<bool>,
        network: &Option<ffi::proto::network_settings::Selected>,
        hw_data: Option<gdk_ses::HwData>,
    ) {
        debug!("process login request...");

        self.send_utxo_updates = send_utxo_updates.unwrap_or(false);

        let network = network.clone().unwrap_or_else(|| {
            ffi::proto::network_settings::Selected::Blockstream(ffi::proto::Empty {})
        });

        if mnemonic.is_some() {
            let info_reg = gdk_ses::LoginInfo {
                account_id: ACCOUNT_ID_REG,
                env: self.env,
                mnemonic: mnemonic.cloned(),
                network: network.clone(),
                cache_dir: self.cache_path().to_str().unwrap().to_owned(),
                worker: self.msg_sender.clone(),
                hw_data: None,
            };

            self.wallets
                .insert(ACCOUNT_ID_REG, gdk_rust::start_processing(info_reg));
        }

        let info_amp = gdk_ses::LoginInfo {
            account_id: ACCOUNT_ID_AMP,
            env: self.env,
            mnemonic: mnemonic.cloned(),
            network: network.clone(),
            cache_dir: self.cache_path().to_str().unwrap().to_owned(),
            worker: self.msg_sender.clone(),
            hw_data,
        };

        self.wallets
            .insert(ACCOUNT_ID_AMP, gdk_cpp::start_processing(info_amp));

        if self.skip_wallet_sync() {
            info!("skip wallet sync delay");
            self.send_wallet_loaded();
        }

        self.process_pending_requests();
        self.resume_peg_monitoring();
        self.update_address_registrations();
        self.download_contacts();
    }

    fn restart_websocket(&mut self) {
        self.connected = false;
        debug!("restart WS connection");
        self.ws_sender.send(ws::WrappedRequest::Disconnect).unwrap();
    }

    fn process_logout_request(&mut self) {
        debug!("process logout request...");

        self.wallets.clear();

        // FIXME: Clear other fields
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

        let persistent = self.settings.persistent.take();
        self.settings = settings::Settings::default();
        self.settings.persistent = persistent;
        self.save_settings();

        self.ui
            .send(ffi::proto::from::Msg::Logout(ffi::proto::Empty {}));

        // Required because new device_key is needed
        // TODO: Do something better when when multi-wallets are added
        self.restart_websocket();
    }

    fn try_change_network(
        &mut self,
        req: ffi::proto::to::ChangeNetwork,
    ) -> Result<(), anyhow::Error> {
        debug!("process change network request...");
        let network = req.network.selected.unwrap();
        let wallet_old = self
            .wallets
            .remove(&ACCOUNT_ID_REG)
            .ok_or_else(|| anyhow!("no wallet"))?;
        let mut login_info = wallet_old.login_info().clone();
        login_info.network = network;

        drop(wallet_old);
        let wallet = start_wallet_processing(login_info);
        self.wallets.insert(wallet.login_info().account_id, wallet);

        Ok(())
    }

    fn process_change_network(&mut self, req: ffi::proto::to::ChangeNetwork) {
        let result = self.try_change_network(req);
        if let Err(e) = result {
            self.show_message(&format!("changing network failed: {}", e.to_string()));
        }
    }

    fn process_encrypt_pin(&self, req: ffi::proto::to::EncryptPin) {
        let details = crate::pin::PinSetDetails {
            pin: req.pin,
            mnemonic: req.mnemonic,
            device_id: String::new(),
        };
        let result = match crate::pin::encrypt_pin(&details) {
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
        let details = crate::pin::PinGetDetails {
            salt: req.salt,
            encrypted_data: req.encrypted_data,
            pin_identifier: req.pin_identifier,
        };
        let result = match crate::pin::decrypt_pin(req.pin, &details) {
            Ok(v) => ffi::proto::from::decrypt_pin::Result::Mnemonic(v),
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
        if req.active {
            self.check_connections();
        }
        self.update_amp_connection();
    }

    fn process_peg_status(&mut self, status: PegStatus) {
        let pegs = status
            .list
            .iter()
            .map(|tx| get_peg_item(&status, &tx))
            .collect::<Vec<_>>();

        let mut queue_msgs = Vec::new();

        if let Some(peg) = self.active_extern_peg.as_ref() {
            if peg.order_id == status.order_id {
                if let Some(first_peg) = status.list.first() {
                    let peg_item = get_peg_item(&status, first_peg);
                    queue_msgs.push(ffi::proto::from::Msg::SwapSucceed(peg_item));
                    self.active_extern_peg = None;
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
        self.orders_last.retain(|_, order| {
            order.own
                || match &msg.asset {
                    Some(asset_id) => order.asset_id != asset_id.to_string(),
                    None => !order.token_market,
                }
        });
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
        let result = self
            .get_wallet_mut(req.account.id)
            .and_then(|wallet| wallet.set_memo(&req.txid, &req.memo));
        match result {
            Ok(_) => {}
            Err(e) => error!("setting memo failed: {}", e),
        }
    }

    fn process_update_push_token(&mut self, req: ffi::proto::to::UpdatePushToken) {
        self.push_token = Some(req.token);
        self.update_push_token();
    }

    fn process_register_phone(&mut self, _req: ffi::proto::to::RegisterPhone) {
        // Not implemented
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
            self.phone_key = Some(phone_key);
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
                req.account.id == ACCOUNT_ID_REG,
                "Non AMP asset order is expected to be from non-AMP account"
            );
        }
        let bitcoin_amount = match req.bitcoin_amount {
            Some(v) => {
                let liquid_asset_id = self.liquid_asset_id;
                let bitcoin_balance = Amount::from_sat(
                    self.get_wallet_mut(ACCOUNT_ID_REG)?
                        .get_balance(&liquid_asset_id),
                );
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
                self.liquid_asset_id,
            )
        } else {
            (details.asset_amount, details.asset)
        };
        let send_amp = self.amp_assets.contains(&send_asset);
        let send_account_id = if send_amp {
            ACCOUNT_ID_AMP
        } else {
            ACCOUNT_ID_REG
        };

        let send_wallet = self.get_wallet_mut(send_account_id)?;
        let available_balance = send_wallet.get_balance(&send_asset);
        debug!(
            "available_balance: {}, send_amount: {}",
            available_balance, send_amount
        );

        if available_balance < send_amount {
            return Ok(Some(ffi::proto::from::Msg::InsufficientFunds(
                ffi::proto::from::ShowInsufficientFunds {
                    asset_id: send_asset.to_string(),
                    available: available_balance,
                    required: send_amount,
                },
            )));
        }

        let tx_chaining_required = if details.side == OrderSide::Maker {
            let inputs = send_wallet.get_utxos()?;
            let send_asset = send_asset.to_string();
            let tx_chaining_required = inputs
                .utxos
                .iter()
                .find(|utxo| utxo.asset_id == send_asset && utxo.amount as i64 == send_amount)
                .is_none();
            Some(tx_chaining_required)
        } else {
            None
        };

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
            two_step: details.two_step,
            tx_chaining_required,
        };
        debug!("send for review quote prompt, order_id: {}", order_id);
        self.ui
            .send(ffi::proto::from::Msg::SubmitReview(submit_review));
        self.visible_submit = Some(order_id.clone());
        self.active_submits.insert(order_id, resp);
        Ok(None)
    }

    fn process_submit_order(&mut self, req: ffi::proto::to::SubmitOrder) {
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

    fn is_own_amp_address(&mut self, addr: &str) -> Result<bool, anyhow::Error> {
        // FIXME: Make sure that the cache is cleared after mnemonic is removed
        if let Some(amp_prev_addrs) = self.settings.amp_prev_addrs.as_ref() {
            if amp_prev_addrs.list.iter().find(|a| *a == addr).is_some() {
                return Ok(true);
            }
        }

        let last_old_pointer = self
            .settings
            .amp_prev_addrs
            .as_ref()
            .map(|v| v.last_pointer);
        let wallet = self.get_wallet_mut(ACCOUNT_ID_AMP)?;
        let (last_new_pointer, new_list) =
            load_all_addresses(wallet.as_mut(), false, last_old_pointer)?;

        let mut amp_prev_addrs = self
            .settings
            .amp_prev_addrs
            .get_or_insert_with(Default::default);
        amp_prev_addrs.last_pointer = last_new_pointer;
        amp_prev_addrs.list.extend(new_list);
        self.save_settings();

        let amp_prev_addrs = self.settings.amp_prev_addrs.as_ref().unwrap();
        let found = amp_prev_addrs.list.iter().find(|a| *a == addr).is_some();
        Ok(found)
    }

    fn try_process_submit_decision(
        &mut self,
        req: ffi::proto::to::SubmitDecision,
    ) -> Result<bool, anyhow::Error> {
        if !req.accept {
            return Ok(true);
        }
        let is_sign = self
            .active_sign
            .as_ref()
            .map(|sign| sign.order_id.to_string() == req.order_id)
            .unwrap_or(false);
        if is_sign {
            let sign_msg = self.active_sign.take().unwrap();
            return self.try_sign(sign_msg);
        }
        let order_id = OrderId::from_str(&req.order_id)?;
        let resp = self
            .active_submits
            .remove(&order_id)
            .ok_or(anyhow!("data not found"))?;
        let index_price = resp.index_price;
        let details = resp.details;
        let side = details.side;
        let auto_sign = req.auto_sign.unwrap_or(false) && side == OrderSide::Maker;
        let two_step = req.two_step.unwrap_or(false) && side == OrderSide::Maker;
        self.assets
            .get(&details.asset)
            .ok_or(anyhow!("unknown asset"))?;
        self.verify_amounts(&details)?;

        let asset_amount = Amount::from_sat(details.asset_amount);
        let bitcoin_asset = self.liquid_asset_id.clone();
        let (send_asset, send_amount, recv_asset, recv_amount) = if details.send_bitcoins {
            (
                bitcoin_asset,
                details.bitcoin_amount + details.server_fee,
                details.asset,
                details.asset_amount,
            )
        } else {
            (
                details.asset.clone(),
                asset_amount.to_sat(),
                bitcoin_asset,
                details.bitcoin_amount - details.server_fee,
            )
        };
        let is_send_amp = self.amp_assets.contains(&send_asset);
        let is_recv_amp = self.amp_assets.contains(&recv_asset);

        let account_id = if is_send_amp {
            ACCOUNT_ID_AMP
        } else {
            ACCOUNT_ID_REG
        };
        let wallet = self.get_wallet_ref(account_id)?;
        let change_addr = self.get_and_register_address(wallet.as_ref())?;
        let inputs = wallet.get_swap_inputs(&send_asset)?;

        let (recv_addr, recv_gaid) = if is_recv_amp && two_step {
            let gaid = self.get_wallet_mut(ACCOUNT_ID_AMP)?.get_gaid()?;
            let device_key = self.settings.device_key.clone();
            let resolved_addr = send_request!(
                self,
                ResolveGaid,
                ResolveGaidRequest {
                    order_id,
                    gaid,
                    device_key
                }
            )?
            .address;
            let is_own_amp_address = self.is_own_amp_address(&resolved_addr)?;
            ensure!(is_own_amp_address);
            (Some(resolved_addr), None)
        } else if is_recv_amp {
            (None, Some(self.get_wallet_mut(ACCOUNT_ID_AMP)?.get_gaid()?))
        } else {
            let recv_addr = self.get_and_register_uniq_address(
                self.get_wallet_ref(ACCOUNT_ID_REG)?.as_ref(),
                &change_addr,
            )?;
            (Some(recv_addr), None)
        };

        self.assets
            .get(&details.asset)
            .ok_or(anyhow!("unknown asset"))?;

        let reserved_txouts = self
            .submit_data
            .values()
            .flat_map(|item| item.txouts.iter())
            .collect::<BTreeSet<_>>();
        // TODO: Remove UTXO value filtering for two step swaps after implementing funding transactions
        let filtered_utxos = inputs
            .iter()
            .filter(|utxo| {
                reserved_txouts
                    .get(&TxOut::new(utxo.txid, utxo.vout))
                    .is_none()
                    // In two step swaps we only interested in UTXOs with exact amount
                    && (!two_step || utxo.value == send_amount as u64)
            })
            .cloned()
            .collect::<Vec<_>>();
        let filtered_amount = filtered_utxos.iter().map(|utxo| utxo.value).sum::<u64>() as i64;
        let mut asset_utxos = if filtered_amount >= send_amount {
            filtered_utxos
        } else {
            warn!(
                "can't find unused UTXO(s), required amount: {}, free amount: {}",
                send_amount, filtered_amount
            );
            inputs
        };

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
            let signed_half = if two_step {
                ensure!(auto_sign, "Auto-sign must be enabled for two-step swap");
                let maker_input = swaps::SigSingleInput {
                    asset: elements::AssetId::from_slice(&send_asset.0).unwrap(),
                    value: send_amount as u64,
                };
                let maker_output = swaps::SigSingleOutput {
                    asset: elements::AssetId::from_slice(&recv_asset.0).unwrap(),
                    value: recv_amount as u64,
                    address: elements::Address::parse_with_params(
                        &recv_addr.clone().unwrap(),
                        self.env.elements_params_pset(),
                    )?,
                };

                let maker_tx = if is_send_amp {
                    self.get_wallet_mut(ACCOUNT_ID_AMP)?
                        .sig_single_maker_tx(&maker_input, &maker_output)?
                } else {
                    self.get_wallet_mut(ACCOUNT_ID_REG)?
                        .sig_single_maker_tx(&maker_input, &maker_output)?
                };

                if let Some(chaining_tx) = &maker_tx.chaining_tx {
                    let allowed = req.tx_chaining_allowed.unwrap_or(false);
                    ensure!(allowed, "Please allow tx chaining and try again");
                    inputs = vec![chaining_tx.input.clone()];
                    self.update_address_registrations();
                }

                Some(MakerSignedHalf {
                    chaining_tx: maker_tx
                        .chaining_tx
                        .map(|chaining_tx| elements::encode::serialize_hex(&chaining_tx.tx)),
                    tx: elements::encode::serialize_hex(&maker_tx.tx),
                    input: MakerInput {
                        prevout_script: maker_tx.input_prevout_script,
                    },
                    output: MakerOutput {
                        asset: recv_asset,
                        asset_bf: BlindingFactor::from_slice(
                            maker_tx.output_asset_bf.into_inner().as_ref(),
                        )
                        .unwrap(),
                        value: recv_amount as u64,
                        value_bf: BlindingFactor::from_slice(
                            maker_tx.output_value_bf.into_inner().as_ref(),
                        )
                        .unwrap(),
                        sender_sk: maker_tx.output_sender_sk.to_string(),
                    },
                })
            } else {
                None
            };

            let addr_req = PsetMakerRequest {
                order_id: order_id.clone(),
                price: details.price,
                private: req.private.unwrap_or(false),
                ttl_seconds: req.ttl_seconds,
                inputs,
                recv_addr,
                recv_gaid,
                recv_device_key: self.settings.device_key.clone(),
                change_addr,
                signed_half,
            };
            send_request!(self, PsetMaker, addr_req)?;
        } else {
            let addr_req = PsetTakerRequest {
                order_id: order_id.clone(),
                price: details.price,
                inputs,
                recv_addr,
                recv_gaid,
                recv_device_key: self.settings.device_key.clone(),
                change_addr,
            };
            send_request!(self, PsetTaker, addr_req)?;
        };

        let bitcoin_amount = Amount::from_sat(details.bitcoin_amount);
        let sell_bitcoin = details.send_bitcoins;
        let price = details.price;
        let server_fee = Amount::from_sat(details.server_fee);

        let asset = self
            .assets
            .get(&details.asset)
            .ok_or(anyhow!("unknown asset"))?;

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
            two_step,
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
        let asset_id = OrderId::from_str(&req.order_id).ok().and_then(|order_id| {
            self.active_submits
                .get(&order_id)
                .map(|order| order.details.asset)
        });
        let domain_agent = asset_id.and_then(|asset_id| {
            self.assets
                .get(&asset_id)
                .and_then(|asset| asset.domain_agent.clone())
        });

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
                let unregistered_err = "Your AMP ID must be registered with the issuer to trade this product. Please consult product details for further information.";
                match (e.to_string(), domain_agent) {
                    (err_text, Some(domain_agent)) if err_text == unregistered_err => {
                        ffi::proto::from::submit_result::Result::UnregisteredGaid(
                            ffi::proto::from::submit_result::UnregisteredGaid { domain_agent },
                        )
                    }
                    _ => ffi::proto::from::submit_result::Result::Error(e.to_string()),
                }
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
        let submit_data = self
            .submit_data
            .get(&msg.order_id)
            .ok_or_else(|| anyhow!("submit_data not found"))?;
        let side = submit_data.side;
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

        let send_amounts = swaps::Amounts {
            send_asset: amounts.send_asset,
            send_amount: amounts.send_amount,
            recv_asset: amounts.recv_asset,
            recv_amount: 0,
        };

        let recv_amounts = swaps::Amounts {
            send_asset: amounts.send_asset,
            send_amount: 0,
            recv_asset: amounts.recv_asset,
            recv_amount: amounts.recv_amount,
        };

        let nonces = if send_amp {
            msg.nonces
                .as_ref()
                .ok_or_else(|| anyhow!("blinding keys should be known"))?
                .as_slice()
        } else {
            &[]
        };

        let recv_account_id = if recv_amp {
            ACCOUNT_ID_AMP
        } else {
            ACCOUNT_ID_REG
        };

        let send_account_id = if send_amp {
            ACCOUNT_ID_AMP
        } else {
            ACCOUNT_ID_REG
        };

        let recv_wallet = self.get_wallet_mut(recv_account_id)?;
        recv_wallet.verify_and_sign_pset(&recv_amounts, &msg.pset, nonces)?;

        let send_wallet = self.get_wallet_mut(send_account_id)?;
        let signed_pset = send_wallet.verify_and_sign_pset(&send_amounts, &msg.pset, nonces)?;

        send_request!(
            self,
            Sign,
            SignRequest {
                order_id: msg.order_id.clone(),
                signed_pset,
                side,
            }
        )?;

        let submit_data = self.submit_data.get_mut(&msg.order_id).unwrap();
        submit_data.signed = true;

        Ok(false)
    }

    fn try_process_sign(&mut self, msg: SignNotification) -> Result<(), anyhow::Error> {
        let existing = self.processed_signs.contains(&msg.order_id);
        debug!(
            "try_process_sign, order_id: {}, existing: {}, side: {:?}",
            msg.order_id, existing, msg.details.side
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
        debug!(
            "process sign, order_id: {}, side: {:?}",
            msg.order_id, msg.details.side
        );
        if msg.details.side == OrderSide::Taker {
            let result = self.try_process_sign(msg);
            if let Err(e) = result {
                self.show_message(&format!("sign failed: {}", e.to_string()));
            }
            return;
        }

        self.pending_sign_requests.push_back(msg);
        self.process_pending_requests();
    }

    fn process_pending_sign_prompts(&mut self) {
        debug!(
            "process_pending_sign_prompts: sign_prompts: {}, visible_submit: {}",
            self.pending_sign_prompts.len(),
            self.visible_submit.is_some(),
        );
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
                two_step: None,
                tx_chaining_required: None,
            };
            debug!("send for review sign prompt for {}", msg.order_id);
            self.ui
                .send(ffi::proto::from::Msg::SubmitReview(submit_review));
            self.visible_submit = Some(msg.order_id.clone());
            self.active_sign = Some(msg);
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
        let submit = self
            .submit_data
            .get_mut(&order_id)
            .ok_or_else(|| anyhow!("submit data not found"))?;
        let order = self
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

        for unsubscribe in self.subscribes.difference(&new_subscribes) {
            self.send_request_msg(Request::Unsubscribe(UnsubscribeRequest {
                asset: unsubscribe.clone(),
            }));
        }
        for subscribe in new_subscribes.difference(&self.subscribes) {
            self.send_request_msg(Request::Subscribe(SubscribeRequest {
                asset: subscribe.clone(),
            }));
        }

        self.subscribes = new_subscribes;
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
        for subscribe in self.subscribes.iter() {
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
                submit_data.txid = Some(v)
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
        if let Some(own) = msg.own.as_ref() {
            let adding_result =
                self.add_missing_submit_data(&msg.order_id, &msg.details, own.two_step);
            if let Err(e) = adding_result {
                error!("adding missing submit data failed: {}", e);
            }
        }

        let private = msg.own.as_ref().map(|v| v.private).unwrap_or(false);
        let swap_market = self.assets.get(&msg.details.asset).is_some();
        let amp_market = self.amp_assets.get(&msg.details.asset).is_some();
        let token_market = !swap_market && !amp_market;
        let (auto_sign, two_step) = self
            .submit_data
            .get(&msg.order_id)
            .map(|submit| (submit.auto_sign, submit.two_step))
            .unwrap_or((false, false));
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
            two_step,
            auto_sign,
            own,
            token_market,
            from_notification,
            index_price,
        };
        self.orders_last.insert(msg.order_id, order);
    }

    fn remove_order(&mut self, order_id: &OrderId) {
        self.orders_last.remove(order_id);
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
        &mut self,
        msg: BlindedSwapClientNotification,
    ) -> Result<(), anyhow::Error> {
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

        let wallet = self.get_wallet_mut(ACCOUNT_ID_REG)?;

        let signed_pset = wallet.verify_and_sign_pset(&amounts, &msg.pset, &[])?;

        send_request!(
            self,
            SignedSwapClient,
            SignedSwapClientRequest {
                order_id: msg.order_id,
                pset: signed_pset,
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
        match self.active_swap.as_ref() {
            Some(v) if v.order_id == msg.order_id => v,
            _ => return,
        };
        let _active_swap = self.active_swap.take().unwrap();

        let error = match msg.status {
            SwapDoneStatus::Success => None,
            SwapDoneStatus::ClientError => Some("client error"),
            SwapDoneStatus::DealerError => Some("dealer error"),
            SwapDoneStatus::ServerError => Some("server error"),
        };
        match (error, msg.txid) {
            (None, Some(txid)) => {
                debug!("instant swap succeed, txid: {}", txid);
                self.succeed_swap = Some(txid);
                self.update_sync_interval();
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

    fn check_ws_connection(&mut self) {
        debug!("check ws connection");
        if !self.connected {
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

    fn update_amp_connection(&mut self) {
        let amp_active = self.app_active || self.pending_amp_sign_requests();
        if self.amp_active == amp_active {
            return;
        }
        self.amp_active = amp_active;
        let wallet = match self.get_wallet_mut(ACCOUNT_ID_AMP) {
            Ok(v) => v,
            Err(_) => return,
        };
        if amp_active {
            debug!("request AMP connect");
            wallet.connect()
        } else {
            debug!("request AMP disconnect");
            wallet.disconnect()
        }
    }

    fn check_amp_connection(&mut self) {
        if !self.amp_connected {
            return;
        }
        let wallet = match self.get_wallet_mut(ACCOUNT_ID_AMP) {
            Ok(v) => v,
            Err(_) => return,
        };
        if wallet.get_previous_addresses(None, false).is_ok() {
            debug!("AMP connection check succeed");
            return;
        }
        warn!("AMP connection check failed");
        wallet.disconnect();
        wallet.connect();
        self.amp_connected = false;
    }

    fn check_connections(&mut self) {
        self.check_ws_connection();
        self.check_amp_connection();
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
                self.check_connections();
                self.process_pending_requests();
            }
            _ => {}
        }
    }

    fn add_missing_submit_data(
        &mut self,
        order_id: &OrderId,
        details: &Details,
        two_step: bool,
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

            // Auto sign is disabled after app restart (unless two-step swap is used)
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
                auto_sign: two_step,
                two_step,
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
        self.add_missing_submit_data(&order_id, &sign.data.details, false)?;
        self.process_sign(sign.data);

        Ok(())
    }

    fn skip_wallet_sync(&self) -> bool {
        self.pending_submits.is_empty() && self.pending_links.is_empty()
    }

    fn pending_amp_sign_requests(&self) -> bool {
        self.pending_sign_requests
            .iter()
            .any(|sign| self.amp_assets.contains(&sign.details.asset))
            || self.pending_signs.keys().all(|order_id| {
                self.submit_data
                    .get(order_id)
                    .map(|submit| submit.market == MarketType::Amp)
                    .unwrap_or(false)
            })
    }

    fn process_pending_requests(&mut self) {
        let pending_amp_sign_requests = self.pending_amp_sign_requests();
        debug!(
            "process_pending_requests, signs: {}, submits: {}, links: {}, sign_requests: {}, sign_prompts: {}, connected: {}, pending_amp_sign_requests: {}",
            self.pending_signs.len(),
            self.pending_submits.len(),
            self.pending_links.len(),
            self.pending_sign_requests.len(),
            self.pending_sign_prompts.len(),
            self.connected,
            pending_amp_sign_requests
        );
        if !self.connected {
            debug!("wait until WS is connected");
            return;
        }
        if !self.amp_connected && pending_amp_sign_requests {
            debug!("wait until AMP is connected");
            self.update_amp_connection();
            return;
        }
        if self.wallets.contains_key(&ACCOUNT_ID_REG) && !self.sync_complete {
            debug!("wait until sync is complete");
            return;
        }

        let pending_signs = std::mem::replace(&mut self.pending_signs, BTreeMap::new());
        let mut background_requests = Vec::new();
        for (order_id, pending_sign) in pending_signs.into_iter() {
            if self.processed_signs.get(&order_id).is_none() {
                let result = self.download_sign_request(order_id);
                if let Err(e) = result {
                    self.show_message(&format!("sign failed: {}", e));
                }
                if let Some(pending_sign) = pending_sign {
                    background_requests.push(pending_sign);
                }
            }
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

        self.update_amp_connection();

        for background_request in background_requests {
            let _ = background_request.send(());
        }
    }

    fn process_ui(&mut self, msg: ffi::ToMsg) {
        debug!(
            "from ui: {}",
            serde_json::to_string(&redact_to_msg(msg.clone())).unwrap()
        );
        match msg {
            ffi::proto::to::Msg::Login(req) => self.process_login_request(
                Some(&req.mnemonic),
                req.send_utxo_updates,
                &req.network.selected,
                None,
            ),
            ffi::proto::to::Msg::Logout(_) => self.process_logout_request(),
            ffi::proto::to::Msg::ChangeNetwork(req) => self.process_change_network(req),
            ffi::proto::to::Msg::EncryptPin(req) => self.process_encrypt_pin(req),
            ffi::proto::to::Msg::DecryptPin(req) => self.process_decrypt_pin(req),
            ffi::proto::to::Msg::AppState(req) => self.process_app_state(req),
            ffi::proto::to::Msg::PushMessage(req) => self.process_push_message(req, None),
            ffi::proto::to::Msg::PegInRequest(_) => self.process_pegin_request(),
            ffi::proto::to::Msg::PegOutAmount(req) => self.process_pegout_amount(req),
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
            ffi::proto::to::Msg::JadeLogin(msg) => self.process_jade_login_request(msg),
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
            instant_swaps: asset.instant_swaps.unwrap_or(false),
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
                } else if self.env == Env::Testnet {
                    include_bytes!("../data/assets-testnet.json").to_vec()
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

    fn register_addresses(&self, list: &[String]) {
        let list = list
            .iter()
            .map(|addr| {
                elements::Address::parse_with_params(addr, self.env.elements_params())
                    .unwrap()
                    .to_unconfidential()
                    .to_string()
            })
            .collect::<Vec<_>>();
        if let (Some(device_key), true) = (self.settings.device_key.as_ref(), self.connected) {
            for chunk in list.chunks(MAX_REGISTER_ADDRESS_COUNT as usize) {
                self.send_request_msg(Request::RegisterAddresses(RegisterAddressesRequest {
                    device_key: device_key.clone(),
                    addresses: chunk.to_vec(),
                }));
            }
        }
    }

    fn update_address_registrations(&mut self) {
        if let (true, Some(_device_key)) = (self.connected, &self.settings.device_key) {
            let last_pointer = self.settings.last_external_new;
            if let Ok((last_pointer, list)) = self
                .get_wallet_mut(ACCOUNT_ID_REG)
                .and_then(|wallet| load_all_addresses(wallet.as_mut(), false, last_pointer))
            {
                self.register_addresses(&list);
                self.settings.last_external_new = Some(last_pointer);
                self.save_settings();
            }

            let last_pointer = self.settings.last_internal_new;
            if let Ok((last_pointer, list)) = self
                .get_wallet_mut(ACCOUNT_ID_REG)
                .and_then(|wallet| load_all_addresses(wallet.as_mut(), true, last_pointer))
            {
                self.register_addresses(&list);
                self.settings.last_internal_new = Some(last_pointer);
                self.save_settings();
            }

            let last_pointer = self.settings.last_external_amp_new;
            if let Ok((last_pointer, list)) = self
                .get_wallet_mut(ACCOUNT_ID_AMP)
                .and_then(|wallet| load_all_addresses(wallet.as_mut(), false, last_pointer))
            {
                self.register_addresses(&list);
                self.settings.last_external_amp_new = Some(last_pointer);
                self.save_settings();
            }
        }
    }

    fn download_contacts(&mut self) {
        let phone_key = self.phone_key.clone();
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

    fn update_sync_interval(&mut self) {
        let pending_tx = self.sent_txhash.is_some() || self.succeed_swap.is_some();
        let interval = if pending_tx { 1 } else { 7 };
        for wallet in self.wallets.values() {
            wallet.update_sync_interval(interval);
        }
    }

    fn sync_order_list(&mut self) {
        debug!(
            "sync order list, last: {}, sent: {}",
            self.orders_last.len(),
            self.orders_sent.len()
        );
        let removed = self
            .orders_sent
            .keys()
            .filter(|order_id| !self.orders_last.contains_key(order_id))
            .cloned()
            .collect::<Vec<_>>();
        for order_id in removed {
            self.orders_sent.remove(&order_id);
            let order_removed = ffi::proto::from::OrderRemoved {
                order_id: order_id.to_string(),
            };
            self.ui
                .send(ffi::proto::from::Msg::OrderRemoved(order_removed));
        }
        for (order_id, order) in self.orders_last.iter() {
            let order_sent = self.orders_sent.get(order_id);
            if order_sent != Some(order) {
                let new = order_sent.is_none() && order.from_notification;
                self.orders_sent.insert(order_id.clone(), order.clone());
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

    fn process_idle_timer(&mut self) {
        let now = std::time::Instant::now();
        if now.duration_since(self.last_connection_check) > AMP_CONNECTION_CHECK_PERIOD {
            self.last_connection_check = now;
            self.check_connections();
        }
    }

    fn get_wallet_ref(
        &self,
        account_id: AccountId,
    ) -> Result<&Box<dyn gdk_ses::GdkSes>, anyhow::Error> {
        self.wallets
            .get(&account_id)
            .ok_or_else(|| anyhow!("wallet not found"))
    }

    fn get_wallet_mut(
        &mut self,
        account_id: AccountId,
    ) -> Result<&mut Box<dyn gdk_ses::GdkSes>, anyhow::Error> {
        self.wallets
            .get_mut(&account_id)
            .ok_or_else(|| anyhow!("wallet not found"))
    }

    fn get_jade_mut(&mut self, port_name: &str) -> Result<&mut JadeData, anyhow::Error> {
        self.jades
            .iter_mut()
            .find(|data| data.port.port_name == port_name)
            .ok_or_else(|| anyhow!("unknown port name"))
    }

    fn try_process_jade_login_request(
        &mut self,
        msg: ffi::proto::to::JadeLogin,
    ) -> Result<(), anyhow::Error> {
        let data = self.get_jade_mut(&msg.port)?;
        ensure!(data.state == JadeState::Idle);
        data.state = JadeState::Connecting;
        self.sync_jade();

        let (resp_sender, resp_receiver) = std::sync::mpsc::channel();
        let callback = move |msg| {
            let _ = resp_sender.send(msg);
        };

        let data = self.get_jade_mut(&msg.port).unwrap();
        let jade_result = sideswap_jade::Jade::new(data.port.clone(), callback);
        let jade = match jade_result {
            Ok(jade) => {
                data.state = JadeState::Unlocking;
                self.sync_jade();
                jade
            }
            Err(e) => {
                bail!("openning jade device failed: {}", e);
            }
        };

        jade.read_status();
        let resp = resp_receiver.recv_timeout(std::time::Duration::from_secs(10));
        let status = match resp {
            Ok(sideswap_jade::Resp::ReadStatus(v)) => v,
            _ => bail!("unexpected Jade response"),
        }?;
        debug!("jade state: {:?}", status.jade_state);

        match status.jade_state {
            sideswap_jade::models::State::Ready => {
                debug!("jade already unlocked");
            }
            sideswap_jade::models::State::Locked => {
                let network = if self.env.data().mainnet {
                    sideswap_jade::Network::Liquid
                } else {
                    sideswap_jade::Network::TestnetLiquid
                };
                jade.auth_user(network);
                let resp = resp_receiver.recv_timeout(std::time::Duration::from_secs(360));
                let res = match resp {
                    Ok(sideswap_jade::Resp::AuthUser(v)) => v,
                    _ => bail!("unexpected Jade response"),
                }?;
                debug!("jade unlock result: {}", res);
                ensure!(res, "unlock failed");
            }
            sideswap_jade::models::State::Uninit
            | sideswap_jade::models::State::Unsaved
            | sideswap_jade::models::State::Temp => {
                bail!("unexpected jade state: {:?}", status.jade_state);
            }
        }

        let data = self.get_jade_mut(&msg.port).unwrap();
        data.state = JadeState::Connected;

        let name = format!(
            "Jade {}",
            data.port.serial_number.clone().unwrap_or_default()
        );

        let hw_data = gdk_ses::HwData {
            env: self.env,
            name,
            jade: std::sync::Arc::new(jade),
            resp_receiver: std::sync::Arc::new(resp_receiver),
        };

        self.sync_jade();

        self.process_login_request(None, None, &None, Some(hw_data));

        Ok(())
    }

    fn process_jade_login_request(&mut self, msg: ffi::proto::to::JadeLogin) {
        let result = self.try_process_jade_login_request(msg.clone());
        if let Err(e) = result {
            self.show_message(&format!("{}", e));
            if let Ok(data) = self.get_jade_mut(&msg.port) {
                data.state = JadeState::Idle;
                self.sync_jade();
            }
        }
    }

    fn process_scan_jade(&mut self, ports: Vec<sideswap_jade::Port>) {
        let mut sync_required = false;

        for port in ports.iter() {
            if self.jades.iter().find(|data| data.port == *port).is_none() {
                debug!("new jade device detected: {}", port.port_name);
                self.jades.push(JadeData {
                    port: port.clone(),
                    state: JadeState::Idle,
                });
                sync_required = true;
            }
        }

        loop {
            let removed = self
                .jades
                .iter()
                .enumerate()
                .find(|(_, data)| ports.iter().find(|port| data.port == **port).is_none());
            match removed {
                Some((index, _)) => {
                    // FIXME: Stop wallets when Jade is disconnected
                    let data = self.jades.remove(index);
                    debug!("jade device removed: {}", data.port.port_name);
                    sync_required = true;
                }
                None => break,
            }
        }

        if sync_required {
            self.sync_jade();
        }
    }

    fn sync_jade(&self) {
        let ports = self
            .jades
            .iter()
            .map(|data| ffi::proto::from::jade_ports::Port {
                port: data.port.port_name.clone(),
                serial: data.port.serial_number.clone(),
                state: i32::from(convert_jade_state(&data.state)),
            })
            .collect();
        self.ui.send(ffi::proto::from::Msg::JadePorts(
            ffi::proto::from::JadePorts { ports },
        ))
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

    let env_data = env.data();
    let (resp_sender, resp_receiver) = crossbeam_channel::unbounded::<ServerResp>();
    let (ws_sender, ws_receiver, ws_hint) = ws::start(
        env_data.host.to_owned(),
        env_data.port,
        env_data.use_tls,
        true,
    );

    ws_sender.send(ws::WrappedRequest::Connect).unwrap();

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

    let msg_sender_copy = msg_sender.clone();
    std::thread::spawn(move || loop {
        std::thread::sleep(IDLE_TIMER);
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
        app_active: true,
        amp_active: true,
        amp_connected: false,
        connected: false,
        server_status: None,
        env,
        ui,
        assets: BTreeMap::new(),
        amp_assets: BTreeSet::new(),
        assets_old: Vec::new(),
        msg_sender: msg_sender.clone(),
        ws_sender,
        ws_hint,
        resp_receiver,
        params,
        agent: ureq::agent(),
        sync_complete: false,
        wallet_loaded_sent: false,
        confirmed_txids: BTreeMap::new(),
        unconfirmed_txids: BTreeMap::new(),
        orders_last: BTreeMap::new(),
        orders_sent: BTreeMap::new(),
        send_utxo_updates: false,
        wallets: BTreeMap::new(),
        phone_key: None,
        subscribes: BTreeSet::new(),
        active_swap: None,
        succeed_swap: None,
        active_extern_peg: None,
        sent_txhash: None,
        peg_out_server_amounts: None,
        active_submits: BTreeMap::new(),
        active_sign: None,
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
        subscribed_market_data: None,
        last_connection_check: std::time::Instant::now(),
        last_blocks: BTreeMap::new(),
        jades: Vec::new(),
    };

    if let Err(error) = gdk_registry::init(&state.registry_path()) {
        match error {
            gdk_registry::Error::AlreadyInitialized => {}
            _ => panic!("gdk_registry init failed: {}", error),
        }
    }

    std::thread::spawn(move || {
        gdk_registry::refresh_assets(gdk_registry::RefreshAssetsParam {
            assets: true,
            icons: true,
            refresh: true,
            config: get_registry_config(env),
        })
    });

    if let Err(e) = state.load_assets() {
        error!("can't load assets: {}", &e);
    }

    if ENABLE_JADE {
        let msg_sender_copy = msg_sender.clone();
        std::thread::spawn(move || {
            debug!("start scan jade thread");
            let mut last_result = None;
            loop {
                std::thread::sleep(std::time::Duration::from_secs(10));
                let ports_result = sideswap_jade::Handle::ports();
                let new_result = match &ports_result {
                    Ok(v) => format!("succeed: {:?}", v),
                    Err(e) => format!("failed: {}", e),
                };
                if last_result.as_ref() != Some(&new_result) {
                    debug!("jade ports scan: {}", new_result);
                    last_result = Some(new_result);
                }
                let send_result =
                    msg_sender_copy.send(Message::ScanJade(ports_result.unwrap_or_default()));
                if send_result.is_err() {
                    break;
                }
            }
            debug!("quit scan jade thread");
        });
    }

    while let Ok(a) = msg_receiver.recv() {
        let started = std::time::Instant::now();

        match a {
            Message::Notif(account_id, msg) => state.process_wallet_notif(account_id, msg),
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
}
