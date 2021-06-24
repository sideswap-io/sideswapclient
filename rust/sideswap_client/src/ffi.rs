use prost::Message;
use sideswap_common::types::Env;
use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::sync::mpsc::{Receiver, Sender};
use std::sync::Once;

pub mod proto {
    include!(concat!(env!("OUT_DIR"), "/sideswap.proto.rs"));
}

pub type ToMsg = proto::to::Msg;
pub type FromMsg = proto::from::Msg;

static INIT_LOGGER_FLAG: Once = Once::new();

pub struct StartParams {
    pub work_dir: String,
    pub version: String,
}

pub struct Client {
    to_sender: Sender<ToMsg>,
    to_receiver: Option<Receiver<ToMsg>>,
    env: Env,
}

pub struct RecvMessage(Vec<u8>);

// Send pointers to Dart as u64 (even on 32-bit platforms)
pub type IntPtr = u64;

// NOTE: Do not use usize for ffi, use u64 instead.
// Uisng usize breaks generated code on 32 builds (arm7).

#[no_mangle]
pub extern "C" fn sideswap_client_create(env: i32) -> IntPtr {
    let client = create(env);
    let client = Box::into_raw(client);
    client as IntPtr
}

fn get_string(str: *const c_char) -> String {
    let str = unsafe { std::ffi::CStr::from_ptr(str) };
    str.to_str().unwrap().to_owned()
}

#[no_mangle]
pub extern "C" fn sideswap_client_start(
    client: IntPtr,
    work_dir: *const c_char,
    version: *const c_char,
    dart_port: i64,
) {
    let client = unsafe { &mut *(client as *mut Client) };
    let start_params = StartParams {
        work_dir: get_string(work_dir),
        version: get_string(version),
    };
    start(client, start_params, dart_port);
}

#[no_mangle]
pub extern "C" fn sideswap_send_request(client: IntPtr, data: *const u8, len: u64) {
    assert!(client != 0);
    assert!(data != std::ptr::null());
    let client = unsafe { &mut *(client as *mut Client) };
    let slice = unsafe { std::slice::from_raw_parts(data, len as usize) };
    let to = proto::To::decode(slice).expect("message decode failed");
    let msg = to.msg.expect("empty to message");
    client
        .to_sender
        .send(msg)
        .expect("sending to message failed");
}

pub const SIDESWAP_BITCOIN: i32 = 1;
pub const SIDESWAP_ELEMENTS: i32 = 2;

pub const SIDESWAP_ENV_PROD: i32 = 0;
pub const SIDESWAP_ENV_STAGING: i32 = 1;
pub const SIDESWAP_ENV_REGTEST: i32 = 2;
pub const SIDESWAP_ENV_LOCAL: i32 = 3;

#[no_mangle]
pub extern "C" fn sideswap_check_addr(client: IntPtr, addr: *const c_char, addr_type: i32) -> bool {
    assert!(client != 0);
    assert!(addr != std::ptr::null());
    let addr = unsafe { CStr::from_ptr(addr) }
        .to_str()
        .expect("invalid c-str");
    let client = unsafe { &mut *(client as *mut Client) };
    match addr_type {
        SIDESWAP_BITCOIN => check_bitcoin_address(client.env, addr),
        SIDESWAP_ELEMENTS => check_elements_address(client.env, addr),
        _ => panic!("unexpected type"),
    }
}

#[no_mangle]
pub extern "C" fn sideswap_msg_ptr(msg: IntPtr) -> *const u8 {
    assert!(msg != 0);
    let msg = unsafe { &*(msg as *const RecvMessage) };
    msg.0.as_ptr()
}

#[no_mangle]
pub extern "C" fn sideswap_msg_len(msg: IntPtr) -> u64 {
    assert!(msg != 0);
    let msg = unsafe { &*(msg as *const RecvMessage) };
    msg.0.len() as u64
}

#[no_mangle]
pub extern "C" fn sideswap_msg_free(msg: IntPtr) {
    assert!(msg != 0);
    let msg = unsafe { Box::from_raw(msg as *mut RecvMessage) };
    std::mem::drop(msg);
}

#[no_mangle]
pub extern "C" fn sideswap_generate_mnemonic12() -> *mut c_char {
    let str = sideswap_libwally::generate_mnemonic12();
    let value = CString::new(str).unwrap();
    value.into_raw()
}

#[no_mangle]
pub extern "C" fn sideswap_verify_mnemonic(mnemonic: *const c_char) -> bool {
    let mnemonic = unsafe { CStr::from_ptr(mnemonic) };
    sideswap_libwally::verify_mnemonic(&mnemonic.to_str().unwrap())
}

#[no_mangle]
pub extern "C" fn sideswap_string_free(str: *mut c_char) {
    unsafe {
        CString::from_raw(str);
    }
}

const LOG_FILTER: &str = "debug,hyper=info,rustls=info";

#[cfg(target_os = "android")]
fn init_log() {
    android_logger::init_once(
        android_logger::Config::default()
            .with_min_level(log::Level::Debug)
            .with_filter(
                android_logger::FilterBuilder::new()
                    .parse(LOG_FILTER)
                    .build(),
            ),
    );
}

#[cfg(not(target_os = "android"))]
fn init_log() {
    if std::env::var_os("RUST_LOG").is_none() {
        std::env::set_var("RUST_LOG", LOG_FILTER);
    }
    env_logger::init();
}

fn create(env: i32) -> Box<Client> {
    INIT_LOGGER_FLAG.call_once(|| {
        init_log();
    });

    info!("started");

    let env = match env {
        SIDESWAP_ENV_PROD => Env::Prod,
        SIDESWAP_ENV_STAGING => Env::Staging,
        SIDESWAP_ENV_REGTEST => Env::Regtest,
        SIDESWAP_ENV_LOCAL => Env::Local,
        _ => panic!("unknown env"),
    };

    let (to_sender, to_receiver) = std::sync::mpsc::channel::<ToMsg>();

    Box::new(Client {
        env,
        to_sender,
        to_receiver: Some(to_receiver),
    })
}

fn start(client: &mut Client, params: StartParams, dart_port: i64) {
    std::panic::set_hook(Box::new(|i| {
        error!("sideswap panic detected: {:?}", i);
        std::process::abort();
    }));

    let env = client.env;
    let to_receiver = client.to_receiver.take().unwrap();
    let (from_sender, from_receiver) = std::sync::mpsc::channel::<FromMsg>();
    std::thread::Builder::new()
        .name("worker_rust".to_owned())
        .spawn(move || {
            super::worker::start_processing(env, to_receiver, from_sender, params);
        })
        .unwrap();

    std::thread::spawn(move || {
        let port = allo_isolate::Isolate::new(dart_port);
        for msg in from_receiver {
            let from = proto::From { msg: Some(msg) };
            let mut buf = Vec::new();
            from.encode(&mut buf).expect("encoding message failed");
            let msg = std::boxed::Box::new(RecvMessage(buf));
            let msg_ptr = Box::into_raw(msg) as IntPtr;
            let result = port.post(msg_ptr);
            assert!(result == true);
        }
    });
}

fn check_bitcoin_address(env: Env, addr: &str) -> bool {
    let addr = match addr.parse::<bitcoin::Address>() {
        Ok(a) => a,
        Err(_) => return false,
    };
    let script_hash = match addr.payload {
        bitcoin::util::address::Payload::ScriptHash(_) => true,
        _ => false,
    };
    match env {
        Env::Prod | Env::Staging => addr.network == bitcoin::Network::Bitcoin,
        Env::Local | Env::Regtest => {
            addr.network == bitcoin::Network::Regtest
                || addr.network == bitcoin::Network::Testnet && script_hash
        }
    }
}

fn check_elements_address(env: Env, addr: &str) -> bool {
    let addr = match addr.parse::<elements::Address>() {
        Ok(v) => v,
        Err(_) => return false,
    };
    if !addr.is_blinded() {
        return false;
    }
    match env {
        Env::Local | Env::Regtest => *addr.params == elements::AddressParams::ELEMENTS,
        Env::Prod | Env::Staging => *addr.params == elements::AddressParams::LIQUID,
    }
}
