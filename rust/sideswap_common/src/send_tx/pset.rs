use anyhow::{anyhow, ensure};
use elements::{pset::PartiallySignedTransaction, AssetId, TxOutSecrets, Txid};
use rand::seq::SliceRandom;
use sideswap_api::{AssetBlindingFactor, ValueBlindingFactor};

use crate::pset_blind::OptBlindedOutputs;

pub struct PsetInput {
    pub txid: Txid,
    pub vout: u32,
    pub script_pub_key: elements::script::Script,
    pub asset_commitment: elements::confidential::Asset,
    pub value_commitment: elements::confidential::Value,
    pub tx_out_sec: TxOutSecrets,
}

pub struct PsetOutput {
    pub address: elements::Address,
    pub asset_id: AssetId,
    pub amount: u64,
}

pub struct Offline {
    pub input: PsetInput,

    pub output: PsetOutput,

    pub output_asset_bf: AssetBlindingFactor,
    pub output_value_bf: ValueBlindingFactor,
    pub output_ephemeral_sk: elements::secp256k1_zkp::SecretKey,
}

pub struct ConstructPsetArgs {
    pub policy_asset: AssetId,
    pub offlines: Vec<Offline>,
    pub inputs: Vec<PsetInput>,
    pub outputs: Vec<PsetOutput>,
    pub network_fee: u64,
}

pub struct ConstructedPset {
    pub blinded_pset: PartiallySignedTransaction,
    pub blinded_outputs: OptBlindedOutputs,
}

fn pset_input(input: PsetInput) -> elements::pset::Input {
    let PsetInput {
        txid,
        vout,
        script_pub_key,
        asset_commitment,
        value_commitment,
        tx_out_sec: _,
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

fn pset_output(output: PsetOutput) -> Result<elements::pset::Output, anyhow::Error> {
    let PsetOutput {
        address,
        asset_id,
        amount,
    } = output;

    let blinding_pubkey = address
        .blinding_pubkey
        .ok_or_else(|| anyhow!("only blinded addresses allowed"))?;
    ensure!(amount > 0);

    let txout = elements::TxOut {
        asset: elements::confidential::Asset::Explicit(asset_id),
        value: elements::confidential::Value::Explicit(amount),
        nonce: elements::confidential::Nonce::Confidential(blinding_pubkey),
        script_pubkey: address.script_pubkey(),
        witness: elements::TxOutWitness::default(),
    };

    let mut output = elements::pset::Output::from_txout(txout);

    output.blinding_key = Some(bitcoin::PublicKey::new(blinding_pubkey));
    output.blinder_index = Some(0);

    Ok(output)
}

fn pset_network_fee(asset: AssetId, amount: u64) -> elements::pset::Output {
    let network_fee_output = elements::TxOut::new_fee(amount, asset);
    elements::pset::Output::from_txout(network_fee_output)
}

pub fn construct_pset(args: ConstructPsetArgs) -> Result<ConstructedPset, anyhow::Error> {
    let ConstructPsetArgs {
        policy_asset,
        mut inputs,
        mut outputs,
        offlines,
        network_fee,
    } = args;

    let mut pset = PartiallySignedTransaction::new_v2();
    let mut input_secrets = Vec::new();
    let mut blinding_factors = Vec::new();

    let mut rng = rand::thread_rng();
    inputs.shuffle(&mut rng);
    outputs.shuffle(&mut rng);

    for offline in offlines {
        blinding_factors.push((
            offline.output_asset_bf,
            offline.output_value_bf,
            offline.output_ephemeral_sk,
        ));

        input_secrets.push(offline.input.tx_out_sec);

        pset.add_input(pset_input(offline.input));

        pset.add_output(pset_output(offline.output)?);
    }

    for input in inputs.into_iter() {
        input_secrets.push(input.tx_out_sec);

        pset.add_input(pset_input(input));
    }

    for output in outputs {
        pset.add_output(pset_output(output)?);
    }

    pset.add_output(pset_network_fee(policy_asset, network_fee));

    let blinded_outputs =
        crate::pset_blind::blind_pset(&mut pset, &input_secrets, &blinding_factors)?;

    Ok(ConstructedPset {
        blinded_pset: pset,
        blinded_outputs,
    })
}
