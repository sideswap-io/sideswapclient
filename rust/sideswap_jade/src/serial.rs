pub use crate::reader::BufReader;

#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub struct Port {
    pub port_name: String,
    pub serial_number: Option<String>,
}

pub struct Handle {
    port: Box<dyn serialport::SerialPort>,
    quit_flag: std::sync::Arc<std::sync::atomic::AtomicBool>,
}

#[derive(Debug)]
pub enum FromPort {
    Data(Vec<u8>),
    FatalError(anyhow::Error),
}

impl Handle {
    pub fn ports() -> Result<Vec<Port>, anyhow::Error> {
        Ok(serialport::available_ports()?
            .into_iter()
            .filter_map(|port| match port.port_type {
                serialport::SerialPortType::UsbPort(usb_port)
                    if (usb_port.vid == 0x10C4 && usb_port.pid == 0xEA60)
                        || (usb_port.vid == 0x1A86 && usb_port.pid == 0x55D4) =>
                {
                    Some(Port {
                        port_name: port.port_name,
                        serial_number: usb_port.serial_number,
                    })
                }
                _ => None,
            })
            .collect())
    }

    pub fn new<F>(port: Port, mut callback: F) -> Result<Self, anyhow::Error>
    where
        F: 'static + Send + FnMut(FromPort) -> (),
    {
        debug!("open Jade port {}", port.port_name);
        let port = serialport::new(&port.port_name, 115200)
            .timeout(std::time::Duration::from_secs(15))
            .open()?;
        let quit_flag = std::sync::Arc::new(std::sync::atomic::AtomicBool::default());

        let mut port_copy = port.try_clone()?;
        let quit_flag_copy = quit_flag.clone();
        std::thread::spawn(move || {
            let reader = BufReader::default();
            let mut buffer = [0u8; 32768];
            loop {
                debug!("start jade read...");
                match port_copy.read(&mut buffer) {
                    Ok(bytes) => {
                        debug!("received {} bytes", bytes);
                        reader.append_data(&buffer[..bytes]);

                        loop {
                            reader.reset_pos();
                            match ciborium::de::from_reader::<ciborium::value::Value, _>(
                                reader.clone(),
                            ) {
                                Ok(v) => {
                                    debug!("recv: {:?}", &v);
                                    let data = reader.remove_read();
                                    callback(FromPort::Data(data));
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
                    Err(e) if e.kind() == std::io::ErrorKind::TimedOut => {
                        debug!("jade read timeout");
                        if quit_flag_copy.load(std::sync::atomic::Ordering::Relaxed) {
                            debug!("stop reading thread");
                            return;
                        }
                    }
                    Err(e) => {
                        error!("fatal reading error: {}", e);
                        callback(FromPort::FatalError(e.into()));
                        return;
                    }
                }
            }
        });

        Ok(Self { port, quit_flag })
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
        self.port.write_all(&buf)?;
        self.port.flush()?;
        debug!("jade write succeed");
        Ok(())
    }
}

impl Drop for Handle {
    fn drop(&mut self) {
        self.quit_flag
            .store(true, std::sync::atomic::Ordering::Relaxed);
    }
}
