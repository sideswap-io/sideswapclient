use std::str::FromStr;

use anyhow::{anyhow, ensure};
use elements::{pset::PartiallySignedTransaction, AssetId, Txid};

pub struct PsetInput {
    pub txid: Txid,
    pub vout: u32,
    pub script_pub_key: elements::script::Script,
    pub asset_commitment: elements::confidential::Asset,
    pub value_commitment: elements::confidential::Value,
}

pub struct PsetOutput {
    pub address: elements::Address,
    pub asset: AssetId,
    pub amount: u64,
}

// Copied from GDK
pub fn p2pkh_script(pk: &elements::bitcoin::PublicKey) -> elements::Script {
    elements::Address::p2pkh(pk, None, &elements::address::AddressParams::ELEMENTS).script_pubkey()
}

pub fn pset_input(input: PsetInput) -> elements::pset::Input {
    let PsetInput {
        txid,
        vout,
        script_pub_key,
        asset_commitment,
        value_commitment,
    } = input;

    let mut pset_input = elements::pset::Input::from_prevout(elements::OutPoint { txid, vout });

    pset_input.witness_utxo = Some(elements::TxOut {
        asset: asset_commitment,
        value: value_commitment,
        nonce: elements::confidential::Nonce::Null,
        script_pubkey: script_pub_key,
        witness: elements::TxOutWitness::default(),
    });

    pset_input
}

pub fn pset_output(output: PsetOutput) -> Result<elements::pset::Output, anyhow::Error> {
    let PsetOutput {
        address,
        asset,
        amount,
    } = output;

    let blinding_pubkey = address
        .blinding_pubkey
        .ok_or_else(|| anyhow!("only blinded addresses allowed"))?;
    ensure!(amount > 0);

    let txout = elements::TxOut {
        asset: elements::confidential::Asset::Explicit(asset),
        value: elements::confidential::Value::Explicit(amount),
        nonce: elements::confidential::Nonce::Confidential(blinding_pubkey),
        script_pubkey: address.script_pubkey(),
        witness: elements::TxOutWitness::default(),
    };

    let mut output = elements::pset::Output::from_txout(txout);

    output.blinding_key =
        Some(elements::bitcoin::PublicKey::from_str(&blinding_pubkey.to_string()).unwrap());
    output.blinder_index = Some(0);

    Ok(output)
}

pub fn pset_network_fee(asset: AssetId, amount: u64) -> elements::pset::Output {
    let network_fee_output = elements::TxOut::new_fee(amount, asset);
    elements::pset::Output::from_txout(network_fee_output)
}

pub fn copy_signatures(
    mut dst: PartiallySignedTransaction,
    src: PartiallySignedTransaction,
) -> Result<PartiallySignedTransaction, anyhow::Error> {
    ensure!(dst.inputs().len() == src.inputs().len());
    ensure!(dst.outputs().len() == src.outputs().len());
    for (dst, src) in dst.inputs_mut().iter_mut().zip(src.inputs().iter()) {
        if src.final_script_witness.is_some() {
            dst.final_script_sig = src.final_script_sig.clone();
            dst.final_script_witness = src.final_script_witness.clone();
        }
    }
    Ok(dst)
}
