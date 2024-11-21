use std::path::Path;

use serde::{Deserialize, Serialize};

#[derive(Default, Serialize, Deserialize)]
pub struct Data {
    pub token: Option<String>,
}

const STATE_FILE_NAME: &str = "state.json";
const TMP_FILE_NAME: &str = "state.tmp";

pub fn save(work_dir: impl AsRef<Path>, state: &Data) {
    let tmp_path = work_dir.as_ref().join(TMP_FILE_NAME);
    let state = serde_json::to_string(&state).expect("must not fail");
    std::fs::write(&tmp_path, state).expect("must not fail");
    let file_path = work_dir.as_ref().join(STATE_FILE_NAME);
    std::fs::rename(tmp_path, file_path).expect("must not fail");
}

pub fn load(work_dir: impl AsRef<Path>) -> Data {
    let file_path = work_dir.as_ref().join(STATE_FILE_NAME);
    let res = std::fs::read_to_string(file_path);
    match res {
        Ok(data) => {
            log::info!("load state from existing file ({} bytes)", data.len());
            serde_json::from_str(&data).expect("must not fail")
        }
        Err(err) if err.kind() == std::io::ErrorKind::NotFound => {
            log::info!("state file not found, create a new one");
            Data::default()
        }
        Err(err) => {
            panic!("unexpected state load error: {err}");
        }
    }
}
