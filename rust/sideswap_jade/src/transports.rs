use crate::JadeId;

#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub struct Port {
    pub jade_id: JadeId,
    pub port_name: String,
    pub serial_number: String,
}

#[allow(dead_code)]
pub enum TransportType {
    Serial,
    Ble,
}

pub trait Transport {
    fn transport_type(&self) -> TransportType;
    fn ports(&self) -> Result<Vec<Port>, anyhow::Error>;
    fn belongs(&self, jade_id: &JadeId) -> bool;
    fn open(&self, jade_id: &JadeId) -> Result<Box<dyn Connection>, anyhow::Error>;
}

pub trait Connection: Send + std::fmt::Debug {
    fn write(&mut self, data: &[u8]) -> Result<(), anyhow::Error>;
    fn read(&mut self) -> Result<Vec<u8>, anyhow::Error>;
}

#[cfg(any(target_os = "linux", target_os = "macos", target_os = "windows"))]
pub mod serial;

pub mod ble;
