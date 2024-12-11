use super::*;

#[test]
fn test_address_check() {
    // P2TR
    assert!(check_bitcoin_address(
        Env::Prod,
        "bc1p5cyxnuxmeuwuvkwfem96lqzszd02n6xdcjrs20cac6yqjjwudpxqkedrcr"
    ));
}
