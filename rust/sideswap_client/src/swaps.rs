use bitcoin::hashes::Hash;
use gdk_common::be::BEScript;
use gdk_common::be::{BEOutPoint, UTXOInfo};
use gdk_common::wally::{asset_blinding_key_to_ec_private_key, ec_public_key_from_private_key};
use gdk_electrum::account::Account;
use std::str::FromStr;

pub struct Amounts {
    pub send_asset: sideswap_api::AssetId,
    pub send_amount: u64,
    pub recv_asset: sideswap_api::AssetId,
    pub recv_amount: u64,
}

fn verify_amounts(amounts: &Amounts) -> Result<(), anyhow::Error> {
    ensure!(amounts.send_amount > 0);
    ensure!(amounts.recv_amount > 0);
    ensure!(amounts.send_asset != amounts.recv_asset);
    Ok(())
}

fn verify_output(
    secp: &elements_pset::secp256k1_zkp::Secp256k1<elements_pset::secp256k1_zkp::All>,
    account: &Account,
    output: &elements_pset::TxOut,
    expected_asset: &elements_pset::AssetId,
    expected_value: u64,
) -> Result<(), anyhow::Error> {
    let store_read = account.store.read().unwrap();
    let acc_store = store_read.account_cache(account.account_num).unwrap();
    let script = elements::Script::from(output.script_pubkey.to_bytes());
    ensure!(
        acc_store
            .paths
            .get(&BEScript::Elements(script.clone()))
            .is_some(),
        "unknown output script"
    );

    let blinding_key = gdk_common::wally::asset_blinding_key_to_ec_private_key(
        account.master_blinding.as_ref().unwrap(),
        &script,
    );
    let secrets = output.unblind(&secp, blinding_key)?;
    ensure!(*expected_asset == secrets.asset, "unexpected asset");
    ensure!(expected_value == secrets.value, "unexpected value");
    Ok(())
}

#[allow(dead_code)]
fn verify_change_output(
    account: &Account,
    output: &elements_pset::pset::Output,
    expected_asset: &elements_pset::AssetId,
) -> Result<(), anyhow::Error> {
    let store_read = account.store.read().unwrap();
    let acc_store = store_read.account_cache(account.account_num).unwrap();
    let script = elements::Script::from(output.script_pubkey.to_bytes());
    ensure!(
        acc_store
            .paths
            .get(&BEScript::Elements(script.clone()))
            .is_some(),
        "unknown output script"
    );
    let expected_blinding_prv =
        asset_blinding_key_to_ec_private_key(account.master_blinding.as_ref().unwrap(), &script);
    let expected_blinding_pub = ec_public_key_from_private_key(expected_blinding_prv);
    let expected_blinding_pub =
        bitcoin::PublicKey::from_str(&expected_blinding_pub.to_string()).unwrap();
    let actual_blinding_pub = output
        .blinding_key
        .as_ref()
        .ok_or_else(|| anyhow!("blinding_key must be set"))?;
    ensure!(
        actual_blinding_pub.to_bytes() == expected_blinding_pub.to_bytes(),
        "unexpected blinding_key"
    );
    let actual_asset = output
        .asset
        .as_ref()
        .ok_or_else(|| anyhow!("asset is empty"))?;
    ensure!(actual_asset == expected_asset, "unexpected asset");
    Ok(())
}

pub fn verify_pset_recv_output(
    secp: &elements_pset::secp256k1_zkp::Secp256k1<elements_pset::secp256k1_zkp::All>,
    account: &Account,
    amounts: &Amounts,
    pset: &elements_pset::pset::PartiallySignedTransaction,
) -> Result<(), anyhow::Error> {
    let recv_asset = elements_pset::AssetId::from_slice(&amounts.recv_asset.0).unwrap();
    let tx = pset.extract_tx()?;
    let recv_output = tx.output.iter().find(|output| {
        verify_output(secp, account, output, &recv_asset, amounts.recv_amount).is_ok()
    });
    ensure!(recv_output.is_some());
    Ok(())
}

pub fn sign_and_verify_pset(
    secp: &elements_pset::secp256k1_zkp::Secp256k1<elements_pset::secp256k1_zkp::All>,
    account: &Account,
    amounts: &Amounts,
    pset: &elements_pset::pset::PartiallySignedTransaction,
    recv_amp: bool,
) -> Result<elements_pset::pset::PartiallySignedTransaction, anyhow::Error> {
    verify_amounts(amounts)?;
    if !recv_amp {
        verify_pset_recv_output(secp, account, amounts, &pset)?;
    }

    let mut pset = pset.clone();
    let send_asset = elements::AssetId::from_slice(&amounts.send_asset.0).unwrap();
    let tx = pset
        .extract_tx()
        .map_err(|e| anyhow!(format!("extracting transaction failed: {}", e)))?;

    let store_read = account.store.read().unwrap();
    let acc_store = store_read.account_cache(account.num()).unwrap();

    let utxos = account
        .utxos(0, true)
        .map_err(|_| anyhow!("can't find utxos"))?;
    let asset_utxos: std::collections::HashMap<BEOutPoint, UTXOInfo> = utxos
        .into_iter()
        .filter(|(_, i)| i.asset_id() == Some(send_asset))
        .collect();

    let mut inputs_amount = 0;
    for (index, input) in pset.inputs.iter_mut().enumerate() {
        let out_point = elements::OutPoint {
            txid: elements::Txid::from_str(&input.previous_txid.to_string()).unwrap(),
            vout: input.previous_output_index,
        };
        let unblinded = acc_store.unblinded.get(&out_point);
        if let Some(unblinded) = unblinded {
            let utxo = asset_utxos
                .get(&BEOutPoint::Elements(out_point))
                .ok_or_else(|| anyhow!("UTXO not found"))?;

            assert!(unblinded.value == utxo.value);
            assert!(unblinded.asset.to_string() == utxo.asset);
            inputs_amount += utxo.value;

            let txid = elements::Txid::from_str(&input.previous_txid.to_string()).unwrap();
            let prev_tx = acc_store
                .get_liquid_tx(&txid)
                .map_err(|_| anyhow!("prev tx not found"))?;

            let private_key = account
                .xprv
                .derive_priv(&secp, &utxo.path)
                .unwrap()
                .private_key;
            let private_key =
                elements_pset::bitcoin::PrivateKey::from_str(&private_key.to_string()).unwrap();

            let prev_value = prev_tx.output[input.previous_output_index as usize].value;
            let prev_value =
                elements_pset::encode::deserialize::<elements_pset::confidential::Value>(
                    &elements::encode::serialize(&prev_value),
                )
                .unwrap();

            let input_sign = sideswap_common::pset::internal_sign_elements(
                &secp,
                &tx,
                index,
                &private_key,
                prev_value,
                elements_pset::SigHashType::All,
            );
            let public_key = private_key.public_key(&secp);
            input.final_script_sig = Some(sideswap_common::pset::p2shwpkh_script_sig(&public_key));
            input.final_script_witness = Some(vec![input_sign, public_key.to_bytes()]);
        }
    }

    ensure!(
        inputs_amount >= amounts.send_amount,
        "unexpected inputs amount"
    );
    let change_amount = inputs_amount - amounts.send_amount;
    let send_asset = elements_pset::AssetId::from_slice(&amounts.send_asset.0).unwrap();
    if change_amount > 0 {
        let change_output = tx.output.iter().find(|output| {
            verify_output(secp, account, output, &send_asset, change_amount).is_ok()
        });
        ensure!(change_output.is_some());
    }

    Ok(pset)
}

pub struct SigSingleInput {
    pub txid: elements_pset::Txid,
    pub vout: u32,
    pub asset: elements_pset::AssetId,
    pub value: u64,
    pub asset_bf: elements_pset::confidential::AssetBlindingFactor,
    pub value_bf: elements_pset::confidential::ValueBlindingFactor,
}

pub struct SigSingleOutput {
    pub address: elements_pset::Address,
    pub asset: elements_pset::AssetId,
    pub value: u64,
}

pub struct SigSingleMaker {
    pub tx: elements_pset::Transaction,
    pub output_asset_bf: elements_pset::confidential::AssetBlindingFactor,
    pub output_value_bf: elements_pset::confidential::ValueBlindingFactor,
    pub output_sender_sk: secp256k1::SecretKey,
}

pub fn sig_single_maker_tx(
    secp: &elements_pset::secp256k1_zkp::Secp256k1<elements_pset::secp256k1_zkp::All>,
    account: &Account,
    input: &SigSingleInput,
    output: &SigSingleOutput,
) -> Result<SigSingleMaker, anyhow::Error> {
    ensure!(input.value > 0);
    ensure!(output.value > 0);
    ensure!(output.address.blinding_pubkey.is_some());

    let rng = &mut rand::thread_rng();

    let txid = gdk_common::be::BETxid::Elements(
        elements::Txid::from_slice(input.txid.as_inner()).unwrap(),
    );
    let utxo = account
        .utxos(0, true)
        .map_err(|_| anyhow!("can't find UTXOs"))?
        .into_iter()
        .find(|utxo| utxo.0.vout() == input.vout && utxo.0.txid() == txid)
        .ok_or_else(|| anyhow!("UTXO not found"))?;

    let new_in = elements_pset::TxIn {
        previous_output: elements_pset::OutPoint {
            txid: input.txid,
            vout: input.vout,
        },
        is_pegin: false,
        has_issuance: false,
        script_sig: elements_pset::Script::default(),
        sequence: 0xffff_ffff,
        asset_issuance: Default::default(),
        witness: elements_pset::TxInWitness::default(),
    };

    let output_asset_bf = elements_pset::confidential::AssetBlindingFactor::new(rng);
    let output_value_bf = elements_pset::confidential::ValueBlindingFactor::new(rng);
    let sender_sk = secp256k1::SecretKey::new(rng);
    let sender_pk = secp256k1::PublicKey::from_secret_key(&secp, &sender_sk);
    let nonce = elements_pset::confidential::Nonce::Confidential(sender_pk);

    let new_out = elements_pset::TxOut {
        asset: elements_pset::confidential::Asset::new_confidential(
            secp,
            output.asset,
            output_asset_bf,
        ),
        value: elements_pset::confidential::Value::new_confidential_from_assetid(
            secp,
            output.value,
            output.asset,
            output_value_bf,
            output_asset_bf,
        ),
        nonce,
        script_pubkey: output.address.script_pubkey(),
        witness: elements_pset::TxOutWitness::default(),
    };

    let mut tx = elements_pset::Transaction {
        version: 2,
        lock_time: 0,
        input: vec![new_in],
        output: vec![new_out],
    };

    let out_point = elements::OutPoint {
        txid: elements::Txid::from_slice(&input.txid.into_inner()).unwrap(),
        vout: input.vout,
    };
    let store_read = account.store.read().unwrap();
    let acc_store = store_read.account_cache(account.num()).unwrap();
    let unblinded = acc_store
        .unblinded
        .get(&out_point)
        .ok_or_else(|| anyhow!("unblinded UTXO not found"))?;
    assert!(unblinded.value == input.value);
    assert!(unblinded.asset.into_inner() == input.asset.into_inner());

    let txid = elements::Txid::from_slice(input.txid.as_inner()).unwrap();
    let prev_tx = acc_store
        .get_liquid_tx(&txid)
        .map_err(|_| anyhow!("prev tx not found"))?;

    let private_key = account
        .xprv
        .derive_priv(&secp, &utxo.1.path)
        .unwrap()
        .private_key;
    let private_key =
        elements_pset::bitcoin::PrivateKey::from_str(&private_key.to_string()).unwrap();

    let prev_value = prev_tx.output[input.vout as usize].value;
    let prev_value = elements_pset::encode::deserialize::<elements_pset::confidential::Value>(
        &elements::encode::serialize(&prev_value),
    )
    .unwrap();

    let input_sign = sideswap_common::pset::internal_sign_elements(
        &secp,
        &tx,
        0,
        &private_key,
        prev_value,
        elements_pset::SigHashType::SinglePlusAnyoneCanPay,
    );
    let public_key = private_key.public_key(&secp);
    tx.input[0].script_sig = sideswap_common::pset::p2shwpkh_script_sig(&public_key);
    tx.input[0].witness.script_witness = vec![input_sign, public_key.to_bytes()];

    Ok(SigSingleMaker {
        tx,
        output_asset_bf,
        output_value_bf,
        output_sender_sk: sender_sk,
    })
}
