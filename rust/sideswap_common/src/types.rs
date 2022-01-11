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

pub const COIN: i64 = 100_000_000;

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
    pub txid: sideswap_api::Txid,
    pub vout: u32,
}

impl TxOut {
    pub fn new(txid: sideswap_api::Txid, vout: u32) -> TxOut {
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

pub fn select_utxo_values<T>(mut inputs: Vec<(i64, T)>, amount: i64) -> Vec<T> {
    let input_amounts = inputs.iter().map(|(amount, _)| amount).cloned().collect();
    let selected = select_utxo(input_amounts, amount);
    let mut result = Vec::new();
    for selected_amount in selected {
        let index = inputs
            .iter()
            .position(|(amount, _)| *amount == selected_amount)
            .unwrap();
        let value = inputs.swap_remove(index).1;
        result.push(value);
    }
    result
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

pub fn get_max_bitcoin_amount(bitcoin_balance: Amount) -> Result<Amount, anyhow::Error> {
    assert!(bitcoin_balance.to_sat() >= 0);
    ensure!(
        bitcoin_balance >= MIN_BITCOIN_AMOUNT + MIN_SERVER_FEE,
        "balance is too low"
    );
    let network_fee_scaled =
        Amount::from_bitcoin(bitcoin_balance.to_bitcoin() * (1. - 1. / (1. + SERVER_FEE_RATE)));
    let network_fee = Amount::max(network_fee_scaled, MIN_SERVER_FEE);
    let bitcoin_amount = bitcoin_balance - network_fee;
    let actual_server_fee = get_server_fee(bitcoin_amount);
    if bitcoin_balance < bitcoin_amount + actual_server_fee {
        Ok(bitcoin_amount - Amount::from_sat(1))
    } else {
        Ok(bitcoin_amount)
    }
}

pub fn asset_scale(asset_precision: u8) -> f64 {
    10i64.checked_pow(asset_precision as u32).unwrap() as f64
}

pub fn asset_amount(
    bitcoin_amount: i64,
    price: f64,
    asset_precision: u8,
    market: sideswap_api::MarketType,
) -> i64 {
    let scale = asset_scale(asset_precision);
    let bitcoin_amount = Amount::from_sat(bitcoin_amount).to_bitcoin();
    let asset_amount = if market.priced_in_bitcoins() {
        bitcoin_amount / price
    } else {
        bitcoin_amount * price
    };
    f64::round(asset_amount * scale) as i64
}

pub fn bitcoin_amount(
    asset_amount: i64,
    price: f64,
    asset_precision: u8,
    market: sideswap_api::MarketType,
) -> i64 {
    let asset_amount = asset_float_amount(asset_amount, asset_precision);
    let bitcoin_amount = if market.priced_in_bitcoins() {
        asset_amount * price
    } else {
        asset_amount / price
    };
    Amount::from_bitcoin(bitcoin_amount).to_sat()
}

pub fn asset_float_amount(asset_amount: i64, asset_precision: u8) -> f64 {
    asset_amount as f64 / asset_scale(asset_precision)
}

pub fn asset_int_amount(asset_amount: f64, asset_precision: u8) -> i64 {
    f64::round(asset_amount * asset_scale(asset_precision)) as i64
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
    fn test_max_amount() {
        use rand::Rng;
        let mut rng = rand::thread_rng();
        let mut less_count = 0;
        let mut more_count = 0;
        let test_count = 10000000;
        for _ in 0..test_count {
            let balance: i64 = rng.gen_range(
                MIN_BITCOIN_AMOUNT.to_sat() + MIN_SERVER_FEE.to_sat(),
                Amount::from_bitcoin(100.0).to_sat(),
            );
            let balance = Amount::from_sat(balance);
            let amount = get_max_bitcoin_amount(balance).unwrap();
            let server_fee = get_server_fee(amount);
            if amount + server_fee > balance {
                more_count += 1;
            }
            if amount + server_fee < balance {
                less_count += 1;
            }
        }
        assert!(more_count == 0);
        assert!(
            (less_count as f64) / (test_count as f64) < 0.002,
            "less_count: {}, test_count: {}",
            less_count,
            test_count
        );
    }
}
