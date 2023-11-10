use futures_util::{SinkExt, StreamExt};
use log::*;
use prost::Message;
use tokio_tungstenite::accept_hdr_async;

#[derive(Default, Clone)]
pub struct WsCallback {
    use_json: std::sync::Arc<std::sync::atomic::AtomicBool>,
}

impl tungstenite::handshake::server::Callback for WsCallback {
    fn on_request(
        self,
        request: &tungstenite::handshake::server::Request,
        response: tungstenite::handshake::server::Response,
    ) -> Result<
        tungstenite::handshake::server::Response,
        tungstenite::handshake::server::ErrorResponse,
    > {
        debug!("new request received to {}", request.uri());
        let use_json = match request.uri().path() {
            "/protobuf" => false,
            "/json" => true,
            _ => {
                return Err(tungstenite::handshake::server::ErrorResponse::new(Some(
                    "not found".to_owned(),
                )))
            }
        };
        self.use_json
            .store(use_json, std::sync::atomic::Ordering::Relaxed);
        Ok(response)
    }
}

#[tokio::main]
async fn main() {
    let matches = clap::App::new("sideswap_headless")
        .arg(clap::Arg::with_name("env_name").required(true))
        .arg(clap::Arg::with_name("work_dir").required(true))
        .arg(clap::Arg::with_name("tcp_address").required(true))
        .arg(
            clap::Arg::with_name("connect")
                .long("connect")
                .help("Connect to the specifed TCP address"),
        )
        .get_matches();
    let env_name = matches.value_of("env_name").unwrap();
    let work_dir = matches.value_of("work_dir").unwrap();
    let tcp_address = matches.value_of("tcp_address").unwrap();
    let connect = matches.is_present("connect");

    let env = match env_name {
        "prod" => sideswap_client::ffi::SIDESWAP_ENV_PROD,
        "testnet" => sideswap_client::ffi::SIDESWAP_ENV_TESTNET,
        "local" => sideswap_client::ffi::SIDESWAP_ENV_LOCAL_TESTNET,
        _ => unimplemented!("unknown env: {}", env_name),
    };

    let client_ptr = sideswap_client::ffi::sideswap_client_start(
        env,
        std::ffi::CString::new(work_dir)
            .unwrap()
            .as_c_str()
            .as_ptr(),
        std::ffi::CString::new("1.0.0").unwrap().as_c_str().as_ptr(),
        sideswap_client::ffi::SIDESWAP_DART_PORT_DISABLED,
    );
    assert!(client_ptr != 0);

    let stream = if connect {
        let stream = tokio::net::TcpStream::connect(tcp_address).await.unwrap();
        info!("successfully connected to  {}", tcp_address);
        stream
    } else {
        let listener = tokio::net::TcpListener::bind(tcp_address)
            .await
            .expect("bind failed");

        info!("waiting incoming connection on {}", tcp_address);
        let (stream, socket) = listener.accept().await.unwrap();
        drop(listener);
        info!("received a new connection from {}", socket);

        stream
    };

    let callback = WsCallback::default();
    let ws_stream = accept_hdr_async(stream, callback.clone()).await.unwrap();
    let (sink, mut stream) = ws_stream.split();
    let sink = std::sync::Arc::new(tokio::sync::Mutex::new(sink));
    let use_json = callback.use_json.load(std::sync::atomic::Ordering::Relaxed);

    let sink_copy = sink.clone();
    tokio::spawn(async move {
        loop {
            let msg = tokio::task::block_in_place(|| {
                let msg = sideswap_client::ffi::sideswap_recv_request(client_ptr);
                let ptr = sideswap_client::ffi::sideswap_msg_ptr(msg);
                let size = sideswap_client::ffi::sideswap_msg_len(msg);
                let msg_copy = unsafe { std::slice::from_raw_parts(ptr, size as usize) }.to_owned();
                sideswap_client::ffi::sideswap_msg_free(msg);
                msg_copy
            });
            let msg = if use_json {
                let msg = sideswap_client::ffi::proto::From::decode(msg.as_slice())
                    .expect("message decode failed");
                tungstenite::Message::Text(serde_json::to_string(&msg).unwrap())
            } else {
                tungstenite::Message::Binary(msg)
            };
            sink_copy.lock().await.send(msg).await.unwrap();
        }
    });

    while let Some(Ok(msg)) = stream.next().await {
        match msg {
            tungstenite::Message::Text(v) => {
                let parse_result = serde_json::from_str::<sideswap_client::ffi::proto::To>(&v);
                match parse_result {
                    Ok(msg) => {
                        let mut buf = Vec::new();
                        msg.encode(&mut buf).expect("encoding message failed");
                        sideswap_client::ffi::sideswap_send_request(
                            client_ptr,
                            buf.as_ptr(),
                            buf.len() as u64,
                        );
                    }
                    Err(e) => {
                        let error_msg =
                            tungstenite::Message::Text(format!("parsing failed: {}", e));
                        sink.lock().await.send(error_msg).await.unwrap();
                    }
                }
            }
            tungstenite::Message::Binary(data) => {
                sideswap_client::ffi::sideswap_send_request(
                    client_ptr,
                    data.as_ptr(),
                    data.len() as u64,
                );
            }
            tungstenite::Message::Ping(_) => {}
            tungstenite::Message::Pong(_) => {}
            tungstenite::Message::Frame(_) => {}
            tungstenite::Message::Close(_) => {
                debug!("close message received");
                break;
            }
        }
    }

    debug!("quit");
    std::process::exit(0);
}
