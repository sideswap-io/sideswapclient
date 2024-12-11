use crate::gdk_json::{self, AddressInfo};

pub struct Amounts {
    pub send_asset: sideswap_api::AssetId,
    pub send_amount: u64,
    pub recv_asset: sideswap_api::AssetId,
    pub recv_amount: u64,
}

pub struct SigSingleInput {
    pub asset: elements::AssetId,
    pub value: u64,
}

pub struct SigSingleOutput {
    pub asset: elements::AssetId,
    pub value: u64,
    pub address_info: AddressInfo,
}

#[allow(dead_code)]
pub struct SigSingleMaker {
    pub proposal: sideswap_api::LiquidexProposal,
    pub funding_tx: Option<elements::Transaction>,
    pub unspent_output: gdk_json::UnspentOutput,
}
