use serde::{Deserialize, Serialize};
use sideswap_api::{OrderId, SessionId};
use std::collections::BTreeSet;

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
    pub session_id: Option<SessionId>,
}

impl Settings {
    pub fn get_persistent(&mut self) -> &mut SettingsPersistent {
        self.persistent
            .get_or_insert_with(|| SettingsPersistent::default())
    }
}

const SETTINGS_NAME: &str = "settings.json";
const SETTINGS_NAME_TMP: &str = "settings.json.tmp";

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

pub fn prune(_settings: &mut Settings) {}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_settings_load() {
        assert!(serde_json::from_str::<Settings>("{}").is_ok());
    }
}
