use super::*;

use futures::prelude::*;
use sideswap_api::*;
use std::time::Instant;

#[derive(Debug)]
pub enum WrappedRequest {
    Connect {
        host: String,
        port: u16,
        use_tls: bool,
    },
    Disconnect,
    Request(RequestMessage),
}

#[derive(Debug)]
pub enum WrappedResponse {
    Connected,
    Disconnected,
    Response(ResponseMessage),
}

async fn connect_async(
    url: &str,
    proxy: Option<&String>,
    host: &str,
    port: u16,
) -> Result<
    (
        tokio_tungstenite::WebSocketStream<
            tokio_tungstenite::MaybeTlsStream<tokio::net::TcpStream>,
        >,
        tokio_tungstenite::tungstenite::handshake::client::Response,
    ),
    anyhow::Error,
> {
    let stream = if let Some(proxy) = proxy {
        let stream = tokio::net::TcpStream::connect(proxy).await?;
        let stream = tokio_socks::tcp::Socks5Stream::connect_with_socket(
            stream,
            format!("{}:{}", host, port),
        )
        .await?;
        stream.into_inner()
    } else {
        tokio::net::TcpStream::connect(format!("{}:{}", host, port)).await?
    };

    let ws = tokio_tungstenite::client_async_tls(url, stream).await?;

    Ok(ws)
}

async fn run(
    req_rx: crossbeam_channel::Receiver<WrappedRequest>,
    resp_tx: crossbeam_channel::Sender<WrappedResponse>,
    mut hint_rx: tokio::sync::mpsc::UnboundedReceiver<()>,
    proxy: Option<String>,
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
        let (host, port, use_tls) = loop {
            let req = req_rx_async.recv().await;
            match req {
                Some(WrappedRequest::Connect {
                    host,
                    port,
                    use_tls,
                }) => {
                    info!("ws connect requested...");
                    break (host, port, use_tls);
                }
                Some(req) => {
                    debug!("drop unexpected request: {:?}", &req);
                }
                None => {
                    debug!("quit from ws connection loop");
                    return;
                }
            }
        };

        let protocol = if use_tls { "wss" } else { "ws" };
        let url = format!("{}://{}:{}/{}", protocol, &host, port, PATH_JSON_RUST_WS);

        let mut reconnect_count = 0;
        let mut ws_stream = None;

        while ws_stream.is_none() {
            debug!("try ws connection to {url}...");
            let delay = RECONNECT_WAIT_PERIODS
                .get(reconnect_count)
                .unwrap_or(&RECONNECT_WAIT_MAX_PERIOD);
            tokio::select! {
                connect_result = async {
                    let connect_result = connect_async(&url, proxy.as_ref(), &host, port).await;
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
                reconnect = hint_rx.recv() => {
                    if reconnect.is_none() {
                        return;
                    }
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
                            let _ = ws_stream.send(tokio_tungstenite::tungstenite::Message::text(&text)).await;
                        }
                        WrappedRequest::Connect{..} => {
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
    proxy: Option<String>,
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
        rt.block_on(run(req_rx, resp_tx, hint_rx, proxy));
    });
    (req_tx, resp_rx, hint_tx)
}
