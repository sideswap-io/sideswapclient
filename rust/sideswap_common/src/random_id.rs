use rand::Rng;

pub fn hex_string(len: usize) -> String {
    assert!(len / 2 == 0);
    let mut arr = Vec::new();
    arr.resize(len / 2, 0u8);
    rand::thread_rng().fill(arr.as_mut_slice());
    hex::encode(arr)
}

pub fn alphanum_string(len: usize) -> String {
    rand::thread_rng()
        .sample_iter(&rand::distributions::Alphanumeric)
        .take(len)
        .map(char::from)
        .collect()
}
