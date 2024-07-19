use super::*;

#[derive(Serialize)]
pub struct OrderHistoryRequest {
    #[serde(skip_serializing_if = "Option::is_none")]
    pub start: Option<i64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub end: Option<i64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub limit: Option<i32>,
}

#[derive(Debug)]
#[allow(unused)]
pub struct Order {
    pub id: i64,
    pub cid: i64,
    pub amount: f64,
    pub price: f64,
    pub mts_create: i64,
    pub mts_update: i64,
    pub status: String,
}

pub type OrderHistoryResponse = Vec<Order>;

impl ApiCall for OrderHistoryRequest {
    type Response = OrderHistoryResponse;

    fn api_path() -> &'static str {
        "v2/auth/r/orders/hist"
    }

    fn parse(value: serde_json::Value) -> Result<Self::Response, anyhow::Error> {
        // https://docs.bitfinex.com/reference/rest-auth-orders-history
        let values = value.as_array().ok_or_else(|| anyhow!("array expected"))?;
        values
            .iter()
            .map(|item| -> Result<Order, anyhow::Error> {
                let list = item.as_array().ok_or_else(|| anyhow!("array expected"))?;
                Ok(Order {
                    id: get_i64(list, 0),
                    cid: get_i64(list, 2),
                    amount: get_f64(list, 6),
                    price: get_f64(list, 16),
                    mts_create: get_i64(list, 4),
                    mts_update: get_i64(list, 5),
                    status: get_string(list, 13),
                })
            })
            .collect()
    }
}
