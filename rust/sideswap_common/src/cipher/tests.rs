use rand::Rng;

use super::{aes::AesCipher, Cipher};

fn generate_random_vector(n: usize) -> Vec<u8> {
    let mut rng = rand::thread_rng();
    (0..n).map(|_| rng.gen::<u8>()).collect()
}

fn test_cipher(mut cipher: impl Cipher) {
    let mut rng = rand::thread_rng();

    let data_len = rng.gen_range(1..1000);
    let data = generate_random_vector(data_len);

    let mut encrypted = cipher.encrypt(&data);
    let decrypted = cipher.decrypt(&encrypted).unwrap();
    assert_eq!(data, decrypted);

    for i in 0..encrypted.len() {
        let orig = encrypted[i];
        encrypted[i] = !orig;
        cipher.decrypt(&encrypted).unwrap_err();
        encrypted[i] = orig;
    }

    while !encrypted.is_empty() {
        encrypted.pop();
        cipher.decrypt(&encrypted).unwrap_err();
    }
}

#[test]
fn test_aes() {
    let key_len = rand::thread_rng().gen_range(1..100);
    let key = generate_random_vector(key_len);

    let cipher = AesCipher::new(&key);
    test_cipher(cipher);
}
