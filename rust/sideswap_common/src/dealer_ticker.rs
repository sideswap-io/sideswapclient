use std::{collections::BTreeMap, str::FromStr};

use anyhow::anyhow;
use elements::AssetId;
use sideswap_types::asset_precision::AssetPrecision;

use crate::{gdk_registry_cache::GdkRegistryCache, network::Network};

#[derive(Copy, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, Debug)]
pub struct DealerTicker([u8; 8]);

impl DealerTicker {
    const MAX_LEN: usize = std::mem::size_of::<DealerTicker>();

    const fn const_parse(value: &str) -> DealerTicker {
        let mut output = [0u8; DealerTicker::MAX_LEN];
        let bytes = value.as_bytes();
        let len = bytes.len();

        let mut i = 0;
        while i < len {
            output[i] = bytes[i];
            i += 1;
        }

        DealerTicker(output)
    }

    pub fn as_str(&self) -> &str {
        let end = self
            .0
            .iter()
            .rposition(|&b| b != 0)
            .map_or(0, |pos| pos + 1);
        let trimmed = &self.0[..end];
        std::str::from_utf8(trimmed).expect("must be valid")
    }

    pub const LBTC: DealerTicker = DealerTicker::const_parse("L-BTC");
    pub const EURX: DealerTicker = DealerTicker::const_parse("EURx");
    pub const USDT: DealerTicker = DealerTicker::const_parse("USDt");
    pub const DEPIX: DealerTicker = DealerTicker::const_parse("DePix");
    pub const MEX: DealerTicker = DealerTicker::const_parse("MEX");
}

#[derive(Debug)]
pub struct InvalidTickerError(String);

impl std::fmt::Display for InvalidTickerError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "Invalid ticker: {}, must be less than {} bytes",
            self.0,
            DealerTicker::MAX_LEN
        )
    }
}

impl std::fmt::Display for DealerTicker {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        self.as_str().fmt(f)
    }
}

impl std::error::Error for InvalidTickerError {}

impl std::str::FromStr for DealerTicker {
    type Err = InvalidTickerError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        if s.bytes().len() > DealerTicker::MAX_LEN {
            Err(InvalidTickerError(s.to_owned()))
        } else {
            Ok(DealerTicker::const_parse(s))
        }
    }
}

impl serde::Serialize for DealerTicker {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        self.as_str().serialize(serializer)
    }
}

impl<'de> serde::Deserialize<'de> for DealerTicker {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: serde::Deserializer<'de>,
    {
        let ticker = String::deserialize(deserializer)?;
        let ticker = DealerTicker::from_str(&ticker).map_err(serde::de::Error::custom)?;
        Ok(ticker)
    }
}

pub struct TickerLoader {
    asset_ids: BTreeMap<AssetId, DealerTicker>,
    precisions: BTreeMap<DealerTicker, AssetPrecision>,
    tickers: BTreeMap<DealerTicker, AssetId>,
}

pub type WhitelistedAssets = Vec<AssetId>;

impl TickerLoader {
    pub fn new(gdk_registry: &GdkRegistryCache, network: Network) -> TickerLoader {
        let known_assets = &network.d().known_assets;
        let mut ticker_loader = TickerLoader {
            asset_ids: BTreeMap::new(),
            precisions: BTreeMap::new(),
            tickers: BTreeMap::new(),
        };

        ticker_loader
            .add_asset(gdk_registry, &network.d().policy_asset.asset_id())
            .expect("must be fail");

        for asset_id in known_assets.all_assets() {
            ticker_loader
                .add_asset(gdk_registry, &asset_id)
                .expect("must be fail");
        }

        let more_assets = match network {
            Network::Liquid => [
                "aa909f1b77451e409fe95fe1d3638ad017ab3325c6d4f00301af6d582d0f2034", // BMN2
                "e8305bb5c1794b256a858a01e5d8af7a5817d257fbfbc2c9d49620f13ff401a9", // CMSTR
                "52d77159096eed69c73862a30b0d4012b88cedf92d518f98bc5fc8d34b6c27c9", // EXOeu
                "3caca4d1e7c596d4f59db73d62e514963c098cc327cab550bd460a9927f5fdbe", // AQF
                "bac499716a43edb4bfd43c31c9cbe06f50921c57164866ea07549ed9b5aa2da3", // BAKER
                "13fd46f84c0885b9d2cfab1b8f0200876f8a0b2933ddda963187118abecbbbf1", // BSIC1
                "7f07d961c654f5a5aef82d97541016f32d43b7da91ab730bde883a7d6dd6c9c7", // PPRGB
            ]
            .as_slice(),
            Network::LiquidTestnet => [
                "649f01bd72fbe33a70508e752044a2b0f91cf73612b70e03f337d095daa8b002", // PXTST
                "639ed77089105bcfe434d47f7368d87f53f30a45fc3cff7463105d152bb4d3b1", // PXTR
                "e7af57b566c7555b246719109a4355a614e0c1112f9706abd50dae01ecdcd3e3", // PXTR2
            ]
            .as_slice(),
            Network::Regtest => [].as_slice(),
        };
        for asset_id in more_assets {
            let asset_id = AssetId::from_str(asset_id).expect("must not fail");
            let res = ticker_loader.add_asset(gdk_registry, &asset_id);
            if let Err(err) = res {
                log::error!("adding asset {asset_id} failed: {err}");
            }
        }

        ticker_loader
    }

    fn add_asset(
        &mut self,
        gdk_registry: &GdkRegistryCache,
        asset_id: &AssetId,
    ) -> Result<(), anyhow::Error> {
        let asset = gdk_registry
            .get_short_asset(asset_id)
            .ok_or_else(|| anyhow!("can't find asset {asset_id}"))?;

        if !self.asset_ids.contains_key(&asset.asset_id) {
            let ticker = asset
                .ticker
                .as_ref()
                .ok_or_else(|| anyhow!("asset {asset_id} has no ticker"))?;
            let ticker = DealerTicker::from_str(&ticker.0)?;

            let old_value = self.asset_ids.insert(asset.asset_id, ticker);
            assert!(old_value.is_none());

            let old_value = self.tickers.insert(ticker, asset.asset_id);
            assert!(old_value.is_none());

            let old_value = self.precisions.insert(ticker, asset.precision);
            assert!(old_value.is_none());
        }

        Ok(())
    }

    pub async fn load(
        work_dir: &str,
        whitelisted_assets: Option<&WhitelistedAssets>,
        network: Network,
    ) -> Result<TickerLoader, anyhow::Error> {
        let gdk_registry = GdkRegistryCache::new(network, work_dir).await;

        let mut ticker_loader = TickerLoader::new(&gdk_registry, network);

        if let Some(config) = whitelisted_assets {
            for asset_id in config {
                ticker_loader.add_asset(&gdk_registry, asset_id)?;
            }
        }

        Ok(ticker_loader)
    }

    pub fn has_ticker(&self, ticker: DealerTicker) -> bool {
        self.tickers.contains_key(&ticker)
    }

    pub fn asset_id(&self, ticker: DealerTicker) -> &AssetId {
        self.tickers
            .get(&ticker)
            .unwrap_or_else(|| panic!("can't find asset with ticker {ticker}"))
    }

    pub fn precision(&self, ticker: DealerTicker) -> AssetPrecision {
        *self
            .precisions
            .get(&ticker)
            .unwrap_or_else(|| panic!("can't find asset with ticker {ticker}"))
    }

    pub fn ticker(&self, asset_id: &AssetId) -> Option<DealerTicker> {
        self.asset_ids.get(asset_id).cloned()
    }
}

#[cfg(test)]
mod tests;
