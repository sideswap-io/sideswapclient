use elements::AssetId;
use sideswap_types::asset_precision::AssetPrecision;

use crate::network::Network;

sideswap_types::define_enum!(DealerTicker {
    LBTC,

    USDt,
    EURx,
    MEX,
    DePix,

    SSWP,
    BMN2,
    CMSTR,
    EXOeu,
    AQF,
    BAKER,
    BSIC1,

    PPRGB,
});

impl DealerTicker {
    pub fn asset_precision(&self) -> AssetPrecision {
        match self {
            DealerTicker::LBTC
            | DealerTicker::USDt
            | DealerTicker::EURx
            | DealerTicker::MEX
            | DealerTicker::DePix => AssetPrecision::BITCOIN_PRECISION,

            DealerTicker::BMN2 | DealerTicker::CMSTR => AssetPrecision::FOUR,

            DealerTicker::AQF | DealerTicker::BSIC1 => AssetPrecision::TWO,

            DealerTicker::SSWP
            | DealerTicker::PPRGB
            | DealerTicker::EXOeu
            | DealerTicker::BAKER => AssetPrecision::ZERO,
        }
    }
}

impl std::fmt::Display for DealerTicker {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        dealer_ticker_to_asset_ticker(*self).fmt(f)
    }
}

pub fn dealer_ticker_to_asset_id(network: Network, ticker: DealerTicker) -> elements::AssetId {
    match ticker {
        DealerTicker::LBTC => network.d().policy_asset.asset_id(),

        DealerTicker::USDt => network.d().known_assets.USDt.asset_id(),
        DealerTicker::EURx => network.d().known_assets.EURx.asset_id(),
        DealerTicker::MEX => network.d().known_assets.MEX.asset_id(),
        DealerTicker::DePix => network.d().known_assets.DePix.asset_id(),

        DealerTicker::SSWP => network.d().known_assets.SSWP.asset_id(),
        DealerTicker::BMN2 => network.d().known_assets.BMN2.asset_id(),
        DealerTicker::CMSTR => network.d().known_assets.CMSTR.asset_id(),
        DealerTicker::PPRGB => network.d().known_assets.PPRGB.asset_id(),
        DealerTicker::EXOeu => network.d().known_assets.EXOeu.asset_id(),
        DealerTicker::AQF => network.d().known_assets.AQF.asset_id(),
        DealerTicker::BAKER => network.d().known_assets.BAKER.asset_id(),
        DealerTicker::BSIC1 => network.d().known_assets.BSIC1.asset_id(),
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
        DealerTicker::EXOeu => sideswap_api::TICKER_EXOEU,
        DealerTicker::AQF => sideswap_api::TICKER_AQF,
        DealerTicker::BAKER => sideswap_api::TICKER_BAKER,
        DealerTicker::BSIC1 => sideswap_api::TICKER_BSIC1,
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
        sideswap_api::TICKER_EXOEU => DealerTicker::EXOeu,
        sideswap_api::TICKER_AQF => DealerTicker::AQF,
        sideswap_api::TICKER_BAKER => DealerTicker::BAKER,
        sideswap_api::TICKER_BSIC1 => DealerTicker::BSIC1,
        _ => return None,
    };
    Some(ticker)
}

impl serde::Serialize for DealerTicker {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        let name = dealer_ticker_to_asset_ticker(*self);
        name.serialize(serializer)
    }
}

impl<'de> serde::Deserialize<'de> for DealerTicker {
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
