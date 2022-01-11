use super::*;
use storage::TransferState;

pub struct Ratio {
    min: f64,
    norm: f64,
    max: f64,
}

#[derive(PartialEq, Debug)]
pub enum Balancing {
    None,
    Send(f64),
    Recv(f64),
}

pub const RATIO_BTC: Ratio = Ratio {
    min: 0.25,
    norm: 0.4,
    max: 0.75,
};
pub const RATIO_USDT: Ratio = Ratio {
    min: 0.25,
    norm: 0.6,
    max: 0.75,
};

fn update_balancing_state(
    storage: &mut Storage,
    path: &str,
    new_state: TransferState,
    slack_url: &Option<String>,
) {
    let balancing = storage
        .balancing
        .as_mut()
        .expect("balancing must be active");
    balancing.updated_at = std::time::SystemTime::now();
    balancing.state = new_state;
    info!("new balancing state: {:?}", &balancing);
    if new_state == TransferState::Failed {
        send_notification(":fire: balancing failed", slack_url);
    } else if new_state == TransferState::Complete {
        send_notification("balancing complete", slack_url);
    }
    save_storage(storage, path);
}

pub fn get_balancing(wallet_balance: f64, exchange_balance: f64, expected: &Ratio) -> Balancing {
    // Something up with balance probably
    if wallet_balance == 0.0 || exchange_balance == 0.0 {
        return Balancing::None;
    }
    let total = wallet_balance + exchange_balance;
    let ratio = wallet_balance / total;
    assert!(expected.min > 0.0);
    assert!(expected.min < expected.norm);
    assert!(expected.norm < expected.max);
    assert!(expected.max < 1.0);
    let diff = Amount::from_bitcoin(f64::abs((expected.norm - ratio) * total)).to_bitcoin();
    if ratio < expected.min {
        Balancing::Recv(diff)
    } else if ratio > expected.max {
        Balancing::Send(diff)
    } else {
        Balancing::None
    }
}

pub fn process_balancing(
    storage: &mut Storage,
    wallet_balances_confirmed: &WalletBalances,
    exchange_balances: &ExchangeBalances,
    module_connected: bool,
    assets: &Assets,
    rpc_http_client: &reqwest::blocking::Client,
    args: &Args,
    mod_tx: &module::Sender,
) {
    let bitfinex_currency_btc = &args.bitfinex_currency_btc;
    let bitfinex_currency_lbtc = &args.bitfinex_currency_lbtc;
    let bitfinex_currency_usdt = &args.bitfinex_currency_usdt;

    if let Some(balancing) = storage.balancing.as_mut() {
        match balancing.state {
            TransferState::SendUsdtNew => {
                let usdt_balance = wallet_balances_confirmed
                    .get(&DEALER_USDT)
                    .cloned()
                    .unwrap_or_default();
                let bitcoin_balance = wallet_balances_confirmed
                    .get(&DEALER_LBTC)
                    .cloned()
                    .unwrap_or_default();
                if usdt_balance >= balancing.amount.to_bitcoin()
                    && bitcoin_balance > 0.0
                    && module_connected
                {
                    let asset = assets
                        .iter()
                        .find(|asset| asset.ticker.0 == TICKER_USDT)
                        .expect("must be known");
                    let result = rpc::make_rpc_call::<rpc::SendToAddressResult>(
                        &rpc_http_client,
                        &args.rpc,
                        &rpc::sendtoaddress_asset(
                            &args.bitfinex_fund_address,
                            balancing.amount.to_bitcoin(),
                            &asset.asset_id.to_string(),
                        ),
                    );
                    match result {
                        Ok(txid) => {
                            info!("sending to bitfinex succeed");
                            balancing.txid = Some(txid);
                            update_balancing_state(
                                storage,
                                &args.storage_path,
                                TransferState::SendUsdtWaitConfirm,
                                &args.notifications.url,
                            );
                        }
                        Err(e) => {
                            error!("sending to bitfinex failed: {}", e);
                            update_balancing_state(
                                storage,
                                &args.storage_path,
                                TransferState::Failed,
                                &args.notifications.url,
                            );
                        }
                    };
                }
            }
            TransferState::RecvUsdtNew => {
                let usdt_balance = exchange_balances
                    .get(bitfinex_currency_usdt)
                    .cloned()
                    .unwrap_or_default();
                if (usdt_balance >= balancing.amount.to_bitcoin() || !args.env.data().mainnet)
                    && module_connected
                {
                    send_msg(
                        &mod_tx,
                        proto::to::Msg::Withdraw(proto::to::Withdraw {
                            key: args.bitfinex_key.clone(),
                            secret: args.bitfinex_secret.clone(),
                            wallet: BITFINEX_WALLET_EXCHANGE.to_owned(),
                            method: BITFINEX_METHOD_USDT.to_owned(),
                            amount: balancing.amount.to_bitcoin(),
                            address: args.bitfinex_withdraw_address.clone(),
                        }),
                    );
                    update_balancing_state(
                        storage,
                        &args.storage_path,
                        TransferState::RecvUsdtWaitWithdrawId,
                        &args.notifications.url,
                    );
                }
            }

            TransferState::SendBtcNew => {
                let bitcoin_balance = wallet_balances_confirmed
                    .get(&DEALER_LBTC)
                    .cloned()
                    .unwrap_or_default();
                if bitcoin_balance >= balancing.amount.to_bitcoin() && module_connected {
                    let result = rpc::make_rpc_call::<rpc::SendToAddressResult>(
                        &rpc_http_client,
                        &args.rpc,
                        &rpc::sendtoaddress_bitcoin(
                            &args.bitfinex_fund_address,
                            balancing.amount.to_bitcoin(),
                        ),
                    );
                    match result {
                        Ok(txid) => {
                            info!("sending to bitfinex succeed");
                            balancing.txid = Some(txid);
                            update_balancing_state(
                                storage,
                                &args.storage_path,
                                TransferState::SendBtcWaitLbtcBalance,
                                &args.notifications.url,
                            );
                        }
                        Err(e) => {
                            error!("sending to bitfinex failed: {}", e);
                            update_balancing_state(
                                storage,
                                &args.storage_path,
                                TransferState::Failed,
                                &args.notifications.url,
                            );
                        }
                    };
                }
            }

            TransferState::SendBtcWaitLbtcBalance => {
                let lbtc_balance = exchange_balances
                    .get(bitfinex_currency_lbtc)
                    .cloned()
                    .unwrap_or_default();
                if lbtc_balance == balancing.amount.to_bitcoin() && module_connected {
                    send_msg(
                        &mod_tx,
                        proto::to::Msg::Transfer(proto::to::Transfer {
                            key: args.bitfinex_key.clone(),
                            secret: args.bitfinex_secret.clone(),
                            from: BITFINEX_WALLET_EXCHANGE.to_owned(),
                            to: BITFINEX_WALLET_EXCHANGE.to_owned(),
                            currency: bitfinex_currency_lbtc.0.clone(),
                            currency_to: bitfinex_currency_btc.0.clone(),
                            amount: balancing.amount.to_bitcoin(),
                        }),
                    );
                    update_balancing_state(
                        storage,
                        &args.storage_path,
                        TransferState::SendBtcWaitConfirm,
                        &args.notifications.url,
                    );
                }
            }

            TransferState::SendBtcWaitConfirm => {
                let lbtc_balance = exchange_balances.get(bitfinex_currency_lbtc).cloned();
                // TODO: Use more elaborate check
                if lbtc_balance == Some(0.0) {
                    update_balancing_state(
                        storage,
                        &args.storage_path,
                        TransferState::Complete,
                        &args.notifications.url,
                    );
                }
            }

            TransferState::RecvBtcNew => {
                let btc_balance = exchange_balances
                    .get(bitfinex_currency_btc)
                    .cloned()
                    .unwrap_or_default();
                if (btc_balance >= balancing.amount.to_bitcoin() || !args.env.data().mainnet)
                    && module_connected
                {
                    send_msg(
                        &mod_tx,
                        proto::to::Msg::Transfer(proto::to::Transfer {
                            key: args.bitfinex_key.clone(),
                            secret: args.bitfinex_secret.clone(),
                            from: BITFINEX_WALLET_EXCHANGE.to_owned(),
                            to: BITFINEX_WALLET_EXCHANGE.to_owned(),
                            currency: bitfinex_currency_btc.0.clone(),
                            currency_to: bitfinex_currency_lbtc.0.clone(),
                            amount: balancing.amount.to_bitcoin(),
                        }),
                    );
                    update_balancing_state(
                        storage,
                        &args.storage_path,
                        TransferState::RecvBtcWaitLbtcBalance,
                        &args.notifications.url,
                    );
                }
            }
            TransferState::RecvBtcWaitLbtcBalance => {
                let lbtc_balance = exchange_balances
                    .get(bitfinex_currency_lbtc)
                    .cloned()
                    .unwrap_or_default();
                if lbtc_balance == balancing.amount.to_bitcoin() && module_connected {
                    send_msg(
                        &mod_tx,
                        proto::to::Msg::Withdraw(proto::to::Withdraw {
                            key: args.bitfinex_key.clone(),
                            secret: args.bitfinex_secret.clone(),
                            wallet: BITFINEX_WALLET_EXCHANGE.to_owned(),
                            method: BITFINEX_METHOD_LBTC.to_owned(),
                            amount: balancing.amount.to_bitcoin(),
                            address: args.bitfinex_withdraw_address.clone(),
                        }),
                    );
                    update_balancing_state(
                        storage,
                        &args.storage_path,
                        TransferState::RecvBtcWaitWithdrawId,
                        &args.notifications.url,
                    );
                }
            }
            TransferState::Complete => {
                info!("balancing complete");
                storage.balancing = None;
                save_storage(&storage, &args.storage_path);
            }
            _ => {}
        }
    }
}

pub fn process_withdraw(storage: &mut Storage, msg: proto::from::Withdraw, args: &Args) {
    info!("withdraw result received, withdraw_id: {}", msg.withdraw_id);
    if let Some(balancing) = storage.balancing.as_mut() {
        match balancing.state {
            TransferState::RecvUsdtWaitWithdrawId
                if msg.withdraw_id > 0 && balancing.withdraw_id.is_none() =>
            {
                info!("withdraw_id updated");
                balancing.withdraw_id = Some(msg.withdraw_id);
                update_balancing_state(
                    storage,
                    &args.storage_path,
                    TransferState::RecvUsdtWaitConfirm,
                    &args.notifications.url,
                );
            }
            TransferState::RecvBtcWaitWithdrawId
                if msg.withdraw_id > 0 && balancing.withdraw_id.is_none() =>
            {
                info!("withdraw_id updated");
                balancing.withdraw_id = Some(msg.withdraw_id);
                update_balancing_state(
                    storage,
                    &args.storage_path,
                    TransferState::RecvBtcWaitConfirm,
                    &args.notifications.url,
                );
            }
            _ => {
                error!("withdraw failed or unexpected: {:?}", &msg);
                update_balancing_state(
                    storage,
                    &args.storage_path,
                    TransferState::Failed,
                    &args.notifications.url,
                );
            }
        }
    } else {
        error!("unexpected withdraw response - no active balancing found");
    }
}

pub fn process_movements(
    storage: &mut Storage,
    msg: proto::from::Movements,
    args: &Args,
    movements: &mut Option<proto::from::Movements>,
) {
    if !msg.success {
        error!("loading movements failed");
        return;
    }
    if Some(&msg) != movements.as_ref() {
        *movements = Some(msg.clone());
        debug!("movements updated: {:?}", &msg);
        return;
    }
    if let Some(balancing) = storage.balancing.as_mut() {
        match balancing.state {
            TransferState::SendUsdtWaitConfirm => {
                let txid = balancing.txid.as_ref().expect("txid must be known");
                let tx_found = msg
                    .movements
                    .iter()
                    .find(|item| {
                        item.transaction_id == *txid && item.status == BITFINEX_STATUS_COMPLETED
                    })
                    .is_some();
                if tx_found {
                    update_balancing_state(
                        storage,
                        &args.storage_path,
                        TransferState::Complete,
                        &args.notifications.url,
                    );
                }
            }
            TransferState::RecvUsdtWaitConfirm => {
                let tx_found = msg
                    .movements
                    .iter()
                    .find(|item| {
                        Some(item.id) == balancing.withdraw_id
                            && item.status == BITFINEX_STATUS_COMPLETED
                    })
                    .is_some();
                // TODO: wait for actual transaction?
                if tx_found {
                    update_balancing_state(
                        storage,
                        &args.storage_path,
                        TransferState::Complete,
                        &args.notifications.url,
                    );
                }
            }
            TransferState::RecvBtcWaitConfirm => {
                let tx_found = msg
                    .movements
                    .iter()
                    .find(|item| {
                        Some(item.id) == balancing.withdraw_id
                            && item.status == BITFINEX_STATUS_COMPLETED
                    })
                    .is_some();
                // TODO: wait for actual transaction?
                if tx_found {
                    update_balancing_state(
                        storage,
                        &args.storage_path,
                        TransferState::Complete,
                        &args.notifications.url,
                    );
                }
            }
            _ => debug!("ignore movements"),
        }
    }
}

pub fn process_transfer(storage: &mut Storage, msg: proto::from::Transfer, args: &Args) {
    debug!("transfer result: {:?}", &msg);
    if storage.balancing.is_some() {
        if !msg.success {
            update_balancing_state(
                storage,
                &args.storage_path,
                TransferState::Failed,
                &args.notifications.url,
            );
        }
    } else {
        warn!("ignore transfer result")
    }
}
