use async_tungstenite::tokio::connect_async;
use futures::prelude::*;
use sideswap_api::*;
use std::time::{Duration, Instant};

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

pub type Sender = std::sync::mpsc::Sender<WrappedRequest>;
pub type Receiver = std::sync::mpsc::Receiver<WrappedResponse>;

static GLOBAL_REQUEST_ID: std::sync::atomic::AtomicI64 = std::sync::atomic::AtomicI64::new(1);

pub fn next_request_id() -> RequestId {
    RequestId::Int(GLOBAL_REQUEST_ID.fetch_add(1, std::sync::atomic::Ordering::Relaxed))
}

const RECONNECT_WAIT_PERIOD: Duration = Duration::from_secs(10);
const PING_PERIOD: Duration = Duration::from_secs(30);
const PONG_TIMEOUT: Duration = Duration::from_secs(90);

async fn run(
    host: String,
    port: u16,
    use_tls: bool,
    req_rx: std::sync::mpsc::Receiver<WrappedRequest>,
    resp_tx: std::sync::mpsc::Sender<WrappedResponse>,
) {
    let (req_tx_async, mut req_rx_async) = tokio::sync::mpsc::unbounded_channel::<WrappedRequest>();
    std::thread::spawn(move || {
        while let Ok(req) = req_rx.recv() {
            if let Err(e) = req_tx_async.send(req) {
                error!("unexpected sending error: {}", e);
            }
        }
    });

    loop {
        let protocol = if use_tls { "wss" } else { "ws" };
        let url = format!("{}://{}:{}/{}", protocol, &host, port, PATH_JSON_RUST_WS);
        let connect_result = connect_async(url).await;
        let mut interval =
            tokio::time::interval_at(tokio::time::Instant::now() + PING_PERIOD, PING_PERIOD);

        let mut ws_stream = match connect_result {
            Ok((ws_stream, _)) => ws_stream,
            Err(e) => {
                error!("connection to the server failed: {}", e);
                tokio::time::delay_for(RECONNECT_WAIT_PERIOD).await;
                continue;
            }
        };

        // Drop old messages
        while let Ok(_) = req_rx_async.try_recv() {}

        resp_tx.send(WrappedResponse::Connected).unwrap();

        let mut last_recv_timestamp = Instant::now();

        loop {
            tokio::select! {
                server_msg = ws_stream.next() => {
                    let server_msg = server_msg.unwrap();
                    let server_msg = match server_msg {
                        Ok(v) => v,
                        Err(_) => {
                            error!("connection to the server closed");
                            break;
                        }
                    };
                    last_recv_timestamp = Instant::now();
                    match server_msg {
                        async_tungstenite::tungstenite::Message::Text(text) => {
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
                        async_tungstenite::tungstenite::Message::Ping(data) => {
                            let _ = ws_stream.send(async_tungstenite::tungstenite::Message::Pong(data)).await;
                        }
                        _ => {}
                    }
                }

                client_result = req_rx_async.next() => {
                    let client_result = match client_result {
                        Some(v) => v,
                        None => return,
                    };
                    match client_result {
                        WrappedRequest::Request(req) => {
                            let text = serde_json::to_string(&req).unwrap();
                            let _ = ws_stream.send(async_tungstenite::tungstenite::Message::text(&text)).await;
                        }
                    }
                }

                _ = interval.tick() => {
                    let last_recv_duration = Instant::now().duration_since(last_recv_timestamp);
                    if last_recv_duration > PONG_TIMEOUT {
                        error!("ping timeout detected");
                        break;
                    }
                    if last_recv_duration > PING_PERIOD {
                        let _ = ws_stream.send(async_tungstenite::tungstenite::Message::Ping(Vec::new())).await;
                    }
                }
            }
        }

        resp_tx.send(WrappedResponse::Disconnected).unwrap();

        tokio::time::delay_for(RECONNECT_WAIT_PERIOD).await;
    }
}

pub fn start(host: String, port: u16, use_tls: bool) -> (Sender, Receiver) {
    let (req_tx, req_rx) = std::sync::mpsc::channel::<WrappedRequest>();
    let (resp_tx, resp_rx) = std::sync::mpsc::channel::<WrappedResponse>();
    std::thread::spawn(move || {
        let mut rt = tokio::runtime::Builder::new()
            .basic_scheduler()
            .enable_all()
            .build()
            .unwrap();
        rt.block_on(run(host, port, use_tls, req_rx, resp_tx));
    });
    (req_tx, resp_rx)
}
