use hex_encoded::HexEncoded;

pub mod bitcoin_amount;
pub mod hex_encoded;
pub mod timestamp;

pub type AssetCommitment = HexEncoded<elements::confidential::Asset>;
pub type ValueCommitment = HexEncoded<elements::confidential::Value>;
pub type NonceCommitment = HexEncoded<elements::confidential::Nonce>;

pub type Transaction = HexEncoded<elements::Transaction>;
