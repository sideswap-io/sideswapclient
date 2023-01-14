#[macro_use]
extern crate log;
#[macro_use]
extern crate anyhow;

pub mod models;
pub mod reader;
mod serial;

pub use serial::FromPort;
pub use serial::Handle;
pub use serial::Port;

use models::*;

#[derive(Debug)]
pub enum Req {
    ReadStatus,
    AuthUser(JadeNetwork),
    ResolveXpub(ResolveXpubReq),
    SignMessage(SignMessageReq),
    GetSignature(Vec<u8>),
    GetSharedNonce(GetSharedNonceReq),
    GetBlindingKey(Vec<u8>),
    GetBlindingFactor(GetBlindingFactorReq),
    GetCommitments(GetCommitmentsReq),
    SignTx(models::ReqSignTx),
    TxInput(models::ReqTxInput),
}

#[derive(Debug)]
pub enum Resp {
    ReadStatus(models::RespVersionInfo),
    AuthUser(bool),
    ResolveXpub(String),
    SignMessage(Vec<u8>),
    GetSignature(Vec<u8>),
    GetSharedNonce(Vec<u8>),
    GetBlindingKey(Vec<u8>),
    GetBlindingFactor(Vec<u8>),
    GetCommitments(models::RespGetCommitments),
    SignTx(bool),
    TxInput(Vec<u8>),
}

#[derive(Debug)]
enum WorkerReq {
    Req(Req),
    Quit,
    FromPort(serial::FromPort),
}

#[derive(Debug)]
pub enum WorkerResp {
    Resp(Result<Resp, anyhow::Error>),
    FatalError(anyhow::Error),
}

pub struct Jade {
    sender: std::sync::mpsc::Sender<WorkerReq>,
}

impl Jade {
    // Provided callback must not block when invoked
    pub fn new<F>(port: Port, callback: F) -> Result<Self, anyhow::Error>
    where
        F: 'static + Send + FnMut(WorkerResp) -> (),
    {
        let (sender, receiver) = std::sync::mpsc::channel();

        let sender_copy = sender.clone();

        let handle_callback = move |msg: FromPort| {
            let send_result = sender_copy.send(WorkerReq::FromPort(msg));
            if let Err(e) = send_result {
                error!("sending failed: {}", e);
            }
        };

        let handle = serial::Handle::new(port, handle_callback)?;

        std::thread::spawn(move || {
            worker(receiver, handle, callback);
        });

        Ok(Self { sender })
    }

    pub fn send(&self, req: Req) {
        self.sender.send(WorkerReq::Req(req)).unwrap();
    }
}

impl Drop for Jade {
    fn drop(&mut self) {
        self.sender.send(WorkerReq::Quit).unwrap();
    }
}

#[derive(Eq, PartialEq)]
enum PendingRequest {
    ReadStatus,
    HttpRequest,
    AuthComplete,
    GetXPub,
    SignMessage,
    GetSignature,
    GetSharedNonce,
    GetBlindingKey,
    GetBlindingFactor,
    GetCommitments,
    SignTx,
    TxInput,
}

struct State {
    pending_requests: std::collections::BTreeMap<i32, PendingRequest>,
    last_request_id: i32,
    agent: ureq::Agent,
}

fn json_to_cbor(value: serde_json::Value) -> Result<ciborium::value::Value, anyhow::Error> {
    match value {
        serde_json::Value::Null => Ok(ciborium::value::Value::Null),
        serde_json::Value::Bool(v) => Ok(ciborium::value::Value::Bool(v)),
        serde_json::Value::String(v) => Ok(ciborium::value::Value::Text(v)),
        serde_json::Value::Number(v) if v.is_f64() => {
            Ok(ciborium::value::Value::Float(v.as_f64().unwrap()))
        }
        serde_json::Value::Number(v) => bail!("unsupported number: {:?}", v),
        serde_json::Value::Array(v) => Ok(ciborium::value::Value::Array(
            v.into_iter()
                .map(json_to_cbor)
                .collect::<Result<Vec<_>, anyhow::Error>>()?,
        )),
        serde_json::Value::Object(v) => Ok(ciborium::value::Value::Map(
            v.into_iter()
                .map(|(key, value)| {
                    json_to_cbor(value).map(|value| (ciborium::value::Value::Text(key), value))
                })
                .collect::<Result<Vec<_>, anyhow::Error>>()?,
        )),
    }
}

fn cbor_to_json(value: ciborium::value::Value) -> Result<serde_json::Value, anyhow::Error> {
    match value {
        ciborium::value::Value::Integer(v) => Ok(serde_json::Value::Number(
            serde_json::Number::from_f64(i128::from(v) as f64)
                .ok_or_else(|| anyhow!("integer number conversion failed"))?,
        )),
        ciborium::value::Value::Float(v) => Ok(serde_json::Value::Number(
            serde_json::Number::from_f64(v)
                .ok_or_else(|| anyhow!("float number conversion failed"))?,
        )),
        ciborium::value::Value::Text(v) => Ok(serde_json::Value::String(v)),
        ciborium::value::Value::Bool(v) => Ok(serde_json::Value::Bool(v)),
        ciborium::value::Value::Null => Ok(serde_json::Value::Null),
        ciborium::value::Value::Array(v) => Ok(serde_json::Value::Array(
            v.into_iter()
                .map(cbor_to_json)
                .collect::<Result<Vec<_>, anyhow::Error>>()?,
        )),
        ciborium::value::Value::Map(v) => Ok(serde_json::Value::Object(
            v.into_iter()
                .map(|(key, value)| {
                    cbor_to_json(value)
                        .map(|value| (key.as_text().unwrap_or_default().to_owned(), value))
                })
                .collect::<Result<serde_json::Map<_, _>, anyhow::Error>>()?,
        )),
        // ciborium::value::Value::Bytes(_) => todo!(),
        _ => bail!("unsupported CBOR value"),
    }
}

fn handle_http_request(
    state: &mut State,
    details: &models::RespAuthUser,
) -> Result<ciborium::value::Value, anyhow::Error> {
    let url = details
        .http_request
        .params
        .urls
        .get(0)
        .ok_or_else(|| anyhow!("empty urls array"))?;

    let data = cbor_to_json(details.http_request.params.data.clone())?;
    let data = serde_json::to_string(&data)?;

    let response = state
        .agent
        .post(&url)
        .set("Content-Type", "application/json")
        .set("Accept", "application/json")
        .send_string(&data)?;
    let response = response.into_string()?;
    let response = serde_json::from_str::<serde_json::Value>(&response)?;

    json_to_cbor(response)
}

fn handle_port_msg<F>(state: &mut State, callback: &mut F, handle: &mut Handle, data: Vec<u8>)
where
    F: FnMut(WorkerResp) -> (),
{
    let jade_resp =
        ciborium::de::from_reader::<models::Resp<ciborium::value::Value>, _>(data.as_slice());

    let jade_resp = match jade_resp {
        Ok(v) => v,
        Err(e) => {
            callback(WorkerResp::FatalError(anyhow!(
                "unexpected response from Jade: {}",
                e
            )));
            return;
        }
    };

    let request_id = jade_resp.id.parse::<i32>().ok().unwrap_or_default();
    let pending_request = state.pending_requests.remove(&request_id);
    let pending_request = match pending_request {
        Some(v) => v,
        None => {
            debug!("unexpected response ignored");
            return;
        }
    };

    match pending_request {
        PendingRequest::ReadStatus => {
            let resp = ciborium::de::from_reader::<models::Resp<models::RespVersionInfo>, _>(
                data.as_slice(),
            );
            match resp {
                Ok(v) => match (v.error, v.result) {
                    (Some(e), _) => {
                        callback(WorkerResp::Resp(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(v)) => {
                        callback(WorkerResp::Resp(Ok(Resp::ReadStatus(v))));
                    }
                    _ => {
                        callback(WorkerResp::Resp(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(WorkerResp::FatalError(anyhow!(
                    "parsing ReadStatus response failed: {}",
                    e
                ))),
            }
        }

        PendingRequest::HttpRequest => {
            let resp =
                ciborium::de::from_reader::<models::Resp<models::RespAuthUser>, _>(data.as_slice());
            match resp {
                Ok(v) => match (v.error, v.result) {
                    (Some(e), _) => {
                        callback(WorkerResp::Resp(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(v)) => {
                        debug!("auth response received: {:?}", v);
                        let result = handle_http_request(state, &v);
                        match result {
                            Ok(pin) => {
                                state.last_request_id += 1;
                                let req = models::Req::<ciborium::value::Value> {
                                    id: state.last_request_id.to_string(),
                                    method: v.http_request.on_reply.clone(),
                                    params: Some(pin),
                                };
                                let result = handle.send(&req);
                                if let Err(e) = result {
                                    callback(WorkerResp::FatalError(e));
                                } else {
                                    let next_step =
                                        if v.http_request.on_reply == "handshake_complete" {
                                            PendingRequest::AuthComplete
                                        } else {
                                            PendingRequest::HttpRequest
                                        };
                                    state
                                        .pending_requests
                                        .insert(state.last_request_id, next_step);
                                }
                            }
                            Err(e) => {
                                callback(WorkerResp::Resp(Err(anyhow!(
                                    "auth request failed: {}",
                                    e
                                ))));
                                // TODO: Cancel auth prompt on the device},
                            }
                        }
                    }
                    _ => {
                        callback(WorkerResp::Resp(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(WorkerResp::FatalError(anyhow!(
                    "parsing AuthUser response failed: {}",
                    e
                ))),
            }
        }

        PendingRequest::AuthComplete => {
            let resp = ciborium::de::from_reader::<models::Resp<models::RespAuthComplete>, _>(
                data.as_slice(),
            );
            match resp {
                Ok(v) => match (v.error, v.result) {
                    (Some(e), _) => {
                        callback(WorkerResp::Resp(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(v)) => {
                        callback(WorkerResp::Resp(Ok(Resp::AuthUser(v))));
                    }
                    _ => {
                        callback(WorkerResp::Resp(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(WorkerResp::FatalError(anyhow!(
                    "parsing AuthComplete response failed: {}",
                    e
                ))),
            }
        }

        PendingRequest::GetXPub => {
            let resp =
                ciborium::de::from_reader::<models::Resp<models::RespGetXPub>, _>(data.as_slice());
            match resp {
                Ok(v) => match (v.error, v.result) {
                    (Some(e), _) => {
                        callback(WorkerResp::Resp(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(v)) => {
                        callback(WorkerResp::Resp(Ok(Resp::ResolveXpub(v))));
                    }
                    _ => {
                        callback(WorkerResp::Resp(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(WorkerResp::FatalError(anyhow!(
                    "parsing ReadStatus response failed: {}",
                    e
                ))),
            }
        }

        PendingRequest::SignMessage => {
            let resp = ciborium::de::from_reader::<models::Resp<models::RespSignMessage>, _>(
                data.as_slice(),
            );
            match resp {
                Ok(v) => match (v.error, v.result) {
                    (Some(e), _) => {
                        callback(WorkerResp::Resp(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(v)) => {
                        callback(WorkerResp::Resp(Ok(Resp::SignMessage(v.into_vec()))));
                    }
                    _ => {
                        callback(WorkerResp::Resp(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(WorkerResp::FatalError(anyhow!(
                    "parsing SignMessage response failed: {}",
                    e
                ))),
            }
        }

        PendingRequest::GetSignature => {
            let resp = ciborium::de::from_reader::<models::Resp<models::RespGetSignature>, _>(
                data.as_slice(),
            );
            match resp {
                Ok(v) => match (v.error, v.result) {
                    (Some(e), _) => {
                        callback(WorkerResp::Resp(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(ciborium::value::Value::Text(v))) => {
                        let v = base64::decode(&v).unwrap();
                        callback(WorkerResp::Resp(Ok(Resp::GetSignature(v))));
                    }
                    (None, Some(ciborium::value::Value::Bytes(v))) => {
                        callback(WorkerResp::Resp(Ok(Resp::GetSignature(v))));
                    }
                    _ => {
                        callback(WorkerResp::Resp(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(WorkerResp::FatalError(anyhow!(
                    "parsing GetSignature response failed: {}",
                    e
                ))),
            }
        }

        PendingRequest::GetSharedNonce => {
            let resp = ciborium::de::from_reader::<models::Resp<models::RespGetSharedNonce>, _>(
                data.as_slice(),
            );
            match resp {
                Ok(v) => match (v.error, v.result) {
                    (Some(e), _) => {
                        callback(WorkerResp::Resp(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(v)) => {
                        callback(WorkerResp::Resp(Ok(Resp::GetSharedNonce(v.into_vec()))));
                    }
                    _ => {
                        callback(WorkerResp::Resp(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(WorkerResp::FatalError(anyhow!(
                    "parsing GetSharedNonce response failed: {}",
                    e
                ))),
            }
        }

        PendingRequest::GetBlindingKey => {
            let resp = ciborium::de::from_reader::<models::Resp<models::RespGetBlindingKey>, _>(
                data.as_slice(),
            );
            match resp {
                Ok(v) => match (v.error, v.result) {
                    (Some(e), _) => {
                        callback(WorkerResp::Resp(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(v)) => {
                        callback(WorkerResp::Resp(Ok(Resp::GetBlindingKey(v.into_vec()))));
                    }
                    _ => {
                        callback(WorkerResp::Resp(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(WorkerResp::FatalError(anyhow!(
                    "parsing GetBlindingKey response failed: {}",
                    e
                ))),
            }
        }

        PendingRequest::GetBlindingFactor => {
            let resp = ciborium::de::from_reader::<models::Resp<models::RespGetBlindingFactor>, _>(
                data.as_slice(),
            );
            match resp {
                Ok(v) => match (v.error, v.result) {
                    (Some(e), _) => {
                        callback(WorkerResp::Resp(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(v)) => {
                        callback(WorkerResp::Resp(Ok(Resp::GetBlindingFactor(v.into_vec()))));
                    }
                    _ => {
                        callback(WorkerResp::Resp(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(WorkerResp::FatalError(anyhow!(
                    "parsing GetBlindingFactor response failed: {}",
                    e
                ))),
            }
        }

        PendingRequest::GetCommitments => {
            let resp = ciborium::de::from_reader::<models::Resp<models::RespGetCommitments>, _>(
                data.as_slice(),
            );
            match resp {
                Ok(v) => match (v.error, v.result) {
                    (Some(e), _) => {
                        callback(WorkerResp::Resp(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(v)) => {
                        callback(WorkerResp::Resp(Ok(Resp::GetCommitments(v))));
                    }
                    _ => {
                        callback(WorkerResp::Resp(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(WorkerResp::FatalError(anyhow!(
                    "parsing GetCommitments response failed: {}",
                    e
                ))),
            }
        }

        PendingRequest::SignTx => {
            let resp =
                ciborium::de::from_reader::<models::Resp<models::RespSignTx>, _>(data.as_slice());
            match resp {
                Ok(v) => match (v.error, v.result) {
                    (Some(e), _) => {
                        callback(WorkerResp::Resp(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(v)) => {
                        callback(WorkerResp::Resp(Ok(Resp::SignTx(v))));
                    }
                    _ => {
                        callback(WorkerResp::Resp(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(WorkerResp::FatalError(anyhow!(
                    "parsing SignTx response failed: {}",
                    e
                ))),
            }
        }

        PendingRequest::TxInput => {
            let resp =
                ciborium::de::from_reader::<models::Resp<models::RespTxInput>, _>(data.as_slice());
            match resp {
                Ok(v) => match (v.error, v.result) {
                    (Some(e), _) => {
                        callback(WorkerResp::Resp(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(v)) => {
                        callback(WorkerResp::Resp(Ok(Resp::TxInput(v.into_vec()))));
                    }
                    _ => {
                        callback(WorkerResp::Resp(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(WorkerResp::FatalError(anyhow!(
                    "parsing TxInput response failed: {}",
                    e
                ))),
            }
        }
    }
}

fn worker<F>(
    receiver: std::sync::mpsc::Receiver<WorkerReq>,
    mut handle: serial::Handle,
    mut callback: F,
) where
    F: FnMut(WorkerResp) -> (),
{
    let mut state = State {
        pending_requests: std::collections::BTreeMap::new(),
        last_request_id: 25000,
        agent: ureq::agent(),
    };

    for msg in receiver {
        match msg {
            WorkerReq::Quit => {
                debug!("stop Jade handler thread");
                break;
            }

            WorkerReq::FromPort(msg) => match msg {
                FromPort::Data(data) => {
                    handle_port_msg(&mut state, &mut callback, &mut handle, data);
                }
                FromPort::FatalError(e) => {
                    callback(WorkerResp::FatalError(e));
                }
            },

            WorkerReq::Req(Req::ReadStatus) => {
                // Remove all old status requests
                state
                    .pending_requests
                    .retain(|_, request| *request != PendingRequest::ReadStatus);
                // Do not send status requests while unlocking wallet (because unlock would fail)
                if state.pending_requests.is_empty() {
                    state.last_request_id += 1;
                    let req = models::Req::<ciborium::value::Value> {
                        id: state.last_request_id.to_string(),
                        method: "get_version_info".to_owned(),
                        params: None,
                    };
                    let result = handle.send(&req);
                    if let Err(e) = result {
                        callback(WorkerResp::FatalError(e));
                    } else {
                        state
                            .pending_requests
                            .insert(state.last_request_id, PendingRequest::ReadStatus);
                    }
                }
            }

            WorkerReq::Req(Req::AuthUser(network)) => {
                state.last_request_id += 1;
                let req = models::Req::<models::ReqAuthUser> {
                    id: state.last_request_id.to_string(),
                    method: "auth_user".to_owned(),
                    params: Some(models::ReqAuthUser {
                        network: network.name().to_owned(),
                    }),
                };
                let result = handle.send(&req);
                if let Err(e) = result {
                    callback(WorkerResp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::HttpRequest);
                }
            }

            WorkerReq::Req(Req::ResolveXpub(req)) => {
                state.last_request_id += 1;
                let req = models::Req::<models::ReqGetXPub> {
                    id: state.last_request_id.to_string(),
                    method: "get_xpub".to_owned(),
                    params: Some(models::ReqGetXPub {
                        network: req.network.name().to_owned(),
                        path: req.path,
                    }),
                };
                let result = handle.send(&req);
                if let Err(e) = result {
                    callback(WorkerResp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::GetXPub);
                }
            }

            WorkerReq::Req(Req::SignMessage(req)) => {
                state.last_request_id += 1;
                let req = models::Req::<models::ReqSignMessage> {
                    id: state.last_request_id.to_string(),
                    method: "sign_message".to_owned(),
                    params: Some(models::ReqSignMessage {
                        path: req.path,
                        message: req.message,
                        ae_host_commitment: serde_bytes::ByteBuf::from(req.ae_host_commitment),
                    }),
                };
                let result = handle.send(&req);
                if let Err(e) = result {
                    callback(WorkerResp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::SignMessage);
                }
            }

            WorkerReq::Req(Req::GetSignature(ae_host_entropy)) => {
                state.last_request_id += 1;
                let req = models::Req::<models::ReqGetSignature> {
                    id: state.last_request_id.to_string(),
                    method: "get_signature".to_owned(),
                    params: Some(models::ReqGetSignature {
                        ae_host_entropy: serde_bytes::ByteBuf::from(ae_host_entropy),
                    }),
                };
                let result = handle.send(&req);
                if let Err(e) = result {
                    callback(WorkerResp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::GetSignature);
                }
            }

            WorkerReq::Req(Req::GetSharedNonce(req)) => {
                state.last_request_id += 1;
                let req = models::Req::<models::ReqGetSharedNonce> {
                    id: state.last_request_id.to_string(),
                    method: "get_shared_nonce".to_owned(),
                    params: Some(models::ReqGetSharedNonce {
                        script: serde_bytes::ByteBuf::from(req.script),
                        their_pubkey: serde_bytes::ByteBuf::from(req.their_pubkey),
                    }),
                };
                let result = handle.send(&req);
                if let Err(e) = result {
                    callback(WorkerResp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::GetSharedNonce);
                }
            }

            WorkerReq::Req(Req::GetBlindingKey(script)) => {
                state.last_request_id += 1;
                let req = models::Req::<models::ReqGetBlindingKey> {
                    id: state.last_request_id.to_string(),
                    method: "get_blinding_key".to_owned(),
                    params: Some(models::ReqGetBlindingKey {
                        script: serde_bytes::ByteBuf::from(script),
                    }),
                };
                let result = handle.send(&req);
                if let Err(e) = result {
                    callback(WorkerResp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::GetBlindingKey);
                }
            }

            WorkerReq::Req(Req::GetBlindingFactor(req)) => {
                state.last_request_id += 1;
                let type_ = match req.factor_type {
                    BlindingFactorType::Asset => "ASSET",
                    BlindingFactorType::Value => "VALUE",
                };
                let req = models::Req::<models::ReqGetBlindingFactor> {
                    id: state.last_request_id.to_string(),
                    method: "get_blinding_factor".to_owned(),
                    params: Some(models::ReqGetBlindingFactor {
                        hash_prevouts: serde_bytes::ByteBuf::from(req.hash_prevouts),
                        output_index: req.output_index,
                        type_: type_.to_owned(),
                    }),
                };
                let result = handle.send(&req);
                if let Err(e) = result {
                    callback(WorkerResp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::GetBlindingFactor);
                }
            }

            WorkerReq::Req(Req::GetCommitments(req)) => {
                state.last_request_id += 1;
                let req = models::Req::<models::ReqGetCommitments> {
                    id: state.last_request_id.to_string(),
                    method: "get_commitments".to_owned(),
                    params: Some(models::ReqGetCommitments {
                        asset_id: serde_bytes::ByteBuf::from(req.asset_id),
                        value: req.value,
                        hash_prevouts: serde_bytes::ByteBuf::from(req.hash_prevouts),
                        output_index: req.output_index,
                        vbf: req.vbf.map(|vbf| serde_bytes::ByteBuf::from(vbf)),
                    }),
                };
                let result = handle.send(&req);
                if let Err(e) = result {
                    callback(WorkerResp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::GetCommitments);
                }
            }

            WorkerReq::Req(Req::SignTx(msg)) => {
                state.last_request_id += 1;
                let req = models::Req::<models::ReqSignTx> {
                    id: state.last_request_id.to_string(),
                    method: "sign_liquid_tx".to_owned(),
                    params: Some(msg),
                };
                let result = handle.send(&req);
                if let Err(e) = result {
                    callback(WorkerResp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::SignTx);
                }
            }

            WorkerReq::Req(Req::TxInput(msg)) => {
                state.last_request_id += 1;
                let req = models::Req::<models::ReqTxInput> {
                    id: state.last_request_id.to_string(),
                    method: "tx_input".to_owned(),
                    params: Some(msg),
                };
                let result = handle.send(&req);
                if let Err(e) = result {
                    callback(WorkerResp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::TxInput);
                }
            }
        }
    }
}
