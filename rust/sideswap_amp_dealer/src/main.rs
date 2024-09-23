use std::collections::{BTreeMap, BTreeSet, HashSet};
use std::str::FromStr;
use std::time::{Duration, Instant};

use anyhow::{anyhow, bail, ensure};
use elements::pset::PartiallySignedTransaction;
use elements::AssetId;
use sideswap_amp::{SignPset, Utxo};
use sideswap_api::{
    Asset, AssetsRequestParam, CancelRequest, EditRequest, LoadPricesRequest, LoginRequest,
    Notification, OrderCreatedNotification, OrderId, PriceOrder, PsetMakerRequest,
    PsetTakerRequest, Request, ResolveGaidRequest, SignNotification, SignRequest, SubmitRequest,
    SubscribeRequest,
};
use sideswap_common::types::asset_int_amount;
use sideswap_common::{b64, make_request};
use sideswap_common::{
    coin_select,
    ws::{
        auto::{WrappedRequest, WrappedResponse},
        ws_req_sender::WsReqSender,
    },
};

#[derive(Debug, serde::Deserialize, Clone)]
struct OrderAmount {
    asset_id: AssetId,
    asset_amount: f64,
    is_asset_sell: bool,
    bitcoin_price: Option<f64>,
    usd_price: Option<f64>,
    #[serde(default)]
    take_only: bool,
}

#[derive(Debug, serde::Deserialize)]
struct Args {
    env: sideswap_common::env::Env,
    work_dir: String,
    mnemonic: String,
    order_amounts: Vec<OrderAmount>,
}

#[derive(Clone)]
struct Order {
    order_id: OrderId,
    submitted_utxos: Vec<Utxo>,
    price: f64,
}

struct OrderData {
    amount: OrderAmount,
    order: Option<Order>,
}

struct Data {
    policy_asset: AssetId,
    usdt_asset: AssetId,
    wallet: sideswap_amp::Wallet,
    ws: WsReqSender,
    gaid: Option<String>,
    consumed_utxos: HashSet<elements::OutPoint>,
    signed_utxos: BTreeMap<OrderId, Vec<elements::OutPoint>>,
    assets: Vec<Asset>,
    bitcoin_usdt_price: Option<f64>,
    public_orders: BTreeMap<OrderId, OrderCreatedNotification>,
    balances: BTreeMap<AssetId, u64>,
    order_takes: BTreeMap<OrderId, Instant>,
}

fn get_bitcoin_price(data: &Data, order_amount: &OrderAmount) -> Result<f64, anyhow::Error> {
    if let Some(bitcoin_price) = order_amount.bitcoin_price {
        Ok(bitcoin_price)
    } else if let Some(usd_price) = order_amount.usd_price {
        let bitcoin_usdt_price = data
            .bitcoin_usdt_price
            .ok_or_else(|| anyhow!("no base bitcoin price"))?;
        Ok(usd_price / bitcoin_usdt_price)
    } else {
        bail!("both bitcoin_price and usd_price empty")
    }
}

fn find_order<'a>(
    orders: &'a mut [OrderData],
    order_id: &OrderId,
) -> Result<&'a mut OrderData, anyhow::Error> {
    orders
        .iter_mut()
        .find(|order| {
            order
                .order
                .as_ref()
                .map(|order| order.order_id == *order_id)
                .unwrap_or(false)
        })
        .ok_or_else(|| anyhow!("order {order_id} not found"))
}

fn asset_precision(data: &Data, asset_id: &AssetId) -> Result<u8, anyhow::Error> {
    data.assets
        .iter()
        .find_map(|asset| (asset.asset_id == *asset_id).then_some(asset.precision))
        .ok_or_else(|| anyhow!("asset {asset_id} not found"))
}

async fn create_order(
    data: &mut Data,
    order_data: &mut OrderData,
    submitted_utxos: &HashSet<elements::OutPoint>,
) -> Result<(), anyhow::Error> {
    if order_data.order.is_some() || order_data.amount.take_only {
        return Ok(());
    }

    ensure!(data.ws.connected());
    let gaid = data
        .gaid
        .as_ref()
        .ok_or_else(|| anyhow!("wallet is not connected"))?;

    let price = get_bitcoin_price(data, &order_data.amount)?;
    let precision = asset_precision(data, &order_data.amount.asset_id)?;

    let (send_asset_id, amount_sign, target) = if order_data.amount.is_asset_sell {
        (
            order_data.amount.asset_id,
            -1.0,
            // Exact asset amount (because it won't change)
            asset_int_amount(order_data.amount.asset_amount, precision) as u64,
        )
    } else {
        (
            data.policy_asset,
            1.0,
            // Larger LBTC amount so we can edit (increase) the price later
            asset_int_amount(order_data.amount.asset_amount * price * 1.1, 8) as u64,
        )
    };

    let submit = make_request!(
        data.ws,
        Submit,
        SubmitRequest {
            order: PriceOrder {
                asset: order_data.amount.asset_id,
                bitcoin_amount: None,
                asset_amount: Some(order_data.amount.asset_amount * amount_sign),
                price: Some(price),
                index_price: None,
            },
        }
    )?;

    let all_utxos = data.wallet.unspent_outputs().await?;

    let asset_utxos = all_utxos
        .into_iter()
        .filter(|utxo| {
            utxo.tx_out_sec.asset == send_asset_id
                && utxo.tx_out_sec.asset_bf != elements::confidential::AssetBlindingFactor::zero()
                && utxo.tx_out_sec.value_bf != elements::confidential::ValueBlindingFactor::zero()
                && !data.consumed_utxos.contains(&utxo.outpoint)
                && !submitted_utxos.contains(&utxo.outpoint)
        })
        .collect::<Vec<_>>();

    let coins = asset_utxos
        .iter()
        .map(|utxo| utxo.tx_out_sec.value)
        .collect::<Vec<_>>();
    let available = coins.iter().sum::<u64>();
    if available < target {
        return Ok(());
    }
    let selected = coin_select::no_change_or_naive(target, &coins).expect("must not fail");
    let submitted_utxos = coin_select::take_utxos(asset_utxos, &selected).expect("must not fail");

    let inputs = submitted_utxos
        .iter()
        .map(|utxo| {
            let redeem_script = sideswap_amp::get_redeem_script(&utxo.prevout_script);

            sideswap_api::PsetInput {
                txid: utxo.outpoint.txid,
                vout: utxo.outpoint.vout,
                asset: utxo.tx_out_sec.asset,
                asset_bf: utxo.tx_out_sec.asset_bf,
                value: utxo.tx_out_sec.value,
                value_bf: utxo.tx_out_sec.value_bf,
                redeem_script: Some(redeem_script.into()),
            }
        })
        .collect::<Vec<_>>();

    let send_amount = if order_data.amount.is_asset_sell {
        submit.details.asset_amount
    } else {
        submit.details.bitcoin_amount + submit.details.server_fee
    };
    let input_amount = inputs.iter().map(|utxo| utxo.value).sum::<u64>();
    ensure!(input_amount >= send_amount as u64);

    let recv_addr = if order_data.amount.is_asset_sell {
        data.wallet.receive_address().await?
    } else {
        // TODO: Upload 1 CA address to the server after the ResolveGaid call
        make_request!(
            data.ws,
            ResolveGaid,
            ResolveGaidRequest {
                order_id: submit.order_id,
                gaid: gaid.clone(),
            }
        )?
        .address
    };
    let change_addr = data.wallet.receive_address().await?;

    make_request!(
        data.ws,
        PsetMaker,
        PsetMakerRequest {
            order_id: submit.order_id,
            price: submit.details.price,
            private: false,
            ttl_seconds: Some(604800), // 1 week
            inputs,
            recv_addr,
            change_addr,
            signed_half: None,
        }
    )?;

    order_data.order = Some(Order {
        order_id: submit.order_id,
        submitted_utxos,
        price,
    });

    Ok(())
}

fn price_diff(old: f64, new: f64) -> f64 {
    (new - old).abs() / old
}

async fn edit_order_price(
    data: &mut Data,
    order_data: &mut OrderData,
) -> Result<(), anyhow::Error> {
    let order = match order_data.order.as_mut() {
        Some(order) => order,
        None => return Ok(()),
    };

    let new_price = get_bitcoin_price(data, &order_data.amount)?;

    let price_diff = price_diff(order.price, new_price);

    if price_diff > 0.005 {
        make_request!(
            data.ws,
            Edit,
            EditRequest {
                order_id: order.order_id,
                price: Some(new_price),
                index_price: None,
            }
        )?;

        order.price = new_price;
    }

    Ok(())
}

async fn sign_order(data: &mut Data, sign: SignNotification) -> Result<(), anyhow::Error> {
    log::info!("sign order, order_id: {}", sign.order_id);

    let all_utxos = data.wallet.unspent_outputs().await?;

    let pset = b64::decode(&sign.pset)?;
    let pset = elements::encode::deserialize::<PartiallySignedTransaction>(&pset)?;

    let pset = data
        .wallet
        .sign_swap_pset(SignPset {
            pset,
            blinding_nonces: sign.nonces.unwrap_or_default(),
            used_utxos: all_utxos,
        })
        .await?;

    let signed_utxos = pset
        .extract_tx()?
        .input
        .iter()
        .map(|input| input.previous_output)
        .collect::<Vec<_>>();

    let pset = elements::encode::serialize(&pset);
    let pset = b64::encode(&pset);

    data.signed_utxos.insert(sign.order_id, signed_utxos);

    make_request!(
        data.ws,
        Sign,
        SignRequest {
            order_id: sign.order_id,
            signed_pset: pset,
            side: sign.details.side,
        }
    )?;

    Ok(())
}

fn order_to_take(data: &Data, submits: &[OrderData]) -> Option<OrderCreatedNotification> {
    let now = Instant::now();
    for order in data.public_orders.values() {
        if order.own.is_some() {
            continue;
        }

        let already_tried_recently = data
            .order_takes
            .get(&order.order_id)
            .map(|timestamp| now.duration_since(*timestamp) < Duration::from_secs(60))
            .unwrap_or(false);
        if already_tried_recently {
            continue;
        }

        let (send_asset, send_amount) = if order.details.send_bitcoins {
            (order.details.asset, order.details.asset_amount)
        } else {
            (
                data.policy_asset,
                order.details.bitcoin_amount + order.details.server_fee,
            )
        };
        let send_amount = send_amount as u64;
        let available = data.balances.get(&send_asset).copied().unwrap_or_default();
        if available < send_amount {
            continue;
        }

        let asset_precision = match asset_precision(data, &order.details.asset) {
            Ok(precision) => precision,
            Err(_) => continue,
        };

        for submit in submits.iter() {
            let submit_asset_amount = asset_int_amount(submit.amount.asset_amount, asset_precision);
            if submit.amount.is_asset_sell == order.details.send_bitcoins
                || submit_asset_amount < order.details.asset_amount
            {
                continue;
            }

            let submit_price = match get_bitcoin_price(data, &submit.amount) {
                Ok(price) => price,
                Err(_) => continue,
            };

            let price_acceptable = if submit.amount.is_asset_sell {
                order.details.price >= submit_price
            } else {
                order.details.price <= submit_price
            };
            if price_acceptable {
                return Some(order.clone());
            }
        }
    }
    None
}

async fn take_order(data: &mut Data, order: OrderCreatedNotification) -> Result<(), anyhow::Error> {
    data.order_takes.insert(order.order_id, Instant::now());

    let recv_addr = if !order.details.send_bitcoins {
        data.wallet.receive_address().await?
    } else {
        let gaid = data
            .gaid
            .as_ref()
            .ok_or_else(|| anyhow!("wallet is not connected"))?;

        // TODO: Upload 1 CA address to the server after the ResolveGaid call
        make_request!(
            data.ws,
            ResolveGaid,
            ResolveGaidRequest {
                order_id: order.order_id,
                gaid: gaid.clone(),
            }
        )?
        .address
    };

    let change_addr = data.wallet.receive_address().await?;

    let all_utxos = data.wallet.unspent_outputs().await?;

    let (send_asset_id, send_amount) = if order.details.send_bitcoins {
        (
            data.policy_asset,
            order.details.bitcoin_amount + order.details.server_fee,
        )
    } else {
        (order.details.asset, order.details.asset_amount)
    };
    let target = send_amount as u64;

    let asset_utxos = all_utxos
        .into_iter()
        .filter(|utxo| {
            utxo.tx_out_sec.asset == send_asset_id
                && utxo.tx_out_sec.asset_bf != elements::confidential::AssetBlindingFactor::zero()
                && utxo.tx_out_sec.value_bf != elements::confidential::ValueBlindingFactor::zero()
                && !data.consumed_utxos.contains(&utxo.outpoint)
        })
        .collect::<Vec<_>>();

    let coins = asset_utxos
        .iter()
        .map(|utxo| utxo.tx_out_sec.value)
        .collect::<Vec<_>>();
    let available = coins.iter().sum::<u64>();
    ensure!(available >= target);
    let selected = coin_select::no_change_or_naive(target, &coins).expect("must not fail");
    let selected_utxos = coin_select::take_utxos(asset_utxos, &selected).expect("must not fail");

    let inputs = selected_utxos
        .iter()
        .map(|utxo| {
            let redeem_script = sideswap_amp::get_redeem_script(&utxo.prevout_script);

            sideswap_api::PsetInput {
                txid: utxo.outpoint.txid,
                vout: utxo.outpoint.vout,
                asset: utxo.tx_out_sec.asset,
                asset_bf: utxo.tx_out_sec.asset_bf,
                value: utxo.tx_out_sec.value,
                value_bf: utxo.tx_out_sec.value_bf,
                redeem_script: Some(redeem_script.into()),
            }
        })
        .collect::<Vec<_>>();

    make_request!(
        data.ws,
        PsetTaker,
        PsetTakerRequest {
            order_id: order.order_id,
            price: order.details.price,
            inputs,
            recv_addr,
            change_addr,
        }
    )?;

    Ok(())
}

async fn update_orders(data: &mut Data, orders: &mut [OrderData]) {
    for index in 0..orders.len() {
        let submitted_utxos = orders
            .iter()
            .map(|order| order.order.iter())
            .flatten()
            .map(|order| order.submitted_utxos.iter())
            .flatten()
            .map(|utxo| utxo.outpoint)
            .collect::<HashSet<_>>();

        let order = &mut orders[index];

        let res = create_order(data, order, &submitted_utxos).await;
        if let Err(err) = res {
            log::error!("creating orders failed: {err}");
        }

        let res = edit_order_price(data, order).await;
        if let Err(err) = res {
            let order_id = order.order.as_ref().expect("must be set").order_id;
            log::info!("cancel order {order_id} because price edit failed: {err}");

            let res = make_request!(data.ws, Cancel, CancelRequest { order_id });
            if let Err(err) = res {
                log::warn!("order {order_id} cancel failed: {err}");
            }
        }
    }

    if let Some(order) = order_to_take(data, orders) {
        let res = take_order(data, order).await;
        match res {
            Ok(()) => {
                log::debug!("taking order succeed");
            }
            Err(err) => {
                log::warn!("taking order failed: {err}");
            }
        }
    }
}

async fn process_ws_notification(data: &mut Data, orders: &mut [OrderData], notif: Notification) {
    match notif {
        Notification::Sign(sign) => {
            log::info!("sign request, order_id: {}", sign.order_id);

            let res = sign_order(data, sign).await;
            if let Err(err) = res {
                log::error!("signing pset failed: {err}");
            }
        }

        Notification::OrderCreated(order) => {
            data.public_orders.insert(order.order_id, order);
        }

        Notification::OrderRemoved(order) => {
            data.public_orders.remove(&order.order_id);
        }

        Notification::Complete(details) => {
            let signed_utxos = data.signed_utxos.remove(&details.order_id);

            if let Some(txid) = details.txid {
                log::info!(
                    "order {} completed successfully, txid: {}",
                    details.order_id,
                    txid
                );
                for outpoint in signed_utxos.expect("must be set") {
                    data.consumed_utxos.insert(outpoint);
                }
            } else {
                log::info!("order {} complete unsuccessfully", details.order_id);
            }

            let order = find_order(orders, &details.order_id);
            if let Ok(order) = order {
                order.order.take();
            } else {
                // Sometimes removed notifications are sent without actual order
                log::debug!("can't find order {}", details.order_id);
            }
        }

        Notification::UpdatePrices(price) => {
            if price.asset == data.usdt_asset {
                data.bitcoin_usdt_price = price.ind;
            }
        }

        _ => {}
    }
}

async fn process_ws_msg(data: &mut Data, orders: &mut [OrderData], msg: WrappedResponse) {
    match msg {
        WrappedResponse::Connected => {
            log::debug!("ws connected");
            data.ws
                .send_request(Request::Login(LoginRequest { session_id: None }));

            let res = make_request!(
                data.ws,
                Assets,
                Some(AssetsRequestParam {
                    embedded_icons: Some(false),
                    all_assets: Some(true),
                    amp_asset_restrictions: Some(false),
                })
            );
            match res {
                Ok(assets) => {
                    log::info!("assets loaded: {}", assets.assets.len());
                    data.assets = assets.assets;
                }
                Err(err) => {
                    log::error!("loaded assets failed: {err}")
                }
            }

            let res = make_request!(
                data.ws,
                LoadPrices,
                LoadPricesRequest {
                    asset: data.usdt_asset
                }
            );
            match res {
                Ok(price) => {
                    data.bitcoin_usdt_price = price.ind;
                }
                Err(err) => {
                    log::error!("loading prices failed: {err}")
                }
            }

            data.public_orders.clear();

            let assets = orders
                .iter()
                .map(|order| order.amount.asset_id)
                .collect::<BTreeSet<_>>();
            for asset_id in assets {
                let res = make_request!(
                    data.ws,
                    Subscribe,
                    SubscribeRequest {
                        asset: Some(asset_id)
                    }
                );
                match res {
                    Ok(orders) => {
                        for order in orders.orders {
                            data.public_orders.insert(order.order_id, order);
                        }
                    }
                    Err(err) => {
                        log::error!("subscribing to asset failed: {err}")
                    }
                }
            }
        }

        WrappedResponse::Disconnected => {
            log::debug!("ws disconnected");
            for order in orders.iter_mut() {
                order.order = None;
            }
            data.bitcoin_usdt_price = None;
            data.public_orders.clear();
        }

        WrappedResponse::Response(msg) => match msg {
            sideswap_api::ResponseMessage::Response(_, _) => {}
            sideswap_api::ResponseMessage::Notification(notif) => {
                process_ws_notification(data, orders, notif).await;
            }
        },
    }
}

fn process_wallet_event(data: &mut Data, event: sideswap_amp::Event) {
    match event {
        sideswap_amp::Event::Connected {
            gaid,
            block_height: _,
        } => {
            log::debug!("wallet connected, gaid: {gaid}");
            data.gaid = Some(gaid);
        }
        sideswap_amp::Event::Disconnected => {
            data.gaid = None;
            data.balances.clear();
        }
        sideswap_amp::Event::BalanceUpdated { balances } => {
            log::debug!("balance updated: {balances:?}");
            data.balances = balances;
        }
        sideswap_amp::Event::NewBlock { .. } => {}
        sideswap_amp::Event::NewTx { .. } => {}
    }
}

#[tokio::main]
async fn main() -> Result<(), anyhow::Error> {
    let args = std::env::args().collect::<Vec<_>>();
    ensure!(
        args.len() == 2,
        "Specify a single argument for the config file path"
    );
    let config_path = &args[1];

    let mut conf = config::Config::new();
    conf.merge(config::File::with_name(config_path))?;
    conf.merge(config::Environment::with_prefix("app").separator("_"))?;
    let args: Args = conf.try_into()?;

    std::fs::create_dir_all(&args.work_dir)?;
    std::env::set_current_dir(&args.work_dir)?;

    sideswap_common::log_init::init_log(&args.work_dir);

    log::info!("started");

    let (req_sender, req_receiver) = tokio::sync::mpsc::unbounded_channel::<WrappedRequest>();
    let (resp_sender, resp_receiver) = tokio::sync::mpsc::unbounded_channel::<WrappedResponse>();
    let env_data = args.env.d();
    tokio::spawn(sideswap_common::ws::auto::run(
        args.env.base_server_ws_url(),
        req_receiver,
        resp_sender,
    ));

    let ws = WsReqSender::new(req_sender, resp_receiver);

    let mnemonic = bip39::Mnemonic::from_str(&args.mnemonic)?;
    let (wallet, mut wallet_events) = sideswap_amp::Wallet::new(mnemonic, env_data.network);

    let mut orders = args
        .order_amounts
        .iter()
        .cloned()
        .map(|order_amount| OrderData {
            amount: order_amount,
            order: None,
        })
        .collect::<Vec<_>>();

    let mut data = Data {
        policy_asset: env_data.network.d().policy_asset.asset_id(),
        usdt_asset: env_data.network.d().known_assets.usdt.asset_id(),
        wallet,
        ws,
        gaid: None,
        consumed_utxos: Default::default(),
        signed_utxos: Default::default(),
        assets: Vec::new(),
        bitcoin_usdt_price: None,
        public_orders: Default::default(),
        balances: Default::default(),
        order_takes: Default::default(),
    };

    let mut timer = tokio::time::interval(Duration::from_secs(1));

    loop {
        tokio::select! {
            ws_resp = data.ws.recv() => {
                process_ws_msg(&mut data, &mut orders, ws_resp).await;
            }

            event = wallet_events.recv() => {
                let event = event.expect("must be open");
                process_wallet_event(&mut data, event);
            },

            _ = timer.tick() => {
                update_orders(&mut data, &mut orders).await;
            },
        }
    }
}
