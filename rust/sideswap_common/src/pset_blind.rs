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
}

/// Blind PSET and return blinding nonces (they are required by the Green backend for AMP accounts)
pub fn blind_pset(
    pset: &mut elements::pset::PartiallySignedTransaction,
    inp_txout_sec: &[elements::TxOutSecrets],
) -> Result<Vec<String>, Error> {
    let secp = elements::secp256k1_zkp::global::SECP256K1;

    let rng = &mut rand::thread_rng();

    let mut last_blinded_index = None;

    let mut exp_out_secrets = Vec::new();
    let mut blinding_nonces = Vec::new();
    for (index, out) in pset.outputs().iter().enumerate() {
        if out.blinding_key.is_none() {
            let value = out.amount.ok_or_else(|| Error::UnknownOutputValue(index))?;
            exp_out_secrets.push((
                value,
                elements::confidential::AssetBlindingFactor::zero(),
                elements::confidential::ValueBlindingFactor::zero(),
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
            .ok_or_else(|| Error::UnknownOutputAsset(index))?;
        let value = output
            .amount
            .ok_or_else(|| Error::UnknownOutputValue(index))?;
        if let Some(receiver_blinding_pk) = output.blinding_key {
            let is_last = index == last_blinded_index;

            let out_abf = elements::confidential::AssetBlindingFactor::new(rng);
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

                elements::confidential::ValueBlindingFactor::last(
                    secp,
                    value,
                    out_abf,
                    &inp_secrets,
                    &exp_out_secrets,
                )
            } else {
                elements::confidential::ValueBlindingFactor::new(rng)
            };

            let value_commitment = elements::secp256k1_zkp::PedersenCommitment::new(
                secp,
                value,
                out_vbf.into_inner(),
                out_asset_commitment,
            );

            let (nonce, shared_secret) = elements::confidential::Nonce::new_confidential(
                rng,
                secp,
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
