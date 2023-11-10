// #![warn(missing_docs)]

//! # GDK registry
//
//! This library provides Liquid assets metadata ensuring data is verified and
//! preserving privacy. It also provides asset icons.
//!
//! A small number of assets information are hard-coded within this library,
//! others are fetched from a default "asset registry" or a user-defined one.
//!
//! The main methods are [`get_assets`] and [`refresh_assets`], but the library
//! must first be initialized by calling [`init`].
//!
//! Assets metadata are informations like the name of an asset, the ticker, and
//! the precision (decimal places of amounts) which define how wallets show
//! informations to users. It's important that these informations are presented
//! correctly so that users can make an informed decision. To ensure these
//! properties, assets metadata are committed in the assets id and verified on
//! the client, so that if the fetched informations are incorrect this library
//! will filter them out.
//!
//! Another important consideration is that access to registries is made in a
//! way that user interest in a particular asset is not revealed to preserve
//! users' privacy.

mod asset_entry;
mod assets_or_icons;
mod cache;
mod error;
mod file;
mod hard_coded;
mod http;
mod last_modified;
mod params;
mod registry;
mod registry_infos;

use std::path::Path;
use std::sync::Arc;
use std::thread;

use assets_or_icons::AssetsOrIcons;
use cache::Cache;
use gdk_common::log;
use last_modified::LastModified;
use params::GetAssetsQuery;
use registry_infos::RegistrySource;

pub use asset_entry::AssetEntry;
pub use error::{Error, Result};
pub use hard_coded::policy_asset_id;
pub use params::{
    AssetCategory, Config, ElementsNetwork, GetAssetsBuilder, GetAssetsParams, RefreshAssetsParams,
};
pub use registry_infos::RegistryInfos;

/// Initialize the library by specifying the root directory where the cached
/// data is persisted across sessions.
pub fn init(dir: impl AsRef<Path>) -> Result<()> {
    registry::init(&dir)?;
    cache::init(&dir)
}

/// Returns informations about a set of assets and related icons.
///
/// Unlike [`refresh_assets`], this function will cache the queried assets to
/// avoid performing a full registry read on every call. The cache file stored
/// on disk is encrypted via the wallet's xpub key.
pub fn get_assets(params: GetAssetsParams) -> Result<RegistryInfos> {
    let network = params.config.network;

    let (assets_id, xpub) = match params.into_query()? {
        GetAssetsQuery::FromCache(assets_id, xpub) => (assets_id, xpub),
        GetAssetsQuery::FromRegistry(matcher) => return registry::filter_full(network, &*matcher),
        GetAssetsQuery::FromHardCoded(matcher) => {
            return registry::filter_hard_coded(network, &*matcher)
        }
        GetAssetsQuery::WholeRegistry => return registry::get_full(network),
    };

    let mut cache_files = cache::CACHE_FILES.lock()?;
    let mut cache = Cache::from_xpub(xpub, &mut *cache_files);

    log::debug!("`get_assets` using cache {:?}", cache);

    let (mut cached, mut not_cached): (Vec<_>, Vec<_>) =
        assets_id.into_iter().partition(|id| cache.is_cached(id));

    // Remove all the ids known not to be in the registry to avoid retriggering
    // a registry read.
    not_cached.retain(|id| !cache.is_missing(id));

    if not_cached.is_empty() {
        cache.filter(&cached);
        return Ok(cache.to_registry(true));
    }

    log::debug!("{:?} are not already cached", not_cached);

    let registry = registry::get_full(network)?;

    // The returned infos are marked as being from the registry if at least one
    // of the returned assets is from the full asset registry.
    let mut from_cache = true;

    let mut in_registry = Vec::new();
    let mut assets_not_in_disk = Vec::new();
    let mut icons_not_in_disk = Vec::new();

    for id in not_cached {
        match (registry.contains_asset(&id), registry.contains_icon(&id)) {
            (true, true) => in_registry.push(id),

            (true, false) => {
                in_registry.push(id.clone());
                icons_not_in_disk.push(id);
            }

            (false, true) => {
                assets_not_in_disk.push(id.clone());
            }

            (false, false) => {
                assets_not_in_disk.push(id.clone());
                icons_not_in_disk.push(id);
            }
        }
    }

    if !in_registry.is_empty() {
        log::debug!("{:?} found in the local asset registry", in_registry);
        cache.extend_from_registry(registry, &in_registry);
        cache.update(&mut *cache_files)?;
        cached.extend(in_registry);
        from_cache = false;
    }

    if !assets_not_in_disk.is_empty() {
        log::debug!("{:?} are not in the local asset registry", assets_not_in_disk);
        cache.register_missing_assets(assets_not_in_disk);
        cache.update(&mut *cache_files)?;
    }

    if !icons_not_in_disk.is_empty() {
        log::debug!("{:?} are not in the local icons registry", icons_not_in_disk);
        cache.register_missing_icons(icons_not_in_disk);
        cache.update(&mut *cache_files)?;
    }

    cache.filter(&cached);
    Ok(cache.to_registry(from_cache))
}

/// Returns informations about a set of assets and related icons.
///
/// Results could come from the persisted cached value when `params.refresh`
/// is `false`, or could be fetched from an asset registry when it's `true`. By
/// default, the Liquid mainnet network is used and the asset registry used is
/// managed by Blockstream and no proxy is used to access it. This default
/// configuration can be overridden by providing the `params.config` parameter.
pub fn refresh_assets(params: RefreshAssetsParams) -> Result<RegistrySource> {
    if !params.wants_something() {
        return Err(Error::BothAssetsIconsFalse);
    }

    let params = Arc::new(params);

    let assets_handle = {
        let params = Arc::clone(&params);
        thread::spawn(move || {
            params
                .wants_assets()
                .then(|| registry::refresh_assets(&params))
                .transpose()
                .map(Option::unwrap_or_default)
        })
    };

    let icons_source = params
        .wants_icons()
        // forces multiline formatting
        .then(|| registry::refresh_icons(&params))
        .transpose()?
        .unwrap_or_default();

    let assets_source = assets_handle.join().unwrap()?;

    Ok(RegistrySource::merge(assets_source, icons_source))
}
