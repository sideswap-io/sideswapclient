use std::{collections::BTreeSet, str::FromStr};

use headless_wallet_api::*;
use sideswap_client::{gdk_json, gdk_ses, gdk_ses_impl, worker};
use sideswap_common::env::Env;

mod headless_wallet_api;

fn get_req() -> Request {
    let mut req = String::new();
    let res = std::io::stdin().read_line(&mut req).unwrap();
    assert!(res > 0);
    log::debug!("req: {req}");
    serde_json::from_str::<Request>(&req).expect("must be valid")
}

fn send_resp(resp: Response) {
    let resp = serde_json::to_string(&resp).expect("must be valid");
    log::debug!("resp: {resp}");
    println!("{}", resp);
}

enum Msg {
    Req(Request),
    WalletNotif(sideswap_client::gdk_json::Notification),
}

struct State {
    wallet: Box<dyn gdk_ses::GdkSes>,
    need_refresh: bool,
    network_block_height: u32,
    reported: BTreeSet<elements::OutPoint>,
}

fn transaction_confs(tx: &gdk_json::Transaction, network_block_height: u32) -> u32 {
    if tx.block_height == 0 || network_block_height == 0 || tx.block_height > network_block_height {
        return 0;
    }
    network_block_height - tx.block_height + 1
}

fn reload_transactions(state: &mut State) {
    log::debug!("reload transactions...");
    let transactions_res = state.wallet.get_transactions_impl();
    let transactions = match transactions_res {
        Ok(transactions) => transactions,
        Err(err) => {
            log::error!("transactions loading failed: {err}");
            state.need_refresh = true;
            return;
        }
    };

    let (unconfirmed, confirmed) = transactions
        .into_iter()
        .partition::<Vec<_>, _>(|tx| transaction_confs(tx, state.network_block_height) <= 2);
    log::debug!("found unconfirmed: {}", unconfirmed.len());
    state.need_refresh = !unconfirmed.is_empty();

    for transaction in confirmed {
        for (vout, txout) in transaction.outputs.iter().enumerate() {
            let outpoint = elements::OutPoint {
                txid: transaction.txhash,
                vout: vout as u32,
            };
            if txout.is_relevant && !state.reported.contains(&outpoint) {
                let address = txout.address.as_ref().unwrap();
                let address = elements::Address::from_str(&address).unwrap();
                send_resp(Response::AddressOutput {
                    created_at: transaction.created_at_ts,
                    txid: transaction.txhash,
                    vout: vout as u32,
                    address,
                    asset_id: txout.asset_id.unwrap(),
                    satoshi: txout.satoshi.unwrap(),
                });
                state.reported.insert(outpoint);
            }
        }
    }
}

fn recv_address(state: &mut State) {
    let address = state.wallet.get_receive_address().unwrap().address;
    send_resp(Response::RecvAddress { address });
}

fn main() {
    send_resp(Response::Protocol {
        version: PROTOCOL_VERSION,
    });

    let login_req = get_req();

    let (work_dir, mnemonic, testnet) = match login_req {
        Request::Login {
            work_dir,
            mnemonic,
            testnet,
        } => (work_dir, mnemonic, testnet),
        _ => panic!("unexpected request, login request is expected"),
    };

    sideswap_client::ffi::init_log(&work_dir);

    std::panic::set_hook(Box::new(|i| {
        log::error!("sideswap panic detected: {:?}", i);
        std::process::abort();
    }));

    let env = if testnet { Env::Testnet } else { Env::Prod };

    let info = gdk_ses::LoginInfo {
        account_id: worker::ACCOUNT_ID_REG,
        env,
        cache_dir: work_dir,
        wallet_info: gdk_ses::WalletInfo::Mnemonic(mnemonic),
        single_sig: true,
        network: None,
        proxy: None,
    };

    let (msg_sender, msg_receiver) = crossbeam_channel::unbounded();

    let msg_sender_copy = msg_sender.clone();
    let notif_callback = Box::new(move |_account_id, details| {
        msg_sender_copy.send(Msg::WalletNotif(details)).unwrap();
    });

    let mut wallet = gdk_ses_impl::start_processing(info, Some(notif_callback)).unwrap();

    wallet.login().unwrap();

    let mut state = State {
        wallet,
        need_refresh: true,
        network_block_height: 0,
        reported: BTreeSet::new(),
    };

    let msg_sender_copy = msg_sender.clone();
    std::thread::spawn(move || loop {
        let req = get_req();
        msg_sender_copy.send(Msg::Req(req)).unwrap();
    });

    while let Ok(req) = msg_receiver.recv() {
        match req {
            Msg::Req(req) => match req {
                Request::Login { .. } => panic!("unexpected login request"),
                Request::RecvAddress { .. } => {
                    recv_address(&mut state);
                }
            },
            Msg::WalletNotif(notif) => {
                if let Some(block) = notif.block {
                    state.network_block_height = block.block_height;
                    if state.need_refresh {
                        reload_transactions(&mut state);
                    }
                }
                if let Some(_transaction) = notif.transaction {
                    reload_transactions(&mut state);
                }
                if let Some(_subaccount) = notif.subaccount {
                    reload_transactions(&mut state);
                }
            }
        }
    }
}
