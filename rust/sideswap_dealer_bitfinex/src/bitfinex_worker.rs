use std::time::Duration;

use tokio::sync::mpsc::UnboundedReceiver;

use crate::{
    bitfinex_api::{self, movements::Movements},
    BfSettings,
};

pub enum MarketType {
    ExchangeMarket,
}

impl ToString for MarketType {
    fn to_string(&self) -> String {
        match self {
            MarketType::ExchangeMarket => "EXCHANGE MARKET".to_owned(),
        }
    }
}

pub struct OrderSubmit {
    pub market_type: MarketType,
    pub symbol: String,
    pub cid: i64,
    pub amount: f64,
}

pub struct Order {
    pub order_id: i64,
}

#[derive(Debug, Clone, PartialEq)]
pub struct Movement {
    pub id: i64,
    pub currency: String,
    pub currency_name: String,
    pub mts_started: i64,
    pub mts_updated: i64,
    pub status: String,
    pub amount: f64,
    pub fees: f64,
    pub destination_address: String,
    pub transaction_id: String,
    pub withdraw_transaction_note: String,
}

pub enum Request {
    Withdraw {
        wallet: String,
        method: String,
        amount: f64,
        address: String,
    },
    Transfer {
        from: String,
        to: String,
        currency: String,
        currency_to: String,
        amount: f64,
    },
    Movements {
        start: Option<i64>,
        end: Option<i64>,
        limit: Option<i32>,
    },
    OrderSubmit(OrderSubmit),
}

pub enum Response {
    Withdraw { withdraw_id: i64 },
    Transfer { success: bool },
    Movements(Movements),
    OrderSubmit(OrderSubmit, Result<Order, anyhow::Error>),
}

fn order_submit_with_retry(
    bf_api: &bitfinex_api::Bitfinex,
    req: &OrderSubmit,
) -> Result<bitfinex_api::submit::SubmitResponse, anyhow::Error> {
    for index in 0..5 {
        // Do not check history for the first time, cid must be unique
        if index != 0 {
            let history_res =
                bf_api.make_request(bitfinex_api::order_history::OrderHistoryRequest {
                    start: None,
                    end: None,
                    limit: None,
                });

            match history_res {
                Ok(history) => {
                    let cid_known = history.iter().any(|order| order.cid == req.cid);
                    ensure!(
                        !cid_known,
                        "order with cid {} already exists in history",
                        req.cid
                    );
                }
                Err(err) => {
                    error!("loading order history failed: {err}");
                    std::thread::sleep(Duration::from_secs(3));
                    continue;
                }
            }
        }

        let submit_res = bf_api.make_request(bitfinex_api::submit::SubmitRequest {
            type_: req.market_type.to_string(),
            cid: req.cid,
            symbol: req.symbol.clone(),
            amount: req.amount.to_string(),
        });
        match submit_res {
            Ok(order) => {
                info!("order submit succeed");
                return Ok(order);
            }
            Err(err) => {
                error!("order submit failed: {err}");
                std::thread::sleep(Duration::from_secs(3));
                continue;
            }
        }
    }

    bail!("all order submit retries failed");
}

pub fn run(
    settings: BfSettings,
    mut req_receiver: UnboundedReceiver<Request>,
    resp_callback: impl Fn(Response),
) {
    let bf_api = bitfinex_api::Bitfinex::new(settings.clone());
    while let Some(req) = req_receiver.blocking_recv() {
        match req {
            Request::Transfer {
                from,
                to,
                currency,
                currency_to,
                amount,
            } => {
                let res = bf_api.make_request(bitfinex_api::transfer::TransferRequest {
                    from,
                    to,
                    currency,
                    currency_to,
                    amount: amount.to_string(),
                });
                match res {
                    Ok(resp) if resp.status == "SUCCESS" => {
                        resp_callback(Response::Transfer { success: true })
                    }
                    Ok(_) | Err(_) => resp_callback(Response::Transfer { success: false }),
                }
            }

            Request::Withdraw {
                wallet,
                method,
                amount,
                address,
            } => {
                let mut retry_count = 0;
                let res = loop {
                    let res = bf_api.make_request(bitfinex_api::withdraw::WithdrawRequest {
                        wallet: wallet.clone(),
                        method: method.clone(),
                        amount: amount.to_string(),
                        address: address.clone(),
                    });
                    debug!("withdraw result: {res:?}");
                    if let Ok(success) = res.as_ref() {
                        if success.withdrawal_id == 0 && success.status == "SUCCESS" && success.text == "Settlement / Transfer in progress, please try again in few seconds"  {
                            retry_count += 1;
                            if retry_count < 5 {
                                debug!("wait and retry withdraw...");
                                std::thread::sleep(Duration::from_secs(10));
                                continue;
                            }
                        }
                    }
                    break res;
                };
                match res {
                    Ok(resp) => resp_callback(Response::Withdraw {
                        withdraw_id: resp.withdrawal_id,
                    }),
                    Err(_err) => resp_callback(Response::Withdraw { withdraw_id: 0 }),
                }
            }

            Request::Movements { start, end, limit } => {
                let res = bf_api.make_request(bitfinex_api::movements::MovementsRequest {
                    start,
                    end,
                    limit,
                });
                match res {
                    Ok(resp) => resp_callback(Response::Movements(Movements {
                        success: true,
                        movements: resp
                            .into_iter()
                            .map(|item| Movement {
                                id: item.id,
                                currency: item.currency,
                                currency_name: item.currency_name,
                                mts_started: item.mts_started,
                                mts_updated: item.mts_updated,
                                status: item.status,
                                amount: item.amount,
                                fees: item.fees,
                                destination_address: item.destination_address,
                                transaction_id: item.transaction_id,
                                withdraw_transaction_note: item.withdraw_transaction_note,
                            })
                            .collect(),
                    })),
                    Err(_err) => resp_callback(Response::Movements(Movements {
                        success: false,
                        movements: Vec::new(),
                    })),
                }
            }

            Request::OrderSubmit(req) => {
                let res = order_submit_with_retry(&bf_api, &req);
                resp_callback(Response::OrderSubmit(
                    req,
                    res.map(|resp| Order {
                        order_id: resp.order_id,
                    }),
                ));
            }
        }
    }
}
