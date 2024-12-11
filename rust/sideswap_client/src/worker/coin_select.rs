use std::collections::BTreeMap;

use anyhow::{anyhow, bail, ensure};
use elements::{AssetId, Txid};
use sideswap_common::{coin_select::no_change_or_naive, network_fee, send_tx::coin_select::InOut};

#[derive(Clone)]
pub enum UtxoType {
    SingleSig,
    MultiSig,
}

#[derive(Clone)]
pub struct Utxo {
    pub txid: Txid,
    pub vout: u32,
    pub asset_id: AssetId,
    pub value: u64,
    pub type_: UtxoType,
}

pub struct Args {
    pub policy_asset: AssetId,
    pub utxos: Vec<Utxo>,
    pub user_outputs: Vec<InOut>,
    pub deduct_fee: Option<usize>,
}

pub struct Res {
    pub inputs: Vec<Utxo>,
    pub user_outputs: Vec<InOut>,
    pub change_outputs: Vec<InOut>,
    pub network_fee: u64,
}

pub struct AssetSelectArgs {
    pub policy_asset: AssetId,
    pub utxos: Vec<Utxo>,
    pub user_outputs: Vec<InOut>,
}

pub struct AssetSelectRes {
    pub asset_inputs: Vec<Utxo>,
    pub user_outputs: Vec<InOut>,
    pub change_outputs: Vec<InOut>,
    pub user_output_amounts: BTreeMap<AssetId, u64>,
}

pub fn select_inputs_for_non_policy_assets(
    AssetSelectArgs {
        policy_asset,
        mut utxos,
        user_outputs,
    }: AssetSelectArgs,
) -> Result<AssetSelectRes, anyhow::Error> {
    let mut user_output_amounts = BTreeMap::<AssetId, u64>::new();

    for user_output in user_outputs.iter() {
        *user_output_amounts.entry(user_output.asset_id).or_default() += user_output.value;
    }

    let mut asset_inputs = Vec::<Utxo>::new();
    let mut change_outputs = Vec::<InOut>::new();

    for (asset_id, target) in user_output_amounts.iter() {
        if *asset_id != policy_asset {
            let all_asset_coins = utxos
                .iter()
                .filter(|utxo| utxo.asset_id == *asset_id)
                .map(|utxo| utxo.value)
                .collect::<Vec<_>>();
            let available = all_asset_coins.iter().sum::<u64>();

            ensure!(
                available >= *target,
                "not enough UTXOs for asset {asset_id}, required: {target}, available: {available}"
            );

            let selected = no_change_or_naive(*target, &all_asset_coins)
                .expect("must not fail because available balance is not less than target");

            let mut total = 0;
            for value in selected {
                let index = utxos
                    .iter()
                    .position(|utxo| utxo.value == value && utxo.asset_id == *asset_id)
                    .expect("can't find required element");
                let utxo = utxos.remove(index);

                asset_inputs.push(utxo);
                total += value;
            }

            assert!(total >= *target);
            let change_amount = total - target;
            if change_amount > 0 {
                change_outputs.push(InOut {
                    asset_id: *asset_id,
                    value: change_amount,
                });
            }
        }
    }

    Ok(AssetSelectRes {
        asset_inputs,
        user_outputs,
        change_outputs,
        user_output_amounts,
    })
}

pub fn coin_select_amount(
    Args {
        policy_asset,
        utxos,
        user_outputs,
        deduct_fee,
    }: Args,
) -> Result<Res, anyhow::Error> {
    for utxo in utxos.iter() {
        ensure!(utxo.value > 0);
    }
    for output in user_outputs.iter() {
        ensure!(output.value > 0);
        ensure!(output.value < elements::bitcoin::amount::Amount::MAX_MONEY.to_sat());
    }

    if let Some(index) = deduct_fee {
        let output = user_outputs
            .get(index)
            .ok_or_else(|| anyhow!("can't deduct network fee from output {index}"))?;
        ensure!(output.asset_id == policy_asset);
    }

    let AssetSelectRes {
        asset_inputs,
        mut user_outputs,
        mut change_outputs,
        user_output_amounts,
    } = select_inputs_for_non_policy_assets(AssetSelectArgs {
        policy_asset,
        utxos: utxos.clone(),
        user_outputs,
    })?;

    let bitcoin_user_output = user_output_amounts
        .get(&policy_asset)
        .copied()
        .unwrap_or_default();

    let bitcoin_utxos = utxos
        .iter()
        .filter(|utxo| utxo.asset_id == policy_asset)
        .collect::<Vec<_>>();

    let mut all_inputs = asset_inputs;
    let mut single_sig_inputs = 0;
    let mut multi_sig_inputs = 0;
    let mut selected_bitcoin_amount = 0;

    for utxo in all_inputs.iter() {
        match utxo.type_ {
            UtxoType::SingleSig => single_sig_inputs += 1,
            UtxoType::MultiSig => multi_sig_inputs += 1,
        }
    }

    // TODO: Try to select L-BTC UTXOs without change

    for utxo in bitcoin_utxos {
        match utxo.type_ {
            UtxoType::SingleSig => single_sig_inputs += 1,
            UtxoType::MultiSig => multi_sig_inputs += 1,
        }

        selected_bitcoin_amount += utxo.value;
        all_inputs.push(utxo.clone());

        for with_change in [false, true] {
            let network_fee = network_fee::expected_network_fee(
                single_sig_inputs,
                multi_sig_inputs,
                user_outputs.len() + change_outputs.len() + usize::from(with_change),
            );

            let target = if deduct_fee.is_some() {
                bitcoin_user_output
            } else {
                network_fee + bitcoin_user_output
            };

            if selected_bitcoin_amount == target && !with_change
                || selected_bitcoin_amount > target && with_change
            {
                if let Some(index) = deduct_fee {
                    let output_orig_value = user_outputs[index].value;
                    ensure!(
                        output_orig_value > network_fee,
                        "can't deduct fee from output {index}, network fee: {network_fee}, user output: {output_orig_value}"
                    );
                    user_outputs[index].value = output_orig_value - network_fee;
                }

                let bitcoin_change = selected_bitcoin_amount - target;
                if bitcoin_change > 0 {
                    change_outputs.push(InOut {
                        asset_id: policy_asset,
                        value: bitcoin_change,
                    });
                }

                return Ok(Res {
                    inputs: all_inputs,
                    user_outputs,
                    change_outputs,
                    network_fee,
                });
            }
        }
    }

    bail!("not enough L-BTC UTXOs");
}
