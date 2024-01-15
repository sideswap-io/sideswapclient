use serde::{Deserialize, Serialize};
use serde_json::json;
use std::collections::BTreeMap;
use std::vec::Vec;

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct RpcServer {
    pub host: String,
    pub port: u16,
    pub login: String,
    pub password: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RpcRequest {
    pub method: String,
    pub params: serde_json::value::Value,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RpcError {
    pub message: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RpcResult<T> {
    pub result: Option<T>,
    pub error: Option<RpcError>,
}

fn make_rpc_impl(
    http_client: &reqwest::blocking::Client,
    rpc_server: &RpcServer,
    req: &RpcRequest,
) -> Result<(String, reqwest::StatusCode), anyhow::Error> {
    let endpoint = format!("http://{}:{}", &rpc_server.host, rpc_server.port);
    let res = http_client
        .post(endpoint)
        .basic_auth(&rpc_server.login, Some(&rpc_server.password))
        .json(&req)
        .send()?;
    let status = res.status();
    let data = std::str::from_utf8(&res.bytes()?)?.to_owned();
    Ok((data, status))
}

pub fn make_rpc(
    http_client: &reqwest::blocking::Client,
    rpc_server: &RpcServer,
    req: &RpcRequest,
) -> Result<(String, reqwest::StatusCode), anyhow::Error> {
    make_rpc_impl(http_client, rpc_server, req)
}

pub fn make_rpc_call_silent<T: serde::de::DeserializeOwned>(
    http_client: &reqwest::blocking::Client,
    rpc_server: &RpcServer,
    req: &RpcRequest,
) -> Result<T, anyhow::Error> {
    let response = make_rpc(http_client, rpc_server, req)?;
    let response = serde_json::from_str::<RpcResult<T>>(&response.0)?;
    if let Some(error) = response.error {
        error!("rpc failed: {}", error.message);
        Err(anyhow!("RPC failed: {}", error.message))
    } else if let Some(result) = response.result {
        Ok(result)
    } else {
        error!("empty RPC response");
        Err(anyhow!("empty RPC response"))
    }
}

pub fn make_rpc_call<T: serde::de::DeserializeOwned>(
    http_client: &reqwest::blocking::Client,
    rpc_server: &RpcServer,
    req: &RpcRequest,
) -> Result<T, anyhow::Error> {
    trace!("make request: {:?}", req);
    make_rpc_call_silent(http_client, rpc_server, req)
}

#[derive(Serialize, Deserialize, Debug, PartialEq)]
pub struct GetWalletInfo {
    pub balance: BTreeMap<String, f64>,
    pub unconfirmed_balance: BTreeMap<String, f64>,
    pub immature_balance: BTreeMap<String, f64>,
    pub private_keys_enabled: bool,
}
pub fn get_wallet_info() -> RpcRequest {
    RpcRequest {
        method: "getwalletinfo".to_owned(),
        params: serde_json::Value::Null,
    }
}

pub fn get_new_address() -> RpcRequest {
    get_new_address_with_type(AddressType::P2SH)
}

#[derive(Copy, Clone)]
pub enum AddressType {
    Legacy,
    P2SH,
    Bech32,
}

pub fn address_type_str(addr_type: AddressType) -> &'static str {
    match addr_type {
        AddressType::Legacy => "legacy",
        AddressType::P2SH => "p2sh-segwit",
        AddressType::Bech32 => "bech32",
    }
}

pub fn get_new_address_with_type(addr_type: AddressType) -> RpcRequest {
    RpcRequest {
        method: "getnewaddress".into(),
        params: json!({
            "address_type": address_type_str(addr_type),
        }),
    }
}

pub fn listunspent(minconf: i32) -> RpcRequest {
    // minconf
    RpcRequest {
        method: "listunspent".to_owned(),
        params: json!({
            "minconf": minconf,
        }),
    }
}
#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct UnspentItem {
    pub txid: elements::Txid,
    pub vout: u32,
    pub address: String,
    pub amount: serde_json::Number,
    pub confirmations: i32,
    pub asset: sideswap_api::AssetId,
    #[serde(rename = "scriptPubKey")]
    pub script_pub_key: elements::Script,
    #[serde(rename = "redeemScript")]
    pub redeem_script: Option<elements::Script>, // Not present for native segwit
    pub assetblinder: Option<elements::confidential::AssetBlindingFactor>,
    pub amountblinder: Option<elements::confidential::ValueBlindingFactor>,
    pub assetcommitment: Option<String>,
    pub amountcommitment: Option<String>,
}
pub type ListUnspent = Vec<UnspentItem>;

impl UnspentItem {
    pub fn tx_out(&self) -> sideswap_common::types::TxOut {
        sideswap_common::types::TxOut {
            txid: self.txid,
            vout: self.vout,
        }
    }
}

pub fn sendtoaddress(address: &str, amount: f64, asset_id: &elements::AssetId) -> RpcRequest {
    RpcRequest {
        method: "sendtoaddress".to_owned(),
        params: json! ({
            "address": address,
            "amount": amount,
            "assetlabel": asset_id,
        }),
    }
}
pub type SendToAddressResult = String;

pub fn dumpprivkey(address: &str) -> RpcRequest {
    RpcRequest {
        method: "dumpprivkey".to_owned(),
        params: json! ({
            "address": address,
        }),
    }
}
pub type DumpPrivKey = String;
