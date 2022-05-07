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

#[derive(Debug)]
pub enum Network {
    // Mainnet,       // Bitcoin mainnet
    // Testnet,       // Bitcoin testnet
    Liquid,        // Liquid mainnet
    TestnetLiquid, // Liquid testnet
}

impl Network {
    pub fn name(&self) -> &'static str {
        match self {
            // Network::Mainnet => "mainnet",
            // Network::Testnet => "testnet",
            Network::Liquid => "liquid",
            Network::TestnetLiquid => "testnet-liquid",
        }
    }
}

#[derive(Debug)]
enum WorkerReq {
    Quit,

    FromPort(serial::FromPort),

    ReadStatus,
    AuthUser(Network),
    ResolveXpub(Network, Vec<u32>),
    SignMessage(Vec<u32>, String, Vec<u8>),
    GetSignature(Vec<u8>),
    GetSharedNonce(Vec<u8>, Vec<u8>),
    GetBlindingKey(Vec<u8>),
    GetBlindingFactor(Vec<u8>, u32, BlindingFactorType),
    GetCommitments(Vec<u8>, u64, Vec<u8>, u32, Option<Vec<u8>>),
    SignTx(models::ReqSignTx),
    TxInput(models::ReqTxInput),
}

#[derive(Debug)]
pub enum Resp {
    FatalError(anyhow::Error),

    ReadStatus(Result<models::RespVersionInfo, anyhow::Error>),
    AuthUser(Result<bool, anyhow::Error>),
    ResolveXpub(Result<String, anyhow::Error>),
    SignMessage(Result<Vec<u8>, anyhow::Error>),
    GetSignature(Result<Vec<u8>, anyhow::Error>),
    GetSharedNonce(Result<Vec<u8>, anyhow::Error>),
    GetBlindingKey(Result<Vec<u8>, anyhow::Error>),
    GetBlindingFactor(Result<Vec<u8>, anyhow::Error>),
    GetCommitments(Result<models::RespGetCommitments, anyhow::Error>),
    SignTx(Result<bool, anyhow::Error>),
    TxInput(Result<Vec<u8>, anyhow::Error>),
}

pub struct Jade {
    sender: std::sync::mpsc::Sender<WorkerReq>,
}

#[derive(Debug)]
pub enum BlindingFactorType {
    Asset,
    Value,
}

impl Jade {
    // Provided callback must not block when invoked
    pub fn new<F>(port: Port, callback: F) -> Result<Self, anyhow::Error>
    where
        F: 'static + Send + FnMut(Resp) -> (),
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

    pub fn read_status(&self) {
        self.sender.send(WorkerReq::ReadStatus).unwrap();
    }

    pub fn auth_user(&self, network: Network) {
        self.sender.send(WorkerReq::AuthUser(network)).unwrap();
    }

    pub fn resolve_xpub(&self, network: Network, path: Vec<u32>) {
        self.sender
            .send(WorkerReq::ResolveXpub(network, path))
            .unwrap();
    }

    pub fn sign_message(&self, path: Vec<u32>, message: String, ae_host_commitment: Vec<u8>) {
        self.sender
            .send(WorkerReq::SignMessage(path, message, ae_host_commitment))
            .unwrap();
    }

    pub fn get_signature(&self, ae_host_entropy: Vec<u8>) {
        self.sender
            .send(WorkerReq::GetSignature(ae_host_entropy))
            .unwrap();
    }

    pub fn get_shared_nonce(&self, script: Vec<u8>, their_pubkey: Vec<u8>) {
        self.sender
            .send(WorkerReq::GetSharedNonce(script, their_pubkey))
            .unwrap();
    }

    pub fn get_blinding_key(&self, script: Vec<u8>) {
        self.sender.send(WorkerReq::GetBlindingKey(script)).unwrap();
    }

    pub fn get_blinding_factor(
        &self,
        hash_prevouts: Vec<u8>,
        output_index: u32,
        factor_type: BlindingFactorType,
    ) {
        self.sender
            .send(WorkerReq::GetBlindingFactor(
                hash_prevouts,
                output_index,
                factor_type,
            ))
            .unwrap();
    }

    pub fn get_commitments(
        &self,
        asset_id: Vec<u8>,
        value: u64,
        hash_prevouts: Vec<u8>,
        output_index: u32,
        vbf: Option<Vec<u8>>,
    ) {
        self.sender
            .send(WorkerReq::GetCommitments(
                asset_id,
                value,
                hash_prevouts,
                output_index,
                vbf,
            ))
            .unwrap();
    }

    pub fn sign_tx(&self, msg: models::ReqSignTx) {
        self.sender.send(WorkerReq::SignTx(msg)).unwrap();
    }

    pub fn tx_input(&self, msg: models::ReqTxInput) {
        self.sender.send(WorkerReq::TxInput(msg)).unwrap();
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
    F: FnMut(Resp) -> (),
{
    let jade_resp =
        ciborium::de::from_reader::<models::Resp<ciborium::value::Value>, _>(data.as_slice());

    let jade_resp = match jade_resp {
        Ok(v) => v,
        Err(e) => {
            callback(Resp::FatalError(anyhow!(
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
                        callback(Resp::ReadStatus(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(v)) => {
                        callback(Resp::ReadStatus(Ok(v)));
                    }
                    _ => {
                        callback(Resp::ReadStatus(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(Resp::FatalError(anyhow!(
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
                        callback(Resp::AuthUser(Err(anyhow!(
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
                                    callback(Resp::FatalError(e));
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
                                callback(Resp::AuthUser(Err(anyhow!(
                                    "auth request failed: {}",
                                    e
                                ))));
                                // TODO: Cancel auth prompt on the device},
                            }
                        }
                    }
                    _ => {
                        callback(Resp::AuthUser(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(Resp::FatalError(anyhow!(
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
                        callback(Resp::AuthUser(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(v)) => {
                        callback(Resp::AuthUser(Ok(v)));
                    }
                    _ => {
                        callback(Resp::AuthUser(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(Resp::FatalError(anyhow!(
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
                        callback(Resp::ResolveXpub(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(v)) => {
                        callback(Resp::ResolveXpub(Ok(v)));
                    }
                    _ => {
                        callback(Resp::ResolveXpub(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(Resp::FatalError(anyhow!(
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
                        callback(Resp::SignMessage(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(v)) => {
                        callback(Resp::SignMessage(Ok(v.into_vec())));
                    }
                    _ => {
                        callback(Resp::SignMessage(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(Resp::FatalError(anyhow!(
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
                        callback(Resp::GetSignature(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(ciborium::value::Value::Text(v))) => {
                        let v = base64::decode(&v).unwrap();
                        callback(Resp::GetSignature(Ok(v)));
                    }
                    (None, Some(ciborium::value::Value::Bytes(v))) => {
                        callback(Resp::GetSignature(Ok(v)));
                    }
                    _ => {
                        callback(Resp::GetSignature(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(Resp::FatalError(anyhow!(
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
                        callback(Resp::GetSignature(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(v)) => {
                        callback(Resp::GetSharedNonce(Ok(v.into_vec())));
                    }
                    _ => {
                        callback(Resp::GetSharedNonce(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(Resp::FatalError(anyhow!(
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
                        callback(Resp::GetBlindingKey(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(v)) => {
                        callback(Resp::GetBlindingKey(Ok(v.into_vec())));
                    }
                    _ => {
                        callback(Resp::GetBlindingKey(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(Resp::FatalError(anyhow!(
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
                        callback(Resp::GetBlindingFactor(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(v)) => {
                        callback(Resp::GetBlindingFactor(Ok(v.into_vec())));
                    }
                    _ => {
                        callback(Resp::GetBlindingFactor(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(Resp::FatalError(anyhow!(
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
                        callback(Resp::GetCommitments(Err(anyhow!(
                            "request failed: {}",
                            e.message
                        ))));
                    }
                    (None, Some(v)) => {
                        callback(Resp::GetCommitments(Ok(v)));
                    }
                    _ => {
                        callback(Resp::GetCommitments(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(Resp::FatalError(anyhow!(
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
                        callback(Resp::SignTx(Err(anyhow!("request failed: {}", e.message))));
                    }
                    (None, Some(v)) => {
                        callback(Resp::SignTx(Ok(v)));
                    }
                    _ => {
                        callback(Resp::SignTx(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(Resp::FatalError(anyhow!(
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
                        callback(Resp::TxInput(Err(anyhow!("request failed: {}", e.message))));
                    }
                    (None, Some(v)) => {
                        callback(Resp::TxInput(Ok(v.into_vec())));
                    }
                    _ => {
                        callback(Resp::TxInput(Err(anyhow!("unexpected response"))));
                    }
                },
                Err(e) => callback(Resp::FatalError(anyhow!(
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
    F: FnMut(Resp) -> (),
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
                    callback(Resp::FatalError(e));
                }
            },

            WorkerReq::ReadStatus => {
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
                        callback(Resp::FatalError(e));
                    } else {
                        state
                            .pending_requests
                            .insert(state.last_request_id, PendingRequest::ReadStatus);
                    }
                }
            }

            WorkerReq::AuthUser(network) => {
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
                    callback(Resp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::HttpRequest);
                }
            }

            WorkerReq::ResolveXpub(network, path) => {
                state.last_request_id += 1;
                let req = models::Req::<models::ReqGetXPub> {
                    id: state.last_request_id.to_string(),
                    method: "get_xpub".to_owned(),
                    params: Some(models::ReqGetXPub {
                        network: network.name().to_owned(),
                        path,
                    }),
                };
                let result = handle.send(&req);
                if let Err(e) = result {
                    callback(Resp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::GetXPub);
                }
            }

            WorkerReq::SignMessage(path, message, ae_host_commitment) => {
                state.last_request_id += 1;
                let req = models::Req::<models::ReqSignMessage> {
                    id: state.last_request_id.to_string(),
                    method: "sign_message".to_owned(),
                    params: Some(models::ReqSignMessage {
                        path,
                        message,
                        ae_host_commitment: serde_bytes::ByteBuf::from(ae_host_commitment),
                    }),
                };
                let result = handle.send(&req);
                if let Err(e) = result {
                    callback(Resp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::SignMessage);
                }
            }

            WorkerReq::GetSignature(ae_host_entropy) => {
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
                    callback(Resp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::GetSignature);
                }
            }

            WorkerReq::GetSharedNonce(script, their_pubkey) => {
                state.last_request_id += 1;
                let req = models::Req::<models::ReqGetSharedNonce> {
                    id: state.last_request_id.to_string(),
                    method: "get_shared_nonce".to_owned(),
                    params: Some(models::ReqGetSharedNonce {
                        script: serde_bytes::ByteBuf::from(script),
                        their_pubkey: serde_bytes::ByteBuf::from(their_pubkey),
                    }),
                };
                let result = handle.send(&req);
                if let Err(e) = result {
                    callback(Resp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::GetSharedNonce);
                }
            }

            WorkerReq::GetBlindingKey(script) => {
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
                    callback(Resp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::GetBlindingKey);
                }
            }

            WorkerReq::GetBlindingFactor(hash_prevouts, output_index, factor_type) => {
                state.last_request_id += 1;
                let type_ = match factor_type {
                    BlindingFactorType::Asset => "ASSET",
                    BlindingFactorType::Value => "VALUE",
                };
                let req = models::Req::<models::ReqGetBlindingFactor> {
                    id: state.last_request_id.to_string(),
                    method: "get_blinding_factor".to_owned(),
                    params: Some(models::ReqGetBlindingFactor {
                        hash_prevouts: serde_bytes::ByteBuf::from(hash_prevouts),
                        output_index,
                        type_: type_.to_owned(),
                    }),
                };
                let result = handle.send(&req);
                if let Err(e) = result {
                    callback(Resp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::GetBlindingFactor);
                }
            }

            WorkerReq::GetCommitments(asset_id, value, hash_prevouts, output_index, vbf) => {
                state.last_request_id += 1;
                let req = models::Req::<models::ReqGetCommitments> {
                    id: state.last_request_id.to_string(),
                    method: "get_commitments".to_owned(),
                    params: Some(models::ReqGetCommitments {
                        asset_id: serde_bytes::ByteBuf::from(asset_id),
                        value,
                        hash_prevouts: serde_bytes::ByteBuf::from(hash_prevouts),
                        output_index,
                        vbf: vbf.map(|vbf| serde_bytes::ByteBuf::from(vbf)),
                    }),
                };
                let result = handle.send(&req);
                if let Err(e) = result {
                    callback(Resp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::GetCommitments);
                }
            }

            WorkerReq::SignTx(msg) => {
                state.last_request_id += 1;
                let req = models::Req::<models::ReqSignTx> {
                    id: state.last_request_id.to_string(),
                    method: "sign_liquid_tx".to_owned(),
                    params: Some(msg),
                };
                let result = handle.send(&req);
                if let Err(e) = result {
                    callback(Resp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::SignTx);
                }
            }

            WorkerReq::TxInput(msg) => {
                state.last_request_id += 1;
                let req = models::Req::<models::ReqTxInput> {
                    id: state.last_request_id.to_string(),
                    method: "tx_input".to_owned(),
                    params: Some(msg),
                };
                let result = handle.send(&req);
                if let Err(e) = result {
                    callback(Resp::FatalError(e));
                } else {
                    state
                        .pending_requests
                        .insert(state.last_request_id, PendingRequest::TxInput);
                }
            }
        }
    }
}
