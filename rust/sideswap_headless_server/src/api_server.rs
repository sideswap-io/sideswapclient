use std::{net::SocketAddr, sync::Arc};

use axum::{
    extract::{Path, State},
    http::StatusCode,
    response::IntoResponse,
    routing::{get, post},
    Json,
};
use sideswap_api::AssetId;
use tokio::sync::oneshot;

pub enum Req {
    NewOrder(NewOrder, oneshot::Sender<Result<OrderInfo, Error>>),
    OrderStatus(
        sideswap_api::OrderId,
        oneshot::Sender<Result<OrderStatus, Error>>,
    ),
    OrderCancel(
        sideswap_api::OrderId,
        oneshot::Sender<Result<CancelResponse, Error>>,
    ),
    ListOrders((), oneshot::Sender<Vec<OrderInfo>>),
    Send(SendRequest, oneshot::Sender<Result<SendResponse, Error>>),
}

pub type Callback = Box<dyn Fn(Req) + Send + Sync>;

#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("channel closed unexpectedly")]
    ChannelClosed(#[from] oneshot::error::RecvError),
    #[error("server error: {0}")]
    Server(String),
    #[error("no inputs found")]
    NotInputs,
    #[error("duplicated order requested")]
    DuplicatedOrder,
    #[error("too many active requests")]
    TooManyRequest,
    #[error("unknown order")]
    UnknownOrder,
}

#[derive(serde::Serialize, Clone)]
struct ErrorResponse {
    error_msg: String,
}

impl IntoResponse for Error {
    fn into_response(self) -> axum::response::Response {
        let error_resp: Json<ErrorResponse> = ErrorResponse {
            error_msg: self.to_string(),
        }
        .into();
        (StatusCode::BAD_REQUEST, error_resp).into_response()
    }
}

#[derive(Clone, Debug, serde::Deserialize)]
pub struct Settings {
    listen_on: SocketAddr,
    api_key: Option<String>,
}

#[derive(serde::Serialize, Clone, Copy)]
pub enum Status {
    Active,
    Expired,
    Succeed,
}

struct Context {
    settings: Settings,
    callback: Callback,
}

#[derive(serde::Deserialize)]
pub struct NewOrder {
    pub asset_id: AssetId,
    pub asset_amount: f64,
    pub price: f64,
    pub private: Option<bool>,
    pub ttl_seconds: Option<u64>,
    pub unique_key: Option<String>,
}

#[derive(serde::Serialize, Clone)]
pub struct OrderStatus {
    pub status: Status,
    pub txid: Option<sideswap_api::Txid>,
}

#[derive(serde::Deserialize)]
pub struct SendReceiver {
    pub address: elements::Address,
    pub asset_id: AssetId,
    pub amount: i64,
}

#[derive(serde::Deserialize)]
pub struct SendRequest {
    pub receivers: Vec<SendReceiver>,
}

#[derive(serde::Serialize)]
pub struct SendResponse {
    pub txid: elements::Txid,
}

pub struct Server {
    context: Arc<Context>,
}

impl Server {
    pub fn new(settings: Settings, callback: Callback) -> Self {
        let context = Arc::new(Context { settings, callback });
        Self { context }
    }
}

#[derive(serde::Serialize, Clone)]
pub struct OrderInfo {
    pub order_id: sideswap_api::OrderId,
    pub asset_id: sideswap_api::AssetId,
    pub bitcoin_amount: i64,
    pub asset_amount: i64,
    pub price: f64,
    pub private: bool,
}

#[derive(serde::Serialize, Clone)]
pub struct CancelResponse {}

async fn auth(
    State(context): State<Arc<Context>>,
    req: axum::http::Request<axum::body::Body>,
    next: axum::middleware::Next,
) -> Result<axum::response::Response, axum::http::StatusCode> {
    if let Some(api_key) = &context.settings.api_key {
        let auth_header = req
            .headers()
            .get(axum::http::header::AUTHORIZATION)
            .and_then(|header| header.to_str().ok())
            .ok_or(axum::http::StatusCode::UNAUTHORIZED)?;
        if auth_header != api_key {
            return Err(axum::http::StatusCode::UNAUTHORIZED);
        }
    }

    Ok(next.run(req).await)
}

async fn list_orders(State(context): State<Arc<Context>>) -> Result<Json<Vec<OrderInfo>>, Error> {
    let (sender, receiver) = oneshot::channel();
    (context.callback)(Req::ListOrders((), sender));
    let resp = receiver.await?;
    Ok(resp.into())
}

async fn new_order(
    State(context): State<Arc<Context>>,
    Json(req): Json<NewOrder>,
) -> Result<Json<OrderInfo>, Error> {
    let (sender, receiver) = oneshot::channel();
    (context.callback)(Req::NewOrder(req, sender));
    let resp = receiver.await??;
    Ok(resp.into())
}

async fn order_status(
    State(context): State<Arc<Context>>,
    order_id: Path<sideswap_api::OrderId>,
) -> Result<Json<OrderStatus>, Error> {
    let (sender, receiver) = oneshot::channel();
    (context.callback)(Req::OrderStatus(order_id.0, sender));
    let resp = receiver.await??;
    Ok(resp.into())
}

async fn order_cancel(
    State(context): State<Arc<Context>>,
    order_id: Path<sideswap_api::OrderId>,
) -> Result<Json<CancelResponse>, Error> {
    let (sender, receiver) = oneshot::channel();
    (context.callback)(Req::OrderCancel(order_id.0, sender));
    let resp = receiver.await??;
    Ok(resp.into())
}

async fn send(
    State(context): State<Arc<Context>>,
    Json(req): Json<SendRequest>,
) -> Result<Json<SendResponse>, Error> {
    let (sender, receiver) = oneshot::channel();
    (context.callback)(Req::Send(req, sender));
    let resp = receiver.await??;
    Ok(resp.into())
}

pub async fn run(server: Server) {
    let app = axum::Router::new()
        .route("/orders/new", post(new_order))
        .route("/orders/status/:order_id", get(order_status))
        .route("/orders/:order_id/status", get(order_status))
        .route("/orders/:order_id/cancel", post(order_cancel))
        .route("/orders", get(list_orders))
        .route("/send", post(send))
        .with_state(Arc::clone(&server.context))
        .layer(axum::middleware::from_fn_with_state(
            Arc::clone(&server.context),
            auth,
        ));

    let listener = tokio::net::TcpListener::bind(server.context.settings.listen_on)
        .await
        .expect("starting api server socket must not fail");
    axum::serve(listener, app).await.unwrap();
}
