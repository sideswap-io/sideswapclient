use elements::AssetId;
use serde::{Deserialize, Serialize};
use sideswap_api::mkt::AssetType;
use sideswap_common::network::Network;
use sideswap_types::asset_precision::AssetPrecision;

#[derive(Debug, Clone, Copy, Hash, PartialEq, Eq, PartialOrd, Ord)]
pub enum DealerTicker {
    LBTC,
    USDt,
    EURx,
    MEX,
    DePix,
    SSWP,
    BMN2,
    CMSTR,
    PPRGB,
}

impl DealerTicker {
    pub const ALL: [DealerTicker; 9] = [
        DealerTicker::LBTC,
        DealerTicker::USDt,
        DealerTicker::EURx,
        DealerTicker::MEX,
        DealerTicker::DePix,
        DealerTicker::SSWP,
        DealerTicker::BMN2,
        DealerTicker::CMSTR,
        DealerTicker::PPRGB,
    ];

    pub fn asset_precision(&self) -> AssetPrecision {
        match self {
            DealerTicker::LBTC
            | DealerTicker::USDt
            | DealerTicker::EURx
            | DealerTicker::MEX
            | DealerTicker::DePix => AssetPrecision::BITCOIN_PRECISION,

            DealerTicker::BMN2 | DealerTicker::CMSTR => AssetPrecision::FOUR,

            DealerTicker::SSWP | DealerTicker::PPRGB => AssetPrecision::ZERO,
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Serialize, Deserialize)]
pub struct ExchangePair {
    pub base: DealerTicker,
    pub quote: DealerTicker,
}

impl std::fmt::Display for DealerTicker {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        dealer_ticker_to_asset_ticker(*self).fmt(f)
    }
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

pub fn dealer_ticker_to_asset_id(network: Network, ticker: DealerTicker) -> elements::AssetId {
    match ticker {
        DealerTicker::LBTC => network.d().policy_asset.asset_id(),
        DealerTicker::USDt => network.d().known_assets.usdt.asset_id(),
        DealerTicker::EURx => network.d().known_assets.eurx.asset_id(),
        DealerTicker::MEX => network.d().known_assets.mex.asset_id(),
        DealerTicker::DePix => network.d().known_assets.depix.asset_id(),
        DealerTicker::SSWP => network.d().known_assets.sswp.asset_id(),
        DealerTicker::BMN2 => network.d().known_assets.bmn2.asset_id(),
        DealerTicker::CMSTR => network.d().known_assets.cmstr.asset_id(),
        DealerTicker::PPRGB => network.d().known_assets.pprgb.asset_id(),
    }
}

pub fn dealer_ticker_from_asset_id(network: Network, asset_id: &AssetId) -> Option<DealerTicker> {
    DealerTicker::ALL
        .iter()
        .find(|ticker| dealer_ticker_to_asset_id(network, **ticker) == *asset_id)
        .copied()
}

fn dealer_ticker_to_asset_ticker(dealer_ticker: DealerTicker) -> &'static str {
    match dealer_ticker {
        DealerTicker::LBTC => sideswap_api::TICKER_LBTC,
        DealerTicker::USDt => sideswap_api::TICKER_USDT,
        DealerTicker::EURx => sideswap_api::TICKER_EURX,
        DealerTicker::MEX => sideswap_api::TICKER_MEX,
        DealerTicker::DePix => sideswap_api::TICKER_DEPIX,
        DealerTicker::SSWP => sideswap_api::TICKER_SSWP,
        DealerTicker::BMN2 => sideswap_api::TICKER_BMN2,
        DealerTicker::CMSTR => sideswap_api::TICKER_CMSTR,
        DealerTicker::PPRGB => sideswap_api::TICKER_PPRGB,
    }
}

pub fn dealer_ticker_from_asset_ticker(ticker: &str) -> Option<DealerTicker> {
    let ticker = match ticker {
        sideswap_api::TICKER_LBTC => DealerTicker::LBTC,
        sideswap_api::TICKER_USDT => DealerTicker::USDt,
        sideswap_api::TICKER_EURX => DealerTicker::EURx,
        sideswap_api::TICKER_MEX => DealerTicker::MEX,
        sideswap_api::TICKER_DEPIX => DealerTicker::DePix,
        sideswap_api::TICKER_SSWP => DealerTicker::SSWP,
        sideswap_api::TICKER_BMN2 => DealerTicker::BMN2,
        sideswap_api::TICKER_CMSTR => DealerTicker::CMSTR,
        sideswap_api::TICKER_PPRGB => DealerTicker::PPRGB,
        _ => return None,
    };
    Some(ticker)
}

impl Serialize for DealerTicker {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        let name = dealer_ticker_to_asset_ticker(*self);
        name.serialize(serializer)
    }
}

impl<'de> Deserialize<'de> for DealerTicker {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: serde::Deserializer<'de>,
    {
        let name = String::deserialize(deserializer)?;
        dealer_ticker_from_asset_ticker(&name)
            .ok_or_else(|| serde::de::Error::custom(anyhow::anyhow!("unknown ticker {name}")))
    }
}

#[cfg(test)]
mod tests;
