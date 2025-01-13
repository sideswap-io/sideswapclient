use std::str::FromStr;

use anyhow::anyhow;

#[derive(serde::Serialize, serde::Deserialize)]
pub struct PinData {
    pub salt: String,
    pub encrypted_data: String,
    pub pin_identifier: String,
    pub hmac: Option<String>,
}

pub const PIN_SERVER_URL: &str = "https://jadepin.blockstream.com";
pub const PIN_SERVER_PUBLIC_KEY: &str =
    "0332b7b1348bde8ca4b46b9dcc30320e140ca26428160a27bdbfc30b34ec87c547";

#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("Wrong pin")]
    WrongPin,
    #[error("Network error: {0}")]
    NetworkError(anyhow::Error),
    #[error("Invalid data: {0}")]
    InvalidData(anyhow::Error),
}

impl From<gdk_pin_client::Error> for Error {
    fn from(value: gdk_pin_client::Error) -> Self {
        match value {
            err @ (gdk_pin_client::Error::InvalidHmac
            | gdk_pin_client::Error::BitcoinHexToBytesError(_)
            | gdk_pin_client::Error::Json(_)
            | gdk_pin_client::Error::Secp256k1(_)) => Error::InvalidData(err.into()),

            gdk_pin_client::Error::InvalidPin | gdk_pin_client::Error::Decryption(_) => {
                Error::WrongPin
            }

            err @ (gdk_pin_client::Error::HandshakeFailed
            | gdk_pin_client::Error::InvalidResponse
            | gdk_pin_client::Error::ServerCallFailed) => Error::NetworkError(err.into()),
        }
    }
}

fn get_pin_client(proxy: Option<&String>) -> Result<gdk_pin_client::PinClient, Error> {
    let agent = ureq::AgentBuilder::new();
    let agent = if let Some(proxy) = proxy {
        let proxy = ureq::Proxy::new(format!("socks5://{}", proxy))
            .map_err(|err| Error::InvalidData(anyhow!("Invalid proxy: {err}")))?;
        agent.proxy(proxy)
    } else {
        agent
    }
    .build();

    Ok(gdk_pin_client::PinClient::new(
        agent,
        url::Url::parse(PIN_SERVER_URL).expect("const must be valid"),
        bitcoin::PublicKey::from_str(PIN_SERVER_PUBLIC_KEY).expect("const must be valid"),
    ))
}

pub fn decrypt_pin(data: &str, pin: &str, proxy: Option<&String>) -> Result<String, Error> {
    let pin = gdk_pin_client::Pin::from(pin);
    let data = serde_json::from_str::<gdk_pin_client::PinData>(data)
        .map_err(|err| Error::InvalidData(anyhow!("Can't decrypt PinData: {err}")))?;
    let manager = get_pin_client(proxy)?;
    let mnemonic = manager.decrypt(&data, &pin)?;
    let mnemonic = std::string::String::from_utf8(mnemonic)
        .map_err(|err| Error::InvalidData(anyhow!("Invalid utf8 decrypted: {err}")))?;
    Ok(mnemonic)
}

pub fn encrypt_pin(mnemonic: &str, pin: &str, proxy: Option<&String>) -> Result<String, Error> {
    let pin = gdk_pin_client::Pin::from(pin);
    let manager = get_pin_client(proxy)?;
    let data = manager.encrypt(mnemonic.as_bytes(), &pin)?;
    let data = serde_json::to_string(&data).expect("must not fail");
    Ok(data)
}
