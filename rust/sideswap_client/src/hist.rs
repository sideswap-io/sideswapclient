use super::*;
use sideswap_api::*;
use serde::Serialize;
use std::vec::Vec;

#[derive(Serialize, Clone)]
pub struct Peg {
    pub pegin: bool,
    pub own_addr: String,
    pub peg_addr: String,
    pub amount: i64,
    pub status: String,
}

#[derive(Serialize, Clone)]
pub struct Swap {
    pub status: SwapStatus,
    pub buy_amount: i64,
    pub buy_asset: String,
    pub sell_amount: i64,
    pub sell_asset: String,
    pub txid: Option<String>,
}

#[derive(Serialize, Clone)]
pub enum Data {
    Peg(Peg),
    Swap(Swap),
}

#[derive(Serialize, Clone)]
pub struct Item {
    pub created_at: i64,
    pub data: Data,
}

#[derive(Serialize, Clone)]
pub struct State {
    orders: Vec<Item>,
}

fn new_item_peg(order: &models::Order, amount: i64, status: &str) -> Item {
    Item {
        created_at: order.created_at,
        data: Data::Peg(Peg {
            pegin: order.pegin,
            own_addr: order.own_addr.clone(),
            peg_addr: order.peg_addr.clone(),
            amount,
            status: status.into(),
        }),
    }
}

fn new_item_swap(status: &SwapStatusResponse) -> Item {
    Item {
        created_at: status.created_at,
        data: Data::Swap(Swap {
            status: status.status,
            buy_amount: status.swap.buy_amount,
            buy_asset: status.swap.buy_asset.clone(),
            sell_amount: status.swap.sell_amount,
            sell_asset: status.swap.sell_asset.clone(),
            txid: status.txid.clone(),
        }),
    }
}

pub fn update_ui(hist: &worker::DBData, ui_sender: &ui::Sender) {
    let mut orders = Vec::<Item>::new();
    for (_, order) in hist.peg_orders.iter() {
        let latest_status = hist.peg_status_map.get(&order.id);
        match latest_status {
            Some(latest_status) => {
                if !latest_status.list.is_empty() {
                    for item in latest_status.list.iter() {
                        orders.push(new_item_peg(&order, item.amount, &item.status));
                    }
                } else {
                    orders.push(new_item_peg(&order, 0, "Pending"));
                }
            }
            None => {
                orders.push(new_item_peg(&order, 0, "Loading..."));
            }
        }
    }

    for (_, swap) in hist.swaps.iter() {
        orders.push(new_item_swap(&swap));
    }

    orders.sort_by(|a, b| a.created_at.cmp(&b.created_at));

    let state = State { orders };
    ui_sender.send(ui::Update::History(state)).unwrap();
}
