use crate::network::Network;

use super::*;

fn run(mut args: Args) {
    for multisig_wallet in [false, true] {
        for use_all_utxos in [false, true] {
            args.multisig_wallet = multisig_wallet;
            args.use_all_utxos = use_all_utxos;
            let _res = try_coin_select(args.clone()).unwrap();
            // panic!("{_res:#?}");
        }
    }
}

#[test]
fn basic() {
    let network = Network::Liquid;
    let policy_asset = network.d().policy_asset.asset_id();

    run(Args {
        multisig_wallet: false,
        policy_asset,
        use_all_utxos: false,
        wallet_utxos: vec![InOut {
            asset_id: policy_asset,
            value: 500000000000,
        }],
        user_outputs: vec![InOut {
            asset_id: policy_asset,
            value: 10000000000,
        }],
        deduct_fee: None,
    });
}

#[test]
fn without_change() {
    let network = Network::Liquid;
    let policy_asset = network.d().policy_asset.asset_id();

    run(Args {
        multisig_wallet: false,
        policy_asset,
        use_all_utxos: false,
        wallet_utxos: vec![
            InOut {
                asset_id: policy_asset,
                value: 100000,
            },
            InOut {
                asset_id: policy_asset,
                value: 200000,
            },
            InOut {
                asset_id: policy_asset,
                value: 300000,
            },
        ],
        user_outputs: vec![InOut {
            asset_id: policy_asset,
            value: 199750,
        }],
        deduct_fee: None,
    });
}

#[test]
fn send_asset() {
    let network = Network::Liquid;
    let policy_asset = network.d().policy_asset.asset_id();
    let usdt_asset = network.d().known_assets.usdt.asset_id();

    run(Args {
        multisig_wallet: false,
        policy_asset,
        use_all_utxos: false,
        wallet_utxos: vec![
            InOut {
                asset_id: policy_asset,
                value: 100,
            },
            InOut {
                asset_id: policy_asset,
                value: 150,
            },
            InOut {
                asset_id: policy_asset,
                value: 200,
            },
            InOut {
                asset_id: policy_asset,
                value: 250,
            },
            InOut {
                asset_id: usdt_asset,
                value: 10000000,
            },
            InOut {
                asset_id: usdt_asset,
                value: 20000000,
            },
            InOut {
                asset_id: usdt_asset,
                value: 30000000,
            },
        ],
        user_outputs: vec![InOut {
            asset_id: usdt_asset,
            value: 50000000,
        }],
        deduct_fee: None,
    });
}

#[test]
fn use_all_inputs() {
    let network = Network::Liquid;
    let policy_asset = network.d().policy_asset.asset_id();
    let usdt_asset = network.d().known_assets.usdt.asset_id();
    let eurx_asset = network.d().known_assets.eurx.asset_id();
    let depix_asset = network.d().known_assets.depix.asset_id();

    run(Args {
        multisig_wallet: false,
        policy_asset,
        use_all_utxos: true,
        wallet_utxos: vec![
            InOut {
                asset_id: policy_asset,
                value: 2000,
            },
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
        user_outputs: vec![InOut {
            asset_id: eurx_asset,
            value: 50000000000,
        }],
        deduct_fee: None,
    });
}

#[test]
fn send_all_bitcoins() {
    let network = Network::Liquid;
    let policy_asset = network.d().policy_asset.asset_id();

    run(Args {
        multisig_wallet: false,
        policy_asset,
        use_all_utxos: false,
        wallet_utxos: vec![
            InOut {
                asset_id: policy_asset,
                value: 20000,
            },
            InOut {
                asset_id: policy_asset,
                value: 30000,
            },
            InOut {
                asset_id: policy_asset,
                value: 50000,
            },
        ],
        user_outputs: vec![InOut {
            asset_id: policy_asset,
            value: 100000,
        }],
        deduct_fee: Some(0),
    });
}

#[test]
fn deduct_fee() {
    let network = Network::Liquid;
    let policy_asset = network.d().policy_asset.asset_id();

    run(Args {
        multisig_wallet: false,
        policy_asset,
        use_all_utxos: true,
        wallet_utxos: vec![
            InOut {
                asset_id: policy_asset,
                value: 30000,
            },
            InOut {
                asset_id: policy_asset,
                value: 30000,
            },
            InOut {
                asset_id: policy_asset,
                value: 50000,
            },
        ],
        user_outputs: vec![
            InOut {
                asset_id: policy_asset,
                value: 10000,
            },
            InOut {
                asset_id: policy_asset,
                value: 10000,
            },
        ],
        deduct_fee: Some(1),
    });
}
