use elements as elements_pset;
use std::str::FromStr;

pub const SERVER_FEE_SHARE: f64 = 0.002;
pub const SERVER_FEE_MIN: i64 = 200;

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
    let server_fee = (bitcoin_amount as f64 * SERVER_FEE_SHARE).round() as i64;
    if server_fee >= SERVER_FEE_MIN {
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
) -> Result<elements_pset::pset::Output, anyhow::Error> {
    let addr = elements_pset::Address::parse_with_params(addr, env.elements_params_pset())?;
    let blinding_pubkey = addr
        .blinding_pubkey
        .ok_or_else(|| anyhow!("only blinded addresses allowed"))?;
    ensure!(amount > 0);

    let txout = elements_pset::TxOut {
        asset: elements_pset::confidential::Asset::Explicit(
            elements_pset::AssetId::from_slice(&asset.0).unwrap(),
        ),
        value: elements_pset::confidential::Value::Explicit(amount as u64),
        nonce: elements_pset::confidential::Nonce::Confidential(blinding_pubkey),
        script_pubkey: addr.script_pubkey(),
        witness: elements_pset::TxOutWitness::default(),
    };
    let mut output = elements_pset::pset::Output::from_txout(txout);
    output.blinding_key =
        Some(elements_pset::bitcoin::PublicKey::from_str(&blinding_pubkey.to_string()).unwrap());
    output.blinder_index = Some(blinder_index);
    Ok(output)
}

// Copied from GDK
pub fn internal_sign_elements(
    secp: &elements_pset::secp256k1_zkp::Secp256k1<elements_pset::secp256k1_zkp::All>,
    tx: &elements_pset::Transaction,
    input_index: usize,
    private_key: &elements_pset::bitcoin::util::key::PrivateKey,
    value: elements_pset::confidential::Value,
    sighash_type: elements_pset::SigHashType,
) -> Vec<u8> {
    let public_key =
        &elements_pset::bitcoin::util::key::PublicKey::from_private_key(&secp, private_key);
    let script_code = p2pkh_script(public_key);
    let sighash = elements_pset::sighash::SigHashCache::new(tx).segwitv0_sighash(
        input_index,
        &script_code,
        value,
        sighash_type,
    );

    let message = elements_pset::secp256k1_zkp::Message::from_slice(&sighash[..]).unwrap();
    let signature = secp.sign(&message, &private_key.key);
    let mut signature = signature.serialize_der().to_vec();
    signature.push(sighash_type.as_u32() as u8);

    signature
}

// Copied from GDK
pub fn p2pkh_script(pk: &elements_pset::bitcoin::PublicKey) -> elements_pset::Script {
    elements_pset::Address::p2pkh(pk, None, &elements_pset::address::AddressParams::ELEMENTS)
        .script_pubkey()
}

// Copied from GDK
pub fn p2shwpkh_redeem_script(
    public_key: &elements_pset::bitcoin::util::key::PublicKey,
) -> elements_pset::bitcoin::Script {
    use elements_pset::bitcoin::hashes::Hash;
    elements_pset::bitcoin::blockdata::script::Builder::new()
        .push_int(0)
        .push_slice(
            &elements_pset::bitcoin::hash_types::PubkeyHash::hash(&public_key.to_bytes())[..],
        )
        .into_script()
}

// Copied from GDK
pub fn p2shwpkh_script_sig(
    public_key: &elements_pset::bitcoin::util::key::PublicKey,
) -> elements_pset::Script {
    elements_pset::script::Builder::new()
        .push_slice(p2shwpkh_redeem_script(public_key).as_bytes())
        .into_script()
}
