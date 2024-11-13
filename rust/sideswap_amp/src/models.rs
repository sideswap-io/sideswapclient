use serde::Deserialize;
use sideswap_types::timestamp_us::TimestampUs;

mod helpers;

#[derive(Deserialize)]
pub struct Subaccount {
    pub name: String,
    pub pointer: u32,
    pub receiving_id: String,
    #[serde(rename = "type")]
    pub type_: String,
    pub required_ca: u32,
}

#[derive(Deserialize)]
pub struct AuthenticateResult {
    pub gait_path: String,
    pub receiving_id: String,
    pub subaccounts: Vec<Subaccount>,
    pub block_height: u32,
    pub block_hash: String,
}

#[derive(Deserialize)]
pub struct ReceiveAddress {
    pub branch: u32,
    pub subaccount: u32,
    pub pointer: u32,
    pub script: elements::Script,
    pub addr_type: String,
}

#[derive(Deserialize, Debug)]
pub struct Utxo {
    pub block_height: Option<u32>,
    pub txhash: elements::Txid,
    pub pt_idx: u32,
    pub subaccount: u32,
    pub pointer: u32,
    pub script_type: u32,
    pub user_status: u32,
    pub value: Option<String>,
    pub subtype: u32,
    #[serde(deserialize_with = "helpers::deserialize_hex")]
    pub asset_tag: elements::confidential::Asset,
    pub script: elements::Script,
    #[serde(deserialize_with = "helpers::deserialize_hex")]
    pub commitment: elements::confidential::Value,
    #[serde(deserialize_with = "helpers::deserialize_nonce")]
    pub nonce_commitment: elements::confidential::Nonce,
    #[serde(deserialize_with = "helpers::deserialize_with_optional_empty_string")]
    pub surj_proof: Option<Box<secp256k1_zkp::SurjectionProof>>,
    #[serde(deserialize_with = "helpers::deserialize_with_optional_empty_string")]
    pub range_proof: Option<Box<secp256k1_zkp::RangeProof>>,
}

#[derive(Deserialize, Debug)]
pub struct TransactionEp {
    // pub address: String, // Examples: "", "8srqhMFdtuV9xLn2MDe7nFVibkUUyxRFhg"
    pub is_output: bool,
    pub is_relevant: bool,
    pub pt_idx: u32,
    pub is_spent: bool,
    // pub value: String, // Examples: "553", "None"
    pub script_type: u32, // Examples: 14
    pub subtype: u32,     // Examples: 0
    pub pointer: u32,
    pub subaccount: u32,

    // Set for inputs
    pub prevtxhash: Option<elements::Txid>,
    pub previdx: Option<u32>,
    pub prevsubaccount: Option<u32>,
    pub prevpointer: Option<u32>,

    // Set for outputs and own inputs
    #[serde(default)]
    #[serde(deserialize_with = "helpers::deserialize_hex")]
    pub asset_tag: elements::confidential::Asset,
    #[serde(default)]
    pub script: elements::Script,
    #[serde(default)]
    #[serde(deserialize_with = "helpers::deserialize_hex")]
    pub commitment: elements::confidential::Value,
    #[serde(default)]
    #[serde(deserialize_with = "helpers::deserialize_nonce")]
    pub nonce_commitment: elements::confidential::Nonce,
    #[serde(default)]
    #[serde(deserialize_with = "helpers::deserialize_with_optional_empty_string")]
    pub surj_proof: Option<Box<secp256k1_zkp::SurjectionProof>>,
    #[serde(default)]
    #[serde(deserialize_with = "helpers::deserialize_with_optional_empty_string")]
    pub range_proof: Option<Box<secp256k1_zkp::RangeProof>>,
}

#[derive(Deserialize, Debug)]
pub struct Transaction {
    pub eps: Vec<TransactionEp>,
    pub block_height: u32,
    pub created_at_ts: TimestampUs,
    pub txhash: elements::Txid,
    pub transaction_vsize: u32,
    pub fee: u64,
    pub rbf_optin: bool,
}

#[derive(Deserialize, Debug)]
pub struct Transactions {
    pub list: Vec<Transaction>,
    pub more: bool,
}

#[derive(Deserialize, Debug)]
pub struct BlockEvent {
    pub count: u32,
    pub diverged_count: u32,
    pub block_hash: String,
    pub previous_hash: String,
}

#[derive(Deserialize, Debug)]
pub struct TransactionEvent {
    pub subaccounts: Vec<u32>,
    pub txhash: elements::Txid,
}

#[cfg(test)]
mod tests;
