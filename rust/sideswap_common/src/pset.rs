use std::str::FromStr;

use bitcoin::hashes::Hash;

/// Server fee that clients pay to the server for each swap.
/// For swap markets it's applied to both sides (0.1% each side).
/// For instant swaps it's applied to dealers.
pub const INSTANT_SWAPS_SERVER_FEE: f64 = 0.002;

/// If the server fee for an instant swap/regular swap is less than 200 sat
/// (total LBTC amount is less than 0.001), then the server fee is skipped
pub const INSTANT_SWAPS_SERVER_FEE_MIN: i64 = 200;

pub fn get_recv_amount(
    client_send_bitcoins: bool,
    send_amount: i64,
    raw_price: f64,
    fixed_fee: i64,
) -> i64 {
    if client_send_bitcoins {
        ((send_amount - fixed_fee) as f64 * raw_price).round() as i64
    } else {
        (send_amount as f64 / raw_price).round() as i64 - fixed_fee
    }
}

pub fn get_send_amount(
    client_send_bitcoins: bool,
    recv_amount: i64,
    raw_price: f64,
    fixed_fee: i64,
) -> i64 {
    if client_send_bitcoins {
        (recv_amount as f64 / raw_price).round() as i64 + fixed_fee
    } else {
        ((recv_amount + fixed_fee) as f64 * raw_price).round() as i64
    }
}

pub fn get_bitcoin_amount(
    client_send_bitcoins: bool,
    send_amount: i64,
    raw_price: f64,
    fixed_fee: i64,
) -> i64 {
    if client_send_bitcoins {
        send_amount - fixed_fee
    } else {
        (send_amount as f64 / raw_price).round() as i64 - fixed_fee
    }
}

pub fn get_server_fee(bitcoin_amount: i64) -> Option<i64> {
    let server_fee = (bitcoin_amount as f64 * INSTANT_SWAPS_SERVER_FEE).round() as i64;
    if server_fee >= INSTANT_SWAPS_SERVER_FEE_MIN {
        Some(server_fee)
    } else {
        None
    }
}

pub fn get_output(
    env: crate::env::Env,
    addr: &str,
    asset: &sideswap_api::AssetId,
    amount: i64,
    blinder_index: u32,
) -> Result<elements::pset::Output, anyhow::Error> {
    let addr = elements::Address::parse_with_params(addr, env.elements_params())?;
    let blinding_pubkey = addr
        .blinding_pubkey
        .ok_or_else(|| anyhow!("only blinded addresses allowed"))?;
    ensure!(amount > 0);

    let txout = elements::TxOut {
        asset: elements::confidential::Asset::Explicit(*asset),
        value: elements::confidential::Value::Explicit(amount as u64),
        nonce: elements::confidential::Nonce::Confidential(blinding_pubkey),
        script_pubkey: addr.script_pubkey(),
        witness: elements::TxOutWitness::default(),
    };
    let mut output = elements::pset::Output::from_txout(txout);
    output.blinding_key =
        Some(elements::bitcoin::PublicKey::from_str(&blinding_pubkey.to_string()).unwrap());
    output.blinder_index = Some(blinder_index);
    Ok(output)
}

// Copied from GDK
pub fn internal_sign_elements(
    secp: &elements::secp256k1_zkp::Secp256k1<elements::secp256k1_zkp::All>,
    tx: &elements::Transaction,
    input_index: usize,
    private_key: &elements::bitcoin::PrivateKey,
    value: elements::confidential::Value,
    sighash_type: elements::EcdsaSighashType,
) -> Vec<u8> {
    let public_key = &elements::bitcoin::PublicKey::from_private_key(secp, private_key);
    let script_code = p2pkh_script(public_key);
    let sighash = elements::sighash::SighashCache::new(tx).segwitv0_sighash(
        input_index,
        &script_code,
        value,
        sighash_type,
    );

    let message = elements::secp256k1_zkp::Message::from_digest_slice(&sighash[..]).unwrap();
    let signature = secp.sign_ecdsa(&message, &private_key.inner);
    let mut signature = signature.serialize_der().to_vec();
    signature.push(sighash_type.as_u32() as u8);

    signature
}

// Copied from GDK
pub fn p2pkh_script(pk: &elements::bitcoin::PublicKey) -> elements::Script {
    elements::Address::p2pkh(pk, None, &elements::address::AddressParams::ELEMENTS).script_pubkey()
}

// Copied from GDK
pub fn p2shwpkh_redeem_script(public_key: &elements::bitcoin::PublicKey) -> elements::Script {
    elements::script::Builder::new()
        .push_int(0)
        .push_slice(&elements::bitcoin::PubkeyHash::hash(&public_key.to_bytes()).to_byte_array())
        .into_script()
}

// Copied from GDK
pub fn p2shwpkh_script_sig(public_key: &elements::bitcoin::PublicKey) -> elements::Script {
    elements::script::Builder::new()
        .push_slice(p2shwpkh_redeem_script(public_key).as_bytes())
        .into_script()
}

pub fn copy_tx_signatures(
    tx: &elements::Transaction,
    pset: &mut elements::pset::PartiallySignedTransaction,
) {
    for (tx_input, pset_input) in tx.input.iter().zip(pset.inputs_mut()) {
        pset_input.final_script_sig = Some(tx_input.script_sig.clone());
        pset_input.final_script_witness = Some(tx_input.witness.script_witness.clone());
    }
}
