use elements::AssetId;
use serde::{Deserialize, Serialize};
use sideswap_api::{TICKER_DEPIX, TICKER_EURX, TICKER_LBTC, TICKER_MEX, TICKER_SSWP, TICKER_USDT};
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
}

impl DealerTicker {
    pub const ALL: [DealerTicker; 6] = [
        DealerTicker::LBTC,
        DealerTicker::USDt,
        DealerTicker::EURx,
        DealerTicker::MEX,
        DealerTicker::DePix,
        DealerTicker::SSWP,
    ];

    pub fn asset_precision(&self) -> AssetPrecision {
        match self {
            DealerTicker::LBTC
            | DealerTicker::USDt
            | DealerTicker::EURx
            | DealerTicker::MEX
            | DealerTicker::DePix => AssetPrecision::BITCOIN_PRECISION,
            DealerTicker::SSWP => AssetPrecision::ZERO,
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
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

pub fn dealer_ticker_to_asset_id(network: Network, ticker: DealerTicker) -> elements::AssetId {
    match ticker {
        DealerTicker::LBTC => network.d().policy_asset.asset_id(),
        DealerTicker::USDt => network.d().known_assets.usdt.asset_id(),
        DealerTicker::EURx => network.d().known_assets.eurx.asset_id(),
        DealerTicker::MEX => network.d().known_assets.mex.asset_id(),
        DealerTicker::DePix => network.d().known_assets.depix.asset_id(),
        DealerTicker::SSWP => network.d().known_assets.sswp.asset_id(),
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
        DealerTicker::LBTC => TICKER_LBTC,
        DealerTicker::USDt => TICKER_USDT,
        DealerTicker::EURx => TICKER_EURX,
        DealerTicker::MEX => TICKER_MEX,
        DealerTicker::DePix => TICKER_DEPIX,
        DealerTicker::SSWP => TICKER_SSWP,
    }
}

pub fn dealer_ticker_from_asset_ticker(ticker: &str) -> Option<DealerTicker> {
    let ticker = match ticker {
        TICKER_LBTC => DealerTicker::LBTC,
        TICKER_USDT => DealerTicker::USDt,
        TICKER_EURX => DealerTicker::EURx,
        TICKER_MEX => DealerTicker::MEX,
        TICKER_DEPIX => DealerTicker::DePix,
        TICKER_SSWP => DealerTicker::SSWP,
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
