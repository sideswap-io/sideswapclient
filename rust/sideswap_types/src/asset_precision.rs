use serde::{Deserialize, Deserializer, Serialize};

#[derive(Debug, Copy, Clone, PartialEq, Eq, PartialOrd, Ord, Serialize)]
pub struct AssetPrecision(u8);

const MAX_PRECISION: u8 = 8;

impl<'de> Deserialize<'de> for AssetPrecision {
    fn deserialize<D: Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = u8::deserialize(deserializer)?;
        AssetPrecision::new(value).map_err(|err| serde::de::Error::custom(err.to_string()))
    }
}

impl std::fmt::Display for AssetPrecision {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        self.0.fmt(f)
    }
}

#[derive(Debug)]
pub struct OutOfRangeError(u8);

impl std::fmt::Display for OutOfRangeError {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(
            f,
            "asset precision value is out of range: {}, can't be more than {}",
            self.0, MAX_PRECISION,
        )
    }
}

impl std::error::Error for OutOfRangeError {}

impl AssetPrecision {
    pub const ZERO: AssetPrecision = AssetPrecision(0);
    pub const TWO: AssetPrecision = AssetPrecision(2);
    pub const FOUR: AssetPrecision = AssetPrecision(4);
    pub const BITCOIN_PRECISION: AssetPrecision = AssetPrecision(8);

    pub const fn value(&self) -> u8 {
        self.0
    }

    pub fn new(value: u8) -> Result<AssetPrecision, OutOfRangeError> {
        if value <= MAX_PRECISION {
            Ok(AssetPrecision(value))
        } else {
            Err(OutOfRangeError(value))
        }
    }
}
