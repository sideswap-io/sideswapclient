pub trait Cipher {
    type Error: std::error::Error + 'static;

    fn encrypt(&mut self, data: &[u8]) -> Vec<u8>;

    fn decrypt(&mut self, data: &[u8]) -> Result<Vec<u8>, Self::Error>;
}

pub mod aes;

#[cfg(test)]
mod tests;
