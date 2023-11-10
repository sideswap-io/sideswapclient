use futures::prelude::*;
use serde::Deserialize;
use tokio_tungstenite::connect_async;

#[derive(Debug)]
pub enum WrappedRequest {
    Data(Vec<u8>),
}

#[derive(Debug)]
pub enum WrappedResponse {
    Connected,
    Disconnected,
    Data(Vec<u8>),
}

#[derive(Debug, Deserialize, Clone)]
pub struct Server {
    host: String,
    port: i32,
}

pub type Sender = crossbeam_channel::Sender<WrappedRequest>;
pub type Receiver = crossbeam_channel::Receiver<WrappedResponse>;

async fn run(
    server: Server,
    req_rx: crossbeam_channel::Receiver<WrappedRequest>,
    resp_tx: crossbeam_channel::Sender<WrappedResponse>,
) {
    let (req_tx_async, mut req_rx_async) = futures::channel::mpsc::unbounded::<WrappedRequest>();
    std::thread::spawn(move || {
        while let Ok(req) = req_rx.recv() {
            req_tx_async.unbounded_send(req).unwrap();
        }
    });

    loop {
        let url = format!("ws://{}:{}/binary", &server.host, server.port);

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
                    let server_msg = match server_msg {
                        Some(v) => v,
                        None => return,
                    };
                    let server_msg = match server_msg {
                        Ok(v) => v,
                        Err(_) => {
                            error!("connection to the server closed");
                            break;
                        },
                    };
                    match server_msg {
                        tokio_tungstenite::tungstenite::Message::Binary(data) => {
                            resp_tx.send(WrappedResponse::Data(data)).unwrap();
                        },
                        tokio_tungstenite::tungstenite::Message::Ping(data) => {
                            let _ = ws_stream.send(tokio_tungstenite::tungstenite::Message::Pong(data)).await;
                        },
                        _ => {
                            error!("unexpected WS message: {:?}", &server_msg);
                        },

                    }
                },

                client_result = req_rx_async.next() => {
                    let client_result = match client_result {
                        Some(v) => v,
                        None => return,
                    };
                    match client_result {
                        WrappedRequest::Data(data) => {
                            let _ = ws_stream.send(tokio_tungstenite::tungstenite::Message::Binary(data)).await;
                        }
                    }
                }
            };
        }

        resp_tx.send(WrappedResponse::Disconnected).unwrap();
        std::thread::sleep(std::time::Duration::from_secs(10));
    }
}

pub fn start(server: Server) -> (Sender, Receiver) {
    let (req_tx, req_rx) = crossbeam_channel::unbounded::<WrappedRequest>();
    let (resp_tx, resp_rx) = crossbeam_channel::unbounded::<WrappedResponse>();
    std::thread::spawn(move || {
        let rt = tokio::runtime::Runtime::new().unwrap();
        rt.block_on(run(server, req_rx, resp_tx));
    });
    (req_tx, resp_rx)
}
