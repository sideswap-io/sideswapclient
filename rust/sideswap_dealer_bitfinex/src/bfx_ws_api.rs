use std::time::{Duration, Instant};

use anyhow::{anyhow, bail, ensure};
use futures::prelude::*;
use serde::{Deserialize, Serialize};
use sideswap_common::{channel_helpers::UncheckedUnboundedSender, retry_delay::RetryDelay};
use tokio::sync::mpsc::{UnboundedReceiver, UnboundedSender};
use tokio_tungstenite::connect_async;

use crate::{bitfinex_api::new_nonce, BfSettings, ExchangePair};

#[derive(Debug, PartialEq, Deserialize)]
pub enum WalletType {
    Exchange,
    Margin,
    Funding,
    Unknown,
}

#[derive(Debug, PartialEq)]
pub enum Event {
    Connected,

    Disconnected {
        reason: String,
    },

    WalletBalance {
        wallet_type: WalletType,
        currency: String,
        balance: f64,
    },

    OrderCancel {
        symbol: String,
        cid: i64,
        id: i64,
        amount_orig: f64,
        price_avg: f64,
    },

    BookUpdate {
        symbol: String,
        bid: f64,
        ask: f64,
    },
}

#[derive(Debug)]
pub enum Command {}

#[derive(Deserialize, Debug)]
#[allow(dead_code)]
pub struct PlatformStatus {
    status: u32,
}

#[derive(Deserialize, Debug)]
#[allow(dead_code)]
pub struct ConnStatus {
    event: String,
    version: u32,
    platform: PlatformStatus,
}

#[derive(Serialize)]
#[serde(tag = "event")]
pub enum Req {
    #[serde(rename = "auth")]
    Auth {
        #[serde(rename = "apiKey")]
        api_key: String,
        #[serde(rename = "authPayload")]
        auth_payload: String,
        #[serde(rename = "authSig")]
        auth_sig: String,
        #[serde(rename = "authNonce")]
        auth_nonce: String,
    },

    #[serde(rename = "conf")]
    Conf { flags: u32 },

    #[serde(rename = "subscribe")]
    Subscribe { channel: String, symbol: String },
}

#[derive(Deserialize)]
#[serde(tag = "event")]
pub enum Resp {
    #[serde(rename = "auth")]
    Auth { status: String },

    #[serde(rename = "conf")]
    Conf {
        status: String,
        #[allow(unused)]
        flags: u32,
    },

    #[serde(rename = "subscribed")]
    Subscribed {
        channel: String,
        #[serde(rename = "chanId")]
        chan_id: i64,
        symbol: String,
        prec: String,
        freq: String,
        len: String,
        pair: String,
    },

    #[serde(rename = "info")]
    Info { code: u32, msg: String },
}

#[derive(Debug)]
struct PricePoint {
    price: f64,
    amount: f64,
    // Store original string values to make sure we can implement crc32 check.
    // Without this CRC32 check might fail for some numbers (like 0.00000016 in JS vs 1.6e-7 in Rust).
    price_orig: String,
    amount_orig: String,
}

struct Book {
    chan_id: i64,
    symbol: String,
    _pair: String,
    points: Vec<PricePoint>,
    last_bid: f64,
    last_ask: f64,
    last_hb: Instant,
}

struct State {
    books: Vec<Book>,
    last_hb: Instant,
}

impl State {
    pub fn new() -> Self {
        Self {
            books: Vec::new(),
            last_hb: Instant::now(),
        }
    }
}

const CONF_FLAG_BOOK_CHECKSUM: u32 = 131072;
const CONF_FLAG_BULK_UPDATES: u32 = 536870912;

type Conn =
    tokio_tungstenite::WebSocketStream<tokio_tungstenite::MaybeTlsStream<tokio::net::TcpStream>>;

async fn next_msg<T: serde::de::DeserializeOwned>(conn: &mut Conn) -> Result<T, anyhow::Error> {
    loop {
        let msg = conn
            .next()
            .await
            .ok_or_else(|| anyhow!("connection closed unexpectedly"))??;
        match msg {
            tungstenite::Message::Text(text) => {
                log::debug!("bf message received: {text}");
                let msg = serde_json::from_str(&text)?;
                return Ok(msg);
            }
            tungstenite::Message::Binary(_) => bail!("unexpected binary message received"),
            tungstenite::Message::Ping(_) => {}
            tungstenite::Message::Pong(_) => {}
            tungstenite::Message::Close(info) => {
                bail!("close message received: {info:?}");
            }
            tungstenite::Message::Frame(_) => bail!("unexpected frame message received"),
        }
    }
}

fn get_event_from_wallet_array(wallet_array: &serde_json::Value) -> Result<Event, anyhow::Error> {
    // See https://docs.bitfinex.com/reference/ws-auth-wallets
    let wallet_array = wallet_array
        .as_array()
        .ok_or_else(|| anyhow!("WALLET_ARRAY must be array"))?;
    let wallet_type = wallet_array
        .first()
        .ok_or_else(|| anyhow!("no WALLET_TYPE"))?
        .as_str()
        .ok_or_else(|| anyhow!("WALLET_TYPE must be string"))?;
    let wallet_type = match wallet_type {
        "exchange" => WalletType::Exchange,
        "margin" => WalletType::Margin,
        "funding" => WalletType::Funding,
        _ => WalletType::Unknown,
    };
    let currency = wallet_array
        .get(1)
        .ok_or_else(|| anyhow!("no CURRENCY"))?
        .as_str()
        .ok_or_else(|| anyhow!("CURRENCY must be string"))?;
    let balance = wallet_array
        .get(2)
        .ok_or_else(|| anyhow!("no BALANCE"))?
        .as_number()
        .ok_or_else(|| anyhow!("BALANCE must be number"))?
        .as_f64()
        .ok_or_else(|| anyhow!("BALANCE must be f64"))?;
    Ok(Event::WalletBalance {
        wallet_type,
        currency: currency.to_owned(),
        balance,
    })
}

fn get_event_from_order_array(order_array: &serde_json::Value) -> Result<Event, anyhow::Error> {
    // See https://docs.bitfinex.com/reference/ws-auth-orders
    let order_array = order_array
        .as_array()
        .ok_or_else(|| anyhow!("ORDER_ARRAY must be array"))?;

    let id = order_array
        .first()
        .ok_or_else(|| anyhow!("no ID"))?
        .as_number()
        .ok_or_else(|| anyhow!("ID must be number"))?
        .as_i64()
        .ok_or_else(|| anyhow!("ID must be i64"))?;
    let cid = order_array
        .get(2)
        .ok_or_else(|| anyhow!("no CID"))?
        .as_number()
        .ok_or_else(|| anyhow!("CID must be number"))?
        .as_i64()
        .ok_or_else(|| anyhow!("CID must be i64"))?;
    let symbol = order_array
        .get(3)
        .ok_or_else(|| anyhow!("no SYMBOL"))?
        .as_str()
        .ok_or_else(|| anyhow!("SYMBOL must be string"))?
        .to_owned();
    let amount_orig = order_array
        .get(7)
        .ok_or_else(|| anyhow!("no AMOUNT_ORIG"))?
        .as_number()
        .ok_or_else(|| anyhow!("AMOUNT_ORIG must be number"))?
        .as_f64()
        .ok_or_else(|| anyhow!("AMOUNT_ORIG must be f64"))?;
    let price_avg = order_array
        .get(17)
        .ok_or_else(|| anyhow!("no PRICE_AVG"))?
        .as_number()
        .ok_or_else(|| anyhow!("PRICE_AVG must be number"))?
        .as_f64()
        .ok_or_else(|| anyhow!("PRICE_AVG must be f64"))?;
    Ok(Event::OrderCancel {
        symbol,
        cid,
        id,
        amount_orig,
        price_avg,
    })
}

fn get_checksum(points: &[PricePoint]) -> u32 {
    const COUNT: usize = 25;
    let mut bids = points
        .iter()
        .filter(|point| point.amount > 0.0)
        .collect::<Vec<_>>();
    let mut asks = points
        .iter()
        .filter(|point| point.amount < 0.0)
        .collect::<Vec<_>>();
    bids.sort_by(|a, b| b.price.total_cmp(&a.price));
    asks.sort_by(|a, b| a.price.total_cmp(&b.price));
    let mut list = Vec::<u8>::new();
    list.reserve(2000);
    for index in 0..COUNT {
        let mut try_append = |bids_asks: &[&PricePoint]| {
            if let Some(point) = bids_asks.get(index) {
                list.extend_from_slice(point.price_orig.as_bytes());
                list.push(b':');
                list.extend_from_slice(point.amount_orig.as_bytes());
                list.push(b':');
            }
        };
        try_append(&bids);
        try_append(&asks);
    }
    list.pop();
    crc32fast::hash(&list)
}

fn process_book_update(
    book: &mut Book,
    new_points: &[serde_json::Value],
) -> Result<Vec<Event>, anyhow::Error> {
    for new_point in new_points {
        let new_point = new_point
            .as_array()
            .ok_or_else(|| anyhow!("array is expected"))?;

        let price_orig = new_point
            .first()
            .ok_or_else(|| anyhow!("can't find PRICE"))?
            .as_number()
            .ok_or_else(|| anyhow!("PRICE must be number"))?;
        let price = price_orig
            .as_f64()
            .ok_or_else(|| anyhow!("PRICE must be f64"))?;

        let count = new_point
            .get(1)
            .ok_or_else(|| anyhow!("can't find COUNT"))?
            .as_number()
            .ok_or_else(|| anyhow!("COUNT must be i64"))?
            .as_i64()
            .ok_or_else(|| anyhow!("COUNT must be i64"))?;

        let amount_orig = new_point
            .get(2)
            .ok_or_else(|| anyhow!("can't find AMOUNT"))?
            .as_number()
            .ok_or_else(|| anyhow!("AMOUNT must be number"))?;
        let amount = amount_orig
            .as_f64()
            .ok_or_else(|| anyhow!("AMOUNT must be f64"))?;

        ensure!(price > 0.0);
        ensure!(amount != 0.0);

        let index = book
            .points
            .iter_mut()
            .position(|point| point.price == price && point.amount.signum() == amount.signum());
        if count == 0 {
            let index = index.ok_or_else(|| anyhow!("can't find point"))?;
            book.points.remove(index);
        } else if let Some(index) = index {
            book.points[index] = PricePoint {
                price,
                amount,
                price_orig: price_orig.as_str().to_owned(),
                amount_orig: amount_orig.as_str().to_owned(),
            };
        } else {
            book.points.push(PricePoint {
                price,
                amount,
                price_orig: price_orig.as_str().to_owned(),
                amount_orig: amount_orig.as_str().to_owned(),
            });
        }
    }

    let bid = book
        .points
        .iter()
        .filter(|point| point.amount > 0.0)
        .map(|point| point.price)
        .fold(f64::NEG_INFINITY, |a, b| a.max(b));
    let ask = book
        .points
        .iter()
        .filter(|point| point.amount < 0.0)
        .map(|point| point.price)
        .fold(f64::INFINITY, |a, b| a.min(b));
    ensure!(bid.is_normal());
    ensure!(ask.is_normal());
    ensure!(bid <= ask);

    if book.last_ask != ask || book.last_bid != bid {
        book.last_ask = ask;
        book.last_bid = bid;
        Ok(vec![Event::BookUpdate {
            symbol: book.symbol.clone(),
            bid,
            ask,
        }])
    } else {
        Ok(Vec::new())
    }
}

fn process_book_cs(book: &mut Book, server_cs: u32) -> Result<Vec<Event>, anyhow::Error> {
    let local_cs = get_checksum(&book.points);
    let valid_cs = server_cs == local_cs;
    ensure!(
        valid_cs,
        "checksum failed for {:?}, server: {}, local: {}",
        book.points,
        server_cs,
        local_cs,
    );
    Ok(Vec::new())
}

fn process_book_msg(
    state: &mut State,
    list: Vec<serde_json::Value>,
    chan_id: i64,
    orig_msg: &str,
) -> Result<Vec<Event>, anyhow::Error> {
    let book = match state.books.iter_mut().find(|book| book.chan_id == chan_id) {
        Some(book) => book,
        None => {
            if list.get(1).and_then(|value| value.as_str()) == Some("hb") {
                log::debug!("ignore unexpected hb messages to {chan_id}");
                return Ok(Vec::new());
            }
            bail!("can't find book with chan_id {chan_id}")
        }
    };

    if let Some(new_points) = list.get(1).and_then(|list| list.as_array()) {
        process_book_update(book, new_points)
    } else if let Some("cs") = list.get(1).and_then(|list| list.as_str()) {
        let server_cs = list
            .get(2)
            .ok_or_else(|| anyhow!("can't find CRC value"))?
            .as_number()
            .ok_or_else(|| anyhow!("CRC must be number"))?
            .as_i64()
            .ok_or_else(|| anyhow!("CRC value must be i64"))? as i32 as u32;
        process_book_cs(book, server_cs)
    } else if let Some("hb") = list.get(1).and_then(|list| list.as_str()) {
        book.last_hb = Instant::now();
        Ok(Vec::new())
    } else {
        log::warn!("unknown bfx message ignored: {orig_msg}");
        Ok(Vec::new())
    }
}

fn get_events_from_array(
    state: &mut State,
    list: Vec<serde_json::Value>,
    orig_msg: &str,
) -> Result<Vec<Event>, anyhow::Error> {
    let chan_id = list
        .first()
        .ok_or_else(|| anyhow!("no CHAN_ID"))?
        .as_number()
        .ok_or_else(|| anyhow!("CHAN_ID must be number"))?
        .as_i64()
        .ok_or_else(|| anyhow!("CHAN_ID must be i64"))?;
    if chan_id != 0 {
        process_book_msg(state, list, chan_id, orig_msg)
    } else if list.get(1).and_then(|value| value.as_str()) == Some("hb") {
        state.last_hb = Instant::now();
        Ok(Vec::new())
    } else {
        log::debug!("bf message received: {orig_msg}");
        let msg_type = list
            .get(1)
            .ok_or_else(|| anyhow!("no MSG_TYPE"))?
            .as_str()
            .ok_or_else(|| anyhow!("MSG_TYPE must be string"))?;

        if chan_id == 0 && msg_type == "ws" {
            let wallet_snapshot = list
                .get(2)
                .ok_or_else(|| anyhow!("no WALLET_SNAPSHOT"))?
                .as_array()
                .ok_or_else(|| anyhow!("WALLET_SNAPSHOT must be array"))?;

            wallet_snapshot
                .iter()
                .map(get_event_from_wallet_array)
                .collect::<Result<Vec<_>, _>>()
        } else if chan_id == 0 && msg_type == "wu" {
            let wallet_array = list.get(2).ok_or_else(|| anyhow!("no WALLET_ARRAY"))?;
            get_event_from_wallet_array(wallet_array).map(|event| vec![event])
        } else if chan_id == 0 && msg_type == "oc" {
            let order = list.get(2).ok_or_else(|| anyhow!("no ORDER_ARRAY"))?;
            get_event_from_order_array(order).map(|event| vec![event])
        } else {
            Ok(Vec::new())
        }
    }
}

fn process_object_msg(
    state: &mut State,
    obj: serde_json::Map<String, serde_json::Value>,
    orig_msg: &str,
) -> Result<Vec<Event>, anyhow::Error> {
    log::debug!("bf message received: {orig_msg}");
    let resp = serde_json::from_value::<Resp>(serde_json::Value::Object(obj))?;
    match resp {
        Resp::Auth { .. } => bail!("unexpected Resp::Auth response"),

        Resp::Conf { status, flags: _ } => {
            ensure!(status == "OK");
        }

        Resp::Subscribed {
            channel,
            chan_id,
            symbol,
            prec,
            freq,
            len,
            pair,
        } => {
            ensure!(channel == "book");
            ensure!(prec == "P0");
            ensure!(freq == "F0");
            ensure!(len == "25");
            log::debug!("subscribed to {symbol}");
            state.books.push(Book {
                chan_id,
                symbol,
                _pair: pair,
                points: Vec::new(),
                last_bid: 0.0,
                last_ask: 0.0,
                last_hb: Instant::now(),
            });
        }

        Resp::Info { code, msg } => {
            // const INFO_CODE_RECONNECT: u32 = 20051;
            // const INFO_CODE_MAINTENANCE_STARTED: u32 = 20060;
            // const INFO_CODE_MAINTENANCE_ENDED: u32 = 20061;

            // Stop connection to keep things simple.
            // The dealer won't start until platform.status is 1 so it's enough.
            bail!("info message received, code: {code}, msg: {msg}");
        }
    }

    Ok(Vec::new())
}

fn get_events(state: &mut State, orig_msg: &str) -> Result<Vec<Event>, anyhow::Error> {
    let msg = serde_json::from_str::<serde_json::Value>(orig_msg)?;

    match msg {
        serde_json::Value::Array(list) => get_events_from_array(state, list, orig_msg),
        serde_json::Value::Object(obj) => process_object_msg(state, obj, orig_msg),

        serde_json::Value::Null
        | serde_json::Value::Bool(_)
        | serde_json::Value::Number(_)
        | serde_json::Value::String(_) => bail!("unexpected ws message"),
    }
}

async fn process_ws_message(
    state: &mut State,
    event_sender: &UncheckedUnboundedSender<Event>,
    msg: tungstenite::Message,
) -> Result<(), anyhow::Error> {
    match msg {
        tungstenite::Message::Text(msg) => {
            let events = get_events(state, &msg)
                .map_err(|err| anyhow!("unexpected bfx error: {err}, msg: '{msg}'"))?;
            for event in events {
                event_sender.send(event);
            }
            Ok(())
        }
        tungstenite::Message::Binary(_) => bail!("unexpected binary message received"),
        tungstenite::Message::Ping(_) => Ok(()),
        tungstenite::Message::Pong(_) => Ok(()),
        tungstenite::Message::Close(info) => {
            bail!("close message received: {info:?}");
        }
        tungstenite::Message::Frame(_) => bail!("unexpected frame message received"),
    }
}

async fn process_command(_req: Command) -> Result<(), anyhow::Error> {
    Ok(())
}

pub async fn connect(settings: &BfSettings) -> Result<Conn, anyhow::Error> {
    let url = "wss://api.bitfinex.com/ws/2";

    let (mut conn, _resp) = connect_async(url).await?;

    let msg = next_msg::<ConnStatus>(&mut conn).await?;
    ensure!(msg.platform.status == 1);

    let auth_nonce = new_nonce();
    let auth_payload = format!("AUTH{auth_nonce}");
    let key = ring::hmac::Key::new(ring::hmac::HMAC_SHA384, settings.bitfinex_secret.as_bytes());
    let tag = ring::hmac::sign(&key, auth_payload.as_bytes());
    let auth_sig = hex::encode(tag.as_ref());

    let auth_req = Req::Auth {
        api_key: settings.bitfinex_key.clone(),
        auth_payload,
        auth_sig,
        auth_nonce,
    };
    let auth_req = serde_json::to_string(&auth_req).expect("must not fail");
    conn.send(tungstenite::Message::text(auth_req)).await?;

    let auth_resp = next_msg::<Resp>(&mut conn).await?;
    match auth_resp {
        Resp::Auth { status } => ensure!(status == "OK"),
        _ => bail!("unexpected response, expected Resp::Auth"),
    }

    let conf_req = Req::Conf {
        flags: CONF_FLAG_BOOK_CHECKSUM | CONF_FLAG_BULK_UPDATES,
    };
    let conf_req = serde_json::to_string(&conf_req).expect("must not fail");
    conn.send(tungstenite::Message::text(conf_req)).await?;

    for exchange_pair in ExchangePair::ALL {
        let sub_req = Req::Subscribe {
            channel: "book".to_owned(),
            symbol: exchange_pair.bfx_bookname().to_owned(),
        };
        let sub_req = serde_json::to_string(&sub_req).expect("must not fail");
        conn.send(tungstenite::Message::text(sub_req)).await?;
    }

    Ok(conn)
}

fn check_hb(state: &State) -> Result<(), anyhow::Error> {
    for book in &state.books {
        let hb_age = Instant::now().duration_since(book.last_hb);
        ensure!(hb_age < Duration::from_secs(60));
    }
    let hb_age = Instant::now().duration_since(state.last_hb);
    ensure!(hb_age < Duration::from_secs(60));
    Ok(())
}

pub async fn run_once(
    conn: &mut Conn,
    command_receiver: &mut UnboundedReceiver<Command>,
    event_sender: &UncheckedUnboundedSender<Event>,
) -> Result<(), anyhow::Error> {
    let mut state = State::new();
    let mut interval = tokio::time::interval(Duration::from_secs(10));

    loop {
        tokio::select! {
            msg = conn.next() => {
                let msg = msg.ok_or_else(|| anyhow!("ws connection closed"))??;
                process_ws_message(&mut state, event_sender, msg).await?;
            },

            req = command_receiver.recv() => {
                let req = req.ok_or_else(|| anyhow!("channel closed"))?;
                process_command(req).await?;
            }

            _ = interval.tick() => {
                check_hb(&state)?;
            },
        };
    }
}

pub async fn run(
    settings: BfSettings,
    mut command_receiver: UnboundedReceiver<Command>,
    event_sender: UnboundedSender<Event>,
) {
    let event_sender = UncheckedUnboundedSender::from(event_sender);
    let mut reconnect_delay = RetryDelay::default();

    while !command_receiver.is_closed() {
        let res = tokio::time::timeout(Duration::from_secs(60), connect(&settings)).await;

        let res = match res {
            Ok(Ok(conn)) => Ok(conn),
            Ok(Err(err)) => Err(err),
            Err(_err) => Err(anyhow!("bfx connection timeout")),
        };

        let mut conn = match res {
            Ok(conn) => conn,
            Err(err) => {
                let delay = reconnect_delay.next_delay();
                log::error!(
                    "bfx connection failed: {err}, wait {}ms before reconnect...",
                    delay.as_millis()
                );
                tokio::time::sleep(delay).await;
                continue;
            }
        };

        // No need to wait, because bfx was up last time
        reconnect_delay = RetryDelay::default();

        event_sender.send(Event::Connected);

        let res = run_once(&mut conn, &mut command_receiver, &event_sender).await;

        let reason = match res {
            Ok(()) => "stopped normally".to_owned(),
            Err(err) => err.to_string(),
        };

        event_sender.send(Event::Disconnected { reason });
    }
}

#[cfg(test)]
mod tests;
