use std::time::Duration;

#[derive(serde::Serialize)]
pub struct RequestMsg {
    text: String,
}

pub async fn send_once(text: &str, url: &str) -> Result<(), anyhow::Error> {
    let client = reqwest::Client::new();

    let msg = RequestMsg {
        text: text.to_owned(),
    };

    let resp = client
        .post(url)
        .json(&msg)
        .timeout(Duration::from_secs(10))
        .send()
        .await?
        .text()
        .await?;

    anyhow::ensure!(resp == "ok", "sending message failed: {}", &resp);
    Ok(())
}

pub async fn send_many(
    text: &str,
    url: &str,
    retry_count: u32,
    retry_delay: Duration,
) -> Result<(), anyhow::Error> {
    let mut count = 0;
    loop {
        let result = send_once(text, url).await;
        if result.is_ok() || count >= retry_count {
            return result;
        }
        log::error!("sending failed: {:?}", result);
        count += 1;
        tokio::time::sleep(retry_delay).await;
    }
}
