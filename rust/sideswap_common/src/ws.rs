use std::time::Duration;

use sideswap_api::RequestId;

pub mod auto;
pub mod manual;
pub mod ws_req_sender;

static GLOBAL_REQUEST_ID: std::sync::atomic::AtomicI64 = std::sync::atomic::AtomicI64::new(1);

pub fn next_request_id() -> RequestId {
    RequestId::Int(GLOBAL_REQUEST_ID.fetch_add(1, std::sync::atomic::Ordering::Relaxed))
}

pub fn next_request_id_str() -> RequestId {
    RequestId::String(
        GLOBAL_REQUEST_ID
            .fetch_add(1, std::sync::atomic::Ordering::Relaxed)
            .to_string(),
    )
}

const RECONNECT_WAIT_PERIODS: [Duration; 6] = [
    Duration::from_secs(0),
    Duration::from_secs(1),
    Duration::from_secs(3),
    Duration::from_secs(9),
    Duration::from_secs(15),
    Duration::from_secs(30),
];
const RECONNECT_WAIT_MAX_PERIOD: Duration = Duration::from_secs(60);

const PING_PERIOD: Duration = Duration::from_secs(30);
const PONG_TIMEOUT: Duration = Duration::from_secs(90);
