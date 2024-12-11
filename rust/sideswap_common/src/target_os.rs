pub enum TargetOs {
    Linux,
    Windows,
    MacOs,
    Android,
    IOS,
}

pub const fn target_os() -> TargetOs {
    if cfg!(target_os = "linux") {
        TargetOs::Linux
    } else if cfg!(target_os = "windows") {
        TargetOs::Windows
    } else if cfg!(target_os = "macos") {
        TargetOs::MacOs
    } else if cfg!(target_os = "android") {
        TargetOs::Android
    } else if cfg!(target_os = "ios") {
        TargetOs::IOS
    } else {
        panic!()
    }
}
