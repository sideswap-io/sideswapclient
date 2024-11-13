use sideswap_types::utxo_ext::UtxoExt;

/// Try to select coins so that their sum is in the range [target..targe + upper_bound_delta].
/// Set `upper_bound_delta` to 0 if you want to find coins without change.
/// All the values must be "sane" so their sum does not overflow.
///
/// Copied from bitcoin-coin-selection (with minor modifications):
/// https://github.com/p2pderivatives/rust-bitcoin-coin-selection/blob/74ec70193754a74473e8b07cce02d83d1d2d3f34/src/branch_and_bound.rs#L145
pub fn in_range(
    target: u64,
    upper_bound_delta: u64,
    target_count: usize,
    coins: &[u64],
) -> Option<Vec<u64>> {
    let mut coins = coins.to_vec();

    // Total_Tries in Core:
    // https://github.com/bitcoin/bitcoin/blob/1d9da8da309d1dbf9aef15eb8dc43b4a2dc3d309/src/wallet/coinselection.cpp#L74
    const ITERATION_LIMIT: i32 = 100_000;

    let mut iteration = 0;
    let mut index = 0;
    let mut backtrack;

    let mut value = 0;

    let mut current_waste = 0;
    let mut best_waste = u64::MAX;

    let mut index_selection: Vec<usize> = vec![];
    let mut best_selection: Option<Vec<usize>> = None;

    let upper_bound = target + upper_bound_delta;

    coins.sort();
    coins.reverse();

    let mut available_value = coins.iter().sum::<u64>();

    if available_value < target {
        return None;
    }

    while iteration < ITERATION_LIMIT {
        backtrack = false;

        // * If any of the conditions are met, backtrack.
        if available_value + value < target
            // Provides an upper bound on the excess value that is permissible.
            // Since value is lost when we create a change output due to increasing the size of the
            // transaction by an output (the change output), we accept solutions that may be
            // larger than the target.  The excess is added to the solutions waste score.
            // However, values greater than value + upper_bound_delta are not considered.
            //
            // This creates a range of possible solutions where;
            // range = (target, target + upper_bound_delta]
            //
            // That is, the range includes solutions that exactly equal the target up to but not
            // including values greater than target + upper_bound_delta.
            || value > upper_bound
            // if current_waste > best_waste.
            || current_waste > best_waste
        {
            backtrack = true;
        }
        // * value meets or exceeds the target.
        //   Record the solution and the waste then continue.
        else if value >= target {
            backtrack = true;

            let waste = value - target;
            current_waste += waste;

            // Check if index_selection is better than the previous known best, and
            // update best_selection accordingly.
            if current_waste <= best_waste
                && (target_count == 0 || index_selection.len() == target_count)
            {
                best_selection = Some(index_selection.clone());
                best_waste = current_waste;
            }

            current_waste -= waste;
        }

        if target_count != 0 && index_selection.len() >= target_count {
            backtrack = true;
        }

        // * Backtrack
        if backtrack {
            if index_selection.is_empty() {
                break;
            }

            loop {
                index -= 1;

                if index <= *index_selection.last().unwrap() {
                    break;
                }

                let utxo_value = coins[index];
                available_value += utxo_value;
            }

            assert_eq!(index, *index_selection.last().unwrap());
            let utxo_value = coins[index];
            value -= utxo_value;
            index_selection.pop().unwrap();
        }
        // * Add next node to the inclusion branch.
        else {
            let utxo_value = coins[index];

            index_selection.push(index);

            value += utxo_value;

            available_value -= utxo_value;
        }

        // no overflow is possible since the iteration count is bounded.
        index += 1;
        iteration += 1;
    }

    best_selection.map(|best_selection| best_selection.iter().map(|index| coins[*index]).collect())
}

pub fn naive(target: u64, coins: &[u64]) -> Option<Vec<u64>> {
    let mut selected = Vec::new();
    let mut total = 0;

    for coin in coins {
        selected.push(*coin);
        total += coin;
        if total >= target {
            break;
        }
    }

    if total < target {
        None
    } else {
        Some(selected)
    }
}

pub fn no_change(target: u64, coins: &[u64]) -> Option<Vec<u64>> {
    in_range(target, 0, 0, coins)
}

pub fn no_change_or_naive(target: u64, coins: &[u64]) -> Option<Vec<u64>> {
    no_change(target, coins).or_else(|| naive(target, coins))
}

pub fn take_utxos<T: UtxoExt>(mut utxos: Vec<T>, coins: &[u64]) -> Option<Vec<T>> {
    let mut selected = Vec::new();
    for coin in coins {
        let index = utxos.iter().position(|utxo| utxo.value() == *coin)?;
        let utxo = utxos.remove(index);
        selected.push(utxo);
    }
    Some(selected)
}
