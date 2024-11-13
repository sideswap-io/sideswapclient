use std::time::Duration;

#[derive(
    Debug, Copy, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, serde::Serialize, serde::Deserialize,
)]
pub struct DurationMs(u64);

impl DurationMs {
    pub fn duration(&self) -> Duration {
        Duration::from_millis(self.0)
    }

    pub fn as_millis(self) -> u64 {
        self.0
    }

    pub fn from_millis(value: u64) -> DurationMs {
        DurationMs(value)
    }
}

impl From<Duration> for DurationMs {
    fn from(value: Duration) -> Self {
        let value = value.as_millis();
        let value = if value > u64::MAX as u128 {
            u64::MAX
        } else {
            value as u64
        };
        DurationMs(value)
    }
}
