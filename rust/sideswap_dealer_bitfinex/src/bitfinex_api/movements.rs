use crate::bitfinex_worker::Movement;

use super::*;

#[derive(Serialize)]
pub struct MovementsRequest {
    #[serde(skip_serializing_if = "Option::is_none")]
    pub start: Option<i64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub end: Option<i64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub limit: Option<i32>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct Movements {
    pub success: bool,
    pub movements: Vec<Movement>,
}

pub type MovementsResponse = Vec<Movement>;

impl ApiCall for MovementsRequest {
    type Response = MovementsResponse;

    fn api_path() -> &'static str {
        "v2/auth/r/movements/hist"
    }

    fn parse(value: serde_json::Value) -> Result<Self::Response, anyhow::Error> {
        // https://docs.bitfinex.com/reference/rest-auth-movements
        let values = value.as_array().ok_or_else(|| anyhow!("array expected"))?;
        values
            .iter()
            .map(|item| -> Result<Movement, anyhow::Error> {
                let list = item.as_array().ok_or_else(|| anyhow!("array expected"))?;
                Ok(Movement {
                    id: get_i64(list, 0),
                    currency: get_string(list, 1),
                    currency_name: get_string(list, 2),
                    mts_started: get_i64(list, 5),
                    mts_updated: get_i64(list, 6),
                    status: get_string(list, 9),
                    amount: get_f64(list, 12),
                    fees: get_f64(list, 13),
                    destination_address: get_string(list, 16),
                    transaction_id: get_string(list, 20),
                    withdraw_transaction_note: get_string(list, 21),
                })
            })
            .collect()
    }
}
