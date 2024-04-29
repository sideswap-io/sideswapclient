use std::{
    collections::BTreeMap,
    time::{Duration, Instant},
};

use btleplug::api::{Central, Manager, Peripheral, ScanFilter, WriteType};
use futures::{Stream, StreamExt};
use tokio::sync::oneshot;

use crate::JadeId;

use super::{Connection, Port, Transport};

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

const SERVICE_UUID: uuid::Uuid = uuid::uuid!("6E400001-B5A3-F393-E0A9-E50E24DCCA9E");
const WRITE_CHAR_UUID: uuid::Uuid = uuid::uuid!("6E400002-B5A3-F393-E0A9-E50E24DCCA9E");
const INDICATE_CHAR_UUID: uuid::Uuid = uuid::uuid!("6E400003-B5A3-F393-E0A9-E50E24DCCA9E");

impl BleTransport {
    #[cfg(not(target_os = "android"))]
    pub fn new() -> Self {
        let (msg_sender, msg_receiver) = tokio::sync::mpsc::unbounded_channel();
        std::thread::spawn(move || {
            let rt = tokio::runtime::Builder::new_current_thread()
                .enable_all()
                .build()
                .expect("should not fail");
            rt.block_on(run(msg_receiver));
        });

        BleTransport { msg_sender }
    }

    #[cfg(target_os = "android")]
    pub fn new() -> Self {
        let msg_sender = MSG_SENDER
            .lock()
            .expect("MSG_SENDER must be already initialized")
            .clone()
            .unwrap();

        BleTransport { msg_sender }
    }
}

impl Transport for BleTransport {
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

struct Data {
    adapter: btleplug::platform::Adapter,
    connected: BTreeMap<JadeId, ConnectedData>,
    scan_activated_at: Option<Instant>,
}

struct ConnectedData {
    peripheral: btleplug::platform::Peripheral,
    write_char: btleplug::api::Characteristic,
    read_char: btleplug::api::Characteristic,
    notification_stream:
        std::pin::Pin<Box<dyn Stream<Item = btleplug::api::ValueNotification> + Send>>,
}

fn get_jade_id(local_name: &str) -> String {
    format!("ble:{local_name}")
}

async fn ports(data: &mut Data) -> Result<Vec<Port>, anyhow::Error> {
    start_scan(data).await?;

    let peripherals = data.adapter.peripherals().await?;
    let mut ports = Vec::new();

    for peripheral in peripherals {
        let properties = peripheral.properties().await?;
        let local_name = properties.and_then(|properties| properties.local_name);
        if let Some(local_name) = local_name {
            if local_name.starts_with("Jade") {
                ports.push(Port {
                    jade_id: get_jade_id(&local_name),
                    port_name: local_name,
                    serial_number: String::new(),
                });
            }
        }
    }

    Ok(ports)
}

struct FoundDevice {
    peripheral: btleplug::platform::Peripheral,
    local_name: String,
}

async fn find_device(data: &mut Data, jade_id: &JadeId) -> Result<FoundDevice, anyhow::Error> {
    for index in 0..20 {
        let peripherals = data.adapter.peripherals().await?;

        for peripheral in peripherals {
            let properties = peripheral.properties().await?;
            let local_name = properties.and_then(|properties| properties.local_name);

            if let Some(local_name) = local_name {
                let id = get_jade_id(&local_name);
                if id == *jade_id {
                    return Ok(FoundDevice {
                        peripheral,
                        local_name,
                    });
                }
            }
        }

        if index == 0 {
            start_scan(data).await?;
        }

        tokio::time::sleep(Duration::from_secs(1)).await;
    }

    bail!("device not found");
}

async fn open(data: &mut Data, jade_id: JadeId) -> Result<(), anyhow::Error> {
    close(data, &jade_id).await;

    let FoundDevice {
        peripheral,
        local_name,
    } = find_device(data, &jade_id).await?;

    let is_connected = peripheral.is_connected().await?;
    if !is_connected {
        log::debug!("start connecting to BLE device {}", &local_name);
        peripheral.connect().await?;
        log::debug!("finish connecting to BLE device {}", &local_name);
    }

    log::debug!("start discovering BLE services on {}", &local_name);
    peripheral.discover_services().await?;
    log::debug!("finish discovering BLE services on {}", &local_name);

    let chars = peripheral.characteristics();
    let read_char = chars
        .iter()
        .find(|c| c.uuid == INDICATE_CHAR_UUID)
        .ok_or_else(|| anyhow!("INDICATE_CHAR_UUID not found"))?
        .clone();
    let write_char = chars
        .iter()
        .find(|c| c.uuid == WRITE_CHAR_UUID)
        .ok_or_else(|| anyhow!("WRITE_CHAR_UUID not found"))?
        .clone();

    let notification_stream = peripheral.notifications().await?;

    peripheral.subscribe(&read_char).await?;

    data.connected.insert(
        jade_id,
        ConnectedData {
            peripheral,
            write_char,
            read_char,
            notification_stream,
        },
    );

    Ok(())
}

async fn write(data: &mut Data, jade_id: JadeId, buf: Vec<u8>) -> Result<(), anyhow::Error> {
    let connected_data = data
        .connected
        .get_mut(&jade_id)
        .ok_or_else(|| anyhow!("not connected"))?;
    // FIXME: Use correct chunk size
    for chunk in buf.chunks(200) {
        connected_data
            .peripheral
            .write(&connected_data.write_char, chunk, WriteType::WithResponse)
            .await?;
    }
    Ok(())
}

async fn read(data: &mut Data, jade_id: JadeId) -> Result<Vec<u8>, anyhow::Error> {
    let connected_data = data
        .connected
        .get_mut(&jade_id)
        .ok_or_else(|| anyhow!("not connected"))?;
    let res = tokio::time::timeout(
        Duration::from_millis(10),
        connected_data.notification_stream.next(),
    )
    .await;
    match res {
        Ok(Some(notif)) => Ok(notif.value),
        Ok(None) => Ok(Vec::new()),
        Err(_timeout) => Ok(Vec::new()),
    }
}

async fn close(data: &mut Data, jade_id: &JadeId) {
    let connected_data = data.connected.get_mut(jade_id);
    if let Some(connected_data) = connected_data {
        let _ = connected_data
            .peripheral
            .unsubscribe(&connected_data.read_char)
            .await;
    }
    data.connected.remove(jade_id);
}

async fn process_msg(data: &mut Data, msg: Msg) {
    match msg {
        Msg::Ports(res_sender) => {
            let res = ports(data).await;
            res_sender.send(res).expect("must be open");
        }
        Msg::Open(jade_id, res_sender) => {
            let res = open(data, jade_id).await;
            res_sender.send(res).expect("must be open");
        }
        Msg::Write(jade_id, buf, res_sender) => {
            let res = write(data, jade_id, buf).await;
            res_sender.send(res).expect("must be open");
        }
        Msg::Read(jade_id, res_sender) => {
            let res = read(data, jade_id).await;
            res_sender.send(res).expect("must be open");
        }
        Msg::Close(jade_id) => {
            close(data, &jade_id).await;
        }
    }
}

async fn start_scan(data: &mut Data) -> Result<(), anyhow::Error> {
    if data.scan_activated_at.is_none() {
        log::debug!("start BLE scan...");
        data.scan_activated_at = Some(Instant::now());
        data.adapter
            .start_scan(ScanFilter {
                services: vec![SERVICE_UUID],
            })
            .await?;
        log::debug!("BLE scan started");
    }
    data.scan_activated_at = Some(Instant::now());
    Ok(())
}

async fn stop_scan_if_needed(data: &mut Data) {
    if let Some(scan_requested_at) = data.scan_activated_at {
        if Instant::now().duration_since(scan_requested_at) > Duration::from_secs(10) {
            let res = data.adapter.stop_scan().await;
            if let Err(err) = res {
                log::error!("stopping scan failed: {err}");
            }
            log::debug!("BLE scan stopped");
            data.scan_activated_at = None;
        }
    }
}

async fn try_run(
    mut msg_receiver: tokio::sync::mpsc::UnboundedReceiver<Msg>,
) -> Result<(), anyhow::Error> {
    let first_msg = match msg_receiver.recv().await {
        Some(msg) => msg,
        None => return Ok(()),
    };

    // Do not try to create a new Manager until the first message is received.
    // We want to show Bluetooth promp only when needed.
    let manager = btleplug::platform::Manager::new().await?;
    let adapter_list = manager.adapters().await?;
    let adapter = adapter_list
        .into_iter()
        .next()
        .ok_or_else(|| anyhow!("not BLE adapters found"))?;

    let mut data = Data {
        adapter,
        connected: BTreeMap::new(),
        scan_activated_at: None,
    };

    process_msg(&mut data, first_msg).await;

    loop {
        tokio::select! {
            msg = msg_receiver.recv() => {
                match msg {
                    Some(msg) => {
                        process_msg(&mut data, msg).await;
                    },
                    None => {
                        break;
                    },
                }
            },

            _ = tokio::time::sleep(Duration::from_secs(1)), if data.scan_activated_at.is_some() => {}
        }

        stop_scan_if_needed(&mut data).await;
    }

    Ok(())
}

async fn run(msg_receiver: tokio::sync::mpsc::UnboundedReceiver<Msg>) {
    let res = try_run(msg_receiver).await;
    if let Err(err) = res {
        log::error!("BLE worker failed: {err}");
    }
}

#[cfg(target_os = "android")]
static MSG_SENDER: std::sync::Mutex<Option<tokio::sync::mpsc::UnboundedSender<Msg>>> =
    std::sync::Mutex::new(None);

#[cfg(target_os = "android")]
#[no_mangle]
pub extern "system" fn Java_io_sideswap_MainActivity_bleThread<'local>(
    env: jni::JNIEnv<'local>,
    _class: jni::objects::JClass<'local>,
) {
    jni_utils::init(&env).unwrap();
    btleplug::platform::init(&env).unwrap();

    let (msg_sender, msg_receiver) = tokio::sync::mpsc::unbounded_channel();
    *MSG_SENDER.lock().unwrap() = Some(msg_sender);

    let rt = tokio::runtime::Builder::new_current_thread()
        .enable_all()
        .build()
        .expect("should not fail");
    rt.block_on(run(msg_receiver));
}
