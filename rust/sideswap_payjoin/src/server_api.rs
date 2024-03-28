#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct AcceptedAssetsRequest {}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct AcceptedAssetsResponse {
    pub accepted_asset: Vec<AcceptedAsset>,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct AcceptedAsset {
    pub asset_id: elements::AssetId,
}

#[derive(Debug, serde::Serialize, serde::Deserialize, Clone)]
pub struct Utxo {
    pub txid: elements::Txid,
    pub vout: u32,
    pub script_pub_key: elements::script::Script,
    pub asset_id: elements::AssetId,
    pub value: u64,
    pub asset_bf: elements::confidential::AssetBlindingFactor,
    pub value_bf: elements::confidential::ValueBlindingFactor,
    pub asset_commitment: elements::secp256k1_zkp::Generator,
    pub value_commitment: elements::secp256k1_zkp::PedersenCommitment,
}

#[derive(Debug, serde::Serialize, serde::Deserialize, Clone)]
pub struct StartRequest {
    pub asset_id: elements::AssetId,
    pub user_agent: String,
    pub api_key: Option<String>,
}

#[derive(Debug, serde::Serialize, serde::Deserialize, Clone)]
pub struct StartResponse {
    pub order_id: String,
    pub expires_at: u64,
    pub price: f64,
    pub fixed_fee: u64,
    pub fee_address: elements::Address,
    pub change_address: elements::Address,
    pub utxos: Vec<Utxo>,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct SignRequest {
    pub order_id: String,
    pub pset: String,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct SignResponse {
    pub pset: String,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "snake_case")]
#[allow(clippy::large_enum_variant)]
pub enum Request {
    AcceptedAssets(AcceptedAssetsRequest),
    Start(StartRequest),
    Sign(SignRequest),
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "snake_case")]
#[allow(clippy::large_enum_variant)]
pub enum Response {
    AcceptedAssets(AcceptedAssetsResponse),
    Start(StartResponse),
    Sign(SignResponse),
}

#[derive(serde::Serialize, serde::Deserialize)]
pub struct Error {
    pub error: String,
}
