use std::collections::HashMap;
use std::io::BufReader;
use std::time::{Duration, Instant};

use gdk_common::log::info;
use gdk_common::ureq;

use crate::Result;
use serde_json::Value;

/// Returns `None` if the response status is `304 Not Modified`.
pub(crate) fn call(
    url: &str,
    agent: &ureq::Agent,
    last_modified: &str,
    custom_params: &HashMap<String, String>,
) -> Result<Option<(Value, String)>> {
    let start = Instant::now();

    let mut request =
        agent.get(url).timeout(Duration::from_secs(30)).set("If-Modified-Since", last_modified);
    for param in custom_params {
        request = request.set(param.0, param.1);
    }
    let response = request.call()?;

    let status = response.status();

    info!("call to {} returned w/ status {} in {:?}", url, status, start.elapsed());

    if status == 304 {
        return Ok(None);
    }

    let last_modified = response
        .header("Last-Modified")
        .or_else(|| response.header("last-modified"))
        .unwrap_or_default()
        .to_string();

    // `respone.into_json()` is slow because of many syscalls. See:
    // https://github.com/algesten/ureq/pull/506.
    let buffered_reader = BufReader::new(response.into_reader());
    let value = serde_json::from_reader(buffered_reader)?;

    info!("END call {} {} took: {:?}", &url, status, start.elapsed());

    Ok(Some((value, last_modified)))
}
