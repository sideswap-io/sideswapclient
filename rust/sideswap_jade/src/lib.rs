uniffi::setup_scaffolding!();

#[macro_use]
extern crate log;
#[macro_use]
extern crate anyhow;

pub type JadeId = String; // vid+pid+serial

pub mod byte_array;
mod http_request;
pub mod jade_mng;
pub mod models;
mod reader;
mod transports;
