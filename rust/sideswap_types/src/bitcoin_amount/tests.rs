use super::*;

#[test]
fn basic() {
    let value = serde_json::from_str::<BtcAmount>("1.00000123").unwrap();
    assert_eq!(value.0, 100000123);

    assert_eq!(value.to_string(), "1.00000123 BTC");

    let value = serde_json::from_str::<BtcAmount>("1").unwrap();
    assert_eq!(value.0, 100000000);

    assert_eq!(value.to_string(), "1 BTC");
}
