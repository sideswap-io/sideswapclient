pub const MIN_FEE_RATE: f64 = 0.1;

pub const WEIGHT_FIXED: usize = 222;

pub const WEIGHT_VIN_SINGLE_SIG_NATIVE: usize = 275;
pub const WEIGHT_VIN_SINGLE_SIG_NESTED: usize = 367;
pub const WEIGHT_VIN_MULTI_SIG: usize = 526;

pub const WEIGHT_VOUT_NATIVE: usize = 266;
pub const WEIGHT_VOUT_NESTED: usize = 270;

pub fn weight_to_vsize(weight: usize) -> usize {
    (weight + 3) / 4
}

pub fn vsize_to_fee(vsize: usize, fee_rate: f64) -> u64 {
    (vsize as f64 * fee_rate).ceil() as u64
}

pub fn weight_to_fee(weight: usize, fee_rate: f64) -> u64 {
    vsize_to_fee(weight_to_vsize(weight), fee_rate)
}

#[derive(Copy, Clone, Default)]
pub struct TxFee {
    pub vin_single_sig_native: usize,
    pub vin_single_sig_nested: usize,
    pub vin_multi_sig: usize,
    pub vout_native: usize,
    pub vout_nested: usize,
}

impl TxFee {
    pub fn sum(&self, other: &TxFee) -> TxFee {
        TxFee {
            vin_single_sig_native: self.vin_single_sig_native + other.vin_single_sig_native,
            vin_single_sig_nested: self.vin_single_sig_nested + other.vin_single_sig_nested,
            vin_multi_sig: self.vin_multi_sig + other.vin_multi_sig,
            vout_native: self.vout_native + other.vout_native,
            vout_nested: self.vout_nested + other.vout_nested,
        }
    }

    pub fn tx_weight(&self) -> usize {
        let TxFee {
            vin_single_sig_native,
            vin_single_sig_nested,
            vin_multi_sig,
            vout_native,
            vout_nested,
        } = self;
        WEIGHT_FIXED
            + WEIGHT_VIN_SINGLE_SIG_NATIVE * vin_single_sig_native
            + WEIGHT_VIN_SINGLE_SIG_NESTED * vin_single_sig_nested
            + WEIGHT_VIN_MULTI_SIG * vin_multi_sig
            + WEIGHT_VOUT_NATIVE * vout_native
            + WEIGHT_VOUT_NESTED * vout_nested
    }

    pub fn fee(&self) -> u64 {
        vsize_to_fee(weight_to_vsize(self.tx_weight()), MIN_FEE_RATE)
    }
}
