use std::time::Duration;

use crate::{bitfinex_api, proto};

pub struct Settings {
    pub bitfinex_key: String,
    pub bitfinex_secret: String,
}

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

pub enum Request {
    Withdraw(proto::to::Withdraw),
    Transfer(proto::to::Transfer),
    Movements(proto::to::Movements),
    OrderSubmit(OrderSubmit),
}
pub enum Response {
    Withdraw(proto::from::Withdraw),
    Transfer(proto::from::Transfer),
    Movements(proto::from::Movements),
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
    settings: Settings,
    req_receiver: crossbeam_channel::Receiver<Request>,
    resp_callback: impl Fn(Response),
) {
    let bf_api =
        bitfinex_api::Bitfinex::new(settings.bitfinex_key.clone(), settings.bitfinex_secret);
    while let Ok(req) = req_receiver.recv() {
        match req {
            Request::Transfer(req) => {
                let res = bf_api.make_request(bitfinex_api::transfer::TransferRequest {
                    from: req.from,
                    to: req.to,
                    currency: req.currency,
                    currency_to: req.currency_to,
                    amount: req.amount.to_string(),
                });
                match res {
                    Ok(resp) if resp.status == "SUCCESS" => {
                        resp_callback(Response::Transfer(proto::from::Transfer { success: true }))
                    }
                    Ok(_) | Err(_) => {
                        resp_callback(Response::Transfer(proto::from::Transfer { success: false }))
                    }
                }
            }

            Request::Withdraw(req) => {
                let mut retry_count = 0;
                let res = loop {
                    let res = bf_api.make_request(bitfinex_api::withdraw::WithdrawRequest {
                        wallet: req.wallet.clone(),
                        method: req.method.clone(),
                        amount: req.amount.to_string(),
                        address: req.address.clone(),
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
                    Ok(resp) => resp_callback(Response::Withdraw(proto::from::Withdraw {
                        withdraw_id: resp.withdrawal_id,
                    })),
                    Err(_err) => {
                        resp_callback(Response::Withdraw(proto::from::Withdraw { withdraw_id: 0 }))
                    }
                }
            }

            Request::Movements(req) => {
                let res = bf_api.make_request(bitfinex_api::movements::MovementsRequest {
                    start: req.start,
                    end: req.end,
                    limit: req.limit,
                });
                match res {
                    Ok(resp) => resp_callback(Response::Movements(proto::from::Movements {
                        success: true,
                        key: settings.bitfinex_key.clone(),
                        movements: resp
                            .into_iter()
                            .map(|item| proto::Movement {
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
                    Err(_err) => resp_callback(Response::Movements(proto::from::Movements {
                        success: false,
                        key: settings.bitfinex_key.clone(),
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
