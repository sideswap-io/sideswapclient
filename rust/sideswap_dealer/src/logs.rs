use std::path::Path;

const DEFAULT: &str = include_str!("../config/log_config.toml");

pub fn init(work_dir: impl AsRef<Path>) {
    std::fs::create_dir_all(&work_dir).expect("must not fail");
    std::env::set_current_dir(work_dir).expect("must not fail");

    let log_config_default_path = "log_config_default.toml";
    let log_config_custom_path = "log_config.toml";
    let config_default = std::fs::read_to_string(log_config_default_path).unwrap_or_default();
    let config_custom = std::fs::read_to_string(log_config_custom_path).unwrap_or_default();

    // Overwrite custom config only if it's empty or has not changed (compared to the older content)
    let can_update_config = config_default == config_custom || config_custom.is_empty();
    if can_update_config {
        std::fs::write(log_config_custom_path, DEFAULT).expect("writing custom config file failed");
    }

    // Always overwrite default config for reference
    std::fs::write(log_config_default_path, DEFAULT).expect("writing default config file failed");

    log4rs::init_file(&log_config_custom_path, Default::default())
        .expect("can't open log settings");

    if !can_update_config {
        log::warn!("custom config file is used");
    }
}
