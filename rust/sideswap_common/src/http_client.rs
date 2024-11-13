use std::time::Duration;

use serde::de::DeserializeOwned;

pub type Error = reqwest::Error;

pub struct HttpClient {
    timeout: Duration,
    reqwest: reqwest::Client,
}

impl Default for HttpClient {
    fn default() -> Self {
        Self::new()
    }
}

impl HttpClient {
    pub fn new() -> Self {
        let timeout = Duration::from_secs(30);
        let reqwest = reqwest::Client::new();
        Self { reqwest, timeout }
    }

    pub fn with_timeout(mut self, timeout: Duration) -> Self {
        self.timeout = timeout;
        self
    }

    pub async fn get_json<T: DeserializeOwned>(&self, url: &str) -> Result<T, Error> {
        tokio::time::timeout(self.timeout + Duration::from_secs(60), async {
            let resp = self
                .reqwest
                .get(url)
                .timeout(self.timeout)
                .send()
                .await?
                .json::<T>()
                .await?;
            Ok(resp)
        })
        .await
        .expect("bug in reqwest timeout handling")
    }
}
