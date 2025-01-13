#[derive(Debug, Copy, Clone)]
pub enum TargetOs {
    Linux,
    Windows,
    MacOs,
    Android,
    IOS,
}

impl TargetOs {
    pub const fn get() -> TargetOs {
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

    pub const fn is_mobile(self) -> bool {
        match self {
            TargetOs::Linux | TargetOs::Windows | TargetOs::MacOs => false,
            TargetOs::Android | TargetOs::IOS => true,
        }
    }
}
