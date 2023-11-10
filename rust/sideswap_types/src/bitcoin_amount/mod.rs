use elements::bitcoin::{self, amount::serde::SerdeAmount};

/// Bitcoin amount serialized as a floating point number
#[derive(Debug, Clone, Copy)]
pub struct SignedBtcAmount(i64);

/// Bitcoin amount serialized as a floating point number
#[derive(Debug, Clone, Copy)]
pub struct BtcAmount(u64);

impl serde::Serialize for SignedBtcAmount {
    fn serialize<S: serde::Serializer>(&self, s: S) -> Result<S::Ok, S::Error> {
        bitcoin::amount::SignedAmount::from_sat(self.0).ser_btc(s)
    }
}

impl<'de> serde::Deserialize<'de> for SignedBtcAmount {
    fn deserialize<D: serde::Deserializer<'de>>(d: D) -> Result<Self, D::Error> {
        bitcoin::amount::SignedAmount::des_btc(d).map(|amount| SignedBtcAmount(amount.to_sat()))
    }
}

impl SignedBtcAmount {
    pub fn to_sat(&self) -> i64 {
        self.0
    }
}

impl serde::Serialize for BtcAmount {
    fn serialize<S: serde::Serializer>(&self, s: S) -> Result<S::Ok, S::Error> {
        bitcoin::amount::Amount::from_sat(self.0).ser_btc(s)
    }
}

impl<'de> serde::Deserialize<'de> for BtcAmount {
    fn deserialize<D: serde::Deserializer<'de>>(d: D) -> Result<Self, D::Error> {
        bitcoin::amount::Amount::des_btc(d).map(|amount| BtcAmount(amount.to_sat()))
    }
}

impl BtcAmount {
    pub fn to_sat(&self) -> u64 {
        self.0
    }
}
