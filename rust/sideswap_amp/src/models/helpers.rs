use hex::FromHex;
use serde::{de::IntoDeserializer, Deserialize};

pub fn deserialize_hex<'de, D, T>(deserializer: D) -> Result<T, D::Error>
where
    D: serde::de::Deserializer<'de>,
    T: elements::encode::Decodable,
{
    let value = String::deserialize(deserializer)?;
    let value = Vec::<u8>::from_hex(&value).map_err(serde::de::Error::custom)?;
    let value = elements::encode::deserialize(&value).map_err(serde::de::Error::custom)?;
    Ok(value)
}

pub fn deserialize_nonce<'de, D>(deserializer: D) -> Result<elements::confidential::Nonce, D::Error>
where
    D: serde::de::Deserializer<'de>,
{
    let value = String::deserialize(deserializer)?;
    if value == "000000000000000000000000000000000000000000000000000000000000000000" {
        Ok(elements::confidential::Nonce::Null)
    } else {
        deserialize_hex(value.into_deserializer())
    }
}

pub fn deserialize_with_optional_empty_string<'de, D, T>(
    deserializer: D,
) -> Result<Option<T>, D::Error>
where
    D: serde::de::Deserializer<'de>,
    T: serde::de::DeserializeOwned,
{
    let value = String::deserialize(deserializer)?;
    if value.is_empty() {
        Ok(None)
    } else {
        let value = T::deserialize(value.into_deserializer())?;
        Ok(Some(value))
    }
}
