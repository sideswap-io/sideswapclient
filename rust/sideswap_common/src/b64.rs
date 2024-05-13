use base64::Engine;

pub fn decode(v: &str) -> Result<Vec<u8>, base64::DecodeError> {
    base64::engine::general_purpose::STANDARD.decode(v)
}

pub fn encode(v: &[u8]) -> String {
    base64::engine::general_purpose::STANDARD.encode(v)
}
