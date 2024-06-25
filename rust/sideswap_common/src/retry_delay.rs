use std::time::Duration;

use rand::Rng;

#[derive(Clone, Debug)]
pub struct RetryDelay {
    base: f64,
    max: f64,
    multiply: f64,
    spread: f64,
}

pub struct RetryDelayOptions {
    pub base: f64,
    pub max: f64,
    pub multiply: f64,
    pub spread: f64,
}

impl RetryDelay {
    pub fn new(options: RetryDelayOptions) -> Self {
        let RetryDelayOptions {
            base,
            max,
            multiply,
            spread,
        } = options;
        RetryDelay {
            base,
            max,
            multiply,
            spread,
        }
    }

    pub fn next_delay(&mut self) -> Duration {
        let mut rng = rand::thread_rng();
        let random = rng.gen_range(-self.spread..self.spread);
        let value = self.base * (1.0 + random);
        self.base = f64::min(self.max, value * self.multiply);
        Duration::from_secs_f64(value)
    }
}

impl Default for RetryDelay {
    fn default() -> Self {
        Self::new(RetryDelayOptions {
            base: 1.0,
            max: 15.0,
            multiply: 2.0,
            spread: 0.3,
        })
    }
}
