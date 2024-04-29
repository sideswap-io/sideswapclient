use bitcoin::bip32;
use serde::{Deserialize, Serialize};
use sideswap_api::{OrderId, SessionId};

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
pub struct SettingsPersistent {}

#[derive(Serialize, Deserialize, Default)]
pub struct AmpPrevAddrs {
    pub last_pointer: u32,
    pub list: Vec<crate::gdk_json::AddressInfo>,
}

#[derive(Serialize, Deserialize, Clone)]
pub struct WatchOnly {
    pub master_blinding_key: String,

    pub root_xpub: bip32::Xpub,
    pub password_xpub: bip32::Xpub,
    pub single_sig_account_xpub: bip32::Xpub,
    pub multi_sig_user_xpub: bip32::Xpub,

    pub username: String,
    pub password: String,
}

#[derive(Serialize, Deserialize, Clone)]
pub struct RegInfo {
    pub jade_watch_only: Option<WatchOnly>,
    pub multi_sig_service_xpub: String,
    pub multi_sig_user_path: Vec<u32>,
}

// All will be cleared after new wallet import!
#[derive(Serialize, Deserialize, Default)]
pub struct Settings {
    pub pegs: Option<Vec<Peg>>,
    pub device_key: Option<String>,

    #[serde(default)]
    pub single_sig_registered: [u32; 2],

    #[serde(default)]
    pub multi_sig_registered: u32,

    pub session_id: Option<SessionId>,
    pub amp_prev_addrs_v2: Option<AmpPrevAddrs>,
    pub master_pub_key: Option<bip32::Xpub>,

    pub reg_info_v3: Option<RegInfo>,
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
    std::fs::write(&file_path_tmp, data)?;
    std::fs::rename(&file_path_tmp, file_path)?;
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
