use std::{
    io::{Read, Write},
    net::TcpStream,
    str::FromStr,
    time::Duration,
};

use crate::JadeId;

use super::{Connection, Port, Transport, TransportType};

pub struct TcpTransport {}

impl TcpTransport {
    pub fn new() -> Self {
        TcpTransport {}
    }
}

#[derive(Debug)]
pub struct TcpConnection {
    stream: TcpStream,
}

const TCP_PREFIX: &str = "tcp:";

impl Transport for TcpTransport {
    fn transport_type(&self) -> TransportType {
        TransportType::Tcp
    }

    fn ports(&self) -> Result<Vec<Port>, anyhow::Error> {
        Ok(Vec::new())
    }

    fn belongs(&self, jade_id: &JadeId) -> bool {
        jade_id.starts_with(TCP_PREFIX)
    }

    fn open(&self, jade_id: &JadeId) -> Result<Box<dyn Connection>, anyhow::Error> {
        debug!("open Jade port {}", jade_id);

        let address = jade_id.strip_prefix(TCP_PREFIX).expect("invalid jade_id");

        let socket = std::net::SocketAddrV4::from_str(address)?;

        let stream = TcpStream::connect(socket)?;

        stream.set_read_timeout(Some(Duration::from_millis(1)))?;

        Ok(Box::new(TcpConnection { stream }))
    }
}

impl Connection for TcpConnection {
    fn write(&mut self, data: &[u8]) -> Result<(), anyhow::Error> {
        log::debug!("write: {} bytes", data.len());
        self.stream.write_all(data)?;
        self.stream.flush()?;
        Ok(())
    }

    fn read(&mut self) -> Result<Vec<u8>, anyhow::Error> {
        let mut buf = [0u8; 1024];
        let res = self.stream.read(&mut buf);
        match res {
            Ok(bytes) => Ok(buf[..bytes].to_vec()),
            Err(err) if err.kind() == std::io::ErrorKind::WouldBlock => Ok(Vec::new()),
            Err(err) => Err(err.into()),
        }
    }
}
