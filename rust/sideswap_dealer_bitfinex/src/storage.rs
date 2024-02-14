use super::types::Amount;
use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize, PartialEq, Eq, Clone, Copy)]
pub enum TransferState {
    SendUsdtNew,
    SendUsdtWaitConfirm,

    RecvUsdtNew,
    RecvUsdtWaitWithdrawId,
    RecvUsdtWaitConfirm,

    SendBtcNew,
    SendBtcWaitLbtcBalance,
    SendBtcWaitConfirm,

    RecvBtcNew,
    RecvBtcWaitLbtcBalance,
    RecvBtcWaitWithdrawId,
    RecvBtcWaitConfirm,

    Complete,
    Failed,
}

#[derive(Debug, Deserialize, Serialize, PartialEq, Eq)]
pub struct Transfer {
    pub withdraw_id: Option<i64>,
    pub state: TransferState,
    pub amount: Amount,
    pub created_at: std::time::SystemTime,
    pub updated_at: std::time::SystemTime,
    pub txid: Option<elements::Txid>,
}

#[derive(Debug, Deserialize, Serialize, PartialEq, Eq, Default)]
pub struct Storage {
    pub balancing: Option<Transfer>,
}
