use std::time::Duration;

use crate::{bitfinex_api, proto};

pub struct Settings {
    pub bitfinex_key: String,
    pub bitfinex_secret: String,
}

pub enum Request {
    Withdraw(proto::to::Withdraw),
    Transfer(proto::to::Transfer),
    Movements(proto::to::Movements),
}
pub enum Response {
    Withdraw(proto::from::Withdraw),
    Transfer(proto::from::Transfer),
    Movements(proto::from::Movements),
}

pub fn run(
    settings: Settings,
    req_receiver: crossbeam_channel::Receiver<Request>,
    resp_callback: impl Fn(Response),
) {
    let bf_api =
        bitfinex_api::Bitfinex::new(settings.bitfinex_key.clone(), settings.bitfinex_secret);
    loop {
        let req = req_receiver.recv().unwrap();
        match req {
            Request::Transfer(req) => {
                let res = bf_api.make_request(bitfinex_api::TransferRequest {
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
                    let res = bf_api.make_request(bitfinex_api::WithdrawRequest {
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
                let res = bf_api.make_request(bitfinex_api::MovementsRequest {
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
        }
    }
}
