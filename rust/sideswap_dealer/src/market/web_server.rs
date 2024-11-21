use std::{collections::BTreeMap, net::SocketAddr};

use poem::{listener::TcpListener, Route, Server};
use poem_openapi::{
    param::Query, payload::Json, ApiResponse, Enum, Object, OpenApi, OpenApiService,
};
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
    #[error("Channel closed, please report bug")]
    ChannelClosed,
    #[error("Unknown ticker: {0}")]
    UnknownTicker(String),
    #[error("Invalid float: {0}")]
    InvalidFloat(NotNormalError),
    #[error("{0}")]
    SuperError(#[from] super::Error),
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

#[derive(Debug, Serialize, Object)]
struct ErrorMessage {
    /// Error message text
    error: String,
}

#[derive(Debug, ApiResponse)]
enum ErrorResponseServer {
    /// Server error
    #[oai(status = 500)]
    InternalServerError(Json<ErrorMessage>),
}

impl From<Error> for ErrorResponseServer {
    fn from(err: Error) -> Self {
        let error_msg = Json(ErrorMessage {
            error: err.to_string(),
        });
        match err {
            Error::InvalidFloat(_) | Error::UnknownTicker(_) => {
                unreachable!()
            }
            Error::ChannelClosed | Error::SuperError(_) => {
                ErrorResponseServer::InternalServerError(error_msg)
            }
        }
    }
}

#[derive(Debug, ApiResponse)]
enum ErrorResponseFull {
    /// Client error
    #[oai(status = 400)]
    BadRequest(Json<ErrorMessage>),
    /// Server error
    #[oai(status = 500)]
    InternalServerError(Json<ErrorMessage>),
}

impl From<Error> for ErrorResponseFull {
    fn from(err: Error) -> Self {
        let error_msg = Json(ErrorMessage {
            error: err.to_string(),
        });
        match err {
            Error::InvalidFloat(_) | Error::UnknownTicker(_) => {
                ErrorResponseFull::BadRequest(error_msg)
            }
            Error::ChannelClosed | Error::SuperError(_) => {
                ErrorResponseFull::InternalServerError(error_msg)
            }
        }
    }
}

/// Trade direction of the base asset
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

/// Available market
#[derive(Debug, Object)]
struct Market {
    /// Base asset ticker (for example L-BTC or USDt).
    base: String,
    /// Quote asset ticker (for example USDt or MEX).
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
    /// Asset ID
    asset_id: String,
    /// Asset name (from the GDK registry)
    name: String,
    /// Asset ticker (from the GDK registry)
    ticker: String,
    /// Asset precision (in the [0..8] range)
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

/// Get market metadata
#[derive(Debug, Object)]
struct Metadata {
    /// Whether the upstream connection to the server is active or not.
    /// Without it most API requests will fail.
    server_connected: bool,
    /// Hard-coded list of some known assets (L-BTC, USDt, MEX etc) with their details.
    assets: Vec<Asset>,
    /// List of the stablecoin and AMP markets (but only where both base and quote assets are known).
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

/// Wallet balances
#[derive(Debug, Object)]
struct Balances {
    /// Wallet balances as seen by the wallet (including unconfirmed transactions).
    wallet: BTreeMap<String, f64>,
    /// Wallet balances as seen by the server (including unconfirmed transactions).
    /// Because it takes time for transactions to propagate through the network, the local wallet and the server may not agree on what is actually available.
    /// The server balances can't be more than the wallet balances.
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

/// Public order
#[derive(Debug, Object)]
struct PublicOrder {
    /// Order ID (based on timestamp, globally unique for all orders)
    order_id: u64,
    /// Trade direction
    trade_dir: TradeDir,
    /// Base asset active order amount (same as `active_amount` in OwnOrder)
    amount: f64,
    /// Price
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
    /// Order ID (based on timestamp, globally unique for all orders)
    order_id: u64,
    /// Base asset ticker
    base: String,
    /// Quote asset ticker
    quote: String,
    /// Trade direction
    trade_dir: TradeDir,
    /// Base asset amount specified when the order was created.
    /// If the order is partially matched, the matched amount is deducted from the `orig_amount` and the order remains active.
    /// If the order is fully matched, it is removed.
    /// Can be larger than the available wallet balance.
    orig_amount: f64,
    /// Active order amount.
    /// All submitted orders are sorted by price and then UTXOs amounts are checked, starting from the top orders.
    /// For sell orders the base asset UTXOs are checked and for buy orders the quote asset.
    /// If zero, the order will not be listed in the public book.
    active_amount: f64,
    /// Order price (must be positive)
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
    /// List of the public orders
    orders: Vec<PublicOrder>,
    /// Timestamp in milliseconds since UNIX epoch (set by the server)
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
    /// List of all active own orders, from all markets
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

async fn recv_res<T>(receiver: oneshot::Receiver<Result<T, super::Error>>) -> Result<T, Error> {
    let resp = receiver.await??;
    Ok(resp)
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

    /// Metadata API call, list all available markets
    #[oai(path = "/metadata", method = "get")]
    async fn metadata(&self) -> Result<Json<Metadata>, ErrorResponseServer> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.send_request(Command::Metadata {
            res_sender: res_sender.into(),
        })?;
        let resp = recv(res_receiver).await?;
        Ok(Json(resp.into()))
    }

    /// Load a snapshot of the public order book
    #[oai(path = "/order_book", method = "get")]
    async fn order_book(
        &self,
        /// Base asset ticker, must be from a known market
        base: Query<String>,
        /// Quote asset ticker, must be from a known market
        quote: Query<String>,
    ) -> Result<Json<OrderBook>, ErrorResponseFull> {
        let base = parse_dealer_ticker(&base.0)?;
        let quote = parse_dealer_ticker(&quote.0)?;
        let exchange_pair = ExchangePair { base, quote };
        let (res_sender, res_receiver) = oneshot::channel();
        self.send_request(Command::OrderBook {
            exchange_pair,
            res_sender: res_sender.into(),
        })?;
        let resp = recv_res(res_receiver).await?;
        Ok(Json(resp.into()))
    }

    /// List of all active orders.
    /// Returns an error if the upstream server connection is down.
    #[oai(path = "/own_orders", method = "get")]
    async fn own_orders(&self) -> Result<Json<OwnOrders>, ErrorResponseServer> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.send_request(Command::OwnOrders {
            res_sender: res_sender.into(),
        })?;
        let resp = recv_res(res_receiver).await?;
        Ok(Json(resp.into()))
    }

    /// Submit a new order and return a new own order if the request succeeds.
    /// Request will fail if the upstream server connection is down.
    /// Wallet balance is not required to cover the full amount and will not be checked, actual order amount will be lowered if necessary.
    /// After receiving or spending wallet UTXOs, the active order amount could be automatically adjusted by the server.
    #[oai(path = "/submit_order", method = "post")]
    async fn submit_order(
        &self,
        /// Base asset ticker, must be from a known market
        base: Query<String>,
        /// Quote asset ticker, must be from a known market
        quote: Query<String>,
        /// Base asset amount as a float (must be positive)
        base_amount: Query<f64>,
        /// Order price (must be positive).
        /// Quote amount = Base amount * Price.
        price: Query<f64>,
        /// Order trade direction
        trade_dir: Query<TradeDir>,
    ) -> Result<Json<OwnOrder>, ErrorResponseFull> {
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
        let resp = recv_res(res_receiver).await?;
        Ok(Json(resp.into()))
    }

    /// Cancel own order.
    /// Submitting an unknown/cancelled order ID will result in an error.
    #[oai(path = "/cancel_order", method = "post")]
    async fn cancel_order(
        &self,
        /// Order ID
        order_id: Query<u64>,
    ) -> Result<(), ErrorResponseFull> {
        let order_id = OrdId::new(order_id.0);
        let (res_sender, res_receiver) = oneshot::channel();
        self.send_request(Command::CancelOrder {
            order_id,
            res_sender: res_sender.into(),
        })?;
        recv_res(res_receiver).await?;
        Ok(())
    }

    /// Load wallet and server balances.
    /// If the upstream server connection is down, the reported server balances will be zero.
    #[oai(path = "/balances", method = "get")]
    async fn balances(&self) -> Result<Json<Balances>, ErrorResponseServer> {
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
