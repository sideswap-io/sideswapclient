use sideswap_api::ServerFee;
use sideswap_types::{asset_precision::AssetPrecision, fee_rate::FeeRateSats};

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

pub const MAX_BTC_AMOUNT: f64 = 21_000_000.0;

pub const COIN: i64 = 100_000_000;

pub const ELEMENTS_CONFIRMED_BLOCKS: i32 = 2;
pub const BITCOIN_CONFIRMED_BLOCKS: i32 = 6;

pub fn btc_to_sat(amount: f64) -> u64 {
    (amount * COIN as f64).round() as u64
}

pub fn sat_to_btc(amount: u64) -> f64 {
    amount as f64 / COIN as f64
}

impl Amount {
    pub fn from_sat(value: i64) -> Self {
        Amount(value)
    }

    pub fn from_rpc(value: &serde_json::Number) -> Self {
        let amount =
            bitcoin::SignedAmount::from_str_in(&value.to_string(), bitcoin::Denomination::Bitcoin)
                .expect("invalid bitcoin value");
        Amount::from_sat(amount.to_sat())
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
    pub txid: elements::Txid,
    pub vout: u32,
}

impl TxOut {
    pub fn new(txid: elements::Txid, vout: u32) -> TxOut {
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

pub fn timestamp_now() -> i64 {
    std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap()
        .as_millis() as i64
}

pub const SWAP_MARKETS_MIN_BITCOIN_AMOUNT: Amount = Amount(2000);
pub const SWAP_MARKETS_MIN_SERVER_FEE: Amount = Amount(500);

pub fn get_server_fee(bitcoin_amount: Amount, server_fee: ServerFee) -> Amount {
    let server_fee = Amount::from_bitcoin(bitcoin_amount.to_bitcoin() * server_fee.value());
    std::cmp::max(server_fee, SWAP_MARKETS_MIN_SERVER_FEE)
}

pub fn get_max_bitcoin_amount(
    bitcoin_balance: Amount,
    server_fee: ServerFee,
) -> Result<Amount, anyhow::Error> {
    assert!(bitcoin_balance.to_sat() >= 0);
    ensure!(
        bitcoin_balance >= SWAP_MARKETS_MIN_BITCOIN_AMOUNT + SWAP_MARKETS_MIN_SERVER_FEE,
        "balance is too low"
    );
    let network_fee_scaled =
        Amount::from_bitcoin(bitcoin_balance.to_bitcoin() * (1. - 1. / (1. + server_fee.value())));
    let network_fee = Amount::max(network_fee_scaled, SWAP_MARKETS_MIN_SERVER_FEE);
    let bitcoin_amount = bitcoin_balance - network_fee;
    let actual_server_fee = get_server_fee(bitcoin_amount, server_fee);
    if bitcoin_balance < bitcoin_amount + actual_server_fee {
        Ok(bitcoin_amount - Amount::from_sat(1))
    } else {
        Ok(bitcoin_amount)
    }
}

pub fn asset_scale(asset_precision: AssetPrecision) -> f64 {
    10u32.pow(u32::from(asset_precision.value())) as f64
}

pub fn asset_amount(
    bitcoin_amount: i64,
    price: f64,
    asset_precision: AssetPrecision,
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
    asset_precision: AssetPrecision,
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

pub fn asset_float_amount(asset_amount: i64, asset_precision: AssetPrecision) -> f64 {
    asset_amount as f64 / asset_scale(asset_precision)
}

pub fn asset_float_amount_(asset_amount: u64, asset_precision: AssetPrecision) -> f64 {
    asset_amount as f64 / asset_scale(asset_precision)
}

pub fn asset_int_amount(asset_amount: f64, asset_precision: AssetPrecision) -> i64 {
    f64::round(asset_amount * asset_scale(asset_precision)) as i64
}

pub fn asset_int_amount_(asset_amount: f64, asset_precision: AssetPrecision) -> u64 {
    f64::round(asset_amount * asset_scale(asset_precision)) as u64
}

pub struct PegOutAmountReq {
    pub amount: i64,
    pub is_send_entered: bool,
    pub fee_rate: FeeRateSats,
    pub min_peg_out_amount: i64,
    pub server_fee_percent_peg_out: f64,
    pub peg_out_bitcoin_tx_vsize: usize,
}

pub struct PegOutAmountResp {
    pub send_amount: i64,
    pub recv_amount: i64,
}

pub fn peg_out_amount(req: PegOutAmountReq) -> Result<PegOutAmountResp, anyhow::Error> {
    ensure!(req.amount > 0);
    let peg_out_rate = 1.0 - req.server_fee_percent_peg_out / 100.0;
    let fixed_fee = (req.peg_out_bitcoin_tx_vsize as f64 * req.fee_rate.raw()).round() as i64;
    let (send_amount, recv_amount) = if req.is_send_entered {
        let recv_amount = (req.amount as f64 * peg_out_rate).round() as i64 - fixed_fee;
        (req.amount, recv_amount)
    } else {
        let send_amount = ((req.amount + fixed_fee) as f64 / peg_out_rate).round() as i64;
        (send_amount, req.amount)
    };
    ensure!(
        send_amount >= req.min_peg_out_amount,
        "Min {}",
        Amount::from_sat(req.min_peg_out_amount).to_bitcoin()
    );
    ensure!(recv_amount > 0, "Amount to receive is negative");
    Ok(PegOutAmountResp {
        send_amount,
        recv_amount,
    })
}

#[cfg(test)]
mod tests;
