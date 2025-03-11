use anyhow::ensure;
use serde::{Deserialize, Serialize};
use serde_json::json;
use sideswap_types::bitcoin_amount::BtcAmount;
use std::collections::BTreeMap;
use std::vec::Vec;

pub mod balances;
pub mod sign_raw_transaction;

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

pub async fn make_rpc_call<T: RpcCall>(
    rpc_server: &RpcServer,
    req: T,
) -> Result<T::Response, anyhow::Error> {
    static HTTP_CLIENT: std::sync::OnceLock<reqwest::Client> = std::sync::OnceLock::new();
    let http_client = HTTP_CLIENT.get_or_init(|| {
        reqwest::Client::builder()
            .timeout(std::time::Duration::from_secs(30))
            .build()
            .expect("http client construction failed")
    });

    let req = req.get_request();
    log::trace!(
        "make rpc request: {}",
        serde_json::to_string(&req).expect("should not fail")
    );

    // If two or more wallets are loaded, most RPC calls must include the wallet name in the URL path
    let wallet_name = rpc_server.wallet.as_deref().unwrap_or("");
    let endpoint = format!(
        "http://{}:{}/wallet/{}",
        &rpc_server.host, rpc_server.port, wallet_name
    );

    let resp = http_client
        .post(&endpoint)
        .basic_auth(&rpc_server.login, Some(&rpc_server.password))
        .json(&req)
        .send()
        .await?
        .text()
        .await?;

    log::trace!("got rpc response: {resp}");

    let response = serde_json::from_str::<RpcResult<T::Response>>(&resp)?;

    if let Some(error) = response.error {
        anyhow::bail!("RPC request failed: {}", error.message);
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
    pub txcount: u32,
}

pub struct GetNewAddressCall {}

impl RpcCall for GetNewAddressCall {
    type Response = elements::Address;

    fn get_request(self) -> RpcRequest {
        get_new_address_with_type(None)
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

pub fn get_new_address_with_type(addr_type: Option<AddressType>) -> RpcRequest {
    let mut params = json!({});
    if let Some(address_type) = addr_type {
        params["address_type"] = json!(address_type_str(address_type));
    }
    RpcRequest {
        method: "getnewaddress".into(),
        params,
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

#[derive(Deserialize, Debug, Clone)]
pub struct UnspentItem {
    pub txid: elements::Txid,
    pub vout: u32,
    pub address: elements::Address,
    pub amount: BtcAmount,
    pub confirmations: i32,
    pub asset: sideswap_api::AssetId,
    #[serde(rename = "scriptPubKey")]
    pub script_pub_key: elements::Script,
    #[serde(rename = "redeemScript")]
    pub redeem_script: Option<elements::Script>, // Not present for native segwit
    pub assetblinder: elements::confidential::AssetBlindingFactor, // 0000000000000000000000000000000000000000000000000000000000000000 for unblinded
    pub amountblinder: elements::confidential::ValueBlindingFactor, // 0000000000000000000000000000000000000000000000000000000000000000 for unblinded
    pub assetcommitment: Option<elements::secp256k1_zkp::Generator>, // Not present if unblinded
    pub amountcommitment: Option<elements::secp256k1_zkp::PedersenCommitment>, // Not present if unblinded
}

impl UnspentItem {
    pub fn outpoint(&self) -> elements::OutPoint {
        elements::OutPoint {
            txid: self.txid,
            vout: self.vout,
        }
    }
}

pub type ListUnspent = Vec<UnspentItem>;

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

pub struct SendRawTransactionCall {
    pub tx: String,
}

impl RpcCall for SendRawTransactionCall {
    type Response = elements::Txid;

    fn get_request(self) -> RpcRequest {
        RpcRequest {
            method: "sendrawtransaction".to_owned(),
            params: vec![json!(self.tx)].into(),
        }
    }
}

// Use `test_mempool_accepted` instead (to not forget to check the `allowed` value)
struct TestMempoolAcceptedCall {
    rawtxs: Vec<String>,
}

#[derive(Deserialize, Debug)]
struct TestMempoolAcceptValue {
    pub txid: String,
    pub allowed: bool,
    #[serde(rename = "reject-reason")]
    pub reject_reason: Option<String>,
}

impl RpcCall for TestMempoolAcceptedCall {
    type Response = Vec<TestMempoolAcceptValue>;

    fn get_request(self) -> RpcRequest {
        RpcRequest {
            method: "testmempoolaccept".to_owned(),
            params: vec![json!(self.rawtxs)].into(),
        }
    }
}

pub async fn test_mempool_accepted_list(
    rpc_server: &RpcServer,
    txs: Vec<String>,
) -> Result<Vec<String>, anyhow::Error> {
    let count = txs.len();
    let check_acceptence =
        make_rpc_call(rpc_server, TestMempoolAcceptedCall { rawtxs: txs }).await?;
    ensure!(
        check_acceptence.len() == count,
        "invalid mempool test result"
    );
    let mut txids = Vec::new();
    for resp in check_acceptence {
        ensure!(
            resp.allowed,
            "mempool test failed: '{}', txid: {}",
            resp.reject_reason.clone().unwrap_or_default(),
            resp.txid,
        );
        txids.push(resp.txid);
    }
    Ok(txids)
}

pub async fn test_mempool_accepted(
    rpc_server: &RpcServer,
    tx: String,
) -> Result<String, anyhow::Error> {
    let resp = test_mempool_accepted_list(rpc_server, vec![tx]).await?;
    Ok(resp[0].clone())
}
