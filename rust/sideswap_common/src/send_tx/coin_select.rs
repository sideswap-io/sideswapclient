use elements::AssetId;

pub mod asset_outputs;
pub mod normal_tx;
pub mod payjoin;

#[derive(Debug, Copy, Clone, PartialEq, Eq)]
pub struct InOut {
    pub asset_id: AssetId,
    pub value: u64,
}

#[derive(thiserror::Error, Debug)]
pub enum CoinSelectError {
    #[error("Not enough UTXOs for asset {asset_id}, required: {required}, available: {available}")]
    NotEnough {
        asset_id: AssetId,
        required: u64,
        available: u64,
    },
    #[error("Invalid amount {0:?}")]
    InvalidAmount(InOut),
    #[error("Invalid params: {0}")]
    InvalidParams(&'static str),
    #[error("Can't select inputs with required amount")]
    SelectionFailed,
    #[error("Insufficient L-BTC to pay network fee")]
    NotEnoughLbtc,
}
