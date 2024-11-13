//! Cache of all wallet UTXOs ever sent to the server.
//! It's used to speed up PSET signing and to ensure that all expected outputs are signed (if a wallet UTXO has already been spent).

use std::collections::BTreeMap;

use elements::{
    bitcoin::PrivateKey, pset::PartiallySignedTransaction, secp256k1_zkp::SECP256K1, OutPoint,
    Script,
};
use sideswap_api::{Utxo, ValueBlindingFactor};

#[derive(Clone)]
pub struct Params {
    pub confifential_only: bool,
}

#[derive(Clone)]
pub struct UtxoData {
    params: Params,
    utxo_keys: BTreeMap<OutPoint, UtxoKey>,
    utxos: Vec<Utxo>,
}

#[derive(Clone)]
struct UtxoKey {
    value: elements::confidential::Value,
    priv_key: PrivateKey,
    redeem_script: Option<Script>,
}

pub struct UtxoWithKey {
    pub utxo: Utxo,
    pub priv_key: PrivateKey,
}

impl UtxoData {
    pub fn new(params: Params) -> UtxoData {
        UtxoData {
            params,
            utxo_keys: BTreeMap::new(),
            utxos: Vec::new(),
        }
    }

    pub fn get_priv_key(&self, outpoint: &OutPoint) -> Option<PrivateKey> {
        self.utxo_keys.get(outpoint).map(|utxo| utxo.priv_key)
    }

    pub fn reset(&mut self, utxos: Vec<UtxoWithKey>) {
        use sideswap_types::utxo_ext::UtxoExt;
        self.utxos.clear();

        for UtxoWithKey { utxo, priv_key } in utxos {
            if self.params.confifential_only && utxo.value_bf == ValueBlindingFactor::zero() {
                continue;
            }

            let value = if utxo.value_bf == ValueBlindingFactor::zero() {
                elements::confidential::Value::Explicit(utxo.value)
            } else {
                elements::confidential::Value::new_confidential_from_assetid(
                    &SECP256K1,
                    utxo.value,
                    utxo.asset,
                    utxo.value_bf,
                    utxo.asset_bf,
                )
            };

            self.utxo_keys.insert(
                utxo.outpoint(),
                UtxoKey {
                    value,
                    priv_key,
                    redeem_script: utxo.redeem_script.clone(),
                },
            );

            self.utxos.push(utxo);
        }
    }

    pub fn utxos(&self) -> &[Utxo] {
        &self.utxos
    }

    pub fn sign_pset(&self, mut pset: PartiallySignedTransaction) -> PartiallySignedTransaction {
        let tx = pset.extract_tx().expect("must not fail");

        for (index, (tx_input, pset_input)) in tx.input.iter().zip(pset.inputs_mut()).enumerate() {
            let outpoint = tx_input.previous_output;
            if let Some(utxo_data) = self.utxo_keys.get(&outpoint) {
                let input_sign = sideswap_common::pset::internal_sign_elements(
                    SECP256K1,
                    &tx,
                    index,
                    &utxo_data.priv_key,
                    utxo_data.value,
                    elements::EcdsaSighashType::All,
                );

                let public_key = utxo_data.priv_key.public_key(SECP256K1);
                pset_input.final_script_sig = utxo_data.redeem_script.as_ref().map(|script| {
                    elements::script::Builder::new()
                        .push_slice(script.as_bytes())
                        .into_script()
                });
                pset_input.final_script_witness = Some(vec![input_sign, public_key.to_bytes()]);
            }
        }

        pset
    }
}
