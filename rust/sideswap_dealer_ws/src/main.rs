use anyhow::{bail, ensure};
use clap::{App, Arg};
use futures_util::{SinkExt, StreamExt};
use log::*;
use serde::{Deserialize, Serialize};
use sideswap_common::*;
use sideswap_dealer::{dealer::*, rpc::RpcServer};
use std::net::SocketAddr;
use tokio::net::{TcpListener, TcpStream};
use tokio_tungstenite::accept_async;

#[derive(Debug, Deserialize)]
pub struct Settings {
    log_settings: String,
    env: types::Env,
    rpc: RpcServer,

    ws_listen_addr: String,
    ws_secret: String,

    bitcoin_amount_submit: f64,
    bitcoin_amount_max: f64,
    bitcoin_amount_min: f64,

    interest_submit: f64,
    interest_sign: f64,
}

async fn accept_connection(
    secret_expected: String,
    peer: SocketAddr,
    stream: TcpStream,
    clients: Clients,
    dealer_tx: std::sync::mpsc::Sender<To>,
) {
    if let Err(e) = handle_connection(secret_expected, peer, stream, &clients, dealer_tx).await {
        error!("error: {}", e);
    }
}

type ClientSink = tokio::sync::mpsc::UnboundedSender<String>;
#[derive(Default, Clone)]
struct Clients {
    sinks: std::sync::Arc<std::sync::Mutex<Vec<ClientSink>>>,
}

fn parse_message(msg: &tungstenite::Message) -> Result<To, anyhow::Error> {
    let text = msg.to_text()?;
    let msg = serde_json::from_str(text)?;
    Ok(msg)
}

#[derive(Serialize, Deserialize, Debug)]
struct ErrorMsg {
    error_msg: String,
}
#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "snake_case")]
pub enum StartRequest {
    Authorize(String),
}

async fn read_loop(
    mut stream: futures_util::stream::SplitStream<tokio_tungstenite::WebSocketStream<TcpStream>>,
    dealer_tx: std::sync::mpsc::Sender<To>,
    send_tx: tokio::sync::mpsc::UnboundedSender<String>,
) -> Result<(), anyhow::Error> {
    while let Some(msg) = stream.next().await {
        let msg = msg?;
        if msg.is_text() || msg.is_binary() {
            let parsed_msg = parse_message(&msg);
            match parsed_msg {
                Ok(v) => dealer_tx.send(v).unwrap(),
                Err(e) => {
                    error!("invalid message: {:?}: {}", &msg, e.to_string());
                    let error = ErrorMsg {
                        error_msg: e.to_string(),
                    };
                    let error_msg = serde_json::to_string(&error).unwrap();
                    send_tx.send(error_msg)?;
                }
            }
        }
    }
    Ok(())
}

async fn handle_connection(
    secret_expected: String,
    peer: SocketAddr,
    stream: TcpStream,
    clients: &Clients,
    dealer_tx: std::sync::mpsc::Sender<To>,
) -> Result<(), anyhow::Error> {
    info!("new connection: {}", peer);
    let ws_stream = accept_async(stream).await?;
    let (mut sink, mut stream) = ws_stream.split();

    let start_request = match stream.next().await {
        Some(x) => x?,
        None => bail!("no login request received"),
    };
    let start_request = match start_request {
        tungstenite::Message::Text(v) => serde_json::from_str::<StartRequest>(&v)?,
        tungstenite::Message::Binary(v) => serde_json::from_slice::<StartRequest>(&v)?,
        _ => bail!("expecting authorize request"),
    };
    let StartRequest::Authorize(secret_user) = start_request;
    ensure!(secret_expected == secret_user);
    info!("client successfully authorized: {}", peer);

    let (send_tx, mut send_rx) = tokio::sync::mpsc::unbounded_channel::<String>();
    tokio::spawn(async move {
        loop {
            let msg = match send_rx.recv().await {
                Some(v) => v,
                None => break,
            };
            let result = sink.send(tungstenite::Message::Text(msg)).await;
            if result.is_err() {
                break;
            }
        }
        debug!("stop reading thread: {}", peer);
    });

    clients.sinks.lock().unwrap().push(send_tx.clone());

    let dealer_tx_copy = dealer_tx.clone();
    let result = read_loop(stream, dealer_tx_copy, send_tx.clone()).await;
    if let Err(e) = result {
        error!("reading failed: {}", e);
    }

    debug!("stop writing thread: {}", peer);

    clients
        .sinks
        .lock()
        .unwrap()
        .retain(|v| !v.same_channel(&send_tx));

    debug!("reset prices");
    dealer_tx.send(To::ResetPrices(None)).unwrap();

    Ok(())
}

async fn start_processing(
    ws_listen_addr: String,
    secret_expected: String,
    clients: Clients,
    dealer_tx: std::sync::mpsc::Sender<To>,
) {
    let listener = TcpListener::bind(&ws_listen_addr)
        .await
        .expect("bind failed");
    info!("listening on {}", ws_listen_addr);

    while let Ok((stream, _)) = listener.accept().await {
        let peer = stream
            .peer_addr()
            .expect("connected streams should have a peer address");
        info!("peer address: {}", peer);

        let clients_copy = clients.clone();
        let secret_expected_copy = secret_expected.clone();
        tokio::spawn(accept_connection(
            secret_expected_copy,
            peer,
            stream,
            clients_copy,
            dealer_tx.clone(),
        ));
    }
}

fn main() {
    let matches = App::new("sideswap_dealer")
        .arg(Arg::with_name("config").required(true))
        .get_matches();
    let config_path = matches.value_of("config").unwrap();

    info!("starting up");

    let mut conf = config::Config::new();
    conf.merge(config::File::with_name(config_path))
        .expect("can't load config");
    conf.merge(config::Environment::with_prefix("app").separator("_"))
        .expect("reading env failed");
    let settings: Settings = conf.try_into().expect("invalid config");

    log4rs::init_file(&settings.log_settings, Default::default()).expect("can't open log settings");

    let tickers = vec![DEALER_USDT].into_iter().collect();

    let env_data = settings.env.data();
    let params = Params {
        env: settings.env,
        server_host: env_data.host.to_owned(),
        server_port: env_data.port,
        server_use_tls: env_data.use_tls,
        rpc: settings.rpc.clone(),
        interest_submit: settings.interest_submit,
        interest_sign: settings.interest_sign,
        tickers,
        bitcoin_amount_submit: types::Amount::from_bitcoin(settings.bitcoin_amount_submit),
        bitcoin_amount_min: types::Amount::from_bitcoin(settings.bitcoin_amount_min),
        bitcoin_amount_max: types::Amount::from_bitcoin(settings.bitcoin_amount_max),
    };

    let (dealer_tx, dealer_rx) = start(params.clone());

    dealer_tx
        .send(To::LimitBalance(ToLimitBalance {
            ticker: DEALER_LBTC,
            balance: settings.bitcoin_amount_max,
            recv_limit: true,
        }))
        .unwrap();
    dealer_tx
        .send(To::LimitBalance(ToLimitBalance {
            ticker: DEALER_LBTC,
            balance: settings.bitcoin_amount_max,
            recv_limit: false,
        }))
        .unwrap();

    let clients = Clients::default();

    let clients_copy = clients.clone();
    let dealer_tx_copy = dealer_tx.clone();
    let ws_listen_addr = settings.ws_listen_addr.clone();
    let secret_expected = settings.ws_secret.clone();
    std::thread::spawn(move || {
        let rt = tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap();
        rt.block_on(start_processing(
            ws_listen_addr,
            secret_expected,
            clients_copy,
            dealer_tx_copy,
        ));
    });

    loop {
        let msg = dealer_rx.recv().unwrap();
        let msg = serde_json::to_string(&msg).unwrap();
        info!("send: {}", &msg);
        clients
            .sinks
            .lock()
            .unwrap()
            .retain(|sink| sink.send(msg.clone()).is_ok());
    }
}
