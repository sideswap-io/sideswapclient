use std::{error::Error, str::FromStr};

use bitcoin::{bip32::ChildNumber, hashes::Hash};
use secp256k1::global::SECP256K1 as secp1;
use secp256k1_zkp::global::SECP256K1 as secp2;
use wamp_async::{Client, ClientConfig, SerializerType};

pub async fn run() -> Result<(), Box<dyn Error>> {
    Ok(())
}
