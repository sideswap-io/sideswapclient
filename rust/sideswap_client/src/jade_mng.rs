pub type JadeId = String; // USB device serial number

#[derive(Debug)]
pub struct ManagedPort {
    pub jade_id: JadeId,
    pub serial: String,
    pub port_name: String,
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
            .find(|port| port.serial_number == *jade_id)
            .ok_or_else(|| anyhow!("jade device not found"))?;
        let resp_sender = data.resp_sender.clone();
        let callback = move |msg| {
            let _jade = resp_sender.send(msg);
        };
        let jade = sideswap_jade::Jade::new(port.clone(), callback)?;
        data.jade = Some(jade);
    }
    data.jade.as_ref().unwrap().send(req);
    Ok(())
}

fn try_recv(
    data: &mut ManagedJadeData,
    timeout: std::time::Duration,
) -> Result<sideswap_jade::Resp, anyhow::Error> {
    data.jade
        .as_ref()
        .ok_or_else(|| anyhow!("jade is not connected"))?;
    let result = data.resp_receiver.recv_timeout(timeout)?;
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

    pub fn recv(&self, timeout: std::time::Duration) -> Result<sideswap_jade::Resp, anyhow::Error> {
        let mut data = self.data.lock().unwrap();
        try_recv(&mut data, timeout)
    }
}

pub struct JadeMng {}

impl JadeMng {
    pub fn new() -> Self {
        JadeMng {}
    }

    pub fn ports(&mut self) -> Result<Vec<ManagedPort>, anyhow::Error> {
        // On macOS Jade reported as two deviced.
        // Use BTreeMap to include every Jade just once.
        let ports = sideswap_jade::Handle::ports()?
            .into_iter()
            .map(|port| {
                (
                    port.serial_number.clone(),
                    ManagedPort {
                        jade_id: port.serial_number.clone(),
                        serial: port.serial_number.clone(),
                        port_name: port.port_name,
                    },
                )
            })
            .collect::<std::collections::BTreeMap<_, _>>();
        let ports = ports.into_values().collect();
        Ok(ports)
    }

    pub fn open(&mut self, jade_id: &JadeId) -> ManagedJade {
        let (resp_sender, resp_receiver) = std::sync::mpsc::channel();
        let jade_data = ManagedJadeData {
            resp_sender,
            resp_receiver,
            jade: None,
        };
        let jade = ManagedJade {
            jade_id: jade_id.clone(),
            data: std::sync::Arc::new(std::sync::Mutex::new(jade_data)),
        };
        jade
    }
}
