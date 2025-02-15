use std::net::TcpListener;

use serde::{Deserialize, Serialize};
use tokio::sync::mpsc::{unbounded_channel, UnboundedSender};

use crate::Msg;

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum Request {
    TestSendUsdt(f64),
    TestRecvUsdt(f64),
    TestSendBtc(f64),
    TestRecvBtc(f64),
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum Response {
    Success(String),
    Error(String),
}

pub struct RequestData {
    pub req: Request,
    pub resp_tx: Option<UnboundedSender<Response>>,
}

pub fn send_request(msg_tx: &UnboundedSender<Msg>, req: Request) {
    msg_tx
        .send(Msg::Cli(RequestData { req, resp_tx: None }))
        .unwrap();
}

fn process_cli_client(
    msg_tx: UnboundedSender<Msg>,
    stream: std::net::TcpStream,
) -> Result<(), anyhow::Error> {
    let mut websocket = tungstenite::accept(stream)?;
    loop {
        let msg = match websocket.read() {
            Ok(v) => v,
            Err(_) => return Ok(()),
        };
        if msg.is_text() || msg.is_binary() {
            let req = msg.to_text()?.to_owned();
            let req = serde_json::from_str::<Request>(&req);
            let (resp_tx, mut resp_rx) = unbounded_channel::<Response>();
            match req {
                Ok(v) => msg_tx
                    .send(Msg::Cli(RequestData {
                        req: v,
                        resp_tx: Some(resp_tx),
                    }))
                    .unwrap(),
                Err(v) => resp_tx.send(Response::Error(v.to_string())).unwrap(),
            };
            let resp = resp_rx.blocking_recv().unwrap();
            let resp = serde_json::to_string(&resp).unwrap();
            websocket.write(tungstenite::protocol::Message::text(resp))?;
        }
    }
}

pub fn start(msg_tx: UnboundedSender<Msg>) {
    let server = TcpListener::bind("127.0.0.1:9001").unwrap();
    for stream in server.incoming() {
        let msg_tx_copy = msg_tx.clone();
        std::thread::spawn(move || {
            let result = process_cli_client(msg_tx_copy, stream.unwrap());
            if let Err(e) = result {
                log::error!("processing client failed: {}", &e);
            }
        });
    }
}
