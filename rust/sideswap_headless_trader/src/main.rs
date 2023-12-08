use std::str::FromStr;

use log::*;
use sideswap_client::ffi::proto::*;
use sideswap_client::ffi::{blocking_recv_msg, send_msg};

mod api_server;

#[derive(Debug, serde::Deserialize, Clone)]
pub struct SellAsset {
    asset_id: sideswap_api::AssetId,
    price_usdt: f64,
    amp_asset: Option<bool>,
    asset_precision: u8,
    offer_amount: Option<f64>,
    private: Option<bool>,
}

#[derive(Debug, serde::Deserialize)]
pub struct Args {
    env: sideswap_common::env::Env,
    work_dir: String,
    mnemonic: String,
    sell_assets: Vec<SellAsset>,
    api_server: Option<api_server::Settings>,
}

pub struct SellAssetData {
    sell_asset: SellAsset,
    submit_time: Option<std::time::Instant>,
    order: Option<Order>,
    account_id: i32,
    asset_balance: Option<i64>,
}

fn main() {
    let matches = clap::App::new("sideswap_dealer")
        .arg(clap::Arg::with_name("config").required(true))
        .get_matches();
    let config_path = matches.value_of("config").unwrap();

    let mut conf = config::Config::new();
    conf.merge(config::File::with_name(config_path))
        .expect("can't load config");
    conf.merge(config::Environment::with_prefix("app").separator("_"))
        .expect("reading env failed");
    let args: Args = conf.try_into().expect("invalid config");

    let client = sideswap_client::ffi::sideswap_client_start(
        sideswap_client::ffi::get_env_from_ffi(args.env),
        std::ffi::CString::new(args.work_dir.clone())
            .unwrap()
            .as_c_str()
            .as_ptr(),
        std::ffi::CString::new("1.0.0").unwrap().as_c_str().as_ptr(),
        sideswap_client::ffi::SIDESWAP_DART_PORT_DISABLED,
    );
    assert!(client != 0);

    send_msg(
        client,
        to::Msg::Login(to::Login {
            wallet: Some(to::login::Wallet::Mnemonic(args.mnemonic.clone())),
            network: NetworkSettings {
                selected: Some(network_settings::Selected::Sideswap(Empty {})),
            },
            phone_key: None,
            send_utxo_updates: None,
            force_auto_sign_maker: None,
        }),
    );

    let usdt_asset_id =
        sideswap_api::AssetId::from_str(args.env.data().network.usdt_asset_id()).unwrap();
    let mut usdt_index_price = None;

    let mut asset_data = args
        .sell_assets
        .iter()
        .cloned()
        .map(|sell_asset| {
            let account_id = if sell_asset.amp_asset.unwrap_or_default() {
                sideswap_client::worker::ACCOUNT_ID_AMP
            } else {
                sideswap_client::worker::ACCOUNT_ID_REG
            };
            SellAssetData {
                sell_asset,
                submit_time: None,
                order: None,
                account_id,
                asset_balance: None,
            }
        })
        .collect::<Vec<_>>();

    let uniq_assets = args
        .sell_assets
        .iter()
        .map(|asset| asset.asset_id)
        .collect::<std::collections::BTreeSet<_>>();
    assert!(
        uniq_assets.len() == asset_data.len(),
        "Duplicated asset_id are not allowed"
    );

    let api_server = args.api_server.clone().map(api_server::Server::new);

    loop {
        let msg = blocking_recv_msg(client);
        let now = std::time::Instant::now();

        match msg {
            from::Msg::ServerConnected(_) => {
                info!("server connected");
                send_msg(
                    client,
                    to::Msg::SubscribePrice(AssetId {
                        asset_id: usdt_asset_id.to_string(),
                    }),
                );
            }

            from::Msg::ServerDisconnected(_) => {
                info!("server disconnected");
                usdt_index_price = None;
            }

            from::Msg::BalanceUpdate(msg) => {
                for balance in msg.balances {
                    for asset_data in asset_data.iter_mut() {
                        if balance.asset_id == asset_data.sell_asset.asset_id.to_string()
                            && msg.account.id == asset_data.account_id
                        {
                            asset_data.asset_balance = Some(balance.amount);
                        }
                    }
                }
            }

            from::Msg::NewAsset(msg) => {
                for asset_data in asset_data.iter_mut() {
                    if msg.asset_id == asset_data.sell_asset.asset_id.to_string() {
                        assert!(
                            msg.precision == u32::from(asset_data.sell_asset.asset_precision),
                            "wrong asset precision, asset_id: {}, precision: {}, expected: {}, please check config",
                            msg.asset_id,
                            asset_data.sell_asset.asset_precision,
                            msg.precision,
                        );
                    }
                }
            }

            from::Msg::IndexPrice(msg) => {
                let asset_id = sideswap_api::AssetId::from_str(&msg.asset_id).unwrap();
                if asset_id == usdt_asset_id {
                    usdt_index_price = msg.ind;
                }

                if let Some(usdt_index_price) = usdt_index_price {
                    for asset_data in asset_data.iter_mut() {
                        let price = asset_data.sell_asset.price_usdt / usdt_index_price;

                        if asset_data.order.is_none()
                            && asset_data
                                .submit_time
                                .map(|submit_time| {
                                    now.duration_since(submit_time)
                                        > std::time::Duration::from_secs(10)
                                })
                                .unwrap_or(true)
                            && asset_data.asset_balance.is_some()
                        {
                            info!(
                                "submit new order, asset_id: {}",
                                asset_data.sell_asset.asset_id
                            );

                            let order_amount = asset_data.sell_asset.offer_amount.unwrap_or(1.0);
                            assert!(order_amount > 0.0);
                            let wallet_amount = sideswap_common::types::asset_float_amount(
                                asset_data.asset_balance.unwrap(),
                                asset_data.sell_asset.asset_precision,
                            );
                            if wallet_amount >= order_amount {
                                send_msg(
                                    client,
                                    to::Msg::SubmitOrder(to::SubmitOrder {
                                        account: Account {
                                            id: asset_data.account_id,
                                        },
                                        asset_id: asset_data.sell_asset.asset_id.to_string(),
                                        bitcoin_amount: None,
                                        asset_amount: Some(-order_amount),
                                        price,
                                        index_price: None,
                                    }),
                                );
                            } else {
                                warn!(
                                    "low balance, asset_id {}, balance: {}, order amount: {}",
                                    asset_data.sell_asset.asset_id, wallet_amount, order_amount
                                );
                            }
                            asset_data.submit_time = Some(now);
                        }

                        if let Some(order) = asset_data.order.as_ref() {
                            if order.price != price {
                                send_msg(
                                    client,
                                    to::Msg::EditOrder(to::EditOrder {
                                        order_id: order.order_id.clone(),
                                        data: Some(to::edit_order::Data::Price(price)),
                                    }),
                                );
                            }
                        }
                    }
                }
            }

            from::Msg::SubmitReview(msg) => {
                info!("accept swap, order_id: {}", msg.order_id);
                let asset_id = sideswap_api::AssetId::from_str(&msg.asset).unwrap();
                let asset = asset_data
                    .iter()
                    .find(|asset| asset.sell_asset.asset_id == asset_id)
                    .expect("must be known");
                send_msg(
                    client,
                    to::Msg::SubmitDecision(to::SubmitDecision {
                        order_id: msg.order_id,
                        accept: true,
                        auto_sign: Some(true),
                        private: asset.sell_asset.private,
                        ttl_seconds: None,
                        two_step: Some(false),
                        tx_chaining_allowed: Some(false),
                    }),
                );
            }

            from::Msg::OrderCreated(msg) => {
                if let Some(api_server) = &api_server {
                    api_server.order_created(msg.clone());
                }

                if !msg.order.auto_sign {
                    // The order from the previous app start
                    warn!("cancel old order, order_id: {}", msg.order.order_id);
                    send_msg(
                        client,
                        to::Msg::CancelOrder(to::CancelOrder {
                            order_id: msg.order.order_id,
                        }),
                    );
                } else {
                    for asset_data in asset_data.iter_mut() {
                        if asset_data.sell_asset.asset_id.to_string() == msg.order.asset_id {
                            if asset_data.order.is_none() {
                                info!(
                                    "order created, order_id: {}, asset_id: {}",
                                    msg.order.order_id, msg.order.asset_id
                                );
                            }
                            asset_data.order = Some(msg.order);
                            break;
                        }
                    }
                }
            }
            from::Msg::OrderRemoved(msg) => {
                if let Some(api_server) = &api_server {
                    api_server.order_removed(msg.clone());
                }

                for asset_data in asset_data.iter_mut() {
                    if asset_data
                        .order
                        .as_ref()
                        .map(|order| order.order_id == msg.order_id)
                        .unwrap_or_default()
                    {
                        info!("order removed, order_id: {}", msg.order_id);
                        asset_data.order = None;
                        break;
                    }
                }
            }
            from::Msg::OrderComplete(msg) => {
                if let Some(txid) = msg.txid {
                    info!("swap succeed, txid: {}, order_id: {}", txid, msg.order_id);
                }
            }

            _ => {}
        }
    }
}
