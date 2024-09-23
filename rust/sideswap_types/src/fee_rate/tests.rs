use super::*;

#[test]
fn basic() {
    let rate_orig = FeeRateBitcoin(0.00003003);
    let rate_sats = rate_orig.to_sats();
    assert_eq!(rate_sats.raw(), 3.003);
    let rate_new = rate_sats.to_bitcoin();
    assert_eq!(rate_new.0, rate_orig.0);
}
