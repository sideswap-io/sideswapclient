use std::{net::SocketAddr, sync::Arc};

use axum::{
    extract::{Path, State},
    routing::{get, post},
    Json,
};
use sideswap_client::ffi::proto::{
    self,
    from::{OrderComplete, OrderCreated},
};

use crate::{error::Error, worker::WorkerReq, Context, NewOrder, OrderStatus, Status};

#[derive(Clone, Debug, serde::Deserialize)]
pub struct Settings {
    listen_on: SocketAddr,
}

pub struct Server {
    context: Arc<Context>,
}

impl Server {
    pub fn new(context: Arc<Context>) -> Self {
        Self { context }
    }

    pub fn order_created(&self, msg: OrderCreated) {
        if msg.order.own {
            self.context.statuses.lock().unwrap().insert(
                msg.order.order_id.clone(),
                OrderStatus {
                    status: Status::Active,
                    txid: None,
                },
            );
            self.context
                .orders
                .lock()
                .unwrap()
                .insert(msg.order.order_id.clone(), msg.order);
        }
    }

    pub fn order_complete(&self, msg: OrderComplete) {
        if let Some(order) = self.context.statuses.lock().unwrap().get_mut(&msg.order_id) {
            order.status = if msg.txid.is_some() {
                Status::Succeed
            } else {
                Status::Expired
            };
            order.txid = msg.txid;
        }
        self.context.orders.lock().unwrap().remove(&msg.order_id);
    }
}

fn convert_order(order: &proto::Order) -> OrderInfo {
    OrderInfo {
        order_id: order.order_id.clone(),
        asset_id: order.asset_id.clone(),
        bitcoin_amount: order.bitcoin_amount,
        asset_amount: order.asset_amount,
        price: order.price,
        private: order.private,
        created_at: order.created_at,
        expires_at: order.expires_at,
    }
}

#[derive(serde::Serialize)]
struct OrderInfo {
    order_id: String,
    asset_id: String,
    bitcoin_amount: i64,
    asset_amount: i64,
    price: f64,
    private: bool,
    created_at: i64,
    expires_at: Option<i64>,
}

async fn list_orders(State(context): State<Arc<Context>>) -> Json<Vec<OrderInfo>> {
    context
        .orders
        .lock()
        .unwrap()
        .values()
        .map(convert_order)
        .collect::<Vec<_>>()
        .into()
}

async fn new_order(
    State(context): State<Arc<Context>>,
    Json(req): Json<NewOrder>,
) -> Result<Json<OrderInfo>, Error> {
    let (res_sender, res_receiver) = tokio::sync::oneshot::channel();
    context
        .req_sender
        .send(WorkerReq::NewOrder(req, res_sender))
        .unwrap();
    let order = res_receiver.await.unwrap()?;
    Ok(convert_order(&order).into())
}

async fn order_status(
    State(context): State<Arc<Context>>,
    order_id: Path<String>,
) -> Result<Json<OrderStatus>, Error> {
    let status = context
        .statuses
        .lock()
        .unwrap()
        .get(&order_id.0)
        .ok_or_else(|| Error::UnknownOrder)?
        .clone();
    Ok(status.into())
}

pub async fn run(settings: Settings, context: Arc<Context>) {
    let app = axum::Router::new()
        .route("/orders/new", post(new_order))
        .route("/orders/status/:order_id", get(order_status))
        .route("/orders", get(list_orders))
        .with_state(Arc::clone(&context));

    let listener = tokio::net::TcpListener::bind(settings.listen_on)
        .await
        .expect("starting api server socket must not fail");
    axum::serve(listener, app).await.unwrap();
}
