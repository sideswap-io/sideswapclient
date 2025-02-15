use std::net::SocketAddr;

use futures::{SinkExt, StreamExt};
use serde::Deserialize;
use sideswap_types::normal_float::NormalFloat;
use tokio::{
    net::{TcpListener, TcpStream},
    sync::mpsc::{unbounded_channel, UnboundedReceiver},
};
use tokio_tungstenite::{tungstenite::Message, WebSocketStream};

use super::{api, controller::Controller, ClientEvent, ClientId, Error, StartQuotesResp};

#[derive(Debug, Clone, Deserialize)]
pub struct Config {
    listen_on: SocketAddr,
}

struct Data {
    controller: Controller,
    client_id: ClientId,
    ws_stream: WebSocketStream<TcpStream>,
}

async fn send_msg(data: &mut Data, msg: Message) {
    let res = data.ws_stream.send(msg).await;
    if let Err(err) = res {
        log::debug!("ws message sending failed: {err}");
    }
}

async fn send_from(data: &mut Data, from: api::From) {
    let msg = serde_json::to_string(&from).expect("must not fail");
    send_msg(data, Message::text(msg)).await;
}

async fn send_notif(data: &mut Data, notif: api::Notif) {
    send_from(data, api::From::Notif { notif }).await;
}

async fn process_ws_req(data: &mut Data, req: api::Req) -> Result<api::Resp, Error> {
    match req {
        api::Req::Subscribe(api::SubscribeReq { exchange_pair }) => {
            let resp = data
                .controller
                .subscribe(data.client_id, exchange_pair)
                .await?;
            let orders = resp.orders.into_iter().map(Into::into).collect();
            Ok(api::Resp::Subscribe(api::SubscribeResp { orders }))
        }

        api::Req::StartQuotes(api::StartQuotesReq {
            exchange_pair,
            asset_type,
            amount,
            trade_dir,
            order_id,
            private_id,
        }) => {
            let StartQuotesResp {
                quote_sub_id,
                fee_asset,
            } = data
                .controller
                .start_quotes(
                    data.client_id,
                    exchange_pair,
                    asset_type,
                    amount,
                    trade_dir.into(),
                    order_id,
                    private_id,
                )
                .await?;
            Ok(api::Resp::StartQuotes(api::StartQuotesResp {
                quote_sub_id,
                fee_asset,
            }))
        }

        api::Req::StopQuotes(api::StopQuotesReq {}) => {
            data.controller.stop_quotes();
            Ok(api::Resp::StopQuotes(api::StopQuotesResp {}))
        }

        api::Req::AcceptQuote(api::AcceptQuoteReq { quote_id }) => {
            let txid = data.controller.accept_quote(quote_id).await?;
            Ok(api::Resp::AcceptQuote(api::AcceptQuoteResp { txid }))
        }
    }
}

async fn process_to_msg(data: &mut Data, to: api::To) {
    match to {
        api::To::Req { id, req } => {
            let res = process_ws_req(data, req).await;
            match res {
                Ok(resp) => send_from(data, api::From::Resp { id, resp }).await,
                Err(err) => {
                    send_from(
                        data,
                        api::From::Error {
                            id,
                            err: err.into(),
                        },
                    )
                    .await
                }
            }
        }
    }
}

fn get_req_id(msg: &str) -> api::ReqId {
    #[derive(serde::Deserialize)]
    pub enum ToIdOnly {
        Req { id: api::ReqId },
    }
    serde_json::from_str::<ToIdOnly>(&msg)
        .map(|ToIdOnly::Req { id }| id)
        .unwrap_or_default()
}

async fn process_ws_msg(data: &mut Data, msg: Message) {
    match msg {
        Message::Text(msg) => {
            let res = serde_json::from_str::<api::To>(&msg);
            match res {
                Ok(to) => {
                    process_to_msg(data, to).await;
                }
                Err(err) => {
                    send_from(
                        data,
                        api::From::Error {
                            id: get_req_id(&msg),
                            err: api::Error {
                                code: api::ErrorCode::InvalidRequest,
                                text: format!("invalid JSON: {err}"),
                                details: None,
                            },
                        },
                    )
                    .await;
                }
            }
        }
        Message::Binary(_) => {
            log::debug!("binary message ignored");
        }
        Message::Ping(_) => {}
        Message::Pong(_) => {}
        Message::Close(msg) => {
            log::debug!("close message received: {msg:?}");
        }
        Message::Frame(_) => {
            log::debug!("frame message ignored");
        }
    }
}

async fn process_client_event(data: &mut Data, event: ClientEvent) {
    match event {
        ClientEvent::Balances { balances } => {
            send_notif(data, api::Notif::Balances(balances.into())).await;
        }

        ClientEvent::ServerConnected { own_orders } => {
            send_notif(
                data,
                api::Notif::ServerConnected(api::ServerConnectedNotif {
                    own_orders: own_orders.orders.into_iter().map(Into::into).collect(),
                }),
            )
            .await;
        }

        ClientEvent::OrderAdded {
            exchange_pair,
            order,
        } => {
            send_notif(
                data,
                api::Notif::OrderCreated(api::OrderCreatedNotif {
                    exchange_pair,
                    order: order.into(),
                }),
            )
            .await;
        }

        ClientEvent::OrderRemoved {
            exchange_pair,
            order_id,
        } => {
            send_notif(
                data,
                api::Notif::OrderRemoved(api::OrderRemovedNotif {
                    exchange_pair,
                    order_id,
                }),
            )
            .await;
        }

        ClientEvent::OwnOrderAdded { order } => {
            send_notif(
                data,
                api::Notif::OwnOrderCreated(api::OwnOrderCreatedNotif {
                    order: order.into(),
                }),
            )
            .await;
        }

        ClientEvent::OwnOrderRemoved { order_id } => {
            send_notif(
                data,
                api::Notif::OwnOrderRemoved(api::OwnOrderRemovedNotif { order_id }),
            )
            .await;
        }

        ClientEvent::MarketPrice {
            exchange_pair,
            ind_price,
            last_price,
        } => {
            send_notif(
                data,
                api::Notif::MarketPrice(api::MarketPriceNotif {
                    exchange_pair,
                    ind_price: ind_price.map(NormalFloat::value),
                    last_price: last_price.map(NormalFloat::value),
                }),
            )
            .await;
        }

        ClientEvent::HistoryUpdated { order, is_new } => {
            send_notif(
                data,
                api::Notif::HistoryUpdated(api::HistoryUpdatedNotif {
                    order: order.into(),
                    is_new,
                }),
            )
            .await;
        }

        ClientEvent::Quote { notif } => {
            send_notif(data, api::Notif::Quote(notif)).await;
        }
    }
}

async fn client_loop(
    data: &mut Data,
    mut event_receiver: UnboundedReceiver<ClientEvent>,
) -> Result<(), anyhow::Error> {
    loop {
        tokio::select! {
            msg = data.ws_stream.next() => {
                match msg {
                    Some(Ok(msg)) => {
                        process_ws_msg(data, msg).await;
                    },
                    Some(Err(err)) => {
                        log::debug!("ws connection closed: {err}");
                        break;
                    },
                    None => {
                        log::debug!("ws connection closed");
                        break;
                    },
                }
            },

            event = event_receiver.recv() => {
                match event {
                    Some(event) => {
                        process_client_event(data, event).await;
                    },
                    None => {
                        log::debug!("disconnect client");
                        break;
                    },
                }
            },
        }
    }

    Ok(())
}

async fn client_run(controller: Controller, client_id: ClientId, tcp_stream: TcpStream) {
    let ws_stream = match tokio_tungstenite::accept_async(tcp_stream).await {
        Ok(ws_stream) => ws_stream,
        Err(err) => {
            log::error!("ws handshake failed: {err}");
            return;
        }
    };

    let mut data = Data {
        controller,
        client_id,
        ws_stream,
    };

    let (event_sender, event_receiver) = unbounded_channel();

    data.controller
        .client_connected(client_id, event_sender.into());

    let result = client_loop(&mut data, event_receiver).await;

    if let Err(err) = result {
        log::debug!("ws connection stopped: {err}");
    }

    data.controller.client_disconnected(client_id);
}

async fn run(config: Config, controller: Controller) {
    let listener = TcpListener::bind(&config.listen_on)
        .await
        .expect("port must be open");

    let mut last_id = 0;

    loop {
        let (tcp_stream, _socket) = listener.accept().await.expect("should not fail");

        last_id += 1;
        let client_id = ClientId(last_id);

        tokio::spawn(client_run(controller.clone(), client_id, tcp_stream));
    }
}

pub fn start(config: Config, controller: Controller) {
    tokio::task::spawn(run(config, controller));
}
