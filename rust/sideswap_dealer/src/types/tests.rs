use super::*;

#[test]
fn names() {
    for ticker in DealerTicker::ALL {
        let name = dealer_ticker_to_asset_ticker(ticker);
        let ticker2 = dealer_ticker_from_asset_ticker(name).unwrap();
        assert_eq!(ticker, ticker2);
    }
}
