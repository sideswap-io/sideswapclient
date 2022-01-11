pub fn get_network(env: sideswap_common::env::Env) -> gdk_common::Network {
    let data = env.data();
    gdk_common::Network {
        name: data.name.to_owned(),
        network: data.electum_network.to_owned(),
        development: data.development,
        liquid: true,
        mainnet: data.mainnet,
        tx_explorer_url: data.tx_explorer_url.to_owned(),
        address_explorer_url: data.address_explorer_url.to_owned(),
        electrum_tls: Some(data.electrum_tls),
        electrum_url: Some(data.electrum_url.to_owned()),
        validate_domain: Some(data.mainnet),
        policy_asset: Some(data.policy_asset.to_owned()),
        sync_interval: None,
        ct_bits: Some(52),
        ct_exponent: Some(0),
        ct_min_value: None,
        spv_enabled: Some(false),
        asset_registry_url: Some(data.asset_registry_url.to_owned()),
        asset_registry_onion_url: None,
        spv_multi: Some(false),
        spv_servers: None,
        taproot_enabled_at: Some(0xffffffff),
    }
}
