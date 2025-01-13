pub fn get_message(challenge: &str) -> String {
    format!("sideswap.io login, nonce: {challenge}")
}
