use serde::{Deserialize, Serialize};
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
    pub params: Vec<serde_json::value::Value>,
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
        .post(&endpoint)
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
    make_rpc_impl(http_client, &rpc_server, &req)
}

pub fn make_rpc_call_silent<T: serde::de::DeserializeOwned>(
    http_client: &reqwest::blocking::Client,
    rpc_server: &RpcServer,
    req: &RpcRequest,
) -> Result<T, anyhow::Error> {
    let response = make_rpc(&http_client, &rpc_server, &req)?;
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
        params: vec![],
    }
}

pub fn get_new_address() -> RpcRequest {
    get_new_address_with_type(Some(AddressType::P2SH))
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

pub fn get_new_address_with_type(addr_type: Option<AddressType>) -> RpcRequest {
    let addr_type = addr_type.map_or(serde_json::Value::Null, |addr_type| {
        serde_json::json!(address_type_str(addr_type))
    });
    RpcRequest {
        method: "getnewaddress".into(),
        // label address_type
        params: vec![serde_json::json!(""), addr_type],
    }
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RawUtxo {
    pub txid: String,
    pub vout: i32,
    pub asset: String,
    pub amount: serde_json::Number,
}

pub type RawTxInputs = sideswap_common::types::TxOut;

pub type RawTxOutputsAmounts = BTreeMap<String, serde_json::Value>;
pub type RawTxOutputsAssets = BTreeMap<String, String>;

pub fn create_raw_tx(
    inputs: &Vec<RawTxInputs>,
    outputs_amounts: &RawTxOutputsAmounts,
    locktime: i64,
    replaceable: bool,
    output_assets: &RawTxOutputsAssets,
) -> RpcRequest {
    let mut data = Vec::<serde_json::value::Value>::new();

    data.push(serde_json::json!(inputs));
    data.push(serde_json::json!(outputs_amounts));
    data.push(serde_json::json!(locktime));
    data.push(serde_json::json!(replaceable));
    data.push(serde_json::json!(output_assets));

    RpcRequest {
        method: "createrawtransaction".into(),
        params: data,
    }
}

#[derive(Serialize, Deserialize, Debug)]
pub struct FundedTx {
    pub hex: String,
}

pub fn convert_to_psbt(tx: &str) -> RpcRequest {
    RpcRequest {
        method: "converttopsbt".into(),
        params: vec![serde_json::json!(tx)],
    }
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PsbtTx {
    pub psbt: String,
}

pub fn fill_psbt_data(converted_tx: &str) -> RpcRequest {
    RpcRequest {
        method: "walletfillpsbtdata".into(),
        params: vec![serde_json::json!(converted_tx)],
    }
}
#[derive(Deserialize)]
pub struct FillPsbtData {
    pub psbt: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct PsbtInputs {
    pub txid: String,
    pub vout: i64,
    pub sequence: i64,
}

pub fn wallet_sign_psbt(tx: &str) -> RpcRequest {
    RpcRequest {
        method: "walletsignpsbt".into(),
        params: vec![serde_json::json!(tx)],
    }
}
#[derive(Deserialize)]
pub struct WalletSignPsbt {
    pub psbt: String,
    pub complete: bool,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct TxInputKey {
    pub txid: String,
    pub vout: i64,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct DecodedRawTx {
    pub vin: Vec<TxInputKey>,
}

pub fn listunspent(minconf: i32) -> RpcRequest {
    // minconf
    RpcRequest {
        method: "listunspent".to_owned(),
        params: vec![serde_json::json!(minconf)],
    }
}
#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct UnspentItem {
    pub txid: sideswap_api::Txid,
    pub vout: u32,
    pub address: String,
    pub amount: serde_json::Number,
    pub confirmations: i32,
    pub asset: sideswap_api::AssetId,
    #[serde(rename = "scriptPubKey")]
    pub script_pub_key: String,
    #[serde(rename = "redeemScript")]
    pub redeem_script: Option<String>,
    pub assetblinder: Option<sideswap_api::BlindingFactor>,
    pub amountblinder: Option<sideswap_api::BlindingFactor>,
    pub assetcommitment: Option<String>,
    pub amountcommitment: Option<String>,
}
pub type ListUnspent = Vec<UnspentItem>;

impl UnspentItem {
    pub fn tx_out(&self) -> sideswap_common::types::TxOut {
        sideswap_common::types::TxOut {
            txid: self.txid.clone(),
            vout: self.vout,
        }
    }
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SignedTx {
    pub hex: String,
}

pub fn sendtoaddress_generic(
    addr: &str,
    amount: f64,
    comment: Option<&str>,
    comment_to: Option<&str>,
    subtractfeefromamount: Option<bool>,
    replaceable: Option<bool>,
    conf_target: Option<i32>,
    estimate_mode: Option<&str>,
    avoid_reuse: Option<bool>,
    assetlabel: Option<&str>,
) -> RpcRequest {
    RpcRequest {
        method: "sendtoaddress".to_owned(),
        params: vec![
            serde_json::json!(addr),
            serde_json::json!(amount),
            serde_json::json!(comment),
            serde_json::json!(comment_to),
            serde_json::json!(subtractfeefromamount),
            serde_json::json!(replaceable),
            serde_json::json!(conf_target),
            serde_json::json!(estimate_mode),
            serde_json::json!(avoid_reuse),
            serde_json::json!(assetlabel),
        ],
    }
}

pub fn sendtoaddress_asset(addr: &str, amount: f64, assetlabel: &str) -> RpcRequest {
    sendtoaddress_generic(
        addr,
        amount,
        None,
        None,
        None,
        None,
        None,
        None,
        None,
        Some(assetlabel),
    )
}

pub fn sendtoaddress_bitcoin(addr: &str, amount: f64) -> RpcRequest {
    sendtoaddress_generic(addr, amount, None, None, None, None, None, None, None, None)
}
pub type SendToAddressResult = String;

pub fn get_address_info(addr: &str) -> RpcRequest {
    RpcRequest {
        method: "getaddressinfo".to_owned(),
        params: vec![serde_json::json!(addr)],
    }
}
#[derive(Deserialize)]
pub struct GetAddressInfo {
    pub confidential: String,
    pub unconfidential: String,
    pub solvable: bool,
}

pub fn get_raw_transaction(txid: &sideswap_api::Txid) -> RpcRequest {
    RpcRequest {
        method: "getrawtransaction".to_owned(),
        params: vec![serde_json::json!(txid)],
    }
}
pub type GetRawTransactionResult = String;

pub fn dumpprivkey(addr: &str) -> RpcRequest {
    RpcRequest {
        method: "dumpprivkey".to_owned(),
        params: vec![serde_json::json!(addr)],
    }
}
pub type DumpPrivKey = String;

pub fn dumpblindingkey(addr: &str) -> RpcRequest {
    RpcRequest {
        method: "dumpblindingkey".to_owned(),
        params: vec![serde_json::json!(addr)],
    }
}
pub type DumpBlindingKey = String;
