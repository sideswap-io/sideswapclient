use sideswap_api::{AssetId, Txid};

#[derive(Debug, PartialEq, Eq)]
pub struct Balance {
    pub asset: AssetId,
    pub value: i64,
}

#[derive(Debug, PartialEq, Eq)]
pub struct Transaction {
    pub txid: Txid,
    pub network_fee: u32,
    pub size: u32,
    pub vsize: u32,
    pub memo: String,
    pub balances: Vec<Balance>,
    pub created_at: i64,
    pub pending_confs: Option<u8>,
}
