use std::str::FromStr;

use log::*;
use sideswap_client::ffi::proto::*;
use sideswap_client::ffi::{blocking_recv_msg, send_msg};

#[derive(Debug, serde::Deserialize)]
pub struct Args {
    env: sideswap_common::env::Env,
    work_dir: String,
    mnemonic: String,
    order_count: usize,
    price_usdt: f64,
    trading_asset_id: sideswap_api::AssetId,
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
            mnemonic: args.mnemonic.clone(),
            phone_key: None,
            network: NetworkSettings {
                selected: Some(network_settings::Selected::Sideswap(Empty {})),
            },
            desktop: false,
            send_utxo_updates: Some(true),
        }),
    );

    // This will stop AMP account because we don't use it here
    send_msg(client, to::Msg::AppState(to::AppState { active: false }));

    let mut trading_utxo_count = 0;
    let mut connected = false;

    let usdt_asset_id =
        sideswap_api::AssetId::from_str(&args.env.data().network.usdt_asset_id()).unwrap();
    let mut usdt_index_price = None;
    let mut orders = std::collections::BTreeMap::<String, Order>::new();

    loop {
        let msg = blocking_recv_msg(client);

        match msg {
            from::Msg::UtxoUpdate(msg) => {
                trading_utxo_count = msg
                    .utxos
                    .iter()
                    .filter(|utxo| {
                        sideswap_api::AssetId::from_str(&utxo.asset_id).unwrap()
                            == args.trading_asset_id
                    })
                    .count();
            }

            from::Msg::ServerConnected(_) => {
                info!("server connected");
                connected = true;
                send_msg(
                    client,
                    to::Msg::SubscribePrice(AssetId {
                        asset_id: usdt_asset_id.to_string(),
                    }),
                );
            }

            from::Msg::ServerDisconnected(_) => {
                info!("server disconnected");
                connected = false;
                usdt_index_price = None;
            }

            from::Msg::IndexPrice(msg) => {
                let asset_id = sideswap_api::AssetId::from_str(&msg.asset_id).unwrap();
                if asset_id == usdt_asset_id {
                    usdt_index_price = msg.ind;
                }

                if connected {
                    if let Some(usdt_index_price) = usdt_index_price {
                        let price = args.price_usdt / usdt_index_price;
                        for _ in orders.len()..usize::min(trading_utxo_count, args.order_count) {
                            send_msg(
                                client,
                                to::Msg::SubmitOrder(to::SubmitOrder {
                                    account: Account { amp: false },
                                    asset_id: args.trading_asset_id.to_string(),
                                    bitcoin_amount: None,
                                    asset_amount: Some(-1.0),
                                    price,
                                    index_price: None,
                                }),
                            );
                        }
                        for order in orders.values() {
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
                } else {
                    for order in orders.values() {
                        send_msg(
                            client,
                            to::Msg::CancelOrder(to::CancelOrder {
                                order_id: order.order_id.clone(),
                            }),
                        );
                    }
                }
            }

            from::Msg::SubmitReview(msg) => send_msg(
                client,
                to::Msg::SubmitDecision(to::SubmitDecision {
                    order_id: msg.order_id,
                    accept: true,
                    auto_sign: Some(true),
                    private: Some(false),
                    ttl_seconds: None,
                }),
            ),

            from::Msg::OrderCreated(msg) => {
                orders.insert(msg.order.order_id.clone(), msg.order);
            }
            from::Msg::OrderRemoved(msg) => {
                orders.remove(&msg.order_id);
            }
            from::Msg::OrderComplete(msg) => {
                orders.remove(&msg.order_id);
            }

            _ => {}
        }
    }
}
