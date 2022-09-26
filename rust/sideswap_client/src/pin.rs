// This code is copied from GDK

use block_modes::BlockMode;
use std::str::FromStr;

pub struct PinGetDetails {
    pub salt: String,
    pub encrypted_data: String,
    pub pin_identifier: String,
}

pub struct PinSetDetails {
    pub pin: String,
    pub mnemonic: String,
    pub device_id: String,
}

pub const PIN_SERVER_URL: &str = "https://jadepin.blockstream.com";
pub const PIN_SERVER_PUBLIC_KEY: &str =
    "0332b7b1348bde8ca4b46b9dcc30320e140ca26428160a27bdbfc30b34ec87c547";

pub fn decrypt_pin(pin: String, details: &PinGetDetails) -> Result<String, anyhow::Error> {
    let agent = ureq::agent();
    let manager = gdk_electrum::pin::PinManager::new(
        agent,
        PIN_SERVER_URL,
        &bitcoin::PublicKey::from_str(PIN_SERVER_PUBLIC_KEY).unwrap(),
    )?;
    let client_key = secp256k1::SecretKey::from_slice(&hex::decode(&details.pin_identifier)?)?;
    let server_key = manager.get_pin(pin.as_bytes(), &client_key)?;
    let iv = hex::decode(&details.salt)?;
    let decipher = gdk_electrum::Aes256Cbc::new_from_slices(&server_key[..], &iv).unwrap();
    let mnemonic = decipher.decrypt_vec(&hex::decode(&details.encrypted_data)?)?;
    let mnemonic = std::string::String::from_utf8(mnemonic)?;
    Ok(mnemonic)
}

pub fn encrypt_pin(details: &PinSetDetails) -> Result<PinGetDetails, anyhow::Error> {
    let agent = ureq::agent();
    let manager = gdk_electrum::pin::PinManager::new(
        agent,
        PIN_SERVER_URL,
        &bitcoin::PublicKey::from_str(PIN_SERVER_PUBLIC_KEY).unwrap(),
    )?;
    let client_key = secp256k1::SecretKey::new(&mut rand::thread_rng());
    let server_key = manager.set_pin(details.pin.as_bytes(), &client_key)?;
    let iv = rand::Rng::gen::<[u8; 16]>(&mut rand::thread_rng());
    let cipher = gdk_electrum::Aes256Cbc::new_from_slices(&server_key[..], &iv).unwrap();
    let encrypted = cipher.encrypt_vec(details.mnemonic.as_bytes());

    let result = PinGetDetails {
        salt: hex::encode(&iv),
        encrypted_data: hex::encode(&encrypted),
        pin_identifier: hex::encode(&client_key[..]),
    };
    Ok(result)
}
