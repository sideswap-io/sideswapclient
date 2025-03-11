use std::{collections::BTreeMap, str::FromStr};

use elements::AssetId;
use serde::Deserialize;

use crate::types::Amount;

use super::{RpcCall, RpcRequest};

pub struct GetBalancesCall {}

pub type BalanceMap = BTreeMap<String, serde_json::Number>;

#[derive(Deserialize)]
pub struct BalancesList {
    pub trusted: BalanceMap,
    pub untrusted_pending: BalanceMap,
}

#[derive(Deserialize)]
pub struct GetBalances {
    pub mine: BalancesList,
}

impl RpcCall for GetBalancesCall {
    type Response = GetBalances;

    fn get_request(self) -> RpcRequest {
        RpcRequest {
            method: "getbalances".to_owned(),
            params: serde_json::Value::Null,
        }
    }
}

pub type ParsedBalanceMap = BTreeMap<AssetId, u64>;

pub fn parse_balances(balances: &BalanceMap, policy_asset: &AssetId) -> ParsedBalanceMap {
    balances
        .iter()
        .map(|(name, balance)| {
            let asset_id = if name == "bitcoin" {
                *policy_asset
            } else {
                AssetId::from_str(&name).expect("must be valid")
            };
            let value: u64 = Amount::from_rpc(balance)
                .0
                .try_into()
                .expect("must be valid");
            (asset_id, value)
        })
        .collect()
}

pub fn total_balances(
    mut confirmed: ParsedBalanceMap,
    unconfirmed: ParsedBalanceMap,
) -> ParsedBalanceMap {
    for (asset_id, value) in unconfirmed {
        *confirmed.entry(asset_id).or_default() += value;
    }
    confirmed
}
