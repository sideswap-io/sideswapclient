use super::*;

#[derive(serde::Deserialize, Debug)]
pub struct GdkEntity {
    pub domain: Option<String>,
}

#[derive(serde::Deserialize, Debug)]
pub struct GdkAsset {
    pub asset_id: AssetId,
    pub name: Option<String>,
    pub precision: Option<u8>,
    pub ticker: Option<Ticker>,
    pub entity: Option<GdkEntity>,
}

#[derive(serde::Deserialize, Debug, Default)]
pub struct GdkAssets {
    pub assets: std::collections::BTreeMap<AssetId, GdkAsset>,
    pub icons: std::collections::BTreeMap<AssetId, String>,
}
