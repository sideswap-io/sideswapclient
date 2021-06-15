use super::*;
use gdk_common::model::{GDKRUST_json, TransactionMeta, UnspentOutput};
use gdk_common::session::Session;
use gdk_electrum::{ElectrumSession, NativeNotif};
use settings::{Peg, PegDir};
use sideswap_api::*;
use sideswap_common::types::*;
use sideswap_common::*;
use sideswap_libwally::*;
use std::sync::{
    mpsc::{Receiver, Sender},
    Mutex,
};
use std::{
    collections::{BTreeMap, BTreeSet, HashMap},
    str::FromStr,
};
use types::Amount;
use types::Env;

const CLIENT_API_KEY: &str = "f8b7a12ee96aa68ee2b12ebfc51d804a4a404c9732652c298d24099a3d922a84";

const USER_AGENT: &str = "sideswap";

const SERVER_REQUEST_TIMEOUT: std::time::Duration = std::time::Duration::from_secs(5);
const SERVER_REQUEST_POLL_PERIOD: std::time::Duration = std::time::Duration::from_secs(1);

const ACCOUNT: u32 = 0;

const BALANCE_NUM_CONFS: u32 = 0;

const TX_CONF_COUNT: u32 = 2;

const EXTRA_ADDRESS_COUNT: u32 = 100;
const MAX_REGISTER_ADDRESS_COUNT: u32 = 100;

const DEFAULT_ICON: &[u8] = include_bytes!("../images/icon_blank.png");

const AUTO_SIGN_ALLOWED_INDEX_PRICE_CHANGE: f64 = 0.1;

#[derive(serde::Deserialize, Debug)]
struct GdkAsset {
    asset_id: AssetId,
    name: Option<String>,
    precision: Option<u8>,
    ticker: Option<Ticker>,
}

#[derive(serde::Deserialize, Debug, Default)]
pub struct GdkAssets {
    assets: BTreeMap<AssetId, GdkAsset>,
    icons: BTreeMap<AssetId, String>,
}

fn network_type(mainnet: bool) -> &'static elements::AddressParams {
    if mainnet {
        &elements::AddressParams::LIQUID
    } else {
        &elements::AddressParams::ELEMENTS
    }
}

fn output_address(
    txout: &elements::TxOut,
    params: &'static elements::AddressParams,
) -> Option<elements::Address> {
    elements::Address::from_script(&txout.script_pubkey, None, params)
}

struct ActivePeg {
    order_id: OrderId,
}

enum AddrType {
    External,
    Internal,
}

struct SendTx {
    tx: TransactionMeta,
    send_all: bool,
    asset_id: AssetId,
    amount: i64,
}

pub struct Context {
    session: ElectrumSession,
    last_balances: BTreeMap<AssetId, Amount>,
    used_utxos: BTreeSet<types::TxOut>,
    sync_complete: bool,
    wallet_loaded_sent: bool,

    pegs: BTreeMap<OrderId, PegStatus>,
    txs: Vec<gdk_common::model::TxListItem>,
    sent_txs: BTreeMap<String, ffi::proto::TransItem>,
    succeed_swap: Option<String>,

    active_swap: Option<ActiveSwap>,
    psbt: Option<String>,
    psbt_utxos: Option<Vec<gdk_common::model::UnspentOutput>>,

    send_tx: Option<SendTx>,
    internal_peg: Option<InternalPeg>,
    active_extern_peg: Option<ActivePeg>,

    active_submit: Option<LinkResponse>,
    active_sign: Option<SignNotification>,
}

pub struct ServerResp(Option<RequestId>, Result<Response, Error>);

fn get_tx_out(utxo: &UnspentOutput) -> types::TxOut {
    types::TxOut {
        txid: utxo.txhash.clone(),
        vout: utxo.pt_idx as i32,
    }
}

struct InternalPeg {
    send_amount: i64,
    blocks: i32,
}

struct SubmitData {
    order_id: OrderId,
    side: OrderSide,
    asset: AssetId,
    bitcoin_amount: Amount,
    asset_amount: Amount,
    server_fee: Amount,
    price: f64,
    asset_precision: u8,
    sell_bitcoin: bool,
    txouts: BTreeSet<TxOut>,
    auto_sign: bool,
    txid: Option<String>,
    index_price: bool,
}

pub struct Data {
    connected: bool,
    server_status: Option<ServerStatus>,
    env: Env,
    assets: BTreeMap<AssetId, Asset>,
    assets_old: Vec<Asset>,
    tickers: BTreeMap<Ticker, AssetId>,
    from_sender: Sender<ffi::FromMsg>,
    ws_sender: Sender<ws::WrappedRequest>,
    resp_receiver: Receiver<ServerResp>,
    params: ffi::StartParams,
    notif_context: *mut NotifContext,
    ctx: Option<Context>,
    settings: settings::Settings,
    push_token: Option<String>,
    liquid_asset_id: AssetId,
    bitcoin_asset_id: String,
    submit_data: BTreeMap<OrderId, SubmitData>,
    pending_signs: BTreeSet<OrderId>,
    visible_submit: Option<OrderId>,
    processed_signs: BTreeSet<OrderId>,
    mobile_submits: BTreeSet<OrderId>,
    pending_sign_requests: std::collections::VecDeque<SignNotification>,
    pending_submits: Vec<ffi::proto::to::SubmitOrder>,
    pending_links: Vec<ffi::proto::to::LinkOrder>,
    utxos_resp: BTreeMap<OrderId, settings::StoredUtxo>,
}

pub struct ActiveSwap {
    order_id: OrderId,
    send_asset: AssetId,
    recv_asset: AssetId,
    send_amount: Amount,
    recv_amount_accepted: Option<Amount>,
    inputs: Vec<gdk_common::model::UnspentOutput>,
    network_fee: Option<i64>,
}

#[derive(Debug)]
enum Message {
    Ui(ffi::ToMsg),
    ServerConnected,
    ServerDisconnected,
    ServerNotification(Notification),
    Notif(serde_json::Value),
    PegStatus(PegStatus),
}

struct NotifContext(Mutex<Sender<serde_json::Value>>);

extern "C" fn notification_callback(context: *const libc::c_void, json: *const GDKRUST_json) {
    let context = unsafe { &*(context as *const NotifContext) };
    let json = unsafe { (*json).0.clone() };
    context.0.lock().unwrap().send(json).unwrap();
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

fn parse_gdk_time(s: &str) -> Result<chrono::DateTime<chrono::Utc>, anyhow::Error> {
    let naive_datetime = chrono::NaiveDateTime::parse_from_str(s, "%Y-%m-%d %H:%M:%S")?;
    let datetime = chrono::DateTime::<chrono::Utc>::from_utc(naive_datetime, chrono::Utc);
    Ok(datetime)
}

fn rev(mut v: Vec<u8>) -> Vec<u8> {
    v.reverse();
    v
}

impl Data {
    fn get_tx_item(
        &self,
        tx: &gdk_common::model::TxListItem,
        top_block: u32,
    ) -> ffi::proto::TransItem {
        let created_at = parse_gdk_time(&tx.created_at).expect("invalid datetime");
        let mut balances = tx
            .satoshi
            .iter()
            .map(|(asset_id, balance)| ffi::proto::Balance {
                asset_id: asset_id.clone(),
                amount: balance.clone(),
            })
            .collect::<Vec<_>>();
        // Sort balances to fix ffi::proto::TransItem equality checks
        balances.sort_by(|a, b| match a.asset_id.cmp(&b.asset_id) {
            std::cmp::Ordering::Less => std::cmp::Ordering::Less,
            std::cmp::Ordering::Greater => std::cmp::Ordering::Greater,
            std::cmp::Ordering::Equal => a.amount.cmp(&b.amount),
        });
        let tx_details = ffi::proto::Tx {
            balances,
            memo: tx.memo.clone(),
            network_fee: tx.fee as i64,
            txid: tx.txhash.clone(),
        };
        let count = if tx.block_height == 0 || tx.block_height > top_block {
            0
        } else {
            top_block - tx.block_height + 1
        };
        let confs = if count < TX_CONF_COUNT {
            Some(ffi::proto::Confs {
                count,
                total: TX_CONF_COUNT,
            })
        } else {
            None
        };
        let tx_item = ffi::proto::TransItem {
            id: tx.txhash.clone(),
            created_at: created_at.timestamp_millis(),
            confs,
            item: Some(ffi::proto::trans_item::Item::Tx(tx_details)),
        };
        tx_item
    }

    fn peg_txitem_id(send_txid: &str, send_vout: i32) -> String {
        format!("{}/{}", send_txid, send_vout)
    }

    fn get_peg_item(&self, peg: &PegStatus, tx: &TxStatus) -> ffi::proto::TransItem {
        let peg_details = ffi::proto::Peg {
            is_peg_in: peg.peg_in,
            amount_send: tx.amount,
            amount_recv: tx.payout.unwrap_or_default(),
            addr_send: peg.addr.clone(),
            addr_recv: peg.addr_recv.clone(),
            txid_send: tx.tx_hash.clone(),
            vout_send: tx.vout,
            txid_recv: tx.payout_txid.clone(),
        };
        let confs = tx.detected_confs.and_then(|count| {
            tx.total_confs.map(|total| ffi::proto::Confs {
                count: count as u32,
                total: total as u32,
            })
        });
        let id = Data::peg_txitem_id(&tx.tx_hash, tx.vout);
        let tx_item = ffi::proto::TransItem {
            id,
            created_at: tx.created_at,
            confs,
            item: Some(ffi::proto::trans_item::Item::Peg(peg_details)),
        };
        tx_item
    }

    fn try_update_tx_list(&mut self) -> Result<(), anyhow::Error> {
        if self.assets.is_empty() || self.ctx.is_none() {
            return Ok(());
        }
        let ctx = self.ctx.as_mut().unwrap();
        let opt = gdk_common::model::GetTransactionsOpt {
            count: usize::MAX,
            ..gdk_common::model::GetTransactionsOpt::default()
        };
        ctx.txs = ctx
            .session
            .get_transactions(&opt)
            .map_err(|e| anyhow!("{}", e))?
            .0;

        let ctx = self.ctx.as_ref().unwrap();
        let all_asset_ids = ctx
            .txs
            .iter()
            .flat_map(|item| item.satoshi.keys())
            .collect::<BTreeSet<_>>();
        let new_asset_ids = all_asset_ids
            .iter()
            .map(|&asset| AssetId(asset.clone()))
            .filter(|asset| self.assets.get(&asset).is_none())
            .collect::<Vec<_>>();
        if !new_asset_ids.is_empty() {
            info!("try to add new assets: {}", new_asset_ids.len());
            let assets = ctx
                .session
                .refresh_assets(&gdk_common::model::RefreshAssets {
                    icons: true,
                    assets: true,
                    refresh: true,
                })
                .unwrap_or_default();
            let gdk_assets = match serde_json::from_value::<GdkAssets>(assets) {
                Ok(v) => {
                    info!(
                        "gdk assets loaded: {}, icons: {}",
                        v.assets.len(),
                        v.icons.len()
                    );
                    v
                }
                Err(e) => {
                    error!("assets parsing failed: {}", e);
                    GdkAssets::default()
                }
            };
            for asset_id in new_asset_ids.iter() {
                let icon = gdk_assets
                    .icons
                    .get(asset_id)
                    .cloned()
                    .unwrap_or_else(|| base64::encode(DEFAULT_ICON));
                let default_ticker = || Ticker(format!("{:0.4}...", &asset_id.0));
                let default_name = || format!("{:0.8}...", &asset_id.0);
                let asset = match gdk_assets.assets.get(asset_id) {
                    Some(v) => Asset {
                        asset_id: asset_id.clone(),
                        name: v.name.clone().unwrap_or_else(default_name),
                        ticker: v.ticker.clone().unwrap_or_else(default_ticker),
                        icon: Some(icon),
                        precision: v.precision.unwrap_or_default(),
                        icon_url: None,
                    },
                    None => Asset {
                        asset_id: asset_id.clone(),
                        name: default_name(),
                        ticker: default_ticker(),
                        icon: Some(base64::encode(DEFAULT_ICON)),
                        precision: 8,
                        icon_url: None,
                    },
                };
                self.register_asset(asset);
            }
        }

        self.sync_tx_list();
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
                self.from_sender
                    .send(ffi::proto::from::Msg::WalletLoaded(ffi::proto::Empty {}))
                    .unwrap();
            }
        }
    }

    fn sync_complete(&mut self) {
        if let Some(ctx) = self.ctx.as_mut() {
            if !ctx.sync_complete {
                ctx.sync_complete = true;
                self.send_wallet_loaded();
                self.process_pending_requests();
            }
        }
    }

    fn resume_peg_monitoring(&mut self) {
        if self.assets.is_empty() || self.ctx.is_none() || !self.connected {
            return;
        }
        for peg in self.settings.pegs.iter().flatten() {
            self.start_peg_monitoring(peg);
        }
    }

    fn get_tx_list(&self, top_block: u32) -> BTreeMap<String, ffi::proto::TransItem> {
        let ctx = self.ctx.as_ref().expect("ctx must be set");
        let new_txs = ctx
            .txs
            .iter()
            .map(|tx| self.get_tx_item(tx, top_block))
            .map(|tx| (tx.id.clone(), tx))
            .collect::<BTreeMap<_, _>>();
        let new_pegs = ctx
            .pegs
            .values()
            .flat_map(|peg| peg.list.iter().map(move |tx| self.get_peg_item(&peg, &tx)))
            .map(|tx| (tx.id.clone(), tx))
            .collect::<BTreeMap<_, _>>();
        let all = new_txs
            .into_iter()
            .chain(new_pegs)
            .collect::<BTreeMap<_, _>>();
        all
    }

    fn get_blinded_value(unblinded: &gdk_common::be::Unblinded) -> String {
        [
            unblinded.value.to_string(),
            unblinded.asset_hex(),
            hex::encode(rev(unblinded.vbf.to_vec())),
            hex::encode(rev(unblinded.abf.to_vec())),
        ]
        .join(",")
    }

    fn get_blinded_values(&self, txid: &str) -> Result<String, anyhow::Error> {
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
        let tx = match tx {
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
        Ok(result.join(","))
    }

    fn try_sync_tx_list(&mut self) -> Result<(), anyhow::Error> {
        // TODO: Ignore confirmed transactions
        let ctx = self.ctx.as_mut().expect("ctx must be set");
        let (top_block, _) = ctx
            .session
            .block_status()
            .map_err(|e| anyhow!("block_status failed: {}", e.to_string()))?;
        let new_list = self.get_tx_list(top_block);
        let ctx = self.ctx.as_mut().expect("ctx must be set");
        let removed_ids = ctx
            .sent_txs
            .iter()
            .filter(|(id, _)| new_list.get(*id).is_none());
        for (id, _) in removed_ids {
            let msg = ffi::proto::from::RemovedTx { id: id.clone() };
            self.from_sender
                .send(ffi::proto::from::Msg::RemovedTx(msg))
                .unwrap();
        }
        for (id, item) in new_list.iter() {
            let need_update = ctx
                .sent_txs
                .get(id)
                .map(|old_tx| old_tx != item)
                .unwrap_or(true);
            if need_update {
                self.from_sender
                    .send(ffi::proto::from::Msg::UpdatedTx(item.clone()))
                    .unwrap();
                if ctx.succeed_swap.as_ref() == Some(&id) {
                    ctx.succeed_swap.take();
                    self.from_sender
                        .send(ffi::proto::from::Msg::SwapSucceed(item.clone()))
                        .unwrap();
                }

                let submit_data = self
                    .submit_data
                    .values()
                    .find(|submit_data| submit_data.txid.as_ref() == Some(&id));
                if let Some(submit_data) = submit_data {
                    if self.visible_submit.as_ref() == Some(&submit_data.order_id) {
                        self.from_sender
                            .send(ffi::proto::from::Msg::SubmitResult(
                                ffi::proto::from::SubmitResult {
                                    result: Some(
                                        ffi::proto::from::submit_result::Result::SwapSucceed(
                                            item.clone(),
                                        ),
                                    ),
                                    minimize_app: false,
                                },
                            ))
                            .unwrap();
                        self.visible_submit = None;
                    }
                }
            }
        }
        ctx.sent_txs = new_list;
        self.update_address_registrations();
        if self.visible_submit.is_none() {
            self.process_pending_sign_requests();
        }
        Ok(())
    }

    fn sync_tx_list(&mut self) {
        if let Err(e) = self.try_sync_tx_list() {
            error!("syncing tx list failed: {}", e.to_string());
        }
    }

    fn update_balances(&mut self) {
        let ctx = match self.ctx.as_mut() {
            Some(v) => v,
            None => return,
        };
        let balance_opts = gdk_common::model::GetBalanceOpt {
            subaccount: ACCOUNT,
            num_confs: BALANCE_NUM_CONFS,
            confidential_utxos_only: None,
        };
        let mut balances = match ctx.session.get_balance(&balance_opts) {
            Ok(v) => v,
            Err(_) => return,
        };

        // Create empty entries for old balances
        for (asset_id, _) in ctx.last_balances.iter() {
            balances.entry(asset_id.0.clone()).or_default();
        }

        let ctx = self.ctx.as_mut().unwrap();
        for (asset_id, balance) in balances.into_iter() {
            let asset_id = AssetId(asset_id);
            let last_amount = ctx.last_balances.get(&asset_id).cloned();
            if last_amount != Some(Amount::from_sat(balance)) {
                let balance_copy = ffi::proto::Balance {
                    asset_id: asset_id.0.clone(),
                    amount: balance,
                };

                self.from_sender
                    .send(ffi::proto::from::Msg::BalanceUpdate(balance_copy))
                    .unwrap();
                ctx.last_balances
                    .insert(asset_id, Amount::from_sat(balance));
            }
        }
    }

    fn data_path(env: Env, path: &str) -> std::path::PathBuf {
        let env_data = types::env_data(env);
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

    fn subscribe_price_update(&self, ticker: &Ticker) {
        let asset_id = match self.tickers.get(ticker) {
            Some(v) => v,
            None => return,
        };
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
        if assets != self.assets_old {
            if let Err(e) = self.save_assets(&assets) {
                error!("can't save assets file: {}", &e);
            }
            self.register_assets(assets);
        }

        let server_status = send_request!(self, ServerStatus, None)?;
        self.process_server_status(server_status);

        self.update_tx_list();
        for asset in self.assets.values() {
            if asset.ticker.0 != TICKER_LBTC {
                self.subscribe_price_update(&asset.ticker);
            }
        }

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
                    warn!("device_key is registered");
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

        Ok(())
    }

    fn process_ws_connected(&mut self) {
        info!("connected to server");
        if let Err(e) = self.try_process_ws_connected() {
            error!("connection failed: {}", &e);
            return;
        }
        self.connected = true;
        self.process_pending_requests();
        self.resume_peg_monitoring();
        self.update_push_token();
        self.update_address_registrations();

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

    fn process_ws_disconnected(&mut self) {
        warn!("disconnected from server");
        self.connected = false;
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
        self.from_sender
            .send(ffi::proto::from::Msg::ServerStatus(status_copy))
            .unwrap();
        self.server_status = Some(resp);
    }

    fn rfq_update(&mut self, msg: MatchRfqUpdate) -> Result<(), anyhow::Error> {
        let ctx = self.ctx.as_mut().ok_or_else(|| anyhow!("no wallet"))?;
        let active_swap = ctx
            .active_swap
            .as_mut()
            .ok_or_else(|| anyhow!("no active swap"))?;

        let recv_amount = msg.quote.as_ref().ok().map(|v| v.recv_amount);
        let network_fee = msg.quote.as_ref().ok().map(|v| v.network_fee);

        active_swap.network_fee = network_fee;

        let error = msg
            .quote
            .err()
            .map(|reason| match reason {
                RfqRejectReason::ServerError => "server error",
                RfqRejectReason::NoDealer => "no dealer",
                RfqRejectReason::AmountLow => "amount low",
                RfqRejectReason::AmountHigh => "amount high",
            })
            .map(|s| s.to_owned());

        let swap_review = ffi::proto::from::SwapReview {
            send_asset: active_swap.send_asset.0.clone(),
            recv_asset: active_swap.recv_asset.0.clone(),
            send_amount: active_swap.send_amount.0,
            recv_amount,
            network_fee,
            error,
        };
        self.from_sender
            .send(ffi::proto::from::Msg::SwapReview(swap_review))
            .unwrap();
        Ok(())
    }

    fn process_rfq_update(&mut self, msg: MatchRfqUpdate) {
        if let Err(e) = self.rfq_update(msg) {
            error!("rfq update failed: {}", &e);
        }
    }

    fn process_swap_notification(&mut self, msg: SwapNotification) {
        // Check that we expect that notification
        match self.ctx.as_ref().and_then(|v| v.active_swap.as_ref()) {
            Some(v) if v.order_id == msg.order_id => v,
            _ => return,
        };
        match msg.state {
            SwapState::WaitPsbt(swap) => self.process_swap_send_psbt(swap),
            SwapState::WaitSign(psbt) => self.process_swap_send_sign(psbt),
            SwapState::Failed(error) => self.swap_failed(error),
            SwapState::Done(txid) => self.swap_succeed(txid),
        };
    }

    fn cleanup_swaps(&mut self) {
        let wallet = self.ctx.as_mut().expect("wallet must be set");
        wallet.active_swap = None;
        wallet.psbt = None;
        wallet.send_tx = None;
        wallet.internal_peg = None;
        wallet.active_extern_peg = None;
    }

    fn swap_send_psbt(&mut self, tx_info: Swap) -> Result<(), anyhow::Error> {
        let ctx = self.ctx.as_ref().ok_or_else(|| anyhow!("no wallet"))?;
        let active_swap = ctx
            .active_swap
            .as_ref()
            .ok_or_else(|| anyhow!("no active swap"))?;

        let psbt_info = PsbtInfo {
            send_asset: tx_info.send_asset.0.clone(),
            recv_asset: tx_info.recv_asset.0.clone(),
            send_amount: active_swap.send_amount.to_sat(),
            recv_amount: tx_info.recv_amount,
        };

        let psbt = generate_psbt(
            &ctx.session.wallet.as_ref().unwrap().read().unwrap(),
            &psbt_info,
            &active_swap.inputs,
            ACCOUNT,
        )?;

        send_request!(
            self,
            Swap,
            SwapRequest {
                order_id: active_swap.order_id.clone(),
                action: SwapAction::Psbt(psbt),
            }
        )?;
        let utxos = active_swap.inputs.clone();
        let wallet = self.ctx.as_mut().expect("wallet must be set");
        wallet.psbt_utxos = Some(utxos);
        Ok(())
    }

    fn process_swap_send_psbt(&mut self, swap: Swap) {
        debug!("send psbt...");
        if let Err(e) = self.swap_send_psbt(swap) {
            error!("sending PSBT failed: {}", &e);
        } else {
            debug!("send succeed");
        }
    }

    fn swap_send_sign(&mut self, psbt: String) -> Result<(), anyhow::Error> {
        let ctx = self.ctx.as_ref().ok_or_else(|| anyhow!("no wallet"))?;
        let active_swap = ctx
            .active_swap
            .as_ref()
            .ok_or_else(|| anyhow!("no active swap"))?
            .clone();
        let utxos = ctx
            .psbt_utxos
            .as_ref()
            .ok_or_else(|| anyhow!("no keys found"))?;
        let psbt_info = PsbtInfo {
            send_asset: active_swap.send_asset.0.clone(),
            recv_asset: active_swap.recv_asset.0.clone(),
            send_amount: active_swap.send_amount.to_sat(),
            recv_amount: active_swap
                .recv_amount_accepted
                .unwrap_or_default()
                .to_sat(),
        };
        let signed_psbt = sign_psbt(
            &ctx.session.wallet.as_ref().unwrap().read().unwrap(),
            &psbt_info,
            &utxos,
            &psbt,
            ACCOUNT,
        )?;

        send_request!(
            self,
            Swap,
            SwapRequest {
                order_id: active_swap.order_id.clone(),
                action: SwapAction::Sign(signed_psbt),
            }
        )?;
        Ok(())
    }

    fn process_swap_send_sign(&mut self, psbt: String) {
        debug!("send sign");
        if let Err(e) = self.swap_send_sign(psbt) {
            error!("sending sign failed: {}", &e);
        } else {
            debug!("send sign succeed");
        }
    }

    fn swap_failed(&mut self, error: SwapError) {
        let error = match error {
            SwapError::Cancelled => return,
            SwapError::Timeout => "timeout",
            SwapError::ServerError => "server error",
            SwapError::DealerError => "dealer error",
            SwapError::ClientError => "client error",
        };
        self.from_sender
            .send(ffi::proto::from::Msg::SwapFailed(error.to_owned()))
            .unwrap();

        self.cleanup_swaps();
    }

    fn swap_succeed(&mut self, txid: String) {
        let ctx = self.ctx.as_mut().expect("wallet must be set");
        let active_swap = ctx.active_swap.as_ref().expect("must be set");
        for utxo in active_swap.inputs.iter() {
            ctx.used_utxos.insert(get_tx_out(utxo));
        }
        ctx.succeed_swap = Some(txid);
        self.cleanup_swaps();
        // FIXME: Update balances (remove consumed UTXOs)
    }

    fn process_price_update(&mut self, msg: PriceUpdateNotification) {
        let asset = match self.assets.get(&msg.asset) {
            Some(v) => v,
            None => return,
        };
        let price_update = ffi::proto::from::PriceUpdate {
            asset: asset.asset_id.0.clone(),
            bid: msg.price.bid,
            ask: msg.price.ask,
        };
        self.from_sender
            .send(ffi::proto::from::Msg::PriceUpdate(price_update))
            .unwrap();
    }

    fn process_wallet_notif(&mut self, msg: serde_json::Value) {
        let msg = msg.as_object().expect("expected object notification");
        let event = msg
            .get("event")
            .expect("expected event filed")
            .as_str()
            .expect("expected string event");
        match event {
            "transaction" | "block" => self.update_tx_list(),
            "sync_complete" => self.sync_complete(),
            _ => {}
        }
    }

    fn process_pegout_request_local(
        &mut self,
        req: ffi::proto::to::SwapRequest,
    ) -> Result<ffi::proto::from::SwapReview, anyhow::Error> {
        let send_amount = req.send_amount;
        let send_asset = req.send_asset;
        let recv_asset = req.recv_asset;
        ensure!(self.connected, "not connected");
        let blocks = req.blocks.ok_or_else(|| anyhow!("blocks must be set"))?;
        let ctx = self.ctx.as_mut().ok_or(anyhow!("no context found"))?;
        let server_status = self
            .server_status
            .as_ref()
            .ok_or(anyhow!("server_status is not known"))?;
        let conversion_rate = 1. - server_status.server_fee_percent_peg_out / 100.;
        let recv_amount = (send_amount as f64 * conversion_rate).round() as i64;
        ensure!(
            req.send_amount >= server_status.min_peg_out_amount,
            "min {}",
            Amount::from_sat(server_status.min_peg_out_amount)
                .to_bitcoin()
                .to_string()
        );
        ctx.internal_peg = Some(InternalPeg {
            send_amount,
            blocks,
        });
        Ok(ffi::proto::from::SwapReview {
            send_asset,
            recv_asset,
            send_amount,
            recv_amount: Some(recv_amount),
            network_fee: None,
            error: None,
        })
    }

    fn try_process_peg_request_external(&mut self) -> Result<(), anyhow::Error> {
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

        let msg = ffi::proto::from::SwapWaitTx {
            send_asset: self.bitcoin_asset_id.clone(),
            recv_asset: self.liquid_asset_id.clone().0,
            peg_addr: resp.peg_addr,
            recv_addr: recv_addr.clone(),
        };

        self.from_sender
            .send(ffi::proto::from::Msg::SwapWaitTx(msg))
            .unwrap();

        let ctx = self.ctx.as_mut().expect("wallet must be set");
        ctx.active_extern_peg = Some(ActivePeg {
            order_id: resp.order_id,
        });
        Ok(())
    }

    fn process_peg_request_external(&mut self) {
        let result = self.try_process_peg_request_external();
        if let Err(e) = result {
            error!("starting peg failed: {}", e.to_string());
            self.from_sender
                .send(ffi::proto::from::Msg::SwapFailed(e.to_string()))
                .unwrap();
        }
    }

    fn process_swap_request_atomic(
        &mut self,
        req: ffi::proto::to::SwapRequest,
    ) -> Result<ffi::proto::from::SwapReview, anyhow::Error> {
        let send_amount = req.send_amount;
        info!(
            "start swap request: send: {}, recv: {}, amount: {}",
            &req.send_asset, &req.recv_asset, send_amount
        );
        ensure!(self.connected, "not connected");
        let send_asset_id = AssetId(req.send_asset);
        let recv_asset_id = AssetId(req.recv_asset);
        let ctx = self.ctx.as_mut().expect("wallet must be set");
        let send_asset = self.assets.get(&send_asset_id).expect("unknown send asset");
        let recv_asset = self.assets.get(&recv_asset_id).expect("unknown recv asset");

        let mut all_utxos = ctx
            .session
            .get_unspent_outputs(&gdk_common::model::GetUnspentOpt {
                subaccount: ACCOUNT,
                num_confs: Some(BALANCE_NUM_CONFS),
                confidential_utxos_only: None,
                all_coins: None,
            })
            .map_err(|_| anyhow!("getting unspent outputs failed"))?;
        let asset_utxos = all_utxos
            .0
            .remove(&send_asset.asset_id.0)
            .ok_or_else(|| anyhow!("not enough UTXO"))?;
        let mut asset_utxos = asset_utxos
            .into_iter()
            .filter(|v| v.block_height >= BALANCE_NUM_CONFS)
            .filter(|v| ctx.used_utxos.get(&get_tx_out(v)).is_none())
            .collect::<Vec<_>>();

        let utxo_amounts: Vec<_> = asset_utxos.iter().map(|v| v.satoshi as i64).collect();
        let total: i64 = utxo_amounts.iter().sum();
        ensure!(total >= send_amount, "not enough UTXO");

        let selected = types::select_utxo(utxo_amounts, send_amount);
        let selected_amount: i64 = selected.iter().cloned().sum();
        assert!(selected_amount >= send_amount);
        let mut selected_utxos = Vec::new();
        for amount in selected {
            let index = asset_utxos
                .iter()
                .position(|v| v.satoshi as i64 == amount)
                .expect("utxo must exists");
            let utxo = asset_utxos.swap_remove(index);
            selected_utxos.push(utxo);
        }

        let change_amount = selected_amount - send_amount;
        // TODO: Check that change amount is bigger than dust
        let with_change = change_amount != 0;

        let rfq = MatchRfq {
            send_asset: send_asset.asset_id.clone(),
            send_amount,
            recv_asset: recv_asset.asset_id.clone(),
            utxo_count: selected_utxos.len() as i32,
            with_change,
        };

        let rfq_resp = send_request!(self, MatchRfq, MatchRfqRequest { rfq: rfq.clone() });
        let rfq_resp = match rfq_resp {
            Ok(resp) => resp,
            Err(e) => bail!("request failed: {}", e.to_string()),
        };

        let ctx = self.ctx.as_mut().expect("wallet must be set");
        ctx.active_swap = Some(ActiveSwap {
            order_id: rfq_resp.order_id.clone(),
            send_asset: send_asset.asset_id.clone(),
            recv_asset: recv_asset.asset_id.clone(),
            send_amount: Amount::from_sat(send_amount),
            recv_amount_accepted: None,
            inputs: selected_utxos,
            network_fee: None,
        });

        Ok(ffi::proto::from::SwapReview {
            send_asset: send_asset.asset_id.clone().0,
            recv_asset: recv_asset.asset_id.clone().0,
            send_amount: send_amount,
            recv_amount: None,
            network_fee: None,
            error: None,
        })
    }

    fn process_swap_request(&mut self, req: ffi::proto::to::SwapRequest) {
        let result = if req.send_asset == self.liquid_asset_id.0
            && req.recv_asset == self.bitcoin_asset_id
        {
            self.process_pegout_request_local(req.clone())
                .map(|v| ffi::proto::from::Msg::SwapReview(v))
        } else if req.send_asset == self.bitcoin_asset_id
            && req.recv_asset == self.liquid_asset_id.0
        {
            panic!("unexpected swap request");
        } else {
            self.process_swap_request_atomic(req.clone())
                .map(|v| ffi::proto::from::Msg::SwapReview(v))
        };

        let result = result.unwrap_or_else(|e| {
            error!("request failed: {}", e.to_string());
            ffi::proto::from::Msg::SwapReview(ffi::proto::from::SwapReview {
                send_asset: req.send_asset.clone(),
                recv_asset: req.recv_asset.clone(),
                send_amount: req.send_amount,
                recv_amount: None,
                network_fee: None,
                error: Some(e.to_string()),
            })
        });

        self.from_sender.send(result).unwrap();
    }

    fn process_swap_cancel(&mut self) {
        let wallet = self.ctx.as_mut().expect("wallet must be set");
        if let Some(active_swap) = wallet.active_swap.take() {
            let _ = send_request!(
                self,
                MatchRfqCancel,
                MatchCancelRequest {
                    order_id: active_swap.order_id,
                }
            );
        }

        self.cleanup_swaps();
    }

    fn try_process_swap_accept(
        &mut self,
        req: ffi::proto::to::SwapAccept,
    ) -> Result<(), anyhow::Error> {
        info!("process swap accept...");
        let ctx = self.ctx.as_ref().expect("wallet must be set");
        ensure!(self.connected, "not connected");
        if let Some(active_swap) = ctx.active_swap.as_ref() {
            let recv_amount = req.recv_amount.ok_or(anyhow!("nothing to accept"))?;
            send_request!(
                self,
                MatchRfqAccept,
                MatchRfqAcceptRequest {
                    order_id: active_swap.order_id.clone(),
                    recv_amount,
                }
            )
            .map_err(|e| anyhow!("{}", e))?;
            self.ctx
                .as_mut()
                .unwrap()
                .active_swap
                .as_mut()
                .unwrap()
                .recv_amount_accepted = Some(Amount::from_sat(recv_amount));
            return Ok(());
        }

        let internal_peg = self
            .ctx
            .as_mut()
            .expect("wallet must be set")
            .internal_peg
            .take();
        if let Some(data) = internal_peg {
            let device_key = self
                .settings
                .device_key
                .as_ref()
                .expect("device_key must exists")
                .clone();
            let recv_addr = req.recv_addr.unwrap();
            // First output is the target output
            let request = match PegDir::Out {
                PegDir::In => unreachable!("PegDir::Out expected"),
                PegDir::Out => Request::Peg(PegRequest {
                    recv_addr: recv_addr.clone(),
                    send_amount: None,
                    peg_in: false,
                    device_key: Some(device_key),
                    blocks: Some(data.blocks),
                }),
            };
            let is_peg_in = false;
            let resp = self.send_request(request);
            let resp = match resp {
                Ok(Response::Peg(resp)) => resp,
                Ok(_) => bail!("unexpected server response"),
                Err(e) => bail!("server error: {}", e.to_string()),
            };
            let lbtc_asset_id = self
                .tickers
                .get(&Ticker(TICKER_LBTC.to_owned()))
                .expect("unknown ticker");
            let ctx = self.ctx.as_mut().expect("wallet must be set");
            let balance = ctx.last_balances.get(&lbtc_asset_id).unwrap();
            ensure!(balance.to_sat() >= data.send_amount, "not enough UTXO");

            let amount = gdk_common::model::AddressAmount {
                address: resp.peg_addr.clone(),
                satoshi: data.send_amount as u64,
                asset_tag: Some(lbtc_asset_id.0.clone()),
            };
            let send_all = balance.to_sat() == data.send_amount;

            let mut details = gdk_common::model::CreateTransaction {
                addressees: vec![amount],
                fee_rate: None,
                subaccount: ACCOUNT,
                send_all: Some(send_all),
                previous_transaction: HashMap::new(),
                memo: None,
                utxos: None,
                num_confs: None,
                confidential_utxos_only: None,
            };
            let tx_detail_unsigned = ctx
                .session
                .create_transaction(&mut details)
                .map_err(|e| anyhow!("{}", e))?;
            let params = network_type(env_data(self.env).mainnet);
            let tx: elements::Transaction =
                elements::encode::deserialize(&hex::decode(&tx_detail_unsigned.hex)?)?;
            let peg_addr = elements::Address::from_str(&resp.peg_addr)?.to_unconfidential();
            let vout_send = tx
                .output
                .iter()
                .position(|txout| output_address(&txout, params).as_ref() == Some(&peg_addr))
                .ok_or(anyhow!("can't find peg output"))? as i32;
            let send_amount = if send_all {
                data.send_amount - tx_detail_unsigned.fee as i64
            } else {
                data.send_amount
            };
            let server_status = self
                .server_status
                .as_ref()
                .ok_or(anyhow!("server_status is not known"))?;
            ensure!(
                send_amount >= server_status.min_peg_out_amount,
                "min {}",
                Amount::from_sat(server_status.min_peg_out_amount)
                    .to_bitcoin()
                    .to_string()
            );
            let conversion_rate = 1. - server_status.server_fee_percent_peg_out / 100.;
            let recv_amount = (send_amount as f64 * conversion_rate).round() as i64;
            let tx_detail_signed = ctx.session.sign_transaction(&tx_detail_unsigned).unwrap();
            let ctx = self.ctx.as_mut().expect("wallet must be set");
            let send_txid = match ctx.session.send_transaction(&tx_detail_signed) {
                Ok(v) => v,
                Err(e) => bail!("broadcast failed: {}", e.to_string()),
            };
            let order_id = resp.order_id.clone();

            let peg_details = ffi::proto::Peg {
                is_peg_in,
                amount_send: send_amount,
                amount_recv: recv_amount,
                addr_send: resp.peg_addr.clone(),
                addr_recv: recv_addr,
                txid_send: send_txid.clone(),
                vout_send,
                txid_recv: None,
            };
            let id = Data::peg_txitem_id(&send_txid, vout_send);
            let swap_succeed = ffi::proto::TransItem {
                id,
                created_at: timestamp_now(),
                confs: Some(ffi::proto::Confs {
                    count: 0,
                    total: TX_CONF_COUNT,
                }),
                item: Some(ffi::proto::trans_item::Item::Peg(peg_details)),
            };
            self.from_sender
                .send(ffi::proto::from::Msg::SwapSucceed(swap_succeed))
                .unwrap();

            self.cleanup_swaps();

            self.add_peg_monitoring(order_id, PegDir::Out);

            return Ok(());
        }

        bail!("nothing to accept");
    }

    fn process_swap_accept(&mut self, req: ffi::proto::to::SwapAccept) {
        let result = self.try_process_swap_accept(req);
        if let Err(e) = result {
            error!("accepting swap failed: {}", e.to_string());
            self.from_sender
                .send(ffi::proto::from::Msg::SwapFailed(e.to_string()))
                .unwrap();
            self.process_swap_cancel();
        }
    }

    fn process_get_recv_address(&mut self) {
        let wallet = self.ctx.as_mut().expect("wallet must be set");
        let addr = wallet
            .session
            .get_receive_address(&gdk_common::model::GetAddressOpt {
                subaccount: ACCOUNT,
                address_type: None,
            })
            .expect("can't get new address")
            .address;
        let addr = ffi::proto::Address { addr };
        self.from_sender
            .send(ffi::proto::from::Msg::RecvAddress(addr))
            .unwrap();
    }

    fn create_tx(&mut self, req: ffi::proto::to::CreateTx) -> Result<i64, anyhow::Error> {
        let ctx = self.ctx.as_mut().expect("wallet must be set");
        let send_asset = AssetId(req.balance.asset_id);
        let send_amount = req.balance.amount;
        let amount = gdk_common::model::AddressAmount {
            address: req.addr,
            satoshi: req.balance.amount as u64,
            asset_tag: Some(send_asset.0.clone()),
        };
        let balance = ctx
            .last_balances
            .get(&send_asset)
            .ok_or(anyhow!("unknown asset: {}", send_asset.0))?;
        ensure!(send_amount > 0, "invalid send amount");
        ensure!(balance.to_sat() >= send_amount, "not enough UTXO");
        let send_all = balance.to_sat() == send_amount;
        let send_all_opt = if send_all { Some(true) } else { None };
        let mut details = gdk_common::model::CreateTransaction {
            addressees: vec![amount],
            fee_rate: None,
            subaccount: ACCOUNT,
            send_all: send_all_opt,
            previous_transaction: HashMap::new(),
            memo: None,
            utxos: None,
            num_confs: None,
            confidential_utxos_only: None,
        };
        let tx_detail_unsigned = ctx
            .session
            .create_transaction(&mut details)
            .map_err(|e| anyhow!("{}", e))?;
        let network_fee = tx_detail_unsigned.fee as i64;
        ctx.send_tx = Some(SendTx {
            tx: tx_detail_unsigned,
            send_all,
            asset_id: send_asset.clone(),
            amount: send_amount,
        });
        Ok(network_fee)
    }

    fn send_tx(
        &mut self,
        req: ffi::proto::to::SendTx,
    ) -> Result<ffi::proto::TransItem, anyhow::Error> {
        let ctx = self.ctx.as_mut().expect("wallet must be set");
        let send_tx = ctx.send_tx.take().ok_or(anyhow!("no transaction found"))?;
        let tx_detail_unsigned = send_tx.tx;
        let network_fee = tx_detail_unsigned.fee as i64;
        let tx_detail_signed = ctx
            .session
            .sign_transaction(&tx_detail_unsigned)
            .map_err(|e| anyhow!("transaction sign failed: {}", e.to_string()))?;
        let txid = ctx
            .session
            .send_transaction(&tx_detail_signed)
            .map_err(|e| anyhow!("send failed: {}", e.to_string()))?;
        if let Err(e) = ctx.session.set_transaction_memo(&txid, &req.memo) {
            error!("setting memo failed: {}", e);
        }

        let lbtc_asset = self
            .assets
            .iter()
            .find(|(_, asset)| asset.ticker.0 == TICKER_LBTC)
            .expect("L-BTC asset must be know")
            .1
            .asset_id
            .clone();
        let wallet = ctx
            .session
            .wallet
            .as_ref()
            .expect("wallet must be set")
            .read()
            .unwrap();
        let store_read = wallet.store.read().expect("store must be set");
        let be_tx =
            gdk_common::be::BETransaction::from_hex(&tx_detail_signed.hex, wallet.network.id())
                .expect("tx decode failed");
        let is_redeposit = be_tx.is_redeposit(
            &store_read.cache.accounts.get(&ACCOUNT).unwrap().paths,
            &store_read.cache.accounts.get(&ACCOUNT).unwrap().all_txs,
        );

        let mut balances = Vec::new();
        if is_redeposit {
            balances.push(ffi::proto::Balance {
                asset_id: lbtc_asset.0.to_owned(),
                amount: -network_fee,
            });
        } else if send_tx.asset_id != lbtc_asset {
            balances.push(ffi::proto::Balance {
                asset_id: send_tx.asset_id.0.clone(),
                amount: -send_tx.amount,
            });
            balances.push(ffi::proto::Balance {
                asset_id: lbtc_asset.0.clone(),
                amount: -network_fee,
            });
        } else if send_tx.send_all {
            balances.push(ffi::proto::Balance {
                asset_id: lbtc_asset.0.clone(),
                amount: -send_tx.amount,
            });
        } else {
            balances.push(ffi::proto::Balance {
                asset_id: lbtc_asset.0.clone(),
                amount: -send_tx.amount - network_fee,
            });
        }

        let tx_details = ffi::proto::Tx {
            balances,
            memo: req.memo.clone(),
            network_fee,
            txid: txid.clone(),
        };

        let confs = Some(ffi::proto::Confs {
            count: 0,
            total: TX_CONF_COUNT,
        });

        let tx_item = ffi::proto::TransItem {
            id: txid.clone(),
            created_at: timestamp_now(),
            confs,
            item: Some(ffi::proto::trans_item::Item::Tx(tx_details)),
        };

        Ok(tx_item)
    }

    fn process_create_tx(&mut self, req: ffi::proto::to::CreateTx) {
        let result = match self.create_tx(req) {
            Ok(network_fee) => ffi::proto::from::create_tx_result::Result::NetworkFee(network_fee),
            Err(e) => ffi::proto::from::create_tx_result::Result::ErrorMsg(e.to_string()),
        };
        let send_result = ffi::proto::from::CreateTxResult {
            result: Some(result),
        };
        self.from_sender
            .send(ffi::proto::from::Msg::CreateTxResult(send_result))
            .unwrap();
    }

    fn process_send_tx(&mut self, req: ffi::proto::to::SendTx) {
        let result = match self.send_tx(req) {
            Ok(tx_item) => ffi::proto::from::send_result::Result::TxItem(tx_item),
            Err(e) => ffi::proto::from::send_result::Result::ErrorMsg(e.to_string()),
        };
        let send_result = ffi::proto::from::SendResult {
            result: Some(result),
        };
        self.from_sender
            .send(ffi::proto::from::Msg::SendResult(send_result))
            .unwrap();
    }

    fn process_blinded_values(&self, req: ffi::proto::to::BlindedValues) {
        let blinded_values = self.get_blinded_values(&req.txid).ok();
        let blinded_values = ffi::proto::from::BlindedValues {
            txid: req.txid,
            blinded_values,
        };
        self.from_sender
            .send(ffi::proto::from::Msg::BlindedValues(blinded_values))
            .unwrap();
    }

    // logins

    fn process_login_request(&mut self, req: ffi::proto::to::Login) {
        debug!("process login request...");

        let electrum_env = match self.env {
            Env::Prod | Env::Staging => sideswap_libwally::Env::Prod,
            Env::Local => sideswap_libwally::Env::Local,
            Env::Regtest => sideswap_libwally::Env::Regtest,
        };
        let parsed_network = get_network(electrum_env);

        let url = gdk_electrum::determine_electrum_url_from_net(&parsed_network).unwrap();

        let cache_path = self.cache_path();
        let cache_path = cache_path.to_str().expect("invalid data path");

        let mut session =
            ElectrumSession::new_session(parsed_network, &cache_path, None, url).unwrap();

        session.notify = NativeNotif(Some((
            notification_callback,
            self.notif_context as *const libc::c_void,
        )));

        session.connect(&serde_json::Value::Null).unwrap();

        let mnemonic = gdk_common::mnemonic::Mnemonic::from(req.mnemonic.to_owned());

        session.login(&mnemonic, None).unwrap();

        let ctx = Context {
            psbt: None,
            psbt_utxos: None,
            session,
            sent_txs: BTreeMap::new(),
            pegs: BTreeMap::new(),
            txs: Vec::new(),
            last_balances: BTreeMap::new(),
            used_utxos: BTreeSet::new(),
            send_tx: None,
            active_swap: None,
            internal_peg: None,
            active_extern_peg: None,
            active_submit: None,
            active_sign: None,
            succeed_swap: None,
            sync_complete: false,
            wallet_loaded_sent: false,
        };

        self.ctx = Some(ctx);

        if self.skip_wallet_sync() {
            info!("skip wallet sync delay");
            self.send_wallet_loaded();
        }

        self.process_pending_requests();
        self.update_tx_list();
        self.resume_peg_monitoring();
        self.update_address_registrations();
    }

    fn restart_websocket(&mut self) {
        self.connected = false;
        self.ws_sender.send(ws::WrappedRequest::Restart).unwrap();
    }

    fn process_logout_request(&mut self) {
        debug!("process logout request...");
        self.ctx = None;
        self.settings = settings::Settings::default();
        self.restart_websocket();
        self.save_settings();
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
        self.from_sender
            .send(ffi::proto::from::Msg::EncryptPin(
                ffi::proto::from::EncryptPin {
                    result: Some(result),
                },
            ))
            .unwrap();
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
        self.from_sender
            .send(ffi::proto::from::Msg::DecryptPin(
                ffi::proto::from::DecryptPin {
                    result: Some(result),
                },
            ))
            .unwrap();
    }

    fn process_peg_status(&mut self, status: PegStatus) {
        let ctx = match self.ctx.as_mut() {
            Some(v) => v,
            None => return,
        };

        ctx.pegs.insert(status.order_id.clone(), status.clone());
        self.sync_tx_list();

        let ctx = self.ctx.as_mut().unwrap();
        let active_peg = match ctx.active_extern_peg.as_ref() {
            Some(v) => v,
            None => return,
        };
        let first_peg_tx = match status.list.first() {
            Some(v) => v,
            None => return,
        };
        if active_peg.order_id != status.order_id {
            return;
        }

        let peg_item = self.get_peg_item(&status, first_peg_tx);
        self.from_sender
            .send(ffi::proto::from::Msg::SwapSucceed(peg_item))
            .unwrap();

        self.cleanup_swaps();
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

    fn process_register_phone(&mut self, req: ffi::proto::to::RegisterPhone) {
        let register_req = RegisterPhoneRequest { number: req.number };
        let resp = send_request!(self, RegisterPhone, register_req);
        let result = match resp {
            Ok(v) => ffi::proto::from::register_phone::Result::PhoneKey(v.phone_key.0),
            Err(e) => ffi::proto::from::register_phone::Result::ErrorMsg(e.to_string()),
        };
        let from = ffi::proto::from::RegisterPhone {
            result: Some(result),
        };
        self.from_sender
            .send(ffi::proto::from::Msg::RegisterPhone(from))
            .unwrap();
    }

    fn process_verify_phone(&mut self, req: ffi::proto::to::VerifyPhone) {
        let verify_req = VerifyPhoneRequest {
            phone_key: PhoneKey(req.phone_key),
            code: req.code,
        };
        let resp = send_request!(self, VerifyPhone, verify_req);
        let result = match resp {
            Ok(_) => ffi::proto::from::verify_phone::Result::Success(ffi::proto::Empty {}),
            Err(e) => ffi::proto::from::verify_phone::Result::ErrorMsg(e.to_string()),
        };
        let from = ffi::proto::from::VerifyPhone {
            result: Some(result),
        };
        self.from_sender
            .send(ffi::proto::from::Msg::VerifyPhone(from))
            .unwrap();
    }

    fn process_upload_avatar(&mut self, _req: ffi::proto::to::UploadAvatar) {
        let result = ffi::proto::GenericResponse {
            success: true,
            error_msg: None,
        };
        self.from_sender
            .send(ffi::proto::from::Msg::UploadAvatar(result))
            .unwrap();
    }

    fn process_upload_contacts(&mut self, _req: ffi::proto::to::UploadContacts) {
        let result = ffi::proto::GenericResponse {
            success: true,
            error_msg: None,
        };
        self.from_sender
            .send(ffi::proto::from::Msg::UploadContacts(result))
            .unwrap();
    }

    fn try_process_submit_order(
        &mut self,
        req: ffi::proto::to::SubmitOrder,
    ) -> Result<(), anyhow::Error> {
        let order = PriceOrder {
            asset: AssetId(req.asset_id),
            bitcoin_amount: req.bitcoin_amount,
            price: Some(req.price),
            index_price: req.index_price,
        };
        let submit_req = SubmitRequest {
            order,
            session_id: Some(req.session_id),
        };
        let resp = send_request!(self, Submit, submit_req)?;

        self.mobile_submits.insert(resp.order_id.clone());
        self.try_process_link_order(resp.order_id)
    }

    fn try_process_link_order(&mut self, order_id: OrderId) -> Result<(), anyhow::Error> {
        let link_req = LinkRequest {
            order_id: order_id.clone(),
        };
        let resp = send_request!(self, Link, link_req)?;
        let details = &resp.details;

        let ctx = self.ctx.as_ref().ok_or(anyhow!("no context found"))?;
        let (send_amount, send_asset) = if details.send_bitcoins {
            (
                details.bitcoin_amount + details.server_fee,
                &self.liquid_asset_id,
            )
        } else {
            (details.asset_amount, &details.asset)
        };
        let available_balance = ctx
            .last_balances
            .get(send_asset)
            .cloned()
            .unwrap_or_default();
        ensure!(
            available_balance.to_sat() >= send_amount,
            "Insufficient funds"
        );

        let step = if details.side == OrderSide::Requestor {
            ffi::proto::from::submit_review::Step::Submit
        } else {
            ffi::proto::from::submit_review::Step::Quote
        };
        let submit_review = ffi::proto::from::SubmitReview {
            order_id: order_id.0.clone(),
            asset: details.asset.0.clone(),
            bitcoin_amount: details.bitcoin_amount,
            asset_amount: details.asset_amount,
            price: details.price,
            sell_bitcoin: details.send_bitcoins,
            server_fee: details.server_fee,
            step: step as i32,
            index_price: resp.index_price,
        };
        self.from_sender
            .send(ffi::proto::from::Msg::SubmitReview(submit_review))
            .unwrap();
        self.visible_submit = Some(order_id.clone());
        let ctx = self.ctx.as_mut().ok_or(anyhow!("no context found"))?;
        ctx.active_submit = Some(resp);
        Ok(())
    }

    fn process_submit_order(&mut self, req: ffi::proto::to::SubmitOrder) {
        // Fix problem with iOS when app is resumed from background
        self.restart_websocket();
        self.pending_submits.push(req);
        self.process_pending_requests();
    }

    fn process_link_order(&mut self, req: ffi::proto::to::LinkOrder) {
        self.pending_links.push(req);
        self.process_pending_requests();
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
            .map(|sign| sign.order_id.0 == req.order_id)
            .unwrap_or(false);
        if is_sign {
            let sign_msg = ctx.active_sign.take().unwrap();
            return self.try_sign(sign_msg);
        }
        let resp = ctx.active_submit.take().ok_or(anyhow!("data not found"))?;
        let index_price = resp.index_price;
        let details = resp.details;
        let side = details.side;
        let order_id = OrderId(req.order_id);
        let bitcoin_amount = Amount::from_sat(details.bitcoin_amount);
        let asset = self
            .assets
            .get(&details.asset)
            .ok_or(anyhow!("unknown asset"))?;
        ensure!(asset.asset_id.0 != self.bitcoin_asset_id);
        ensure!(details.price > 0.0);
        ensure!(details.bitcoin_amount > 0);
        ensure!(details.server_fee > 0);
        ensure!(details.server_fee < details.bitcoin_amount);
        let expected_asset_amount =
            types::asset_amount(bitcoin_amount.to_sat(), details.price, asset.precision);
        ensure!(expected_asset_amount == details.asset_amount);
        let asset_amount = Amount::from_sat(details.asset_amount);
        let bitcoin_asset = self.liquid_asset_id.clone();
        let (send_asset, send_amount, recv_asset) = if details.send_bitcoins {
            (
                bitcoin_asset,
                details.bitcoin_amount + details.server_fee,
                details.asset.clone(),
            )
        } else {
            (details.asset.clone(), asset_amount.to_sat(), bitcoin_asset)
        };

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
            .remove(&send_asset.0)
            .ok_or_else(|| anyhow!("Insufficient funds"))?;
        let reserved_txouts = self
            .submit_data
            .values()
            .flat_map(|item| item.txouts.iter())
            .collect::<BTreeSet<_>>();
        let filtered_utxos = all_asset_utxos
            .iter()
            .filter(|utxo| reserved_txouts.get(&get_tx_out(utxo)).is_none())
            .cloned()
            .collect::<Vec<_>>();
        let filtered_amount = filtered_utxos.iter().map(|utxo| utxo.satoshi).sum::<u64>() as i64;
        let mut asset_utxos = if filtered_amount >= send_amount {
            filtered_utxos
        } else {
            all_asset_utxos
        };

        let utxo_amounts: Vec<_> = asset_utxos.iter().map(|v| v.satoshi as i64).collect();
        let total: i64 = utxo_amounts.iter().sum();
        ensure!(total >= send_amount, "Insufficient funds");

        let selected = types::select_utxo(utxo_amounts, send_amount);
        let selected_amount: i64 = selected.iter().cloned().sum();
        assert!(selected_amount >= send_amount);
        let mut selected_utxos = Vec::new();
        for amount in selected {
            let index = asset_utxos
                .iter()
                .position(|v| v.satoshi as i64 == amount)
                .expect("utxo must exists");
            let utxo = asset_utxos.swap_remove(index);
            selected_utxos.push(utxo);
        }

        let psbt_info = PsbtInfo {
            send_asset: send_asset.0.clone(),
            recv_asset: recv_asset.0,
            recv_amount: 0,
            send_amount: selected_amount,
        };
        let pset = generate_psbt(
            &ctx.session.wallet.as_ref().unwrap().read().unwrap(),
            &psbt_info,
            &selected_utxos,
            ACCOUNT,
        )?;

        let txouts = selected_utxos
            .iter()
            .map(get_tx_out)
            .collect::<BTreeSet<_>>();

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

        let addr_req = AddrRequest {
            order_id: order_id.clone(),
            pset,
            recv_addr,
            change_addr,
            price: details.price,
        };
        send_request!(self, Addr, addr_req)?;

        let bitcoin_amount = Amount::from_sat(details.bitcoin_amount);
        let sell_bitcoin = details.send_bitcoins;
        let price = details.price;
        let server_fee = Amount::from_sat(details.server_fee);
        let auto_sign = req.auto_sign.unwrap_or(false) && side == OrderSide::Requestor;

        let submit_data = SubmitData {
            order_id: order_id.clone(),
            side,
            asset: details.asset,
            bitcoin_amount,
            asset_amount,
            server_fee,
            price,
            sell_bitcoin,
            txouts,
            asset_precision: asset.precision,
            auto_sign,
            txid: None,
            index_price,
        };
        self.submit_data
            .insert(submit_data.order_id.clone(), submit_data);
        let done = side == OrderSide::Requestor;

        let stored_utxo = settings::StoredUtxo {
            utxos: selected_utxos,
            created_at: std::time::SystemTime::now(),
        };
        if side == OrderSide::Requestor {
            self.settings
                .utxos_req
                .get_or_insert_with(|| BTreeMap::new())
                .insert(order_id, stored_utxo);
            self.save_settings();
        } else {
            self.utxos_resp.insert(order_id, stored_utxo);
        }

        Ok(done)
    }

    fn process_submit_decision(&mut self, req: ffi::proto::to::SubmitDecision) {
        let order_id = OrderId(req.order_id.clone());
        let minimize_app = self.mobile_submits.remove(&order_id);
        let result = self.try_process_submit_decision(req);
        let result = match result {
            Ok(true) => {
                ffi::proto::from::submit_result::Result::SubmitSucceed(ffi::proto::Empty {})
            }
            Ok(false) => {
                // TODO: Add timer
                return;
            }
            Err(e) => {
                error!("submit failed: {}", e);
                ffi::proto::from::submit_result::Result::Error(e.to_string())
            }
        };
        let from = ffi::proto::from::SubmitResult {
            result: Some(result),
            minimize_app,
        };
        self.from_sender
            .send(ffi::proto::from::Msg::SubmitResult(from))
            .unwrap();
        self.visible_submit = None;
        self.process_pending_sign_requests();
    }

    fn try_sign(&mut self, msg: SignNotification) -> Result<bool, anyhow::Error> {
        let ctx = self.ctx.as_ref().ok_or_else(|| anyhow!("no wallet"))?;
        let submit_data = self
            .submit_data
            .get(&msg.order_id)
            .ok_or_else(|| anyhow!("no keys found"))?;
        ensure!(submit_data.order_id == msg.order_id, "unexpected order_id");
        let pset = msg.pset;
        let psbt_info = if submit_data.sell_bitcoin {
            PsbtInfo {
                send_asset: self.liquid_asset_id.clone().0,
                recv_asset: submit_data.asset.clone().0,
                send_amount: (submit_data.bitcoin_amount + submit_data.server_fee).to_sat(),
                recv_amount: submit_data.asset_amount.to_sat(),
            }
        } else {
            PsbtInfo {
                send_asset: submit_data.asset.clone().0,
                recv_asset: self.liquid_asset_id.clone().0,
                send_amount: submit_data.asset_amount.to_sat(),
                recv_amount: (submit_data.bitcoin_amount - submit_data.server_fee).to_sat(),
            }
        };

        let utxos = if msg.details.side == OrderSide::Requestor {
            let utxos = self
                .settings
                .utxos_req
                .get_or_insert_with(|| BTreeMap::new())
                .remove(&msg.order_id);
            self.save_settings();
            utxos
        } else {
            self.utxos_resp.remove(&msg.order_id)
        };
        let utxos = utxos.ok_or_else(|| anyhow!("not utxos found"))?;

        let signed_pset = sign_psbt(
            &ctx.session.wallet.as_ref().unwrap().read().unwrap(),
            &psbt_info,
            &utxos.utxos,
            &pset,
            ACCOUNT,
        )?;
        send_request!(
            self,
            Sign,
            SignRequest {
                order_id: msg.order_id.clone(),
                signed_pset,
                side: submit_data.side,
            }
        )?;
        //self.show_message("sign succeed");
        Ok(false)
    }

    fn try_process_sign(&mut self, msg: SignNotification) -> Result<(), anyhow::Error> {
        self.processed_signs.insert(msg.order_id.clone());
        let order_id = msg.order_id.clone();
        let ctx = self.ctx.as_mut().ok_or_else(|| anyhow!("no wallet"))?;
        let submit_data = self
            .submit_data
            .get_mut(&msg.order_id)
            .ok_or_else(|| anyhow!("no keys found"))?;
        ensure!(order_id == submit_data.order_id);
        let price_change = f64::abs(msg.details.price - submit_data.price) / submit_data.price;
        ensure!(submit_data.sell_bitcoin == msg.details.send_bitcoins);
        ensure!(submit_data.asset == msg.details.asset);
        ensure!(submit_data.bitcoin_amount.to_sat() == msg.details.bitcoin_amount);
        ensure!(submit_data.server_fee.to_sat() == msg.details.server_fee);
        ensure!(submit_data.side == msg.details.side);
        ensure!(msg.details.price > 0.0);
        ensure!(msg.details.asset_amount > 0);
        ensure!(price_change == 0.0 || submit_data.side != OrderSide::Responder);
        let expected_asset_amount = types::asset_amount(
            submit_data.bitcoin_amount.to_sat(),
            msg.details.price,
            submit_data.asset_precision,
        );
        ensure!(expected_asset_amount == msg.details.asset_amount);
        submit_data.price = msg.details.price;
        submit_data.asset_amount = Amount::from_sat(msg.details.asset_amount);
        // Maker: Auto-sign is only allowed if price do not change (or change within 10% for price tracking orders).
        // Taker: Auto-sign is always used because price was already reviewed earlier (and can't change since that).
        let allowed_price_change = if submit_data.index_price {
            AUTO_SIGN_ALLOWED_INDEX_PRICE_CHANGE
        } else {
            0.0
        };
        let auto_sign_allowed = submit_data.side == OrderSide::Responder
            || (submit_data.side == OrderSide::Requestor
                && submit_data.auto_sign
                && price_change <= allowed_price_change);
        if !auto_sign_allowed {
            let step = ffi::proto::from::submit_review::Step::Sign;
            let submit_review = ffi::proto::from::SubmitReview {
                order_id: order_id.0.clone(),
                asset: submit_data.asset.clone().0,
                bitcoin_amount: submit_data.bitcoin_amount.to_sat(),
                asset_amount: submit_data.asset_amount.to_sat(),
                price: submit_data.price,
                server_fee: submit_data.server_fee.to_sat(),
                sell_bitcoin: submit_data.sell_bitcoin,
                step: step as i32,
                index_price: false,
            };
            self.from_sender
                .send(ffi::proto::from::Msg::SubmitReview(submit_review))
                .unwrap();
            self.visible_submit = Some(order_id.clone());
            ctx.active_sign = Some(msg);
        } else {
            // Show swap tx after auto-sign
            if self.visible_submit.is_none() && submit_data.side == OrderSide::Requestor {
                self.visible_submit = Some(msg.order_id.clone());
            }
            self.try_sign(msg)?;
        }
        Ok(())
    }

    fn process_sign(&mut self, msg: SignNotification) {
        if msg.details.side == OrderSide::Responder {
            let result = self.try_process_sign(msg);
            if let Err(e) = result {
                self.show_message(&format!("sign failed: {}", e.to_string()));
            }
            return;
        }

        self.pending_sign_requests.push_back(msg);
        self.process_pending_sign_requests();
    }

    fn process_pending_sign_requests(&mut self) {
        loop {
            if self.visible_submit.is_some() {
                return;
            }
            let msg = self.pending_sign_requests.pop_front();
            let msg = match msg {
                Some(v) => v,
                None => return,
            };
            if self.processed_signs.get(&msg.order_id).is_some() {
                continue;
            }
            let result = self.try_process_sign(msg);
            if let Err(e) = result {
                self.show_message(&format!("sign failed: {}", e.to_string()));
            }
        }
    }

    fn process_complete(&mut self, msg: CompleteNotification) {
        match msg.txid {
            Some(v) => {
                let submit_data = match self.submit_data.get_mut(&msg.order_id) {
                    Some(v) => v,
                    None => return,
                };
                submit_data.txid = Some(v)
            }
            None => {
                if self.visible_submit.as_ref() == Some(&msg.order_id) {
                    self.from_sender
                        .send(ffi::proto::from::Msg::SubmitResult(
                            ffi::proto::from::SubmitResult {
                                result: Some(ffi::proto::from::submit_result::Result::Error(
                                    "Order has been cancelled".to_owned(),
                                )),
                                minimize_app: false,
                            },
                        ))
                        .unwrap();
                    self.visible_submit = None;
                    self.process_pending_sign_requests();
                }
                self.submit_data.remove(&msg.order_id);
            }
        }
    }

    // message processing

    fn send_request(&self, request: Request) -> Result<Response, anyhow::Error> {
        let active_request_id = ws::next_request_id();
        self.ws_sender
            .send(ws::WrappedRequest::Request(RequestMessage::Request(
                active_request_id.clone(),
                request,
            )))
            .unwrap();

        let started = std::time::Instant::now();
        loop {
            let resp = self.resp_receiver.recv_timeout(SERVER_REQUEST_POLL_PERIOD);
            match resp {
                Ok(ServerResp(Some(request_id), result)) => {
                    if request_id != active_request_id {
                        warn!("discard old response");
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
        self.from_sender
            .send(ffi::proto::from::Msg::ShowMessage(msg))
            .unwrap();
    }

    fn process_push_message(&mut self, req: String) {
        let msg = match serde_json::from_str::<FcmMessage>(&req) {
            Ok(v) => v,
            Err(e) => {
                error!("parsing FCM message failed: {}", e);
                return;
            }
        };
        match msg {
            FcmMessage::Sign(data) => {
                info!("sign request received, order_id: {}", data.order_id);
                self.pending_signs.insert(data.order_id);
                self.process_pending_requests();
            }
            _ => {}
        }
    }

    fn download_sign_request(&mut self, order_id: OrderId) -> Result<(), anyhow::Error> {
        let sign = send_request!(
            self,
            GetSign,
            GetSignRequest {
                order_id: order_id.clone()
            }
        )?;

        if self.submit_data.get(&order_id).is_none() {
            let asset = self
                .assets
                .get(&sign.data.details.asset)
                .ok_or(anyhow!("unknown asset"))?;
            ensure!(asset.asset_id.0 != self.bitcoin_asset_id);
            ensure!(sign.data.details.price > 0.0);
            ensure!(sign.data.details.bitcoin_amount > 0);
            ensure!(sign.data.details.server_fee > 0);
            ensure!(sign.data.details.server_fee < sign.data.details.bitcoin_amount);
            let expected_asset_amount = types::asset_amount(
                sign.data.details.bitcoin_amount,
                sign.data.details.price,
                asset.precision,
            );
            ensure!(expected_asset_amount == sign.data.details.asset_amount);
            let asset_amount = Amount::from_sat(sign.data.details.asset_amount);
            let bitcoin_amount = Amount::from_sat(sign.data.details.bitcoin_amount);
            let sell_bitcoin = sign.data.details.send_bitcoins;
            let price = sign.data.details.price;
            let server_fee = Amount::from_sat(sign.data.details.server_fee);

            let submit_data = SubmitData {
                order_id,
                side: OrderSide::Requestor,
                asset: sign.data.details.asset.clone(),
                bitcoin_amount,
                asset_amount,
                server_fee,
                price,
                sell_bitcoin,
                txouts: BTreeSet::new(),
                asset_precision: asset.precision,
                auto_sign: false,
                txid: None,
                index_price: false,
            };
            self.submit_data
                .insert(submit_data.order_id.clone(), submit_data);
        }

        self.process_sign(sign.data);

        Ok(())
    }

    fn skip_wallet_sync(&self) -> bool {
        self.pending_submits.is_empty() && self.pending_links.is_empty()
    }

    fn process_pending_requests(&mut self) {
        debug!(
            "process pending requests, signs: {}, submits: {}, links: {}, connected: {}",
            self.pending_signs.len(),
            self.pending_submits.len(),
            self.pending_links.len(),
            self.connected,
        );
        if !self.connected {
            return;
        }
        let ctx = match self.ctx.as_ref() {
            Some(v) => v,
            None => return,
        };
        let sync_complete = ctx.sync_complete;

        let pending_signs = std::mem::replace(&mut self.pending_signs, BTreeSet::new());
        for order_id in pending_signs.into_iter() {
            if self.processed_signs.get(&order_id).is_none() {
                let result = self.download_sign_request(order_id);
                if let Err(e) = result {
                    self.show_message(&format!("sign failed: {}", e));
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
                self.from_sender
                    .send(ffi::proto::from::Msg::SubmitResult(
                        ffi::proto::from::SubmitResult {
                            result: Some(ffi::proto::from::submit_result::Result::Error(
                                e.to_string(),
                            )),
                            minimize_app: true,
                        },
                    ))
                    .unwrap();
            }
        }

        let pending_links = std::mem::replace(&mut self.pending_links, Vec::new());
        for req in pending_links.into_iter() {
            let result = self.try_process_link_order(OrderId(req.order_id));
            if let Err(e) = result {
                self.show_message(&e.to_string());
            }
        }
    }

    fn process_ui(&mut self, msg: ffi::ToMsg) {
        match msg {
            ffi::proto::to::Msg::Login(req) => self.process_login_request(req),
            ffi::proto::to::Msg::Logout(_) => self.process_logout_request(),
            ffi::proto::to::Msg::EncryptPin(req) => self.process_encrypt_pin(req),
            ffi::proto::to::Msg::DecryptPin(req) => self.process_decrypt_pin(req),
            ffi::proto::to::Msg::PushMessage(req) => self.process_push_message(req),
            ffi::proto::to::Msg::PegRequest(_) => self.process_peg_request_external(),
            ffi::proto::to::Msg::SwapRequest(req) => self.process_swap_request(req),
            ffi::proto::to::Msg::SwapCancel(_) => self.process_swap_cancel(),
            ffi::proto::to::Msg::SwapAccept(req) => self.process_swap_accept(req),
            ffi::proto::to::Msg::GetRecvAddress(_) => self.process_get_recv_address(),
            ffi::proto::to::Msg::CreateTx(req) => self.process_create_tx(req),
            ffi::proto::to::Msg::SendTx(req) => self.process_send_tx(req),
            ffi::proto::to::Msg::BlindedValues(req) => self.process_blinded_values(req),
            ffi::proto::to::Msg::SetMemo(req) => self.process_set_memo(req),
            ffi::proto::to::Msg::UpdatePushToken(req) => self.process_update_push_token(req),
            ffi::proto::to::Msg::RegisterPhone(req) => self.process_register_phone(req),
            ffi::proto::to::Msg::VerifyPhone(req) => self.process_verify_phone(req),
            ffi::proto::to::Msg::UploadAvatar(req) => self.process_upload_avatar(req),
            ffi::proto::to::Msg::UploadContacts(req) => self.process_upload_contacts(req),
            ffi::proto::to::Msg::SubmitOrder(req) => self.process_submit_order(req),
            ffi::proto::to::Msg::LinkOrder(req) => self.process_link_order(req),
            ffi::proto::to::Msg::SubmitDecision(req) => self.process_submit_decision(req),
        }
    }

    fn process_ws_notification(&mut self, notification: Notification) {
        match notification {
            Notification::PegStatus(status) => self.process_peg_status(status),
            Notification::ServerStatus(resp) => self.process_server_status(resp),
            Notification::MatchRfq(status) => self.process_rfq_update(status),
            Notification::Swap(msg) => self.process_swap_notification(msg),
            Notification::PriceUpdate(msg) => self.process_price_update(msg),
            Notification::Sign(msg) => self.process_sign(msg),
            Notification::Complete(msg) => self.process_complete(msg),
            _ => {}
        }
    }

    pub fn register_asset(&mut self, asset: Asset) {
        let asset_id = asset.asset_id.clone();
        let asset_copy = ffi::proto::Asset {
            asset_id: asset.asset_id.0.clone(),
            name: asset.name.clone(),
            ticker: asset.ticker.0.clone(),
            icon: asset
                .icon
                .as_ref()
                .expect("asset icon must be embedded")
                .clone(),
            precision: asset.precision as u32,
        };

        self.assets.insert(asset_id.clone(), asset.clone());
        self.tickers.insert(asset.ticker.clone(), asset_id);

        self.from_sender
            .send(ffi::proto::from::Msg::NewAsset(asset_copy))
            .unwrap();
    }

    pub fn register_assets(&mut self, assets: Assets) {
        types::check_assets(self.env, &assets);
        for asset in assets {
            self.register_asset(asset);
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
        self.register_assets(assets);
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
        let active_request_id = ws::next_request_id();
        self.ws_sender
            .send(ws::WrappedRequest::Request(RequestMessage::Request(
                active_request_id.clone(),
                request,
            )))
            .unwrap();
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
        addr.to_unconfidential().to_string()
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
                let external_count = new_external - last_external;
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
                    ));
                }
                for pointer in last_internal..new_internal {
                    addresses.push(Data::get_address(
                        &wallet.read().unwrap(),
                        AddrType::Internal,
                        pointer,
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

    fn save_settings(&self) {
        let result = settings::save_settings(&self.settings, &self.get_data_path());
        if let Err(e) = result {
            error!("saving settings failed: {}", e);
        }
    }
}

pub fn start_processing(
    env: Env,
    to_receiver: Receiver<ffi::ToMsg>,
    from_sender: Sender<ffi::FromMsg>,
    params: ffi::StartParams,
) {
    let env_data = types::env_data(env);
    let (msg_sender, msg_receiver) = std::sync::mpsc::channel::<Message>();
    let (resp_sender, resp_receiver) = std::sync::mpsc::channel::<ServerResp>();
    let (ws_sender, ws_receiver) =
        ws::start(env_data.host.to_owned(), env_data.port, env_data.use_tls);

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
                ws::WrappedResponse::Response(ResponseMessage::Response(
                    _,
                    Ok(Response::PegStatus(msg)),
                )) => msg_sender_copy.send(Message::PegStatus(msg)).unwrap(),
                ws::WrappedResponse::Response(ResponseMessage::Response(req_id, result)) => {
                    resp_sender.send(ServerResp(req_id, result)).unwrap();
                }
            }
        }
    });

    let msg_sender_copy = msg_sender.clone();
    std::thread::spawn(move || {
        while let Ok(msg) = to_receiver.recv() {
            msg_sender_copy.send(Message::Ui(msg)).unwrap();
        }
    });

    let (notif_sender, notif_receiver) = std::sync::mpsc::channel::<serde_json::Value>();
    let msg_sender_copy = msg_sender.clone();
    std::thread::spawn(move || {
        while let Ok(msg) = notif_receiver.recv() {
            msg_sender_copy.send(Message::Notif(msg)).unwrap();
        }
    });
    let notif_context = Box::new(NotifContext(Mutex::new(notif_sender)));
    let notif_context = Box::into_raw(notif_context);

    let settings_path = Data::data_path(env, &params.work_dir);
    let mut settings = settings::load_settings(&settings_path).unwrap_or_default();
    settings::prune(&mut settings);

    let liquid_asset_id = AssetId(types::env_data(env).bitcoin_asset_id.to_owned());
    let bitcoin_asset_id =
        "0000000000000000000000000000000000000000000000000000000000000000".to_owned();

    let mut state = Data {
        connected: false,
        server_status: None,
        assets: BTreeMap::new(),
        assets_old: Vec::new(),
        tickers: BTreeMap::new(),
        from_sender,
        ws_sender,
        params,
        notif_context,
        env,
        ctx: None,
        resp_receiver,
        settings,
        push_token: None,
        liquid_asset_id,
        bitcoin_asset_id,
        submit_data: BTreeMap::new(),
        pending_signs: BTreeSet::new(),
        visible_submit: None,
        processed_signs: BTreeSet::new(),
        mobile_submits: BTreeSet::new(),
        pending_sign_requests: std::collections::VecDeque::new(),
        pending_submits: Vec::new(),
        pending_links: Vec::new(),
        utxos_resp: BTreeMap::new(),
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
        }

        let stopped = std::time::Instant::now();
        let processing_time = stopped.duration_since(started);
        if processing_time > std::time::Duration::from_millis(100) {
            debug!("processing time: {} seconds", processing_time.as_secs_f64());
        }
    }
}
