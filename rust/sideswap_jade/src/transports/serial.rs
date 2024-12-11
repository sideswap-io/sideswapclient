use crate::JadeId;

use super::{Connection, Port, Transport, TransportType};

pub struct SerialTransport {}

impl SerialTransport {
    pub fn new() -> Self {
        SerialTransport {}
    }
}

#[derive(Debug)]
pub struct SerialConnection {
    port: Box<dyn serialport::SerialPort>,
}

pub fn get_jade_id(usb_port: &serialport::UsbPortInfo) -> JadeId {
    let serial_number: &str = match &usb_port.serial_number {
        Some(serial_number) => serial_number,
        None => "unknown",
    };
    format!(
        "{:#06x}-{:#06x}-{}",
        usb_port.vid, usb_port.pid, serial_number
    )
}

impl Transport for SerialTransport {
    fn transport_type(&self) -> TransportType {
        TransportType::Serial
    }

    fn ports(&self) -> Result<Vec<Port>, anyhow::Error> {
        // From https://github.com/Blockstream/lwk/blob/master/lwk_jade/src/lib.rs#L62
        pub const JADE_DEVICE_IDS: [(u16, u16); 6] = [
            (0x10c4, 0xea60),
            (0x1a86, 0x55d4),
            (0x0403, 0x6001),
            (0x1a86, 0x7523),
            // new
            (0x303a, 0x4001),
            (0x303a, 0x1001),
        ];

        Ok(serialport::available_ports()?
            .into_iter()
            .filter_map(|port| match port.port_type {
                serialport::SerialPortType::UsbPort(usb_port)
                    if JADE_DEVICE_IDS
                        .iter()
                        .any(|&(vid, pid)| usb_port.vid == vid && usb_port.pid == pid) =>
                {
                    Some(Port {
                        jade_id: get_jade_id(&usb_port),
                        port_name: port.port_name,
                        serial_number: usb_port.serial_number.clone().unwrap_or_default(),
                    })
                }
                _ => None,
            })
            .collect())
    }

    fn belongs(&self, jade_id: &JadeId) -> bool {
        jade_id.chars().filter(|char| *char == '-').count() == 2
    }

    fn open(&self, jade_id: &JadeId) -> Result<Box<dyn Connection>, anyhow::Error> {
        debug!("open Jade port {}", jade_id);
        let ports = self.ports()?;
        let port = ports
            .into_iter()
            .find(|port| port.jade_id == *jade_id)
            .ok_or_else(|| anyhow!("jade device not found"))?;

        let port = serialport::new(&port.port_name, 115200)
            .timeout(std::time::Duration::from_millis(100))
            .open()?;

        Ok(Box::new(SerialConnection { port }))
    }
}

impl Connection for SerialConnection {
    fn write(&mut self, data: &[u8]) -> Result<(), anyhow::Error> {
        self.port.write_all(data)?;
        self.port.flush()?;
        Ok(())
    }

    fn read(&mut self) -> Result<Vec<u8>, anyhow::Error> {
        let mut buf = [0u8; 1024];
        let res = self.port.read(&mut buf);
        match res {
            Ok(bytes) => Ok(buf[..bytes].to_vec()),
            Err(err) if err.kind() == std::io::ErrorKind::TimedOut => Ok(Vec::new()),
            Err(err) => Err(err.into()),
        }
    }
}
