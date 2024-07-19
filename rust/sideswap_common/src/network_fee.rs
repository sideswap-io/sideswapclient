pub const FEE_RATE: f64 = 0.1;

pub const WEIGHT_FIXED: usize = 44;
pub const WEIGHT_VIN_SINGLE_SIG: usize = 367;
pub const WEIGHT_VIN_MULTI_SIG: usize = 526;
pub const WEIGHT_VOUT: usize = 4810;
pub const WEIGHT_FEE: usize = 178;

pub fn weight_to_network_fee(weight: usize) -> u64 {
    let vsize = (weight + 3) / 4;
    (vsize as f64 * FEE_RATE).ceil() as u64
}

/// `vout_count` must not count the network fee output
pub fn expected_network_fee(
    single_sig_inputs: usize,
    multi_sig_inputs: usize,
    blinded_outputs: usize,
) -> u64 {
    let weight = WEIGHT_FIXED
        + WEIGHT_VIN_SINGLE_SIG * single_sig_inputs
        + WEIGHT_VIN_MULTI_SIG * multi_sig_inputs
        + WEIGHT_VOUT * blinded_outputs
        + WEIGHT_FEE;
    weight_to_network_fee(weight)
}

pub fn expected_network_fee_single_wallet(
    input_count: usize,
    multisig_wallet: bool,
    blinded_outputs: usize,
) -> u64 {
    let (single_sig_inputs, multi_sig_inputs) = if multisig_wallet {
        (0, input_count)
    } else {
        (input_count, 0)
    };
    expected_network_fee(single_sig_inputs, multi_sig_inputs, blinded_outputs)
}
