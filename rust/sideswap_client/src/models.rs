use sideswap_api::AssetId;

#[derive(Debug, PartialEq, Eq)]
pub struct Balance {
    pub asset: AssetId,
    pub value: i64,
}

#[derive(Debug, PartialEq, Eq)]
pub struct Transaction {
    pub txid: elements::Txid,
    pub network_fee: u32,
    pub size: u32,
    pub vsize: u32,
    pub memo: String,
    pub balances: Vec<Balance>,
    pub created_at: i64,
    pub block_height: u32,
    pub balances_all: Vec<Balance>,
    pub max_pointer_external: u32,
    pub max_pointer_internal: u32,
}
