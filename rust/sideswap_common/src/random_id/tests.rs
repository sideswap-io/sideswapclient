use super::*;

#[test]
fn basic() {
    let num = numeric_string(10);
    assert_eq!(num.len(), 10);
    assert!(num.chars().all(|char| char.is_numeric()));
}
