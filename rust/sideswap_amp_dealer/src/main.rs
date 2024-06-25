#[macro_use]
extern crate log;

use std::collections::HashSet;
use std::str::FromStr;
use std::{collections::BTreeMap, time::Duration};

use anyhow::{anyhow, ensure};
use elements::pset::PartiallySignedTransaction;
use elements::{AssetId, OutPoint};
use sideswap_amp::{SignPset, Utxo};
use sideswap_api::{
    LoginRequest, Notification, OrderId, PriceOrder, PsetMakerRequest, Request, ResolveGaidRequest,
    Response, SignNotification, SignRequest, SubmitRequest,
};
use sideswap_common::b64;
use sideswap_common::ws::{
    auto::{WrappedRequest, WrappedResponse},
    ws_req_sender::WsReqSender,
};

#[derive(Debug, serde::Deserialize, Clone)]
struct SellAsset {
    asset_id: AssetId,
    interest: f64,
    amount: f64,
}

#[derive(Debug, serde::Deserialize)]
struct Args {
    env: sideswap_common::env::Env,
    work_dir: String,
    mnemonic: String,
    sell_assets: Vec<SellAsset>,
}

#[derive(Clone)]
struct Order {
    asset_id: AssetId,
    sell_asset: bool,
    all_utxos: Vec<Utxo>,
    used_utxos: Option<Vec<OutPoint>>,
}

struct AssetData {
    sell_asset: SellAsset,
}

struct Data {
    policy_asset: AssetId,
    wallet: sideswap_amp::Wallet,
    ws: WsReqSender,
    assets: BTreeMap<AssetId, AssetData>,
    gaid: Option<String>,
    orders: BTreeMap<OrderId, Order>,
    consumed_utxos: HashSet<elements::OutPoint>,
}

async fn create_orders(
    data: &mut Data,
    sell_asset: bool,
    asset: &SellAsset,
) -> Result<(), anyhow::Error> {
    ensure!(data.ws.connected());
    let gaid = data
        .gaid
        .as_ref()
        .ok_or_else(|| anyhow!("wallet is not connected"))?;

    let order_count = data
        .orders
        .values()
        .filter(|order| order.sell_asset == sell_asset && order.asset_id == asset.asset_id)
        .count();
    if order_count != 0 {
        return Ok(());
    }

    let asset_amount = asset.amount;
    let asset_sign = if sell_asset { -1.0 } else { 1.0 };
    let send_asset_id = if sell_asset {
        asset.asset_id
    } else {
        data.policy_asset
    };

    let index_price = if sell_asset {
        1.0 + asset.interest
    } else {
        1.0 - asset.interest
    };

    let res = data
        .ws
        .make_request(Request::Submit(SubmitRequest {
            order: PriceOrder {
                asset: asset.asset_id,
                bitcoin_amount: None,
                asset_amount: Some(asset_amount * asset_sign),
                price: None,
                index_price: Some(index_price),
            },
        }))
        .await?;
    let submit = if let Response::Submit(submit) = res {
        submit
    } else {
        panic!("unexpected response")
    };

    let utxos = data.wallet.unspent_outputs().await?;

    let utxos = utxos
        .into_iter()
        .filter(|utxo| {
            utxo.tx_out_sec.asset == send_asset_id
                && utxo.tx_out_sec.asset_bf != elements::confidential::AssetBlindingFactor::zero()
                && utxo.tx_out_sec.value_bf != elements::confidential::ValueBlindingFactor::zero()
                && !data.consumed_utxos.contains(&utxo.outpoint)
        })
        .collect::<Vec<_>>();

    let inputs = utxos
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
    ensure!(!inputs.is_empty());

    let send_amount = if sell_asset {
        submit.details.asset_amount
    } else {
        submit.details.bitcoin_amount + submit.details.server_fee
    };
    let input_amount = inputs.iter().map(|utxo| utxo.value).sum::<u64>();
    ensure!(input_amount >= send_amount as u64);

    let recv_addr = if sell_asset {
        data.wallet.receive_address().await?
    } else {
        // TODO: Upload 1 CA address to the server after the ResolveGaid call
        let resp = data
            .ws
            .make_request(Request::ResolveGaid(ResolveGaidRequest {
                order_id: submit.order_id,
                gaid: gaid.clone(),
            }))
            .await?;
        if let Response::ResolveGaid(resolved) = resp {
            resolved.address
        } else {
            panic!("unexpected response")
        }
    };
    let change_addr = data.wallet.receive_address().await?;

    data.ws
        .make_request(Request::PsetMaker(PsetMakerRequest {
            order_id: submit.order_id,
            price: submit.details.price,
            private: false,
            ttl_seconds: None,
            inputs,
            recv_addr,
            change_addr,
            signed_half: None,
        }))
        .await?;

    data.orders.insert(
        submit.order_id,
        Order {
            asset_id: asset.asset_id,
            sell_asset,
            all_utxos: utxos,
            used_utxos: None,
        },
    );

    Ok(())
}

async fn sign_order(data: &mut Data, sign: SignNotification) -> Result<(), anyhow::Error> {
    let order = data
        .orders
        .get_mut(&sign.order_id)
        .ok_or_else(|| anyhow!("order {} not found", sign.order_id))?;
    info!(
        "sign request for {}, sell asset: {}, order_id: {}",
        order.asset_id, order.sell_asset, sign.order_id
    );

    let pset = b64::decode(&sign.pset)?;
    let pset = elements::encode::deserialize::<PartiallySignedTransaction>(&pset)?;

    let pset = data
        .wallet
        .sign_swap_pset(SignPset {
            pset,
            blinding_nonces: sign.nonces.unwrap_or_default(),
            used_utxos: order.all_utxos.clone(),
        })
        .await?;

    let used_utxos = pset
        .extract_tx()?
        .input
        .iter()
        .map(|input| input.previous_output)
        .collect::<Vec<_>>();

    let pset = elements::encode::serialize(&pset);
    let pset = b64::encode(&pset);

    data.ws
        .make_request(Request::Sign(SignRequest {
            order_id: sign.order_id,
            signed_pset: pset,
            side: sign.details.side,
        }))
        .await?;

    order.used_utxos = Some(used_utxos);

    Ok(())
}

async fn create_all_orders(data: &mut Data) {
    let assets = data
        .assets
        .values()
        .map(|asset| asset.sell_asset.clone())
        .collect::<Vec<_>>();
    for asset in assets {
        for sell_asset in [true, false] {
            let res = create_orders(data, sell_asset, &asset).await;
            if let Err(err) = res {
                error!("creating orders failed: {}", err);
            }
        }
    }
}

async fn process_ws_notification(data: &mut Data, notif: Notification) {
    match notif {
        Notification::Sign(sign) => {
            info!("sign request, order_id: {}", sign.order_id);

            let res = sign_order(data, sign).await;
            if let Err(err) = res {
                error!("signing pset failed: {err}");
            }
        }

        Notification::Complete(details) => {
            let order = data.orders.remove(&details.order_id);
            if let Some(order) = order {
                if let Some(txid) = details.txid {
                    info!(
                        "order {} complete successfully, txid: {}",
                        details.order_id, txid
                    );
                    for outpoint in order.used_utxos.expect("must be set") {
                        data.consumed_utxos.insert(outpoint);
                    }
                } else {
                    info!("order {} complete unsuccessfully", details.order_id);
                }
            } else {
                // Sometimes removed notifications are sent without actual order
                debug!("can't find order {}", details.order_id);
            }
        }

        _ => {}
    }
}

async fn process_ws_msg(data: &mut Data, msg: WrappedResponse) {
    match msg {
        WrappedResponse::Connected => {
            debug!("ws connected");
            data.ws
                .send_request(Request::Login(LoginRequest { session_id: None }));
        }
        WrappedResponse::Disconnected => {
            debug!("ws disconnected");
            data.orders.clear();
        }
        WrappedResponse::Response(msg) => match msg {
            sideswap_api::ResponseMessage::Response(_, Ok(_resp)) => {}
            sideswap_api::ResponseMessage::Response(_, Err(err)) => {
                error!("response failed: {err}");
            }
            sideswap_api::ResponseMessage::Notification(notif) => {
                process_ws_notification(data, notif).await;
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
            debug!("wallet connected, gaid: {gaid}");
            data.gaid = Some(gaid);
        }
        sideswap_amp::Event::Disconnected => {
            data.gaid = None;
        }
        sideswap_amp::Event::BalanceUpdated { balances } => {
            debug!("balance updated: {balances:?}");
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

    info!("started");

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

    let assets = args
        .sell_assets
        .iter()
        .cloned()
        .map(|sell_asset| {
            assert!(sell_asset.interest > 0.0 && sell_asset.interest < 0.1);
            (sell_asset.asset_id, AssetData { sell_asset })
        })
        .collect::<BTreeMap<_, _>>();
    ensure!(
        assets.len() == args.sell_assets.len(),
        "Duplicated asset_id are not allowed"
    );

    let mut data = Data {
        policy_asset: env_data.network.d().policy_asset.asset_id(),
        wallet,
        ws,
        assets,
        gaid: None,
        orders: Default::default(),
        consumed_utxos: Default::default(),
    };

    let mut timer = tokio::time::interval(Duration::from_secs(10));

    loop {
        tokio::select! {
            ws_resp = data.ws.recv() => {
                process_ws_msg(&mut data, ws_resp).await;
            }

            event = wallet_events.recv() => {
                let event = event.expect("must be open");
                process_wallet_event(&mut data, event);
            },

            _ = timer.tick() => {
                create_all_orders(&mut data).await;
            },
        }
    }
}
