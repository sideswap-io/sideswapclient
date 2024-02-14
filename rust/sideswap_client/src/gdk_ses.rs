use std::collections::BTreeMap;
use std::str::FromStr;

use crate::gdk_json::{self, AddressInfo};
use crate::settings::WatchOnly;
use crate::worker;
use crate::{ffi, models};
use bitcoin::bip32::ExtendedPubKey;
use sideswap_api::{Asset, AssetId};
use sideswap_common::env::Env;
use sideswap_jade::models::JadeNetwork;

#[derive(Copy, Clone)]
pub enum TxType {
    Normal,
    Swap,
    OfflineSwapOutput,
    OfflineSwap,
}

pub enum JadeStatus {
    Idle,
    ReadStatus,
    AuthUser,
    MasterBlindingKey,
    SignTx(TxType),
}

pub type JadeStatusCallback = std::sync::Arc<Box<dyn Fn(JadeStatus)>>;

#[derive(Clone)]
pub struct HwData {
    pub env: Env,
    pub name: String,
    pub jade: std::sync::Arc<crate::jade_mng::ManagedJade>,
    pub status_callback: JadeStatusCallback,
    pub master_blinding_key: String,
    pub xpubs: BTreeMap<Vec<u32>, ExtendedPubKey>,
}

#[derive(Clone)]
pub enum WalletInfo {
    Mnemonic(String),
    HwData(HwData),
    WatchOnly(WatchOnly),
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ElectrumServer {
    SideSwap,
    SideSwapCn,
    Blockstream,
    Custom {
        host: String,
        port: u16,
        use_tls: bool,
    },
}

impl Default for ElectrumServer {
    fn default() -> Self {
        Self::SideSwap
    }
}

#[derive(Clone)]
pub struct LoginInfo {
    pub account_id: worker::AccountId,
    pub env: Env,
    pub cache_dir: String,
    pub wallet_info: WalletInfo,
    pub single_sig: bool,
    pub electrum_server: ElectrumServer,
    pub proxy: Option<String>,
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
        self.jade.recv(time)
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

    pub fn resolve_xpub(
        &self,
        network: JadeNetwork,
        path: &[u32],
    ) -> Result<ExtendedPubKey, anyhow::Error> {
        self.jade.send(sideswap_jade::Req::ResolveXpub(
            sideswap_jade::models::ResolveXpubReq {
                network,
                path: path.to_vec(),
            },
        ));
        let xpub = match self.jade.recv(std::time::Duration::from_secs(20)) {
            Ok(sideswap_jade::Resp::ResolveXpub(v)) => v,
            resp => bail!("unexpected Jade response: {:?}", resp),
        };
        let xpub = ExtendedPubKey::from_str(&xpub)?;
        Ok(xpub)
    }

    pub fn set_status(&self, status: JadeStatus) {
        (self.status_callback)(status);
    }
}

impl WalletInfo {
    pub fn mnemonic(&self) -> Option<&String> {
        match self {
            WalletInfo::Mnemonic(mnemonic) => Some(mnemonic),
            WalletInfo::HwData(_) | WalletInfo::WatchOnly(_) => None,
        }
    }

    pub fn hw_data(&self) -> Option<&HwData> {
        match self {
            WalletInfo::HwData(hw_data) => Some(hw_data),
            WalletInfo::Mnemonic(_) | WalletInfo::WatchOnly(_) => None,
        }
    }

    pub fn watch_only(&self) -> Option<&WatchOnly> {
        match self {
            WalletInfo::WatchOnly(watch_only) => Some(watch_only),
            WalletInfo::Mnemonic(_) | WalletInfo::HwData(_) => None,
        }
    }
}

pub struct TxFeeInfo {
    pub input_count: usize,
    pub fee: u64,
}

pub trait GdkSes {
    fn login(&mut self) -> Result<(), anyhow::Error>;

    fn register(&mut self) -> Result<(), anyhow::Error>;

    fn set_watch_only(&mut self, username: &str, password: &str) -> Result<(), anyhow::Error>;

    fn connect(&mut self);

    fn disconnect(&mut self);

    fn login_info(&self) -> &LoginInfo;

    fn get_gaid(&self) -> Result<String, anyhow::Error>;

    fn unlock_hww(&self) -> Result<(), anyhow::Error>;

    fn update_sync_interval(&self, time: u32);

    fn get_balances(&self) -> Result<std::collections::BTreeMap<AssetId, i64>, anyhow::Error>;

    fn get_balance(&self, asset_id: &AssetId) -> i64 {
        self.get_balances()
            .ok()
            .and_then(|balances| balances.get(asset_id).cloned())
            .unwrap_or_default()
    }

    fn get_transactions_impl(&self) -> Result<Vec<gdk_json::Transaction>, anyhow::Error>;

    fn get_transactions(&self) -> Result<Vec<models::Transaction>, anyhow::Error> {
        self.get_transactions_impl().map(|transactions| {
            transactions
                .iter()
                .map(crate::gdk_ses_impl::convert_tx)
                .collect()
        })
    }

    fn get_receive_address(&self) -> Result<AddressInfo, anyhow::Error>;

    fn get_change_address(&self) -> Result<AddressInfo, anyhow::Error>;

    fn create_tx(&mut self, tx: ffi::proto::CreateTx) -> Result<serde_json::Value, anyhow::Error>;

    fn send_tx(
        &mut self,
        tx: &serde_json::Value,
        assets: &BTreeMap<AssetId, Asset>,
    ) -> Result<elements::Txid, anyhow::Error>;

    fn create_payjoin(
        &mut self,
        req: ffi::proto::CreatePayjoin,
    ) -> Result<ffi::proto::CreatedPayjoin, anyhow::Error>;

    fn send_payjoin(
        &mut self,
        req: &ffi::proto::CreatedPayjoin,
        assets: &BTreeMap<AssetId, Asset>,
    ) -> Result<elements::Txid, anyhow::Error>;

    fn get_utxos(&self) -> Result<gdk_json::UnspentOutputsResult, anyhow::Error>;

    fn get_tx_fee(
        &mut self,
        asset_id: AssetId,
        send_amount: i64,
        addr: &str,
    ) -> Result<TxFeeInfo, anyhow::Error>;

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

    fn sig_single_maker_tx(
        &mut self,
        input: &crate::swaps::SigSingleInput,
        output: &crate::swaps::SigSingleOutput,
        assets: &BTreeMap<AssetId, Asset>,
    ) -> Result<crate::swaps::SigSingleMaker, anyhow::Error>;

    fn verify_and_sign_pset(
        &mut self,
        amounts: &crate::swaps::Amounts,
        pset: &str,
        nonces: &[String],
        assets: &BTreeMap<AssetId, Asset>,
    ) -> Result<String, anyhow::Error>;

    fn set_memo(&mut self, txid: &str, memo: &str) -> Result<(), anyhow::Error>;
}
