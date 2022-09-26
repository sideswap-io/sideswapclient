use crate::worker;
use crate::{ffi, models};
use sideswap_api::AssetId;
use sideswap_common::env::Env;

#[derive(Clone)]
pub struct LoginInfo {
    pub account_id: worker::AccountId,
    pub env: Env,
    pub mnemonic: Option<String>,
    pub network: ffi::proto::network_settings::Selected,
    pub jade_port: Option<sideswap_jade::Port>,
    pub cache_dir: String,
    pub worker: crossbeam_channel::Sender<worker::Message>,
}

pub trait GdkSes {
    fn login(&mut self) -> Result<(), anyhow::Error>;

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

    fn create_tx(
        &mut self,
        tx: ffi::proto::CreateTx,
    ) -> Result<ffi::proto::CreatedTx, anyhow::Error>;

    fn send_tx(&mut self) -> Result<sideswap_api::Txid, anyhow::Error>;

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
        &self,
        last_pointer: Option<u32>,
        is_internal: bool,
    ) -> Result<crate::gdk_json::PreviousAddresses, anyhow::Error>;

    fn get_swap_inputs(
        &self,
        send_asset: &AssetId,
    ) -> Result<Vec<sideswap_api::PsetInput>, anyhow::Error>;

    fn sig_single_maker_tx(
        &self,
        input: &crate::swaps::SigSingleInput,
        output: &crate::swaps::SigSingleOutput,
    ) -> Result<crate::swaps::SigSingleMaker, anyhow::Error>;

    fn verify_and_sign_pset(
        &self,
        amounts: &crate::swaps::Amounts,
        pset: &str,
        nonces: &[String],
    ) -> Result<String, anyhow::Error>;

    fn set_memo(&mut self, txid: &str, memo: &str) -> Result<(), anyhow::Error>;
}
