use super::schema::*;
use serde::Serialize;

#[derive(Queryable, Debug, Serialize)]
pub struct Order {
    pub id: i32,
    pub order_id: String,
    pub pegin: bool,
    pub own_addr: String,
    pub peg_addr: String,
    pub created_at: i64,
}

#[derive(Insertable)]
#[table_name = "orders"]
pub struct NewOrder {
    pub order_id: String,
    pub pegin: bool,
    pub own_addr: String,
    pub peg_addr: String,
    pub created_at: i64,
}

#[derive(Queryable, Debug, Serialize)]
pub struct Swap {
    pub id: i32,
    pub order_id: String,
}

#[derive(Insertable)]
#[table_name = "swaps"]
pub struct NewSwap {
    pub order_id: String,
}

#[derive(Queryable, Debug, Serialize, Clone)]
pub struct Wallet {
    pub id: i64,
    pub wallet_type: String,
    pub host: String,
    pub port: String,
    pub user_name: String,
    pub user_pass: String,
    pub is_active: bool,
}

#[derive(Insertable, Hash)]
#[table_name = "wallets"]
pub struct NewWallet {
    pub id: Option<i64>,
    pub wallet_type: String,
    pub host: String,
    pub port: String,
    pub user_name: String,
    pub user_pass: String,
    pub is_active: bool,
}

#[derive(Queryable, Debug, Serialize)]
pub struct Setting {
    pub key: String,
    pub value: String,
}

#[derive(Insertable)]
#[table_name = "settings"]
pub struct NewSetting {
    pub key: String,
    pub value: String,
}
