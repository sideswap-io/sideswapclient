use std::str::FromStr;

use super::*;

#[test]
fn basic() {
    let asset_id = "6f0279e9ed041c3d710a9f57d0c02928416460c4b722ae3457a11eec381c526d";
    let a = ConstAssetId::new(asset_id);
    let b = elements::AssetId::from_str(asset_id).unwrap();
    assert_eq!(a.asset_id(), b);
}
