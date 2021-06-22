#[derive(
    Eq,
    PartialEq,
    Debug,
    derive_more::Add,
    derive_more::Sub,
    derive_more::Display,
    Copy,
    Clone,
    PartialOrd,
    Ord,
    Default,
    serde::Deserialize,
    serde::Serialize,
)]
pub struct Amount(pub i64);

const COIN: i64 = 100_000_000;

pub const ELEMENTS_CONFIRMED_BLOCKS: i32 = 2;
pub const BITCOIN_CONFIRMED_BLOCKS: i32 = 6;

impl Amount {
    pub fn from_sat(value: i64) -> Self {
        Amount(value)
    }

    pub fn from_rpc(value: &serde_json::Number) -> Self {
        let amount =
            bitcoin::SignedAmount::from_str_in(&value.to_string(), bitcoin::Denomination::Bitcoin)
                .expect("invalid bitcoin value");
        Amount::from_sat(amount.as_sat())
    }

    pub fn from_bitcoin(value: f64) -> Self {
        Amount((value * COIN as f64).round() as i64)
    }

    pub fn to_sat(&self) -> i64 {
        self.0
    }

    pub fn to_bitcoin(&self) -> f64 {
        (self.0 as f64) / (COIN as f64)
    }

    pub fn to_rpc(&self) -> serde_json::Value {
        serde_json::Value::String(
            bitcoin::SignedAmount::from_sat(self.0).to_string_in(bitcoin::Denomination::Bitcoin),
        )
    }
}

#[derive(
    Hash, Eq, PartialEq, Clone, Ord, PartialOrd, Debug, serde::Serialize, serde::Deserialize,
)]
pub struct TxOut {
    pub txid: String,
    pub vout: i32,
}

impl TxOut {
    pub fn new(txid: String, vout: i32) -> TxOut {
        TxOut { txid, vout }
    }
}

pub type TxOuts = Vec<TxOut>;

pub fn select_utxo(mut inputs: Vec<i64>, amount: i64) -> Vec<i64> {
    assert!(amount > 0);
    let mut amount_remain = amount;
    let mut result = Vec::new();
    while amount_remain > 0 {
        inputs.sort_by_key(|value| -(value - amount_remain).abs());
        let selected = inputs.pop().expect("not enough available inputs");
        result.push(selected);
        amount_remain -= selected;
    }
    result.sort_unstable();
    result.reverse();
    while result.iter().sum::<i64>() - result.last().unwrap() > amount {
        result.pop();
    }
    result
}

#[derive(Debug, Eq, PartialEq, Copy, Clone, serde::Serialize, serde::Deserialize)]
pub enum Env {
    Prod,
    Staging,
    Regtest,
    Local,
}

impl Env {
    pub fn data(&self) -> &'static EnvData {
        env_data(*self)
    }

    pub fn is_mainnet(&self) -> bool {
        self.data().mainnet
    }
}

pub struct EnvData {
    pub host: &'static str,
    pub port: u16,
    pub use_tls: bool,
    pub name: &'static str,
    pub mainnet: bool,
    pub bitcoin_asset_id: &'static str,
}

const ENV_PROD: EnvData = EnvData {
    host: "api.sideswap.io",
    port: 443,
    use_tls: true,
    name: "prod",
    mainnet: true,
    bitcoin_asset_id: "6f0279e9ed041c3d710a9f57d0c02928416460c4b722ae3457a11eec381c526d",
};

const ENV_STAGING: EnvData = EnvData {
    host: "api-test.sideswap.io",
    port: 443,
    use_tls: true,
    name: "staging",
    mainnet: true,
    bitcoin_asset_id: "6f0279e9ed041c3d710a9f57d0c02928416460c4b722ae3457a11eec381c526d",
};

const ENV_REGTEST: EnvData = EnvData {
    host: "api-regtest.sideswap.io",
    port: 443,
    use_tls: true,
    name: "regtest",
    mainnet: false,
    bitcoin_asset_id: "2e16b12daf1244332a438e829ca7ce209195f8e1c54199770cd8b327710a8ab2",
};

const ENV_LOCAL: EnvData = EnvData {
    host: "192.168.71.50",
    port: 4001,
    use_tls: false,
    name: "local",
    mainnet: false,
    bitcoin_asset_id: "2684bbac0fa7ad544ec8eee43c35156346e5d641d24a4b9d5d8f183e3f2d8fb9",
};

fn known_asset_id(mainnet: bool, ticker: &str) -> Option<&'static str> {
    match (mainnet, ticker) {
        // Liquid
        (true, sideswap_api::TICKER_LBTC) => {
            Some("6f0279e9ed041c3d710a9f57d0c02928416460c4b722ae3457a11eec381c526d")
        }
        (true, sideswap_api::TICKER_USDT) => {
            Some("ce091c998b83c78bb71a632313ba3760f1763d9cfcffae02258ffa9865a37bd2")
        }
        _ => None,
    }
}

pub fn env_data(env: Env) -> &'static EnvData {
    match env {
        Env::Prod => &ENV_PROD,
        Env::Staging => &ENV_STAGING,
        Env::Regtest => &ENV_REGTEST,
        Env::Local => &ENV_LOCAL,
    }
}

// Check that known asset IDs are valid
pub fn check_assets(env: Env, assets: &sideswap_api::Assets) {
    let mainnet = env_data(env).mainnet;
    if !mainnet {
        return;
    }

    let bitcoin_asset = assets
        .iter()
        .find(|asset| asset.ticker.0 == sideswap_api::TICKER_LBTC)
        .expect("can't find bitcoin ticker");
    assert!(
        bitcoin_asset.asset_id.0
            == known_asset_id(mainnet, &sideswap_api::TICKER_LBTC).expect("can't find L-BTC")
    );

    assets
        .iter()
        .find(|asset| asset.ticker.0 == sideswap_api::TICKER_USDT)
        .map(|asset| {
            assert!(
                asset.asset_id.0
                    == known_asset_id(mainnet, &sideswap_api::TICKER_USDT)
                        .expect("can't find L-BTC")
            );
        });
}

const VSIZE_FIXED: i64 = 23;
const VSIZE_VIN: i64 = 108;
const VSIZE_VOUT: i64 = 1192;

pub fn expected_network_fee(vin_count: i32, vout_count: i32, fee_rate: f64) -> Amount {
    let expected_vsize =
        VSIZE_FIXED + vin_count as i64 * VSIZE_VIN + vout_count as i64 * VSIZE_VOUT;
    Amount::from_bitcoin(expected_vsize as f64 * fee_rate / 1000.0 * 1.075)
}

pub fn timestamp_now() -> i64 {
    std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap()
        .as_millis() as i64
}

pub const MIN_BITCOIN_AMOUNT: Amount = Amount(2000);
pub const MIN_SERVER_FEE: Amount = Amount(500);
pub const SERVER_FEE_RATE: f64 = 0.001;

pub fn get_server_fee(bitcoin_amount: Amount) -> Amount {
    let server_fee = Amount::from_bitcoin(bitcoin_amount.to_bitcoin() * SERVER_FEE_RATE);
    std::cmp::max(server_fee, MIN_SERVER_FEE)
}

pub fn asset_scale(asset_precision: u8) -> f64 {
    10i64.checked_pow(asset_precision as u32).unwrap() as f64
}

pub fn asset_amount(bitcoin_amount: i64, price: f64, asset_precision: u8) -> i64 {
    let scale = asset_scale(asset_precision);
    let asset_amount = Amount::from_sat(bitcoin_amount).to_bitcoin() * price * scale;
    f64::round(asset_amount) as i64
}

pub fn asset_float_amount(asset_amount: i64, asset_precision: u8) -> f64 {
    asset_amount as f64 / asset_scale(asset_precision)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_select_utxo() {
        assert_eq!(select_utxo(vec![10], 10), vec![10]);
        assert_eq!(select_utxo(vec![15], 10), vec![15]);
        assert_eq!(select_utxo(vec![15, 10], 25), vec![15, 10]);
        assert_eq!(select_utxo(vec![5000, 10, 5], 15), vec![10, 5]);
        assert_eq!(select_utxo(vec![5000, 10, 5], 16), vec![5000]);
        assert_eq!(select_utxo(vec![1000, 100, 10, 1], 101), vec![100, 1]);
        assert_eq!(select_utxo(vec![1000, 100, 10, 1], 102), vec![100, 10]);
    }

    #[test]
    fn test_asset_amount() {
        assert_eq!(
            asset_amount(Amount::from_bitcoin(1.0).to_sat(), 12345.67, 8),
            1234567000000
        );
        assert_eq!(
            asset_amount(Amount::from_bitcoin(1.0).to_sat(), 12345.67, 2),
            1234567
        );
        assert_eq!(
            asset_amount(Amount::from_bitcoin(1.0).to_sat(), 12345.67, 0),
            12346
        );
    }
}
