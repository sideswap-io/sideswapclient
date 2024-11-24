use std::net::SocketAddr;

use futures::{SinkExt, StreamExt};
use serde::Deserialize;
use sideswap_types::normal_float::NormalFloat;
use tokio::{
    net::{TcpListener, TcpStream},
    sync::{
        mpsc::{unbounded_channel, UnboundedReceiver, UnboundedSender},
        oneshot,
    },
};
use tokio_tungstenite::{tungstenite::Message, WebSocketStream};

use super::{ClientCommand, ClientEvent, ClientId, Error};

mod api;

#[derive(Debug, Clone, Deserialize)]
pub struct Config {
    listen_on: SocketAddr,
}

struct Data {
    client_id: ClientId,
    ws_stream: WebSocketStream<TcpStream>,
    command_sender: UnboundedSender<ClientCommand>,
}

impl Error {
    fn code(&self) -> api::ErrorCode {
        match self {
            Error::ChannelClosed
            | Error::WsRequestError(_)
            | Error::UnexpectedResponse(_)
            | Error::TryAgain
            | Error::ServerDisconnected => api::ErrorCode::ServerError,
            Error::UnknownTicker(_) | Error::InvalidFloat(_) => api::ErrorCode::InvalidRequest,
        }
    }

    fn details(&self) -> Option<api::ErrorDetails> {
        match self {
            Error::ChannelClosed
            | Error::WsRequestError(_)
            | Error::UnexpectedResponse(_)
            | Error::TryAgain
            | Error::ServerDisconnected
            | Error::UnknownTicker(_)
            | Error::InvalidFloat(_) => None,
        }
    }
}

fn convert_order(order: &super::PublicOrder_) -> api::PubOrder {
    api::PubOrder {
        order_id: order.order_id,
        trade_dir: order.trade_dir,
        amount: order.amount,
        price: order.price.value(),
    }
}

async fn send_msg(data: &mut Data, msg: Message) {
    let res = data.ws_stream.send(msg).await;
    if let Err(err) = res {
        log::debug!("ws message sending failed: {err}");
    }
}

async fn send_from(data: &mut Data, from: api::From) {
    let msg = serde_json::to_string(&from).expect("must not fail");
    send_msg(data, Message::Text(msg)).await;
}

async fn send_notif(data: &mut Data, notif: api::Notif) {
    send_from(data, api::From::Notif { notif }).await;
}

fn send_command(data: &Data, command: ClientCommand) {
    let res = data.command_sender.send(command);
    if let Err(err) = res {
        log::debug!("command sending failed: {err}");
    }
}

async fn process_ws_req(data: &mut Data, req: api::Req) -> Result<api::Resp, Error> {
    match req {
        api::Req::Subscribe(req) => {
            let (res_sender, res_receiver) = oneshot::channel();
            send_command(
                data,
                ClientCommand::WsSubscribe {
                    client_id: data.client_id,
                    exchange_pair: req.exchange_pair,
                    res_sender: res_sender.into(),
                },
            );
            let resp = res_receiver.await??;
            let orders = resp.orders.iter().map(convert_order).collect();
            Ok(api::Resp::Subscribe(api::SubscribeResp { orders }))
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
                            err: api::Error {
                                code: err.code(),
                                text: err.to_string(),
                                details: err.details(),
                            },
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
        Message::Ping(msg) => {
            send_msg(data, Message::Pong(msg)).await;
        }
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
        ClientEvent::ServerConnected => {
            send_notif(
                data,
                api::Notif::ServerConnected(api::ServerConnectedNotif {}),
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
                    order: convert_order(&order),
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

async fn client_run(
    client_id: ClientId,
    command_sender: UnboundedSender<ClientCommand>,
    tcp_stream: TcpStream,
) {
    let ws_stream = match tokio_tungstenite::accept_async(tcp_stream).await {
        Ok(ws_stream) => ws_stream,
        Err(err) => {
            log::error!("ws handshake failed: {err}");
            return;
        }
    };

    let mut data = Data {
        client_id,
        ws_stream,
        command_sender,
    };

    let (event_sender, event_receiver) = unbounded_channel();

    send_command(
        &data,
        ClientCommand::ClientConnected {
            client_id,
            event_sender: event_sender.into(),
        },
    );

    let result = client_loop(&mut data, event_receiver).await;

    if let Err(err) = result {
        log::debug!("ws connection stopped: {err}");
    }

    send_command(&data, ClientCommand::ClientDisconnected { client_id });
}

async fn run(config: Config, command_sender: UnboundedSender<ClientCommand>) {
    let listener = TcpListener::bind(&config.listen_on)
        .await
        .expect("port must be open");

    let mut last_id = 0;

    loop {
        let (tcp_stream, _socket) = listener.accept().await.expect("should not fail");

        last_id += 1;
        let client_id = ClientId(last_id);

        tokio::spawn(client_run(client_id, command_sender.clone(), tcp_stream));
    }
}

pub fn start(config: Config, command_sender: UnboundedSender<ClientCommand>) {
    tokio::task::spawn(run(config, command_sender));
}
