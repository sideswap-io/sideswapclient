use hex_encoded::HexEncoded;

pub mod asset_precision;
pub mod bitcoin_amount;
pub mod duration_ms;
pub mod fee_rate;
pub mod hex_encoded;
pub mod normal_float;
pub mod timestamp_ms;
pub mod timestamp_us;
pub mod utxo_ext;

pub type AssetCommitment = HexEncoded<elements::confidential::Asset>;
pub type ValueCommitment = HexEncoded<elements::confidential::Value>;
pub type NonceCommitment = HexEncoded<elements::confidential::Nonce>;

pub type Transaction = HexEncoded<elements::Transaction>;
