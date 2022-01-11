use async_tungstenite::tokio::connect_async;
use futures::prelude::*;
use sideswap_api::*;
use std::time::{Duration, Instant};

#[derive(Debug)]
pub enum WrappedRequest {
    Connect,
    Disconnect,
    Request(RequestMessage),
}

#[derive(Debug)]
pub enum WrappedResponse {
    Connected,
    Disconnected,
    Response(ResponseMessage),
}

static GLOBAL_REQUEST_ID: std::sync::atomic::AtomicI64 = std::sync::atomic::AtomicI64::new(1);

pub fn next_request_id() -> RequestId {
    RequestId::Int(GLOBAL_REQUEST_ID.fetch_add(1, std::sync::atomic::Ordering::Relaxed))
}

const RECONNECT_WAIT_PERIODS: [Duration; 5] = [
    Duration::from_secs(0),
    Duration::from_secs(1),
    Duration::from_secs(3),
    Duration::from_secs(6),
    Duration::from_secs(9),
];
const RECONNECT_WAIT_MAX_PERIOD: Duration = Duration::from_secs(12);

const PING_PERIOD: Duration = Duration::from_secs(30);
const PONG_TIMEOUT: Duration = Duration::from_secs(90);

async fn run(
    host: String,
    port: u16,
    use_tls: bool,
    sync: bool,
    req_rx: crossbeam_channel::Receiver<WrappedRequest>,
    resp_tx: crossbeam_channel::Sender<WrappedResponse>,
    mut hint_rx: tokio::sync::mpsc::UnboundedReceiver<()>,
) {
    let (req_tx_async, mut req_rx_async) = tokio::sync::mpsc::unbounded_channel::<WrappedRequest>();
    std::thread::spawn(move || {
        while let Ok(req) = req_rx.recv() {
            if let Err(e) = req_tx_async.send(req) {
                error!("unexpected sending error: {}", e);
            }
        }
    });

    let protocol = if use_tls { "wss" } else { "ws" };
    let url = format!("{}://{}:{}/{}", protocol, &host, port, PATH_JSON_RUST_WS);

    loop {
        if sync {
            loop {
                let req = req_rx_async.recv().await;
                match req {
                    Some(WrappedRequest::Connect) => {
                        info!("ws connect requested...");
                        break;
                    }
                    Some(req) => {
                        debug!("drop unexpected request: {:?}", &req);
                    }
                    None => {
                        debug!("quit from ws connection loop");
                        return;
                    }
                }
            }
        }

        let mut reconnect_count = 0;
        let mut ws_stream = None;

        while ws_stream.is_none() {
            debug!("try ws connection...");
            let delay = RECONNECT_WAIT_PERIODS
                .get(reconnect_count)
                .unwrap_or(&RECONNECT_WAIT_MAX_PERIOD);
            tokio::select! {
                connect_result = async {
                    let connect_result = connect_async(&url).await;
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
                _ = hint_rx.recv() => {
                    debug!("reconnect hint received");
                    reconnect_count = 0;
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
                        Err(_) => {
                            error!("ws connection to the server closed");
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

                client_result = req_rx_async.recv() => {
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
                            let _ = ws_stream.send(async_tungstenite::tungstenite::Message::text(&text)).await;
                        }
                        WrappedRequest::Connect => {
                            warn!("ignore unexpected ws connect request");
                        }
                        WrappedRequest::Disconnect => {
                            info!("ws disconnect requested");
                            break;
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
                        let _ = ws_stream.send(async_tungstenite::tungstenite::Message::Ping(Vec::new())).await;
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
    sync: bool,
) -> (
    crossbeam_channel::Sender<WrappedRequest>,
    crossbeam_channel::Receiver<WrappedResponse>,
    tokio::sync::mpsc::UnboundedSender<()>,
) {
    let (req_tx, req_rx) = crossbeam_channel::unbounded::<WrappedRequest>();
    let (resp_tx, resp_rx) = crossbeam_channel::unbounded::<WrappedResponse>();
    let (hint_tx, hint_rx) = tokio::sync::mpsc::unbounded_channel::<()>();
    std::thread::spawn(move || {
        let rt = tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap();
        rt.block_on(run(host, port, use_tls, sync, req_rx, resp_tx, hint_rx));
    });
    (req_tx, resp_rx, hint_tx)
}
