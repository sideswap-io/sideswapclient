use std::str::FromStr;

use crate::gdk_json::{self, AddressInfo};

pub struct Amounts {
    pub send_asset: sideswap_api::AssetId,
    pub send_amount: u64,
    pub recv_asset: sideswap_api::AssetId,
    pub recv_amount: u64,
}

pub struct SigSingleInput {
    pub asset: elements::AssetId,
    pub value: u64,
}

pub struct SigSingleOutput {
    pub asset: elements::AssetId,
    pub value: u64,
    pub address_info: AddressInfo,
}

pub struct SigSingleMaker {
    pub proposal: sideswap_api::LiquidexProposal,
    pub chaining_tx: Option<MakerChainingTx>,
    pub unspent_output: gdk_json::UnspentOutput,
}

pub struct MakerChainingTx {
    pub input: sideswap_api::Utxo,
    pub tx: elements::Transaction,
}

pub fn generate_fake_p2sh_address(env: sideswap_common::env::Env) -> elements::Address {
    let pk_hex = "020000000000000000000000000000000000000000000000000000000000000001";
    let pk = elements::bitcoin::PublicKey::from_str(pk_hex).unwrap();
    let blinder = elements::secp256k1_zkp::PublicKey::from_str(pk_hex).unwrap();
    elements::Address::p2shwpkh(&pk, Some(blinder), env.elements_params())
}

#[cfg(test)]
mod test {
    use super::*;
    #[test]
    fn test_generate_fake_p2sh_address() {
        generate_fake_p2sh_address(sideswap_common::env::Env::Prod);
    }
}
