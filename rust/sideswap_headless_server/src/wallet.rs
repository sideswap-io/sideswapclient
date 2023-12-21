use std::{
    collections::BTreeMap,
    str::FromStr,
    time::{Duration, Instant},
};

use sideswap_api::AssetId;
use sideswap_client::{gdk_json, gdk_ses, gdk_ses_impl, worker};
use sideswap_common::env::Env;

pub enum Req {
    Notif(gdk_json::Notification),
    SignPset(sideswap_api::SignNotification),
    Timer,
}

pub struct SwapInputs {
    pub recv_address: sideswap_api::Address,
    pub change_address: sideswap_api::Address,
    pub utxos: std::collections::BTreeMap<AssetId, Vec<gdk_json::UnspentOutput>>,
}

pub enum Resp {
    SwapInputs(SwapInputs),
    SignedPset(sideswap_api::OrderId, String),
    PsetSignFailed(sideswap_api::OrderId),
}

pub type Callback = Box<dyn Fn(Resp) + Send>;

pub struct Params {
    pub env: Env,
    pub mnemonic: String,
    pub work_dir: String,
    pub callback: Callback,
}

#[derive(Clone)]
pub struct Wallet {
    req_sender: crossbeam_channel::Sender<Req>,
}

impl Wallet {
    pub fn send_req(&self, req: Req) {
        self.req_sender.send(req).unwrap();
    }
}

pub fn start(params: Params) -> Wallet {
    let (req_sender, req_receiver) = crossbeam_channel::unbounded();

    let req_sender_copy = req_sender.clone();
    std::thread::spawn(move || {
        run(params, req_sender_copy, req_receiver);
    });

    Wallet { req_sender }
}

fn run(
    params: Params,
    req_sender: crossbeam_channel::Sender<Req>,
    req_receiver: crossbeam_channel::Receiver<Req>,
) {
    let Params {
        env,
        mnemonic,
        work_dir,
        callback,
    } = params;

    let info = gdk_ses::LoginInfo {
        account_id: worker::ACCOUNT_ID_REG,
        env,
        cache_dir: work_dir,
        wallet_info: gdk_ses::WalletInfo::Mnemonic(mnemonic),
        single_sig: true,
        network: None,
        proxy: None,
    };

    let notif_callback = Box::new(move |_account_id, details| {
        req_sender.send(Req::Notif(details)).unwrap();
    });

    let mut wallet = gdk_ses_impl::start_processing(info, Some(notif_callback)).unwrap();

    wallet.login().unwrap();

    let policy_asset = AssetId::from_str(env.data().policy_asset).unwrap();

    let mut utxo_update_timestamp = Instant::now();
    let mut utxo_update_needed = true;

    loop {
        let req = req_receiver.recv().unwrap();
        match req {
            Req::Notif(_notif) => {
                utxo_update_needed = true;
            }

            Req::SignPset(sign) => {
                let details = sign.details;
                let amounts = if details.send_bitcoins {
                    sideswap_client::swaps::Amounts {
                        send_asset: policy_asset,
                        recv_asset: details.asset,
                        send_amount: (details.bitcoin_amount + details.server_fee) as u64,
                        recv_amount: details.asset_amount as u64,
                    }
                } else {
                    sideswap_client::swaps::Amounts {
                        send_asset: details.asset,
                        recv_asset: policy_asset,
                        send_amount: details.asset_amount as u64,
                        recv_amount: (details.bitcoin_amount - details.server_fee) as u64,
                    }
                };

                let sign_res = wallet.verify_and_sign_pset(
                    &amounts,
                    &sign.pset,
                    &sign.nonces.unwrap_or_default(),
                    &BTreeMap::new(),
                );

                match sign_res {
                    Ok(signed_pset) => {
                        callback(Resp::SignedPset(sign.order_id, signed_pset));
                    }
                    Err(err) => {
                        log::error!("pset sign failed: {}, order_id: {}", err, sign.order_id);
                        callback(Resp::PsetSignFailed(sign.order_id));
                    }
                }
            }

            Req::Timer => {}
        }

        if utxo_update_needed
            && Instant::now().duration_since(utxo_update_timestamp) > Duration::from_secs(10)
        {
            let swap_inputs = SwapInputs {
                recv_address: wallet.get_receive_address().unwrap().address,
                change_address: wallet.get_change_address().unwrap().address,
                utxos: wallet.get_utxos().unwrap().unspent_outputs,
            };
            callback(Resp::SwapInputs(swap_inputs));

            utxo_update_timestamp = Instant::now();
            utxo_update_needed = false;
        }
    }
}
