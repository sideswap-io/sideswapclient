// In milliseconds since UNIX epoch
#[derive(
    Debug, Copy, Clone, serde::Serialize, serde::Deserialize, PartialEq, Eq, PartialOrd, Ord,
)]
pub struct TimestampMs(u64);

impl TimestampMs {
    pub fn from_millis(value: u64) -> TimestampMs {
        TimestampMs(value)
    }

    pub fn from_time(time: std::time::SystemTime) -> Option<TimestampMs> {
        time.duration_since(std::time::UNIX_EPOCH)
            .ok()?
            .as_millis()
            .try_into()
            .ok()
            .map(TimestampMs)
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
