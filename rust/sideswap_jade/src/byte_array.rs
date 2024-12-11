// Serialized as hex in JSON and byte strings in CBOR
#[derive(Debug, Clone, Copy)]
pub struct ByteArray<const T: usize>(pub [u8; T]);

impl<const T: usize> std::fmt::LowerHex for ByteArray<T> {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        for ch in self.0 {
            write!(f, "{:02x}", ch)?;
        }
        Ok(())
    }
}

impl<const T: usize> std::fmt::Display for ByteArray<T> {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        std::fmt::LowerHex::fmt(self, f)
    }
}

impl<const T: usize> serde::Serialize for ByteArray<T> {
    fn serialize<S: serde::Serializer>(&self, s: S) -> Result<S::Ok, S::Error> {
        if s.is_human_readable() {
            s.collect_str(self)
        } else {
            s.serialize_bytes(&self.0)
        }
    }
}

impl<'de, const T: usize> serde::Deserialize<'de> for ByteArray<T> {
    fn deserialize<D: serde::Deserializer<'de>>(d: D) -> Result<Self, D::Error> {
        if d.is_human_readable() {
            let s = <&str>::deserialize(d)?;
            let mut bytes = [0u8; T];
            hex::decode_to_slice(s, &mut bytes).map_err(serde::de::Error::custom)?;
            Ok(Self(bytes))
        } else {
            use serde_bytes::Deserialize;
            Ok(Self(<[u8; T]>::deserialize(d)?))
        }
    }
}

pub type ByteArray32 = ByteArray<32>;
pub type ByteArray33 = ByteArray<33>;
