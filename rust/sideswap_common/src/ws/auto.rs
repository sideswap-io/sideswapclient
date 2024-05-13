use super::*;

use futures::prelude::*;
use sideswap_api::*;
use std::time::Instant;
use tokio::sync::mpsc::{UnboundedReceiver, UnboundedSender};

#[derive(Debug)]
pub enum WrappedRequest {
    Request(RequestMessage),
}

#[derive(Debug)]
pub enum WrappedResponse {
    Connected,
    Disconnected,
    Response(ResponseMessage),
}

pub async fn run(
    host: &str,
    port: u16,
    use_tls: bool,
    mut req_rx: UnboundedReceiver<WrappedRequest>,
    resp_tx: UnboundedSender<WrappedResponse>,
) {
    let protocol = if use_tls { "wss" } else { "ws" };
    let url = format!("{}://{}:{}/{}", protocol, &host, port, PATH_JSON_RUST_WS);

    loop {
        let mut reconnect_count = 0;
        let mut ws_stream = None;

        while ws_stream.is_none() {
            debug!("try ws connection...");
            let delay = RECONNECT_WAIT_PERIODS
                .get(reconnect_count)
                .unwrap_or(&RECONNECT_WAIT_MAX_PERIOD);
            tokio::select! {
                connect_result = async {
                    let connect_result = tokio_tungstenite::connect_async(&url).await;
                    if connect_result.is_err() {
                        tokio::time::sleep(*delay).await
                    }
                    connect_result
                } => {
                    match connect_result {
                        Ok((v, _)) => ws_stream = Some(v),
                        Err(e) => {
                            error!("ws connection to the server failed: {}", e);
                            reconnect_count += 1;
                        }
                    };
                }
            }
        }
        let mut ws_stream = ws_stream.unwrap();

        debug!("ws connected");
        resp_tx.send(WrappedResponse::Connected).unwrap();

        let mut last_recv_timestamp = Instant::now();
        let mut interval =
            tokio::time::interval_at(tokio::time::Instant::now() + PING_PERIOD, PING_PERIOD);

        loop {
            tokio::select! {
                server_msg = ws_stream.next() => {
                    let server_msg = server_msg.unwrap();
                    let server_msg = match server_msg {
                        Ok(v) => v,
                        Err(v) => {
                            error!("ws connection to the server closed: {}", v);
                            break;
                        }
                    };
                    last_recv_timestamp = Instant::now();
                    match server_msg {
                        tokio_tungstenite::tungstenite::Message::Text(text) => {
                            let server_msg = serde_json::from_str::<ResponseMessage>(&text);
                            match server_msg {
                                Ok(v) => {
                                    resp_tx.send(WrappedResponse::Response(v)).unwrap();
                                }
                                Err(e) => {
                                    error!("parsing response failed: {}: {}", e, &text);
                                }
                            }
                        }
                        tokio_tungstenite::tungstenite::Message::Ping(data) => {
                            let _ = ws_stream.send(tokio_tungstenite::tungstenite::Message::Pong(data)).await;
                        }
                        _ => {}
                    }
                }

                client_result = req_rx.recv() => {
                    let client_result = match client_result {
                        Some(v) => v,
                        None => {
                            info!("terminate ws connection loop");
                            return;
                        },
                    };
                    match client_result {
                        WrappedRequest::Request(req) => {
                            let text = serde_json::to_string(&req).unwrap();
                            let _ = ws_stream.send(tokio_tungstenite::tungstenite::Message::text(&text)).await;
                        }
                    }
                }

                _ = interval.tick() => {
                    let last_recv_duration = Instant::now().duration_since(last_recv_timestamp);
                    if last_recv_duration > PONG_TIMEOUT {
                        error!("ws ping timeout detected");
                        break;
                    }
                    if last_recv_duration > PING_PERIOD {
                        let _ = ws_stream.send(tokio_tungstenite::tungstenite::Message::Ping(Vec::new())).await;
                    }
                }
            }
        }

        debug!("ws disconnected");
        resp_tx.send(WrappedResponse::Disconnected).unwrap();
    }
}

pub fn start(
    host: String,
    port: u16,
    use_tls: bool,
) -> (
    UnboundedSender<WrappedRequest>,
    UnboundedReceiver<WrappedResponse>,
) {
    let (req_tx, req_rx) = tokio::sync::mpsc::unbounded_channel::<WrappedRequest>();
    let (resp_tx, resp_rx) = tokio::sync::mpsc::unbounded_channel::<WrappedResponse>();
    std::thread::spawn(move || {
        let rt = tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap();
        rt.block_on(run(&host, port, use_tls, req_rx, resp_tx));
    });
    (req_tx, resp_rx)
}
