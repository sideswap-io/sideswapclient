use super::*;

#[tokio::test]
async fn basic() {
    for network in [Network::Liquid, Network::LiquidTestnet] {
        let gdk_registry = GdkRegistryCache::new(network, "/tmp/sideswap").await;
        let all_assets = gdk_registry.get_all_assets();
        for asset_id in all_assets.keys() {
            gdk_registry.get_asset(asset_id).unwrap();
        }
    }
}
