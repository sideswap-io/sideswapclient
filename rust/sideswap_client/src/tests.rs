use std::{
    collections::{BTreeMap, BTreeSet},
    sync::{mpsc, Arc},
};

use sideswap_common::env::Env;

use crate::{
    ffi::proto,
    worker::{self, AccountId, ACCOUNT_ID_AMP, ACCOUNT_ID_REG},
};

struct Data {
    msg_sender: mpsc::Sender<worker::Message>,
    from_receiver: mpsc::Receiver<proto::from::Msg>,
    server_connected: bool,
    balances: BTreeMap<AccountId, Vec<proto::Balance>>,
    own_orders: BTreeMap<u64, proto::OwnOrder>,
}

const LBTC: &str = "144c654344aa716d6f3abcc1ca90e5641e4e2a7f633bc09fe3baf64585819a49";
const USDT: &str = "b612eb46313a2cd6ebabd8b7a8eed5696e29898b87a43bff41c94f51acef9d73";
const SSWP: &str = "1f9f9319beeded3aa3751190ec9b2d77df570c3b9e6e84a4aa321c11331e0118";

impl Data {
    fn send(&self, msg: proto::to::Msg) {
        self.msg_sender.send(worker::Message::Ui(msg)).unwrap();
    }

    fn recv(&mut self) -> proto::from::Msg {
        let msg = self.from_receiver.recv().unwrap();

        match &msg {
            proto::from::Msg::BalanceUpdate(msg) => {
                self.balances.insert(msg.account.id, msg.balances.clone());
            }

            proto::from::Msg::OwnOrders(msg) => {
                self.own_orders = msg
                    .list
                    .iter()
                    .map(|order| (order.order_id.id, order.clone()))
                    .collect();
            }
            proto::from::Msg::OwnOrderCreated(msg) => {
                self.own_orders.insert(msg.order_id.id, msg.clone());
            }
            proto::from::Msg::OwnOrderRemoved(msg) => {
                self.own_orders.remove(&msg.id);
            }

            proto::from::Msg::ServerConnected(_) => {
                self.server_connected = true;
            }
            proto::from::Msg::ServerDisconnected(_) => {
                self.server_connected = false;
            }

            proto::from::Msg::Login(_)
            | proto::from::Msg::Logout(_)
            | proto::from::Msg::EnvSettings(_)
            | proto::from::Msg::RegisterAmp(_)
            | proto::from::Msg::UpdatedTxs(_)
            | proto::from::Msg::RemovedTxs(_)
            | proto::from::Msg::UpdatedPegs(_)
            | proto::from::Msg::NewAsset(_)
            | proto::from::Msg::AmpAssets(_)
            | proto::from::Msg::TokenMarketOrder(_)
            | proto::from::Msg::ServerStatus(_)
            | proto::from::Msg::PriceUpdate(_)
            | proto::from::Msg::WalletLoaded(_)
            | proto::from::Msg::SyncComplete(_)
            | proto::from::Msg::EncryptPin(_)
            | proto::from::Msg::DecryptPin(_)
            | proto::from::Msg::PeginWaitTx(_)
            | proto::from::Msg::PegOutAmount(_)
            | proto::from::Msg::SwapSucceed(_)
            | proto::from::Msg::SwapFailed(_)
            | proto::from::Msg::RecvAddress(_)
            | proto::from::Msg::CreateTxResult(_)
            | proto::from::Msg::SendResult(_)
            | proto::from::Msg::BlindedValues(_)
            | proto::from::Msg::LoadUtxos(_)
            | proto::from::Msg::LoadAddresses(_)
            | proto::from::Msg::RegisterPhone(_)
            | proto::from::Msg::VerifyPhone(_)
            | proto::from::Msg::UploadAvatar(_)
            | proto::from::Msg::UploadContacts(_)
            | proto::from::Msg::ContactCreated(_)
            | proto::from::Msg::ContactRemoved(_)
            | proto::from::Msg::ContactTransaction(_)
            | proto::from::Msg::AccountStatus(_)
            | proto::from::Msg::ShowMessage(_)
            | proto::from::Msg::InsufficientFunds(_)
            | proto::from::Msg::SubmitReview(_)
            | proto::from::Msg::SubmitResult(_)
            | proto::from::Msg::EditOrder(_)
            | proto::from::Msg::CancelOrder(_)
            | proto::from::Msg::StartTimer(_)
            | proto::from::Msg::OrderCreated(_)
            | proto::from::Msg::OrderRemoved(_)
            | proto::from::Msg::OrderComplete(_)
            | proto::from::Msg::IndexPrice(_)
            | proto::from::Msg::AssetDetails(_)
            | proto::from::Msg::UpdatePriceStream(_)
            | proto::from::Msg::LocalMessage(_)
            | proto::from::Msg::MarketDataSubscribe(_)
            | proto::from::Msg::MarketDataUpdate(_)
            | proto::from::Msg::PortfolioPrices(_)
            | proto::from::Msg::ConversionRates(_)
            | proto::from::Msg::JadePorts(_)
            | proto::from::Msg::JadeStatus(_)
            | proto::from::Msg::GaidStatus(_)
            | proto::from::Msg::MarketList(_)
            | proto::from::Msg::MarketAdded(_)
            | proto::from::Msg::MarketRemoved(_)
            | proto::from::Msg::PublicOrders(_)
            | proto::from::Msg::PublicOrderCreated(_)
            | proto::from::Msg::PublicOrderRemoved(_)
            | proto::from::Msg::MarketPrice(_)
            | proto::from::Msg::OrderSubmit(_)
            | proto::from::Msg::OrderEdit(_)
            | proto::from::Msg::OrderCancel(_)
            | proto::from::Msg::Quote(_)
            | proto::from::Msg::AcceptQuote(_)
            | proto::from::Msg::ChartsSubscribe(_)
            | proto::from::Msg::ChartsUpdate(_)
            | proto::from::Msg::LoadHistory(_)
            | proto::from::Msg::HistoryUpdated(_) => {}
        }

        msg
    }
}

fn start_wallet(wallet: proto::to::login::Wallet, work_dir: &str) -> Data {
    let (msg_sender, msg_receiver) = mpsc::channel::<worker::Message>();
    let (from_sender, from_receiver) = mpsc::channel::<proto::from::Msg>();

    let env = Env::LocalTestnet;

    let params = worker::StartParams {
        work_dir: work_dir.to_owned(),
        version: "1.0.0".to_owned(),
    };

    sideswap_common::log_init::init_log(&params.work_dir);

    let from_callback = Arc::new(move |msg| -> bool {
        let res = from_sender.send(msg);
        res.is_ok()
    });

    let msg_sender_copy = msg_sender.clone();
    std::thread::spawn(move || {
        worker::start_processing(env, msg_sender_copy, msg_receiver, from_callback, params);
    });

    let mut data = Data {
        msg_sender,
        from_receiver,
        server_connected: false,
        balances: BTreeMap::new(),
        own_orders: BTreeMap::new(),
    };

    data.send(proto::to::Msg::Login(proto::to::Login {
        phone_key: None,
        wallet: Some(wallet),
    }));

    loop {
        let msg = data.recv();
        if let proto::from::Msg::Login(msg) = msg {
            match msg.result.unwrap() {
                proto::from::login::Result::ErrorMsg(msg) => panic!("login failed: {msg}"),
                proto::from::login::Result::Success(_) => break,
            }
        }
    }

    let mut wallets = BTreeSet::new();
    while wallets.len() != 2 {
        let msg = data.recv();
        if let proto::from::Msg::BalanceUpdate(msg) = msg {
            let positive_balance = msg.balances.iter().any(|balance| balance.amount > 0);
            if positive_balance {
                match msg.account.id {
                    ACCOUNT_ID_REG | ACCOUNT_ID_AMP => {
                        wallets.insert(msg.account.id);
                    }
                    _ => panic!("unexpected account id: {}", msg.account.id),
                }
            }
        }
    }

    data
}

fn start_wallet_1() -> Data {
    start_wallet(
        proto::to::login::Wallet::Mnemonic(std::env::var("GDK_TESTNET_MNEMONIC").unwrap()),
        "/tmp/sideswap/test_work_dir_1",
    )
}

fn start_wallet_2() -> Data {
    start_wallet(
        proto::to::login::Wallet::Mnemonic(std::env::var("GDK_TESTNET_MNEMONIC_2").unwrap()),
        "/tmp/sideswap/test_work_dir_2",
    )
}

fn start_jade() -> Data {
    start_wallet(
        proto::to::login::Wallet::JadeId(std::env::var("GDK_TESTNET_JADE_ID").unwrap()),
        "/tmp/sideswap/test_work_dir_jade",
    )
}

fn submit_order(
    data: &mut Data,
    base: &str,
    quote: &str,
    base_amount: u64,
    price: f64,
    trade_dir: proto::TradeDir,
    two_step: bool,
) {
    data.send(proto::to::Msg::OrderSubmit(proto::to::OrderSubmit {
        asset_pair: proto::AssetPair {
            base: base.to_owned(),
            quote: quote.to_owned(),
        },
        base_amount,
        price,
        trade_dir: trade_dir.into(),
        ttl_seconds: Some(360),
        two_step,
        tx_chaining_allowed: Some(true),
        private: false,
    }));

    loop {
        let msg = data.recv();

        if let proto::from::Msg::OrderSubmit(msg) = msg {
            match msg.result.unwrap() {
                proto::from::order_submit::Result::SubmitSucceed(_) => {
                    log::info!("order submit succeed");
                    break;
                }
                proto::from::order_submit::Result::Error(err) => {
                    panic!("order submit failed: {err}");
                }
                proto::from::order_submit::Result::UnregisteredGaid(msg) => {
                    panic!("GAID is not allowed: {msg:?}");
                }
            }
        }
    }
}

fn make_swap(
    data: &mut Data,
    base: &str,
    quote: &str,
    asset_type: proto::AssetType,
    amount: u64,
    trade_dir: proto::TradeDir,
) {
    data.send(proto::to::Msg::StartQuotes(proto::to::StartQuotes {
        asset_pair: proto::AssetPair {
            base: base.to_owned(),
            quote: quote.to_owned(),
        },
        asset_type: asset_type.into(),
        amount,
        trade_dir: trade_dir.into(),
    }));

    let quote = loop {
        let msg = data.recv();
        if let proto::from::Msg::Quote(msg) = msg {
            match msg.result.unwrap() {
                proto::from::quote::Result::Success(quote) => break quote,
                proto::from::quote::Result::LowBalance(_) => {
                    panic!("unexpected LowBalance response");
                }
                proto::from::quote::Result::Error(err) => {
                    panic!("unexpected Error response: {err}");
                }
                proto::from::quote::Result::UnregisteredGaid(_) => {
                    panic!("unexpected UnregisteredGaid response");
                }
            }
        }
    };

    log::info!("accept quote, quote_id: {}...", quote.quote_id);
    data.send(proto::to::Msg::AcceptQuote(proto::to::AcceptQuote {
        quote_id: quote.quote_id,
    }));

    let txid = loop {
        let msg = data.recv();
        if let proto::from::Msg::AcceptQuote(msg) = msg {
            match msg.result.unwrap() {
                proto::from::accept_quote::Result::Success(msg) => {
                    log::info!("swap succeed, txid: {}", msg.txid);
                    break msg.txid;
                }
                proto::from::accept_quote::Result::Error(err) => panic!("swap failed: {err}"),
            }
        }
    };

    loop {
        let msg = data.recv();
        if let proto::from::Msg::UpdatedTxs(msg) = msg {
            let item = msg
                .items
                .iter()
                .find(|item| match item.item.as_ref().unwrap() {
                    proto::trans_item::Item::Tx(tx) => tx.txid == txid,
                    proto::trans_item::Item::Peg(_) => unreachable!(),
                });
            if let Some(item) = item {
                log::debug!("tx item received: {item:?}");
                break;
            };
        }
    }
}

fn payjoin(data: &mut Data, account_id: AccountId, asset_id: &str, amount: u64, address: &str) {
    data.send(proto::to::Msg::CreateTx(proto::CreateTx {
        addressees: vec![proto::AddressAmount {
            address: address.to_owned(),
            amount: amount as i64,
            asset_id: asset_id.to_string(),
        }],
        account: proto::Account { id: account_id },
        utxos: Vec::new(),
        fee_asset_id: Some(asset_id.to_owned()),
        deduct_fee_output: Some(0),
    }));

    let created = loop {
        let msg = data.recv();

        if let proto::from::Msg::CreateTxResult(msg) = msg {
            match msg.result.unwrap() {
                proto::from::create_tx_result::Result::ErrorMsg(err) => {
                    panic!("create tx failed: {err}")
                }
                proto::from::create_tx_result::Result::CreatedTx(created) => break created,
            }
        }
    };

    data.send(proto::to::Msg::SendTx(proto::to::SendTx {
        account: proto::Account { id: account_id },
        id: created.id,
    }));

    loop {
        let msg = data.recv();

        if let proto::from::Msg::SendResult(msg) = msg {
            match msg.result.unwrap() {
                proto::from::send_result::Result::ErrorMsg(err) => {
                    panic!("sending tx failed: {err}")
                }
                proto::from::send_result::Result::TxItem(tx) => {
                    log::debug!("send succeed, id: {}", tx.id);
                    break;
                }
            }
        }
    }
}

#[test]
fn sell_lbtc_for_usdt_wallet1() {
    let mut data = start_wallet_1();

    make_swap(
        &mut data,
        LBTC,
        USDT,
        proto::AssetType::Base,
        10000,
        proto::TradeDir::Sell,
    );
}

#[test]
fn buy_sswp_for_lbtc_wallet1() {
    let mut data = start_wallet_1();

    make_swap(
        &mut data,
        SSWP,
        LBTC,
        proto::AssetType::Base,
        10,
        proto::TradeDir::Buy,
    );
}

#[test]
fn swap_sswp_for_usdt_wallet1_wallet2() {
    let mut data1 = start_wallet_1();

    submit_order(
        &mut data1,
        SSWP,
        USDT,
        100,
        0.85,
        proto::TradeDir::Sell,
        false,
    );

    let mut data2 = start_wallet_2();

    make_swap(
        &mut data2,
        SSWP,
        USDT,
        proto::AssetType::Base,
        10,
        proto::TradeDir::Buy,
    );
}

#[test]
fn buy_lbtc_for_usdt_jade() {
    let mut data = start_jade();

    make_swap(
        &mut data,
        LBTC,
        USDT,
        proto::AssetType::Base,
        10000,
        proto::TradeDir::Buy,
    );
}

#[test]
fn sell_lbtc_for_usdt_jade() {
    let mut data = start_jade();

    make_swap(
        &mut data,
        LBTC,
        USDT,
        proto::AssetType::Base,
        10000,
        proto::TradeDir::Sell,
    );
}

#[test]
fn sell_usdt_for_lbtc_jade() {
    let mut data = start_jade();

    make_swap(
        &mut data,
        LBTC,
        USDT,
        proto::AssetType::Quote,
        950000000,
        proto::TradeDir::Sell,
    );
}

#[test]
fn buy_sswp_for_lbtc_jade() {
    let mut data = start_jade();

    make_swap(
        &mut data,
        SSWP,
        LBTC,
        proto::AssetType::Base,
        11,
        proto::TradeDir::Buy,
    );
}

#[test]
fn sell_sswp_for_lbtc_jade() {
    let mut data = start_jade();

    make_swap(
        &mut data,
        SSWP,
        LBTC,
        proto::AssetType::Base,
        3,
        proto::TradeDir::Sell,
    );
}

#[test]
fn buy_lbtc_for_usdt_offline_maker_wallet1() {
    let mut data = start_wallet_1();

    submit_order(
        &mut data,
        LBTC,
        USDT,
        10000,
        95000.0,
        proto::TradeDir::Buy,
        true,
    );
}

#[test]
fn buy_lbtc_for_usdt_offline_maker_jade() {
    let mut data = start_jade();

    submit_order(
        &mut data,
        LBTC,
        USDT,
        10000,
        95000.0,
        proto::TradeDir::Buy,
        true,
    );
}

#[test]
fn sell_usdt_for_lbtc_taker_wallet2() {
    let mut data = start_wallet_2();

    make_swap(
        &mut data,
        LBTC,
        USDT,
        proto::AssetType::Quote,
        950000000,
        proto::TradeDir::Buy,
    );
}

#[test]
fn sell_sswp_for_usdt_offline_wallet1() {
    let mut data = start_wallet_1();

    submit_order(&mut data, SSWP, USDT, 12, 0.95, proto::TradeDir::Sell, true);
}

#[test]
fn sell_sswp_for_usdt_offline_jade() {
    let mut data = start_jade();

    submit_order(&mut data, SSWP, USDT, 6, 0.95, proto::TradeDir::Sell, true);
}

#[test]
fn buy_lbtc_for_usdt_offline_jade() {
    let mut data1 = start_jade();

    submit_order(
        &mut data1,
        LBTC,
        USDT,
        10000,
        95000.0,
        proto::TradeDir::Buy,
        true,
    );
}

#[test]
fn send_payjoin_wallet1() {
    let mut data1 = start_wallet_1();

    payjoin(
        &mut data1,
        ACCOUNT_ID_REG,
        USDT,
        100000000,
        "vjU5WU5sQZVpuvY1GDHmjufQcBdRTS2yZKrCAQuBhBjxqVcKhHKN82YtBUiznTX9WQ5MSUUZaRBdG9Du",
    );
}

#[test]
fn send_payjoin_jade() {
    let mut data1 = start_jade();

    payjoin(
        &mut data1,
        ACCOUNT_ID_REG,
        USDT,
        100000000,
        "vjU5WU5sQZVpuvY1GDHmjufQcBdRTS2yZKrCAQuBhBjxqVcKhHKN82YtBUiznTX9WQ5MSUUZaRBdG9Du",
    );
}
