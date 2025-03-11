use elements::AssetId;
use sideswap_common::{
    b64,
    dealer_ticker::{DealerTicker, InvalidTickerError},
    ws::ws_req_sender,
};
use sideswap_types::asset_precision::AssetPrecision;

use crate::api;

#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("Invalid address: {0}: {1}")]
    InvalidAddress(String, anyhow::Error),
    #[error(transparent)]
    InvalidTicker(#[from] InvalidTickerError),
    #[error("Unknown ticker: {0}")]
    UnknownTicker(DealerTicker),
    #[error("Channel closed, please report bug")]
    ChannelClosed,
    #[error("RPC error: {0}")]
    Rpc(anyhow::Error),
    #[error("WS error: {0}")]
    WsError(#[from] ws_req_sender::Error),
    #[error("Invalid asset amount: {0} (asset_precison: {1})")]
    InvalidAssetAmount(f64, AssetPrecision),
    #[error("Can't find market")]
    NoMarket,
    #[error(
        "Not enough amount for asset {asset_id}, required: {required}, available: {available}"
    )]
    NotEnoughAmount {
        asset_id: AssetId,
        required: u64,
        available: u64,
    },
    #[error("Quote error: {0}")]
    QuoteError(String),
    #[error("Base64 error: {0}")]
    Base64(#[from] b64::Error),
    #[error("Encode error: {0}")]
    EncodeError(#[from] elements::encode::Error),
    #[error("PSET error: {0}")]
    PsetError(#[from] elements::pset::Error),
}

impl From<tokio::sync::oneshot::error::RecvError> for Error {
    fn from(_value: tokio::sync::oneshot::error::RecvError) -> Self {
        Error::ChannelClosed
    }
}

impl<T> From<tokio::sync::mpsc::error::SendError<T>> for Error {
    fn from(_value: tokio::sync::mpsc::error::SendError<T>) -> Self {
        Error::ChannelClosed
    }
}

impl Error {
    pub fn error_code(&self) -> api::ErrorCode {
        match self {
            Error::InvalidAddress(_, _)
            | Error::InvalidTicker(_)
            | Error::UnknownTicker(_)
            | Error::ChannelClosed
            | Error::Rpc(_)
            | Error::WsError(_)
            | Error::InvalidAssetAmount(_, _)
            | Error::NoMarket
            | Error::NotEnoughAmount { .. }
            | Error::QuoteError(_)
            | Error::Base64(_)
            | Error::EncodeError(_)
            | Error::PsetError(_) => api::ErrorCode::InvalidRequest,
        }
    }
}

impl Into<api::Error> for Error {
    fn into(self) -> api::Error {
        api::Error {
            text: self.to_string(),
            code: self.error_code(),
            details: None,
        }
    }
}
