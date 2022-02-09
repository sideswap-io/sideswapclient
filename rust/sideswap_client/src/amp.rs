use crate::ffi;
use crate::gdk;
use crate::gdk_json;
use crate::models;
use crate::worker;
use sideswap_api::AssetId;
use sideswap_api::BlindingFactor;
use sideswap_api::PsetInput;
use sideswap_common::env::Env;
use sideswap_common::env::Network;
use sideswap_common::types::Amount;
use std::collections::BTreeMap;
use std::collections::HashMap;
use std::ffi::{CStr, CString};
use std::str::FromStr;

const SUBACCOUNT_NAME_AMP: &str = "AMP";
const SUBACCOUNT_TYPE_AMP: &str = "2of2_no_recovery";

pub struct Amp(std::sync::Arc<std::sync::Mutex<Data>>);

pub type PsetUtoxs = Vec<serde_json::Value>;

impl Amp {
    pub fn send(&self, to: To) {
        self.0.lock().unwrap().amp_sender.send(to).unwrap();
    }

    pub fn get_swap_inputs(
        &self,
        send_asset: &AssetId,
    ) -> Result<worker::SwapInputs, anyhow::Error> {
        unsafe { get_swap_inputs(&mut self.0.lock().unwrap(), send_asset) }
    }

    pub fn verify_pset(
        &self,
        amounts: &crate::swaps::Amounts,
        pset: &str,
        send_amp: bool,
        recv_amp: bool,
    ) -> Result<PsetUtoxs, anyhow::Error> {
        unsafe {
            verify_pset(
                &mut self.0.lock().unwrap(),
                amounts,
                pset,
                send_amp,
                recv_amp,
            )
        }
    }

    pub fn sign_pset(
        &self,
        pset: &str,
        nonces: &[String],
        utxos: PsetUtoxs,
    ) -> Result<String, anyhow::Error> {
        unsafe { sign_pset(&mut self.0.lock().unwrap(), pset, nonces, utxos) }
    }

    pub fn get_gaid(&self) -> Result<String, anyhow::Error> {
        try_get_gaid(&mut self.0.lock().unwrap())
    }

    pub fn get_balance(&self, asset: &AssetId) -> Amount {
        unsafe {
            let balances = get_balances(&mut self.0.lock().unwrap()).unwrap_or_default();
            let balance = balances.get(asset).cloned().unwrap_or_default();
            Amount::from_sat(balance as i64)
        }
    }

    pub fn get_blinded_values(&self, txid: &str) -> Result<Vec<String>, anyhow::Error> {
        unsafe { get_blinded_values(&mut self.0.lock().unwrap(), txid) }
    }

    pub fn make_pegout_payment(
        &self,
        send_amount: i64,
        peg_addr: &str,
    ) -> Result<worker::PegPayment, anyhow::Error> {
        unsafe { make_pegout_payment(&mut self.0.lock().unwrap(), send_amount, peg_addr) }
    }
}

#[derive(Debug)]
pub enum To {
    Notification(gdk_json::Notification),

    Login(String, Env),
    Logout,
    AppState(bool),
    GetRecvAddr,
    CreateTx(ffi::proto::to::CreateTx),
    SendTx,
}

#[derive(Debug)]
pub enum From {
    Register(Result<String, String>),
    Balances(BTreeMap<AssetId, u64>),
    Transactions(Vec<models::Transaction>),
    RecvAddr(String),
    CreateTx(ffi::proto::from::CreateTxResult),
    SendTx(ffi::proto::from::SendResult),
    SentTx(sideswap_api::Txid),
    Error(String),
    ConnectionStatus(bool),
}

struct Wallet {
    session: Option<*mut gdk::GA_session>,
    account: gdk_json::Subaccount,
    created_tx: Option<serde_json::Value>,
    mnemonic: String,
    policy_asset: AssetId,
    env: Env,
}

unsafe impl Send for Wallet {}

struct Data {
    amp_sender: crossbeam_channel::Sender<To>,
    worker: crossbeam_channel::Sender<worker::Message>,
    notif_context: *mut NotifContext,
    wallet: Option<Wallet>,
    top_block: Option<u32>,
    pending_txs: bool,
}

unsafe impl Send for Data {}

struct GdkJson {
    json: *mut gdk::GA_json,
    str: *mut ::std::os::raw::c_char,
}

impl GdkJson {
    fn new<T: serde::Serialize>(data: &T) -> Self {
        let data = serde_json::to_string(&data).unwrap();
        let mut output = std::ptr::null_mut();
        let value = CString::new(data).unwrap();
        let rc = unsafe { gdk::GA_convert_string_to_json(value.as_ptr(), &mut output) };
        assert!(rc == 0);
        Self {
            json: output,
            str: std::ptr::null_mut(),
        }
    }

    unsafe fn owned(ptr: *mut gdk::GA_json) -> Self {
        assert!(ptr != std::ptr::null_mut());
        Self {
            json: ptr,
            str: std::ptr::null_mut(),
        }
    }

    unsafe fn as_ptr(&self) -> *const gdk::GA_json {
        self.json
    }

    fn to_str(&mut self) -> &str {
        if self.str == std::ptr::null_mut() {
            let rc = unsafe { gdk::GA_convert_json_to_string(self.json, &mut self.str) };
            assert!(rc == 0);
        }
        unsafe { CStr::from_ptr(self.str).to_str().unwrap() }
    }

    fn to_json<T: serde::de::DeserializeOwned>(&mut self) -> Result<T, serde_json::Error> {
        serde_json::from_str(self.to_str())
    }
}

impl Drop for GdkJson {
    fn drop(&mut self) {
        let rc = unsafe { gdk::GA_destroy_json(self.json) };
        assert!(rc == 0);
        if self.str != std::ptr::null_mut() {
            unsafe { gdk::GA_destroy_string(self.str) };
        }
    }
}

unsafe fn run_auth_handler<T: serde::de::DeserializeOwned>(
    call: *mut gdk::GA_auth_handler,
) -> Result<T, anyhow::Error> {
    let mut status = std::ptr::null_mut();
    let rc = gdk::GA_auth_handler_get_status(call, &mut status);
    ensure!(rc == 0, "GA_auth_handler_get_status failed");
    let mut json = GdkJson::owned(status);
    debug!("auth handler status: {}", json.to_str());
    let result = json
        .to_json::<gdk_json::AuthHandler<T>>()
        .map_err(|e| anyhow!("parsing failed: {}, json: {}", e, json.to_str()))?;
    let rc = gdk::GA_destroy_auth_handler(call);
    assert!(rc == 0);
    if result.status == gdk_json::Status::Error {
        if let Some(error) = result.error {
            bail!("{}", error);
        }
        bail!("unknown auth handler error");
    }
    ensure!(
        result.status == gdk_json::Status::Done,
        "unexpected auth handler status: {:?}",
        result.status
    );
    let result = result
        .result
        .ok_or_else(|| anyhow!("auth handler error: no result field"))?;
    Ok(result)
}

struct NotifContext(crossbeam_channel::Sender<To>);

unsafe extern "C" fn notification_handler(
    context: *mut std::os::raw::c_void,
    details: *mut gdk::GA_json,
) {
    let context = &*(context as *const NotifContext);
    let mut details = GdkJson::owned(details);
    debug!("amp notification: {}", details.to_str());
    let details = details.to_json::<gdk_json::Notification>();
    match details {
        Ok(v) => {
            let _ = context.0.send(To::Notification(v));
        }
        Err(e) => warn!("notification parsing fails: {}", e),
    }
}

fn last_gdk_error_details() -> Result<String, anyhow::Error> {
    let mut json = std::ptr::null_mut();
    let rc = unsafe { gdk::GA_get_thread_error_details(&mut json) };
    ensure!(rc == 0, "GA_get_thread_error_details failed");
    let mut json = unsafe { GdkJson::owned(json) };
    let json = json.to_json::<gdk_json::ErrorDetailsResult>()?;
    Ok(json.details)
}

fn send_from(data: &Data, from: From) {
    let result = data.worker.send(worker::Message::Amp(from));
    if let Err(e) = result {
        warn!("sending failed: {}", e);
    }
}

fn convert_tx(tx: &gdk_json::Transaction, top_block: u32) -> models::Transaction {
    let created_at = tx.created_at_ts as i64 / 1000;
    let mut balances = std::collections::BTreeMap::<AssetId, i64>::new();
    for input in tx.inputs.iter() {
        match (input.asset_id, input.satoshi) {
            (Some(asset_id), Some(amount)) => {
                *balances.entry(asset_id.clone()).or_default() -= amount as i64
            }
            _ => {}
        }
    }
    for output in tx.outputs.iter() {
        match (output.asset_id, output.satoshi) {
            (Some(asset_id), Some(amount)) => {
                *balances.entry(asset_id.clone()).or_default() += amount as i64
            }
            _ => {}
        }
    }
    let balances = balances
        .iter()
        .map(|(asset_id, balance)| models::Balance {
            asset: asset_id.clone(),
            value: *balance,
        })
        .collect::<Vec<_>>();
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

    let tx = models::Transaction {
        txid: tx.txhash.clone(),
        network_fee: tx.fee,
        memo: tx.memo.clone(),
        balances,
        created_at,
        pending_confs,
    };
    tx
}

unsafe fn notification(data: &mut Data, msg: gdk_json::Notification) {
    if let Some(block) = msg.block {
        data.top_block = Some(block.block_height);
        if data.pending_txs {
            update_tx_and_balances(data);
        }
    }

    if let Some(_transaction) = msg.transaction {
        update_tx_and_balances(data);
    }

    if let Some(network) = msg.network {
        if network.connected && network.login_required.unwrap_or(false) {
            info!("try reconnect AMP account");
            app_state(data, false);
            app_state(data, true);
            // info!("try reconnect AMP account");
            // if let Some(wallet) = data.wallet.as_mut() {
            //     if let Some(session) = wallet.session {
            //         let login_result = try_login(session, &wallet.mnemonic);
            //         if let Err(e) = login_result {
            //             warn!("AMP account reconnect failed: {}", e);
            //             send_from(data, From::Error(format!("reconnect failed: {}", e)));
            //         } else {
            //             info!("AMP account reconnect succeed");
            //             send_from(data, From::ConnectionStatus(true));
            //             update_tx_and_balances(data);
            //         }
            //     }
            // }
        }
        if !network.connected {
            send_from(data, From::ConnectionStatus(false));
        }
    }
}

unsafe fn try_login(session: *mut gdk::GA_session, mnemonic: &str) -> Result<(), anyhow::Error> {
    let hw_device = gdk_json::HwDevice {};
    let login_user = gdk_json::LoginUser {
        mnemonic: mnemonic.to_owned(),
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_login_user(
        session,
        GdkJson::new(&hw_device).as_ptr(),
        GdkJson::new(&login_user).as_ptr(),
        &mut call,
    );
    ensure!(
        rc == 0,
        "GA_login_user failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let login = run_auth_handler::<gdk_json::LoginUserResult>(call)
        .map_err(|e| anyhow!("login failed: {}", e))?;
    debug!("wallet_hash_id: {:?}", login.wallet_hash_id);
    Ok(())
}

unsafe fn try_connect(
    session: *mut gdk::GA_session,
    notif_context: *mut NotifContext,
    mnemonic: String,
    env: Env,
) -> Result<Wallet, anyhow::Error> {
    let rc = gdk::GA_set_notification_handler(
        session,
        Some(notification_handler),
        notif_context as *mut libc::c_void,
    );
    assert!(rc == 0);

    let network = match env.data().network {
        Network::Mainnet => "liquid",
        Network::Testnet => "testnet-liquid",
        Network::Regtest | Network::Local => {
            bail!("unsupported env")
        }
    };
    let policy_asset = AssetId::from_str(env.data().policy_asset).unwrap();
    let connect_config = gdk_json::ConnectConfig {
        name: network.to_owned(),
        log_level: Some("info".to_owned()),
    };
    let rc = gdk::GA_connect(session, GdkJson::new(&connect_config).as_ptr());
    ensure!(
        rc == 0,
        "connection failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );

    let hw_device = gdk_json::HwDevice {};
    let mut call = std::ptr::null_mut();
    let mnemonic_copy = CString::new(mnemonic.clone()).unwrap();
    let rc = gdk::GA_register_user(
        session,
        GdkJson::new(&hw_device).as_ptr(),
        mnemonic_copy.as_ptr(),
        &mut call,
    );
    ensure!(
        rc == 0,
        "GA_register_user failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let register_result = run_auth_handler::<serde_json::Value>(call)
        .map_err(|e| anyhow!("registration failed: {}", e))?;
    debug!("registration result: {}", register_result);

    try_login(session, &mnemonic)?;

    let get_subaccounts_opts = gdk_json::GetSubaccountsOpts {
        refresh: Some(false),
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_get_subaccounts(
        session,
        GdkJson::new(&get_subaccounts_opts).as_ptr(),
        &mut call,
    );
    ensure!(
        rc == 0,
        "GA_get_subaccounts failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let subaccounts = run_auth_handler::<gdk_json::GetSubaccountsResult>(call)
        .map_err(|e| anyhow!("loading subaccounts failed: {}", e))?;

    let account = subaccounts
        .subaccounts
        .into_iter()
        .find(|account| account.type_ == SUBACCOUNT_TYPE_AMP)
        .ok_or_else(|| anyhow!("no account found"))
        .or_else(|_| {
            let mut call = std::ptr::null_mut();
            let new_subaccount = gdk_json::CreateSubaccount {
                name: SUBACCOUNT_NAME_AMP.to_owned(),
                type_: SUBACCOUNT_TYPE_AMP.to_owned(),
            };
            let rc = gdk::GA_create_subaccount(
                session,
                GdkJson::new(&new_subaccount).as_ptr(),
                &mut call,
            );
            ensure!(
                rc == 0,
                "GA_create_subaccount failed: {}",
                last_gdk_error_details().unwrap_or_default()
            );
            let created_subaccount = run_auth_handler::<gdk_json::Subaccount>(call)
                .map_err(|e| anyhow!("creating AMP subaccount failed: {}", e))?;
            Ok(created_subaccount)
        })?;

    let wallet = Wallet {
        session: Some(session),
        account,
        created_tx: None,
        mnemonic,
        policy_asset,
        env,
    };

    Ok(wallet)
}

unsafe fn login(data: &mut Data, mnemonic: String, env: Env) {
    logout(data);

    let mut session = std::ptr::null_mut();
    let rc = gdk::GA_create_session(&mut session);
    assert!(rc == 0);

    let login_result = try_connect(session, data.notif_context, mnemonic, env);
    match login_result {
        Ok(wallet) => {
            send_from(
                data,
                From::Register(Ok(wallet.account.receiving_id.clone())),
            );
            data.wallet = Some(wallet);
            send_from(data, From::ConnectionStatus(true));
            update_tx_and_balances(data);
        }

        Err(e) => {
            send_from(data, From::ConnectionStatus(false));
            let rc = gdk::GA_destroy_session(session);
            assert!(rc == 0);

            send_from(
                data,
                From::Register(Err(format!("AMP register error: {}", e))),
            );
        }
    }
}

unsafe fn logout(data: &mut Data) {
    if let Some(wallet) = data.wallet.as_mut() {
        if let Some(session) = wallet.session.clone() {
            send_from(data, From::ConnectionStatus(false));
            let rc = gdk::GA_destroy_session(session);
            assert!(rc == 0);
        }
        data.wallet = None;
    }
}

unsafe fn app_state(data: &mut Data, active: bool) {
    if let Some(wallet) = data.wallet.as_ref() {
        match (wallet.session.clone(), active) {
            (Some(session), false) => {
                send_from(data, From::ConnectionStatus(false));

                debug!("destroy GDK session because app is not active");
                let rc = gdk::GA_disconnect(session);
                assert!(rc == 0);
                let rc = gdk::GA_destroy_session(session);
                assert!(rc == 0);
                data.wallet.as_mut().unwrap().session = None;
            }
            (None, true) => {
                debug!("create GDK session because app is active");
                let mnemonic = wallet.mnemonic.clone();
                let env = wallet.env;
                let mut connection_index = 0;
                loop {
                    let mut session = std::ptr::null_mut();
                    let rc = gdk::GA_create_session(&mut session);
                    assert!(rc == 0);

                    let login_result =
                        try_connect(session, data.notif_context, mnemonic.clone(), env);

                    match login_result {
                        Ok(wallet) => {
                            debug!("recreating GDK session succeed");
                            data.wallet = Some(wallet);
                            send_from(data, From::ConnectionStatus(true));
                            update_tx_and_balances(data);
                            break;
                        }

                        Err(e) => {
                            error!("recreating GDK session failed");
                            let rc = gdk::GA_destroy_session(session);
                            assert!(rc == 0);
                            if connection_index == 2 {
                                send_from(data, From::Error(format!("AMP login error: {}", e)));
                                break;
                            }
                        }
                    }
                    connection_index += 1;
                }
            }
            _ => {}
        }
    }
}

unsafe fn load_transactions(data: &mut Data) -> Result<Vec<gdk_json::Transaction>, anyhow::Error> {
    let wallet = data.wallet.as_ref().ok_or_else(|| anyhow!("no wallet"))?;
    let session = wallet
        .session
        .clone()
        .ok_or_else(|| anyhow!("no session"))?;

    let mut result = HashMap::new();
    let mut first = 0;
    // Looks like 900 is max tx count that could be loaded at once
    let count = 900;
    let mut load_more = true;
    while load_more {
        let list_transactions = gdk_json::ListTransactions {
            subaccount: wallet.account.pointer,
            first,
            count,
        };
        let mut call = std::ptr::null_mut();
        let rc = gdk::GA_get_transactions(
            session,
            GdkJson::new(&list_transactions).as_ptr(),
            &mut call,
        );
        ensure!(rc == 0, "GA_get_transactions failed");
        let transaction_list = run_auth_handler::<gdk_json::TransactionList>(call)?;
        load_more = transaction_list.transactions.len() as i32 == count;
        first += transaction_list.transactions.len() as i32;
        for tx in transaction_list.transactions.into_iter() {
            result.insert(tx.txhash.clone(), tx);
        }
    }
    Ok(result.into_values().collect())
}

unsafe fn try_update_tx_list(data: &mut Data) -> Result<(), anyhow::Error> {
    let transaction_list = load_transactions(data)?;

    let top_block = data.top_block.unwrap_or_default();
    let mut items = Vec::new();
    let mut pending_txs = false;
    for tx in transaction_list {
        let converted_tx = convert_tx(&tx, top_block);
        pending_txs |= converted_tx.pending_confs.is_some();
        items.push(converted_tx);
    }
    if !items.is_empty() {
        send_from(data, From::Transactions(items));
    }
    data.pending_txs = pending_txs;

    Ok(())
}

unsafe fn update_tx_and_balances(data: &mut Data) {
    let update_tx_list_result = try_update_tx_list(data);
    if let Err(e) = update_tx_list_result {
        error!("updating AMP tx list failed: {}", e);
    }

    let balances = get_balances(data);
    match balances {
        Ok(balances) => {
            send_from(data, From::Balances(balances));
        }
        Err(e) => error!("updating AMP balances failed: {}", e),
    }
}

fn try_get_gaid(data: &mut Data) -> Result<String, anyhow::Error> {
    let wallet = data
        .wallet
        .as_ref()
        .ok_or_else(|| anyhow!("no AMP wallet"))?;
    Ok(wallet.account.receiving_id.clone())
}

unsafe fn try_get_recv_addr(data: &mut Data) -> Result<String, anyhow::Error> {
    let wallet = data
        .wallet
        .as_mut()
        .ok_or_else(|| anyhow!("no AMP wallet"))?;
    let session = wallet
        .session
        .clone()
        .ok_or_else(|| anyhow!("no session"))?;

    let get_addr = gdk_json::RecvAddrOpt {
        subaccount: wallet.account.pointer,
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_get_receive_address(session, GdkJson::new(&get_addr).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_get_receive_address failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let recv_addr = run_auth_handler::<gdk_json::RecvAddrResult>(call)
        .map_err(|e| anyhow!("receiving new address failed: {}", e))?;
    debug!("recv addr: {:?}", &recv_addr);
    Ok(recv_addr.address)
}

unsafe fn get_recv_addr(data: &mut Data) {
    let recv_addr_result = try_get_recv_addr(data);
    match recv_addr_result {
        Ok(addr) => {
            send_from(data, From::RecvAddr(addr));
        }
        Err(e) => {
            send_from(data, From::Error(format!("failed: {}", e)));
        }
    }
}

unsafe fn try_create_tx(
    data: &mut Data,
    tx: ffi::proto::to::CreateTx,
) -> Result<i64, anyhow::Error> {
    let wallet = data
        .wallet
        .as_mut()
        .ok_or_else(|| anyhow!("no AMP wallet"))?;
    let session = wallet
        .session
        .clone()
        .ok_or_else(|| anyhow!("no session"))?;
    let send_asset = AssetId::from_str(&tx.balance.asset_id).unwrap();

    let mut call = std::ptr::null_mut();
    let unspent_outputs = gdk_json::UnspentOutputsArgs {
        subaccount: wallet.account.pointer,
        num_confs: 0,
    };
    let rc =
        gdk::GA_get_unspent_outputs(session, GdkJson::new(&unspent_outputs).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_get_unspent_outputs failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let unspent_outputs_json = run_auth_handler::<gdk_json::UnspentOutputsJsonResult>(call)
        .map_err(|e| anyhow!("loading unspent outputs failed: {}", e))?;
    let mut unspent_outputs = serde_json::from_value::<gdk_json::UnspentOutputs>(
        unspent_outputs_json.unspent_outputs.clone(),
    )
    .map_err(|e| anyhow!("parsing unspent outputs failed: {}", e))?;

    let bitcoin_balance = unspent_outputs
        .get(&wallet.policy_asset)
        .map(|inputs| inputs.iter().map(|input| input.satoshi).sum::<u64>())
        .unwrap_or_default();
    let inputs = unspent_outputs.remove(&send_asset).unwrap_or_default();
    let total = inputs.iter().map(|input| input.satoshi).sum::<u64>() as i64;
    ensure!(tx.balance.amount <= total, "Insufficient funds");
    ensure!(
        bitcoin_balance > 0,
        "Insufficient L-BTC AMP to pay network fee"
    );
    let send_all = tx.balance.amount == total;

    let tx_addressee = gdk_json::TxAddressee {
        address: tx.addr,
        satoshi: tx.balance.amount as u64,
        asset_id: send_asset,
    };
    let create_tx = gdk_json::CreateTransactionOpt {
        subaccount: wallet.account.pointer,
        addressees: vec![tx_addressee],
        utxos: unspent_outputs_json.unspent_outputs,
        send_all,
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_create_transaction(session, GdkJson::new(&create_tx).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_create_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let created_tx_json = run_auth_handler::<serde_json::Value>(call)
        .map_err(|e| anyhow!("creating transaction failed: {}", e))?;
    let created_tx =
        serde_json::from_value::<gdk_json::CreateTransactionResult>(created_tx_json.clone())
            .map_err(|e| anyhow!("parsing created transaction JSON failed: {}", e))?;
    debug!("created tx: {:?}", &created_tx);
    ensure!(created_tx.fee > 0, "network fee is 0");

    wallet.created_tx = Some(created_tx_json);

    Ok(created_tx.fee as i64)
}

unsafe fn create_tx(data: &mut Data, tx: ffi::proto::to::CreateTx) {
    let create_tx_result = try_create_tx(data, tx);

    let result = match create_tx_result {
        Ok(fee) => ffi::proto::from::create_tx_result::Result::NetworkFee(fee),
        Err(e) => ffi::proto::from::create_tx_result::Result::ErrorMsg(e.to_string()),
    };
    let create_result = ffi::proto::from::CreateTxResult {
        result: Some(result),
    };

    send_from(data, From::CreateTx(create_result));
}

unsafe fn try_send_tx(data: &mut Data) -> Result<(), anyhow::Error> {
    let wallet = data
        .wallet
        .as_mut()
        .ok_or_else(|| anyhow!("no AMP wallet"))?;
    let session = wallet
        .session
        .clone()
        .ok_or_else(|| anyhow!("no session"))?;

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_sign_transaction(
        session,
        GdkJson::new(&wallet.created_tx).as_ptr(),
        &mut call,
    );
    ensure!(
        rc == 0,
        "GA_sign_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let signed_tx_json = run_auth_handler::<serde_json::Value>(call)
        .map_err(|e| anyhow!("signing tx failed: {}", e))?;

    // signed_tx_json
    //     .as_object_mut()
    //     .ok_or_else(|| anyhow!("invalid signed TX json"))?
    //     .insert("memo".to_owned(), json!(memo));

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_send_transaction(session, GdkJson::new(&signed_tx_json).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_send_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let send_result = run_auth_handler::<gdk_json::SendTransactionResult>(call)
        .map_err(|e| anyhow!("sending tx failed: {}", e))?;
    info!("send succeed, waiting for txhash: {}", &send_result.txhash);

    send_from(data, From::SentTx(send_result.txhash));

    Ok(())
}

unsafe fn send_tx(data: &mut Data) {
    let send_result = try_send_tx(data);
    if let Err(e) = send_result {
        let send_result = ffi::proto::from::SendResult {
            result: Some(ffi::proto::from::send_result::Result::ErrorMsg(
                e.to_string(),
            )),
        };
        send_from(data, From::SendTx(send_result));
    }
}

unsafe fn get_swap_inputs(
    data: &mut Data,
    send_asset: &AssetId,
) -> Result<worker::SwapInputs, anyhow::Error> {
    let change_addr = try_get_recv_addr(data)?;

    let wallet = data
        .wallet
        .as_mut()
        .ok_or_else(|| anyhow!("no AMP wallet"))?;
    let session = wallet
        .session
        .clone()
        .ok_or_else(|| anyhow!("no session"))?;

    let mut config = std::ptr::null_mut();
    let rc = gdk::GA_get_twofactor_config(session, &mut config);
    ensure!(
        rc == 0,
        "GA_get_twofactor_config failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let mut config = GdkJson::owned(config);
    let config = config.to_json::<gdk_json::TwoFactorConfig>()?;
    ensure!(
        !config.any_enabled,
        "Two-Factor authentication not supported"
    );

    let mut call = std::ptr::null_mut();
    let unspent_outputs = gdk_json::UnspentOutputsArgs {
        subaccount: wallet.account.pointer,
        num_confs: 0,
    };
    let rc =
        gdk::GA_get_unspent_outputs(session, GdkJson::new(&unspent_outputs).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_get_unspent_outputs failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let mut unspent_outputs = run_auth_handler::<gdk_json::UnspentOutputsParsedResult>(call)
        .map_err(|e| anyhow!("loading unspent outputs failed: {}", e))?;
    let inputs = unspent_outputs
        .unspent_outputs
        .remove(send_asset)
        .unwrap_or_default()
        .into_iter()
        .map(|utxo| PsetInput {
            txid: utxo.txhash,
            vout: utxo.pt_idx,
            asset: utxo.asset_id,
            asset_bf: utxo.assetblinder.unwrap(),
            value: utxo.satoshi,
            value_bf: utxo.amountblinder.unwrap(),
            // No need to set redeem_script for AMP asset inputs
            redeem_script: None,
        })
        .collect();

    Ok(worker::SwapInputs {
        inputs,
        change_addr,
    })
}

unsafe fn verify_pset(
    data: &mut Data,
    amounts: &crate::swaps::Amounts,
    pset: &str,
    send_amp: bool,
    recv_amp: bool,
) -> Result<PsetUtoxs, anyhow::Error> {
    let wallet = data
        .wallet
        .as_mut()
        .ok_or_else(|| anyhow!("no AMP wallet"))?;
    let session = wallet
        .session
        .clone()
        .ok_or_else(|| anyhow!("no session"))?;
    ensure!(
        send_amp != recv_amp,
        "unsupported swap type (send_amp != recv_amp)"
    );

    let mut call = std::ptr::null_mut();
    let unspent_outputs = gdk_json::UnspentOutputsArgs {
        subaccount: wallet.account.pointer,
        num_confs: 0,
    };
    let rc =
        gdk::GA_get_unspent_outputs(session, GdkJson::new(&unspent_outputs).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_get_unspent_outputs failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let mut unspent_outputs_json = run_auth_handler::<gdk_json::UnspentOutputsJsonMapResult>(call)
        .map_err(|e| anyhow!("loading unspent outputs failed: {}", e))?;
    let utxos = unspent_outputs_json
        .unspent_outputs
        .remove(&amounts.send_asset)
        .unwrap_or_default();

    let verify_pset = gdk_json::PsetDetailsOpt {
        utxos: utxos.clone(),
        psbt: pset.to_owned(),
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_psbt_get_details(session, GdkJson::new(&verify_pset).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_psbt_get_details failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let pset_details = run_auth_handler::<gdk_json::PsetDetailsResult>(call)
        .map_err(|e| anyhow!("loading PSET details failed: {}", e))?;
    debug!("decoded AMP pset details: {:?}", &pset_details);
    // There could be only AMP asset inputs and outputs currenly
    // (because L-BTC goes from/to the regular wallet)
    ensure!(send_amp != recv_amp);
    let amp_asset = if send_amp {
        amounts.send_asset
    } else {
        amounts.recv_asset
    };
    for data in pset_details
        .inputs
        .iter()
        .chain(pset_details.outputs.iter())
    {
        ensure!(data.asset_id == amp_asset);
        ensure!(data.subaccount == wallet.account.pointer);
    }
    let input_total = pset_details
        .inputs
        .iter()
        .map(|data| data.satoshi)
        .sum::<u64>();
    let output_total = pset_details
        .outputs
        .iter()
        .map(|data| data.satoshi)
        .sum::<u64>();
    if send_amp {
        ensure!(input_total >= output_total);
        ensure!(input_total - output_total == amounts.send_amount);
    }
    if recv_amp {
        ensure!(input_total == 0);
        ensure!(output_total == amounts.recv_amount);
    }
    Ok(utxos)
}

unsafe fn sign_pset(
    data: &mut Data,
    pset: &str,
    nonces: &[String],
    utxos: PsetUtoxs,
) -> Result<String, anyhow::Error> {
    let wallet = data
        .wallet
        .as_mut()
        .ok_or_else(|| anyhow!("no AMP wallet"))?;
    let session = wallet
        .session
        .clone()
        .ok_or_else(|| anyhow!("no session"))?;

    let sign_pset = gdk_json::SignPsetOpt {
        utxos,
        psbt: pset.to_owned(),
        blinding_nonces: nonces.to_owned(),
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_psbt_sign(session, GdkJson::new(&sign_pset).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_sign_psbt failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let signed_pset = run_auth_handler::<gdk_json::SignPsetResult>(call)
        .map_err(|e| anyhow!("signing pset failed: {}", e))?;
    Ok(signed_pset.psbt)
}

unsafe fn get_balances(data: &mut Data) -> Result<gdk_json::BalanceList, anyhow::Error> {
    let wallet = data
        .wallet
        .as_mut()
        .ok_or_else(|| anyhow!("no AMP wallet"))?;
    let session = wallet
        .session
        .clone()
        .ok_or_else(|| anyhow!("no session"))?;
    let balance = gdk_json::UnspentOutputsArgs {
        subaccount: wallet.account.pointer,
        num_confs: 0,
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_get_balance(session, GdkJson::new(&balance).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_get_balance failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let balances = run_auth_handler::<gdk_json::BalanceList>(call)
        .map_err(|e| anyhow!("loading balances failed: {}", e))?;
    Ok(balances)
}

fn get_blinded_value(
    value: u64,
    asset: &AssetId,
    value_bf: &BlindingFactor,
    asset_bf: &BlindingFactor,
) -> String {
    [
        value.to_string(),
        asset.to_string(),
        value_bf.to_string(),
        asset_bf.to_string(),
    ]
    .join(",")
}

unsafe fn get_blinded_values(data: &mut Data, txid: &str) -> Result<Vec<String>, anyhow::Error> {
    let txid = sideswap_api::Txid::from_str(txid)?;
    let transaction_list = load_transactions(data)?;
    let tx = transaction_list
        .iter()
        .find(|tx| tx.txhash == txid)
        .ok_or_else(|| anyhow!("tx not found"))?;
    let mut result = Vec::new();
    for input in tx.inputs.iter() {
        match (
            input.satoshi,
            input.asset_id,
            input.amountblinder,
            input.assetblinder,
        ) {
            (Some(value), Some(asset_id), Some(value_bf), Some(asset_bf)) => {
                result.push(get_blinded_value(value, &asset_id, &value_bf, &asset_bf))
            }
            _ => {}
        }
    }
    for output in tx.outputs.iter() {
        match (
            output.satoshi,
            output.asset_id,
            output.amountblinder,
            output.assetblinder,
        ) {
            (Some(value), Some(asset_id), Some(value_bf), Some(asset_bf)) => {
                result.push(get_blinded_value(value, &asset_id, &value_bf, &asset_bf))
            }
            _ => {}
        }
    }
    Ok(result)
}

unsafe fn make_pegout_payment(
    data: &mut Data,
    send_amount: i64,
    peg_addr: &str,
) -> Result<worker::PegPayment, anyhow::Error> {
    let wallet = data
        .wallet
        .as_mut()
        .ok_or_else(|| anyhow!("no AMP wallet"))?;
    let session = wallet
        .session
        .clone()
        .ok_or_else(|| anyhow!("no session"))?;
    let send_asset = wallet.policy_asset;

    let mut call = std::ptr::null_mut();
    let unspent_outputs = gdk_json::UnspentOutputsArgs {
        subaccount: wallet.account.pointer,
        num_confs: 0,
    };
    let rc =
        gdk::GA_get_unspent_outputs(session, GdkJson::new(&unspent_outputs).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_get_unspent_outputs failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let unspent_outputs_json = run_auth_handler::<gdk_json::UnspentOutputsJsonResult>(call)
        .map_err(|e| anyhow!("loading unspent outputs failed: {}", e))?;
    let mut unspent_outputs = serde_json::from_value::<gdk_json::UnspentOutputs>(
        unspent_outputs_json.unspent_outputs.clone(),
    )
    .map_err(|e| anyhow!("parsing unspent outputs failed: {}", e))?;

    let inputs = unspent_outputs.remove(&send_asset).unwrap_or_default();
    let total = inputs.iter().map(|input| input.satoshi).sum::<u64>() as i64;
    ensure!(send_amount <= total, "Insufficient funds");
    let send_all = send_amount == total;

    let tx_addressee = gdk_json::TxAddressee {
        address: peg_addr.to_owned(),
        satoshi: send_amount as u64,
        asset_id: send_asset,
    };
    let create_tx = gdk_json::CreateTransactionOpt {
        subaccount: wallet.account.pointer,
        addressees: vec![tx_addressee],
        utxos: unspent_outputs_json.unspent_outputs,
        send_all,
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_create_transaction(session, GdkJson::new(&create_tx).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_create_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let created_tx_json = run_auth_handler::<serde_json::Value>(call)
        .map_err(|e| anyhow!("creating transaction failed: {}", e))?;
    let created_tx =
        serde_json::from_value::<gdk_json::CreateTransactionResult>(created_tx_json.clone())
            .map_err(|e| anyhow!("parsing created transaction JSON failed: {}", e))?;
    debug!("created tx: {:?}", &created_tx);
    ensure!(created_tx.fee > 0, "network fee is 0");

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_sign_transaction(session, GdkJson::new(&created_tx_json).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_sign_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let signed_tx_json = run_auth_handler::<serde_json::Value>(call)
        .map_err(|e| anyhow!("signing tx failed: {}", e))?;

    let signed_tx =
        serde_json::from_value::<gdk_json::SignTransactionResult>(signed_tx_json.clone())?;

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_send_transaction(session, GdkJson::new(&signed_tx_json).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_send_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let send_result = run_auth_handler::<gdk_json::SendTransactionResult>(call)
        .map_err(|e| anyhow!("sending tx failed: {}", e))?;
    info!("send succeed, waiting for txhash: {}", &send_result.txhash);

    let sent_amount = if send_all {
        send_amount - created_tx.fee as i64
    } else {
        send_amount
    };

    Ok(worker::PegPayment {
        sent_amount,
        sent_txid: send_result.txhash,
        signed_tx: signed_tx.transaction,
    })
}

static GDK_INITIALIZED: std::sync::Once = std::sync::Once::new();

pub fn start_processing(work_dir: &str, worker: crossbeam_channel::Sender<worker::Message>) -> Amp {
    let (amp_sender, amp_receiver) = crossbeam_channel::unbounded::<To>();

    let notif_context = Box::into_raw(Box::new(NotifContext(amp_sender.clone())));

    let data = std::sync::Arc::new(std::sync::Mutex::new(Data {
        worker,
        notif_context,
        top_block: None,
        wallet: None,
        amp_sender,
        pending_txs: false,
    }));

    GDK_INITIALIZED.call_once(|| unsafe {
        let config = gdk_json::InitConfig {
            datadir: work_dir.to_owned(),
        };
        let rc = gdk::GA_init(GdkJson::new(&config).as_ptr());
        assert!(rc == 0);
    });

    let data_copy = data.clone();
    std::thread::spawn(move || unsafe {
        while let Ok(msg) = amp_receiver.recv() {
            let mut data = data_copy.lock().unwrap();
            match msg {
                To::Notification(msg) => notification(&mut data, msg),

                To::Login(mnemonic, env) => login(&mut data, mnemonic, env),
                To::Logout => logout(&mut data),
                To::AppState(active) => app_state(&mut data, active),
                To::GetRecvAddr => get_recv_addr(&mut data),
                To::CreateTx(tx) => create_tx(&mut data, tx),
                To::SendTx => send_tx(&mut data),
            }
        }

        debug!("shutdown GDK AMP account processing...");
        let mut data = data_copy.lock().unwrap();
        logout(&mut data);
    });

    Amp(data)
}
