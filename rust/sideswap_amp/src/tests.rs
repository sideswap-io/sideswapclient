use std::str::FromStr;

use super::*;

#[test]
fn derive_address() {
    let mnemonic = bip39::Mnemonic::from_str(
        "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about",
    )
    .unwrap();
    let seed = mnemonic.to_seed("");
    let master_blinding_key = MasterBlindingKey::from_seed(&seed);
    let master_key = Xpriv::new_master(bitcoin::Network::Bitcoin, &seed).unwrap();

    let subaccount = 1;
    let pointer = 62;
    let user_xpriv = derive_user_xpriv(&master_key, subaccount);
    let service_xpub = Xpub::from_str("xpub7ByyA3Xt3nTXThVAhxvKN9GaKomxebSyPCg8ePH4TEtFap46GRwajHD2AQuTLDuG3UAw2cHgbU7JWQYJ52XPB7PsjAnHzzX1HhEmULgEo7q").unwrap();
    let address = get_address(
        &user_xpriv,
        &service_xpub,
        &master_blinding_key,
        Network::Liquid,
        pointer,
    );

    assert_eq!(
        address.to_string(),
        "VJLEdPSgEtV1wSZGjdH1Hqb8AjyVRzNGnqq6fr3ZrRUAzhG2wxztAq1WN5d353GXFEGby14k9BzWTvBU"
    );
}

#[test]
fn test_challenge_address() {
    let mnemonic = bip39::Mnemonic::from_str(
        "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about",
    )
    .unwrap();
    let seed = mnemonic.to_seed("");
    let master_key = Xpriv::new_master(bitcoin::Network::Testnet, &seed).unwrap();

    let challenge_address = get_challenge_address(&master_key, Network::LiquidTestnet);

    assert_eq!(
        challenge_address.to_string(),
        "FfisAwyVKYxYrzzm6v5BiTcjhAi8fKm7Fx"
    );
}

#[test]
fn test_xpub() {
    let xpub = Xpub {
        network: bitcoin::Network::Testnet,
        depth: 0,
        parent_fingerprint: Default::default(),
        child_number: 0.into(),
        public_key: "02c47d84a5b256ee3c29df89642d14b6ed73d17a2b8af0aca18f6f1900f1633533"
            .parse()
            .unwrap(),
        chain_code: "c660eec6d9c536f4121854146da22e02d4c91d72af004d41729b9a592f0788e5"
            .parse()
            .unwrap(),
    };
    assert_eq!(xpub.to_string(), "tpubD6NzVbkrYhZ4YKB74cMgKEpwByD7UWLXt2MxRdwwaQtgrw6E3YPQgSRkaxMWnpDXKtX5LvRmY5mT8FkzCtJcEQ1YhN1o8CU2S5gy9TDFc24");
}

#[test]
fn test_gait_path() {
    let xpub = derive_service_xpub(Network::LiquidTestnet, "7f112a1838c8af4d4fea8a2c840ae7faa52b91a8650e040bd7d76c434d3b36243b3b34b1c4d9c0eadd406d1f32834e84a9c7d90adc811f21393e2deb8c587ed8", 1).unwrap();
    assert_eq!(xpub.to_string(), "tpubECMbgHMZm4QyjyuVHUU8x8Jdg68N8oaewDZsrtxF9A6SBuMEK4AM6KHosDvnAW6DCd4N8PqGk2mkJ2yEKNryUFGESXguefdkMi4WEFgUpmb");
}

#[test]
fn test_derive_gait_path() {
    let mnemonic = bip39::Mnemonic::from_str(
        "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about",
    )
    .unwrap();
    let seed = mnemonic.to_seed("");
    let master_key = Xpriv::new_master(bitcoin::Network::Bitcoin, &seed).unwrap();
    let ga_path = derive_ga_path(&master_key);
    assert_eq!(hex::encode(ga_path), "7f112a1838c8af4d4fea8a2c840ae7faa52b91a8650e040bd7d76c434d3b36243b3b34b1c4d9c0eadd406d1f32834e84a9c7d90adc811f21393e2deb8c587ed8");
}
