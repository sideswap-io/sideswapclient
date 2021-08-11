use serde::{Deserialize, Serialize};
use sideswap_api::OrderId;
use std::collections::{BTreeMap, BTreeSet};

#[derive(Eq, PartialEq, Serialize, Deserialize, Copy, Clone)]
pub enum PegDir {
    In,
    Out,
}

#[derive(Serialize, Deserialize)]
pub struct Peg {
    pub order_id: OrderId,
    pub dir: PegDir,
}

#[derive(Serialize, Deserialize)]
pub struct StoredUtxo {
    pub utxos: Vec<sideswap_libwally::UnspentOutput>,
    pub created_at: std::time::SystemTime,
}

#[derive(Serialize, Deserialize, Default)]
pub struct SettingsPersistent {
    pub unregister_phone_requests: Option<BTreeSet<sideswap_api::PhoneKey>>,
}

// All will be cleared after new wallet import!
#[derive(Serialize, Deserialize, Default)]
pub struct Settings {
    pub persistent: Option<SettingsPersistent>,

    pub pegs: Option<Vec<Peg>>,
    pub device_key: Option<String>,
    pub last_external: Option<u32>,
    pub last_internal: Option<u32>,
    pub utxos_req: Option<BTreeMap<OrderId, StoredUtxo>>,
    pub session_id: Option<String>,
}

impl Settings {
    pub fn get_persistent(&mut self) -> &mut SettingsPersistent {
        self.persistent
            .get_or_insert_with(|| SettingsPersistent::default())
    }
}

const SETTINGS_NAME: &str = "settings.json";
const SETTINGS_NAME_TMP: &str = "settings.json.tmp";

const EXPIRED_UTXOS: std::time::Duration = std::time::Duration::from_secs(24 * 60 * 60);

pub fn save_settings(
    settings: &Settings,
    data_dir: &std::path::PathBuf,
) -> Result<(), anyhow::Error> {
    let data = serde_json::to_string(&settings)?;
    let file_path = data_dir.join(SETTINGS_NAME);
    let file_path_tmp = std::path::Path::new(&data_dir).join(SETTINGS_NAME_TMP);
    std::fs::write(&file_path_tmp, &data)?;
    std::fs::rename(&file_path_tmp, &file_path)?;
    Ok(())
}

pub fn load_settings(data_dir: &std::path::PathBuf) -> Result<Settings, anyhow::Error> {
    let file_path = data_dir.join(SETTINGS_NAME);
    let data = std::fs::read(file_path)?;
    let settings = serde_json::from_slice::<Settings>(&data)?;
    Ok(settings)
}

pub fn prune(settings: &mut Settings) {
    let now = std::time::SystemTime::now();
    let utxos = settings.utxos_req.get_or_insert_with(|| BTreeMap::new());
    let expired = utxos
        .iter()
        .filter(|(_, utxo)| {
            now.duration_since(utxo.created_at)
                .unwrap_or(std::time::Duration::default())
                > EXPIRED_UTXOS
        })
        .map(|(order_id, _)| order_id.clone())
        .collect::<Vec<_>>();
    for order_id in expired {
        utxos.remove(&order_id);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_settings_load() {
        assert!(serde_json::from_str::<Settings>("{}").is_ok());
    }
}
