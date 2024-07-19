use std::collections::BTreeMap;

use serde::Deserialize;
use sideswap_api::{
    AssetId, Request, ResponseMessage, SubscribePriceStreamRequest, SubscribePriceStreamResponse,
};
use sideswap_common::{
    types::COIN,
    ws::{
        self,
        auto::{WrappedRequest, WrappedResponse},
    },
};
use tokio::sync::mpsc::UnboundedSender;

#[derive(Debug, Deserialize)]
pub struct Settings {
    log_settings: String,
    env: sideswap_common::env::Env,
}

#[derive(Debug)]
#[allow(dead_code)]
enum State {
    Max(f64),
    Error(String),
}

struct Subscribe {
    ticker: String,
    asset_id: AssetId,
    send_bitcoins: bool,
    send_amount: Option<i64>,
    recv_amount: Option<i64>,
    state: Option<State>,
}

type Subscribes = BTreeMap<String, Subscribe>;

fn add_sub(subs: &mut Subscribes, asset_id: &AssetId, ticker: &str) {
    let big_amount = 1000 * COIN;

    subs.insert(
        format!("{ticker}/send"),
        Subscribe {
            ticker: ticker.to_owned(),
            asset_id: *asset_id,
            send_bitcoins: true,
            send_amount: Some(big_amount),
            recv_amount: None,
            state: None,
        },
    );

    subs.insert(
        format!("{ticker}/recv"),
        Subscribe {
            ticker: ticker.to_owned(),
            asset_id: *asset_id,
            send_bitcoins: false,
            send_amount: None,
            recv_amount: Some(big_amount),
            state: None,
        },
    );
}

fn send_req(ws_tx: &UnboundedSender<WrappedRequest>, req: Request) {
    ws_tx
        .send(WrappedRequest::Request(
            sideswap_api::RequestMessage::Request(sideswap_api::RequestId::Int(0), req),
        ))
        .unwrap();
}

fn process_price_resp(subs: &mut Subscribes, resp: SubscribePriceStreamResponse) {
    let subscribe_id = resp.subscribe_id.unwrap();
    let sub = subs.get_mut(&subscribe_id).unwrap();

    // We use very high amount to subscribe so it should always fail
    let error_msg = resp
        .error_msg
        .expect("all subscribes are expected to return error_msg");
    let state = if let Some(max_amount) = error_msg.strip_prefix("Max: ") {
        let number = if let Some(without_rebalancing_note) =
            max_amount.strip_suffix(", re-balancing in progress")
        {
            without_rebalancing_note
        } else {
            max_amount
        };
        let max: f64 = number
            .parse()
            .map_err(|err| anyhow::anyhow!("invalid status: {error_msg}: {err}"))
            .unwrap();
        State::Max(max)
    } else {
        State::Error(error_msg.to_owned())
    };
    log::debug!("updated: {}: {:?}", subscribe_id, state);
    sub.state = Some(state);
}

#[tokio::main]
async fn main() {
    let args = std::env::args().collect::<Vec<_>>();
    assert!(
        args.len() == 2,
        "Specify a single argument for the path to the config file"
    );
    let config_path = &args[1];

    let mut conf = config::Config::new();
    conf.merge(config::File::with_name(config_path))
        .expect("can't load config");
    conf.merge(config::Environment::with_prefix("app").separator("_"))
        .expect("reading env failed");
    let Settings { log_settings, env } = conf.try_into().expect("invalid config");

    log4rs::init_file(&log_settings, Default::default()).expect("can't open log settings");

    log::info!("starting up");

    sideswap_common::panic_handler::install_panic_handler();

    let known_assets = &env.d().network.d().known_assets;

    let (req_sender, req_receiver) = tokio::sync::mpsc::unbounded_channel::<WrappedRequest>();
    let (resp_sender, mut resp_receiver) =
        tokio::sync::mpsc::unbounded_channel::<WrappedResponse>();
    tokio::spawn(sideswap_common::ws::auto::run(
        env.base_server_ws_url(),
        req_receiver,
        resp_sender,
    ));

    let mut subs = Subscribes::new();
    add_sub(&mut subs, &known_assets.usdt.asset_id(), "usdt");
    add_sub(&mut subs, &known_assets.eurx.asset_id(), "eurx");
    add_sub(&mut subs, &known_assets.depix.asset_id(), "depix");

    let mut ticker_states = BTreeMap::new();
    for sub in subs.values() {
        ticker_states.insert(sub.ticker.clone(), true);
    }

    loop {
        let msg = resp_receiver.recv().await.expect("must be open");
        match msg {
            ws::auto::WrappedResponse::Connected => {
                log::info!("connected to the server");
                for (subscribe_id, sub) in subs.iter() {
                    send_req(
                        &req_sender,
                        Request::SubscribePriceStream(SubscribePriceStreamRequest {
                            subscribe_id: Some(subscribe_id.to_owned()),
                            asset: sub.asset_id,
                            send_bitcoins: sub.send_bitcoins,
                            send_amount: sub.send_amount,
                            recv_amount: sub.recv_amount,
                        }),
                    );
                }
            }
            ws::auto::WrappedResponse::Disconnected => {
                log::warn!("disconnected from the server");
                for sub in subs.values_mut() {
                    sub.state = None;
                }
            }
            ws::auto::WrappedResponse::Response(ResponseMessage::Response(_, res)) => {
                let resp = res.expect("should not fail");
                if let sideswap_api::Response::SubscribePriceStream(resp) = resp {
                    process_price_resp(&mut subs, resp);
                }
            }
            ws::auto::WrappedResponse::Response(ResponseMessage::Notification(notif)) => {
                if let sideswap_api::Notification::UpdatePriceStream(resp) = notif {
                    process_price_resp(&mut subs, resp);
                }
            }
        }

        for (ticker, state) in ticker_states.clone() {
            let new_state = subs
                .values()
                .filter(|sub| sub.ticker == ticker)
                .all(|sub| matches!(sub.state, Some(State::Max(_))));
            if state != new_state {
                log::info!(
                    "ticker state changed, ticker: {}, valid: {}",
                    ticker,
                    new_state
                );
                ticker_states.insert(ticker, new_state);
            }
        }
    }
}
