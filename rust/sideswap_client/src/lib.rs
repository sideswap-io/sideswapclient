#![recursion_limit = "1024"]
#[macro_use]
extern crate anyhow;
extern crate serde;
extern crate tungstenite;
extern crate url;
#[macro_use]
extern crate log;
extern crate sideswap_api;
#[macro_use]
extern crate diesel;
#[macro_use]
extern crate diesel_migrations;
extern crate qrcode;
#[macro_use]
extern crate futures;
extern crate clap;
extern crate dirs;

pub mod db;
pub mod hist;
pub mod models;
pub mod rpc;
pub mod schema;
pub mod settings;
pub mod ui;
pub mod worker;
pub mod ws;
pub mod ffi;