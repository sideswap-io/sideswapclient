use base64::Engine;

pub type Error = base64::DecodeError;

pub fn decode(v: &str) -> Result<Vec<u8>, Error> {
    base64::engine::general_purpose::STANDARD.decode(v)
}

pub fn encode(v: &[u8]) -> String {
    base64::engine::general_purpose::STANDARD.encode(v)
}
