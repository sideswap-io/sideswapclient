use std::time::Duration;

use sideswap_api::RequestId;

pub mod auto;
pub mod manual;
pub mod ws_req_sender;

static GLOBAL_REQUEST_ID: std::sync::atomic::AtomicI64 = std::sync::atomic::AtomicI64::new(1);

pub fn next_id() -> i64 {
    GLOBAL_REQUEST_ID.fetch_add(1, std::sync::atomic::Ordering::Relaxed)
}

pub fn next_request_id() -> RequestId {
    RequestId::Int(next_id())
}

const PING_PERIOD: Duration = Duration::from_secs(30);
const PONG_TIMEOUT: Duration = Duration::from_secs(90);
