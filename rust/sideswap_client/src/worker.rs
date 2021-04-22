use super::*;
use core::panic;
use gdk_common::model::{GDKRUST_json, TransactionMeta, UnspentOutput};
use gdk_common::session::Session;
use gdk_electrum::{ElectrumSession, NativeNotif};
use settings::{Peg, PegDir};
use sideswap_api::*;
use sideswap_common::types::*;
use sideswap_common::*;
use sideswap_libwally::*;
use std::collections::{BTreeMap, BTreeSet, HashMap};
use std::sync::{
    mpsc::{Receiver, Sender},
    Mutex,
};
use types::Amount;
use types::Env;

const CLIENT_API_KEY: &str = "f8b7a12ee96aa68ee2b12ebfc51d804a4a404c9732652c298d24099a3d922a84";

const USER_AGENT: &str = "sideswap";

const SERVER_REQUEST_TIMEOUT: std::time::Duration = std::time::Duration::from_secs(5);
const SERVER_REQUEST_POOL_PERIOD: std::time::Duration = std::time::Duration::from_secs(1);

//const RFQ_TIMEOUT: std::time::Duration = std::time::Duration::from_secs(10);

const BALANCE_NUM_CONFS: u32 = 0;

const LIQUID_FEE_RATE: f64 = 100.0 / 1000.0; // sat/kbyte

const TX_CONF_COUNT: u32 = 2;

const EXTRA_ADDRESS_COUNT: u32 = 100;
const MAX_REGISTER_ADDRESS_COUNT: u32 = 100;

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

    pegs: BTreeMap<OrderId, PegStatus>,
    txs: Vec<gdk_common::model::TxListItem>,
    sent_txs: BTreeMap<String, ffi::proto::TransItem>,

    active_swap: Option<ActiveSwap>,
    psbt: Option<String>,
    psbt_keys: Option<PsbtKeys>,

    send_tx: Option<SendTx>,
    internal_peg: Option<InternalPeg>,
    active_extern_peg: Option<ActivePeg>,
}

pub struct ServerResp(Option<RequestId>, Result<Response, Error>);

fn get_tx_out(utxo: &UnspentOutput) -> types::TxOut {
    types::TxOut {
        txid: utxo.txhash.clone(),
        vout: utxo.pt_idx as i32,
    }
}

struct InternalPeg {
    tx: gdk_common::be::BETransaction,
    send_amount: i64,
    recv_amount: i64,
    tx_amount: i64,
    change_amount: i64,
    network_fee: i64,
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
    liquid_asset_id: String,
    bitcoin_asset_id: String,
}

pub struct ActiveSwap {
    order_id: OrderId,
    send_asset: AssetId,
    recv_asset: AssetId,
    send_amount: i64,
    recv_amount: Option<i64>,
    inputs: Vec<gdk_common::model::UnspentOutput>,
    //total_utxos_amount: Amount,
    change_amount: Amount,
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

impl Data {
    fn get_tx_item(
        &self,
        tx: &gdk_common::model::TxListItem,
        top_block: u32,
    ) -> ffi::proto::TransItem {
        let created_at = parse_gdk_time(&tx.created_at).expect("invalid datetime");
        let balances = tx
            .satoshi
            .iter()
            .filter_map(|(asset_id, balance)| {
                // filter only known assets
                // FIXME: Do not filter known only assets
                self.assets
                    .get(&AssetId(asset_id.clone()))
                    .map(|asset| ffi::proto::Balance {
                        asset_id: asset.asset_id.0.clone(),
                        amount: balance.clone(),
                    })
            })
            .collect();
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
            txid_recv: None,
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

    fn update_tx_list(&mut self) {
        if self.assets.is_empty() || self.ctx.is_none() {
            return;
        }
        let ctx = self.ctx.as_mut().expect("wallet must be set");
        let opt = gdk_common::model::GetTransactionsOpt {
            count: usize::MAX,
            ..gdk_common::model::GetTransactionsOpt::default()
        };
        ctx.txs = ctx
            .session
            .get_transactions(&opt)
            .expect("getting transaction list failed")
            .0;

        self.sync_tx_list();
    }

    fn resume_peg_monitoring(&mut self) {
        if self.assets.is_empty() || self.ctx.is_none() || !self.connected {
            return;
        }
        for peg in self.settings.pegs.iter() {
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

    fn try_sync_tx_list(&mut self) -> Result<(), anyhow::Error> {
        let ctx = self.ctx.as_ref().expect("ctx must be set");
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
            }
        }
        ctx.sent_txs = new_list;
        self.update_address_registrations();
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
        let mut balances = match ctx.session.get_balance(BALANCE_NUM_CONFS, None) {
            Ok(v) => v,
            Err(_) => return,
        };

        // Create empty entries for old balances
        for (asset_id, _) in ctx.last_balances.iter() {
            balances.entry(asset_id.0.clone()).or_default();
        }

        for asset_id in balances.keys() {
            let asset_id = AssetId(asset_id.clone());
            if self.assets.get(&asset_id).is_none() {
                let asset_id = asset_id.clone();
                let asset = Asset {
                    asset_id: asset_id.clone(),
                    name: format!("{:0.8}...", &asset_id.0),
                    ticker: Ticker(format!("{:0.4}...", &asset_id.0)),
                    icon: base64::encode(include_bytes!("../images/icon_blank.png")),
                    precision: 8,
                };
                self.register_asset(asset);
            }
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

        self.update_balances();
        self.update_tx_list();
        self.resume_peg_monitoring();
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
        self.update_push_token();
        self.update_address_registrations();
    }

    fn process_ws_disconnected(&mut self) {
        warn!("disconnected from server");
        self.connected = false;
    }

    fn process_server_status(&mut self, resp: ServerStatus) {
        let status_copy = ffi::proto::ServerStatus {
            min_peg_in_amount: resp.min_peg_in_amount,
            min_peg_out_amount: resp.min_peg_out_amount,
            server_fee_percent_peg_in: resp.server_fee_percent_peg_in,
            server_fee_percent_peg_out: resp.server_fee_percent_peg_out,
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

        active_swap.recv_amount = recv_amount;
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
            send_amount: active_swap.send_amount,
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
        wallet.psbt_keys = None;
        wallet.send_tx = None;
        wallet.internal_peg = None;
        wallet.active_extern_peg = None;
    }

    fn swap_send_psbt(&mut self, tx_info: Swap) -> Result<(), anyhow::Error> {
        let wallet = self.ctx.as_ref().ok_or_else(|| anyhow!("no wallet"))?;
        let active_swap = wallet
            .active_swap
            .as_ref()
            .ok_or_else(|| anyhow!("no active swap"))?;

        let psbt_info = PsbtInfo {
            send_asset: tx_info.send_asset.0.clone(),
            recv_asset: tx_info.recv_asset.0.clone(),
            recv_amount: tx_info.recv_amount,
            change_amount: active_swap.change_amount.to_sat(),
            utxos: active_swap.inputs.clone(),
        };

        let (psbt, keys) = generate_psbt(&wallet.session, &psbt_info)?;

        send_request!(
            self,
            Swap,
            SwapRequest {
                order_id: active_swap.order_id.clone(),
                action: SwapAction::Psbt(psbt),
            }
        )?;
        let wallet = self.ctx.as_mut().expect("wallet must be set");
        wallet.psbt_keys = Some(keys);
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
        let keys = ctx
            .psbt_keys
            .as_ref()
            .ok_or_else(|| anyhow!("not keys found"))?;
        let signed_psbt =
            sideswap_libwally::sign_psbt(&psbt, &ctx.session.wallet.as_ref().unwrap(), &keys)?;
        let active_swap = ctx
            .active_swap
            .as_ref()
            .ok_or_else(|| anyhow!("no active swap"))?
            .clone();

        let order_id = active_swap.order_id.clone();
        send_request!(
            self,
            Swap,
            SwapRequest {
                order_id,
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
        let send_balance = ffi::proto::Balance {
            asset_id: active_swap.send_asset.0.clone(),
            amount: -active_swap.send_amount,
        };
        let recv_balance = ffi::proto::Balance {
            asset_id: active_swap.recv_asset.0.clone(),
            amount: active_swap.recv_amount.unwrap_or_default(),
        };
        let tx_details = ffi::proto::Tx {
            txid: txid.clone(),
            network_fee: active_swap.network_fee.unwrap_or_default(),
            memo: "".to_owned(),
            balances: vec![send_balance, recv_balance],
        };
        let swap_succeed = ffi::proto::TransItem {
            id: txid.clone(),
            created_at: timestamp_now(),
            confs: Some(ffi::proto::Confs {
                count: 0,
                total: TX_CONF_COUNT,
            }),
            item: Some(ffi::proto::trans_item::Item::Tx(tx_details)),
        };
        for utxo in active_swap.inputs.iter() {
            ctx.used_utxos.insert(get_tx_out(utxo));
        }

        self.from_sender
            .send(ffi::proto::from::Msg::SwapSucceed(swap_succeed))
            .unwrap();
        self.cleanup_swaps();
        self.update_balances();
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
            "transaction" | "block" => {
                self.update_tx_list();
                self.update_balances();
            }
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

        let ctx = self.ctx.as_ref().ok_or(anyhow!("no context found"))?;
        let wallet = ctx
            .session
            .wallet
            .as_ref()
            .ok_or(anyhow!("wallet is not set"))?;
        ensure!(self.connected, "not connected");
        let server_status = self
            .server_status
            .as_ref()
            .ok_or(anyhow!("server_status is not known"))?;

        let mut all_utxos = ctx
            .session
            .get_unspent_outputs(&serde_json::Value::Null)
            .unwrap();
        let asset_utxos = all_utxos
            .0
            .remove(&send_asset)
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

        let expected_change_amount = selected_amount - send_amount;
        assert!(expected_change_amount >= 0);
        let with_change = expected_change_amount > gdk_common::be::DUST_VALUE as i64;
        let fee_rate = LIQUID_FEE_RATE;

        let utxos: HashMap<_, _> = vec![(send_asset.clone(), selected_utxos)]
            .into_iter()
            .collect();

        use std::convert::TryInto;
        let utxos = &gdk_common::model::GetUnspentOutputs(utxos);
        let utxos: gdk_common::be::Utxos =
            utxos.try_into().map_err(|_| anyhow!("conversion failed"))?;

        let mut tx = gdk_common::be::BETransaction::new(wallet.network.id());
        for utxo in utxos {
            tx.add_input(utxo.0);
        }

        // Pretend that target output is change too for the fee estimation purpose
        let network_fee = tx.estimated_fee(fee_rate, 1 + with_change as u8) as i64;
        // Workaround for min-relay fee not meet error, something up with estimated_fee
        let network_fee = network_fee + 3;
        info!("expected network fee: {}", network_fee);

        let target_amount = send_amount - network_fee;
        ensure!(
            target_amount >= server_status.min_peg_out_amount,
            "Amount is too low to cover network fees"
        );
        let request = Request::PegFee(PegFeeRequest {
            send_amount: target_amount,
            peg_in: false,
        });
        let resp = self.send_request(request);
        let resp = match resp {
            Ok(Response::PegFee(resp)) => resp,
            Ok(_) => bail!("unexpected server response"),
            Err(e) => bail!("server error: {}", e.to_string()),
        };

        let recv_amount = resp.recv_amount;
        let server_fee = target_amount - recv_amount;
        ensure!(server_fee >= 0, "unexpected server_fee");

        let ctx = self.ctx.as_mut().expect("wallet must be set");
        ctx.internal_peg = Some(InternalPeg {
            tx,
            send_amount,
            tx_amount: target_amount,
            recv_amount,
            change_amount: expected_change_amount,
            network_fee,
        });

        Ok(ffi::proto::from::SwapReview {
            send_asset,
            recv_asset,
            send_amount,
            recv_amount: Some(recv_amount),
            network_fee: Some(network_fee),
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
            .get_receive_address(&serde_json::Value::Null)
            .expect("can't get new address")
            .address;
        let request = Request::Peg(PegRequest {
            recv_addr: recv_addr.clone(),
            send_amount: None,
            peg_in: true,
            device_key: Some(device_key),
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
            recv_asset: self.liquid_asset_id.clone(),
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
            .get_unspent_outputs(&serde_json::Value::Null)
            .unwrap();
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

        let wallet = self.ctx.as_mut().expect("wallet must be set");
        wallet.active_swap = Some(ActiveSwap {
            order_id: rfq_resp.order_id.clone(),
            send_asset: send_asset.asset_id.clone(),
            recv_asset: recv_asset.asset_id.clone(),
            send_amount,
            recv_amount: None,
            inputs: selected_utxos,
            //total_utxos_amount: Amount::from_sat(selected_amount),
            change_amount: Amount::from_sat(change_amount),
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
        let result = if req.send_asset == self.liquid_asset_id
            && req.recv_asset == self.bitcoin_asset_id
        {
            self.process_pegout_request_local(req.clone())
                .map(|v| ffi::proto::from::Msg::SwapReview(v))
        } else if req.send_asset == self.bitcoin_asset_id && req.recv_asset == self.liquid_asset_id
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
            let recv_amount = active_swap
                .recv_amount
                .ok_or(anyhow!("nothing to accept"))?;
            send_request!(
                self,
                MatchRfqAccept,
                MatchRfqAcceptRequest {
                    order_id: active_swap.order_id.clone(),
                    recv_amount,
                }
            )
            .map_err(|e| anyhow!("request failed: {}", e))?;
            return Ok(());
        }

        let ctx = self.ctx.as_mut().expect("wallet must be set");
        if let Some(data) = ctx.internal_peg.take() {
            let ctx = self.ctx.as_ref().expect("wallet must be set");
            let device_key = self
                .settings
                .device_key
                .as_ref()
                .expect("device_key must exists")
                .clone();
            let recv_addr = req.recv_addr.unwrap();
            // First output is the target output
            let vout_send = 0;
            let request = match PegDir::Out {
                PegDir::In => unreachable!("PegDir::Out expected"),
                PegDir::Out => Request::Peg(PegRequest {
                    recv_addr: recv_addr.clone(),
                    send_amount: Some(data.send_amount),
                    peg_in: false,
                    device_key: Some(device_key),
                }),
            };
            let is_peg_in = false;
            let resp = self.send_request(request);
            let resp = match resp {
                Ok(Response::Peg(resp)) => resp,
                Ok(_) => bail!("unexpected server response"),
                Err(e) => bail!("server error: {}", e.to_string()),
            };

            let mut tx = data.tx;
            let target_addr = resp.peg_addr.clone();
            let lbtc_asset_id = self
                .tickers
                .get(&Ticker(TICKER_LBTC.to_owned()))
                .expect("unknown ticker");
            let amount = gdk_common::model::AddressAmount {
                address: target_addr.clone(),
                satoshi: data.tx_amount as u64,
                asset_tag: Some(lbtc_asset_id.0.clone()),
            };

            tx.add_output(
                &target_addr,
                data.tx_amount as u64,
                Some(lbtc_asset_id.0.clone()),
            )
            .unwrap();

            if data.change_amount > 0 {
                let change_addr = ctx
                    .session
                    .get_receive_address(&serde_json::Value::Null)
                    .expect("can't get new address")
                    .address;
                tx.add_output(
                    &change_addr,
                    data.change_amount as u64,
                    Some(lbtc_asset_id.0.clone()),
                )
                .unwrap();
            }

            let policy_asset = ctx.session.network.policy_asset().ok();
            tx.add_fee_if_elements(data.network_fee as u64, &policy_asset)
                .unwrap();

            let details = gdk_common::model::CreateTransaction {
                addressees: vec![amount],
                fee_rate: None,
                subaccount: None,
                send_all: None,
                previous_transaction: HashMap::new(),
                memo: None,
                utxos: None,
            };

            let mut peg_tx = TransactionMeta::new(
                tx,
                None,
                None,
                HashMap::new(),
                data.network_fee as u64,
                ctx.session
                    .network
                    .id()
                    .get_bitcoin_network()
                    .unwrap_or(bitcoin::Network::Bitcoin),
                "peg-out".to_string(),
                details,
                true,
                gdk_common::model::SPVVerifyResult::InProgress,
            );
            if data.change_amount > 0 {
                peg_tx.changes_used = Some(1);
            }

            let tx_detail_signed = ctx.session.sign_transaction(&peg_tx).unwrap();
            let ctx = self.ctx.as_mut().expect("wallet must be set");
            let send_txid = match ctx.session.send_transaction(&tx_detail_signed) {
                Ok(v) => v,
                Err(e) => bail!("broadcast failed: {}", e.to_string()),
            };
            let order_id = resp.order_id.clone();

            let peg_details = ffi::proto::Peg {
                is_peg_in,
                amount_send: data.tx_amount,
                amount_recv: data.recv_amount,
                addr_send: target_addr.clone(),
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
        }
    }

    fn process_get_recv_address(&mut self) {
        let wallet = self.ctx.as_mut().expect("wallet must be set");
        let addr = wallet
            .session
            .get_receive_address(&serde_json::Value::Null)
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
            subaccount: None,
            send_all: send_all_opt,
            previous_transaction: HashMap::new(),
            memo: None,
            utxos: None,
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
        let send_tx = match ctx.send_tx.take() {
            Some(v) => v,
            None => bail!("no transaction found"),
        };
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
        if let Err(e) = ctx.session.set_transaction_memo(&txid, &req.memo, 0) {
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
        let wallet = ctx.session.wallet.as_ref().expect("wallet must be set");
        let store_read = wallet.store.read().expect("store must be set");
        let be_tx =
            gdk_common::be::BETransaction::from_hex(&tx_detail_signed.hex, wallet.network.id())
                .expect("tx decode failed");
        let is_redeposit = be_tx.is_redeposit(&store_read.cache.paths, &store_read.cache.all_txs);

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

        let mut session = ElectrumSession::new_session(parsed_network, &cache_path, url).unwrap();

        session.notify = NativeNotif(Some((
            notification_callback,
            self.notif_context as *const libc::c_void,
        )));

        session.connect(&serde_json::Value::Null).unwrap();

        let mnemonic = gdk_common::mnemonic::Mnemonic::from(req.mnemonic.to_owned());

        session.login(&mnemonic, None).unwrap();

        let ctx = Context {
            psbt: None,
            psbt_keys: None,
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
        };

        self.ctx = Some(ctx);

        self.update_tx_list();
        self.update_balances();
        self.resume_peg_monitoring();
        self.update_address_registrations();
    }

    fn process_logout_request(&mut self) {
        debug!("process logout request...");
        self.ctx = None;
        self.settings = settings::Settings::default();
        self.save_settings();
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
            .set_transaction_memo(&req.txid, &req.memo, 0)
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
            let resp = self.resp_receiver.recv_timeout(SERVER_REQUEST_POOL_PERIOD);
            match resp {
                Ok(ServerResp(Some(request_id), result)) => {
                    if request_id != active_request_id {
                        warn!("discard old response");
                        continue;
                    }
                    return result.map_err(|e| anyhow!("response failed: {}", e.message));
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

    fn process_ui(&mut self, msg: ffi::ToMsg) {
        match msg {
            ffi::proto::to::Msg::Login(req) => self.process_login_request(req),
            ffi::proto::to::Msg::Logout(_) => self.process_logout_request(),
            ffi::proto::to::Msg::PegRequest(_) => self.process_peg_request_external(),
            ffi::proto::to::Msg::SwapRequest(req) => self.process_swap_request(req),
            ffi::proto::to::Msg::SwapCancel(_) => self.process_swap_cancel(),
            ffi::proto::to::Msg::SwapAccept(req) => self.process_swap_accept(req),
            ffi::proto::to::Msg::GetRecvAddress(_) => self.process_get_recv_address(),
            ffi::proto::to::Msg::CreateTx(req) => self.process_create_tx(req),
            ffi::proto::to::Msg::SendTx(req) => self.process_send_tx(req),
            ffi::proto::to::Msg::SetMemo(req) => self.process_set_memo(req),
            ffi::proto::to::Msg::UpdatePushToken(req) => self.process_update_push_token(req),
            ffi::proto::to::Msg::RegisterPhone(req) => self.process_register_phone(req),
            ffi::proto::to::Msg::VerifyPhone(req) => self.process_verify_phone(req),
        }
    }

    fn process_ws_notification(&mut self, notification: Notification) {
        match notification {
            Notification::PegStatus(status) => self.process_peg_status(status),
            Notification::ServerStatus(resp) => self.process_server_status(resp),
            Notification::MatchRfq(status) => self.process_rfq_update(status),
            Notification::Swap(msg) => self.process_swap_notification(msg),
            Notification::RfqCreated(_) => {}
            Notification::RfqRemoved(_) => {}
            Notification::PriceUpdate(msg) => self.process_price_update(msg),
        }
    }

    pub fn register_asset(&mut self, asset: Asset) {
        let asset_id = asset.asset_id.clone();
        let asset_copy = ffi::proto::Asset {
            asset_id: asset.asset_id.0.clone(),
            name: asset.name.clone(),
            ticker: asset.ticker.0.clone(),
            icon: asset.icon.clone(),
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
                peg_in: true,
            }),
            PegDir::Out => Request::PegStatus(PegStatusRequest {
                order_id: peg.order_id.clone(),
                peg_in: false,
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
        self.settings.pegs.push(peg);
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
        let addr_type = match addr_type {
            AddrType::External => 0,
            AddrType::Internal => 1,
        };
        let addr = wallet
            .derive_address(&wallet.xpub, [addr_type, pointer])
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
                    .store
                    .read()
                    .expect("read store must succeed")
                    .cache
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
                    addresses.push(Data::get_address(wallet, AddrType::External, pointer));
                }
                for pointer in last_internal..new_internal {
                    addresses.push(Data::get_address(wallet, AddrType::Internal, pointer));
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
    let settings = settings::load_settings(&settings_path).unwrap_or_default();

    let liquid_asset_id = match env {
        Env::Prod | Env::Staging => {
            "6f0279e9ed041c3d710a9f57d0c02928416460c4b722ae3457a11eec381c526d"
        }
        Env::Regtest => "2e16b12daf1244332a438e829ca7ce209195f8e1c54199770cd8b327710a8ab2",
        Env::Local => "2684bbac0fa7ad544ec8eee43c35156346e5d641d24a4b9d5d8f183e3f2d8fb9",
    }
    .to_owned();
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
    };

    if let Err(e) = state.load_assets() {
        error!("can't load assets: {}", &e);
    }

    while let Ok(a) = msg_receiver.recv() {
        match &a {
            Message::Ui(ffi::proto::to::Msg::Login(_)) => debug!("new msg: login request..."),
            _ => debug!("new msg: {:?}", &a),
        };

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
