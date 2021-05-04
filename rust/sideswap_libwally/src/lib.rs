use bitcoin::blockdata::script::Builder;
use bitcoin::hash_types::PubkeyHash;
use bitcoin::hashes::Hash;
use bitcoin::util::bip32::DerivationPath;
use bitcoin::{PublicKey, Script};
use ffi::size_t;
use gdk_common::session::Session;
use gdk_electrum::{interface::WalletCtx, ElectrumSession};
use std::collections::BTreeMap;
use std::ptr::{null, null_mut};
use std::str::FromStr;

#[macro_use]
extern crate log;

mod ffi;

pub fn check(result: i32) {
    assert!(result == ffi::WALLY_OK as i32);
}

pub fn reversed<T>(mut v: Vec<T>) -> Vec<T> {
    v.reverse();
    v
}

pub enum Env {
    Local,
    Regtest,
    Prod,
}

pub type RedeemScript = Vec<u8>;
pub struct PsbtInfo {
    pub send_asset: String,
    pub recv_asset: String,
    pub recv_amount: i64,
    pub change_amount: i64,
    pub utxos: Vec<gdk_common::model::UnspentOutput>,
}

pub struct PsbtKeys {
    pub priv_keys: BTreeMap<RedeemScript, bitcoin::PrivateKey>,
}

pub fn redeem_script(public_key: &PublicKey) -> Script {
    Builder::new()
        .push_int(0)
        .push_slice(&PubkeyHash::hash(&public_key.to_bytes())[..])
        .into_script()
}

pub fn generate_psbt(
    session: &ElectrumSession,
    psbt_info: &PsbtInfo,
) -> Result<(String, PsbtKeys), anyhow::Error> {
    struct Output {
        addr: gdk_common::model::AddressPointer,
        amount: i64,
        asset: String,
    };

    let mut opt = gdk_common::model::GetTransactionsOpt::default();
    opt.count = 10000;

    let mut keys = PsbtKeys {
        priv_keys: BTreeMap::new(),
    };

    let wallet = session.wallet.as_ref().unwrap();

    let txs = wallet.list_tx(&opt).unwrap();

    let mut outputs = vec![];

    if psbt_info.recv_amount > 0 {
        let new_address = session
            .get_receive_address(&serde_json::Value::Null)
            .unwrap();
        let recv_output = Output {
            addr: new_address,
            amount: psbt_info.recv_amount,
            asset: psbt_info.recv_asset.clone(),
        };
        outputs.push(recv_output);
    }

    if psbt_info.change_amount > 0 {
        let change_address = session
            .get_receive_address(&serde_json::Value::Null)
            .unwrap();
        let change_output = Output {
            addr: change_address,
            amount: psbt_info.change_amount,
            asset: psbt_info.send_asset.clone(),
        };
        outputs.push(change_output);
    }

    let inputs_allocation_len = psbt_info.utxos.len() as size_t;
    let outputs_allocation_len = outputs.len() as size_t;

    let psbt_version = 0;
    let tx_version = 2;
    let psbt_str_copy;

    unsafe {
        let mut psbt = null_mut();
        let mut tx = null_mut();

        check(ffi::wally_psbt_init_alloc(
            psbt_version,
            inputs_allocation_len,
            outputs_allocation_len,
            0,
            &mut psbt,
        ));
        check(ffi::wally_tx_init_alloc(
            tx_version,
            0,
            inputs_allocation_len,
            outputs_allocation_len,
            &mut tx,
        ));
        check(ffi::wally_psbt_set_global_tx(psbt, tx));

        let mut psbt_tx_input = null_mut();
        for (index, utxo) in psbt_info.utxos.iter().enumerate() {
            let prev_tx_meta = txs.iter().find(|t| t.txid == utxo.txhash).unwrap();
            let prev_tx_hash = reversed(hex::decode(&prev_tx_meta.txid).unwrap());
            let asset_id_unprefixed = reversed(hex::decode(&psbt_info.send_asset).unwrap());
            let mut prev_tx = null_mut();
            let prev_tx_hex = std::ffi::CString::new(prev_tx_meta.hex.as_bytes()).unwrap();
            check(ffi::wally_tx_from_hex(
                prev_tx_hex.as_ptr(),
                ffi::WALLY_TX_FLAG_USE_WITNESS | ffi::WALLY_TX_FLAG_USE_ELEMENTS,
                &mut prev_tx,
            ));
            let sequence = std::u32::MAX;
            check(ffi::wally_tx_elements_input_init_alloc(
                prev_tx_hash.as_ptr(),
                prev_tx_hash.len() as size_t,
                utxo.pt_idx,
                sequence,
                null(),
                0,
                null(),
                null(),
                0,
                null(),
                0,
                null(),
                0,
                null(),
                0,
                null(),
                0,
                null(),
                0,
                null(),
                &mut psbt_tx_input,
            ));
            check(ffi::wally_psbt_add_input_at(
                psbt,
                index as u32,
                ffi::WALLY_PSBT_FLAG_NON_FINAL,
                psbt_tx_input,
            ));

            let store = wallet.store.read().unwrap();
            let outpoint = elements::OutPoint {
                txid: elements::hash_types::Txid::from_str(&utxo.txhash).unwrap(),
                vout: utxo.pt_idx,
            };
            let unblineded = store.cache.unblinded.get(&outpoint).unwrap();

            let path = DerivationPath::from_str(&utxo.derivation_path).unwrap();
            let xprv = wallet.xprv.derive_priv(&wallet.secp, &path).unwrap();
            let private_key = &xprv.private_key;
            let public_key = &bitcoin::PublicKey::from_private_key(&wallet.secp, private_key);
            let redeem_script = redeem_script(public_key);
            let redeem_script = redeem_script.as_bytes();
            let input = (*psbt).inputs.offset(index as isize);

            keys.priv_keys
                .insert(redeem_script.to_vec(), private_key.clone());

            check(ffi::wally_psbt_input_set_abf(
                input,
                unblineded.abf.as_ptr(),
                unblineded.abf.len() as size_t,
            ));
            check(ffi::wally_psbt_input_set_vbf(
                input,
                unblineded.vbf.as_ptr(),
                unblineded.vbf.len() as size_t,
            ));
            check(ffi::wally_psbt_input_set_witness_utxo(
                input,
                (*prev_tx).outputs.offset(outpoint.vout as isize),
            ));
            check(ffi::wally_psbt_input_set_redeem_script(
                input,
                redeem_script.as_ptr(),
                redeem_script.len() as size_t,
            ));
            check(ffi::wally_psbt_input_set_value(input, utxo.satoshi));
            check(ffi::wally_psbt_input_set_asset(
                input,
                asset_id_unprefixed.as_ptr(),
                asset_id_unprefixed.len() as size_t,
            ));
        }

        for (index, output) in outputs.iter().enumerate() {
            let path =
                DerivationPath::from_str(&format!("m/{}/{}", 0, output.addr.pointer)).unwrap();
            let xprv = wallet.xprv.derive_priv(&wallet.secp, &path).unwrap();
            let private_key = &xprv.private_key;
            let public_key = &bitcoin::PublicKey::from_private_key(&wallet.secp, private_key);
            let redeem_script = redeem_script(public_key);
            let redeem_script = redeem_script.as_bytes();
            let output_ptr = (*psbt).outputs.offset(index as isize);

            let script_code = gdk_common::scripts::p2shwpkh_script(public_key);
            let script_code = elements::Script::from(script_code.as_bytes().to_owned());
            let private_blinding_key = gdk_common::wally::asset_blinding_key_to_ec_private_key(
                wallet.master_blinding.as_ref().unwrap(),
                &script_code,
            );
            let public_blinding_key =
                gdk_common::wally::ec_public_key_from_private_key(private_blinding_key.clone())
                    .serialize();

            let asset_id_prefixed =
                reversed(hex::decode(&format!("{}{}", &output.asset, "01")).unwrap());

            let mut value = vec![0; ffi::WALLY_TX_ASSET_CT_VALUE_UNBLIND_LEN as usize];
            check(ffi::wally_tx_confidential_value_from_satoshi(
                output.amount as u64,
                value.as_mut_ptr(),
                value.len() as size_t,
            ));

            let script_code = gdk_common::scripts::p2shwpkh_script(public_key);
            let script_code = script_code.as_bytes();

            let mut psbt_tx_output = null_mut();
            check(ffi::wally_tx_elements_output_init_alloc(
                script_code.as_ptr(),
                script_code.len() as size_t,
                asset_id_prefixed.as_ptr(),
                asset_id_prefixed.len() as size_t,
                value.as_ptr(),
                value.len() as size_t,
                null(),
                0,
                null(),
                0,
                null(),
                0,
                &mut psbt_tx_output,
            ));
            check(ffi::wally_psbt_add_output_at(
                psbt,
                index as u32,
                0,
                psbt_tx_output,
            ));

            check(ffi::wally_psbt_output_set_redeem_script(
                output_ptr,
                redeem_script.as_ptr(),
                redeem_script.len() as size_t,
            ));
            check(ffi::wally_psbt_output_set_blinding_pubkey(
                output_ptr,
                public_blinding_key.as_ptr(),
                public_blinding_key.len() as size_t,
            ));
        }

        (*psbt).magic[0] = 'p' as u8;
        (*psbt).magic[1] = 's' as u8;
        (*psbt).magic[2] = 'e' as u8;
        (*psbt).magic[3] = 't' as u8;
        (*psbt).magic[4] = 0xff as u8;

        let mut psbt_str = null_mut();
        check(ffi::wally_psbt_to_base64(psbt, 0, &mut psbt_str));
        psbt_str_copy = std::ffi::CString::from_raw(psbt_str)
            .to_str()
            .unwrap()
            .to_owned();
    }

    Ok((psbt_str_copy, keys))
}

pub fn sign_psbt(
    psbt: &str,
    wallet: &WalletCtx,
    details: &PsbtKeys,
) -> Result<String, anyhow::Error> {
    let psbt_str_copy;

    unsafe {
        let psbt_str = std::ffi::CString::new(psbt.as_bytes()).unwrap();
        let mut psbt = null_mut();
        check(ffi::wally_psbt_from_base64(psbt_str.as_ptr(), &mut psbt));

        let mut witness_copy = BTreeMap::new();

        let output_count = (*psbt).outputs_allocation_len as usize;
        for output_index in 0..output_count {
            let tx_out = (*(*psbt).tx).outputs.offset(output_index as isize);
            let psbt_out = (*psbt).outputs.offset(output_index as isize);
            (*tx_out).asset = (*psbt_out).asset_commitment;
            (*tx_out).value = (*psbt_out).value_commitment;
            (*tx_out).nonce = (*psbt_out).nonce;
            (*tx_out).asset_len = (*psbt_out).asset_commitment_len;
            (*tx_out).value_len = (*psbt_out).value_commitment_len;
            (*tx_out).nonce_len = (*psbt_out).nonce_len;
        }

        let input_count = (*psbt).inputs_allocation_len as usize;
        for input_index in 0..input_count {
            let input = (*psbt).inputs.offset(input_index as isize);
            let redeem_script = std::slice::from_raw_parts(
                (*input).redeem_script,
                (*input).redeem_script_len as usize,
            );
            if let Some(private_key) = details.priv_keys.get(redeem_script) {
                info!("found key for input {}", input_index);
                let public_key =
                    bitcoin::PublicKey::from_private_key(&wallet.secp, private_key).to_bytes();
                let private_key = private_key.to_bytes();
                let mut map = null_mut();
                check(ffi::wally_map_init_alloc(1, &mut map));
                check(ffi::wally_map_add(
                    map,
                    public_key.as_ptr(),
                    public_key.len() as size_t,
                    private_key.as_ptr(),
                    private_key.len() as size_t,
                ));
                check(ffi::wally_psbt_input_set_keypaths(input, map));
                check(ffi::wally_psbt_sign(
                    psbt,
                    private_key.as_ptr(),
                    private_key.len() as size_t,
                    ffi::EC_FLAG_GRIND_R,
                ));
                check(ffi::wally_psbt_finalize(psbt));

                let witness = *(*(*input).final_witness).items;
                let witness =
                    std::slice::from_raw_parts(witness.witness, witness.witness_len as usize)
                        .to_vec();
                info!("witness {}: {}", input_index, hex::encode(&witness));
                witness_copy.insert(input_index, witness);
            }
        }

        let mut psbt = null_mut();
        check(ffi::wally_psbt_from_base64(psbt_str.as_ptr(), &mut psbt));

        let input_count = (*psbt).inputs_allocation_len as usize;
        for input_index in 0..input_count {
            let input = (*psbt).inputs.offset(input_index as isize);
            let redeem_script = std::slice::from_raw_parts(
                (*input).redeem_script,
                (*input).redeem_script_len as usize,
            );
            if let Some(private_key) = details.priv_keys.get(redeem_script) {
                info!("found key for input {}", input_index);
                let public_key =
                    bitcoin::PublicKey::from_private_key(&wallet.secp, private_key).to_bytes();
                let private_key = private_key.to_bytes();
                let mut map = null_mut();
                check(ffi::wally_map_init_alloc(1, &mut map));
                check(ffi::wally_map_add(
                    map,
                    public_key.as_ptr(),
                    public_key.len() as size_t,
                    private_key.as_ptr(),
                    private_key.len() as size_t,
                ));
                check(ffi::wally_psbt_input_set_keypaths(input, map));
                check(ffi::wally_psbt_sign(
                    psbt,
                    private_key.as_ptr(),
                    private_key.len() as size_t,
                    ffi::EC_FLAG_GRIND_R,
                ));
            }
        }
        check(ffi::wally_psbt_finalize(psbt));

        for input_index in 0..input_count {
            if let Some(witness_copy) = witness_copy.get_mut(&input_index) {
                let input = (*psbt).inputs.offset(input_index as isize);
                let mut witness = &mut *(*(*input).final_witness).items;
                info!("copy witness...");
                witness.witness = witness_copy.as_mut_ptr();
                witness.witness_len = witness_copy.len() as size_t;
            }
        }

        let mut psbt_str = null_mut();
        check(ffi::wally_psbt_to_base64(psbt, 0, &mut psbt_str));

        psbt_str_copy = std::ffi::CString::from_raw(psbt_str)
            .to_str()
            .unwrap()
            .to_owned();

        info!("success");
    }

    Ok(psbt_str_copy)
}

const ENTROPY_SIZE_MNEMONIC12: usize = 16;

fn generate_mnemonic12_from_rng<R: rand::RngCore + rand::CryptoRng>(rng: &mut R) -> String {
    let mut key: [u8; ENTROPY_SIZE_MNEMONIC12] = [0; ENTROPY_SIZE_MNEMONIC12];
    rng.try_fill_bytes(&mut key)
        .expect("generating random bytes failed");
    let mut output = null_mut();
    unsafe {
        check(ffi::bip39_mnemonic_from_bytes(
            null(),
            key.as_ptr(),
            ENTROPY_SIZE_MNEMONIC12 as size_t,
            &mut output,
        ));
        let result = std::ffi::CStr::from_ptr(output)
            .to_str()
            .unwrap()
            .to_owned();
        ffi::wally_free_string(output);
        result
    }
}

pub fn generate_mnemonic12() -> String {
    let mut rng = rand::rngs::OsRng::new().expect("creating OsRng failed");
    generate_mnemonic12_from_rng(&mut rng)
}

pub fn verify_mnemonic(mnemonic: &str) -> bool {
    let mnemonic = std::ffi::CString::new(mnemonic).unwrap();
    unsafe {
        let result = ffi::bip39_mnemonic_validate(null(), mnemonic.as_ptr());
        result == ffi::WALLY_OK as i32
    }
}

pub fn get_network(env: Env) -> gdk_common::Network {
    match env {
        Env::Local => gdk_common::Network {
            name: "Electrum Liquid Regtest".to_owned(),
            network: "liquid-electrum-regtest".to_owned(),
            spv_enabled: Some(false),
            asset_registry_url: Some("https://assets.blockstream.info".to_owned()),
            asset_registry_onion_url: Some("http://vi5flmr4z3h3luup.onion".to_owned()),
            tls: Some(false),
            mainnet: false,
            liquid: true,
            development: true,
            tx_explorer_url: "https://blockstream.info/liquid/tx/".to_owned(),
            address_explorer_url: "https://blockstream.info/address/".to_owned(),
            electrum_url: Some("192.168.71.50:51401".to_owned()),
            policy_asset: Some(
                "2684bbac0fa7ad544ec8eee43c35156346e5d641d24a4b9d5d8f183e3f2d8fb9".to_owned(),
            ),
            ct_exponent: Some(0),
            ct_bits: Some(52),
            validate_domain: None,
            ct_min_value: None,
            sync_interval: None,
            spv_cross_validation: None,
            spv_cross_validation_servers: None,
        },
        Env::Regtest => gdk_common::Network {
            name: "Electrum Liquid Regtest".to_owned(),
            network: "liquid-electrum-regtest".to_owned(),
            spv_enabled: Some(false),
            asset_registry_url: Some("https://assets.blockstream.info".to_owned()),
            asset_registry_onion_url: Some("http://vi5flmr4z3h3luup.onion".to_owned()),
            tls: Some(false),
            mainnet: false,
            liquid: true,
            development: true,
            tx_explorer_url: "https://blockstream.info/liquid/tx/".to_owned(),
            address_explorer_url: "https://blockstream.info/address/".to_owned(),
            electrum_url: Some("api.sideswap.io:10402".to_owned()),
            policy_asset: Some(
                "2e16b12daf1244332a438e829ca7ce209195f8e1c54199770cd8b327710a8ab2".to_owned(),
            ),
            ct_exponent: Some(0),
            ct_bits: Some(52),
            validate_domain: None,
            ct_min_value: None,
            sync_interval: None,
            spv_cross_validation: None,
            spv_cross_validation_servers: None,
        },
        Env::Prod => gdk_common::Network {
            name: "Electrum Liquid".to_owned(),
            network: "liquid-electrum-mainnet".to_owned(),
            spv_enabled: Some(false),
            asset_registry_url: Some("https://assets.blockstream.info".to_owned()),
            asset_registry_onion_url: Some("http://vi5flmr4z3h3luup.onion".to_owned()),
            tls: Some(true),
            mainnet: true,
            liquid: true,
            development: false,
            tx_explorer_url: "https://blockstream.info/liquid/tx/".to_owned(),
            address_explorer_url: "https://blockstream.info/address/".to_owned(),
            electrum_url: Some("blockstream.info:995".to_owned()),
            policy_asset: Some(
                "6f0279e9ed041c3d710a9f57d0c02928416460c4b722ae3457a11eec381c526d".to_owned(),
            ),
            ct_exponent: Some(0),
            ct_bits: Some(52),
            validate_domain: None,
            ct_min_value: None,
            sync_interval: None,
            spv_cross_validation: None,
            spv_cross_validation_servers: None,
        },
    }
}

pub fn get_bitcoin_network(env: Env) -> gdk_common::Network {
    match env {
        Env::Local => unimplemented!(),
        Env::Regtest => unimplemented!(),
        Env::Prod => gdk_common::Network {
            name: "Bitcoin".to_owned(),
            network: "mainnet".to_owned(),
            spv_enabled: Some(false),
            asset_registry_url: None,
            asset_registry_onion_url: None,
            tls: Some(true),
            mainnet: true,
            liquid: false,
            development: false,
            tx_explorer_url: "https://blockstream.info/tx/".to_owned(),
            address_explorer_url: "https://blockstream.info/address/".to_owned(),
            electrum_url: Some("blockstream.info:700".to_owned()),
            policy_asset: None,
            ct_exponent: None,
            ct_bits: None,
            validate_domain: None,
            ct_min_value: None,
            sync_interval: None,
            spv_cross_validation: None,
            spv_cross_validation_servers: None,
        },
    }
}
