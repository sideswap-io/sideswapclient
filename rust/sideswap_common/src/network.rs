use crate::const_asset_id::ConstAssetId as C;

#[derive(Debug, Eq, PartialEq, Copy, Clone, serde::Serialize, serde::Deserialize)]
pub enum Network {
    Liquid,
    LiquidTestnet,
}

#[derive(Copy, Clone)]
pub struct KnownAssetIds {
    pub usdt: C,
    pub eurx: C,
    pub mex: C,
    pub depix: C,
}

pub struct NetworkData {
    pub name: &'static str,
    pub elements_params: &'static elements::address::AddressParams,
    pub bitcoin_network: bitcoin::Network,
    pub single_sig_account_path: [u32; 3],
    pub electrum_url: &'static str,
    pub electrum_tls: bool,
    pub asset_registry_url: &'static str,
    pub tx_explorer_url: &'static str,
    pub address_explorer_url: &'static str,
    pub policy_asset: C,

    // Green multi-sig backend
    pub service_pubkey: &'static str,
    pub service_chain_code: &'static str,

    pub known_assets: KnownAssetIds,
}

pub const NETWORK_LIQUID: NetworkData = NetworkData {
    name: "Liquid",
    elements_params: &elements::address::AddressParams::LIQUID,
    bitcoin_network: bitcoin::Network::Bitcoin,
    single_sig_account_path: [0x80000031, 0x800006F0, 0x80000000],
    electrum_url: "blockstream.info:995",
    electrum_tls: true,
    asset_registry_url: "https://assets.blockstream.info",
    tx_explorer_url: "https://blockstream.info/liquid/tx/",
    address_explorer_url: "https://blockstream.info/address/",
    policy_asset: C::new("6f0279e9ed041c3d710a9f57d0c02928416460c4b722ae3457a11eec381c526d"),

    service_chain_code: "02721cc509aa0c2f4a90628e9da0391b196abeabc6393ed4789dd6222c43c489",
    service_pubkey: "02c408c3bb8a3d526103fb93246f54897bdd997904d3e18295b49a26965cb41b7f",

    known_assets: KnownAssetIds {
        usdt: C::new("ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2"),
        eurx: C::new("18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec"),
        mex: C::new("26ac924263ba547b706251635550a8649545ee5c074fe5db8d7140557baaf32e"),
        depix: C::new("02f22f8d9c76ab41661a2729e4752e2c5d1a263012141b86ea98af5472df5189"),
    },
};

pub const NETWORK_LIQUID_TESTNET: NetworkData = NetworkData {
    name: "LiquidTestnet",
    elements_params: &elements::address::AddressParams::LIQUID_TESTNET,
    bitcoin_network: bitcoin::Network::Testnet,
    single_sig_account_path: [0x80000031, 0x80000001, 0x80000000],
    electrum_url: "blockstream.info:465",
    electrum_tls: true,
    asset_registry_url: "https://assets-testnet.blockstream.info",
    tx_explorer_url: "https://blockstream.info/liquidtestnet/liquidtestnet/tx/",
    address_explorer_url: "https://blockstream.info/liquidtestnet/address/",
    policy_asset: C::new("144c654344aa716d6f3abcc1ca90e5641e4e2a7f633bc09fe3baf64585819a49"),

    service_chain_code: "c660eec6d9c536f4121854146da22e02d4c91d72af004d41729b9a592f0788e5",
    service_pubkey: "02c47d84a5b256ee3c29df89642d14b6ed73d17a2b8af0aca18f6f1900f1633533",

    known_assets: KnownAssetIds {
        usdt: C::new("b612eb46313a2cd6ebabd8b7a8eed5696e29898b87a43bff41c94f51acef9d73"),
        eurx: C::new("58af36e1b529b42f3e4ccce812924380058cae18b2ad26c89805813a9db25980"),
        mex: C::new("485ff8a902ad063bd8886ef8cfc0d22a068d14dcbe6ae06cf3f904dc581fbd2b"),
        depix: C::new("a5de979bc31dc731fa94b3661ae19c1e20cd067642c69798cad9011094a26f60"),
    },
};

impl Network {
    pub fn d(&self) -> &'static NetworkData {
        match *self {
            Network::Liquid => &NETWORK_LIQUID,
            Network::LiquidTestnet => &NETWORK_LIQUID_TESTNET,
        }
    }
}
