use base64::Engine;
use serde::{Deserialize, Serialize};
use serde_json::json;
use sideswap_types::hex_encoded::HexEncoded;
use std::collections::BTreeMap;
use std::vec::Vec;

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct RpcServer {
    pub host: String,
    pub port: u16,
    pub login: String,
    pub password: String,
    pub wallet: Option<String>,
}

pub trait RpcCall {
    type Response: serde::de::DeserializeOwned;

    fn get_request(self) -> RpcRequest;
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RpcRequest {
    method: String,
    params: serde_json::value::Value,
}

#[derive(Serialize, Deserialize, Debug)]
struct RpcError {
    message: String,
}

#[derive(Serialize, Deserialize, Debug)]
struct RpcResult<T> {
    result: Option<T>,
    error: Option<RpcError>,
}

pub fn make_rpc_call<T: RpcCall>(
    http_client: &ureq::Agent,
    rpc_server: &RpcServer,
    req: T,
) -> Result<T::Response, anyhow::Error> {
    let req = req.get_request();
    let req = serde_json::to_string(&req).expect("should not fail");
    trace!("make rpc request: {req}");

    // If two or more wallets are loaded, most RPC calls must include the wallet name in the URL path
    let wallet_name = rpc_server.wallet.as_ref().map(String::as_str).unwrap_or("");
    let endpoint = format!(
        "http://{}:{}/wallet/{}",
        &rpc_server.host, rpc_server.port, wallet_name
    );

    let encoded_credentials = base64::engine::general_purpose::STANDARD
        .encode(format!("{}:{}", rpc_server.login, rpc_server.password));
    let auth_header_value = format!("Basic {}", encoded_credentials);
    let res = http_client
        .post(&endpoint)
        .set("Authorization", &auth_header_value)
        .set("Content-Type", "application/json")
        .send_string(&req)?;
    let _status = res.status();
    let data = res.into_string()?;
    trace!("got rpc response: {}", data);

    let response = serde_json::from_str::<RpcResult<T::Response>>(&data)?;

    if let Some(error) = response.error {
        bail!("RPC request failed: {}", error.message);
    }
    let resp = match response.result {
        Some(v) => v,
        None => serde_json::from_value::<T::Response>(serde_json::Value::Null)?,
    };
    Ok(resp)
}

pub struct GetWalletInfoCall {}

impl RpcCall for GetWalletInfoCall {
    type Response = GetWalletInfo;

    fn get_request(self) -> RpcRequest {
        RpcRequest {
            method: "getwalletinfo".to_owned(),
            params: serde_json::Value::Null,
        }
    }
}

#[derive(Serialize, Deserialize, Debug, PartialEq)]
pub struct GetWalletInfo {
    pub balance: BTreeMap<String, f64>,
    pub unconfirmed_balance: BTreeMap<String, f64>,
    pub immature_balance: BTreeMap<String, f64>,
    pub private_keys_enabled: bool,
}

pub struct GetNewAddressCall {}

impl RpcCall for GetNewAddressCall {
    type Response = elements::Address;

    fn get_request(self) -> RpcRequest {
        get_new_address_with_type(AddressType::P2SH)
    }
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

pub struct ListUnspentCall {
    pub minconf: i32,
}

impl RpcCall for ListUnspentCall {
    type Response = ListUnspent;

    fn get_request(self) -> RpcRequest {
        RpcRequest {
            method: "listunspent".to_owned(),
            params: json!({
                "minconf": self.minconf,
            }),
        }
    }
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct UnspentItem {
    pub txid: elements::Txid,
    pub vout: u32,
    pub address: elements::Address,
    pub amount: serde_json::Number,
    pub confirmations: i32,
    pub asset: sideswap_api::AssetId,
    #[serde(rename = "scriptPubKey")]
    pub script_pub_key: elements::Script,
    #[serde(rename = "redeemScript")]
    pub redeem_script: Option<elements::Script>, // Not present for native segwit
    pub assetblinder: Option<elements::confidential::AssetBlindingFactor>,
    pub amountblinder: Option<elements::confidential::ValueBlindingFactor>,
    pub assetcommitment: Option<HexEncoded<elements::confidential::Asset>>,
    pub amountcommitment: Option<HexEncoded<elements::confidential::Value>>,
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

pub struct SendToAddressCall {
    pub address: elements::Address,
    pub amount: f64,
    pub asset_id: elements::AssetId,
}

impl RpcCall for SendToAddressCall {
    type Response = elements::Txid;

    fn get_request(self) -> RpcRequest {
        RpcRequest {
            method: "sendtoaddress".to_owned(),
            params: json! ({
                "address": self.address,
                "amount": self.amount,
                "assetlabel": self.asset_id,
            }),
        }
    }
}

pub struct DumpPrivKeyCall {
    pub address: elements::Address,
}

impl RpcCall for DumpPrivKeyCall {
    type Response = elements::bitcoin::PrivateKey;

    fn get_request(self) -> RpcRequest {
        RpcRequest {
            method: "dumpprivkey".to_owned(),
            params: json! ({
                "address": self.address,
            }),
        }
    }
}
