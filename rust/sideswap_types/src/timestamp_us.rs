// In microseconds since UNIX epoch
#[derive(
    Debug, Copy, Clone, serde::Serialize, serde::Deserialize, PartialEq, Eq, PartialOrd, Ord,
)]
pub struct TimestampUs(u64);

impl TimestampUs {
    pub fn from_micros(value: u64) -> TimestampUs {
        TimestampUs(value)
    }

    pub fn from_time(time: std::time::SystemTime) -> Option<TimestampUs> {
        time.duration_since(std::time::UNIX_EPOCH)
            .ok()?
            .as_micros()
            .try_into()
            .ok()
            .map(TimestampUs)
    }

    pub fn to_time(&self) -> std::time::SystemTime {
        std::time::UNIX_EPOCH + std::time::Duration::from_micros(self.0)
    }

    pub fn now() -> Self {
        Self::from_time(std::time::SystemTime::now()).expect("invalid SystemTime")
    }

    pub fn as_micros(self) -> u64 {
        self.0
    }
}
