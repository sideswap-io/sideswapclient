use super::*;
use storage::TransferState;

struct Ratio {
    min: f64,
    norm: f64,
    max: f64,
}

#[derive(PartialEq, Debug)]
enum Balancing {
    None,
    Recv(f64),
    Send(f64),
}

#[derive(PartialEq, Debug)]
pub enum AssetBalancing {
    None,
    RecvBtc(f64),
    SendBtc(f64),
    RecvUsdt(f64),
    SendUsdt(f64),
}

const RATIO_BTC: Ratio = Ratio {
    min: 0.25,
    norm: 0.5,
    max: 0.75,
};
const RATIO_USDT: Ratio = Ratio {
    min: 0.25,
    norm: 0.5,
    max: 0.75,
};
const MIN_BALANCING_AMOUNT_USDT: f64 = 1000.0;

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

fn get_balancing_smaller(
    wallet_balance: f64,
    exchange_balance: f64,
    expected: &Ratio,
) -> Balancing {
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

fn get_balancing_bigger(
    asset_wallet_balance: f64,
    asset_exchange_balance: f64,
    other_wallet_balance: f64,
    other_exchange_balance: f64,
    from_other_to_asset_scale: f64,
) -> Balancing {
    let recv_amount = other_exchange_balance * from_other_to_asset_scale - asset_wallet_balance;
    let send_amount = other_wallet_balance * from_other_to_asset_scale - asset_exchange_balance;
    if recv_amount > 0.0 {
        Balancing::Recv(recv_amount)
    } else if send_amount > 0.0 {
        Balancing::Send(send_amount)
    } else {
        Balancing::None
    }
}

pub fn get_balancing(
    balance_wallet_bitcoin: f64,
    balance_exchange_bitcoin: f64,
    balance_wallet_usdt: f64,
    balance_exchange_usdt: f64,
    bitcoin_usdt_price: f64,
) -> AssetBalancing {
    if bitcoin_usdt_price == 0.0
        || balance_wallet_bitcoin == 0.0
        || balance_exchange_bitcoin == 0.0
        || balance_wallet_usdt == 0.0
        || balance_exchange_usdt == 0.0
    {
        return AssetBalancing::None;
    }

    let bitcoin_total = balance_wallet_bitcoin + balance_exchange_bitcoin;
    let usdt_total = balance_wallet_usdt + balance_exchange_usdt;
    let bitcoin_total_as_usdt = bitcoin_total * bitcoin_usdt_price;
    let bitcoin_smaller = bitcoin_total_as_usdt < usdt_total;

    // Balance smaller asset first
    let smaller_balancing = if bitcoin_smaller {
        get_balancing_smaller(balance_wallet_bitcoin, balance_exchange_bitcoin, &RATIO_BTC)
    } else {
        get_balancing_smaller(balance_wallet_usdt, balance_exchange_usdt, &RATIO_USDT)
    };

    let balancing = match smaller_balancing {
        Balancing::Recv(amount) if bitcoin_smaller => AssetBalancing::RecvBtc(amount),
        Balancing::Send(amount) if bitcoin_smaller => AssetBalancing::SendBtc(amount),
        Balancing::Recv(amount) => AssetBalancing::RecvUsdt(amount),
        Balancing::Send(amount) => AssetBalancing::SendUsdt(amount),
        Balancing::None => {
            let bigger_balancing = if bitcoin_smaller {
                get_balancing_bigger(
                    balance_wallet_usdt,
                    balance_exchange_usdt,
                    balance_wallet_bitcoin,
                    balance_exchange_bitcoin,
                    bitcoin_usdt_price,
                )
            } else {
                get_balancing_bigger(
                    balance_wallet_bitcoin,
                    balance_exchange_bitcoin,
                    balance_wallet_usdt,
                    balance_exchange_usdt,
                    1.0 / bitcoin_usdt_price,
                )
            };
            match bigger_balancing {
                Balancing::Recv(amount) if bitcoin_smaller => AssetBalancing::RecvUsdt(amount),
                Balancing::Send(amount) if bitcoin_smaller => AssetBalancing::SendUsdt(amount),
                Balancing::Recv(amount) => AssetBalancing::RecvBtc(amount),
                Balancing::Send(amount) => AssetBalancing::SendBtc(amount),
                Balancing::None => AssetBalancing::None,
            }
        }
    };
    let balancing_amount_usdt = match balancing {
        AssetBalancing::None => 0.0,
        AssetBalancing::RecvBtc(v) => v * bitcoin_usdt_price,
        AssetBalancing::SendBtc(v) => v * bitcoin_usdt_price,
        AssetBalancing::RecvUsdt(v) => v,
        AssetBalancing::SendUsdt(v) => v,
    };

    if balancing_amount_usdt < MIN_BALANCING_AMOUNT_USDT {
        AssetBalancing::None
    } else {
        balancing
    }
}

pub fn process_balancing(
    storage: &mut Storage,
    wallet_balances_confirmed: &WalletBalances,
    exchange_balances: &ExchangeBalances,
    module_connected: bool,
    rpc_http_client: &ureq::Agent,
    args: &Args,
    _mod_tx: &module::Sender,
    bf_sender: &crossbeam_channel::Sender<bitfinex_worker::Request>,
) {
    let bitfinex_currency_btc = &args.bitfinex_currency_btc;
    let bitfinex_currency_lbtc = &args.bitfinex_currency_lbtc;
    let bitfinex_currency_usdt = &args.bitfinex_currency_usdt;

    if let Some(balancing) = storage.balancing.as_mut() {
        match balancing.state {
            TransferState::SendUsdtNew => {
                let usdt_balance = wallet_balances_confirmed
                    .get(&DealerTicker::USDt)
                    .cloned()
                    .unwrap_or_default();
                let bitcoin_balance = wallet_balances_confirmed
                    .get(&DealerTicker::LBTC)
                    .cloned()
                    .unwrap_or_default();
                if usdt_balance >= balancing.amount.to_bitcoin()
                    && bitcoin_balance > 0.0
                    && module_connected
                {
                    let usdt_asset_id =
                        sideswap_api::AssetId::from_str(args.env.data().network.usdt_asset_id())
                            .unwrap();

                    let result = rpc::make_rpc_call(
                        rpc_http_client,
                        &args.rpc,
                        rpc::SendToAddressCall {
                            address: args.bitfinex_fund_address.clone(),
                            amount: balancing.amount.to_bitcoin(),
                            asset_id: usdt_asset_id,
                        },
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
                    bf_sender
                        .send(bitfinex_worker::Request::Withdraw(proto::to::Withdraw {
                            key: args.bitfinex_key.clone(),
                            secret: args.bitfinex_secret.clone(),
                            wallet: BITFINEX_WALLET_EXCHANGE.to_owned(),
                            method: BITFINEX_METHOD_USDT.to_owned(),
                            amount: balancing.amount.to_bitcoin(),
                            address: args.bitfinex_withdraw_address.to_string(),
                        }))
                        .unwrap();
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
                    .get(&DealerTicker::LBTC)
                    .cloned()
                    .unwrap_or_default();
                if bitcoin_balance >= balancing.amount.to_bitcoin() && module_connected {
                    let bitcoin_asset = AssetId::from_str(args.env.data().policy_asset).unwrap();
                    let result = rpc::make_rpc_call(
                        rpc_http_client,
                        &args.rpc,
                        rpc::SendToAddressCall {
                            address: args.bitfinex_fund_address.clone(),
                            amount: balancing.amount.to_bitcoin(),
                            asset_id: bitcoin_asset,
                        },
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
                    bf_sender
                        .send(bitfinex_worker::Request::Transfer(proto::to::Transfer {
                            key: args.bitfinex_key.clone(),
                            secret: args.bitfinex_secret.clone(),
                            from: BITFINEX_WALLET_EXCHANGE.to_owned(),
                            to: BITFINEX_WALLET_EXCHANGE.to_owned(),
                            currency: bitfinex_currency_lbtc.0.clone(),
                            currency_to: bitfinex_currency_btc.0.clone(),
                            amount: balancing.amount.to_bitcoin(),
                        }))
                        .unwrap();
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
                    bf_sender
                        .send(bitfinex_worker::Request::Transfer(proto::to::Transfer {
                            key: args.bitfinex_key.clone(),
                            secret: args.bitfinex_secret.clone(),
                            from: BITFINEX_WALLET_EXCHANGE.to_owned(),
                            to: BITFINEX_WALLET_EXCHANGE.to_owned(),
                            currency: bitfinex_currency_btc.0.clone(),
                            currency_to: bitfinex_currency_lbtc.0.clone(),
                            amount: balancing.amount.to_bitcoin(),
                        }))
                        .unwrap();
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
                    bf_sender
                        .send(bitfinex_worker::Request::Withdraw(proto::to::Withdraw {
                            key: args.bitfinex_key.clone(),
                            secret: args.bitfinex_secret.clone(),
                            wallet: BITFINEX_WALLET_EXCHANGE.to_owned(),
                            method: BITFINEX_METHOD_LBTC.to_owned(),
                            amount: balancing.amount.to_bitcoin(),
                            address: args.bitfinex_withdraw_address.to_string(),
                        }))
                        .unwrap();
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
                save_storage(storage, &args.storage_path);
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
                        item.transaction_id == *txid.to_string()
                            && item.status == BITFINEX_STATUS_COMPLETED
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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_balancing() {
        // Bitcoin is smaller
        assert_eq!(
            get_balancing(0.5, 0.5, 27500.0, 27500.0, 50000.0),
            AssetBalancing::None
        );
        assert_eq!(
            get_balancing(0.2, 0.8, 27500.0, 27500.0, 50000.0),
            AssetBalancing::RecvBtc(0.3)
        );
        assert_eq!(
            get_balancing(0.8, 0.2, 27500.0, 27500.0, 50000.0),
            AssetBalancing::SendBtc(0.3)
        );
        assert_eq!(
            get_balancing(0.3, 0.7, 10000.0, 45000.0, 50000.0),
            AssetBalancing::RecvUsdt(25000.0)
        );
        assert_eq!(
            get_balancing(0.7, 0.3, 10000.0, 45000.0, 50000.0),
            AssetBalancing::RecvUsdt(5000.0)
        );
        assert_eq!(
            get_balancing(0.3, 0.7, 34500.0, 15500.0, 50000.0),
            AssetBalancing::None
        );
        assert_eq!(
            get_balancing(0.7, 0.3, 15000.0, 35000.0, 50000.0),
            AssetBalancing::None
        );

        // USDt is smaller
        assert_eq!(
            get_balancing(0.5, 0.5, 22500.0, 22500.0, 50000.0),
            AssetBalancing::None
        );
        assert_eq!(
            get_balancing(0.5, 0.5, 5000.0, 40000.0, 50000.0),
            AssetBalancing::RecvUsdt(17500.0)
        );
        assert_eq!(
            get_balancing(0.5, 0.5, 40000.0, 5000.0, 50000.0),
            AssetBalancing::SendUsdt(17500.0)
        );
        assert_eq!(
            get_balancing(0.2, 0.8, 13500.0, 31500.0, 50000.0),
            AssetBalancing::RecvBtc(0.43)
        );
        assert_eq!(
            get_balancing(0.8, 0.2, 13500.0, 31500.0, 50000.0),
            AssetBalancing::SendBtc(0.07)
        );
        assert_eq!(
            get_balancing(0.7, 0.3, 13500.0, 31500.0, 50000.0),
            AssetBalancing::None
        );
        assert_eq!(
            get_balancing(0.3, 0.7, 31500.0, 13500.0, 50000.0),
            AssetBalancing::None
        );
    }
}
