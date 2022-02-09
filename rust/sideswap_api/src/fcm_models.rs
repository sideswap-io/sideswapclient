use super::*;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
pub enum TxType {
    Send,
    Recv,
    Swap,
    Redeposit,
    Unknown,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct FcmMessageTx {
    pub txid: String,
    pub tx_type: TxType,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct FcmMessagePeg {
    pub order_id: OrderId,
    pub peg_in: bool,
    pub tx_hash: String,
    pub vout: i32,
    pub created_at: Timestamp,
    pub payout_txid: Option<String>,
    pub payout: i64,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct FcmMessageSign {
    pub order_id: OrderId,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct OrderCancelled {
    pub order_id: OrderId,
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "snake_case")]
pub enum FcmMessage {
    Tx(FcmMessageTx),
    PegDetected(FcmMessagePeg),
    PegPayout(FcmMessagePeg),
    Sign(FcmMessageSign),
    OrderCancelled(OrderCancelled),
}
