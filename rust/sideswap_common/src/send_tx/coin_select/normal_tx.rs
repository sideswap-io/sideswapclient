use std::collections::BTreeMap;

use anyhow::ensure;
use elements::AssetId;

use crate::{coin_select, verify};

use super::{asset_outputs, CoinSelectError, InOut};

mod discount_fee;
mod no_discount_fee;

#[derive(Debug, Clone)]
pub struct Args {
    pub multisig_wallet: bool,
    pub policy_asset: AssetId,
    pub use_all_utxos: bool,
    pub wallet_utxos: Vec<InOut>,
    pub user_outputs: Vec<InOut>,
    pub deduct_fee: Option<usize>,
}

#[derive(Debug)]
pub struct Res {
    pub asset_inputs: Vec<InOut>,
    pub bitcoin_inputs: Vec<InOut>,
    pub user_outputs: Vec<InOut>,
    pub change_outputs: Vec<InOut>,
    pub fee_change: Option<InOut>,
    pub network_fee: InOut,
}

pub fn try_coin_select(args: Args) -> Result<Res, CoinSelectError> {
    let fee_discount = true;

    let res = if fee_discount {
        discount_fee::try_coin_select_impl(args.clone())
    } else {
        no_discount_fee::try_coin_select_impl(args.clone())
    };

    if let Ok(res) = &res {
        let validate_res = if fee_discount {
            discount_fee::validate_res(&args, res)
        } else {
            no_discount_fee::validate_res(&args, res)
        };

        validate_res.unwrap_or_else(|err| {
            panic!("bug in coin selection!!!\nerr: {err}\nargs: {args:#?}\nres: {res:#?}")
        });
    }

    res
}

#[cfg(test)]
mod tests;
