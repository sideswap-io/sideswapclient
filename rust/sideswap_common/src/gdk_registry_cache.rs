use std::{
    collections::BTreeMap,
    path::{Path, PathBuf},
    sync::Arc,
    time::Duration,
};

use anyhow::ensure;
use arc_swap::ArcSwap;
use base64::Engine;
use elements::{AssetId, ContractHash};
use serde::{Deserialize, Serialize};
use sideswap_types::asset_precision::AssetPrecision;

use crate::network::Network;

#[derive(Serialize, Deserialize, Debug, PartialEq, Eq, Clone)]
pub struct GdkAssetEntity {
    pub domain: String,
}

#[derive(Serialize, Deserialize, Debug, PartialEq, Eq, Clone)]
pub struct GdkAsset {
    pub asset_id: AssetId,
    pub name: String,
    pub precision: AssetPrecision,
    pub ticker: Option<sideswap_api::Ticker>, // Can be null for some assets
    pub entity: GdkAssetEntity,
    pub issuance_prevout: sideswap_api::IssuancePrevout,
    pub issuer_pubkey: String,
    pub contract: serde_json::Value,
}

#[derive(Serialize, Deserialize, Debug, PartialEq, Eq, Clone)]
pub struct GdkAssetContract {
    pub entity: GdkAssetEntity,
    pub issuer_pubkey: String,
    pub name: String,
    pub precision: AssetPrecision,
    pub ticker: Option<sideswap_api::Ticker>,
    pub version: u32,
}

pub struct GdkRegistryCache {
    policy_asset_id: AssetId,
    assets: Updater<AssetRegistry>,
    icons: Updater<IconRegistry>,
}

#[derive(Serialize, Deserialize, Debug, PartialEq, Eq, Clone)]
pub struct ShortAssetInfo {
    pub asset_id: AssetId,
    pub name: String,
    pub ticker: Option<sideswap_api::Ticker>,
    pub precision: AssetPrecision,
}

pub type AllGdkAssets = Arc<BTreeMap<AssetId, GdkAsset>>;

pub type AllGdkIcons = Arc<BTreeMap<AssetId, Vec<u8>>>;

pub fn get_policy_asset_short_info(policy_asset: &AssetId) -> ShortAssetInfo {
    ShortAssetInfo {
        asset_id: *policy_asset,
        name: "Liquid Bitcoin".to_owned(),
        ticker: Some(sideswap_api::Ticker("L-BTC".to_owned())),
        precision: AssetPrecision::BITCOIN_PRECISION,
    }
}

impl GdkRegistryCache {
    pub async fn new(network: Network, cache_dir: impl AsRef<Path>) -> Self {
        let cache_dir = cache_dir.as_ref().join(network.d().name);
        std::fs::create_dir_all(&cache_dir).expect("can't create cache directory");

        let policy_asset_id = network.d().policy_asset.asset_id();
        let assets = Updater::new(network, cache_dir.clone()).await;
        let icons = Updater::new(network, cache_dir).await;

        GdkRegistryCache {
            policy_asset_id,
            assets,
            icons,
        }
    }

    /// NOTE: Does not include L-BTC
    pub fn get_all_assets(&self) -> AllGdkAssets {
        self.assets.data.load_full()
    }

    pub fn get_all_icons(&self) -> AllGdkIcons {
        self.icons.data.load_full()
    }

    pub fn verify_asset_hash(asset_id: &AssetId, asset: &GdkAsset) {
        assert_eq!(asset.asset_id, *asset_id);

        // Verify contract hash
        let contract = serde_json::to_string(&asset.contract).expect("must not fail");
        let contract_hash = ContractHash::from_json_contract(&contract).expect("must not fail");
        let prevout = elements::OutPoint {
            txid: asset.issuance_prevout.txid,
            vout: asset.issuance_prevout.vout,
        };
        let entropy = AssetId::generate_asset_entropy(prevout, contract_hash);
        let expected_asset_id = AssetId::from_entropy(entropy);
        assert_eq!(
            expected_asset_id, *asset_id,
            "asset id verification failed, asset_id: {}, expected: {}, name: {}",
            asset_id, expected_asset_id, asset.name
        );

        // Verify contract content
        let contract = serde_json::from_value::<GdkAssetContract>(asset.contract.clone())
            .expect("must be valid");
        assert_eq!(contract.entity.domain, asset.entity.domain);
        assert_eq!(contract.name, asset.name);
        assert_eq!(contract.ticker, asset.ticker);
        assert_eq!(contract.precision, asset.precision);
        assert_eq!(contract.issuer_pubkey, asset.issuer_pubkey);
    }

    /// NOTE: Does not include L-BTC
    ///
    /// Contract hash is verified
    pub fn get_asset(&self, asset_id: &AssetId) -> Option<GdkAsset> {
        let assets = self.assets.data.load();
        let asset = assets.get(asset_id).cloned()?;
        Self::verify_asset_hash(asset_id, &asset);
        Some(asset)
    }

    /// NOTE: Does include L-BTC
    ///
    /// Contract hash is verified for all assets except L-BTC
    pub fn get_short_asset(&self, asset_id: &AssetId) -> Option<ShortAssetInfo> {
        if *asset_id == self.policy_asset_id {
            Some(get_policy_asset_short_info(&self.policy_asset_id))
        } else {
            let assets = self.assets.data.load();
            let asset = assets.get(asset_id)?;
            Self::verify_asset_hash(asset_id, asset);
            Some(ShortAssetInfo {
                asset_id: *asset_id,
                name: asset.name.clone(),
                ticker: asset.ticker.clone(),
                precision: asset.precision,
            })
        }
    }

    pub fn get_icon(&self, asset_id: &AssetId) -> Option<Vec<u8>> {
        self.icons.data.load().get(asset_id).cloned()
    }

    /// NOTE: Does not include L-BTC
    pub fn has_asset(&self, asset_id: &AssetId) -> bool {
        self.assets.data.load().contains_key(asset_id)
    }

    pub fn has_icon(&self, asset_id: &AssetId) -> bool {
        self.icons.data.load().contains_key(asset_id)
    }
}

fn check_network<T>(data: &BTreeMap<AssetId, T>, network: Network) -> Result<(), anyhow::Error> {
    ensure!(
        data.contains_key(&network.d().known_assets.USDt.asset_id())
            || data.contains_key(&network.d().known_assets.EURx.asset_id()),
        "wrong network, can't find usdt or eurx asset"
    );
    Ok(())
}

#[derive(Clone)]
struct Updater<R: Registry> {
    data: Arc<ArcSwap<BTreeMap<AssetId, R::Item>>>,
    handle: Arc<tokio::task::AbortHandle>,
}

#[derive(Serialize, Deserialize)]
struct CacheFile<R: Registry> {
    last_modified: Option<String>,
    raw_items: BTreeMap<AssetId, R::RawItem>,
}

trait Registry {
    type RawItem: serde::de::DeserializeOwned + serde::ser::Serialize + Send + Sync;

    type Item: Send + Sync;

    fn file_name() -> &'static str;

    fn convert_item(item: Self::RawItem) -> Result<Self::Item, anyhow::Error>;
}

struct AssetRegistry;

impl Registry for AssetRegistry {
    type RawItem = GdkAsset;

    type Item = GdkAsset;

    fn file_name() -> &'static str {
        "index.json"
    }

    fn convert_item(item: Self::RawItem) -> Result<Self::Item, anyhow::Error> {
        Ok(item)
    }
}

struct IconRegistry;

impl Registry for IconRegistry {
    type RawItem = String;

    type Item = Vec<u8>;

    fn file_name() -> &'static str {
        "icons.json"
    }

    fn convert_item(item: Self::RawItem) -> Result<Self::Item, anyhow::Error> {
        let item = base64::engine::general_purpose::STANDARD.decode(item)?;
        Ok(item)
    }
}

fn read_cache_file<R: Registry>(
    file_path: &Path,
    network: Network,
) -> Result<(BTreeMap<AssetId, R::Item>, Option<String>), anyhow::Error> {
    let data = std::fs::read_to_string(file_path)?;
    let cache = serde_json::from_str::<CacheFile<R>>(&data)?;
    check_network(&cache.raw_items, network)?;
    let items = convert_items::<R>(cache.raw_items)?;
    Ok((items, cache.last_modified))
}

async fn load_url<R: Registry>(
    network: Network,
    last_modified: &Option<String>,
) -> Result<Option<(String, Option<String>)>, anyhow::Error> {
    let base_url = network.d().asset_registry_url;
    let url = format!("{}/{}", base_url, R::file_name());
    let mut request = reqwest::Client::new()
        .get(&url)
        .timeout(Duration::from_secs(60));
    if let Some(last_modified) = last_modified {
        request = request.header("If-Modified-Since", last_modified);
    }
    let assets_response = request.send().await?;
    let status = assets_response.status();
    log::debug!("call_assets {} returns {}", url, status);
    if status == 304 {
        // The server should not return 304 if last_modified was not set
        ensure!(last_modified.is_some());
        return Ok(None);
    }
    let last_modified = assets_response
        .headers()
        .get("Last-Modified")
        .map(|value| value.to_str().map(|value| value.to_owned()))
        .transpose()?;
    let data = assets_response.text().await?;
    serde_json::from_str::<serde_json::Value>(&data)?;

    Ok(Some((data, last_modified)))
}

fn convert_items<R: Registry>(
    raw_items: BTreeMap<AssetId, R::RawItem>,
) -> Result<BTreeMap<AssetId, R::Item>, anyhow::Error> {
    let mut items = BTreeMap::new();
    for (asset_id, raw_item) in raw_items.into_iter() {
        let item = R::convert_item(raw_item)?;
        items.insert(asset_id, item);
    }
    Ok(items)
}

async fn load_from_network<R: Registry>(
    network: Network,
    last_modified: &Option<String>,
    file_path: &Path,
) -> Result<Option<(BTreeMap<AssetId, R::Item>, Option<String>)>, anyhow::Error> {
    let load_result = load_url::<R>(network, last_modified).await?;
    let (data, last_modified) = match load_result {
        Some(v) => v,
        None => return Ok(None),
    };
    let raw_items = serde_json::from_str::<BTreeMap<AssetId, R::RawItem>>(&data)?;
    check_network(&raw_items, network)?;

    let cache = CacheFile::<R> {
        last_modified,
        raw_items,
    };
    let file_path_tmp = file_path.with_extension("tmp");
    let cache_data = serde_json::to_string(&cache).expect("should not fail");
    std::fs::write(&file_path_tmp, &cache_data)?;
    std::fs::rename(&file_path_tmp, file_path)?;

    let items = convert_items::<R>(cache.raw_items)?;
    Ok(Some((items, cache.last_modified)))
}

impl<R: Registry + 'static> Updater<R> {
    async fn new(network: Network, cache_dir: PathBuf) -> Self {
        let file_path = cache_dir.join(R::file_name());

        let (items, last_modified) = match read_cache_file::<R>(&file_path, network) {
            Ok(data) => data,
            Err(err) => {
                log::warn!("loading cache file {file_path:?} failed: {err}");
                loop {
                    let res = load_from_network::<R>(network, &None, &file_path).await;
                    match res {
                        Ok(Some(output)) =>
                            break output,

                        Ok(None) => unreachable!("load_from_network should not return empty result when last_modified is None"),
                        Err(err) => {
                            log::error!("loading failed: {err}");
                            tokio::time::sleep(Duration::from_secs(60)).await;
                        }
                    }
                }
            }
        };

        let data = Arc::new(ArcSwap::from_pointee(items));

        let task = tokio::spawn(run::<R>(
            network,
            file_path,
            last_modified,
            Arc::clone(&data),
        ));

        let handle = Arc::new(task.abort_handle());

        Self { data, handle }
    }
}

impl<R: Registry> Drop for Updater<R> {
    fn drop(&mut self) {
        self.handle.abort();
    }
}

async fn run<R: Registry + 'static>(
    network: Network,
    file_path: PathBuf,
    mut last_modified: Option<String>,
    data: Arc<ArcSwap<BTreeMap<AssetId, R::Item>>>,
) {
    loop {
        let res = load_from_network::<R>(network, &last_modified, &file_path).await;

        match res {
            Ok(Some((items, last_modified_new))) => {
                log::info!(
                    "gdk registry updated ({}), new count: {}",
                    R::file_name(),
                    items.len()
                );
                data.store(Arc::new(items));
                last_modified = last_modified_new;
                tokio::time::sleep(Duration::from_secs(600)).await;
            }
            Ok(None) => {
                log::info!("gdk registry was not updated ({})", R::file_name(),);
                tokio::time::sleep(Duration::from_secs(3600)).await;
            }
            Err(err) => {
                log::error!("loading gdk registry failed: {err}");
                tokio::time::sleep(Duration::from_secs(600)).await;
            }
        }
    }
}

#[cfg(test)]
mod tests;
