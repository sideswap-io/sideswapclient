use crate::worker;
use crate::{ffi, models};
use sideswap_api::AssetId;
use sideswap_common::env::Env;

pub enum JadeStatus {
    Idle,
    ReadStatus,
    AuthUser,
    SignTx,
}

pub type JadeStatusCallback = std::sync::Arc<Box<dyn Fn(JadeStatus)>>;

#[derive(Clone)]
pub struct WatchOnly {
    pub username: String,
    pub password: String,
}

#[derive(Clone)]
pub struct LoginInfo {
    pub account_id: worker::AccountId,
    pub env: Env,
    pub mnemonic: Option<String>,
    pub network: Option<ffi::proto::network_settings::Selected>,
    pub cache_dir: String,
    pub hw_data: Option<HwData>,
    pub watch_only: Option<WatchOnly>,
}

#[derive(Clone)]
pub struct HwData {
    pub env: Env,
    pub name: String,
    pub jade: std::sync::Arc<crate::jade_mng::ManagedJade>,
    pub status_callback: JadeStatusCallback,
}

pub type NotifCallback = Box<dyn Fn(worker::AccountId, crate::gdk_json::Notification)>;

impl HwData {
    pub fn clear_queue(&self) {
        // TODO: Should we clear pending queue here?
        while let Ok(msg) = self.jade.recv(std::time::Duration::ZERO) {
            warn!("unexpected Jade response ignored: {:?}", msg);
        }
    }

    pub fn get_resp_with_timeout(
        &self,
        time: std::time::Duration,
    ) -> Result<sideswap_jade::Resp, anyhow::Error> {
        self.jade
            .recv(time)
            .map_err(|e| anyhow!("jade response timeout: {}", e))
    }

    pub fn get_resp(&self) -> Result<sideswap_jade::Resp, anyhow::Error> {
        self.get_resp_with_timeout(std::time::Duration::from_secs(10))
    }

    pub fn get_hw_device(hw_data: Option<&Self>) -> crate::gdk_json::HwDevice {
        crate::gdk_json::HwDevice {
            device: hw_data.map(|hw_data| crate::gdk_json::HwDeviceDetails {
                name: hw_data.name.clone(),
                supports_ae_protocol: 1,
                supports_arbitrary_scripts: true,
                supports_host_unblinding: true,
                supports_liquid: 1,
                supports_low_r: true,
            }),
        }
    }

    pub fn set_status(&self, status: JadeStatus) {
        (self.status_callback)(status);
    }
}

pub trait GdkSes {
    fn login(&mut self) -> Result<(), anyhow::Error>;

    fn set_watch_only(&mut self, username: &str, password: &str) -> Result<(), anyhow::Error>;

    fn connect(&mut self);

    fn disconnect(&mut self);

    fn login_info(&self) -> &LoginInfo;

    fn get_gaid(&self) -> Result<String, anyhow::Error>;

    fn update_sync_interval(&self, time: u32);

    fn get_balances(&self) -> Result<std::collections::BTreeMap<AssetId, i64>, anyhow::Error>;

    fn get_balance(&self, asset_id: &AssetId) -> i64 {
        self.get_balances()
            .ok()
            .and_then(|balances| balances.get(asset_id).cloned())
            .unwrap_or_default()
    }

    fn get_transactions(&self) -> Result<Vec<models::Transaction>, anyhow::Error>;

    fn get_recv_address(&self) -> Result<String, anyhow::Error>;

    fn create_tx(&mut self, tx: ffi::proto::CreateTx) -> Result<serde_json::Value, anyhow::Error>;

    fn send_tx(&mut self, tx: &serde_json::Value) -> Result<sideswap_api::Txid, anyhow::Error>;

    fn get_utxos(&self) -> Result<ffi::proto::from::UtxoUpdate, anyhow::Error>;

    fn get_tx_fee(
        &mut self,
        asset_id: AssetId,
        send_amount: i64,
        addr: &str,
    ) -> Result<i64, anyhow::Error>;

    fn make_pegout_payment(
        &mut self,
        send_amount: i64,
        peg_addr: &str,
        send_amount_exact: i64,
    ) -> Result<worker::PegPayment, anyhow::Error>;

    fn get_blinded_values(&self, txid: &str) -> Result<Vec<String>, anyhow::Error>;

    fn get_previous_addresses(
        &mut self,
        last_pointer: Option<u32>,
        is_internal: bool,
    ) -> Result<crate::gdk_json::PreviousAddresses, anyhow::Error>;

    fn get_swap_inputs(
        &self,
        send_asset: &AssetId,
    ) -> Result<Vec<sideswap_api::PsetInput>, anyhow::Error>;

    fn sig_single_maker_tx(
        &mut self,
        input: &crate::swaps::SigSingleInput,
        output: &crate::swaps::SigSingleOutput,
    ) -> Result<crate::swaps::SigSingleMaker, anyhow::Error>;

    fn verify_and_sign_pset(
        &mut self,
        amounts: &crate::swaps::Amounts,
        pset: &str,
        nonces: &[String],
    ) -> Result<String, anyhow::Error>;

    fn set_memo(&mut self, txid: &str, memo: &str) -> Result<(), anyhow::Error>;
}
