use bitcoin::secp256k1::SecretKey;
use elements::{
    confidential::{AssetBlindingFactor, ValueBlindingFactor},
    pset::{
        raw::{ProprietaryKey, ProprietaryType},
        PartiallySignedTransaction,
    },
    TxOutSecrets,
};

#[derive(thiserror::Error, Debug)]
pub enum Error {
    #[error("Output {0} value must be set")]
    UnknownOutputValue(usize),
    #[error("Output {0} asset must be set")]
    UnknownOutputAsset(usize),
    #[error("No blinding output found")]
    NoBlindingOutputFound,
    #[error("Blinding error: {0}")]
    BlindingError(#[from] elements::secp256k1_zkp::Error),
    #[error("Invalid input: {0}")]
    InvalidInput(&'static str),
}

const PSET_IN_EXPLICIT_VALUE: ProprietaryType = 0x11; // 8 bytes
const PSET_IN_VALUE_PROOF: ProprietaryType = 0x12; // 73 bytes
const PSET_IN_EXPLICIT_ASSET: ProprietaryType = 0x13; // 2 bytes
const PSET_IN_ASSET_PROOF: ProprietaryType = 0x14; // 67 bytes

pub fn remove_explicit_values(pset: &mut PartiallySignedTransaction) {
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
}

fn add_input_explicit_proofs(
    input: &mut elements::pset::Input,
    secret: &TxOutSecrets,
) -> Result<(), Error> {
    if secret.asset_bf == AssetBlindingFactor::zero()
        && secret.value_bf == ValueBlindingFactor::zero()
    {
        return Ok(());
    }
    let mut rng = rand::thread_rng();
    let asset_gen_unblinded = elements::secp256k1_zkp::Generator::new_unblinded(
        elements::secp256k1_zkp::global::SECP256K1,
        secret.asset.into_tag(),
    );
    let asset_gen_blinded = input
        .witness_utxo
        .as_ref()
        .ok_or(Error::InvalidInput("no witness_utxo"))?
        .asset
        .into_asset_gen(elements::secp256k1_zkp::global::SECP256K1)
        .ok_or(Error::InvalidInput("no asset_gen"))?;

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
    )?;

    let blind_value_proof = elements::secp256k1_zkp::RangeProof::new(
        elements::secp256k1_zkp::global::SECP256K1,
        secret.value,
        input
            .witness_utxo
            .as_ref()
            .ok_or(Error::InvalidInput("no witness_utxo"))?
            .value
            .commitment()
            .ok_or(Error::InvalidInput("invalid commitment"))?,
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

    Ok(())
}

/// Blind PSET and return blinding nonces (they are required by the Green backend for AMP accounts).
///
/// blinding_factors - zero or more pre-generated blinding factors for the outputs.
pub fn blind_pset(
    pset: &mut PartiallySignedTransaction,
    inp_txout_sec: &[TxOutSecrets],
    blinding_factors: &[(AssetBlindingFactor, ValueBlindingFactor, SecretKey)],
) -> Result<Vec<String>, Error> {
    let secp = elements::secp256k1_zkp::global::SECP256K1;

    let rng = &mut rand::thread_rng();

    for (input, secret) in pset.inputs_mut().iter_mut().zip(inp_txout_sec.iter()) {
        add_input_explicit_proofs(input, secret)?;
    }

    let mut last_blinded_index = None;

    let mut exp_out_secrets = Vec::new();
    let mut blinding_nonces = Vec::new();
    for (index, out) in pset.outputs().iter().enumerate() {
        if out.blinding_key.is_none() {
            let value = out.amount.ok_or(Error::UnknownOutputValue(index))?;
            exp_out_secrets.push((
                value,
                AssetBlindingFactor::zero(),
                ValueBlindingFactor::zero(),
            ));
        } else {
            last_blinded_index = Some(index);
        }
    }

    let last_blinded_index = last_blinded_index.ok_or(Error::NoBlindingOutputFound)?;

    let inputs = inp_txout_sec
        .iter()
        .map(|secret| {
            let tag = secret.asset.into_tag();
            let tweak = secret.asset_bf.into_inner();
            let gen = elements::secp256k1_zkp::Generator::new_blinded(secp, tag, tweak);
            (gen, tag, tweak)
        })
        .collect::<Vec<_>>();

    for (index, output) in pset.outputs_mut().iter_mut().enumerate() {
        let asset_id = output
            .asset
            .ok_or(Error::UnknownOutputAsset(index))?;
        let value = output
            .amount
            .ok_or(Error::UnknownOutputValue(index))?;
        if let Some(receiver_blinding_pk) = output.blinding_key {
            let is_last = index == last_blinded_index;

            let blinding_factor = blinding_factors.get(index);

            let out_abf = if let Some(blinding_factor) = blinding_factor {
                blinding_factor.0
            } else {
                AssetBlindingFactor::new(rng)
            };

            let out_asset_commitment = elements::secp256k1_zkp::Generator::new_blinded(
                secp,
                asset_id.into_tag(),
                out_abf.into_inner(),
            );

            let out_vbf = if is_last {
                let inp_secrets = inp_txout_sec
                    .iter()
                    .map(|o| (o.value, o.asset_bf, o.value_bf))
                    .collect::<Vec<_>>();

                ValueBlindingFactor::last(secp, value, out_abf, &inp_secrets, &exp_out_secrets)
            } else if let Some(blinding_factor) = blinding_factor {
                blinding_factor.1
            } else {
                ValueBlindingFactor::new(rng)
            };

            let value_commitment = elements::secp256k1_zkp::PedersenCommitment::new(
                secp,
                value,
                out_vbf.into_inner(),
                out_asset_commitment,
            );

            let ephemeral_sk = if let Some(blinding_factor) = blinding_factor {
                blinding_factor.2
            } else {
                SecretKey::new(rng)
            };

            let (nonce, shared_secret) = elements::confidential::Nonce::with_ephemeral_sk(
                secp,
                ephemeral_sk,
                &receiver_blinding_pk.inner,
            );
            blinding_nonces.push(shared_secret.display_secret().to_string());

            let mut message = [0u8; 64];
            message[..32].copy_from_slice(asset_id.into_tag().as_ref());
            message[32..].copy_from_slice(out_abf.into_inner().as_ref());

            let rangeproof = elements::secp256k1_zkp::RangeProof::new(
                secp,
                1,
                value_commitment,
                value,
                out_vbf.into_inner(),
                &message,
                output.script_pubkey.as_bytes(),
                shared_secret,
                0,
                52,
                out_asset_commitment,
            )?;

            let surjection_proof = elements::secp256k1_zkp::SurjectionProof::new(
                secp,
                rng,
                asset_id.into_tag(),
                out_abf.into_inner(),
                &inputs,
            )?;

            output.value_rangeproof = Some(Box::new(rangeproof));
            output.asset_surjection_proof = Some(Box::new(surjection_proof));
            output.amount_comm = Some(value_commitment);
            output.asset_comm = Some(out_asset_commitment);
            output.ecdh_pubkey = nonce.commitment().map(|pk| elements::bitcoin::PublicKey {
                inner: pk,
                compressed: true,
            });

            let gen = elements::secp256k1_zkp::Generator::new_unblinded(secp, asset_id.into_tag());
            output.blind_asset_proof =
                Some(Box::new(elements::secp256k1_zkp::SurjectionProof::new(
                    secp,
                    rng,
                    asset_id.into_tag(),
                    out_abf.into_inner(),
                    &[(
                        gen,
                        asset_id.into_tag(),
                        elements::secp256k1_zkp::ZERO_TWEAK,
                    )],
                )?));

            output.blind_value_proof = Some(Box::new(elements::secp256k1_zkp::RangeProof::new(
                secp,
                value,
                value_commitment,
                value,
                out_vbf.into_inner(),
                &[],
                &[],
                elements::secp256k1_zkp::SecretKey::new(rng),
                -1,
                0,
                out_asset_commitment,
            )?));

            exp_out_secrets.push((value, out_abf, out_vbf));
        } else {
            blinding_nonces.push(String::new());
        }
    }

    Ok(blinding_nonces)
}
