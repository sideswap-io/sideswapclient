use crate::{network::Network, types::Amount};

use super::*;

#[test]
fn basic() {
    let network = Network::Liquid;
    let policy_asset = network.d().policy_asset.asset_id();
    let usdt_asset = network.d().known_assets.usdt.asset_id();

    let _res = try_coin_select(Args {
        multisig_wallet: false,
        policy_asset,
        fee_asset: usdt_asset,
        price: 60000.0,
        fixed_fee: Amount::from_bitcoin(0.04).to_sat() as u64,
        use_all_utxos: false,
        wallet_utxos: vec![InOut {
            asset_id: usdt_asset,
            value: 500000000000,
        }],
        server_utxos: [65, 291, 330, 343, 348, 348, 352]
            .iter()
            .map(|value| InOut {
                asset_id: policy_asset,
                value: *value,
            })
            .collect(),
        user_outputs: vec![InOut {
            asset_id: usdt_asset,
            value: 10000000000,
        }],
        deduct_fee: None,
    })
    .unwrap();
    // panic!("{_res:#?}");
}

#[test]
fn without_asset_change() {
    let network = Network::Liquid;
    let policy_asset = network.d().policy_asset.asset_id();
    let usdt_asset = network.d().known_assets.usdt.asset_id();

    let _res = try_coin_select(Args {
        multisig_wallet: false,
        policy_asset,
        fee_asset: usdt_asset,
        price: 60000.0,
        fixed_fee: Amount::from_bitcoin(0.04).to_sat() as u64,
        use_all_utxos: false,
        wallet_utxos: vec![InOut {
            asset_id: usdt_asset,
            value: 10023700000,
        }],
        server_utxos: [65, 291, 330, 343, 348, 348, 352]
            .iter()
            .map(|value| InOut {
                asset_id: policy_asset,
                value: *value,
            })
            .collect(),
        user_outputs: vec![InOut {
            asset_id: usdt_asset,
            value: 10000000000,
        }],
        deduct_fee: None,
    })
    .unwrap();
    // panic!("{_res:#?}");
}

#[test]
fn send_lbtc() {
    let network = Network::Liquid;
    let policy_asset = network.d().policy_asset.asset_id();
    let usdt_asset = network.d().known_assets.usdt.asset_id();

    let _res = try_coin_select(Args {
        multisig_wallet: false,
        policy_asset,
        fee_asset: usdt_asset,
        price: 60000.0,
        fixed_fee: Amount::from_bitcoin(0.04).to_sat() as u64,
        use_all_utxos: false,
        wallet_utxos: vec![
            InOut {
                asset_id: policy_asset,
                value: 100000000,
            },
            InOut {
                asset_id: usdt_asset,
                value: 200000000000,
            },
        ],
        server_utxos: [330, 343, 348, 348, 352]
            .iter()
            .map(|value| InOut {
                asset_id: policy_asset,
                value: *value,
            })
            .collect(),
        user_outputs: vec![InOut {
            asset_id: policy_asset,
            value: 100000000,
        }],
        deduct_fee: None,
    })
    .unwrap();
    // panic!("{_res:#?}");
}

#[test]
fn deduct_fee_whole_amount() {
    let network = Network::Liquid;
    let policy_asset = network.d().policy_asset.asset_id();
    let usdt_asset = network.d().known_assets.usdt.asset_id();

    let _res = try_coin_select(Args {
        multisig_wallet: false,
        policy_asset,
        fee_asset: usdt_asset,
        price: 60000.0,
        fixed_fee: Amount::from_bitcoin(0.04).to_sat() as u64,
        use_all_utxos: false,
        wallet_utxos: vec![InOut {
            asset_id: usdt_asset,
            value: 200000000000,
        }],
        server_utxos: [500]
            .iter()
            .map(|value| InOut {
                asset_id: policy_asset,
                value: *value,
            })
            .collect(),
        user_outputs: vec![InOut {
            asset_id: usdt_asset,
            value: 200000000000,
        }],
        deduct_fee: Some(0),
    })
    .unwrap();
    // panic!("{_res:#?}");
}

#[test]
fn deduct_fee_part_amount() {
    let network = Network::Liquid;
    let policy_asset = network.d().policy_asset.asset_id();
    let usdt_asset = network.d().known_assets.usdt.asset_id();

    let _res = try_coin_select(Args {
        multisig_wallet: true,
        policy_asset,
        fee_asset: usdt_asset,
        price: 12345.0,
        fixed_fee: Amount::from_bitcoin(0.04).to_sat() as u64,
        use_all_utxos: false,
        wallet_utxos: vec![
            InOut {
                asset_id: usdt_asset,
                value: 200000000000,
            },
            InOut {
                asset_id: usdt_asset,
                value: 4534123123,
            },
            InOut {
                asset_id: usdt_asset,
                value: 61231231,
            },
            InOut {
                asset_id: usdt_asset,
                value: 6456464,
            },
        ],
        server_utxos: [100, 150, 200, 250]
            .iter()
            .map(|value| InOut {
                asset_id: policy_asset,
                value: *value,
            })
            .collect(),
        user_outputs: vec![
            InOut {
                asset_id: usdt_asset,
                value: 3000000000,
            },
            InOut {
                asset_id: usdt_asset,
                value: 4000000000,
            },
        ],
        deduct_fee: Some(0),
    })
    .unwrap();
    // panic!("{_res:#?}");
}

#[test]
fn use_all_inputs() {
    let network = Network::Liquid;
    let policy_asset = network.d().policy_asset.asset_id();
    let usdt_asset = network.d().known_assets.usdt.asset_id();
    let eurx_asset = network.d().known_assets.eurx.asset_id();
    let depix_asset = network.d().known_assets.depix.asset_id();

    let _res = try_coin_select(Args {
        multisig_wallet: true,
        policy_asset,
        fee_asset: usdt_asset,
        price: 55000.0,
        fixed_fee: Amount::from_bitcoin(0.04).to_sat() as u64,
        use_all_utxos: true,
        wallet_utxos: vec![
            InOut {
                asset_id: usdt_asset,
                value: 200000000000,
            },
            InOut {
                asset_id: eurx_asset,
                value: 300000000000,
            },
            InOut {
                asset_id: depix_asset,
                value: 400000000000,
            },
        ],
        server_utxos: [100, 150, 200, 250]
            .iter()
            .map(|value| InOut {
                asset_id: policy_asset,
                value: *value,
            })
            .collect(),
        user_outputs: vec![InOut {
            asset_id: eurx_asset,
            value: 50000000000,
        }],
        deduct_fee: None,
    })
    .unwrap();
    // panic!("{_res:#?}");
}
