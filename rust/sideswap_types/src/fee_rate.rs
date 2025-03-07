use std::fmt::Display;

use serde::{Deserialize, Serialize};

const COIN: f64 = 100_000_000.0;

/// Fee rate in BTC/kB as returned by Bitcoin Core (bitcoins per 1000 virtualbytes)
#[derive(Debug, Copy, Clone, Serialize, Deserialize, PartialEq)]
pub struct FeeRateBitcoin(f64);

impl FeeRateBitcoin {
    pub fn to_sats(&self) -> FeeRateSats {
        FeeRateSats((self.0 * COIN).round() / 1000.0)
    }
}

/// Fee rate in sat/byte
#[derive(Debug, Copy, Clone, Serialize, Deserialize, PartialEq, PartialOrd)]
pub struct FeeRateSats(f64);

impl FeeRateSats {
    pub fn to_bitcoin(&self) -> FeeRateBitcoin {
        FeeRateBitcoin((self.0 * 1000.0).round() / COIN)
    }

    pub fn vsize_to_fee(&self, vsize: usize) -> u64 {
        (vsize as f64 * self.0).ceil() as u64
    }

    pub fn from_raw(value: f64) -> FeeRateSats {
        FeeRateSats(value)
    }

    pub fn raw(&self) -> f64 {
        self.0
    }

    pub fn from_fee(fee: u64, vsize: usize) -> FeeRateSats {
        assert!(vsize != 0);
        FeeRateSats(fee as f64 / vsize as f64)
    }
}

impl Eq for FeeRateSats {}

impl Ord for FeeRateSats {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.0.total_cmp(&other.0)
    }
}

impl Display for FeeRateSats {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{} s/b", self.0)
    }
}

#[cfg(test)]
mod tests;
