use elements::{Address, AssetId};

#[derive(Debug, Clone)]
pub struct Recipient {
    pub address: Address,
    pub asset_id: AssetId,
    pub amount: u64,
}
