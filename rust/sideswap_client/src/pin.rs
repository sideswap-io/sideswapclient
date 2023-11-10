use std::str::FromStr;

#[derive(serde::Serialize, serde::Deserialize)]
pub struct PinData {
    pub salt: String,
    pub encrypted_data: String,
    pub pin_identifier: String,
}

pub const PIN_SERVER_URL: &str = "https://jadepin.blockstream.com";
pub const PIN_SERVER_PUBLIC_KEY: &str =
    "0332b7b1348bde8ca4b46b9dcc30320e140ca26428160a27bdbfc30b34ec87c547";

fn get_pin_client(proxy: Option<&String>) -> Result<gdk_pin_client::PinClient, anyhow::Error> {
    let agent = ureq::AgentBuilder::new();
    let agent = if let Some(proxy) = proxy {
        agent.proxy(ureq::Proxy::new(format!("socks5://{}", proxy))?)
    } else {
        agent
    }
    .build();

    Ok(gdk_pin_client::PinClient::new(
        agent,
        url::Url::parse(PIN_SERVER_URL).unwrap(),
        bitcoin::PublicKey::from_str(PIN_SERVER_PUBLIC_KEY).unwrap(),
    ))
}

pub fn decrypt_pin(
    details: &PinData,
    pin: String,
    proxy: Option<&String>,
) -> Result<String, anyhow::Error> {
    let pin = gdk_pin_client::Pin::from_str(&pin).unwrap();

    let json = serde_json::to_value(details)?;
    let data: gdk_pin_client::PinData = serde_json::from_value(json)?;

    let manager = get_pin_client(proxy)?;
    let mnemonic = manager.decrypt(&data, &pin)?;
    let mnemonic = std::string::String::from_utf8(mnemonic)?;

    Ok(mnemonic)
}

pub fn encrypt_pin(
    mnemonic: String,
    pin: String,
    proxy: Option<&String>,
) -> Result<PinData, anyhow::Error> {
    let pin = gdk_pin_client::Pin::from_str(&pin).unwrap();

    let manager = get_pin_client(proxy)?;
    let data = manager.encrypt(mnemonic.as_bytes(), &pin)?;

    let json = serde_json::to_value(data)?;
    let data = serde_json::from_value(json)?;

    Ok(data)
}
