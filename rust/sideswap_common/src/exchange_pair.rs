use serde::{Deserialize, Serialize};
use sideswap_api::mkt::AssetType;

use crate::dealer_ticker::DealerTicker;

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Serialize, Deserialize)]
pub struct ExchangePair {
    pub base: DealerTicker,
    pub quote: DealerTicker,
}

impl std::fmt::Display for ExchangePair {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}/{}", self.base, self.quote)
    }
}

impl ExchangePair {
    pub fn asset(&self, asset_type: AssetType) -> DealerTicker {
        match asset_type {
            AssetType::Base => self.base,
            AssetType::Quote => self.quote,
        }
    }
}
