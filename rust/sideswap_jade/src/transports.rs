use crate::JadeId;

#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub struct Port {
    pub jade_id: JadeId,
    pub port_name: String,
    pub serial_number: String,
}

pub trait Transport {
    fn ports(&self) -> Result<Vec<Port>, anyhow::Error>;
    fn belongs(&self, jade_id: &JadeId) -> bool;
    fn open(&self, jade_id: &JadeId) -> Result<Box<dyn Connection>, anyhow::Error>;
}

pub trait Connection: Send + std::fmt::Debug {
    fn write(&mut self, data: &[u8]) -> Result<(), anyhow::Error>;
    fn read(&mut self) -> Result<Vec<u8>, anyhow::Error>;
}

pub struct AllTransports {
    transports: Vec<Box<dyn Transport>>,
}

impl AllTransports {
    pub fn new() -> Self {
        let mut transports = Vec::<Box<dyn Transport>>::new();

        #[cfg(any(target_os = "linux", target_os = "macos", target_os = "windows"))]
        transports.push(Box::new(serial::SerialTransport::new()));

        transports.push(Box::new(ble::BleTransport::new()));

        AllTransports { transports }
    }
}

impl Transport for AllTransports {
    fn ports(&self) -> Result<Vec<Port>, anyhow::Error> {
        let mut ports = Vec::new();
        for transport in self.transports.iter() {
            let new_ports_res = transport.ports();
            match new_ports_res {
                Ok(mut new_ports) => {
                    ports.append(&mut new_ports);
                }
                Err(err) => {
                    log::error!("port scan failed: {err}");
                }
            }
        }
        Ok(ports)
    }

    fn belongs(&self, _jade_id: &JadeId) -> bool {
        true
    }

    fn open(&self, jade_id: &JadeId) -> Result<Box<dyn Connection>, anyhow::Error> {
        for transport in self.transports.iter() {
            if transport.belongs(jade_id) {
                return transport.open(jade_id);
            }
        }
        bail!("Unknown jade_id: {}", jade_id);
    }
}

#[cfg(any(target_os = "linux", target_os = "macos", target_os = "windows"))]
mod serial;

mod ble;
