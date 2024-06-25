use crate::{channel_helpers, retry_delay::RetryDelay};

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
    base_url: String,
    mut req_rx: UnboundedReceiver<WrappedRequest>,
    resp_tx: UnboundedSender<WrappedResponse>,
) {
    log::debug!("start ws connection to {base_url}...");

    let resp_tx = channel_helpers::UncheckedUnboundedSender::from(resp_tx);

    let url = format!("{}/{}", base_url, sideswap_api::PATH_JSON_RUST_WS);

    loop {
        let mut retry_delay = RetryDelay::default();

        let mut ws_stream = loop {
            debug!("try ws connection...");
            let connect_res = tokio_tungstenite::connect_async(&url).await;
            match connect_res {
                Ok((ws_stream, _response)) => break ws_stream,
                Err(err) => {
                    error!("ws connection to the server failed: {err}");
                    tokio::time::sleep(retry_delay.next_delay()).await;
                }
            }
        };

        debug!("ws connected");
        resp_tx.send(WrappedResponse::Connected);

        let mut last_recv_timestamp = Instant::now();
        let mut interval =
            tokio::time::interval_at(tokio::time::Instant::now() + PING_PERIOD, PING_PERIOD);

        loop {
            tokio::select! {
                server_msg = ws_stream.next() => {
                    let server_msg = server_msg.expect("can't be empty");
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
                                    resp_tx.send(WrappedResponse::Response(v));
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
                            let text = serde_json::to_string(&req).expect("must not fail");
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
        resp_tx.send(WrappedResponse::Disconnected);
    }
}

pub fn start(
    base_url: String,
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
            .expect("must not fail");
        rt.block_on(run(base_url, req_rx, resp_tx));
    });
    (req_tx, resp_rx)
}
