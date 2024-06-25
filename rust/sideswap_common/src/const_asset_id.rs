/// Workaround for missing elements::AssetId const constructor
#[derive(Copy, Clone)]
pub struct ConstAssetId([u8; 32]);

impl ConstAssetId {
    /// Use for const initialization only.
    /// Panics if invalid string is supplied.
    pub const fn new(s: &str) -> Self {
        let mut data: [u8; 32] = hex_literal::decode::<32>(&[s.as_bytes()]);

        let mut left = 0;
        let mut right = data.len() - 1;
        while left < right {
            let tmp = data[left];
            data[left] = data[right];
            data[right] = tmp;
            left += 1;
            right -= 1;
        }

        Self(data)
    }

    pub fn asset_id(&self) -> elements::AssetId {
        elements::AssetId::from_inner(bitcoin::hashes::sha256::Midstate(self.0))
    }
}

#[macro_export]
macro_rules! asset_id {
    ($s:expr) => {
        sideswap_common::const_asset_id::ConstAssetId::new($s).asset_id()
    };
}

#[cfg(test)]
mod tests;
