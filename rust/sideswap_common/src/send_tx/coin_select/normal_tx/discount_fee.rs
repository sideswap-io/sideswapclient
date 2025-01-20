use crate::network_fee_discount;

use super::*;

pub fn expected_network_fee_single_wallet(
    input_count: usize,
    multisig_wallet: bool,
    blinded_outputs: usize,
) -> u64 {
    let (vin_single_sig_nested, vin_multi_sig) = if multisig_wallet {
        (0, input_count)
    } else {
        (input_count, 0)
    };
    let tx_fee = network_fee_discount::TxFee {
        vin_single_sig_native: 0,
        vin_single_sig_nested,
        vin_multi_sig,
        vout_native: 0,
        vout_nested: blinded_outputs,
    };
    tx_fee.fee()
}

pub fn try_coin_select_impl(
    Args {
        multisig_wallet,
        policy_asset,
        use_all_utxos,
        wallet_utxos,
        user_outputs,
        deduct_fee,
    }: Args,
) -> Result<Res, CoinSelectError> {
    for utxo in wallet_utxos.iter() {
        verify!(
            utxo.value > 0 && utxo.value < elements::bitcoin::amount::Amount::MAX_MONEY.to_sat(),
            CoinSelectError::InvalidAmount(*utxo)
        );
    }
    for output in user_outputs.iter() {
        verify!(
            output.value > 0
                && output.value < elements::bitcoin::amount::Amount::MAX_MONEY.to_sat(),
            CoinSelectError::InvalidAmount(*output)
        );
    }

    if let Some(index) = deduct_fee {
        let output = user_outputs
            .get(index)
            .ok_or(CoinSelectError::InvalidParams("invalid deduct_fee index"))?;
        verify!(
            output.asset_id == policy_asset,
            CoinSelectError::InvalidParams("can't deduct fee from non-bitcoin output")
        );
    }

    let bitcoin_utxos = wallet_utxos
        .iter()
        .filter(|utxo| utxo.asset_id == policy_asset)
        .map(|utxo| utxo.value)
        .collect::<Vec<_>>();

    verify!(!bitcoin_utxos.is_empty(), CoinSelectError::NotEnoughLbtc);
    let bitcoin_utxos_total = bitcoin_utxos.iter().sum::<u64>();

    let asset_outputs::Res {
        asset_inputs,
        user_outputs,
        change_outputs,
        user_output_amounts,
    } = asset_outputs::select(asset_outputs::Args {
        fee_asset: policy_asset,
        use_all_utxos,
        wallet_utxos,
        user_outputs,
    })?;

    let bitcoin_user_output = user_output_amounts
        .get(&policy_asset)
        .copied()
        .unwrap_or_default();

    let mut best: Option<Res> = None;

    'outer: for with_fee_change in [true, false] {
        if use_all_utxos
            && !with_fee_change
            && bitcoin_user_output != bitcoin_utxos_total
            && deduct_fee.is_some()
        {
            // Nothing can be done in this case
            continue;
        }

        let bitcoin_inputs = if use_all_utxos || bitcoin_user_output == bitcoin_utxos_total {
            bitcoin_utxos.clone()
        } else if with_fee_change {
            let mut input_count = 1;

            loop {
                let network_fee = expected_network_fee_single_wallet(
                    asset_inputs.len() + input_count,
                    multisig_wallet,
                    user_outputs.len() + change_outputs.len() + 1,
                );

                let target = if deduct_fee.is_some() {
                    bitcoin_user_output
                } else {
                    network_fee + bitcoin_user_output
                };

                let selected = bitcoin_utxos.iter().take(input_count).copied().sum::<u64>();

                if selected > target {
                    break;
                }

                input_count += 1;
                if input_count > bitcoin_utxos.len() {
                    continue 'outer;
                }
            }

            bitcoin_utxos.iter().copied().take(input_count).collect()
        } else if deduct_fee.is_some() {
            // The branch here without change and with deducted fee output.
            // We need to find exact amount in this case.
            let selected = coin_select::no_change(bitcoin_user_output, &bitcoin_utxos);
            match selected {
                Some(selected) => selected,
                None => continue,
            }
        } else {
            let base_network_fee = expected_network_fee_single_wallet(
                asset_inputs.len(),
                multisig_wallet,
                user_outputs.len() + change_outputs.len(),
            );

            let fee_rate_per_input = if multisig_wallet {
                network_fee_discount::vsize_to_fee(
                    network_fee_discount::weight_to_vsize(
                        network_fee_discount::WEIGHT_VIN_MULTI_SIG,
                    ),
                    network_fee_discount::MIN_FEE_RATE,
                )
            } else {
                network_fee_discount::vsize_to_fee(
                    network_fee_discount::weight_to_vsize(
                        network_fee_discount::WEIGHT_VIN_SINGLE_SIG_NESTED,
                    ),
                    network_fee_discount::MIN_FEE_RATE,
                )
            };

            let bitcoin_utxos_effective = bitcoin_utxos
                .iter()
                .filter_map(|value| value.checked_sub(fee_rate_per_input))
                .collect::<Vec<_>>();

            let target = bitcoin_user_output + base_network_fee;

            let upper_bound_delta = network_fee_discount::vsize_to_fee(
                network_fee_discount::weight_to_vsize(network_fee_discount::WEIGHT_VOUT_NESTED),
                network_fee_discount::MIN_FEE_RATE,
            );

            let selected_res =
                coin_select::in_range(target, upper_bound_delta, 0, &bitcoin_utxos_effective);

            let selected = match selected_res {
                Some(selected) => selected,
                None => continue,
            };

            selected
                .iter()
                .map(|value| *value + fee_rate_per_input)
                .collect()
        };

        let bitcoin_input_total = bitcoin_inputs.iter().sum::<u64>();

        let network_fee = if with_fee_change || deduct_fee.is_some() {
            expected_network_fee_single_wallet(
                asset_inputs.len() + bitcoin_inputs.len(),
                multisig_wallet,
                user_outputs.len() + change_outputs.len() + usize::from(with_fee_change),
            )
        } else {
            if bitcoin_input_total <= bitcoin_user_output {
                continue;
            }
            bitcoin_input_total - bitcoin_user_output
        };

        let bitcoin_user_output = if deduct_fee.is_some() {
            if network_fee >= bitcoin_user_output {
                continue;
            }
            bitcoin_user_output - network_fee
        } else {
            bitcoin_user_output
        };

        if bitcoin_input_total < bitcoin_user_output + network_fee {
            continue;
        }
        let fee_change = bitcoin_input_total - bitcoin_user_output - network_fee;

        if best
            .as_ref()
            .map(|best| best.network_fee.value > network_fee)
            .unwrap_or(true)
        {
            let mut user_outputs = user_outputs.clone();
            if let Some(index) = deduct_fee {
                if user_outputs[index].value <= network_fee {
                    // Can't deduct fee from the selected output
                    continue;
                }
                user_outputs[index].value -= network_fee;
            }

            best = Some(Res {
                asset_inputs: asset_inputs.clone(),
                bitcoin_inputs: bitcoin_inputs
                    .iter()
                    .map(|value| InOut {
                        asset_id: policy_asset,
                        value: *value,
                    })
                    .collect(),
                user_outputs,
                change_outputs: change_outputs.clone(),
                fee_change: (with_fee_change && fee_change > 0).then_some(InOut {
                    asset_id: policy_asset,
                    value: fee_change,
                }),
                network_fee: InOut {
                    asset_id: policy_asset,
                    value: network_fee,
                },
            })
        };
    }

    best.ok_or(CoinSelectError::SelectionFailed)
}

pub fn validate_res(
    args: &Args,
    Res {
        asset_inputs,
        bitcoin_inputs,
        user_outputs,
        change_outputs,
        fee_change,
        network_fee,
    }: &Res,
) -> Result<(), anyhow::Error> {
    let mut inputs = BTreeMap::<AssetId, u64>::new();
    let mut outputs = BTreeMap::<AssetId, u64>::new();

    for input in asset_inputs.iter().chain(bitcoin_inputs.iter()) {
        ensure!(input.value > 0);
        *inputs.entry(input.asset_id).or_default() += input.value;
    }

    for output in user_outputs
        .iter()
        .chain(change_outputs.iter())
        .chain(fee_change.iter())
        .chain(std::iter::once(network_fee))
    {
        ensure!(output.value > 0);
        *outputs.entry(output.asset_id).or_default() += output.value;
    }

    let mut user_outputs_corrected = user_outputs.clone();
    if let Some(index) = args.deduct_fee {
        ensure!(user_outputs_corrected[index].asset_id == args.policy_asset);
        user_outputs_corrected[index].value += network_fee.value;
    }
    ensure!(args.user_outputs == user_outputs_corrected);

    ensure!(inputs == outputs, "check failed: {inputs:?} != {outputs:?}");

    let min_network_fee = expected_network_fee_single_wallet(
        asset_inputs.len() + bitcoin_inputs.len(),
        args.multisig_wallet,
        user_outputs.len() + change_outputs.len() + usize::from(fee_change.is_some()),
    );
    let max_network_fee = expected_network_fee_single_wallet(
        args.wallet_utxos.len(),
        args.multisig_wallet,
        user_outputs.len() + change_outputs.len() + 1,
    );
    let network_fee = network_fee.value;
    ensure!(
        network_fee >= min_network_fee && network_fee <= max_network_fee,
        "invalid network fee: {}, min: {}, max: {}",
        network_fee,
        min_network_fee,
        max_network_fee,
    );

    ensure!(
        !args.use_all_utxos || args.wallet_utxos.len() == asset_inputs.len() + bitcoin_inputs.len()
    );

    Ok(())
}
