use rand::Rng;

use crate::{network::Network, test_utils::test_rng};

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
    let usdt_asset = network.d().known_assets.USDt.asset_id();

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
    let usdt_asset = network.d().known_assets.USDt.asset_id();
    let eurx_asset = network.d().known_assets.EURx.asset_id();
    let depix_asset = network.d().known_assets.DePix.asset_id();

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

#[test]
fn coin_selection_bug() {
    let mut rng = test_rng();

    for _ in 0..1000 {
        let network = Network::Liquid;
        let policy_asset = network.d().policy_asset.asset_id();

        let target = 100000;
        let mut wallet_utxos = Vec::new();
        let mut sum: u64 = 0;
        while sum < target {
            let new = rng.gen_range(1..(2 * target));
            sum += new;
            wallet_utxos.push(InOut {
                asset_id: policy_asset,
                value: new,
            });
        }

        run(Args {
            multisig_wallet: false,
            policy_asset,
            use_all_utxos: false,
            wallet_utxos,
            user_outputs: vec![InOut {
                asset_id: policy_asset,
                value: 100000,
            }],
            deduct_fee: Some(0),
        });
    }
}

#[test]
#[ignore = "not fixed yet"]
fn peg_out_max_amount() {
    let network = Network::Liquid;
    let policy_asset = network.d().policy_asset.asset_id();

    let _res = try_coin_select(Args {
        multisig_wallet: false,
        policy_asset,
        use_all_utxos: false,
        wallet_utxos: vec![InOut {
            asset_id: policy_asset,
            value: 1000000,
        }],
        user_outputs: vec![InOut {
            asset_id: policy_asset,
            value: 999978,
        }],
        deduct_fee: None,
    })
    .unwrap();
}
