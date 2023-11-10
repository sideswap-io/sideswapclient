use std::collections::HashMap;
use std::fmt;

use gdk_common::elements::AssetId;
use serde::{ser, Deserialize, Serialize};

use crate::asset_entry::AssetEntry;

pub(crate) type RegistryAssets = HashMap<AssetId, AssetEntry>;
pub(crate) type RegistryIcons = HashMap<AssetId, String>;

/// Asset informations returned by [`get_assets`](crate::get_assets).
#[derive(Clone, Default, Eq, PartialEq, Serialize, Deserialize)]
pub struct RegistryInfos {
    /// Assets metadata.
    pub assets: RegistryAssets,

    /// Assets icons: the hashmap value is a Base64 encoded image.
    pub icons: RegistryIcons,

    #[serde(default, skip_serializing)]
    pub(crate) source: Option<RegistrySource>,
}

/// Max number of assets and icons included in the debug output of
/// [`RegistryInfos`].
const REGISTRY_INFOS_DEBUG_LIMIT: usize = 64;

// Custom `Debug` impl to avoid having full base64 encoded images in debug
// logs.
impl fmt::Debug for RegistryInfos {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let assets = self.assets.iter().take(REGISTRY_INFOS_DEBUG_LIMIT).collect::<HashMap<_, _>>();

        let icons = self
            .icons
            .iter()
            .map(|(id, _b64)| (id, "..."))
            .take(REGISTRY_INFOS_DEBUG_LIMIT)
            .collect::<HashMap<_, _>>();

        f.debug_struct("RegistryInfos")
            .field("assets", &assets)
            .field("icons", &icons)
            .field("source", &self.source)
            .finish()
    }
}

#[derive(Copy, Clone, Debug, Eq, PartialEq, Deserialize)]
pub enum RegistrySource {
    Cache,
    Downloaded,
    LocalRegistry,
    NotModified,
}

impl Default for RegistrySource {
    fn default() -> Self {
        Self::LocalRegistry
    }
}

impl ser::Serialize for RegistrySource {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: ser::Serializer,
    {
        serializer.serialize_unit()
    }
}

impl RegistryInfos {
    pub(crate) fn contains_asset(&self, id: &AssetId) -> bool {
        self.assets.contains_key(id)
    }

    pub(crate) fn contains_icon(&self, id: &AssetId) -> bool {
        self.icons.contains_key(id)
    }

    pub(crate) const fn new(assets: RegistryAssets, icons: RegistryIcons) -> Self {
        Self {
            assets,
            icons,
            source: None,
        }
    }

    pub(crate) const fn new_with_source(
        assets: RegistryAssets,
        icons: RegistryIcons,
        source: RegistrySource,
    ) -> Self {
        Self {
            assets,
            icons,
            source: Some(source),
        }
    }
}

impl RegistrySource {
    pub(crate) fn merge(self, other: Self) -> Self {
        use RegistrySource::*;
        match (self, other) {
            (Cache, source) | (source, Cache) => source,
            (Downloaded, _) | (_, Downloaded) => Downloaded,
            (LocalRegistry, source) | (source, LocalRegistry) => source,
            (NotModified, NotModified) => NotModified,
        }
    }
}
