use crate::retry_delay::RetryDelay;

use super::*;

use futures::prelude::*;
use sideswap_api::*;
use std::time::Instant;
use tokio::sync::mpsc::{UnboundedReceiver, UnboundedSender};

#[derive(Debug)]
pub enum WrappedRequest {
    Connect {
        host: String,
        port: u16,
        use_tls: bool,
        proxy: Option<String>,
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

type WsStream = (
    tokio_tungstenite::WebSocketStream<tokio_tungstenite::MaybeTlsStream<tokio::net::TcpStream>>,
    tokio_tungstenite::tungstenite::handshake::client::Response,
);

async fn connect_async(
    url: &str,
    proxy: Option<&String>,
    host: &str,
    port: u16,
) -> Result<WsStream, anyhow::Error> {
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

async fn connect_with_error_delay(
    url: &str,
    proxy: Option<&String>,
    host: &str,
    port: u16,
    error_delay: Duration,
) -> Result<WsStream, anyhow::Error> {
    let connect_result = tokio::time::timeout(
        Duration::from_secs(30),
        connect_async(&url, proxy, host, port),
    )
    .await;
    match connect_result {
        Ok(Ok(stream)) => Ok(stream),
        Ok(Err(err)) => {
            tokio::time::sleep(error_delay).await;
            Err(err)
        }
        Err(_timeout) => {
            // Do not wait more, we have already spent some time
            Err(anyhow!("connection timeout"))
        }
    }
}

async fn run(
    mut req_rx: UnboundedReceiver<WrappedRequest>,
    resp_tx: UnboundedSender<WrappedResponse>,
    mut hint_rx: UnboundedReceiver<()>,
) {
    loop {
        let (host, port, use_tls, proxy) = loop {
            let req = req_rx.recv().await;
            match req {
                Some(WrappedRequest::Connect {
                    host,
                    port,
                    use_tls,
                    proxy,
                }) => {
                    info!("ws connect requested...");
                    break (host, port, use_tls, proxy);
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

        let mut retry_delay = RetryDelay::default();

        let mut ws_stream = loop {
            debug!("try ws connection to {url}...");
            tokio::select! {
                connect_result = connect_with_error_delay(&url, proxy.as_ref(), &host, port, retry_delay.next_delay()) => {
                    match connect_result {
                        Ok((ws_stream, _response)) => break ws_stream,
                        Err(e) => {
                            error!("ws connection to the server failed: {}", e);
                        }
                    };
                }

                reconnect = hint_rx.recv() => {
                    if reconnect.is_none() {
                        return;
                    }
                    debug!("reconnect hint received");
                    retry_delay = RetryDelay::default();
                }
            }
        };

        debug!("ws connected");
        resp_tx.send(WrappedResponse::Connected).unwrap();

        let mut last_recv_timestamp = Instant::now();
        let mut interval =
            tokio::time::interval_at(tokio::time::Instant::now() + PING_PERIOD, PING_PERIOD);

        loop {
            tokio::select! {
                server_msg = ws_stream.select_next_some() => {
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

pub fn start() -> (
    UnboundedSender<WrappedRequest>,
    UnboundedReceiver<WrappedResponse>,
    UnboundedSender<()>,
) {
    let (req_tx, req_rx) = tokio::sync::mpsc::unbounded_channel::<WrappedRequest>();
    let (resp_tx, resp_rx) = tokio::sync::mpsc::unbounded_channel::<WrappedResponse>();
    let (hint_tx, hint_rx) = tokio::sync::mpsc::unbounded_channel::<()>();
    std::thread::spawn(move || {
        let rt = tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap();
        rt.block_on(run(req_rx, resp_tx, hint_rx));
    });
    (req_tx, resp_rx, hint_tx)
}
