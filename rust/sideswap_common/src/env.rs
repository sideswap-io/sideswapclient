use std::str::FromStr;

use elements::AssetId;

#[derive(Debug, Eq, PartialEq, Copy, Clone, serde::Serialize, serde::Deserialize)]
pub enum Env {
    Prod,
    Staging,
    Testnet,
    Regtest,
    Local,
    LocalLiquid,
    LocalTestnet,
}

#[derive(Debug, Eq, PartialEq, Copy, Clone, serde::Serialize, serde::Deserialize)]
pub enum Network {
    Mainnet,
    Testnet,
    Regtest,
    Local,
}

impl Env {
    pub fn data(&self) -> &'static EnvData {
        match *self {
            Env::Prod => &ENV_PROD,
            Env::Staging => &ENV_STAGING,
            Env::Testnet => &ENV_TESTNET,
            Env::Regtest => &ENV_REGTEST,
            Env::Local => &ENV_LOCAL,
            Env::LocalLiquid => &ENV_LOCAL_LIQUID,
            Env::LocalTestnet => &ENV_LOCAL_TESTNET,
        }
    }

    pub fn elements_params(&self) -> &'static elements::AddressParams {
        match *self {
            Env::Prod | Env::Staging | Env::LocalLiquid => {
                &elements::address::AddressParams::LIQUID
            }
            Env::Testnet | Env::LocalTestnet => &LIQUID_TESTNET,
            Env::Regtest | Env::Local => &elements::address::AddressParams::ELEMENTS,
        }
    }
}

impl EnvData {
    pub fn base_server_url(&self) -> String {
        let protocol = if self.use_tls { "https" } else { "http" };
        format!("{}://{}:{}", protocol, self.host, self.port)
    }
}

pub struct KnownAssetIds {
    pub bitcoin: AssetId,
    pub usdt: AssetId,
    pub eurx: AssetId,
    pub mex: AssetId,
    pub depix: AssetId,
}

impl Network {
    pub fn elements_params(&self) -> &'static elements::AddressParams {
        match *self {
            Network::Mainnet => &elements::address::AddressParams::LIQUID,
            Network::Testnet => &elements::address::AddressParams::LIQUID_TESTNET,
            Network::Regtest | Network::Local => &elements::address::AddressParams::ELEMENTS,
        }
    }

    pub fn lbtc_asset_id(&self) -> &'static str {
        match self {
            Network::Mainnet => "6f0279e9ed041c3d710a9f57d0c02928416460c4b722ae3457a11eec381c526d",
            Network::Testnet => "144c654344aa716d6f3abcc1ca90e5641e4e2a7f633bc09fe3baf64585819a49",
            Network::Regtest => "",
            Network::Local => "",
        }
    }

    pub fn usdt_asset_id(&self) -> &'static str {
        match self {
            Network::Mainnet => "ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2",
            Network::Testnet => "b612eb46313a2cd6ebabd8b7a8eed5696e29898b87a43bff41c94f51acef9d73",
            Network::Regtest => "a0682b2b1493596f93cea5f4582df6a900b5e1a491d5ac39dea4bb39d0a45bbf",
            Network::Local => "ac1775bb717c60a9a4adc3587bd166350e016938b1e34f4b8e2e490dfd03817a",
        }
    }

    pub fn eurx_asset_id(&self) -> &'static str {
        match self {
            Network::Mainnet => "18729918ab4bca843656f08d4dd877bed6641fbd596a0a963abbf199cfeb3cec",
            Network::Testnet => "58af36e1b529b42f3e4ccce812924380058cae18b2ad26c89805813a9db25980",
            Network::Regtest => "6d15498e26ec311dc6e9962dd05f6e7024c7fe4989cc09d426822ea540f048a2",
            Network::Local => "92e71c513e2d1b2e421200beb1dabb231c12b5d2c53438648e09859909c0f9b7",
        }
    }

    pub fn mex_asset_id(&self) -> &'static str {
        match self {
            Network::Mainnet => "26ac924263ba547b706251635550a8649545ee5c074fe5db8d7140557baaf32e",
            Network::Testnet => "485ff8a902ad063bd8886ef8cfc0d22a068d14dcbe6ae06cf3f904dc581fbd2b",
            Network::Regtest => unimplemented!(),
            Network::Local => unimplemented!(),
        }
    }

    pub fn depix_asset_id(&self) -> &'static str {
        match self {
            Network::Mainnet => "02f22f8d9c76ab41661a2729e4752e2c5d1a263012141b86ea98af5472df5189",
            Network::Testnet => "bee14e1514d638afa39fdc954ec4534ccadeb4e2199c38c5a9017952e0b8e214",
            Network::Regtest => unimplemented!(),
            Network::Local => unimplemented!(),
        }
    }

    pub fn bitcoin_network(&self) -> bitcoin::Network {
        match self {
            Network::Mainnet => bitcoin::Network::Bitcoin,
            Network::Testnet => bitcoin::Network::Testnet,
            Network::Regtest | Network::Local => bitcoin::Network::Regtest,
        }
    }

    pub fn single_sig_account_path(&self) -> [u32; 3] {
        match self {
            Network::Mainnet => [0x80000031, 0x800006F0, 0x80000000],
            Network::Testnet | Network::Regtest | Network::Local => {
                [0x80000031, 0x80000001, 0x80000000]
            }
        }
    }

    pub fn known_assets(&self) -> KnownAssetIds {
        KnownAssetIds {
            bitcoin: AssetId::from_str(self.lbtc_asset_id()).unwrap(),
            usdt: AssetId::from_str(self.usdt_asset_id()).unwrap(),
            eurx: AssetId::from_str(self.eurx_asset_id()).unwrap(),
            mex: AssetId::from_str(self.mex_asset_id()).unwrap(),
            depix: AssetId::from_str(self.depix_asset_id()).unwrap(),
        }
    }
}

pub const LIQUID_TESTNET: elements::AddressParams = elements::AddressParams {
    p2pkh_prefix: 36,
    p2sh_prefix: 19,
    blinded_prefix: 23,
    bech_hrp: "tex",
    blech_hrp: "tlq",
};

pub const LIQUID_TESTNET_PSET: elements::AddressParams = elements::AddressParams {
    p2pkh_prefix: 36,
    p2sh_prefix: 19,
    blinded_prefix: 23,
    bech_hrp: "tex",
    blech_hrp: "tlq",
};

pub struct EnvData {
    pub host: &'static str,
    pub port: u16,
    pub use_tls: bool,
    pub name: &'static str,
    pub mainnet: bool,
    pub development: bool,
    pub policy_asset: &'static str,
    pub electum_network: &'static str,
    pub electrum_url: &'static str,
    pub electrum_tls: bool,
    pub asset_registry_url: &'static str,
    pub tx_explorer_url: &'static str,
    pub address_explorer_url: &'static str,
    pub network: Network,
}

const ENV_PROD: EnvData = EnvData {
    host: "api.sideswap.io",
    port: 443,
    use_tls: true,
    name: "prod",
    mainnet: true,
    development: false,
    policy_asset: "6f0279e9ed041c3d710a9f57d0c02928416460c4b722ae3457a11eec381c526d",
    electum_network: "liquid-electrum-mainnet",
    electrum_url: "blockstream.info:995",
    electrum_tls: true,
    asset_registry_url: "https://assets.blockstream.info",
    tx_explorer_url: "https://blockstream.info/liquid/tx/",
    address_explorer_url: "https://blockstream.info/address/",
    network: Network::Mainnet,
};

const ENV_STAGING: EnvData = EnvData {
    host: "api-test.sideswap.io",
    port: 443,
    use_tls: true,
    name: "staging",
    mainnet: true,
    development: true,
    policy_asset: "6f0279e9ed041c3d710a9f57d0c02928416460c4b722ae3457a11eec381c526d",
    electum_network: "liquid-electrum-mainnet",
    electrum_url: "blockstream.info:995",
    electrum_tls: true,
    asset_registry_url: "https://assets.blockstream.info",
    tx_explorer_url: "https://blockstream.info/liquid/tx/",
    address_explorer_url: "https://blockstream.info/address/",
    network: Network::Mainnet,
};

const ENV_TESTNET: EnvData = EnvData {
    host: "api-testnet.sideswap.io",
    port: 443,
    use_tls: true,
    name: "testnet",
    mainnet: false,
    development: false,
    policy_asset: "144c654344aa716d6f3abcc1ca90e5641e4e2a7f633bc09fe3baf64585819a49",
    electum_network: "electrum-testnet-liquid",
    electrum_url: "blockstream.info:465",
    electrum_tls: true,
    asset_registry_url: "https://assets-testnet.blockstream.info",
    tx_explorer_url: "https://blockstream.info/liquidtestnet/liquidtestnet/tx/",
    address_explorer_url: "https://blockstream.info/liquidtestnet/address/",
    network: Network::Testnet,
};

const ENV_REGTEST: EnvData = EnvData {
    host: "api-regtest.sideswap.io",
    port: 443,
    use_tls: true,
    name: "regtest",
    mainnet: false,
    development: true,
    policy_asset: "2e16b12daf1244332a438e829ca7ce209195f8e1c54199770cd8b327710a8ab2",
    electum_network: "electrum-regtest-liquid",
    electrum_url: "api.sideswap.io:10402",
    electrum_tls: false,
    asset_registry_url: "https://staging.sideswap.io/assets",
    tx_explorer_url: "",
    address_explorer_url: "",
    network: Network::Regtest,
};

const ENV_LOCAL: EnvData = EnvData {
    host: "192.168.71.50",
    port: 4001,
    use_tls: false,
    name: "local",
    mainnet: false,
    development: true,
    policy_asset: "2684bbac0fa7ad544ec8eee43c35156346e5d641d24a4b9d5d8f183e3f2d8fb9",
    electum_network: "electrum-local-liquid",
    electrum_url: "192.168.71.50:51401",
    electrum_tls: false,
    asset_registry_url: "http://192.168.71.50/assets",
    tx_explorer_url: "",
    address_explorer_url: "",
    network: Network::Local,
};

const ENV_LOCAL_LIQUID: EnvData = EnvData {
    host: "192.168.71.50",
    port: 5001,
    use_tls: false,
    name: "local_liquid",
    mainnet: true,
    development: false,
    policy_asset: "6f0279e9ed041c3d710a9f57d0c02928416460c4b722ae3457a11eec381c526d",
    electum_network: "liquid-electrum-mainnet",
    electrum_url: "blockstream.info:995",
    electrum_tls: true,
    asset_registry_url: "https://assets.blockstream.info",
    tx_explorer_url: "https://blockstream.info/liquid/tx/",
    address_explorer_url: "https://blockstream.info/address/",
    network: Network::Mainnet,
};

const ENV_LOCAL_TESTNET: EnvData = EnvData {
    host: "192.168.71.50",
    port: 6001,
    use_tls: false,
    name: "local_testnet",
    mainnet: false,
    development: false,
    policy_asset: "144c654344aa716d6f3abcc1ca90e5641e4e2a7f633bc09fe3baf64585819a49",
    electum_network: "electrum-testnet-liquid",
    electrum_url: "blockstream.info:465",
    electrum_tls: true,
    asset_registry_url: "https://assets-testnet.blockstream.info",
    tx_explorer_url: "https://blockstream.info/liquidtestnet/liquidtestnet/tx/",
    address_explorer_url: "https://blockstream.info/liquidtestnet/address/",
    network: Network::Testnet,
};
