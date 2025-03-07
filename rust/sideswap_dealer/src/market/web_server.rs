use std::net::SocketAddr;

use poem::{listener::TcpListener, Route, Server};
use poem_openapi::{
    param::Query,
    payload::{Json, PlainText},
    ApiResponse, OpenApi, OpenApiService,
};
use serde::Deserialize;
use sideswap_api::mkt::OrdId;
use sideswap_common::{dealer_ticker::DealerTicker, exchange_pair::ExchangePair};
use sideswap_types::{normal_float::NormalFloat, timestamp_ms::TimestampMs};

#[derive(Debug, Clone, Deserialize)]
pub struct Config {
    listen_on: SocketAddr,
    server_url: Option<String>,
}

use super::{api, controller::Controller, Error};

struct Api {
    controller: Controller,
}

#[derive(Debug, ApiResponse)]
enum ErrorResponse {
    /// Request failed
    #[oai(status = 400)]
    BadRequest(Json<api::Error>),
}

impl From<Error> for ErrorResponse {
    fn from(err: Error) -> Self {
        ErrorResponse::BadRequest(Json(err.into()))
    }
}

fn parse_dealer_ticker(api: &Api, value: &str) -> Result<DealerTicker, Error> {
    api.controller.parse_ticker(value)
}

fn parse_normal_float(value: f64) -> Result<NormalFloat, Error> {
    NormalFloat::new(value).map_err(Error::InvalidFloat)
}

#[OpenApi]
impl Api {
    /// Get a new receiving address
    #[oai(path = "/new_address", method = "get")]
    async fn new_address(&self) -> Result<PlainText<String>, ErrorResponse> {
        let resp = self.controller.new_address().await?.to_string();
        Ok(PlainText(resp))
    }

    /// Metadata API call, list all available markets
    #[oai(path = "/metadata", method = "get")]
    async fn metadata(&self) -> Result<Json<api::Metadata>, ErrorResponse> {
        let resp = self.controller.metadata().await?;
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
    ) -> Result<Json<api::OrderBook>, ErrorResponse> {
        let base = parse_dealer_ticker(&self, &base.0)?;
        let quote = parse_dealer_ticker(&self, &quote.0)?;
        let exchange_pair = ExchangePair { base, quote };
        let resp = self.controller.order_book(exchange_pair).await?;
        Ok(Json(resp.into()))
    }

    /// List of all active orders.
    /// Returns an error if the upstream server connection is down.
    #[oai(path = "/own_orders", method = "get")]
    async fn own_orders(&self) -> Result<Json<api::OwnOrders>, ErrorResponse> {
        let resp = self.controller.own_orders().await?;
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
        trade_dir: Query<api::TradeDir>,
        /// Client order id. If set, must be unique among all active and recent history orders.
        client_order_id: Query<Option<Box<String>>>,
    ) -> Result<Json<api::OwnOrder>, ErrorResponse> {
        let base = parse_dealer_ticker(&self, &base.0)?;
        let quote = parse_dealer_ticker(&self, &quote.0)?;
        let exchange_pair = ExchangePair { base, quote };
        let price = parse_normal_float(price.0)?;
        let resp = self
            .controller
            .submit_order(
                exchange_pair,
                base_amount.0,
                price,
                trade_dir.0.into(),
                client_order_id.0,
            )
            .await?;
        Ok(Json(resp.into()))
    }

    /// Edit own order
    #[oai(path = "/edit_order", method = "post")]
    async fn edit_order(
        &self,
        /// Order ID
        order_id: Query<u64>,
        /// Base asset amount as a float (must be positive)
        base_amount: Query<Option<f64>>,
        /// Order price (must be positive).
        /// Quote amount = Base amount * Price.
        price: Query<Option<f64>>,
    ) -> Result<Json<api::OwnOrder>, ErrorResponse> {
        let resp = self
            .controller
            .edit_order(
                OrdId::new(order_id.0),
                base_amount.0,
                price.0.map(parse_normal_float).transpose()?,
            )
            .await?;
        Ok(Json(resp.into()))
    }

    /// Cancel own order.
    /// Submitting an unknown/cancelled order ID will result in an error.
    #[oai(path = "/cancel_order", method = "post")]
    async fn cancel_order(
        &self,
        /// Order ID
        order_id: Query<u64>,
    ) -> Result<(), ErrorResponse> {
        self.controller.cancel_order(OrdId::new(order_id.0)).await?;
        Ok(())
    }

    /// Load wallet balances
    #[oai(path = "/balances", method = "get")]
    async fn balances(&self) -> Result<Json<api::BalancesNotif>, ErrorResponse> {
        let resp = self.controller.balances().await?;
        Ok(Json(resp.into()))
    }

    /// Load order history.
    /// History is returned in reverse order (newest to oldest).
    #[oai(path = "/load_history", method = "get")]
    async fn load_history(
        &self,
        /// If set, only includes orders with id >= start_time.
        start_time: Query<Option<u64>>,
        /// If set, only includes orders with id < end_time.
        end_time: Query<Option<u64>>,
        /// If set, skips the specified number of orders from the beginning.
        skip: Query<Option<usize>>,
        /// If set, limits the number of returned orders in the response.
        count: Query<Option<usize>>,
    ) -> Result<Json<api::HistoryOrders>, ErrorResponse> {
        let resp = self
            .controller
            .get_history_orders(
                start_time.0.map(TimestampMs::from_millis),
                end_time.0.map(TimestampMs::from_millis),
                skip.0,
                count.0,
            )
            .await?;
        Ok(Json(resp.into()))
    }
}

async fn run(config: Config, controller: Controller) {
    let api = Api { controller };

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

pub fn start(config: Config, controller: Controller) {
    tokio::task::spawn(run(config, controller));
}
