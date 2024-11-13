use std::path::Path;

const LOG_FILTER: &str =
    "debug,hyper=info,rustls=info,ureq=warn,sideswap_jade::transports::ble::uniffi_log=info";

const TIMESTAMP_FORMAT: &str = "%Y-%m-%d %H:%M:%S.%3f";

fn log_format(
    w: &mut dyn std::io::Write,
    now: &mut flexi_logger::DeferredNow,
    record: &log::Record,
) -> Result<(), std::io::Error> {
    let text = format!(
        "[{}] {} {} {}",
        now.format(TIMESTAMP_FORMAT),
        record.level(),
        record.module_path().unwrap_or("<unnamed>"),
        &record.args()
    );
    let line_limit = if cfg!(debug_assertions) {
        1024 * 1024
    } else {
        2 * 1024
    };
    let len = std::cmp::min(text.len(), line_limit);
    write!(w, "{}", &text.as_str()[..len])
}

pub fn init_log_with_name(work_dir: impl AsRef<Path>, name: &str) {
    let log_name = format!("{name}.log");
    let prev_log_name = format!("{name}_prev.log");

    let path = work_dir.as_ref().join(log_name);

    let file_size = std::fs::metadata(&path)
        .map(|metadata| metadata.len())
        .unwrap_or_default();
    if file_size > 50 * 1024 * 1024 {
        let path_old = work_dir.as_ref().join(prev_log_name);
        let _ = std::fs::rename(&path, path_old);
    }

    let stdout_level = if cfg!(debug_assertions) {
        flexi_logger::Duplicate::Debug
    } else {
        flexi_logger::Duplicate::Error
    };

    let _ = flexi_logger::Logger::try_with_str(LOG_FILTER)
        .unwrap()
        .format(log_format)
        .use_utc()
        .log_to_file(flexi_logger::FileSpec::try_from(path).unwrap())
        .append()
        .duplicate_to_stderr(stdout_level)
        .start();
}

pub fn init_log(work_dir: impl AsRef<Path>) {
    init_log_with_name(work_dir, "sideswap")
}
