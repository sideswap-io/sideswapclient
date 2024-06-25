use std::{
    sync::{Arc, Mutex},
    time::{Duration, Instant},
};
use tokio::sync::mpsc::{UnboundedReceiver, UnboundedSender};
use tokio::sync::oneshot;

use crate::JadeId;

use super::{Connection, Port, Transport, TransportType};

const MAX_WRITE_SIZE: usize = 500;

pub struct BleTransport {
    msg_sender: tokio::sync::mpsc::UnboundedSender<Msg>,
}

#[derive(Debug)]
pub struct BleConnection {
    msg_sender: tokio::sync::mpsc::UnboundedSender<Msg>,
    jade_id: JadeId,
}

enum Msg {
    Ports(oneshot::Sender<Result<Vec<Port>, anyhow::Error>>),
    Open(JadeId, oneshot::Sender<Result<(), anyhow::Error>>),
    Write(JadeId, Vec<u8>, oneshot::Sender<Result<(), anyhow::Error>>),
    Read(JadeId, oneshot::Sender<Result<Vec<u8>, anyhow::Error>>),
    Close(JadeId),
}

impl BleTransport {
    #[allow(dead_code)]
    pub fn new() -> Self {
        let msg_sender = MSG_SENDER
            .lock()
            .expect("must not fail")
            .clone()
            .expect("MSG_SENDER must be already initialized");

        BleTransport { msg_sender }
    }
}

impl Transport for BleTransport {
    fn transport_type(&self) -> TransportType {
        TransportType::Ble
    }

    fn ports(&self) -> Result<Vec<Port>, anyhow::Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.msg_sender.send(Msg::Ports(res_sender))?;
        res_receiver.blocking_recv()?
    }

    fn belongs(&self, jade_id: &JadeId) -> bool {
        jade_id.starts_with("ble:")
    }

    fn open(&self, jade_id: &JadeId) -> Result<Box<dyn Connection>, anyhow::Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.msg_sender
            .send(Msg::Open(jade_id.clone(), res_sender))?;
        res_receiver.blocking_recv()??;

        Ok(Box::new(BleConnection {
            msg_sender: self.msg_sender.clone(),
            jade_id: jade_id.clone(),
        }))
    }
}

impl Connection for BleConnection {
    fn write(&mut self, data: &[u8]) -> Result<(), anyhow::Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.msg_sender
            .send(Msg::Write(self.jade_id.clone(), data.to_vec(), res_sender))?;
        res_receiver.blocking_recv()?
    }

    fn read(&mut self) -> Result<Vec<u8>, anyhow::Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.msg_sender
            .send(Msg::Read(self.jade_id.clone(), res_sender))?;
        res_receiver.blocking_recv()?
    }
}

impl Drop for BleConnection {
    fn drop(&mut self) {
        let _ = self.msg_sender.send(Msg::Close(self.jade_id.clone()));
    }
}

fn get_jade_id(local_name: &str) -> String {
    format!("ble:{local_name}")
}

struct Data {
    ble_api: Arc<dyn BleApi>,
    scan_activated_at: Option<Instant>,
}

static MSG_SENDER: Mutex<Option<UnboundedSender<Msg>>> = Mutex::new(None);
static MSG_RECEIVER: Mutex<Option<UnboundedReceiver<Msg>>> = Mutex::new(None);

fn start_scan(data: &mut Data) -> Result<(), BleApiError> {
    if data.scan_activated_at.is_none() {
        data.ble_api.start_scan()?;
    }
    data.scan_activated_at = Some(Instant::now());
    Ok(())
}

fn stop_scan(data: &mut Data) {
    if data.scan_activated_at.is_some() {
        data.scan_activated_at = None;
        let res = data.ble_api.stop_scan();
        if let Err(err) = res {
            log::error!("stop scan failed: {err}");
        }
    }
}

fn stop_scan_if_needed(data: &mut Data) {
    if let Some(scan_requested_at) = data.scan_activated_at {
        if Instant::now().duration_since(scan_requested_at) > Duration::from_secs(10) {
            stop_scan(data);
        }
    }
}

fn get_available_devices(data: &mut Data) -> Result<Vec<Port>, BleApiError> {
    let names = data.ble_api.device_names()?;
    let ports = names
        .into_iter()
        .map(|device_name| Port {
            jade_id: get_jade_id(&device_name),
            port_name: device_name,
            serial_number: String::new(),
        })
        .collect();
    Ok(ports)
}

fn start_scan_and_get_available_devices(data: &mut Data) -> Result<Vec<Port>, BleApiError> {
    start_scan(data)?;

    let ports = get_available_devices(data)?;

    Ok(ports)
}

fn open(data: &mut Data, jade_id: &JadeId) -> Result<(), BleApiError> {
    // Make sure device is known
    let started = Instant::now();
    while Instant::now().duration_since(started) < Duration::from_secs(30) {
        let ports = get_available_devices(data)?;
        if ports.iter().any(|port| port.jade_id == *jade_id) {
            break;
        }
        // No bonded or scanned device found, start scan and wait for device
        start_scan(data)?;
        std::thread::sleep(Duration::from_millis(100));
    }

    // It's recommended to stop BLE scan before initiating a new connection
    stop_scan(data);

    let device_name = get_device_name(data, jade_id);

    data.ble_api.open(device_name)?;

    Ok(())
}

fn write(data: &mut Data, jade_id: &JadeId, buf: Vec<u8>) -> Result<(), BleApiError> {
    let device_name = get_device_name(data, jade_id);
    for chunk in buf.chunks(MAX_WRITE_SIZE) {
        data.ble_api.write(device_name.clone(), chunk.to_vec())?;
    }
    Ok(())
}

fn read(data: &mut Data, jade_id: &JadeId) -> Result<Vec<u8>, BleApiError> {
    let device_name = get_device_name(data, jade_id);
    data.ble_api.read(device_name)
}

fn close(data: &mut Data, jade_id: &JadeId) {
    let device_name = get_device_name(data, jade_id);
    let res = data.ble_api.close(device_name);
    if let Err(err) = res {
        log::error!("close failed: {err}");
    }
}

fn get_device_name(_data: &Data, jade_id: &JadeId) -> String {
    jade_id.trim_start_matches("ble:").to_owned()
}

fn process_msg(data: &mut Data, msg: Msg) {
    match msg {
        Msg::Ports(res_sender) => {
            let res = start_scan_and_get_available_devices(data).map_err(Into::into);
            res_sender.send(res).expect("must be open");
        }
        Msg::Open(jade_id, res_sender) => {
            let res = open(data, &jade_id).map_err(Into::into);
            res_sender.send(res).expect("must be open");
        }
        Msg::Write(jade_id, buf, res_sender) => {
            let res = write(data, &jade_id, buf).map_err(Into::into);
            res_sender.send(res).expect("must be open");
        }
        Msg::Read(jade_id, res_sender) => {
            let res = read(data, &jade_id).map_err(Into::into);
            res_sender.send(res).expect("must be open");
        }
        Msg::Close(jade_id) => {
            close(data, &jade_id);
        }
    }
}

async fn run(mut msg_receiver: UnboundedReceiver<Msg>, mut data: Data) {
    loop {
        tokio::select! {
            msg = msg_receiver.recv() => {
                let msg = msg.expect("channel is always open");
                process_msg(&mut data, msg);
            }

            _ = tokio::time::sleep(Duration::from_secs(1)), if data.scan_activated_at.is_some() => {}
        }

        stop_scan_if_needed(&mut data);
    }
}

#[derive(Debug, thiserror::Error, uniffi::Error)]
pub enum BleApiError {
    #[error("{msg}")]
    General { msg: String },
}

impl From<uniffi::UnexpectedUniFFICallbackError> for BleApiError {
    fn from(value: uniffi::UnexpectedUniFFICallbackError) -> Self {
        BleApiError::General {
            msg: value.to_string(),
        }
    }
}

#[uniffi::export(with_foreign)]
pub trait BleApi: Send + Sync {
    fn start_scan(&self) -> Result<(), BleApiError>;

    fn stop_scan(&self) -> Result<(), BleApiError>;

    fn device_names(&self) -> Result<Vec<String>, BleApiError>;

    fn open(&self, device_name: String) -> Result<(), BleApiError>;

    fn write(&self, device_name: String, buf: Vec<u8>) -> Result<(), BleApiError>;

    fn read(&self, device_name: String) -> Result<Vec<u8>, BleApiError>;

    fn close(&self, device_name: String) -> Result<(), BleApiError>;
}

#[derive(uniffi::Object)]
pub struct BleClient {
    ble_api: Arc<dyn BleApi>,
}

#[uniffi::export]
impl BleClient {
    #[uniffi::constructor]
    pub fn new(ble_api: Arc<dyn BleApi>) -> Self {
        let (msg_sender, msg_receiver) = tokio::sync::mpsc::unbounded_channel();
        *MSG_SENDER.lock().expect("must not fail") = Some(msg_sender);
        *MSG_RECEIVER.lock().expect("must not fail") = Some(msg_receiver);

        Self { ble_api }
    }

    pub fn run(&self) {
        let rt = tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .expect("should not fail");

        let data = Data {
            ble_api: Arc::clone(&self.ble_api),
            scan_activated_at: None,
        };

        let msg_receiver = MSG_RECEIVER
            .lock()
            .expect("must not fail")
            .take()
            .expect("MSG_RECEIVER must be already initialized");

        rt.block_on(run(msg_receiver, data));
    }
}

mod uniffi_log {
    // Use a separate module as a workaround for https://github.com/mozilla/uniffi-rs/issues/1702
    #[uniffi::export]
    pub fn log(msg: String) {
        info!("{}", msg);
    }
}
