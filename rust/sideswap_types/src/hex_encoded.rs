use elements::hex::FromHex;

#[derive(Debug, Clone)]
pub struct HexEncoded<T>(T);

impl<T> HexEncoded<T> {
    pub fn new(value: T) -> Self {
        Self(value)
    }

    pub fn into_inner(self) -> T {
        self.0
    }

    pub fn as_ref(&self) -> &T {
        &self.0
    }
}

impl<T> From<T> for HexEncoded<T> {
    fn from(value: T) -> Self {
        Self(value)
    }
}

impl<T: elements::encode::Encodable> serde::Serialize for HexEncoded<T> {
    fn serialize<S: serde::Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        serializer.serialize_str(&elements::encode::serialize_hex(&self.0))
    }
}

impl<'de, T: elements::encode::Decodable> serde::Deserialize<'de> for HexEncoded<T> {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        let hex = String::deserialize(deserializer)?;
        let vec = Vec::<u8>::from_hex(&hex).map_err(serde::de::Error::custom)?;
        let value = elements::encode::deserialize(&vec).map_err(serde::de::Error::custom)?;
        Ok(HexEncoded(value))
    }
}
