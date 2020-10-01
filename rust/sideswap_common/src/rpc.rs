use serde::{Deserialize, Serialize};
use std::collections::{BTreeMap, HashMap};
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
struct RpcResult<T> {
    pub result: Option<T>,
    pub error: Option<RpcError>,
}

pub fn is_default_rpc(rpc_server: &RpcServer) -> bool {
    rpc_server.host == "localhost"
        && rpc_server.port == 7041
        && rpc_server.login.is_empty()
        && rpc_server.password.is_empty()
}

fn get_default_rpc() -> Result<RpcServer, anyhow::Error> {
    let mut is_linux = false;
    let mut conf_path = match std::env::consts::FAMILY {
        "unix" => match std::env::consts::OS {
            "macos" => dirs::config_dir(),
            _ => {
                is_linux = true;
                dirs::home_dir()
            }
        },
        _ => dirs::config_dir(),
    }
    .unwrap();

    if is_linux {
        conf_path.push(".elements");
    } else {
        conf_path.push("Elements");
    }

    conf_path.push("liquidv1");
    conf_path.push(".cookie");

    let cookie = std::fs::read_to_string(conf_path)?;
    let credential: Vec<&str> = cookie.split(':').collect();

    ensure!(credential.len() == 2, "invalid cookie faile");
    let login = credential[0].to_owned();
    let password = credential[1].to_owned();

    Ok(RpcServer {
        host: "localhost".to_owned(),
        port: 7041,
        login,
        password,
    })
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
    if is_default_rpc(&rpc_server) {
        make_rpc_impl(http_client, &get_default_rpc()?, &req)
    } else {
        make_rpc_impl(http_client, &rpc_server, &req)
    }
}

pub fn make_rpc_call_silent<T: serde::de::DeserializeOwned>(
    http_client: &reqwest::blocking::Client,
    rpc_server: &RpcServer,
    req: &RpcRequest,
) -> Result<T, anyhow::Error> {
    let response = make_rpc(&http_client, &rpc_server, &req)?;
    let response = serde_json::from_str::<RpcResult<T>>(&response.0)?;
    if let Some(error) = response.error {
        debug!("rpc failed: {}", error.message);
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
    debug!("make request: {:?}", req);
    make_rpc_call_silent(http_client, rpc_server, req)
}

pub fn make_rpc_call_status_silent(
    http_client: &reqwest::blocking::Client,
    rpc_server: &RpcServer,
    req: &RpcRequest,
) -> reqwest::StatusCode {
    let res = make_rpc(&http_client, &rpc_server, &req);
    match res {
        Ok((_, status_code)) => status_code,
        _ => reqwest::StatusCode::NOT_FOUND,
    }
}

pub fn make_rpc_call_status(
    http_client: &reqwest::blocking::Client,
    rpc_server: &RpcServer,
    req: &RpcRequest,
) -> reqwest::StatusCode {
    debug!("make request: {:?}", req);
    make_rpc_call_status_silent(http_client, rpc_server, req)
}

#[derive(Serialize, Deserialize, Debug)]
pub struct GetWalletInfo {
    pub balance: HashMap<String, serde_json::Number>,
    pub private_keys_enabled: bool,
}

pub fn get_wallet_info() -> RpcRequest {
    RpcRequest {
        method: "getwalletinfo".into(),
        params: vec![],
    }
}

pub type AssetLabels = HashMap<String, String>;

pub fn dump_asset_labels() -> RpcRequest {
    RpcRequest {
        method: "dumpassetlabels".into(),
        params: vec![],
    }
}

pub fn get_new_address() -> RpcRequest {
    get_new_address_with_type(Some(AddressType::Bech32))
}

#[derive(Copy, Clone)]
pub enum AddressType {
    Legacy,
    P2ShSegwit,
    Bech32,
}

pub fn address_type_str(addr_type: AddressType) -> &'static str {
    match addr_type {
        AddressType::Legacy => "legacy",
        AddressType::P2ShSegwit => "p2sh-segwit",
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

pub type RawTxInputs = crate::types::TxOut;

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

pub fn fund_raw_tx(raw_tx: &str) -> RpcRequest {
    RpcRequest {
        method: "fundrawtransaction".into(),
        params: vec![serde_json::json!(raw_tx)],
    }
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

pub fn create_funded_psbt(
    inputs: &Vec<PsbtInputs>,
    outputs_amounts: &RawTxOutputsAmounts,
    fee_rate: f64,
) -> RpcRequest {
    let mut data = Vec::<serde_json::value::Value>::new();

    data.push(serde_json::json!(inputs));
    data.push(serde_json::json!(outputs_amounts));
    data.push(serde_json::json!(0));

    let mut input_data = BTreeMap::<String, String>::new();
    input_data.insert("feeRate".into(), fee_rate.to_string());
    data.push(serde_json::json!(input_data));

    RpcRequest {
        method: "walletcreatefundedpsbt".into(),
        params: data,
    }
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

pub fn decode_raw_tx(tx: &str) -> RpcRequest {
    RpcRequest {
        method: "decoderawtransaction".into(),
        params: vec![serde_json::json!(tx)],
    }
}

pub fn list_unspent(minimum_amount: &String, asset: &String) -> RpcRequest {
    let mut data = Vec::<serde_json::value::Value>::new();
    let mut input_data = BTreeMap::<String, String>::new();
    input_data.insert("minimumSumAmount".into(), minimum_amount.into());
    input_data.insert("asset".into(), asset.into());

    data.push(serde_json::json!(1));
    data.push(serde_json::json!(9999999));
    data.push(serde_json::json!(Vec::<serde_json::value::Value>::new()));
    data.push(serde_json::json!(true));
    data.push(serde_json::json!(input_data));

    RpcRequest {
        method: "listunspent".into(),
        params: data,
    }
}

pub fn list_unspent2(minconf: i32) -> RpcRequest {
    // minconf
    RpcRequest {
        method: "listunspent".to_owned(),
        params: vec![serde_json::json!(minconf)],
    }
}
#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct UnspentItem {
    pub txid: String,
    pub vout: i32,
    pub address: String,
    pub amount: serde_json::Number,
    pub confirmations: i32,
    pub asset: String,
}
pub type ListUnspent = Vec<UnspentItem>;

impl UnspentItem {
    pub fn tx_out(&self) -> crate::types::TxOut {
        crate::types::TxOut {
            txid: self.txid.clone(),
            vout: self.vout,
        }
    }
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SignedTx {
    pub hex: String,
}

pub fn sign_raw_tx_with_wallet(blinded_tx: &str) -> RpcRequest {
    RpcRequest {
        method: "signrawtransactionwithwallet".into(),
        params: vec![serde_json::json!(blinded_tx)],
    }
}

pub fn sign_psbt(tx: &str) -> RpcRequest {
    RpcRequest {
        method: "walletsignpsbt".into(),
        params: vec![serde_json::json!(tx)],
    }
}

pub fn send_raw_tx(signed_tx: &str) -> RpcRequest {
    RpcRequest {
        method: "sendrawtransaction".into(),
        params: vec![serde_json::json!(signed_tx)],
    }
}

pub fn set_wallet_passphrase(pass: &str, timeout: i64) -> RpcRequest {
    RpcRequest {
        method: "walletpassphrase".into(),
        params: vec![serde_json::json!(pass), serde_json::json!(timeout)],
    }
}

pub fn set_wallet_lock() -> RpcRequest {
    RpcRequest {
        method: "walletlock".into(),
        params: vec![],
    }
}

pub fn ping() -> RpcRequest {
    RpcRequest {
        method: "ping".into(),
        params: vec![],
    }
}
