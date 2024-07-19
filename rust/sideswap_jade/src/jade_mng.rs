use std::{
    sync::{Arc, Mutex},
    time::Duration,
};

use base64::Engine;
use serde::{Deserialize, Serialize};

#[derive(Copy, Clone)]
pub enum TxType {
    Normal,
    MakerUtxo,
    Swap,
    OfflineSwap,
}

pub enum JadeStatus {
    Connecting,
    Idle,
    ReadStatus,
    AuthUser,
    MasterBlindingKey,
    SignTx(TxType),
}

pub type JadeStatusCallback = std::sync::Arc<Box<dyn Fn(JadeStatus)>>;

use crate::{
    http_request::handle_http_request,
    models,
    transports::{self, Connection, Transport},
    JadeId,
};

#[derive(Serialize)]
struct ReqMsg<T> {
    id: String,
    method: String,
    params: T,
}

#[derive(Deserialize, Debug)]
struct Error {
    #[allow(dead_code)]
    code: i32,
    message: String,
}

#[derive(Deserialize, Debug)]
struct RespMsg<T> {
    #[allow(dead_code)]
    id: String,
    result: Option<T>,
    error: Option<Error>,
}

#[derive(Debug, Clone, Copy)]
pub enum JadeState {
    Uninit,
    Main,
    Test,
}

#[derive(Debug)]
pub struct ManagedPort {
    pub jade_id: JadeId,
    pub port_name: String,
}

struct ManagedJadeData {
    connection: Option<Box<dyn Connection>>,
    last_request_id: u64,
}

pub struct ManagedJade {
    jade_id: JadeId,
    data: Arc<Mutex<ManagedJadeData>>,
    agent: ureq::Agent,
    transport: Arc<dyn Transport>,
    status_callback: JadeStatusCallback,
}

pub struct JadeMng {
    transports: Vec<Arc<dyn Transport>>,
    status_callback: JadeStatusCallback,
}

impl ManagedJade {
    pub fn set_status(&self, status: JadeStatus) {
        (self.status_callback)(status);
    }

    fn try_make_request<Request: serde::Serialize, Response: serde::de::DeserializeOwned>(
        &self,
        name: &str,
        timeout: Duration,
        req: Request,
    ) -> Result<Response, anyhow::Error> {
        let mut data = self.data.lock().expect("must not fail");

        data.last_request_id += 1;
        let request_id = data.last_request_id;

        if let Some(connection) = data.connection.as_mut() {
            let res = connection.read();
            if let Err(err) = res {
                log::debug!("read error: {err}, reconnect...");
                data.connection = None;
            }
        }

        if data.connection.is_none() {
            let connecting_status = match self.transport.transport_type() {
                transports::TransportType::Serial => JadeStatus::Idle,
                transports::TransportType::Ble => JadeStatus::Connecting,
            };
            self.set_status(connecting_status);
            let open_res = self.transport.open(&self.jade_id);
            self.set_status(JadeStatus::Idle);
            let jade = open_res?;
            data.connection = Some(jade);
        }
        let jade = data.connection.as_mut().expect("connection is open now");

        loop {
            let resp = jade.read()?;
            if resp.is_empty() {
                break;
            }
        }

        {
            let req = ReqMsg {
                id: request_id.to_string(),
                method: name.to_owned(),
                params: req,
            };
            let mut buf = Vec::<u8>::new();
            ciborium::ser::into_writer(&req, &mut buf).unwrap();
            debug!(
                "send: {:?}",
                &ciborium::de::from_reader::<ciborium::value::Value, _>(buf.as_slice()).unwrap()
            );
            jade.write(&buf)?;
        }

        let now = std::time::Instant::now();
        let reader = crate::reader::BufReader::default();
        let mut delay = 0;
        loop {
            let data = jade.read()?;

            if data.is_empty() {
                if std::time::Instant::now().duration_since(now) > timeout {
                    bail!("timeout");
                }
                std::thread::sleep(Duration::from_millis(delay));
                delay = std::cmp::min(delay + 1, 100);
                continue;
            }
            delay = 0;

            reader.append_data(&data);
            reader.reset_pos();

            match ciborium::de::from_reader::<ciborium::value::Value, _>(reader.clone()) {
                Ok(v) => {
                    debug!("recv: {:?}", &v);
                    let data = reader.remove_read();

                    let expected = v
                        .as_map()
                        .map(|map| {
                            map.iter().any(|(key, value)| {
                                key.as_text() == Some("id")
                                    && value.as_text() == Some(&request_id.to_string())
                            })
                        })
                        .unwrap_or_default();
                    if expected {
                        let resp =
                            ciborium::de::from_reader::<RespMsg<Response>, _>(data.as_slice())?;
                        if let Some(error) = resp.error {
                            bail!("Jade error: {}", error.message);
                        }
                        match resp.result {
                            Some(resp) => return Ok(resp),
                            None => bail!("empty resp"),
                        }
                    } else {
                        debug!("drop unexpected message");
                    }
                }
                Err(e) => {
                    debug!("decode failed: {}, wait for more data", e);
                    continue;
                }
            }
        }
    }

    fn make_request<Request: serde::Serialize, Response: serde::de::DeserializeOwned>(
        &self,
        name: &str,
        timeout: Duration,
        req: Request,
    ) -> Result<Response, anyhow::Error> {
        let res = self.try_make_request(name, timeout, req);
        if let Err(err) = &res {
            log::error!("jade request error: {}", err);
        }
        res
    }

    pub fn read_status(&self) -> Result<models::RespVersionInfo, anyhow::Error> {
        let resp = self.make_request::<models::EmptyRequest, models::RespVersionInfo>(
            "get_version_info",
            std::time::Duration::from_secs(10),
            None,
        )?;

        // Version check
        let req = semver::VersionReq::parse(">=0.1.48").expect("must be valid");
        let version = semver::Version::parse(&resp.jade_version)?;
        ensure!(req.matches(&version), "Please upgrade your Jade firmware to 0.1.48 or higher to use SideSwap with your Jade device");

        Ok(resp)
    }

    pub fn auth_user(&self, network: models::JadeNetwork) -> Result<bool, anyhow::Error> {
        // It might take some time to enter passphrase on Jade.
        // Use a long timeout for this reason.
        let resp = self.make_request::<models::ReqAuthUser, models::RespAuthUser>(
            "auth_user",
            std::time::Duration::from_secs(300),
            models::ReqAuthUser {
                network: network.name().to_owned(),
            },
        )?;
        let http_resp = handle_http_request(&self.agent, &resp)?;

        if resp.http_request.on_reply == "pin" {
            // New Jade
            let resp = self.make_request::<ciborium::value::Value, models::RespAuthComplete>(
                &resp.http_request.on_reply,
                std::time::Duration::from_secs(300),
                http_resp,
            )?;
            Ok(resp)
        } else {
            // Old Jade
            let resp = self.make_request::<ciborium::value::Value, models::RespAuthUser>(
                &resp.http_request.on_reply,
                std::time::Duration::from_secs(300),
                http_resp,
            )?;
            let http_resp = handle_http_request(&self.agent, &resp)?;
            let resp = self.make_request::<ciborium::value::Value, models::RespAuthComplete>(
                &resp.http_request.on_reply,
                std::time::Duration::from_secs(300),
                http_resp,
            )?;
            Ok(resp)
        }
    }

    pub fn resolve_xpub(
        &self,
        network: models::JadeNetwork,
        path: &[u32],
    ) -> Result<String, anyhow::Error> {
        let resp = self.make_request::<models::ReqGetXPub, models::RespGetXPub>(
            "get_xpub",
            std::time::Duration::from_secs(300),
            models::ReqGetXPub {
                network: network.name().to_owned(),
                path: path.to_owned(),
            },
        )?;
        Ok(resp)
    }

    pub fn master_blinding_key(&self) -> Result<Vec<u8>, anyhow::Error> {
        let resp = self.make_request::<models::EmptyRequest, models::RespGetMasterBlindingKey>(
            "get_master_blinding_key",
            std::time::Duration::from_secs(300),
            None,
        )?;
        Ok(resp)
    }

    pub fn blinding_key(&self, script: Vec<u8>) -> Result<Vec<u8>, anyhow::Error> {
        let resp = self.make_request::<models::ReqGetBlindingKey, models::RespGetBlindingKey>(
            "get_blinding_key",
            std::time::Duration::from_secs(10),
            models::ReqGetBlindingKey {
                script: serde_bytes::ByteBuf::from(script),
            },
        )?;
        Ok(resp.into_vec())
    }

    pub fn shared_nonce(
        &self,
        script: Vec<u8>,
        their_pubkey: Vec<u8>,
    ) -> Result<Vec<u8>, anyhow::Error> {
        let resp = self.make_request::<models::ReqGetSharedNonce, models::RespGetSharedNonce>(
            "get_xpub",
            std::time::Duration::from_secs(10),
            models::ReqGetSharedNonce {
                script: serde_bytes::ByteBuf::from(script),
                their_pubkey: serde_bytes::ByteBuf::from(their_pubkey),
            },
        )?;
        Ok(resp.into_vec())
    }

    pub fn sign_tx(&self, sign_tx: models::ReqSignTx) -> Result<bool, anyhow::Error> {
        let resp = self.make_request::<models::ReqSignTx, models::RespSignTx>(
            "sign_liquid_tx",
            std::time::Duration::from_secs(300),
            sign_tx,
        )?;
        Ok(resp)
    }

    pub fn tx_input(&self, tx_input: Option<models::ReqTxInput>) -> Result<Vec<u8>, anyhow::Error> {
        if let Some(tx_input) = tx_input {
            let resp = self.make_request::<models::ReqTxInput, models::RespTxInput>(
                "tx_input",
                std::time::Duration::from_secs(300),
                tx_input,
            )?;
            Ok(resp.into_vec())
        } else {
            let resp = self.make_request::<models::ReqTxInputEmpty, models::RespTxInput>(
                "tx_input",
                std::time::Duration::from_secs(300),
                models::ReqTxInputEmpty {},
            )?;
            Ok(resp.into_vec())
        }
    }

    pub fn get_signature(
        &self,
        req: Option<serde_bytes::ByteBuf>,
    ) -> Result<Option<Vec<u8>>, anyhow::Error> {
        let resp = self.make_request::<models::ReqGetSignature, models::RespGetSignature>(
            "get_signature",
            std::time::Duration::from_secs(10),
            models::ReqGetSignature {
                ae_host_entropy: req,
            },
        )?;
        match resp {
            ciborium::Value::Bytes(v) => Ok(Some(v)),
            ciborium::Value::Text(v) => {
                let v = base64::engine::general_purpose::STANDARD.decode(v).unwrap();
                Ok(Some(v))
            }
            ciborium::Value::Null => Ok(None),
            _ => Err(anyhow!("unexpected response")),
        }
    }

    pub fn sign_message(&self, req: models::SignMessageReq) -> Result<Vec<u8>, anyhow::Error> {
        let resp = self.make_request::<models::ReqSignMessage, models::RespSignMessage>(
            "sign_message",
            std::time::Duration::from_secs(10),
            models::ReqSignMessage {
                path: req.path,
                message: req.message,
                ae_host_commitment: serde_bytes::ByteBuf::from(req.ae_host_commitment),
            },
        )?;
        Ok(resp.into_vec())
    }
}

// fn serial(efusemac: &str) -> &str {
//     &efusemac[6..]
// }

// fn state(status: &models::RespVersionInfo) -> JadeState {
//     match status.jade_state {
//         models::State::Locked | models::State::Ready => match status.jade_networks {
//             models::StatusNetwork::All => JadeState::Main,
//             models::StatusNetwork::Main => JadeState::Main,
//             models::StatusNetwork::Test => JadeState::Test,
//         },
//         models::State::Uninit | models::State::Unsaved | models::State::Temp => JadeState::Uninit,
//     }
// }

impl JadeMng {
    pub fn new(status_callback: JadeStatusCallback) -> Self {
        let mut transports = Vec::<Arc<dyn Transport>>::new();

        #[cfg(any(target_os = "linux", target_os = "macos", target_os = "windows"))]
        transports.push(Arc::new(transports::serial::SerialTransport::new()));

        #[cfg(any(target_os = "android", target_os = "ios"))]
        transports.push(Arc::new(transports::ble::BleTransport::new()));

        JadeMng {
            transports,
            status_callback,
        }
    }

    pub fn ports(&mut self) -> Result<Vec<ManagedPort>, anyhow::Error> {
        // On macOS Jade reported as two devices.
        // Use BTreeMap to include every Jade just once.
        let mut ports = Vec::new();
        for transport in self.transports.iter() {
            ports.append(&mut transport.ports()?);
        }

        let ports = ports
            .into_iter()
            .map(|port| (port.jade_id.clone(), port))
            .collect::<std::collections::BTreeMap<_, _>>();

        Ok(ports
            .into_iter()
            .map(|(jade_id, jade)| ManagedPort {
                jade_id: jade_id.clone(),
                port_name: jade.port_name,
            })
            .collect())
    }

    pub fn open(&mut self, jade_id: &JadeId) -> Result<ManagedJade, anyhow::Error> {
        let seconds = std::time::SystemTime::now()
            .duration_since(std::time::SystemTime::UNIX_EPOCH)
            .unwrap()
            .as_secs();

        let jade_data = ManagedJadeData {
            connection: None,
            last_request_id: seconds,
        };

        let transport = self
            .transports
            .iter()
            .find(|transport| transport.belongs(jade_id))
            .ok_or_else(|| anyhow!("can't find transport for {jade_id}"))?;

        Ok(ManagedJade {
            jade_id: jade_id.clone(),
            data: Arc::new(Mutex::new(jade_data)),
            agent: ureq::Agent::new(), // FIXME: Use proxy
            transport: Arc::clone(&transport),
            status_callback: Arc::clone(&self.status_callback),
        })
    }
}
