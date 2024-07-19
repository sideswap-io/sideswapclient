use std::collections::BTreeMap;

use sideswap_api::AssetId;

use crate::{coin_select::no_change_or_naive, verify};

use super::{CoinSelectError, InOut};

pub struct Args {
    pub fee_asset: AssetId,
    pub use_all_utxos: bool,
    pub wallet_utxos: Vec<InOut>,
    pub user_outputs: Vec<InOut>,
}

pub struct Res {
    pub asset_inputs: Vec<InOut>,
    pub user_outputs: Vec<InOut>,
    pub change_outputs: Vec<InOut>,
    pub user_output_amounts: BTreeMap<AssetId, u64>,
}

pub fn select(
    Args {
        fee_asset,
        use_all_utxos,
        wallet_utxos,
        user_outputs,
    }: Args,
) -> Result<Res, CoinSelectError> {
    let mut user_output_amounts = BTreeMap::<AssetId, u64>::new();

    for input in wallet_utxos.iter() {
        verify!(input.value > 0, CoinSelectError::InvalidAmount(*input));
        if use_all_utxos {
            // This will consume all asset UTXOs even if there is no user output for this asset_id
            user_output_amounts.entry(input.asset_id).or_default();
        }
    }

    for user_output in user_outputs.iter() {
        verify!(
            user_output.value > 0,
            CoinSelectError::InvalidAmount(*user_output)
        );
        *user_output_amounts.entry(user_output.asset_id).or_default() += user_output.value;
    }

    let mut user_inputs = Vec::<InOut>::new();
    let mut change_outputs = Vec::<InOut>::new();

    for (&asset_id, &target) in user_output_amounts.iter() {
        if asset_id != fee_asset {
            let all_asset_coins = wallet_utxos
                .iter()
                .filter(|utxo| utxo.asset_id == asset_id)
                .map(|utxo| utxo.value)
                .collect::<Vec<_>>();
            let available = all_asset_coins.iter().sum::<u64>();

            verify!(
                available >= target,
                CoinSelectError::NotEnough {
                    asset_id: asset_id,
                    required: target,
                    available: available,
                }
            );

            let selected = if use_all_utxos {
                all_asset_coins
            } else {
                no_change_or_naive(target, &all_asset_coins)
                    .expect("must not fail because available balance is not less than target")
            };

            let mut total = 0;
            for value in selected {
                user_inputs.push(InOut { asset_id, value });
                total += value;
            }

            assert!(total >= target);
            let change_amount = total - target;
            if change_amount > 0 {
                change_outputs.push(InOut {
                    asset_id,
                    value: change_amount,
                });
            }
        }
    }

    Ok(Res {
        asset_inputs: user_inputs,
        user_outputs,
        change_outputs,
        user_output_amounts,
    })
}
