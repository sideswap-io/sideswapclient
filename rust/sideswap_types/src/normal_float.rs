use serde::{Deserialize, Deserializer, Serialize};

#[derive(Debug, Copy, Clone, PartialEq, Serialize)]
pub struct NormalFloat(f64);

impl<'de> Deserialize<'de> for NormalFloat {
    fn deserialize<D: Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let value = f64::deserialize(deserializer)?;
        NormalFloat::new(value).map_err(|err| serde::de::Error::custom(err.to_string()))
    }
}

impl std::fmt::Display for NormalFloat {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        self.0.fmt(f)
    }
}

#[derive(Debug)]
pub struct NotNormalError(f64);

impl std::fmt::Display for NotNormalError {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(f, "invalid float value: {}", self.0)
    }
}

impl std::error::Error for NotNormalError {}

impl NormalFloat {
    pub fn value(self) -> f64 {
        self.0
    }

    pub fn new(value: f64) -> Result<NormalFloat, NotNormalError> {
        match value.classify() {
            std::num::FpCategory::Normal | std::num::FpCategory::Zero => Ok(NormalFloat(value)),

            std::num::FpCategory::Nan
            | std::num::FpCategory::Infinite
            | std::num::FpCategory::Subnormal => Err(NotNormalError(value)),
        }
    }
}

impl Eq for NormalFloat {}

impl Ord for NormalFloat {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.0.partial_cmp(&other.0).expect("must not fail")
    }
}

impl PartialOrd for NormalFloat {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}
