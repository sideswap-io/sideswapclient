use std::str::FromStr;
use std::{collections::BTreeMap, sync::Arc};

use crate::{
    ffi::proto,
    gdk_json::{self, AddressInfo},
    gdk_ses_impl::CreatedTxCache,
    models,
    settings::WatchOnly,
    worker,
};
use bitcoin::bip32;
use sideswap_api::{Asset, AssetId};
use sideswap_common::env::Env;
use sideswap_jade::{
    jade_mng::{self, JadeStatus},
    models::JadeNetwork,
};

#[derive(Debug, Copy, Clone)]
pub enum SignWith {
    User,
    GreenBackend,
    #[allow(dead_code)]
    All,
}

impl SignWith {
    pub fn to_json(self) -> Vec<gdk_json::SignWith> {
        match self {
            SignWith::User => vec![gdk_json::SignWith::User],
            SignWith::GreenBackend => vec![gdk_json::SignWith::GreenBackend],
            SignWith::All => vec![gdk_json::SignWith::User, gdk_json::SignWith::GreenBackend],
        }
    }
}

#[derive(Clone)]
pub struct HwData {
    pub env: Env,
    pub name: String,
    pub jade: Arc<jade_mng::ManagedJade>,
    pub master_blinding_key: String,
    pub xpubs: BTreeMap<Vec<u32>, bip32::Xpub>,
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

pub type NotifCallback = Box<dyn Fn(worker::AccountId, gdk_json::Notification)>;

impl HwData {
    pub fn get_hw_device(hw_data: Option<&Self>) -> gdk_json::HwDevice {
        gdk_json::HwDevice {
            device: hw_data.map(|hw_data| gdk_json::HwDeviceDetails {
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
    ) -> Result<bip32::Xpub, anyhow::Error> {
        let xpub = self.jade.resolve_xpub(network, path)?;
        let xpub = bip32::Xpub::from_str(&xpub)?;
        Ok(xpub)
    }

    pub fn set_status(&self, status: JadeStatus) {
        self.jade.set_status(status);
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

pub type Balances = BTreeMap<AssetId, i64>;

pub trait GdkSes {
    fn login(&mut self) -> Result<(), anyhow::Error>;

    fn register(&mut self) -> Result<(), anyhow::Error>;

    fn set_watch_only(&mut self, username: &str, password: &str) -> Result<(), anyhow::Error>;

    fn connect(&mut self);

    fn disconnect(&mut self);

    fn login_info(&self) -> &LoginInfo;

    fn get_gaid(&self) -> Result<String, anyhow::Error>;

    #[allow(dead_code)]
    fn unlock_hww(&self) -> Result<(), anyhow::Error>;

    #[allow(dead_code)]
    fn update_sync_interval(&self, time: u32);

    fn get_balances(&self) -> Result<Balances, anyhow::Error>;

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

    fn create_tx(
        &mut self,
        cache: &mut CreatedTxCache,
        tx: proto::CreateTx,
    ) -> Result<proto::CreatedTx, anyhow::Error>;

    fn send_tx(
        &mut self,
        cache: &mut CreatedTxCache,
        id: &str,
        assets: &BTreeMap<AssetId, Asset>,
    ) -> Result<elements::Txid, anyhow::Error>;

    fn broadcast_tx(&mut self, tx: &str) -> Result<(), anyhow::Error>;

    fn get_utxos(&self) -> Result<gdk_json::UnspentOutputs, anyhow::Error>;

    fn get_blinded_values(&self, txid: &elements::Txid) -> Result<Vec<String>, anyhow::Error>;

    fn get_previous_addresses(
        &mut self,
        last_pointer: Option<u32>,
        is_internal: bool,
    ) -> Result<gdk_json::PreviousAddresses, anyhow::Error>;

    #[allow(dead_code)]
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

    fn sign_pset(
        &mut self,
        utxos: &gdk_json::UnspentOutputs,
        pset: &str,
        nonces: &[String],
        assets: &BTreeMap<AssetId, Asset>,
        tx_type: jade_mng::TxType,
        sign_with: SignWith,
    ) -> Result<String, anyhow::Error>;

    fn set_memo(&mut self, txid: &str, memo: &str) -> Result<(), anyhow::Error>;
}
