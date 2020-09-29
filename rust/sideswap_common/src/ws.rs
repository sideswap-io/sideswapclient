use async_tungstenite::tokio::connect_async;
use futures::prelude::*;
use sideswap_api::*;

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

async fn run(
    host: String,
    port: i32,
    use_tls: bool,
    req_rx: std::sync::mpsc::Receiver<WrappedRequest>,
    resp_tx: std::sync::mpsc::Sender<WrappedResponse>,
) {
    let (req_tx_async, mut req_rx_async) = futures::channel::mpsc::unbounded::<WrappedRequest>();
    std::thread::spawn(move || {
        while let Ok(req) = req_rx.recv() {
            req_tx_async.unbounded_send(req).unwrap();
        }
    });

    loop {
        let protocol = if use_tls { "wss" } else { "ws" };
        let url = format!("{}://{}:{}/{}", protocol, &host, port, PATH_JSON_RUST_WS);
        let connect_result = connect_async(url).await;

        let ws_stream = match connect_result {
            Ok((ws_stream, _)) => ws_stream,
            Err(e) => {
                error!("connection to the server failed: {}", e);
                std::thread::sleep(std::time::Duration::from_secs(10));
                continue;
            }
        };
        resp_tx.send(WrappedResponse::Connected).unwrap();

        let mut ws_stream = ws_stream.fuse();

        loop {
            select! {
                server_msg = ws_stream.next() => {
                    let server_msg = server_msg.unwrap();
                    let server_msg = match server_msg {
                        Ok(v) => v,
                        Err(e) => {
                            error!("connection to the server closed");
                            break;
                        },
                    };
                    match server_msg {
                        tungstenite::Message::Text(text) => {
                            let server_msg = serde_json::from_str::<ResponseMessage>(&text);
                            match server_msg {
                                Ok(v) => {
                                    resp_tx.send(WrappedResponse::Response(v)).unwrap();
                                },
                                Err(e) => {
                                    error!("parsing response failed: {}: {}", e, &text);
                                },
                            }
                        },
                        tungstenite::Message::Ping(data) => {
                            let _ = ws_stream.send(tungstenite::Message::Pong(data)).await;
                        },
                        _ => {
                        },

                    }
                },

                client_result = req_rx_async.next() => {
                    let client_result = client_result.unwrap();
                    match client_result {
                        WrappedRequest::Request(req) => {
                            let text = serde_json::to_string(&req).unwrap();
                            let _ = ws_stream.send(tungstenite::Message::text(&text)).await;
                        }
                    }
                }
            };
        }

        resp_tx.send(WrappedResponse::Disconnected).unwrap();
        std::thread::sleep(std::time::Duration::from_secs(10));
    }
}

pub fn start(host: String, port: i32, use_tls: bool) -> (Sender, Receiver) {
    let (req_tx, req_rx) = std::sync::mpsc::channel::<WrappedRequest>();
    let (resp_tx, resp_rx) = std::sync::mpsc::channel::<WrappedResponse>();
    std::thread::spawn(move || {
        let mut rt = tokio::runtime::Runtime::new().unwrap();
        rt.block_on(run(host, port, use_tls, req_rx, resp_tx));
    });
    (req_tx, resp_rx)
}
