use axum::{http::StatusCode, response::IntoResponse, Json};
use sideswap_api::AssetId;

#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("unknown asset_id: {0}")]
    UnknownAsset(AssetId),
    #[error("submit failed: {0}")]
    SubmitFailed(String),
    #[error("insufficient funds, required: {required}, available: {available}")]
    InsufficientFunds { required: i64, available: i64 },
    #[error("unknown order")]
    UnknownOrder,
    #[error("too many active orders")]
    TooManyOrders,
}

#[derive(serde::Serialize, Clone)]
struct ErrorResponse {
    error_msg: String,
}

impl IntoResponse for Error {
    fn into_response(self) -> axum::response::Response {
        let error_resp: Json<ErrorResponse> = ErrorResponse {
            error_msg: self.to_string(),
        }
        .into();
        (StatusCode::BAD_REQUEST, error_resp).into_response()
    }
}
