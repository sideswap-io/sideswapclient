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
)]
pub struct Amount(pub i64);

const COIN: i64 = 100_000_000;

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
    let mut amount_remain = amount;
    let mut result = Vec::new();
    while amount_remain > 0 {
        inputs.sort_by_key(|value| -(value - amount_remain).abs());
        let selected = inputs.pop().expect("not enough available inputs");
        result.push(selected);
        amount_remain -= selected;
    }
    result.sort();
    result.reverse();
    while result.iter().sum::<i64>() - result.last().unwrap() > amount {
        result.pop();
    }
    result
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
}
