use bitcoin::hashes::hex::ToHex;
use bitcoin::hashes::Hash;
use gdk_common::be::BEOutPoint;
use gdk_common::be::BEScript;
use gdk_common::wally::{asset_blinding_key_to_ec_private_key, ec_public_key_from_private_key};
use gdk_electrum::account::Account;
use std::str::FromStr;

static SECP: once_cell::sync::OnceCell<secp256k1::Secp256k1<secp256k1::All>> =
    once_cell::sync::OnceCell::new();

pub fn secp() -> &'static secp256k1::Secp256k1<secp256k1::All> {
    SECP.get_or_init(|| {
        let mut ctx = secp256k1::Secp256k1::new();
        let mut rng = rand::thread_rng();
        ctx.randomize(&mut rng);
        ctx
    })
}

pub struct Amounts {
    pub send_asset: sideswap_api::AssetId,
    pub send_amount: u64,
    pub recv_asset: sideswap_api::AssetId,
    pub recv_amount: u64,
}

fn verify_amounts(amounts: &Amounts) -> Result<(), anyhow::Error> {
    ensure!(amounts.send_asset != amounts.recv_asset);
    Ok(())
}

fn verify_output(
    account: &Account,
    output: &elements::TxOut,
    expected_asset: &elements::AssetId,
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
    let secrets = output.unblind(secp(), blinding_key)?;
    ensure!(*expected_asset == secrets.asset, "unexpected asset");
    ensure!(expected_value == secrets.value, "unexpected value");
    Ok(())
}

#[allow(dead_code)]
fn verify_change_output(
    account: &Account,
    output: &elements::pset::Output,
    expected_asset: &elements::AssetId,
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
    account: &Account,
    amounts: &Amounts,
    pset: &elements::pset::PartiallySignedTransaction,
) -> Result<(), anyhow::Error> {
    if amounts.recv_amount == 0 {
        return Ok(());
    }
    let recv_asset = elements::AssetId::from_slice(&amounts.recv_asset.0).unwrap();
    let tx = pset.extract_tx()?;
    let recv_output = tx
        .output
        .iter()
        .find(|output| verify_output(account, output, &recv_asset, amounts.recv_amount).is_ok());
    ensure!(recv_output.is_some());
    Ok(())
}

pub fn verify_and_sign_pset(
    account: &Account,
    amounts: &Amounts,
    pset: &elements::pset::PartiallySignedTransaction,
) -> Result<elements::pset::PartiallySignedTransaction, anyhow::Error> {
    verify_amounts(amounts)?;
    verify_pset_recv_output(account, amounts, &pset)?;

    let mut pset = pset.clone();
    let send_asset = elements::AssetId::from_slice(&amounts.send_asset.0).unwrap();
    let tx = pset
        .extract_tx()
        .map_err(|e| anyhow!(format!("extracting transaction failed: {}", e)))?;

    if amounts.send_amount == 0 {
        return Ok(pset);
    }

    let store_read = account.store.read().unwrap();
    let acc_store = store_read.account_cache(account.num()).unwrap();

    let unspents = account
        .unspents()
        .map_err(|_| anyhow!("can't find utxos"))?;
    let utxos = unspents
        .into_iter()
        .map(|txout| account.txo(&txout).map(|txo| (txout, txo)))
        .collect::<Result<Vec<_>, _>>()?;
    let asset_utxos: std::collections::HashMap<BEOutPoint, gdk_common::model::Txo> = utxos
        .into_iter()
        .filter(|utxo| utxo.1.asset_id() == Some(send_asset))
        .collect();

    let mut inputs_amount = 0;
    for (index, input) in pset.inputs_mut().iter_mut().enumerate() {
        let out_point = elements::OutPoint {
            txid: elements::Txid::from_str(&input.previous_txid.to_string()).unwrap(),
            vout: input.previous_output_index,
        };
        let unblinded = acc_store.unblinded.get(&out_point);
        if let Some(unblinded) = unblinded {
            let utxo = asset_utxos
                .get(&BEOutPoint::Elements(out_point))
                .ok_or_else(|| anyhow!("UTXO not found"))?;

            assert!(unblinded.value == utxo.satoshi);
            assert!(unblinded.asset == utxo.asset_id().unwrap());
            inputs_amount += utxo.satoshi;

            let txid = elements::Txid::from_str(&input.previous_txid.to_string()).unwrap();
            let prev_tx = acc_store
                .get_liquid_tx(&txid)
                .map_err(|_| anyhow!("prev tx not found"))?;

            let private_key = account
                .xprv
                .as_ref()
                .unwrap()
                .derive_priv(secp(), &&utxo.user_path[3..])
                .unwrap()
                .private_key;

            let prev_value = prev_tx.output[input.previous_output_index as usize].value;
            let prev_value = elements::encode::deserialize::<elements::confidential::Value>(
                &elements::encode::serialize(&prev_value),
            )
            .unwrap();

            let input_sign = sideswap_common::pset::internal_sign_elements(
                secp(),
                &tx,
                index,
                &private_key,
                prev_value,
                elements::SigHashType::All,
            );
            let public_key = private_key.public_key(secp());
            input.final_script_sig = Some(sideswap_common::pset::p2shwpkh_script_sig(&public_key));
            input.final_script_witness = Some(vec![input_sign, public_key.to_bytes()]);
        }
    }

    ensure!(
        inputs_amount >= amounts.send_amount,
        "unexpected inputs amount"
    );
    let change_amount = inputs_amount - amounts.send_amount;
    let send_asset = elements::AssetId::from_slice(&amounts.send_asset.0).unwrap();
    if change_amount > 0 {
        let change_output = tx
            .output
            .iter()
            .find(|output| verify_output(account, output, &send_asset, change_amount).is_ok());
        ensure!(change_output.is_some());
    }

    Ok(pset)
}

pub struct SigSingleInput {
    pub asset: elements::AssetId,
    pub value: u64,
}

pub struct SigSingleOutput {
    pub asset: elements::AssetId,
    pub value: u64,
    pub address: elements::Address,
}

pub struct SigSingleMaker {
    pub tx: elements::Transaction,
    pub output_asset_bf: elements::confidential::AssetBlindingFactor,
    pub output_value_bf: elements::confidential::ValueBlindingFactor,
    pub output_sender_sk: secp256k1::SecretKey,
    pub input_prevout_script: Option<String>,
    pub chaining_tx: Option<MakerChainingTx>,
}

pub struct MakerChainingTx {
    pub input: sideswap_api::PsetInput,
    pub tx: elements::Transaction,
}

fn sig_single_maker_utxo(
    account: &Account,
    input: &SigSingleInput,
) -> Result<
    (
        gdk_common::model::Txo,
        elements::Transaction,
        Option<MakerChainingTx>,
    ),
    anyhow::Error,
> {
    let unspents = account
        .unspents()
        .map_err(|_| anyhow!("can't find utxos"))?;
    let utxos = unspents
        .into_iter()
        .map(|txout| account.txo(&txout))
        .collect::<Result<Vec<_>, _>>()?;
    if let Some(utxo) = utxos.iter().find(|utxo| {
        utxo.asset_id() == Some(input.asset)
            && utxo.satoshi == input.value
            && utxo.is_confidential()
    }) {
        let store_read = account.store.read().unwrap();
        let acc_store = store_read.account_cache(account.num()).unwrap();
        let previous_output = elements::OutPoint {
            txid: utxo.outpoint.txid().ref_elements().unwrap().clone(),
            vout: utxo.outpoint.vout(),
        };
        let prev_tx = acc_store
            .get_liquid_tx(&previous_output.txid)
            .map_err(|_| anyhow!("prev tx not found"))?;

        return Ok((utxo.clone(), prev_tx, None));
    };

    let recv_addr = account.get_next_address(false)?;

    let amount = gdk_common::model::AddressAmount {
        address: recv_addr.address.clone(),
        satoshi: input.value,
        asset_id: Some(input.asset.to_string()),
    };

    let mut create_tx_utxos = gdk_common::model::CreateTxUtxos::new();
    for utxo in utxos {
        create_tx_utxos
            .entry(utxo.asset_id().unwrap().to_string())
            .or_default()
            .push(gdk_common::model::CreateTxUtxo {
                txid: utxo.outpoint.txid().to_string(),
                vout: utxo.outpoint.vout(),
            });
    }

    let mut details = gdk_common::model::CreateTransaction {
        addressees: vec![amount],
        fee_rate: None,
        subaccount: account.account_num,
        send_all: false,
        previous_transaction: None,
        memo: None,
        utxos: create_tx_utxos,
        num_confs: 0,
        confidential_utxos_only: false,
        utxo_strategy: gdk_common::model::UtxoStrategy::Default,
    };

    let created_tx = account.create_tx(&mut details)?;
    let output_count = created_tx
        .transaction_outputs
        .iter()
        .filter(|txout| txout.user_path == recv_addr.user_path)
        .count();
    ensure!(output_count == 1);
    let (pt_idx, _output) = created_tx
        .transaction_outputs
        .iter()
        .enumerate()
        .filter(|(_, txout)| txout.user_path == recv_addr.user_path)
        .next()
        .unwrap();

    let signed_tx = account.sign(&created_tx)?;

    let tx = elements::encode::deserialize::<elements::Transaction>(&hex::decode(&signed_tx.hex)?)?;
    let tx_out = &tx.output[pt_idx];
    let script_pubkey = BEScript::from(&tx_out.script_pubkey);
    let store_read = account.store.read().unwrap();
    let acc_store = store_read.account_cache(account.num()).unwrap();
    let account_path = acc_store.get_path(&script_pubkey)?;
    let script = elements::Script::from(tx_out.script_pubkey.to_bytes());
    let blinding_key = gdk_common::wally::asset_blinding_key_to_ec_private_key(
        account.master_blinding.as_ref().unwrap(),
        &script,
    );
    let txoutsecrets = tx_out.unblind(secp(), blinding_key)?;
    assert!(txoutsecrets.asset == input.asset);
    assert!(txoutsecrets.value == input.value);
    let txoutcommitments = Some((tx_out.asset, tx_out.value, tx_out.nonce));
    let chaining_tx_txid = tx.txid();
    let public_key = account.public_key(account_path);
    let redeem_script = sideswap_common::pset::p2shwpkh_redeem_script(&public_key).to_hex();

    let chaining_tx = MakerChainingTx {
        input: sideswap_api::PsetInput {
            txid: sideswap_api::Hash32::from_slice(&tx.txid().into_inner()).unwrap(),
            vout: pt_idx as u32,
            asset: sideswap_api::Hash32::from_slice(&txoutsecrets.asset.into_inner()).unwrap(),
            asset_bf: sideswap_api::Hash32::from_slice(txoutsecrets.asset_bf.into_inner().as_ref())
                .unwrap(),
            value: txoutsecrets.value,
            value_bf: sideswap_api::Hash32::from_slice(txoutsecrets.value_bf.into_inner().as_ref())
                .unwrap(),
            redeem_script: Some(redeem_script),
        },
        tx: tx.clone(),
    };

    let txo = gdk_common::model::Txo {
        outpoint: BEOutPoint::Elements(elements::OutPoint::new(chaining_tx_txid, pt_idx as u32)),
        height: None,
        public_key,
        script_pubkey,
        script_code: account.script_code(account_path),
        subaccount: account.account_num,
        script_type: account.script_type.clone(),
        user_path: account.get_full_path(&account_path).into(),
        satoshi: txoutsecrets.value,
        sequence: None,
        txoutsecrets: Some(txoutsecrets),
        txoutcommitments,
    };

    Ok((txo, tx, Some(chaining_tx)))
}

pub fn sig_single_maker_tx(
    account: &Account,
    input: &SigSingleInput,
    output: &SigSingleOutput,
) -> Result<SigSingleMaker, anyhow::Error> {
    ensure!(input.value > 0);
    ensure!(output.value > 0);
    ensure!(output.address.blinding_pubkey.is_some());

    let rng = &mut rand::thread_rng();

    let (utxo, prev_tx, chaining_tx) = sig_single_maker_utxo(account, input)?;

    assert!(utxo.satoshi == input.value);
    assert!(utxo.asset_id() == Some(input.asset));

    let previous_output = elements::OutPoint {
        txid: utxo.outpoint.txid().ref_elements().unwrap().clone(),
        vout: utxo.outpoint.vout(),
    };

    let new_in = elements::TxIn {
        previous_output,
        is_pegin: false,
        has_issuance: false,
        script_sig: elements::Script::default(),
        sequence: 0xffff_ffff,
        asset_issuance: Default::default(),
        witness: elements::TxInWitness::default(),
    };

    let output_asset_bf = elements::confidential::AssetBlindingFactor::new(rng);
    let output_value_bf = elements::confidential::ValueBlindingFactor::new(rng);
    let sender_sk = secp256k1::SecretKey::new(rng);
    let sender_pk = secp256k1::PublicKey::from_secret_key(secp(), &sender_sk);
    let nonce = elements::confidential::Nonce::Confidential(sender_pk);

    let new_out = elements::TxOut {
        asset: elements::confidential::Asset::new_confidential(
            secp(),
            output.asset,
            output_asset_bf,
        ),
        value: elements::confidential::Value::new_confidential_from_assetid(
            secp(),
            output.value,
            output.asset,
            output_value_bf,
            output_asset_bf,
        ),
        nonce,
        script_pubkey: output.address.script_pubkey(),
        witness: elements::TxOutWitness::default(),
    };

    let mut tx = elements::Transaction {
        version: 2,
        lock_time: 0,
        input: vec![new_in],
        output: vec![new_out],
    };

    let private_key = account
        .xprv
        .as_ref()
        .unwrap()
        .derive_priv(secp(), &&utxo.user_path[3..])
        .unwrap()
        .private_key;

    let prev_value = prev_tx.output[previous_output.vout as usize].value;

    let input_sign = sideswap_common::pset::internal_sign_elements(
        secp(),
        &tx,
        0,
        &private_key,
        prev_value,
        elements::SigHashType::SinglePlusAnyoneCanPay,
    );
    let public_key = private_key.public_key(secp());
    tx.input[0].script_sig = sideswap_common::pset::p2shwpkh_script_sig(&public_key);
    tx.input[0].witness.script_witness = vec![input_sign, public_key.to_bytes()];

    Ok(SigSingleMaker {
        tx,
        output_asset_bf,
        output_value_bf,
        output_sender_sk: sender_sk,
        input_prevout_script: None,
        chaining_tx,
    })
}

pub fn generate_fake_p2sh_address(env: sideswap_common::env::Env) -> elements::Address {
    let pk_hex = "020000000000000000000000000000000000000000000000000000000000000001";
    let pk = elements::bitcoin::ecdsa::PublicKey::from_str(pk_hex).unwrap();
    let blinder = secp256k1::PublicKey::from_str(pk_hex).unwrap();
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
