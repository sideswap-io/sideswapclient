use std::collections::BTreeMap;

use crate::{
    coin_select, network_fee, network_fee_discount,
    send_tx::coin_select::{asset_outputs, InOut},
};
use anyhow::{anyhow, ensure};
use elements::AssetId;

#[derive(Debug, Clone)]
pub struct Args {
    pub multisig_wallet: bool,
    pub policy_asset: AssetId,
    pub fee_asset: AssetId,
    pub price: f64,
    pub fixed_fee: u64,
    pub use_all_utxos: bool,

    pub wallet_utxos: Vec<InOut>,
    pub server_utxos: Vec<InOut>,

    pub user_outputs: Vec<InOut>,
    pub deduct_fee: Option<usize>,
}

#[derive(Debug)]
pub struct Res {
    pub user_inputs: Vec<InOut>,
    pub client_inputs: Vec<InOut>,
    pub server_inputs: Vec<InOut>,

    pub user_outputs: Vec<InOut>,
    pub change_outputs: Vec<InOut>,
    pub server_fee: InOut,
    pub server_change: Option<InOut>,
    pub fee_change: Option<InOut>,
    pub network_fee: InOut,

    pub cost: u64,
}

fn naive_coin_select(target: u64, target_count: usize, coins: &[u64]) -> Option<Vec<u64>> {
    let selected = coins.iter().copied().take(target_count).collect::<Vec<_>>();
    let sum = selected.iter().sum::<u64>();
    if sum < target {
        None
    } else {
        Some(selected)
    }
}

fn try_coin_select_impl(
    Args {
        multisig_wallet,
        policy_asset,
        fee_asset,
        price,
        fixed_fee,
        use_all_utxos,
        wallet_utxos,
        server_utxos,
        user_outputs,
        deduct_fee,
    }: Args,
) -> Result<Res, anyhow::Error> {
    ensure!(fee_asset != policy_asset);
    ensure!(price > 0.0);
    ensure!(fixed_fee > 0);
    ensure!(wallet_utxos.iter().all(|utxo| utxo.value > 0));

    ensure!(server_utxos
        .iter()
        .all(|utxo| utxo.asset_id == policy_asset && utxo.value > 0));

    if let Some(index) = deduct_fee {
        let output = user_outputs
            .get(index)
            .ok_or_else(|| anyhow!("no output with index {index}"))?;
        ensure!(output.asset_id == fee_asset);
    }

    let fee_utoxs = wallet_utxos
        .iter()
        .filter(|utxo| utxo.asset_id == fee_asset)
        .map(|utxo| utxo.value)
        .collect::<Vec<_>>();
    let mut server_utxos = server_utxos
        .iter()
        .map(|utxo| utxo.value)
        .collect::<Vec<_>>();
    server_utxos.sort();
    server_utxos.reverse();

    let asset_outputs::Res {
        asset_inputs,
        user_outputs,
        change_outputs,
        user_output_amounts,
    } = asset_outputs::select(asset_outputs::Args {
        fee_asset,
        use_all_utxos,
        wallet_utxos,
        user_outputs,
    })?;

    let mut best: Option<Res> = None;

    for with_fee_change in [false, true] {
        for with_server_change in [false, true] {
            for server_input_count in 1..=server_utxos.len() {
                for fee_input_count in 1..=fee_utoxs.len() {
                    if use_all_utxos && fee_input_count != fee_utoxs.len() {
                        continue;
                    }
                    let client_input_count = asset_inputs.len() + fee_input_count;

                    let output_count = user_outputs.len()
                        + change_outputs.len()
                        + usize::from(with_fee_change)
                        + usize::from(with_server_change)
                        + 1; // Server fee output

                    let (single_sig_inputs, multi_sig_inputs) = if multisig_wallet {
                        (0, client_input_count)
                    } else {
                        (client_input_count, 0)
                    };

                    let min_network_fee = network_fee_discount::TxFee {
                        vin_single_sig_native: server_input_count,
                        vin_single_sig_nested: single_sig_inputs,
                        vin_multi_sig: multi_sig_inputs,
                        vout_native: 0,
                        vout_nested: output_count,
                    }
                    .fee();

                    let server_inputs = if with_server_change {
                        naive_coin_select(min_network_fee + 1, server_input_count, &server_utxos)
                    } else {
                        let upper_bound_delta = network_fee::weight_to_network_fee(
                            network_fee_discount::WEIGHT_VOUT_NESTED,
                        );
                        coin_select::in_range(
                            min_network_fee,
                            upper_bound_delta,
                            server_input_count,
                            &server_utxos,
                        )
                    };

                    let server_inputs = match server_inputs {
                        Some(server_inputs) => server_inputs,
                        None => continue,
                    };

                    let server_input = server_inputs.iter().sum::<u64>();
                    let server_change = if with_server_change {
                        server_input - min_network_fee
                    } else {
                        0
                    };
                    let network_fee = server_input - server_change;
                    let min_asset_fee = (network_fee as f64 * price) as u64 + fixed_fee;

                    let user_asset_output = user_output_amounts
                        .get(&fee_asset)
                        .copied()
                        .unwrap_or_default();

                    let fee_asset_target = if deduct_fee.is_none() {
                        user_asset_output + min_asset_fee
                    } else {
                        user_asset_output
                    };

                    let fee_asset_inputs = if with_fee_change {
                        naive_coin_select(fee_asset_target + 1, fee_input_count, &fee_utoxs)
                    } else {
                        let upper_bound_delta = (network_fee::weight_to_network_fee(
                            network_fee_discount::WEIGHT_VOUT_NESTED,
                        ) as f64
                            * price) as u64;
                        coin_select::in_range(
                            fee_asset_target,
                            upper_bound_delta,
                            fee_input_count,
                            &fee_utoxs,
                        )
                    };

                    let fee_asset_inputs = match fee_asset_inputs {
                        Some(fee_asset_inputs) => fee_asset_inputs,
                        None => continue,
                    };

                    let fee_input = fee_asset_inputs.iter().sum::<u64>();
                    let fee_change = if with_fee_change {
                        fee_input - fee_asset_target
                    } else {
                        0
                    };
                    let server_fee = if deduct_fee.is_none() {
                        fee_input - fee_change - user_asset_output
                    } else {
                        min_asset_fee
                    };
                    let new_cost = server_fee;

                    if best
                        .as_ref()
                        .map(|best| best.cost > new_cost)
                        .unwrap_or(true)
                    {
                        let mut user_outputs = user_outputs.clone();
                        if let Some(index) = deduct_fee {
                            if user_outputs[index].value <= min_asset_fee {
                                // Can't deduct fee from the selected output
                                continue;
                            }
                            user_outputs[index].value -= min_asset_fee;
                        }

                        best = Some(Res {
                            user_inputs: asset_inputs.clone(),
                            client_inputs: fee_asset_inputs
                                .iter()
                                .map(|value| InOut {
                                    asset_id: fee_asset,
                                    value: *value,
                                })
                                .collect(),
                            server_inputs: server_inputs
                                .iter()
                                .map(|value| InOut {
                                    asset_id: policy_asset,
                                    value: *value,
                                })
                                .collect(),
                            user_outputs,
                            change_outputs: change_outputs.clone(),
                            server_fee: InOut {
                                asset_id: fee_asset,
                                value: server_fee,
                            },
                            server_change: with_server_change.then_some(InOut {
                                asset_id: policy_asset,
                                value: server_change,
                            }),
                            fee_change: with_fee_change.then_some(InOut {
                                asset_id: fee_asset,
                                value: fee_change,
                            }),
                            network_fee: InOut {
                                asset_id: policy_asset,
                                value: network_fee,
                            },
                            cost: new_cost,
                        })
                    };
                }
            }
        }
    }

    best.ok_or_else(|| anyhow!("payjoin UTXOs selection failed"))
}

fn validate_res(
    args: &Args,
    Res {
        user_inputs,
        client_inputs,
        server_inputs,
        user_outputs,
        change_outputs,
        server_fee,
        server_change,
        fee_change,
        network_fee,
        cost: _,
    }: &Res,
) -> Result<(), anyhow::Error> {
    let mut inputs = BTreeMap::<AssetId, u64>::new();
    let mut outputs = BTreeMap::<AssetId, u64>::new();

    for input in user_inputs
        .iter()
        .chain(client_inputs.iter())
        .chain(server_inputs.iter())
    {
        *inputs.entry(input.asset_id).or_default() += input.value;
    }

    for output in user_outputs
        .iter()
        .chain(change_outputs.iter())
        .chain(std::iter::once(server_fee))
        .chain(server_change.iter())
        .chain(fee_change.iter())
        .chain(std::iter::once(network_fee))
    {
        *outputs.entry(output.asset_id).or_default() += output.value;
    }

    let mut user_outputs_corrected = user_outputs.clone();
    if let Some(index) = args.deduct_fee {
        ensure!(user_outputs_corrected[index].asset_id == args.fee_asset);
        user_outputs_corrected[index].value += server_fee.value;
    }
    ensure!(args.user_outputs == user_outputs_corrected);

    ensure!(inputs == outputs, "check failed: {inputs:?} != {outputs:?}");

    let client_input_count = user_inputs.len() + client_inputs.len();
    let server_input_count = server_inputs.len();
    let output_count = user_outputs.len()
        + change_outputs.len()
        + 1
        + usize::from(server_change.is_some())
        + usize::from(fee_change.is_some());

    let (single_sig_inputs, multi_sig_inputs) = if args.multisig_wallet {
        (0, client_input_count)
    } else {
        (client_input_count, 0)
    };

    let min_network_fee = network_fee_discount::TxFee {
        vin_single_sig_native: server_input_count,
        vin_single_sig_nested: single_sig_inputs,
        vin_multi_sig: multi_sig_inputs,
        vout_native: 0,
        vout_nested: output_count,
    }
    .fee();

    let actual_network_fee = network_fee.value;
    ensure!(actual_network_fee >= min_network_fee);
    ensure!(actual_network_fee <= 2 * min_network_fee);

    let min_server_fee = (actual_network_fee as f64 * args.price) as u64 + args.fixed_fee;
    let actual_server_fee = server_fee.value;
    ensure!(actual_server_fee >= min_server_fee);
    ensure!(actual_server_fee <= 2 * min_server_fee);

    ensure!(
        !args.use_all_utxos || args.wallet_utxos.len() == user_inputs.len() + client_inputs.len()
    );

    Ok(())
}

pub fn try_coin_select(args: Args) -> Result<Res, anyhow::Error> {
    let res = try_coin_select_impl(args.clone());

    if let Ok(res) = &res {
        if let Err(err) = validate_res(&args, res) {
            panic!("bug in coin selection!!!\nerr: {err}\nargs: {args:#?}\nres: {res:#?}");
        }
    }
    res
}

#[cfg(test)]
mod tests;
