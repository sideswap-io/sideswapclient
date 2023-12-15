use std::{
    collections::{BTreeMap, VecDeque},
    str::FromStr,
};

const MAX_QUEUE: usize = 5;

use crossbeam_channel::Receiver;
use log::*;
use sideswap_api::AssetId;
use sideswap_client::{
    ffi::{proto, send_msg, IntPtr},
    worker,
};
use sideswap_common::types::asset_float_amount;

use crate::{error::Error, NewOrder};

pub enum WorkerReq {
    NewOrder(
        NewOrder,
        tokio::sync::oneshot::Sender<Result<proto::Order, Error>>,
    ),
    FromMsg(proto::from::Msg),
}

struct PendingSubmit {
    order: NewOrder,
    res_sender: tokio::sync::oneshot::Sender<Result<proto::Order, Error>>,
}

fn process_new_order(
    client: IntPtr,
    order: &NewOrder,
    assets: &BTreeMap<AssetId, proto::Asset>,
) -> Result<(), Error> {
    let asset = assets
        .get(&order.asset_id)
        .ok_or_else(|| Error::UnknownAsset(order.asset_id))?;

    let account_id = if asset.amp_market {
        worker::ACCOUNT_ID_AMP
    } else {
        worker::ACCOUNT_ID_REG
    };

    let order_amount = asset_float_amount(order.asset_amount, asset.precision as u8);

    send_msg(
        client,
        proto::to::Msg::SubmitOrder(proto::to::SubmitOrder {
            account: proto::Account { id: account_id },
            asset_id: asset.asset_id.clone(),
            bitcoin_amount: None,
            asset_amount: Some(-order_amount),
            price: order.price,
            index_price: None,
        }),
    );

    Ok(())
}

pub fn run(
    client: IntPtr,
    req_receiver: Receiver<WorkerReq>,
    api_server: crate::api_server::Server,
) {
    let mut assets = BTreeMap::<AssetId, proto::Asset>::new();

    let mut pending_submits = VecDeque::<PendingSubmit>::new();

    let mut active_submit = Option::<PendingSubmit>::None;

    loop {
        let req = req_receiver.recv().unwrap();

        match req {
            WorkerReq::NewOrder(order, res_sender) => {
                if pending_submits.len() < MAX_QUEUE {
                    pending_submits.push_back(PendingSubmit { order, res_sender });
                } else {
                    let _ = res_sender.send(Err(Error::TooManyOrders));
                }
            }

            WorkerReq::FromMsg(msg) => match msg {
                proto::from::Msg::NewAsset(asset) => {
                    let asset_id = sideswap_api::AssetId::from_str(&asset.asset_id).unwrap();
                    assets.insert(asset_id, asset);
                }

                proto::from::Msg::SubmitReview(msg) => {
                    info!("accept swap, order_id: {}", msg.order_id);
                    let active_submit = active_submit.as_ref().unwrap();
                    send_msg(
                        client,
                        proto::to::Msg::SubmitDecision(proto::to::SubmitDecision {
                            order_id: msg.order_id,
                            accept: true,
                            auto_sign: Some(true),
                            private: active_submit.order.private,
                            ttl_seconds: active_submit.order.ttl_seconds,
                            two_step: Some(false),
                            tx_chaining_allowed: Some(false),
                            only_unused_utxos: Some(true),
                        }),
                    );
                }

                proto::from::Msg::SubmitResult(msg) => match msg.result.unwrap() {
                    proto::from::submit_result::Result::SubmitSucceed(_) => {}
                    proto::from::submit_result::Result::Error(err) => {
                        let active_submit = active_submit.take().unwrap();
                        let _ = active_submit.res_sender.send(Err(Error::SubmitFailed(err)));
                    }
                    proto::from::submit_result::Result::SwapSucceed(_) => {}
                    proto::from::submit_result::Result::UnregisteredGaid(err) => {
                        panic!("Unexpected error: {err:?}")
                    }
                },

                proto::from::Msg::InsufficientFunds(msg) => {
                    let active_submit = active_submit.take().unwrap();
                    let _ = active_submit.res_sender.send(Err(Error::InsufficientFunds {
                        required: msg.required,
                        available: msg.available,
                    }));
                }

                proto::from::Msg::OrderCreated(msg) => {
                    api_server.order_created(msg.clone());

                    let active_submit = active_submit.take().unwrap();
                    let _ = active_submit.res_sender.send(Ok(msg.order));
                }

                proto::from::Msg::OrderComplete(msg) => {
                    api_server.order_complete(msg.clone());
                }

                _ => {}
            },
        }

        if active_submit.is_none() && !pending_submits.is_empty() {
            let pending_submit = pending_submits.pop_front().unwrap();

            let res = process_new_order(client, &pending_submit.order, &assets);
            match res {
                Ok(()) => {
                    active_submit = Some(pending_submit);
                }
                Err(err) => {
                    let _ = pending_submit.res_sender.send(Err(err));
                }
            }
        }
    }
}
