use serde::Deserialize;

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
    pub subaccounts: Vec<Subaccount>,
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

#[cfg(test)]
mod tests;
