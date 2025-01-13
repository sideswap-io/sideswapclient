use std::path::PathBuf;

use super::*;

#[test]
fn names() {
    for ticker in DealerTicker::ALL {
        let name = dealer_ticker_to_asset_ticker(ticker);
        let ticker2 = dealer_ticker_from_asset_ticker(name).unwrap();
        assert_eq!(ticker, ticker2);
    }
}

#[tokio::test]
async fn dealer_tickers() {
    let network = Network::Liquid;

    let gdk_registry = sideswap_common::gdk_registry_cache::GdkRegistryCache::new(
        network,
        &PathBuf::from("/tmp/sideswap/"),
    )
    .await;

    for dealer_ticker in DealerTicker::ALL {
        let asset_id = dealer_ticker_to_asset_id(network, dealer_ticker);
        if asset_id == network.d().policy_asset.asset_id() {
            continue;
        }
        let asset = gdk_registry.get_asset(&asset_id).unwrap();
        let expected_ticker = asset.ticker.unwrap();
        let parsed_dealer_ticker = dealer_ticker_from_asset_ticker(&expected_ticker.0).unwrap();
        assert_eq!(
            expected_ticker.0,
            dealer_ticker_to_asset_ticker(dealer_ticker)
        );
        assert_eq!(asset.precision, dealer_ticker.asset_precision());
        assert_eq!(dealer_ticker, parsed_dealer_ticker);
    }
}
