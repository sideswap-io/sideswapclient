use std::collections::BTreeMap;

use sideswap_api::AssetId;

#[derive(Copy, Clone, PartialEq, Eq)]
pub enum TxType {
    Received,
    Sent,
    Swap,
    Internal,
    Unknown,
}

pub fn get_tx_conf_count(top_block_height: u32, tx_block_height: u32) -> u32 {
    if top_block_height != 0 && tx_block_height != 0 {
        std::cmp::min(2, top_block_height.saturating_sub(tx_block_height) + 1)
    } else {
        0
    }
}

pub fn get_tx_type(
    amounts: &BTreeMap<AssetId, i64>,
    policy_asset: &AssetId,
    network_fee: u64,
) -> TxType {
    let any_positive = amounts.values().any(|value| *value > 0);
    let any_negative = amounts.values().any(|value| *value < 0);

    if amounts.len() == 2 && any_positive && any_negative {
        TxType::Swap
    } else if amounts.len() == 1
        && amounts
            .iter()
            .all(|(asset, value)| asset == policy_asset && *value == -(network_fee as i64))
    {
        TxType::Internal
    } else if any_positive && !any_negative {
        TxType::Received
    } else if any_negative && !any_positive {
        TxType::Sent
    } else {
        TxType::Unknown
    }
}
