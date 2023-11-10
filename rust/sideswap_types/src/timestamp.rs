// In milliseconds since UNIX epoch
#[derive(Debug, Copy, Clone, serde::Serialize, serde::Deserialize)]
pub struct Timestamp(u64);

impl Timestamp {
    pub fn from_time(time: std::time::SystemTime) -> Option<Self> {
        time.duration_since(std::time::UNIX_EPOCH)
            .ok()?
            .as_millis()
            .try_into()
            .ok()
            .map(Timestamp)
    }

    pub fn to_time(&self) -> std::time::SystemTime {
        std::time::UNIX_EPOCH + std::time::Duration::from_millis(self.0)
    }

    pub fn now() -> Self {
        Self::from_time(std::time::SystemTime::now()).expect("invalid SystemTime")
    }

    pub fn as_millis(self) -> u64 {
        self.0
    }
}
