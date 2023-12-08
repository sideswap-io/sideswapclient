use std::{
    collections::BTreeMap,
    net::SocketAddr,
    sync::{Arc, Mutex},
};

use axum::{extract::State, routing::get, Json};
use sideswap_client::ffi::proto::{
    from::{OrderCreated, OrderRemoved},
    Order,
};

#[derive(Clone, Debug, serde::Deserialize)]
pub struct Settings {
    listen_on: SocketAddr,
}

pub struct Server {
    context: Arc<Context>,
}

struct Context {
    orders: Mutex<BTreeMap<String, Order>>,
}

impl Server {
    pub fn new(settings: Settings) -> Self {
        let context = Arc::new(Context {
            orders: Default::default(),
        });
        let context_copy = Arc::clone(&context);
        std::thread::spawn(move || {
            let rt = tokio::runtime::Runtime::new().unwrap();
            rt.block_on(run(settings, context_copy));
        });

        Self { context }
    }

    pub fn order_created(&self, msg: OrderCreated) {
        if msg.order.own {
            self.context
                .orders
                .lock()
                .unwrap()
                .insert(msg.order.order_id.clone(), msg.order);
        }
    }

    pub fn order_removed(&self, msg: OrderRemoved) {
        self.context.orders.lock().unwrap().remove(&msg.order_id);
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
}

async fn list_orders(State(context): State<Arc<Context>>) -> Json<Vec<OrderInfo>> {
    context
        .orders
        .lock()
        .unwrap()
        .values()
        .map(|order| OrderInfo {
            order_id: order.order_id.clone(),
            asset_id: order.asset_id.clone(),
            bitcoin_amount: order.bitcoin_amount,
            asset_amount: order.asset_amount,
            price: order.price,
            private: order.private,
        })
        .collect::<Vec<_>>()
        .into()
}

async fn run(settings: Settings, context: Arc<Context>) {
    let app = axum::Router::new()
        .route("/orders", get(list_orders))
        .with_state(Arc::clone(&context));

    let listener = tokio::net::TcpListener::bind(settings.listen_on)
        .await
        .expect("starting api server socket must not fail");
    axum::serve(listener, app).await.unwrap();
}
