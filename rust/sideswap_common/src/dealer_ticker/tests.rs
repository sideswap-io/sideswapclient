use super::*;

#[test]
fn basic() {
    assert_eq!(DealerTicker::LBTC.as_str(), "L-BTC");
    assert_eq!(DealerTicker::from_str("L-BTC").unwrap(), DealerTicker::LBTC);

    assert_eq!(DealerTicker::USDT.as_str(), "USDt");
    assert_eq!(DealerTicker::from_str("USDt").unwrap(), DealerTicker::USDT);
}

#[test]
fn long_ticker_name() {
    let ticker = DealerTicker::const_parse("12345678");
    assert_eq!(ticker.as_str(), "12345678");
}

#[test]
fn too_long_err() {
    let _err = DealerTicker::from_str("123456789").unwrap_err();
}
