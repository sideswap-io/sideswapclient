use std::{
    collections::{BTreeMap, HashSet},
    str::FromStr,
};

use rand::seq::SliceRandom;
use sideswap_api::RequestId;
use sideswap_common::{env::Env, ws::manual as ws};
use tokio::sync::oneshot;

use crate::{
    api_server::{self, NewOrder},
    wallet,
};

pub enum Req {
    ApiServer(api_server::Req),
    Wallet(wallet::Resp),
    Ws(ws::WrappedResponse),
}

type AsyncRequest = Box<dyn FnOnce(&mut Data, Result<sideswap_api::Response, sideswap_api::Error>)>;

enum OrderState {
    Active(Vec<elements::OutPoint>),
    Succeed(Vec<elements::OutPoint>, sideswap_api::Txid),
    Failed,
}

struct Data {
    env: Env,
    policy_asset: sideswap_api::AssetId,
    session_id: sideswap_api::SessionId,
    ws_connected: bool,
    async_requests: BTreeMap<RequestId, AsyncRequest>,
    ws_sender: crossbeam_channel::Sender<ws::WrappedRequest>,
    wallet: wallet::Wallet,
    orders: BTreeMap<sideswap_api::OrderId, OrderState>,
    swap_inputs: Option<wallet::SwapInputs>,
    unique_orders: BTreeMap<String, sideswap_api::OrderId>,
    sign_request_count: usize,
}

fn request_ws_connect(data: &mut Data) {
    let env_data = data.env.data();
    let ws_connect = ws::WrappedRequest::Connect {
        host: env_data.host.to_owned(),
        port: env_data.port,
        use_tls: env_data.use_tls,
    };
    data.ws_sender.send(ws_connect).unwrap();
}

fn send_request(data: &Data, req: sideswap_api::Request) {
    if data.ws_connected {
        let request_id = sideswap_common::ws::next_request_id_str();
        data.ws_sender
            .send(ws::WrappedRequest::Request(
                sideswap_api::RequestMessage::Request(request_id.clone(), req),
            ))
            .unwrap();
    }
}

fn make_async_request(
    data: &mut Data,
    req: sideswap_api::Request,
    callback: impl FnOnce(&mut Data, Result<sideswap_api::Response, sideswap_api::Error>) + 'static,
) {
    if !data.ws_connected {
        callback(
            data,
            Err(sideswap_api::Error {
                code: sideswap_api::ErrorCode::ServerError,
                message: "Not connected".to_owned(),
            }),
        );
        return;
    }

    let request_id = sideswap_common::ws::next_request_id_str();
    data.ws_sender
        .send(ws::WrappedRequest::Request(
            sideswap_api::RequestMessage::Request(request_id.clone(), req),
        ))
        .unwrap();
    data.async_requests.insert(request_id, Box::new(callback));
}

fn process_wallet(data: &mut Data, resp: wallet::Resp) {
    match resp {
        wallet::Resp::SwapInputs(swap_inputs) => {
            log::debug!("update swap inputs ...");
            data.swap_inputs = Some(swap_inputs);
        }
        wallet::Resp::SignedPset(order_id, signed_pset) => {
            data.sign_request_count -= 1;
            log::debug!("got signed pset...");
            make_async_request(
                data,
                sideswap_api::Request::Sign(sideswap_api::SignRequest {
                    order_id,
                    signed_pset,
                    side: sideswap_api::OrderSide::Maker,
                }),
                move |data, res| match res {
                    Ok(sideswap_api::Response::Sign(_)) => {
                        log::debug!("signing order succeed");
                    }
                    Ok(_) => panic!("unexpected response"),
                    Err(err) => {
                        log::error!("signing order failed: {}", err.message);
                        cancel_order(data, order_id);
                    }
                },
            );
        }
        wallet::Resp::PsetSignFailed(order_id) => {
            data.sign_request_count -= 1;
            log::debug!("got pset sign failed notification, order_id: {order_id}");
            cancel_order(data, order_id);
        }
    }
}

fn get_order_status(
    data: &mut Data,
    order_id: sideswap_api::OrderId,
) -> Result<api_server::OrderStatus, api_server::Error> {
    let order_state = data.orders.get(&order_id);
    let status = match order_state {
        Some(OrderState::Active(_)) => api_server::OrderStatus {
            status: api_server::Status::Active,
            txid: None,
        },
        Some(OrderState::Succeed(_, txid)) => api_server::OrderStatus {
            status: api_server::Status::Succeed,
            txid: Some(*txid),
        },
        Some(OrderState::Failed) | None => api_server::OrderStatus {
            status: api_server::Status::Expired,
            txid: None,
        },
    };
    Ok(status)
}

fn cancel_order(data: &mut Data, order_id: sideswap_api::OrderId) {
    data.orders.insert(order_id, OrderState::Failed);
    send_request(
        data,
        sideswap_api::Request::Cancel(sideswap_api::CancelRequest { order_id }),
    );
}

fn process_submit_inputs(
    data: &mut Data,
    submit_resp: sideswap_api::SubmitResponse,
    new_order: NewOrder,
    res_sender: oneshot::Sender<Result<api_server::OrderInfo, api_server::Error>>,
) {
    let order_id = submit_resp.order_id;
    let details = submit_resp.details;
    log::debug!("order created: {order_id}");

    let swap_inputs = match data.swap_inputs.as_ref() {
        Some(swap_inputs) => swap_inputs,
        None => {
            log::error!("not swap inputs");
            cancel_order(data, order_id);
            let _ = res_sender.send(Err(api_server::Error::NotInputs));
            return;
        }
    };

    let (send_asset, send_amount) = if details.send_bitcoins {
        (
            data.policy_asset,
            details.bitcoin_amount + details.server_fee,
        )
    } else {
        (details.asset, details.asset_amount)
    };

    let reserved = data
        .orders
        .values()
        .filter_map(|order| match order {
            OrderState::Active(inputs) => Some(inputs.iter()),
            OrderState::Succeed(inputs, _) => Some(inputs.iter()),
            OrderState::Failed => None,
        })
        .flatten()
        .copied()
        .collect::<HashSet<_>>();

    let mut inputs = swap_inputs
        .utxos
        .get(&send_asset)
        .cloned()
        .unwrap_or_default();

    inputs.retain(|input| {
        !reserved.contains(&elements::OutPoint {
            txid: input.txhash,
            vout: input.vout,
        })
    });

    inputs.shuffle(&mut rand::thread_rng());

    let inputs_amount = inputs.iter().map(|input| input.satoshi).sum::<u64>() as i64;

    let inputs = inputs
        .into_iter()
        .map(|input| {
            (
                input.satoshi as i64,
                sideswap_client::worker::convert_to_swap_utxo(input),
            )
        })
        .collect::<Vec<_>>();

    if inputs_amount < send_amount {
        log::error!("not enough UTXOs, send_amount: {send_amount}, inputs_amount: {inputs_amount}");
        cancel_order(data, order_id);
        let _ = res_sender.send(Err(api_server::Error::NotInputs));
        return;
    }
    let inputs = sideswap_common::types::select_utxo_values(inputs, send_amount);

    let utxos = inputs
        .iter()
        .map(|input| elements::OutPoint {
            txid: input.txid,
            vout: input.vout,
        })
        .collect::<Vec<_>>();

    data.orders.insert(order_id, OrderState::Active(utxos));

    make_async_request(
        data,
        sideswap_api::Request::PsetMaker(sideswap_api::PsetMakerRequest {
            order_id,
            price: details.price,
            inputs,
            recv_addr: swap_inputs.recv_address.clone(),
            change_addr: swap_inputs.change_address.clone(),
            private: true,
            ttl_seconds: new_order.ttl_seconds,
            signed_half: None,
        }),
        move |data, res| match res {
            Ok(sideswap_api::Response::PsetMaker(_)) => {
                log::debug!("submitting pset details succeed");

                if let Some(unique_key) = new_order.unique_key {
                    if let Some(existing_order_id) = data.unique_orders.get(&unique_key) {
                        let is_allowed = match data.orders.get(&existing_order_id) {
                            Some(OrderState::Active(_)) => false,
                            Some(OrderState::Succeed(_, _)) => false,
                            Some(OrderState::Failed) => true,
                            None => true,
                        };

                        if !is_allowed {
                            let _ = res_sender.send(Err(api_server::Error::DuplicatedOrder));
                            cancel_order(data, order_id);
                            return;
                        }
                    }

                    data.unique_orders.insert(unique_key, order_id);
                }

                let _ = res_sender.send(Ok(api_server::OrderInfo {
                    order_id: order_id,
                    asset_id: details.asset,
                    bitcoin_amount: details.bitcoin_amount,
                    asset_amount: details.asset_amount,
                    price: details.price,
                    private: true,
                }));
            }
            Ok(_) => panic!("unexpected response"),
            Err(err) => {
                log::error!("submitting order failed: {}", err.message);
                cancel_order(data, order_id);
                let _ = res_sender.send(Err(api_server::Error::NotInputs));
            }
        },
    );
}

fn process_new_order(
    data: &mut Data,
    new_order: NewOrder,
    res_sender: oneshot::Sender<Result<api_server::OrderInfo, api_server::Error>>,
) {
    if data.sign_request_count > 5 {
        log::error!("too many active requests");
        let _ = res_sender.send(Err(api_server::Error::TooManyRequest));
        return;
    }

    make_async_request(
        data,
        sideswap_api::Request::Submit(sideswap_api::SubmitRequest {
            order: sideswap_api::PriceOrder {
                asset: new_order.asset_id,
                bitcoin_amount: None,
                asset_amount: Some(-new_order.asset_amount),
                price: Some(new_order.price),
                index_price: None,
                force_private: None,
                disable_price_edit: None,
            },
        }),
        move |data, res| match res {
            Ok(sideswap_api::Response::Submit(resp)) => {
                process_submit_inputs(data, resp, new_order, res_sender);
            }
            Ok(_) => panic!("unexpected response"),
            Err(err) => {
                log::error!("order submit failed unexpectedly: {}", err.message);
                let _ = res_sender.send(Err(api_server::Error::Server(err.message)));
            }
        },
    );
}

fn process_api(data: &mut Data, req: api_server::Req) {
    match req {
        api_server::Req::NewOrder(new_order, res_sender) => {
            process_new_order(data, new_order, res_sender);
        }
        api_server::Req::OrderStatus(order_id, res_sender) => {
            let res = get_order_status(data, order_id);
            let _ = res_sender.send(res);
        }
        api_server::Req::ListOrders(_, _) => {}
    }
}

fn process_ws(data: &mut Data, resp: ws::WrappedResponse) {
    match resp {
        ws::WrappedResponse::Connected => {
            data.ws_connected = true;

            make_async_request(
                data,
                sideswap_api::Request::Login(sideswap_api::LoginRequest {
                    session_id: Some(data.session_id),
                }),
                |data, res| match res {
                    Ok(sideswap_api::Response::Login(resp)) => {
                        log::debug!(
                            "active orders: {}",
                            serde_json::to_string(&resp.orders).unwrap()
                        );
                        for order in resp.orders.into_iter() {
                            cancel_order(data, order.order_id);
                        }
                    }
                    Ok(_) => panic!("unexpected response"),
                    Err(err) => log::error!("login request failed unexpectedly: {}", err),
                },
            );
        }

        ws::WrappedResponse::Disconnected => {
            data.ws_connected = false;

            let async_requests = std::mem::take(&mut data.async_requests);
            for request in async_requests.into_values() {
                request(
                    data,
                    Err(sideswap_api::Error {
                        code: sideswap_api::ErrorCode::ServerError,
                        message: "Server disconnected".to_owned(),
                    }),
                );
            }

            request_ws_connect(data);
        }

        ws::WrappedResponse::Response(resp) => match resp {
            sideswap_api::ResponseMessage::Response(request_id, res) => {
                let request_id = request_id.unwrap();
                if let Some(callback) = data.async_requests.remove(&request_id) {
                    callback(data, res);
                }
            }
            sideswap_api::ResponseMessage::Notification(notif) => match notif {
                sideswap_api::Notification::OrderCreated(order) => {
                    log::debug!("order created: {}", order.order_id);
                }
                sideswap_api::Notification::OrderRemoved(order) => {
                    log::debug!("order removed: {}", order.order_id);
                    if let Some(order) = data.orders.get_mut(&order.order_id) {
                        if !matches!(order, OrderState::Active(_)) {
                            *order = OrderState::Failed;
                        }
                    }
                }
                sideswap_api::Notification::Complete(complete) => {
                    log::debug!(
                        "order complete, order_id: {}, txid: {:?}",
                        complete.order_id,
                        complete.txid
                    );
                    if let Some(txid) = complete.txid {
                        let order = data.orders.remove(&complete.order_id).unwrap();
                        let inputs = match order {
                            OrderState::Active(inputs) => inputs,
                            _ => panic!("unexpected state"),
                        };
                        data.orders
                            .insert(complete.order_id, OrderState::Succeed(inputs, txid));
                    } else {
                        data.orders.insert(complete.order_id, OrderState::Failed);
                    }
                }
                sideswap_api::Notification::Sign(sign) => {
                    log::debug!("sign swap...");
                    data.wallet.send_req(wallet::Req::SignPset(sign));
                    data.sign_request_count += 1;
                }
                _ => {}
            },
        },
    }
}

pub fn run(
    env: Env,
    req_receiver: crossbeam_channel::Receiver<Req>,
    ws_sender: crossbeam_channel::Sender<ws::WrappedRequest>,
    wallet: wallet::Wallet,
    session_id: sideswap_api::SessionId,
) {
    let policy_asset = sideswap_api::AssetId::from_str(env.data().policy_asset).unwrap();

    let mut data = Data {
        env,
        policy_asset,
        session_id,
        ws_connected: false,
        async_requests: Default::default(),
        ws_sender,
        wallet,
        orders: BTreeMap::new(),
        swap_inputs: None,
        unique_orders: BTreeMap::new(),
        sign_request_count: 0,
    };

    request_ws_connect(&mut data);

    loop {
        let req = req_receiver.recv().unwrap();
        match req {
            Req::ApiServer(req) => process_api(&mut data, req),
            Req::Wallet(resp) => process_wallet(&mut data, resp),
            Req::Ws(resp) => process_ws(&mut data, resp),
        }
    }
}
