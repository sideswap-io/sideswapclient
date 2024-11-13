use std::path::{Path, PathBuf};

use serde::{de::DeserializeOwned, Serialize};

use crate::cipher::Cipher;

type Hash = blake3::Hash;

pub struct FileCache<D, C> {
    file_path: PathBuf,
    data: D,
    cipher: C,
    old_hash: Hash,
}

#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),
    #[error("Cipher error: {0}")]
    Cipher(Box<dyn std::error::Error>),
    #[error("Ciborium error: {0}")]
    Ciborium(Box<dyn std::error::Error>),
}

impl<D: Default + Serialize + DeserializeOwned, C: Cipher> FileCache<D, C> {
    pub fn new(file_path: PathBuf, mut cipher: C) -> Self {
        let (data, old_hash) = load::<D>(&file_path, &mut cipher).unwrap_or_else(|err| {
            log::warn!("loading cache failed: {err}");
            (D::default(), Hash::from_bytes([0; 32]))
        });

        Self {
            file_path,
            data,
            cipher,
            old_hash,
        }
    }

    pub fn save(&mut self) -> Result<usize, Error> {
        let (new_hash, size) = save(
            &self.file_path,
            &mut self.cipher,
            &self.data,
            &self.old_hash,
        )?;

        self.old_hash = new_hash;

        Ok(size)
    }

    pub fn data(&self) -> &D {
        &self.data
    }

    pub fn data_mut(&mut self) -> &mut D {
        &mut self.data
    }
}

fn load<D: DeserializeOwned>(
    file_path: &Path,
    cipher: &mut impl Cipher,
) -> Result<(D, Hash), Error> {
    let encrypted = std::fs::read(file_path)?;
    let decrypted = cipher
        .decrypt(&encrypted)
        .map_err(|err| Error::Cipher(Box::new(err)))?;
    let hash = hash(&decrypted);
    let cache = ciborium::from_reader::<D, _>(decrypted.as_slice())
        .map_err(|err| Error::Ciborium(Box::new(err)))?;
    Ok((cache, hash))
}

fn save<D: Serialize>(
    file_path: &Path,
    cipher: &mut impl Cipher,
    data: &D,
    old_hash: &Hash,
) -> Result<(Hash, usize), Error> {
    let mut decrypted = Vec::<u8>::new();
    ciborium::into_writer(&data, &mut decrypted).expect("must not fail");
    let hash = hash(&decrypted);
    if hash.as_bytes() != old_hash.as_bytes() {
        let encrypted = cipher.encrypt(&decrypted);
        std::fs::write(file_path, &encrypted)?;
    }
    Ok((hash, decrypted.len()))
}

fn hash(decrypted: &[u8]) -> Hash {
    blake3::hash(decrypted)
}
