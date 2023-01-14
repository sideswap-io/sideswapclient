use sideswap_api::AssetId;

use crate::{
    ffi, gdk_json,
    gdk_ses::{self, NotifCallback},
};

#[derive(Eq, PartialEq, Clone, Copy)]
enum GdkState {
    Disconnected,
    Connected,
    LoggedIn,
}

struct GdkSesJade {
    watch_only: Box<dyn crate::gdk_ses::GdkSes>,
    jade: Box<dyn crate::gdk_ses::GdkSes>,
    jade_state: std::sync::Arc<std::sync::Mutex<GdkState>>,
}

impl crate::gdk_ses::GdkSes for GdkSesJade {
    fn login(&mut self) -> Result<(), anyhow::Error> {
        self.watch_only.login()
    }

    fn set_watch_only(&mut self, _username: &str, _password: &str) -> Result<(), anyhow::Error> {
        bail!("not implemented");
    }

    fn connect(&mut self) {
        self.watch_only.connect();
    }

    fn disconnect(&mut self) {
        self.watch_only.disconnect();
    }

    fn login_info(&self) -> &gdk_ses::LoginInfo {
        self.watch_only.login_info()
    }

    fn get_gaid(&self) -> Result<String, anyhow::Error> {
        self.watch_only.get_gaid()
    }

    fn update_sync_interval(&self, _time: u32) {}

    fn get_balances(&self) -> Result<std::collections::BTreeMap<AssetId, i64>, anyhow::Error> {
        self.watch_only.get_balances()
    }

    fn get_transactions(&self) -> Result<Vec<crate::models::Transaction>, anyhow::Error> {
        self.watch_only.get_transactions()
    }

    fn get_recv_address(&self) -> Result<String, anyhow::Error> {
        self.watch_only.get_recv_address()
    }

    fn create_tx(&mut self, req: ffi::proto::CreateTx) -> Result<serde_json::Value, anyhow::Error> {
        self.watch_only.create_tx(req)
    }

    fn send_tx(&mut self, tx: &serde_json::Value) -> Result<sideswap_api::Txid, anyhow::Error> {
        self.check_jade()?;
        self.jade.send_tx(tx)
    }

    fn get_utxos(&self) -> Result<crate::ffi::proto::from::UtxoUpdate, anyhow::Error> {
        self.watch_only.get_utxos()
    }

    fn get_tx_fee(
        &mut self,
        asset_id: sideswap_api::AssetId,
        send_amount: i64,
        addr: &str,
    ) -> Result<i64, anyhow::Error> {
        self.watch_only.get_tx_fee(asset_id, send_amount, addr)
    }

    fn make_pegout_payment(
        &mut self,
        send_amount: i64,
        peg_addr: &str,
        send_amount_exact: i64,
    ) -> Result<crate::worker::PegPayment, anyhow::Error> {
        self.check_jade()?;
        self.jade
            .make_pegout_payment(send_amount, peg_addr, send_amount_exact)
    }

    fn get_blinded_values(&self, txid: &str) -> Result<Vec<String>, anyhow::Error> {
        self.watch_only.get_blinded_values(txid)
    }

    fn get_previous_addresses(
        &mut self,
        last_pointer: Option<u32>,
        is_internal: bool,
    ) -> Result<gdk_json::PreviousAddresses, anyhow::Error> {
        if last_pointer.is_none() && self.get_jade_state() == GdkState::LoggedIn {
            let check_result = self.jade.get_previous_addresses(None, is_internal);
            if let Err(e) = check_result {
                debug!("GDK jade connection check failed: {}", e);
                self.jade.disconnect();
                self.jade.connect();
                self.set_jade_state(GdkState::Disconnected);
            }
        }

        self.watch_only
            .get_previous_addresses(last_pointer, is_internal)
    }

    fn get_swap_inputs(
        &self,
        send_asset: &sideswap_api::AssetId,
    ) -> Result<Vec<sideswap_api::PsetInput>, anyhow::Error> {
        self.watch_only.get_swap_inputs(send_asset)
    }

    fn sig_single_maker_tx(
        &mut self,
        input: &crate::swaps::SigSingleInput,
        output: &crate::swaps::SigSingleOutput,
    ) -> Result<crate::swaps::SigSingleMaker, anyhow::Error> {
        self.check_jade()?;
        self.jade.sig_single_maker_tx(input, output)
    }

    fn verify_and_sign_pset(
        &mut self,
        amounts: &crate::swaps::Amounts,
        pset: &str,
        nonces: &[String],
    ) -> Result<String, anyhow::Error> {
        self.check_jade()?;
        self.jade.verify_and_sign_pset(amounts, pset, nonces)
    }

    fn set_memo(&mut self, txid: &str, memo: &str) -> Result<(), anyhow::Error> {
        self.watch_only.set_memo(txid, memo)
    }
}

impl GdkSesJade {
    fn get_jade_state(&self) -> GdkState {
        *self.jade_state.lock().unwrap()
    }

    fn set_jade_state(&self, state: GdkState) {
        *self.jade_state.lock().unwrap() = state;
    }

    fn check_jade(&mut self) -> Result<(), anyhow::Error> {
        match self.get_jade_state() {
            GdkState::Disconnected => {
                bail!("GDK jade is disconnected");
            }
            GdkState::Connected => {
                debug!("try login GDK jade");
                self.jade.login()?;
                self.set_jade_state(GdkState::LoggedIn);
            }
            GdkState::LoggedIn => {}
        }
        Ok(())
    }
}

pub fn start_processing(
    info: gdk_ses::LoginInfo,
    notif_callback: NotifCallback,
) -> Box<dyn crate::gdk_ses::GdkSes> {
    let mut login_info_watch_only = info;
    let mut login_info_jade = login_info_watch_only.clone();
    login_info_watch_only.hw_data = None;
    login_info_jade.watch_only = None;

    let jade_state = std::sync::Arc::new(std::sync::Mutex::new(GdkState::Disconnected));

    let callback_watch_only = Box::new(move |wallet_id, notif| {
        notif_callback(wallet_id, notif);
    });

    let jade_state_copy = jade_state.clone();
    let callback_jade = Box::new(move |_wallet_id, notif: gdk_json::Notification| {
        if let Some(gdk_json::NotificationNetwork {
            current_state: gdk_json::ConnectionState::Connected,
            next_state: _,
            wait_ms: _,
        }) = &notif.network
        {
            debug!("GDK jade connected");
            *jade_state_copy.lock().unwrap() = GdkState::Connected;
        }

        if let Some(gdk_json::NotificationNetwork {
            current_state: gdk_json::ConnectionState::Disconnected,
            next_state: _,
            wait_ms: _,
        }) = &notif.network
        {
            debug!("GDK jade disconnected");
            *jade_state_copy.lock().unwrap() = GdkState::Disconnected;
        }
    });

    let watch_only = crate::gdk_cpp::start_processing(login_info_watch_only, callback_watch_only);
    let jade = crate::gdk_cpp::start_processing(login_info_jade, callback_jade);
    let ses = GdkSesJade {
        watch_only,
        jade,
        jade_state,
    };
    Box::new(ses)
}
