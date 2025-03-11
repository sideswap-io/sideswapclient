use serde::Deserialize;
use serde_json::json;
use sideswap_types::hex_encoded::HexEncoded;

use super::{RpcCall, RpcRequest};

#[derive(Deserialize)]
pub struct SignRawTransactionWithWallet {
    pub hex: HexEncoded<elements::Transaction>,
    // pub complete: bool,
}

pub struct SignRawTransactionWithWalletCall {
    pub raw_tx: HexEncoded<elements::Transaction>,
}

impl RpcCall for SignRawTransactionWithWalletCall {
    type Response = SignRawTransactionWithWallet;

    fn get_request(self) -> RpcRequest {
        RpcRequest {
            method: "signrawtransactionwithwallet".to_owned(),
            params: vec![json!(self.raw_tx)].into(),
        }
    }
}
