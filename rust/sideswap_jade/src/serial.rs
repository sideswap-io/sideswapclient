pub use crate::reader::BufReader;

pub type JadeId = String; // vid+pid+serial

#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub struct Port {
    pub jade_id: JadeId,
    pub port_name: String,
    pub serial_number: String,
}

pub struct Handle {
    #[cfg(any(target_os = "linux", target_os = "macos", target_os = "windows"))]
    sender: crossbeam_channel::Sender<Vec<u8>>,
}

#[derive(Debug)]
pub enum FromPort {
    Data(Vec<u8>),
    FatalError(anyhow::Error),
}

#[cfg(any(target_os = "linux", target_os = "macos", target_os = "windows"))]
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

#[cfg(any(target_os = "linux", target_os = "macos", target_os = "windows"))]
impl Handle {
    pub fn ports() -> Result<Vec<Port>, anyhow::Error> {
        Ok(serialport::available_ports()?
            .into_iter()
            .filter_map(|port| match port.port_type {
                serialport::SerialPortType::UsbPort(usb_port)
                    // From https://github.com/Blockstream/Jade/tree/master/diy
                    if (usb_port.vid == 0x10C4 && usb_port.pid == 0xEA60)
                        || (usb_port.vid == 0x1A86 && usb_port.pid == 0x55D4)
                        || (usb_port.vid == 0x0403 && usb_port.pid == 0x6001)
                        || (usb_port.vid == 0x1A86 && usb_port.pid == 0x7523) =>
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

    pub fn new<F>(port: Port, mut callback: F) -> Result<Self, anyhow::Error>
    where
        F: 'static + Send + FnMut(FromPort),
    {
        debug!("open Jade port {}", port.jade_id);
        let mut port = serialport::new(&port.port_name, 115200)
            .timeout(std::time::Duration::from_millis(50))
            .open()?;

        let (sender, receiver) = crossbeam_channel::unbounded::<Vec<u8>>();

        std::thread::spawn(move || {
            let reader = BufReader::default();
            let mut buffer = [0u8; 32768];

            debug!("start jade read thread");

            // Drop old data if any
            loop {
                match port.read(&mut buffer) {
                    Ok(bytes) => {
                        debug!("discard {} bytes: {}", bytes, hex::encode(&buffer[..bytes]));
                    }
                    Err(e) if e.kind() == std::io::ErrorKind::TimedOut => {
                        break;
                    }
                    Err(e) => {
                        error!("fatal reading error: {}", e);
                        callback(FromPort::FatalError(e.into()));
                        return;
                    }
                }
            }

            loop {
                loop {
                    let recv_result = receiver.try_recv();
                    match recv_result {
                        Ok(v) => {
                            debug!("send {} bytes: {}", v.len(), hex::encode(&v));
                            let result = port.write_all(&v);
                            if let Err(e) = result {
                                callback(FromPort::FatalError(e.into()));
                                return;
                            }
                            let result = port.flush();
                            if let Err(e) = result {
                                callback(FromPort::FatalError(e.into()));
                                return;
                            }
                        }
                        Err(crossbeam_channel::TryRecvError::Empty) => {
                            break;
                        }
                        Err(crossbeam_channel::TryRecvError::Disconnected) => {
                            debug!("stop reading thread");
                            return;
                        }
                    }
                }

                match port.read(&mut buffer) {
                    Ok(bytes) => {
                        debug!(
                            "received {} bytes: {}",
                            bytes,
                            hex::encode(&buffer[..bytes])
                        );
                        reader.append_data(&buffer[..bytes]);

                        loop {
                            reader.reset_pos();
                            match ciborium::de::from_reader::<ciborium::value::Value, _>(
                                reader.clone(),
                            ) {
                                Ok(v) => {
                                    debug!("recv: {:?}", &v);
                                    let data = reader.remove_read();

                                    let log_message = v
                                        .as_map()
                                        .map(|map| {
                                            map.iter()
                                                .any(|(key, _value)| key.as_text() == Some("log"))
                                        })
                                        .unwrap_or_default();
                                    if !log_message {
                                        callback(FromPort::Data(data));
                                    } else {
                                        debug!("drop log message");
                                    }
                                    if reader.size() == 0 {
                                        break;
                                    }
                                }
                                Err(e) => {
                                    debug!("decode failed: {}, wait for more data", e);
                                    break;
                                }
                            }
                        }
                    }
                    Err(e) if e.kind() == std::io::ErrorKind::TimedOut => {}
                    Err(e) => {
                        error!("fatal reading error: {}", e);
                        callback(FromPort::FatalError(e.into()));
                        return;
                    }
                }
            }
        });

        Ok(Self { sender })
    }

    pub fn send<T>(&mut self, data: &T) -> Result<(), anyhow::Error>
    where
        T: serde::Serialize,
    {
        let mut buf = Vec::<u8>::new();
        ciborium::ser::into_writer(&data, &mut buf).unwrap();
        debug!(
            "send: {:?}",
            &ciborium::de::from_reader::<ciborium::value::Value, _>(buf.as_slice()).unwrap()
        );
        self.sender.send(buf)?;
        Ok(())
    }
}

#[cfg(any(target_os = "android", target_os = "ios"))]
impl Handle {
    pub fn ports() -> Result<Vec<Port>, anyhow::Error> {
        Ok(Vec::new())
    }

    pub fn new<F>(_port: Port, _callback: F) -> Result<Self, anyhow::Error>
    where
        F: 'static + Send + FnMut(FromPort) -> (),
    {
        unreachable!()
    }

    pub fn send<T>(&mut self, _data: &T) -> Result<(), anyhow::Error>
    where
        T: serde::Serialize,
    {
        unreachable!()
    }
}
