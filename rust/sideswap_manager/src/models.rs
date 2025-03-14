use sideswap_api::OrderId;
use sqlx::types::Text;

pub struct Peg {
    pub order_id: Text<OrderId>,
}

pub struct Swap {
    pub txid: Text<elements::Txid>,
}
