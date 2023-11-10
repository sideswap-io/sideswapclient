use std::str::FromStr;

use anyhow::{anyhow, ensure};
use elements::{
    pset::{
        raw::{ProprietaryKey, ProprietaryType},
        PartiallySignedTransaction,
    },
    AssetId, TxOutSecrets, Txid,
};
use rand::seq::SliceRandom;

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

const PSET_IN_EXPLICIT_VALUE: ProprietaryType = 0x11; // 8 bytes
const PSET_IN_VALUE_PROOF: ProprietaryType = 0x12; // 73 bytes
const PSET_IN_EXPLICIT_ASSET: ProprietaryType = 0x13; // 2 bytes
const PSET_IN_ASSET_PROOF: ProprietaryType = 0x14; // 67 bytes

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

fn add_input_explicit_proofs(
    mut input: elements::pset::Input,
    secret: &TxOutSecrets,
) -> Result<elements::pset::Input, anyhow::Error> {
    let mut rng = rand::thread_rng();
    let asset_gen_unblinded = elements::secp256k1_zkp::Generator::new_unblinded(
        elements::secp256k1_zkp::global::SECP256K1,
        secret.asset.into_tag(),
    );
    let asset_gen_blinded = input
        .witness_utxo
        .as_ref()
        .unwrap()
        .asset
        .into_asset_gen(elements::secp256k1_zkp::global::SECP256K1)
        .unwrap();

    let blind_asset_proof = elements::secp256k1_zkp::SurjectionProof::new(
        elements::secp256k1_zkp::global::SECP256K1,
        &mut rng,
        secret.asset.into_tag(),
        secret.asset_bf.into_inner(),
        &[(
            asset_gen_unblinded,
            secret.asset.into_tag(),
            elements::secp256k1_zkp::ZERO_TWEAK,
        )],
    )
    .unwrap();

    let blind_value_proof = elements::secp256k1_zkp::RangeProof::new(
        elements::secp256k1_zkp::global::SECP256K1,
        secret.value,
        input
            .witness_utxo
            .as_ref()
            .unwrap()
            .value
            .commitment()
            .unwrap(),
        secret.value,
        secret.value_bf.into_inner(),
        &[],
        &[],
        elements::secp256k1_zkp::SecretKey::new(&mut rng),
        -1,
        0,
        asset_gen_blinded,
    )?;

    input.proprietary.insert(
        ProprietaryKey::from_pset_pair(PSET_IN_EXPLICIT_VALUE, Vec::new()),
        elements::encode::serialize(&secret.value),
    );

    input.proprietary.insert(
        ProprietaryKey::from_pset_pair(PSET_IN_EXPLICIT_ASSET, Vec::new()),
        elements::encode::serialize(&secret.asset),
    );

    let mut blind_value_proof = elements::encode::serialize(&blind_value_proof);
    blind_value_proof.remove(0);
    let mut blind_asset_proof = elements::encode::serialize(&blind_asset_proof);
    blind_asset_proof.remove(0);

    input.proprietary.insert(
        ProprietaryKey::from_pset_pair(PSET_IN_VALUE_PROOF, Vec::new()),
        blind_value_proof,
    );

    input.proprietary.insert(
        ProprietaryKey::from_pset_pair(PSET_IN_ASSET_PROOF, Vec::new()),
        blind_asset_proof,
    );

    Ok(input)
}

pub fn remove_explicit_values(mut pset: PartiallySignedTransaction) -> PartiallySignedTransaction {
    for input in pset.inputs_mut() {
        for subtype in [
            PSET_IN_EXPLICIT_VALUE,
            PSET_IN_EXPLICIT_ASSET,
            PSET_IN_VALUE_PROOF,
            PSET_IN_ASSET_PROOF,
        ] {
            input
                .proprietary
                .remove(&ProprietaryKey::from_pset_pair(subtype, Vec::new()));
        }
    }
    pset
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

pub fn randomize_and_blind_pset(
    mut pset: PartiallySignedTransaction,
    input_secrets: &[TxOutSecrets],
) -> Result<PartiallySignedTransaction, anyhow::Error> {
    let mut rng = rand::thread_rng();

    ensure!(pset.inputs().len() == input_secrets.len());

    let mut inputs = pset
        .inputs()
        .iter()
        .cloned()
        .zip(input_secrets)
        .collect::<Vec<_>>();
    let outputs = pset.outputs_mut();

    inputs.shuffle(&mut rng);
    outputs.shuffle(&mut rng);

    let fee_output = outputs
        .iter()
        .position(|output| output.blinding_key.is_none())
        .ok_or_else(|| anyhow!("can't find network fee output"))?;
    let output_count = outputs.len();
    outputs.swap(fee_output, output_count - 1);

    let mut pset = PartiallySignedTransaction::new_v2();

    for (input, secret) in inputs.iter() {
        // Add explicit asset/amount proofs for inputs (required by GDK)
        let input = add_input_explicit_proofs(input.clone(), secret)?;
        pset.add_input(input);
    }

    for output in outputs {
        pset.add_output(output.clone());
    }

    let inp_txout_sec = inputs
        .iter()
        .enumerate()
        .map(|(index, (_input, secret))| (index, **secret))
        .collect();

    pset.blind_last(
        &mut rng,
        elements::secp256k1_zkp::global::SECP256K1,
        &inp_txout_sec,
    )?;

    Ok(pset)
}
