use std::{collections::BTreeMap, time::Duration};

use sideswap_jade::serial::JadeId;

#[derive(Debug, Clone, Copy)]
pub enum JadeState {
    Uninit,
    Main,
    Test,
}

#[derive(Debug)]
pub struct ManagedPort {
    pub jade_id: JadeId,
    pub serial: String,
    pub version: String,
    pub port_name: String,
    pub state: JadeState,
}

struct ManagedJadeData {
    resp_sender: std::sync::mpsc::Sender<sideswap_jade::WorkerResp>,
    resp_receiver: std::sync::mpsc::Receiver<sideswap_jade::WorkerResp>,
    jade: Option<sideswap_jade::Jade>,
}

pub struct ManagedJade {
    jade_id: JadeId,
    data: std::sync::Arc<std::sync::Mutex<ManagedJadeData>>,
}

fn try_send(
    data: &mut ManagedJadeData,
    jade_id: &JadeId,
    req: sideswap_jade::Req,
) -> Result<(), anyhow::Error> {
    if data.jade.is_none() {
        let ports = sideswap_jade::Handle::ports()?;
        let port = ports
            .into_iter()
            .find(|port| port.jade_id == *jade_id)
            .ok_or_else(|| anyhow!("jade device not found"))?;
        let resp_sender = data.resp_sender.clone();
        let callback = move |msg| {
            let _jade = resp_sender.send(msg);
        };
        let jade = sideswap_jade::Jade::new(port, callback)?;
        data.jade = Some(jade);
    }
    data.jade.as_ref().unwrap().send(req);
    Ok(())
}

fn try_recv(
    data: &mut ManagedJadeData,
    timeout: Duration,
) -> Result<sideswap_jade::Resp, anyhow::Error> {
    data.jade
        .as_ref()
        .ok_or_else(|| anyhow!("jade is not connected"))?;
    let result = data
        .resp_receiver
        .recv_timeout(timeout)
        .map_err(|_| anyhow!("jade response timeout"))?;
    match result {
        sideswap_jade::WorkerResp::Resp(v) => v,
        sideswap_jade::WorkerResp::FatalError(e) => {
            data.jade = None;
            bail!("unexpected fatal Jade error: {}", e);
        }
    }
}

impl ManagedJade {
    pub fn send(&self, req: sideswap_jade::Req) {
        let mut data = self.data.lock().unwrap();
        let result = try_send(&mut data, &self.jade_id, req);
        if let Err(e) = result {
            error!(
                "sending jade request failed: {}, jade_id: {}",
                e, self.jade_id
            );
        }
    }

    pub fn recv(&self, timeout: Duration) -> Result<sideswap_jade::Resp, anyhow::Error> {
        let mut data = self.data.lock().unwrap();
        try_recv(&mut data, timeout)
    }
}

struct JadeStatus {
    port_name: String,
    version: String,
    serial: String,
    state: JadeState,
}

pub struct JadeMng {
    known_ports: BTreeMap<JadeId, JadeStatus>,
}

fn serial(efusemac: &str) -> &str {
    &efusemac[6..]
}

fn state(status: &sideswap_jade::models::RespVersionInfo) -> JadeState {
    match status.jade_state {
        sideswap_jade::models::State::Locked | sideswap_jade::models::State::Ready => {
            match status.jade_networks {
                sideswap_jade::models::StatusNetwork::All => JadeState::Main,
                sideswap_jade::models::StatusNetwork::Main => JadeState::Main,
                sideswap_jade::models::StatusNetwork::Test => JadeState::Test,
            }
        }
        sideswap_jade::models::State::Uninit
        | sideswap_jade::models::State::Unsaved
        | sideswap_jade::models::State::Temp => JadeState::Uninit,
    }
}

impl JadeMng {
    pub fn new() -> Self {
        JadeMng {
            known_ports: BTreeMap::new(),
        }
    }

    pub fn ports(&mut self) -> Result<Vec<ManagedPort>, anyhow::Error> {
        // On macOS Jade reported as two devices.
        // Use BTreeMap to include every Jade just once.
        let ports = sideswap_jade::Handle::ports()?
            .into_iter()
            .map(|port| (port.jade_id.clone(), port))
            .collect::<std::collections::BTreeMap<_, _>>();

        // Erase removed devices
        self.known_ports
            .retain(|jade_id, _jade| ports.contains_key(jade_id));

        // Open and add new devices
        for (jade_id, jade) in ports.into_iter() {
            if !self.known_ports.contains_key(&jade.jade_id) {
                let jade_dev = self.open(&jade_id);
                jade_dev.send(sideswap_jade::Req::ReadStatus);
                let res = jade_dev.recv(Duration::from_secs(1));
                if let Ok(sideswap_jade::Resp::ReadStatus(status)) = res {
                    self.known_ports.insert(
                        jade_id,
                        JadeStatus {
                            port_name: jade.port_name,
                            version: status.jade_version.clone(),
                            serial: serial(&status.efusemac).to_owned(),
                            state: state(&status),
                        },
                    );
                }
            }
        }

        Ok(self
            .known_ports
            .iter()
            .map(|(jade_id, jade)| match jade {
                JadeStatus {
                    version,
                    serial,
                    port_name,
                    state,
                } => ManagedPort {
                    jade_id: jade_id.clone(),
                    serial: serial.clone(),
                    version: version.clone(),
                    port_name: port_name.clone(),
                    state: *state,
                },
            })
            .collect())
    }

    pub fn open(&mut self, jade_id: &JadeId) -> ManagedJade {
        let (resp_sender, resp_receiver) = std::sync::mpsc::channel();
        let jade_data = ManagedJadeData {
            resp_sender,
            resp_receiver,
            jade: None,
        };

        ManagedJade {
            jade_id: jade_id.clone(),
            data: std::sync::Arc::new(std::sync::Mutex::new(jade_data)),
        }
    }
}
