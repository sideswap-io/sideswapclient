use std::{collections::BTreeMap, net::SocketAddr};

use poem::{error::ResponseError, listener::TcpListener, IntoResponse, Route, Server};
use poem_openapi::{param::Query, payload::Json, Enum, Object, OpenApi, OpenApiService};
use serde::{Deserialize, Serialize};
use sideswap_api::market::{self, OrdId};
use sideswap_types::normal_float::{NormalFloat, NotNormalError};
use tokio::sync::{
    mpsc::{self, UnboundedSender, WeakUnboundedSender},
    oneshot,
};

#[derive(Debug, Clone, Deserialize)]
pub struct Config {
    listen_on: SocketAddr,
    server_url: Option<String>,
}

use crate::types::{dealer_ticker_from_asset_ticker, DealerTicker, ExchangePair};

use super::Command;

struct Api {
    command_sender: WeakUnboundedSender<Command>,
}

#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("Channel closed")]
    ChannelClosed,
    #[error("Unknown ticker: {0}")]
    UnknownTicker(String),
    #[error("Invalid float: {0}")]
    InvalidFloat(NotNormalError),
}

impl From<oneshot::error::RecvError> for Error {
    fn from(_value: oneshot::error::RecvError) -> Self {
        Error::ChannelClosed
    }
}

impl<T> From<mpsc::error::SendError<T>> for Error {
    fn from(_value: mpsc::error::SendError<T>) -> Self {
        Error::ChannelClosed
    }
}

#[derive(Serialize)]
pub struct ErrorResponse {
    text: String,
}

impl ResponseError for Error {
    fn status(&self) -> poem::http::StatusCode {
        poem::http::StatusCode::BAD_REQUEST
    }

    fn as_response(&self) -> poem::Response {
        let error = ErrorResponse {
            text: self.to_string(),
        };

        let mut resp = poem::web::Json(error).into_response();
        resp.set_status(self.status());
        resp
    }
}

#[derive(Debug, Enum)]
enum TradeDir {
    Sell,
    Buy,
}

impl From<market::TradeDir> for TradeDir {
    fn from(value: market::TradeDir) -> Self {
        match value {
            market::TradeDir::Sell => TradeDir::Sell,
            market::TradeDir::Buy => TradeDir::Buy,
        }
    }
}

impl Into<market::TradeDir> for TradeDir {
    fn into(self) -> market::TradeDir {
        match self {
            TradeDir::Sell => market::TradeDir::Sell,
            TradeDir::Buy => market::TradeDir::Buy,
        }
    }
}

/// Market info
#[derive(Debug, Object)]
struct Market {
    base: String,
    quote: String,
}

impl From<super::Market> for Market {
    fn from(value: super::Market) -> Self {
        Market {
            base: value.base.to_string(),
            quote: value.quote.to_string(),
        }
    }
}

#[derive(Debug, Object)]
struct Asset {
    asset_id: String,
    name: String,
    ticker: String,
    precision: u8,
}

impl From<sideswap_api::Asset> for Asset {
    fn from(value: sideswap_api::Asset) -> Self {
        Asset {
            asset_id: value.asset_id.to_string(),
            name: value.name,
            ticker: value.ticker.0,
            precision: value.precision.value(),
        }
    }
}

#[derive(Debug, Object)]
struct Metadata {
    server_connected: bool,
    assets: Vec<Asset>,
    markets: Vec<Market>,
}

impl From<super::Metadata> for Metadata {
    fn from(value: super::Metadata) -> Self {
        Metadata {
            server_connected: value.server_connected,
            assets: value.assets.into_iter().map(Into::into).collect(),
            markets: value.markets.into_iter().map(Into::into).collect(),
        }
    }
}

#[derive(Debug, Object)]
struct Balances {
    wallet: BTreeMap<String, f64>,
    server: BTreeMap<String, f64>,
}

impl From<super::Balances> for Balances {
    fn from(value: super::Balances) -> Self {
        Balances {
            wallet: value
                .wallet
                .into_iter()
                .map(|(ticker, value)| (ticker.to_string(), value))
                .collect(),
            server: value
                .server
                .into_iter()
                .map(|(ticker, value)| (ticker.to_string(), value))
                .collect(),
        }
    }
}

#[derive(Debug, Object)]
struct PublicOrder {
    order_id: u64,
    trade_dir: TradeDir,
    amount: f64,
    price: f64,
}

impl From<super::PublicOrder_> for PublicOrder {
    fn from(value: super::PublicOrder_) -> Self {
        PublicOrder {
            order_id: value.order_id.value(),
            trade_dir: value.trade_dir.into(),
            amount: value.amount,
            price: value.price.value(),
        }
    }
}

#[derive(Debug, Object)]
struct OwnOrder {
    order_id: u64,
    base: String,
    quote: String,
    trade_dir: TradeDir,
    orig_amount: f64,
    active_amount: f64,
    price: f64,
}

impl From<super::OwnOrder_> for OwnOrder {
    fn from(value: super::OwnOrder_) -> Self {
        OwnOrder {
            order_id: value.order_id.value(),
            base: value.exchange_pair.base.to_string(),
            quote: value.exchange_pair.quote.to_string(),
            trade_dir: value.trade_dir.into(),
            orig_amount: value.orig_amount,
            active_amount: value.active_amount,
            price: value.price.value(),
        }
    }
}

#[derive(Debug, Object)]
struct OrderBook {
    orders: Vec<PublicOrder>,
    timestamp: u64,
}

impl From<super::OrderBook> for OrderBook {
    fn from(value: super::OrderBook) -> Self {
        OrderBook {
            orders: value.orders.into_iter().map(Into::into).collect(),
            timestamp: value.timestamp.as_millis(),
        }
    }
}

#[derive(Debug, Object)]
struct OwnOrders {
    orders: Vec<OwnOrder>,
}

impl From<super::OwnOrders> for OwnOrders {
    fn from(value: super::OwnOrders) -> Self {
        OwnOrders {
            orders: value.orders.into_iter().map(Into::into).collect(),
        }
    }
}

async fn recv<T>(receiver: oneshot::Receiver<T>) -> Result<T, Error> {
    receiver.await.map_err(Into::into)
}

fn parse_dealer_ticker(value: &str) -> Result<DealerTicker, Error> {
    dealer_ticker_from_asset_ticker(value).ok_or_else(|| Error::UnknownTicker(value.to_owned()))
}

fn parse_normal_float(value: f64) -> Result<NormalFloat, Error> {
    NormalFloat::new(value).map_err(Error::InvalidFloat)
}

#[OpenApi]
impl Api {
    fn send_request(&self, command: Command) -> Result<(), Error> {
        let sender = self.command_sender.upgrade().ok_or(Error::ChannelClosed)?;
        sender.send(command)?;
        Ok(())
    }

    #[oai(path = "/metadata", method = "get")]
    async fn metadata(&self) -> poem::Result<Json<Metadata>> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.send_request(Command::Metadata {
            res_sender: res_sender.into(),
        })?;
        let resp = recv(res_receiver).await?;
        Ok(Json(resp.into()))
    }

    #[oai(path = "/order_book", method = "get")]
    async fn order_book(
        &self,
        base: Query<String>,
        quote: Query<String>,
    ) -> poem::Result<Json<OrderBook>> {
        let base = parse_dealer_ticker(&base.0)?;
        let quote = parse_dealer_ticker(&quote.0)?;
        let exchange_pair = ExchangePair { base, quote };
        let (res_sender, res_receiver) = oneshot::channel();
        self.send_request(Command::OrderBook {
            exchange_pair,
            res_sender: res_sender.into(),
        })?;
        let resp = recv(res_receiver).await?;
        Ok(Json(resp.into()))
    }

    #[oai(path = "/own_orders", method = "get")]
    async fn own_orders(&self) -> poem::Result<Json<OwnOrders>> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.send_request(Command::OwnOrders {
            res_sender: res_sender.into(),
        })?;
        let resp = recv(res_receiver).await?;
        Ok(Json(resp.into()))
    }

    #[oai(path = "/submit_order", method = "post")]
    async fn submit_order(
        &self,
        base: Query<String>,
        quote: Query<String>,
        base_amount: Query<f64>,
        price: Query<f64>,
        trade_dir: Query<TradeDir>,
    ) -> poem::Result<Json<OwnOrder>> {
        let base = parse_dealer_ticker(&base.0)?;
        let quote = parse_dealer_ticker(&quote.0)?;
        let exchange_pair = ExchangePair { base, quote };
        let price = parse_normal_float(price.0)?;

        let (res_sender, res_receiver) = oneshot::channel();
        self.send_request(Command::SubmitOrder {
            exchange_pair,
            base_amount: base_amount.0,
            price,
            trade_dir: trade_dir.0.into(),
            res_sender: res_sender.into(),
        })?;
        let resp = recv(res_receiver).await?;
        Ok(Json(resp.into()))
    }

    #[oai(path = "/cancel_order", method = "post")]
    async fn cancel_order(&self, order_id: Query<u64>) -> poem::Result<()> {
        let order_id = OrdId::new(order_id.0);
        let (res_sender, res_receiver) = oneshot::channel();
        self.send_request(Command::CancelOrder {
            order_id,
            res_sender: res_sender.into(),
        })?;
        recv(res_receiver).await?;
        Ok(())
    }

    #[oai(path = "/balances", method = "get")]
    async fn balances(&self) -> poem::Result<Json<Balances>> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.send_request(Command::Balances {
            res_sender: res_sender.into(),
        })?;
        let resp = recv(res_receiver).await?;
        Ok(Json(resp.into()))
    }
}

async fn run(config: Config, command_sender: WeakUnboundedSender<Command>) {
    let api = Api { command_sender };

    let mut api = OpenApiService::new(api, "SideSwap Dealer API", "1.0");
    if let Some(url) = config.server_url.as_ref() {
        api = api.server(url)
    }

    let spec = api.spec_endpoint();

    let ui = api.swagger_ui();

    let route = Route::new()
        .nest("/", ui)
        .nest("/api", api)
        .nest("/spec", spec);

    Server::new(TcpListener::bind(config.listen_on))
        .run(route)
        .await
        .expect("must not fail");
}

pub fn start(config: Config, command_sender: &UnboundedSender<Command>) {
    tokio::task::spawn(run(config, command_sender.downgrade()));
}
