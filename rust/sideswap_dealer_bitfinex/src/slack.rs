#[derive(serde::Serialize)]
pub struct SlackMsg {
    text: String,
}

pub fn send_slack_once(text: &str, url: &str) -> Result<(), anyhow::Error> {
    let http_client = ureq::AgentBuilder::new()
        .timeout(std::time::Duration::from_secs(10))
        .build();

    let msg = SlackMsg {
        text: text.to_owned(),
    };

    let resp = http_client.post(url).send_json(&msg)?.into_string()?;
    ensure!(resp == "ok", "sending message failed: {}", &resp);
    Ok(())
}

pub fn send_slack(
    text: &str,
    url: &str,
    retry_count: u32,
    retry_delay: std::time::Duration,
) -> Result<(), anyhow::Error> {
    let mut count = 0;
    loop {
        let result = send_slack_once(text, url);
        if result.is_ok() || count >= retry_count {
            return result;
        }
        error!("slack sending failed: {:?}", result);
        count += 1;
        std::thread::sleep(retry_delay);
    }
}
