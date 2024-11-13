use elements::bitcoin::{self};

/// Bitcoin amount deserialized from a floating point number.
/// Used with Bitcoin Core/Elements RPC.
#[derive(Debug, Clone, Copy)]
pub struct BtcAmount(u64);

impl<'de> serde::Deserialize<'de> for BtcAmount {
    fn deserialize<D: serde::Deserializer<'de>>(d: D) -> Result<Self, D::Error> {
        bitcoin::amount::serde::as_btc::deserialize(d)
            .map(|amount: bitcoin::amount::Amount| BtcAmount(amount.to_sat()))
    }
}

impl BtcAmount {
    pub fn to_sat(&self) -> u64 {
        self.0
    }

    pub fn to_btc(&self) -> f64 {
        bitcoin::amount::Amount::from_sat(self.0).to_btc()
    }
}

impl std::fmt::Display for BtcAmount {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        bitcoin::amount::Amount::from_sat(self.0).fmt(f)
    }
}

#[cfg(test)]
mod tests;
