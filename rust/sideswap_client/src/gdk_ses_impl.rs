use crate::ffi;
use crate::gdk;
use crate::gdk_json;
use crate::gdk_json::AddressInfo;
use crate::gdk_ses;
use crate::gdk_ses::JadeStatusCallback;
use crate::gdk_ses::NotifCallback;
use crate::gdk_ses::TxType;
use crate::models;
use crate::models::Transaction;
use crate::swaps;
use crate::swaps::MakerChainingTx;
use crate::worker;
use crate::worker::AccountId;
use base64::Engine;
use elements::encode::Encodable;
use elements::hashes::Hash;
use elements::secp256k1_zkp::global::SECP256K1;
use gdk_ses::HwData;
use serde_bytes::ByteBuf;
use sideswap_api::Asset;
use sideswap_api::AssetId;
use sideswap_common::env::Env;
use sideswap_common::env::Network;
use std::collections::BTreeMap;
use std::collections::BTreeSet;
use std::collections::HashMap;
use std::ffi::{CStr, CString};
use std::str::FromStr;
use std::time::Duration;

const SUBACCOUNT_NAME_REG: &str = "Main account";
const SUBACCOUNT_TYPE_REG: &str = "p2sh-p2wpkh";

const SUBACCOUNT_NAME_AMP: &str = "AMP";
const SUBACCOUNT_TYPE_AMP: &str = "2of2_no_recovery";

pub struct GdkSesImpl {
    login_info: gdk_ses::LoginInfo,
    hw_data: Option<HwData>,

    session: *mut gdk::GA_session,
    subaccount: Option<i32>,
    receiving_id: Option<String>,
    policy_asset: AssetId,
}

impl gdk_ses::GdkSes for GdkSesImpl {
    fn login(&mut self) -> Result<(), anyhow::Error> {
        unsafe { login(self) }
    }

    fn register(&mut self) -> Result<(), anyhow::Error> {
        unsafe { register(self) }
    }

    fn set_watch_only(&mut self, username: &str, password: &str) -> Result<(), anyhow::Error> {
        unsafe { set_watch_only(self, username, password) }
    }

    fn connect(&mut self) {
        unsafe {
            reconnect_hint(self, gdk_json::ReconnectHint::Connect);
        }
    }

    fn disconnect(&mut self) {
        unsafe {
            reconnect_hint(self, gdk_json::ReconnectHint::Disconnect);
        }
    }

    fn login_info(&self) -> &gdk_ses::LoginInfo {
        &self.login_info
    }

    fn get_gaid(&self) -> Result<String, anyhow::Error> {
        try_get_gaid(self)
    }

    fn unlock_hww(&self) -> Result<(), anyhow::Error> {
        if let Some(hw_data) = self.hw_data.as_ref() {
            unlock_hw(hw_data.env, &hw_data.jade, &hw_data.status_callback)
        } else {
            Ok(())
        }
    }

    fn update_sync_interval(&self, _time: u32) {}

    fn get_balances(&self) -> Result<std::collections::BTreeMap<AssetId, i64>, anyhow::Error> {
        unsafe { get_balances(self) }
    }

    fn get_transactions_impl(&self) -> Result<Vec<gdk_json::Transaction>, anyhow::Error> {
        unsafe { load_transactions(self) }
    }

    fn get_receive_address(&self) -> Result<AddressInfo, anyhow::Error> {
        unsafe { try_get_addr_info(self, false) }
    }

    fn get_change_address(&self) -> Result<AddressInfo, anyhow::Error> {
        unsafe { try_get_addr_info(self, true) }
    }

    fn create_tx(&mut self, tx: ffi::proto::CreateTx) -> Result<serde_json::Value, anyhow::Error> {
        unsafe { try_create_tx(self, tx) }
    }

    fn send_tx(
        &mut self,
        tx: &serde_json::Value,
        assets: &BTreeMap<AssetId, Asset>,
    ) -> Result<elements::Txid, anyhow::Error> {
        unsafe { try_send_tx(self, tx, assets) }
    }

    fn create_payjoin(
        &mut self,
        req: ffi::proto::CreatePayjoin,
    ) -> Result<ffi::proto::CreatedPayjoin, anyhow::Error> {
        unsafe { try_create_payjoin(self, req) }
    }

    fn send_payjoin(
        &mut self,
        req: &ffi::proto::CreatedPayjoin,
        assets: &BTreeMap<AssetId, Asset>,
    ) -> Result<elements::Txid, anyhow::Error> {
        unsafe { try_send_payjoin(self, req, assets) }
    }

    fn get_utxos(&self) -> Result<gdk_json::UnspentOutputsResult, anyhow::Error> {
        unsafe { try_get_unspent_outputs(self) }
    }

    fn get_tx_fee(
        &mut self,
        asset_id: AssetId,
        send_amount: i64,
        addr: &str,
    ) -> Result<gdk_ses::TxFeeInfo, anyhow::Error> {
        unsafe { get_tx_fee(self, asset_id, send_amount, addr) }
    }

    fn make_pegout_payment(
        &mut self,
        send_amount: i64,
        peg_addr: &str,
        send_amount_exact: i64,
    ) -> Result<worker::PegPayment, anyhow::Error> {
        unsafe { make_pegout_payment(self, send_amount, peg_addr, send_amount_exact) }
    }

    fn get_blinded_values(&self, txid: &str) -> Result<Vec<String>, anyhow::Error> {
        unsafe { get_blinded_values(self, txid) }
    }

    fn get_previous_addresses(
        &mut self,
        last_pointer: Option<u32>,
        internal: bool,
    ) -> Result<gdk_json::PreviousAddresses, anyhow::Error> {
        unsafe { get_previous_addresses(self, last_pointer, internal) }
    }

    fn sig_single_maker_tx(
        &mut self,
        input: &swaps::SigSingleInput,
        output: &swaps::SigSingleOutput,
        assets: &BTreeMap<AssetId, Asset>,
    ) -> Result<swaps::SigSingleMaker, anyhow::Error> {
        unsafe { sig_single_maker_tx(self, input, output, assets) }
    }

    fn verify_and_sign_pset(
        &mut self,
        amounts: &crate::swaps::Amounts,
        pset: &str,
        nonces: &[String],
        assets: &BTreeMap<AssetId, Asset>,
    ) -> Result<String, anyhow::Error> {
        unsafe { verify_and_sign_pset(self, amounts, pset, nonces, assets) }
    }

    fn set_memo(&mut self, txid: &str, memo: &str) -> Result<(), anyhow::Error> {
        unsafe { set_memo(self, txid, memo) }
    }
}

impl GdkSesImpl {
    fn get_subaccount(&self) -> Result<i32, anyhow::Error> {
        self.subaccount
            .ok_or_else(|| anyhow!("not connected, subaccount is not set"))
    }
}

impl Drop for GdkSesImpl {
    fn drop(&mut self) {
        unsafe {
            debug!("destroy session {:p}", self.session);
            let rc = gdk::GA_destroy_session(self.session);
            assert!(rc == 0);
        }
    }
}

struct GdkJson {
    json: *mut gdk::GA_json,
    str: *mut ::std::os::raw::c_char,
}

impl GdkJson {
    fn new<T: serde::Serialize>(data: &T) -> Self {
        let data = serde_json::to_string(&data).unwrap();
        let mut output = std::ptr::null_mut();
        let value = CString::new(data).unwrap();
        let rc = unsafe { gdk::GA_convert_string_to_json(value.as_ptr(), &mut output) };
        assert!(rc == 0);
        Self {
            json: output,
            str: std::ptr::null_mut(),
        }
    }

    unsafe fn owned(ptr: *mut gdk::GA_json) -> Self {
        assert!(ptr != std::ptr::null_mut());
        Self {
            json: ptr,
            str: std::ptr::null_mut(),
        }
    }

    unsafe fn as_ptr(&self) -> *mut gdk::GA_json {
        self.json
    }

    fn to_str(&mut self) -> &str {
        if self.str == std::ptr::null_mut() {
            let rc = unsafe { gdk::GA_convert_json_to_string(self.json, &mut self.str) };
            assert!(rc == 0);
        }
        unsafe { CStr::from_ptr(self.str).to_str().unwrap() }
    }

    fn to_json<T: serde::de::DeserializeOwned>(&mut self) -> Result<T, serde_json::Error> {
        serde_json::from_str(self.to_str())
    }
}

impl Drop for GdkJson {
    fn drop(&mut self) {
        let rc = unsafe { gdk::GA_destroy_json(self.json) };
        assert!(rc == 0);
        if self.str != std::ptr::null_mut() {
            unsafe { gdk::GA_destroy_string(self.str) };
        }
    }
}

struct AuthHandlerOwner {
    call: *mut gdk::GA_auth_handler,
}

impl Drop for AuthHandlerOwner {
    fn drop(&mut self) {
        unsafe {
            let rc = gdk::GA_destroy_auth_handler(self.call);
            assert!(rc == 0);
        }
    }
}

pub fn unlock_hw(
    env: Env,
    jade: &crate::jade_mng::ManagedJade,
    status_callback: &JadeStatusCallback,
) -> Result<(), anyhow::Error> {
    while let Ok(msg) = jade.recv(std::time::Duration::ZERO) {
        warn!("unexpected Jade response ignored: {:?}", msg);
    }

    jade.send(sideswap_jade::Req::ReadStatus);
    let resp = jade.recv(Duration::from_secs(1)).or_else(|_err| {
        (status_callback)(gdk_ses::JadeStatus::ReadStatus);
        let resp = jade.recv(Duration::from_secs(10));
        (status_callback)(gdk_ses::JadeStatus::Idle);
        resp
    });
    let status = match resp {
        Ok(sideswap_jade::Resp::ReadStatus(v)) => v,
        resp => bail!("unexpected Jade response: {:?}", resp),
    };
    debug!("jade state: {:?}", status.jade_state);

    match status.jade_state {
        sideswap_jade::models::State::Ready => {
            debug!("jade already unlocked");
        }
        sideswap_jade::models::State::Locked => {
            let network = if env.data().mainnet {
                sideswap_jade::models::JadeNetwork::Liquid
            } else {
                sideswap_jade::models::JadeNetwork::TestnetLiquid
            };
            jade.send(sideswap_jade::Req::AuthUser(network));
            (status_callback)(gdk_ses::JadeStatus::AuthUser);
            let resp = jade.recv(std::time::Duration::from_secs(120));
            (status_callback)(gdk_ses::JadeStatus::Idle);
            let res = match resp {
                Ok(sideswap_jade::Resp::AuthUser(v)) => v,
                resp => bail!("unexpected Jade response: {:?}", resp),
            };
            debug!("jade unlock result: {}", res);
            ensure!(res, "unlock failed");
        }
        sideswap_jade::models::State::Uninit => {
            bail!("please initialize Jade first")
        }
        sideswap_jade::models::State::Unsaved | sideswap_jade::models::State::Temp => {
            bail!("unexpected jade state: {:?}", status.jade_state);
        }
    }

    Ok(())
}

struct HandlerParams<'a> {
    assets: Option<&'a BTreeMap<AssetId, Asset>>,
    tx_type: TxType,
}

impl<'a> HandlerParams<'a> {
    fn new() -> Self {
        HandlerParams {
            assets: None,
            tx_type: TxType::Normal,
        }
    }

    fn with_assets(mut self, assets: &'a BTreeMap<AssetId, Asset>) -> Self {
        self.assets = Some(assets);
        self
    }

    fn with_tx_status(mut self, status: TxType) -> Self {
        self.tx_type = status;
        self
    }
}

unsafe fn run_auth_handler<T: serde::de::DeserializeOwned>(
    hw_data: Option<&HwData>,
    call: *mut gdk::GA_auth_handler,
    params: HandlerParams,
) -> Result<T, anyhow::Error> {
    let result = run_auth_handler_impl(hw_data, call, params);
    if let Some(hw_data) = hw_data {
        hw_data.set_status(gdk_ses::JadeStatus::Idle);
    }
    result
}

// Do it manually, because otherwise numbers will be converted as Map([(Text("$serde_json::private::Number"), Text("8"))]))
fn convert_value(value: &serde_json::Value) -> ciborium::Value {
    match value {
        serde_json::Value::Null => ciborium::Value::Null,
        serde_json::Value::Bool(val) => ciborium::Value::Bool(*val),
        serde_json::Value::Number(val) if val.is_i64() => {
            ciborium::Value::Integer(val.as_i64().expect("must be set").into())
        }
        serde_json::Value::Number(val) if val.is_f64() => {
            ciborium::Value::Float(val.as_f64().expect("must be set"))
        }
        serde_json::Value::Number(val) => ciborium::Value::Text(val.to_string()),
        serde_json::Value::String(val) => ciborium::Value::Text(val.clone()),
        serde_json::Value::Array(arr) => {
            ciborium::Value::Array(arr.iter().map(convert_value).collect())
        }
        serde_json::Value::Object(map) => ciborium::Value::Map(
            map.iter()
                .map(|(key, value)| (ciborium::Value::Text(key.clone()), convert_value(value)))
                .collect(),
        ),
    }
}

fn get_jade_asset_info(
    asset_id: &AssetId,
    assets: &BTreeMap<AssetId, Asset>,
) -> Option<sideswap_jade::models::AssetInfo> {
    let asset = assets.get(asset_id)?;
    let issuance_prevout = asset.issuance_prevout.as_ref()?;
    let contract = asset.contract.as_ref()?;
    let contract = convert_value(contract);
    if contract.is_null() {
        return None;
    }
    Some(sideswap_jade::models::AssetInfo {
        asset_id: asset_id.to_string(),
        contract,
        issuance_prevout: sideswap_jade::models::Prevout {
            txid: issuance_prevout.txid.to_string(),
            vout: issuance_prevout.vout,
        },
    })
}

unsafe fn run_auth_handler_impl<T: serde::de::DeserializeOwned>(
    hw_data: Option<&HwData>,
    call: *mut gdk::GA_auth_handler,
    params: HandlerParams,
) -> Result<T, anyhow::Error> {
    // Destroy auth handler if function returns early
    let _auth_handler_owner = AuthHandlerOwner { call };

    let mut json = loop {
        let mut status = std::ptr::null_mut();
        let rc = gdk::GA_auth_handler_get_status(call, &mut status);
        ensure!(rc == 0, "GA_auth_handler_get_status failed");
        let mut json = GdkJson::owned(status);
        debug!("auth handler status: {}", json.to_str());
        let result = json
            .to_json::<gdk_json::AuthHandler<serde_json::Value>>()
            .map_err(|e| anyhow!("parsing failed: {}, json: {}", e, json.to_str()))?;
        if result.status != gdk_json::Status::ResolveCode {
            break json;
        }
        let hw_data =
            hw_data.ok_or_else(|| anyhow!("can't resolve auth handler without hw_data"))?;
        let required_data = result
            .required_data
            .ok_or_else(|| anyhow!("required_data is empty"))?;

        // Check that device is online and unlock it if needed
        let required_hw = match &required_data.action {
            gdk_json::HwAction::GetXpubs => required_data
                .paths
                .clone()
                .unwrap_or_default()
                .iter()
                .any(|user_path| !hw_data.xpubs.contains_key(user_path)),
            gdk_json::HwAction::GetMasterBlindingKey => false,
            gdk_json::HwAction::GetBlindingPublicKeys
            | gdk_json::HwAction::GetBlindingNonces
            | gdk_json::HwAction::SignTx
            | gdk_json::HwAction::SignMessage => true,
        };
        if required_hw {
            unlock_hw(hw_data.env, &hw_data.jade, &hw_data.status_callback)?;
        }

        match required_data.action {
            gdk_json::HwAction::GetXpubs => {
                let paths = required_data.paths.unwrap();
                let mut xpubs = Vec::new();

                for path in paths {
                    let xpub = if let Some(xpub) = hw_data.xpubs.get(&path) {
                        xpub.clone()
                    } else {
                        hw_data.clear_queue();
                        let network = if hw_data.env.data().mainnet {
                            sideswap_jade::models::JadeNetwork::Liquid
                        } else {
                            sideswap_jade::models::JadeNetwork::TestnetLiquid
                        };
                        hw_data.resolve_xpub(network, &path)?
                    };
                    xpubs.push(xpub);
                }

                let result = gdk_json::GetXPubsRes { xpubs };
                let result = serde_json::to_string(&result).unwrap();
                let result = CString::new(result).unwrap();
                let rc = gdk::GA_auth_handler_resolve_code(call, result.as_ptr());
                ensure!(rc == 0, "GA_auth_handler_resolve_code failed");
            }

            gdk_json::HwAction::GetBlindingPublicKeys => {
                let scripts = required_data.scripts.unwrap();

                hw_data.clear_queue();

                for script in scripts.iter() {
                    let script = hex::decode(script).unwrap();
                    hw_data
                        .jade
                        .send(sideswap_jade::Req::GetBlindingKey(script));
                }

                let mut blinding_keys = Vec::new();
                for _ in scripts.iter() {
                    let resp = hw_data.get_resp();
                    let resp = match resp {
                        Ok(sideswap_jade::Resp::GetBlindingKey(v)) => v,
                        resp => bail!("unexpected Jade response: {:?}", resp),
                    };
                    blinding_keys.push(hex::encode(&resp));
                }
                let result = gdk_json::GetBlindingPublicKeys {
                    public_keys: blinding_keys,
                };
                let result = serde_json::to_string(&result).unwrap();
                let result = CString::new(result).unwrap();
                let rc = gdk::GA_auth_handler_resolve_code(call, result.as_ptr());
                ensure!(rc == 0, "GA_auth_handler_resolve_code failed");
            }

            gdk_json::HwAction::GetBlindingNonces => {
                let blinding_keys_required = required_data.blinding_keys_required.unwrap();
                let scripts = required_data.scripts.unwrap();
                let public_keys = required_data.public_keys.unwrap();
                ensure!(scripts.len() == public_keys.len());

                hw_data.clear_queue();

                for (script, public_key) in scripts.iter().zip(public_keys.iter()) {
                    let script = hex::decode(script).unwrap();
                    let public_key = hex::decode(public_key).unwrap();
                    hw_data.jade.send(sideswap_jade::Req::GetSharedNonce(
                        sideswap_jade::models::GetSharedNonceReq {
                            script: script.clone(),
                            their_pubkey: public_key,
                        },
                    ));
                    if blinding_keys_required {
                        hw_data
                            .jade
                            .send(sideswap_jade::Req::GetBlindingKey(script));
                    }
                }

                let mut nonces = Vec::new();
                let mut blinding_keys = Vec::new();
                for _ in scripts.iter() {
                    let resp = hw_data.get_resp();
                    let resp = match resp {
                        Ok(sideswap_jade::Resp::GetSharedNonce(v)) => v,
                        resp => bail!("unexpected Jade response: {:?}", resp),
                    };
                    nonces.push(hex::encode(&resp));

                    if blinding_keys_required {
                        let resp = hw_data.get_resp();
                        let resp = match resp {
                            Ok(sideswap_jade::Resp::GetBlindingKey(v)) => v,
                            resp => bail!("unexpected Jade response: {:?}", resp),
                        };
                        blinding_keys.push(hex::encode(&resp));
                    }
                }
                let result = gdk_json::GetBlindingNonces {
                    nonces,
                    public_keys: blinding_keys,
                };
                let result = serde_json::to_string(&result).unwrap();
                let result = CString::new(result).unwrap();
                let rc = gdk::GA_auth_handler_resolve_code(call, result.as_ptr());
                ensure!(rc == 0, "GA_auth_handler_resolve_code failed");
            }

            gdk_json::HwAction::SignTx => {
                hw_data.set_status(gdk_ses::JadeStatus::SignTx(params.tx_type));

                let transaction = required_data.transaction.unwrap();
                let transaction_inputs = required_data.transaction_inputs.unwrap();
                let transaction_outputs = required_data.transaction_outputs.unwrap();
                let use_ae_protocol = required_data.use_ae_protocol.unwrap_or_default();
                ensure!(use_ae_protocol);

                hw_data.clear_queue();

                let mut prevout_enc = elements::hashes::sha256d::Hash::engine();
                for input in transaction_inputs.iter() {
                    let txid = elements::Txid::from_str(&input.txhash).unwrap();
                    let prevout = elements::OutPoint::new(txid, input.pt_idx);
                    prevout.consensus_encode(&mut prevout_enc).unwrap();
                }
                let last_blinded_index = transaction_outputs
                    .iter()
                    .enumerate()
                    .rfind(|(_, output)| !output.scriptpubkey.is_empty())
                    .ok_or_else(|| anyhow!("can't find non-fee output"))?
                    .0;
                debug!(
                    "last blinded index: {}, output count: {}",
                    last_blinded_index,
                    transaction_outputs.len(),
                );

                let mut commitments =
                    Vec::<Option<sideswap_jade::models::TrustedCommitment>>::new();
                let mut change = Vec::<Option<sideswap_jade::models::Output>>::new();

                for output in transaction_outputs.iter() {
                    if output.amountblinder.is_some() && output.assetblinder.is_some() {
                        let asset_commitment = elements::confidential::Asset::new_confidential(
                            SECP256K1,
                            output.asset_id,
                            output.assetblinder.unwrap(),
                        );
                        let value_commitment = elements::confidential::Value::new_confidential(
                            SECP256K1,
                            output.satoshi,
                            asset_commitment.commitment().unwrap(),
                            output.amountblinder.unwrap(),
                        );
                        commitments.push(Some(sideswap_jade::models::TrustedCommitment {
                            asset_id: output.asset_id.into(),
                            value: output.satoshi,
                            asset_generator: ByteBuf::from(
                                hex::decode(&asset_commitment.commitment().unwrap().to_string())
                                    .unwrap(),
                            ),
                            blinding_key: ByteBuf::from(
                                hex::decode(&output.blinding_key.clone().unwrap()).unwrap(),
                            ),
                            abf: output.assetblinder.unwrap(),
                            vbf: output.amountblinder.unwrap(),
                            value_commitment: ByteBuf::from(
                                hex::decode(&value_commitment.commitment().unwrap().to_string())
                                    .unwrap(),
                            ),
                        }));
                    } else {
                        commitments.push(None);
                    }

                    if let Some(user_path) = output.user_path.as_ref() {
                        let variant = match output.address_type.unwrap() {
                            gdk_json::AddressType::P2shP2wpkh => {
                                Some(sideswap_jade::models::OutputVariant::P2wpkhP2sh)
                            }
                            gdk_json::AddressType::P2wsh => None,
                        };
                        change.push(Some(sideswap_jade::models::Output {
                            path: user_path.clone(),
                            recovery_xpub: None,
                            is_change: output.is_change.unwrap_or_default()
                                || output.is_internal.unwrap_or_default(),
                            variant,
                        }));
                    } else {
                        change.push(None);
                    }
                }

                let network = if hw_data.env.data().mainnet {
                    sideswap_jade::models::JadeNetwork::Liquid
                } else {
                    sideswap_jade::models::JadeNetwork::TestnetLiquid
                };

                let additional_info = if required_data.is_partial == Some(true) {
                    let mut input_sum = BTreeMap::<AssetId, u64>::new();
                    for input in transaction_inputs.iter() {
                        if input.user_path.is_some() {
                            *input_sum.entry(input.asset_id).or_default() += input.satoshi;
                        }
                    }
                    ensure!(input_sum.len() == 1);
                    let send_asset = *input_sum.keys().next().unwrap();

                    let mut output_sum = BTreeMap::<AssetId, u64>::new();
                    for output in transaction_outputs.iter() {
                        if output.user_path.is_some() {
                            if output.asset_id == send_asset {
                                *input_sum.entry(output.asset_id).or_default() -= output.satoshi;
                            } else {
                                *output_sum.entry(output.asset_id).or_default() += output.satoshi;
                            }
                        }
                    }
                    ensure!(output_sum.len() == 1);
                    let _recv_asset = *output_sum.keys().next().unwrap();

                    let wallet_input_summary = input_sum
                        .into_iter()
                        .map(
                            |(asset_id, amount)| sideswap_jade::models::AdditionalInfoSummary {
                                asset_id: asset_id.into(),
                                satoshi: amount,
                            },
                        )
                        .collect();

                    let wallet_output_summary = output_sum
                        .into_iter()
                        .map(
                            |(asset_id, amount)| sideswap_jade::models::AdditionalInfoSummary {
                                asset_id: asset_id.into(),
                                satoshi: amount,
                            },
                        )
                        .collect();
                    // Should be true only for the maker side
                    let is_partial =
                        transaction_inputs.len() == 1 && transaction_outputs.len() == 1;

                    Some(sideswap_jade::models::ReqSignTxAdditionalInfo {
                        is_partial,
                        tx_type: sideswap_jade::models::TxType::Swap,
                        wallet_input_summary,
                        wallet_output_summary,
                    })
                } else {
                    None
                };

                let mut asset_info = Vec::new();
                let asset_ids = transaction_inputs
                    .iter()
                    .map(|input| input.asset_id)
                    .chain(transaction_outputs.iter().map(|output| output.asset_id))
                    .collect::<BTreeSet<_>>();
                if let Some(assets) = params.assets {
                    for asset_id in asset_ids {
                        if let Some(info) = get_jade_asset_info(&asset_id, assets) {
                            asset_info.push(info);
                        } else {
                        }
                    }
                }

                let sign_tx = sideswap_jade::models::ReqSignTx {
                    network: network.name().to_owned(),
                    use_ae_signatures: true,
                    txn: ByteBuf::from(hex::decode(&transaction).unwrap()),
                    num_inputs: transaction_inputs.len() as u32,
                    trusted_commitments: commitments.clone(),
                    change,
                    asset_info,
                    additional_info,
                };

                hw_data.jade.send(sideswap_jade::Req::SignTx(sign_tx));
                // TODO: Decide how much we should wait here
                let resp = hw_data.get_resp_with_timeout(std::time::Duration::from_secs(120));
                let sign_tx_result = match resp {
                    Ok(sideswap_jade::Resp::SignTx(v)) => v,
                    resp => bail!("unexpected Jade response: {:?}", resp),
                };
                ensure!(sign_tx_result, "sign tx request failed");

                let mut signer_commitments = Vec::new();
                for input in transaction_inputs.iter() {
                    let req = if !input.skip_signing.unwrap_or_default() {
                        Some(sideswap_jade::models::ReqTxInput {
                            is_witness: true,
                            path: input.user_path.clone().unwrap().clone(),
                            script: ByteBuf::from(
                                hex::decode(&input.prevout_script.clone().unwrap()).unwrap(),
                            ),
                            sighash: input.user_sighash,
                            asset_id: input.asset_id.into(),
                            value: input.satoshi,

                            value_commitment: ByteBuf::from(
                                hex::decode(&input.commitment.clone().unwrap()).unwrap(),
                            ),
                            ae_host_commitment: ByteBuf::from(
                                hex::decode(&input.ae_host_commitment.clone().unwrap()).unwrap(),
                            ),
                            ae_host_entropy: ByteBuf::from(
                                hex::decode(&input.ae_host_entropy.clone().unwrap()).unwrap(),
                            ),

                            abf: input.assetblinder.unwrap(),
                            vbf: input.amountblinder.unwrap(),
                            asset_generator: ByteBuf::from(
                                hex::decode(input.asset_tag.as_ref().unwrap()).unwrap(),
                            ),
                        })
                    } else {
                        None
                    };
                    hw_data.jade.send(sideswap_jade::Req::TxInput(req));
                    let resp = hw_data.get_resp();
                    let tx_input = match resp {
                        Ok(sideswap_jade::Resp::TxInput(v)) => v,
                        resp => bail!("unexpected Jade response: {:?}", resp),
                    };
                    signer_commitments.push(hex::encode(&tx_input));
                }

                let mut signatures = Vec::new();
                for input in transaction_inputs.iter() {
                    let req = if !input.skip_signing.unwrap_or_default() {
                        Some(ByteBuf::from(
                            hex::decode(input.ae_host_entropy.as_ref().unwrap()).unwrap(),
                        ))
                    } else {
                        None
                    };
                    hw_data.jade.send(sideswap_jade::Req::GetSignature(req));
                    let resp = hw_data.get_resp();
                    let signature = match resp {
                        Ok(sideswap_jade::Resp::GetSignature(v)) => v,
                        resp => bail!("unexpected Jade response: {:?}", resp),
                    };
                    signatures.push(signature.map(hex::encode));
                }

                let result = gdk_json::SignTx {
                    signatures,
                    signer_commitments,

                    asset_commitments: commitments
                        .iter()
                        .map(|v| v.as_ref().map(|v| hex::encode(&v.asset_generator)))
                        .collect(),
                    value_commitments: commitments
                        .iter()
                        .map(|v| v.as_ref().map(|v| hex::encode(&v.value_commitment)))
                        .collect(),
                    assetblinders: commitments
                        .iter()
                        .map(|v| v.as_ref().map(|v| v.abf))
                        .collect(),
                    amountblinders: commitments
                        .iter()
                        .map(|v| v.as_ref().map(|v| v.vbf))
                        .collect(),
                };
                let result = CString::new(serde_json::to_string(&result).unwrap()).unwrap();
                let rc = gdk::GA_auth_handler_resolve_code(call, result.as_ptr());
                ensure!(rc == 0, "GA_auth_handler_resolve_code failed");
            }

            gdk_json::HwAction::SignMessage => {
                let path = required_data.path.unwrap();
                let message = required_data.message.unwrap();
                let use_ae_protocol = required_data.use_ae_protocol.unwrap_or_default();
                ensure!(use_ae_protocol);
                let ae_host_commitment =
                    hex::decode(required_data.ae_host_commitment.unwrap()).unwrap();
                let ae_host_entropy =
                    ByteBuf::from(hex::decode(required_data.ae_host_entropy.unwrap()).unwrap());

                hw_data.clear_queue();

                hw_data.jade.send(sideswap_jade::Req::SignMessage(
                    sideswap_jade::models::SignMessageReq {
                        path,
                        message,
                        ae_host_commitment,
                    },
                ));
                let resp = hw_data.get_resp();
                let signer_commitment = match resp {
                    Ok(sideswap_jade::Resp::SignMessage(v)) => v,
                    resp => bail!("unexpected Jade response: {:?}", resp),
                };

                hw_data
                    .jade
                    .send(sideswap_jade::Req::GetSignature(Some(ae_host_entropy)));
                let resp = hw_data.get_resp();
                let signature = match resp {
                    Ok(sideswap_jade::Resp::GetSignature(v)) => v,
                    resp => bail!("unexpected Jade response: {:?}", resp),
                }
                .unwrap();

                // Convert signature into DER format
                let signature = match signature.len() {
                    64 => signature.as_slice(),
                    65 => &signature[1..],
                    _ => bail!("unexpected signature size: {}", signature.len()),
                };
                let signature = secp256k1::ecdsa::Signature::from_compact(signature)?
                    .serialize_der()
                    .to_vec();

                let result = gdk_json::SignMessage {
                    signature: hex::encode(signature),
                    signer_commitment: hex::encode(signer_commitment),
                };
                let result = CString::new(serde_json::to_string(&result).unwrap()).unwrap();
                let rc = gdk::GA_auth_handler_resolve_code(call, result.as_ptr());
                ensure!(rc == 0, "GA_auth_handler_resolve_code failed");
            }

            gdk_json::HwAction::GetMasterBlindingKey => {
                let result = gdk_json::MasterBlindingKeyRes {
                    master_blinding_key: hw_data.master_blinding_key.clone(),
                };
                let result = serde_json::to_string(&result).unwrap();
                let result = CString::new(result).unwrap();
                let rc = gdk::GA_auth_handler_resolve_code(call, result.as_ptr());
                ensure!(rc == 0, "GA_auth_handler_resolve_code failed");
            }
        };
    };

    let result = json
        .to_json::<gdk_json::AuthHandler<T>>()
        .map_err(|e| anyhow!("parsing failed: {}, json: {}", e, json.to_str()))?;
    if result.status == gdk_json::Status::Error {
        if let Some(error) = result.error {
            bail!("{}", error);
        }
        bail!("unknown auth handler error");
    }
    ensure!(
        result.status == gdk_json::Status::Done,
        "unexpected auth handler status: {:?}",
        result.status
    );
    let result = result
        .result
        .ok_or_else(|| anyhow!("auth handler error: no result field"))?;
    Ok(result)
}

struct NotifContext {
    account_id: AccountId,
    notif_callback: NotifCallback,
    session: *const gdk::GA_session,
}

unsafe extern "C" fn notification_callback_cpp(
    context: *mut std::os::raw::c_void,
    details: *mut gdk::GA_json,
) {
    let context = &*(context as *const NotifContext);
    let mut details = GdkJson::owned(details);
    debug!(
        "new notification from {} (session {:p}): {}",
        context.account_id,
        context.session,
        details.to_str()
    );
    let details = details.to_json::<gdk_json::Notification>().unwrap();

    (*context.notif_callback)(context.account_id, details);
}

fn last_gdk_error_details() -> Result<String, anyhow::Error> {
    let mut json = std::ptr::null_mut();
    let rc = unsafe { gdk::GA_get_thread_error_details(&mut json) };
    ensure!(rc == 0, "GA_get_thread_error_details failed");
    let mut json = unsafe { GdkJson::owned(json) };
    let json = json.to_json::<gdk_json::ErrorDetailsResult>()?;
    Ok(json.details)
}

fn convert_input(input: &gdk_json::TransactionInput) -> Option<models::Balance> {
    match (input.is_relevant, input.asset_id, input.satoshi) {
        (true, Some(asset_id), Some(satoshi)) if satoshi != 0 => Some(models::Balance {
            asset: asset_id,
            value: -(satoshi as i64),
        }),
        _ => None,
    }
}

fn convert_output(output: &gdk_json::TransactionOutput) -> Option<models::Balance> {
    match (output.is_relevant, output.asset_id, output.satoshi) {
        (true, Some(asset_id), Some(satoshi)) if satoshi != 0 => Some(models::Balance {
            asset: asset_id,
            value: satoshi as i64,
        }),
        _ => None,
    }
}

pub fn convert_tx(tx: &gdk_json::Transaction) -> Transaction {
    let created_at = tx.created_at_ts / 1000;
    let mut balances = std::collections::BTreeMap::<AssetId, i64>::new();
    for input in tx.inputs.iter() {
        match (input.asset_id, input.satoshi) {
            (Some(asset_id), Some(amount)) => {
                *balances.entry(asset_id).or_default() -= amount as i64
            }
            _ => {}
        }
    }
    for output in tx.outputs.iter() {
        match (output.asset_id, output.satoshi) {
            (Some(asset_id), Some(amount)) => {
                *balances.entry(asset_id).or_default() += amount as i64
            }
            _ => {}
        }
    }
    let balances = balances
        .iter()
        .map(|(asset_id, balance)| models::Balance {
            asset: *asset_id,
            value: *balance,
        })
        .collect::<Vec<_>>();

    let balances_all = tx
        .inputs
        .iter()
        .map(convert_input)
        .chain(tx.outputs.iter().map(convert_output))
        .flatten()
        .collect();

    let max_pointer_external = tx
        .outputs
        .iter()
        .filter(|output| output.is_relevant && !output.is_internal)
        .filter_map(|output| output.pointer)
        .max()
        .unwrap_or_default();

    let max_pointer_internal = tx
        .outputs
        .iter()
        .filter(|output| output.is_relevant && output.is_internal)
        .filter_map(|output| output.pointer)
        .max()
        .unwrap_or_default();

    Transaction {
        txid: tx.txhash,
        network_fee: tx.fee,
        vsize: tx.transaction_vsize,
        size: 0, // FIXME: GDK now only provides `transaction_vsize` and `transaction_weight`
        memo: tx.memo.clone(),
        balances,
        created_at,
        block_height: tx.block_height,
        balances_all,
        max_pointer_external,
        max_pointer_internal,
    }
}

pub fn get_redeem_script(utxo: &gdk_json::UnspentOutput) -> elements::Script {
    if let Some(public_key) = utxo.public_key.as_ref() {
        sideswap_common::pset::p2shwpkh_redeem_script(public_key)
    } else {
        elements::script::Builder::new()
            .push_int(0)
            .push_slice(&elements::WScriptHash::hash(utxo.prevout_script.as_bytes())[..])
            .into_script()
    }
}

unsafe fn load_transactions(
    data: &GdkSesImpl,
) -> Result<Vec<gdk_json::Transaction>, anyhow::Error> {
    let session = data.session;
    let subaccount = data.get_subaccount()?;

    let mut result = HashMap::new();
    let mut first = 0;
    // Looks like 900 is max tx count that could be loaded at once
    let count = 900;
    let mut load_more = true;
    while load_more {
        let list_transactions = gdk_json::ListTransactions {
            subaccount,
            first,
            count,
        };
        let mut call = std::ptr::null_mut();
        let rc = gdk::GA_get_transactions(
            session,
            GdkJson::new(&list_transactions).as_ptr(),
            &mut call,
        );
        ensure!(rc == 0, "GA_get_transactions failed");
        let transaction_list = run_auth_handler::<gdk_json::TransactionList>(
            data.hw_data.as_ref(),
            call,
            HandlerParams::new(),
        )?;
        load_more = transaction_list.transactions.len() as i32 == count;
        first += transaction_list.transactions.len() as i32;
        for tx in transaction_list.transactions.into_iter() {
            result.insert(tx.txhash, tx);
        }
    }
    Ok(result.into_values().collect())
}

fn try_get_gaid(data: &GdkSesImpl) -> Result<String, anyhow::Error> {
    data.receiving_id
        .clone()
        .ok_or_else(|| anyhow!("not connected, receiving_id is not set"))
}

unsafe fn try_get_addr_info(
    data: &GdkSesImpl,
    is_internal: bool,
) -> Result<gdk_json::AddressInfo, anyhow::Error> {
    let session = data.session;
    let subaccount = data.get_subaccount()?;

    let get_addr = gdk_json::RecvAddrOpt {
        subaccount,
        is_internal: Some(is_internal),
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_get_receive_address(session, GdkJson::new(&get_addr).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_get_receive_address failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let recv_addr = run_auth_handler::<gdk_json::AddressInfo>(
        data.hw_data.as_ref(),
        call,
        HandlerParams::new(),
    )
    .map_err(|e| anyhow!("receiving new address failed: {}", e))?;
    debug!("recv addr: {:?}", &recv_addr.address);

    Ok(recv_addr)
}

unsafe fn try_get_unspent_outputs(
    data: &GdkSesImpl,
) -> Result<gdk_json::UnspentOutputsResult, anyhow::Error> {
    let session = data.session;
    let subaccount = data.get_subaccount()?;
    let mut call = std::ptr::null_mut();
    let unspent_outputs = gdk_json::UnspentOutputsArgs {
        subaccount,
        num_confs: 0,
    };
    let rc =
        gdk::GA_get_unspent_outputs(session, GdkJson::new(&unspent_outputs).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_get_unspent_outputs failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let unspent_outputs = run_auth_handler::<gdk_json::UnspentOutputsResult>(
        data.hw_data.as_ref(),
        call,
        HandlerParams::new(),
    )
    .map_err(|e| anyhow!("loading unspent outputs failed: {}", e))?;
    Ok(unspent_outputs)
}

unsafe fn try_create_tx(
    data: &mut GdkSesImpl,
    tx: ffi::proto::CreateTx,
) -> Result<serde_json::Value, anyhow::Error> {
    let session = data.session;
    let subaccount = data.get_subaccount()?;

    let unspent_outputs = try_get_unspent_outputs(data)?.unspent_outputs;

    let bitcoin_balance = unspent_outputs
        .get(&data.policy_asset)
        .map(|inputs| inputs.iter().map(|input| input.satoshi).sum::<u64>())
        .unwrap_or_default();
    ensure!(bitcoin_balance > 0, "Insufficient L-BTC to pay network fee");

    // There should be no more than one is_greedy recepient
    let greedy_count = tx
        .addressees
        .iter()
        .map(|addresse| u32::from(addresse.is_greedy.unwrap_or_default()))
        .sum::<u32>();
    ensure!(greedy_count == 0 || greedy_count == 1);
    // Find addresse with is_greedy (only consider L-BTC because is_greedy is not very useful for other assets)
    let greedy_index = tx
        .addressees
        .iter()
        .enumerate()
        .filter(|(_index, addresse)| {
            addresse.is_greedy.unwrap_or_default()
                && addresse.asset_id == data.policy_asset.to_string()
        })
        .next()
        .map(|(index, _addresse)| index);
    if greedy_index.is_some() {
        // Ensure that L-BTC send balance is equal to whole L-BTC balance.
        // We don't want to send more than expected.
        let total_bitcoin_send = tx
            .addressees
            .iter()
            .filter_map(|addresse| {
                (addresse.asset_id == data.policy_asset.to_string()).then(|| addresse.amount)
            })
            .sum::<i64>();
        ensure!(total_bitcoin_send == bitcoin_balance as i64);
    }

    let addressees = tx
        .addressees
        .iter()
        .enumerate()
        .map(
            |(index, addresse)| -> Result<gdk_json::TxAddressee, anyhow::Error> {
                let asset_id = AssetId::from_str(&addresse.asset_id)?;
                Ok(gdk_json::TxAddressee {
                    address: addresse.address.clone(),
                    satoshi: addresse.amount as u64,
                    asset_id,
                    // Use sanitized greedy_index value to prevent setting it for non-LBTC assets
                    is_greedy: greedy_index.map(|greedy_index| greedy_index == index),
                })
            },
        )
        .collect::<Result<Vec<_>, _>>()?;

    let create_tx = gdk_json::CreateTransactionOpt {
        subaccount,
        addressees,
        utxos: unspent_outputs,
        // utxo_strategy: None,
        is_partial: false,
        used_utxos: None,
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_create_transaction(session, GdkJson::new(&create_tx).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_create_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let created_tx_json =
        run_auth_handler::<serde_json::Value>(data.hw_data.as_ref(), call, HandlerParams::new())
            .map_err(|e| anyhow!("creating transaction failed: {}", e))?;
    let created_tx =
        serde_json::from_value::<gdk_json::CreateTransactionResult>(created_tx_json.clone())
            .map_err(|e| anyhow!("parsing created transaction JSON failed: {}", e))?;
    debug!("created tx: {:?}", &created_tx);
    ensure!(created_tx.error.is_empty(), "{}", created_tx.error);
    ensure!(created_tx.fee.unwrap_or_default() > 0, "network fee is 0");

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_blind_transaction(session, GdkJson::new(&created_tx_json).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_blind_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let blinded_tx_json =
        run_auth_handler::<serde_json::Value>(data.hw_data.as_ref(), call, HandlerParams::new())
            .map_err(|e| anyhow!("blinding transaction failed: {}", e))?;
    debug!("blinded tx: {:?}", &blinded_tx_json);

    Ok(blinded_tx_json)
}

unsafe fn try_send_tx(
    data: &mut GdkSesImpl,
    tx: &serde_json::Value,
    assets: &BTreeMap<AssetId, Asset>,
) -> Result<elements::Txid, anyhow::Error> {
    let session = data.session;

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_sign_transaction(session, GdkJson::new(&tx).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_sign_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let signed_tx_json = run_auth_handler::<serde_json::Value>(
        data.hw_data.as_ref(),
        call,
        HandlerParams::new().with_assets(assets),
    )
    .map_err(|e| anyhow!("signing tx failed: {}", e))?;
    let signed_tx =
        serde_json::from_value::<gdk_json::SignTransactionResult>(signed_tx_json.clone())
            .map_err(|e| anyhow!("parsing signed transaction JSON failed: {}", e))?;
    ensure!(signed_tx.error.is_empty(), "{}", signed_tx.error);
    debug!("signed tx: {:?}", &signed_tx);

    ensure!(signed_tx
        .transaction_outputs
        .iter()
        .all(|v| v.address.is_none() == v.scriptpubkey.is_empty()));

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_send_transaction(session, GdkJson::new(&signed_tx_json).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_send_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let send_result = run_auth_handler::<gdk_json::SendTransactionResult>(
        data.hw_data.as_ref(),
        call,
        HandlerParams::new(),
    )
    .map_err(|e| anyhow!("sending tx failed: {}", e))?;
    info!("send succeed, waiting for txhash: {}", &send_result.txhash);

    Ok(send_result.txhash)
}

unsafe fn try_create_payjoin(
    data: &mut GdkSesImpl,
    req: ffi::proto::CreatePayjoin,
) -> Result<ffi::proto::CreatedPayjoin, anyhow::Error> {
    ensure!(req.balance.amount > 0);
    let send_amount = req.balance.amount as u64;
    let send_asset = AssetId::from_str(&req.balance.asset_id).unwrap();
    let address = elements::Address::from_str(&req.addr)?;

    let unspent_outputs = try_get_unspent_outputs(data)?
        .unspent_outputs
        .remove(&send_asset)
        .unwrap_or_default();

    let balance = unspent_outputs
        .iter()
        .map(|input| input.satoshi)
        .sum::<u64>();
    ensure!(send_amount <= balance, "Insufficient funds");

    ensure!(unspent_outputs.iter().all(|utxo| utxo
        .asset_tag
        .clone()
        .into_inner()
        .is_confidential()
        && utxo.commitment.clone().into_inner().is_confidential()
        && utxo.amountblinder != elements::confidential::ValueBlindingFactor::zero()
        && utxo.assetblinder != elements::confidential::AssetBlindingFactor::zero()));
    ensure!(unspent_outputs
        .iter()
        .all(|utxo| utxo.public_key.is_some() || utxo.script.is_some()));

    let subtract_fee_from_amount = balance == send_amount;

    let change_address = try_get_addr_info(data, true)?.address;

    let utxos = unspent_outputs
        .into_iter()
        .map(|utxo| {
            let script_pub_key = utxo
                .script
                .unwrap_or_else(|| sideswap_payjoin::pset::p2pkh_script(&utxo.public_key.unwrap()));
            sideswap_payjoin::server_api::Utxo {
                txid: utxo.txhash,
                vout: utxo.vout,
                script_pub_key,
                asset_id: utxo.asset_id,
                value: utxo.satoshi,
                asset_bf: utxo.assetblinder,
                value_bf: utxo.amountblinder,
                asset_commitment: utxo
                    .asset_tag
                    .into_inner()
                    .into_asset_gen(SECP256K1)
                    .expect("only confidential inputs expected here"),
                value_commitment: utxo
                    .commitment
                    .into_inner()
                    .commitment()
                    .expect("only confidential inputs expected here"),
            }
        })
        .collect::<Vec<_>>();

    let resp = sideswap_payjoin::create_payjoin(sideswap_payjoin::CreatePayjoin {
        base_url: data.login_info.env.data().base_server_url(),
        user_agent: worker::USER_AGENT.to_owned(),
        asset_id: send_asset,
        amount: send_amount,
        subtract_fee_from_amount,
        address,
        change_address,
        utxos,
    })?;

    let pset =
        base64::engine::general_purpose::STANDARD.encode(elements::encode::serialize(&resp.pset));

    Ok(ffi::proto::CreatedPayjoin {
        req,
        pset,
        asset_fee: resp.asset_fee as i64,
    })
}

unsafe fn try_send_payjoin(
    data: &mut GdkSesImpl,
    req: &ffi::proto::CreatedPayjoin,
    assets: &BTreeMap<AssetId, Asset>,
) -> Result<elements::Txid, anyhow::Error> {
    let session = data.session;
    let send_asset = AssetId::from_str(&req.req.balance.asset_id).unwrap();

    let utxos = try_get_unspent_outputs(data)?
        .unspent_outputs
        .remove(&send_asset)
        .unwrap_or_default();

    let sign_pset = gdk_json::SignPsetOpt {
        utxos,
        psbt: req.pset.clone(),
        blinding_nonces: Vec::new(), // FIXME: Get nonces for AMP accounts
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_psbt_sign(session, GdkJson::new(&sign_pset).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_sign_psbt failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let mut signed_pset_json = run_auth_handler::<serde_json::Value>(
        data.hw_data.as_ref(),
        call,
        HandlerParams::new().with_assets(assets),
    )
    .map_err(|e| anyhow!("signing pset failed: {}", e))?;
    let signed_pset = serde_json::from_value::<gdk_json::SignPsetResult>(signed_pset_json.clone())?;

    let pset_server = elements::encode::deserialize::<elements::pset::PartiallySignedTransaction>(
        &base64::engine::general_purpose::STANDARD.decode(&req.pset)?,
    )?;
    let pset_client = elements::encode::deserialize::<elements::pset::PartiallySignedTransaction>(
        &base64::engine::general_purpose::STANDARD.decode(signed_pset.psbt)?,
    )?;

    let tx = sideswap_payjoin::final_tx(pset_client, pset_server)?;
    let tx = elements::encode::serialize_hex(&tx);

    signed_pset_json
        .as_object_mut()
        .unwrap()
        .insert("transaction".to_owned(), serde_json::Value::String(tx));

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_send_transaction(session, GdkJson::new(&signed_pset_json).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_send_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let send_result = run_auth_handler::<gdk_json::SendTransactionResult>(
        data.hw_data.as_ref(),
        call,
        HandlerParams::new(),
    )
    .map_err(|e| anyhow!("sending tx failed: {}", e))?;
    info!("send succeed, waiting for txhash: {}", &send_result.txhash);

    Ok(send_result.txhash)
}

unsafe fn verify_and_sign_pset(
    data: &GdkSesImpl,
    amounts: &crate::swaps::Amounts,
    pset: &str,
    nonces: &[String],
    assets: &BTreeMap<AssetId, Asset>,
) -> Result<String, anyhow::Error> {
    let session = data.session;

    let unspent_outputs = try_get_unspent_outputs(data)?.unspent_outputs;

    let mut utxos = Vec::<gdk_json::UnspentOutput>::new();
    for (_asset_id, list) in unspent_outputs.into_iter() {
        utxos.extend(list.into_iter());
    }

    let verify_pset = gdk_json::PsetDetailsOpt {
        utxos: utxos.clone(),
        psbt: pset.to_owned(),
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_psbt_get_details(session, GdkJson::new(&verify_pset).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_psbt_get_details failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let pset_details = run_auth_handler::<gdk_json::PsetDetailsResult>(
        data.hw_data.as_ref(),
        call,
        HandlerParams::new(),
    )
    .map_err(|e| anyhow!("loading PSET details failed: {}", e))?;
    debug!("decoded AMP pset details: {:?}", &pset_details);
    for (asset, _amount) in pset_details.satoshi.iter() {
        ensure!(*asset == amounts.send_asset || *asset == amounts.recv_asset);
    }
    let send_amount = -pset_details
        .satoshi
        .get(&amounts.send_asset)
        .cloned()
        .unwrap_or_default();
    let recv_amount = pset_details
        .satoshi
        .get(&amounts.recv_asset)
        .cloned()
        .unwrap_or_default();
    // GDK includes network fee amount for L-BTC inputs
    let send_amount = if amounts.send_asset == data.policy_asset && send_amount != 0 {
        send_amount + pset_details.fee.unwrap_or_default()
    } else {
        send_amount
    };
    ensure!(send_amount == amounts.send_amount as i64);
    ensure!(recv_amount == amounts.recv_amount as i64);

    if amounts.send_amount == 0 {
        return Ok(pset.to_owned());
    }

    let sign_pset = gdk_json::SignPsetOpt {
        utxos,
        psbt: pset.to_owned(),
        blinding_nonces: nonces.to_owned(),
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_psbt_sign(session, GdkJson::new(&sign_pset).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_sign_psbt failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let signed_pset = run_auth_handler::<gdk_json::SignPsetResult>(
        data.hw_data.as_ref(),
        call,
        HandlerParams::new()
            .with_assets(assets)
            .with_tx_status(TxType::Swap),
    )
    .map_err(|e| anyhow!("signing pset failed: {}", e))?;
    Ok(signed_pset.psbt)
}

unsafe fn sig_single_maker_utxo(
    data: &GdkSesImpl,
    input: &crate::swaps::SigSingleInput,
    assets: &BTreeMap<AssetId, Asset>,
) -> Result<(gdk_json::UnspentOutput, Option<MakerChainingTx>), anyhow::Error> {
    let send_asset = input.asset;

    let unspent_outputs = try_get_unspent_outputs(data)?.unspent_outputs;

    if let Some(unspent_output) = unspent_outputs
        .get(&send_asset)
        .cloned()
        .unwrap_or_default()
        .into_iter()
        .find(|utxo| utxo.satoshi == input.value)
    {
        return Ok((unspent_output, None));
    }

    let subaccount = data.get_subaccount()?;
    let session = data.session;

    // If set to true, Jade will show all outputs for confirmation (because all outputs are recognized as changes)
    let is_internal = false;
    let address_info = try_get_addr_info(data, is_internal)?;
    let bitcoin_balance = unspent_outputs
        .get(&data.policy_asset)
        .map(|inputs| inputs.iter().map(|input| input.satoshi).sum::<u64>())
        .unwrap_or_default();
    let send_all = input.value == bitcoin_balance && send_asset == data.policy_asset;

    let addressee = gdk_json::TxInternalAddressee {
        address_info: address_info.clone(),
        satoshi: input.value,
        asset_id: send_asset,
        is_greedy: Some(send_all),
    };

    let create_tx = gdk_json::CreateInternalTransactionOpt {
        subaccount,
        addressees: vec![addressee],
        utxos: unspent_outputs,
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_create_transaction(session, GdkJson::new(&create_tx).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_create_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let mut created_tx_json =
        run_auth_handler::<serde_json::Value>(data.hw_data.as_ref(), call, HandlerParams::new())
            .map_err(|e| anyhow!("creating transaction failed: {}", e))?;
    let created_tx =
        serde_json::from_value::<gdk_json::CreateTransactionResult>(created_tx_json.clone())
            .map_err(|e| anyhow!("parsing created transaction JSON failed: {}", e))?;
    debug!("created tx: {:?}", &created_tx);
    ensure!(created_tx.error.is_empty(), "{}", created_tx.error);
    ensure!(created_tx.fee.unwrap_or_default() > 0, "network fee is 0");

    if !data.login_info.single_sig {
        created_tx_json.as_object_mut().unwrap().insert(
            "sign_with".to_owned(),
            serde_json::json!(["user", "green-backend"]),
        );
    }

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_blind_transaction(session, GdkJson::new(&created_tx_json).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_blind_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let blinded_tx_json =
        run_auth_handler::<serde_json::Value>(data.hw_data.as_ref(), call, HandlerParams::new())
            .map_err(|e| anyhow!("blinding transaction failed: {}", e))?;
    debug!("blinded tx: {:?}", &blinded_tx_json);

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_sign_transaction(session, GdkJson::new(&blinded_tx_json).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_sign_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let signed_tx = run_auth_handler::<gdk_json::SignTransactionResult>(
        data.hw_data.as_ref(),
        call,
        HandlerParams::new()
            .with_assets(assets)
            .with_tx_status(TxType::OfflineSwapOutput),
    )
    .map_err(|e| anyhow!("signing tx failed: {}", e))?;
    debug!("signed tx: {:?}", &signed_tx);
    ensure!(signed_tx.error.is_empty(), "{}", signed_tx.error);

    let tx = signed_tx
        .transaction
        .ok_or_else(|| anyhow!("transaction is empty"))?
        .into_inner();

    ensure!(!send_all || signed_tx.transaction_outputs.len() == 2);
    let (pt_idx, output) = signed_tx
        .transaction_outputs
        .iter()
        .enumerate()
        .find(|(_, output)| {
            output.address.as_ref() == Some(&address_info.address.to_string())
                && (output.satoshi == input.value || send_all)
                && output.asset_id == Some(send_asset)
        })
        .ok_or_else(|| anyhow!("constructed UTXO not found"))?;
    let output_asset_bf = output
        .assetblinder
        .ok_or_else(|| anyhow!("assetblinder is not set"))?;
    let output_value_bf = output
        .amountblinder
        .ok_or_else(|| anyhow!("amountblinder is not set"))?;

    let tx_out = &tx.output[pt_idx];
    let asset_commitment = tx_out.asset;
    let value_commitment = tx_out.value;
    let nonce_commitment = tx_out.nonce;

    let prevout_script = if let Some(script) = address_info.script.clone() {
        script
    } else if let Some(public_key) = address_info.public_key {
        ensure!(data.login_info.single_sig);
        sideswap_common::pset::p2pkh_script(&public_key)
    } else {
        bail!("script or public_key must be known");
    };

    let utxo = gdk_json::UnspentOutput {
        address_type: address_info.address_type,
        txhash: tx.txid(),
        pointer: address_info.pointer,
        vout: pt_idx as u32,
        asset_id: output.asset_id.unwrap(),
        satoshi: output.satoshi,
        amountblinder: output_value_bf,
        assetblinder: output_asset_bf,
        subaccount: address_info.subaccount,
        is_internal,
        user_sighash: None,
        prevout_script,
        is_blinded: true,
        is_confidential: Some(true),
        public_key: address_info.public_key,
        user_path: Some(address_info.user_path),
        block_height: None,
        script: address_info.script,
        script_type: address_info.script_type,
        subtype: address_info.subtype,
        user_status: None,
        asset_tag: asset_commitment.into(),
        commitment: value_commitment.into(),
        nonce_commitment: nonce_commitment.to_string(),
    };
    debug!("chained utxo: {}", serde_json::to_string(&utxo).unwrap());

    let chaining_tx = MakerChainingTx {
        input: sideswap_api::PsetInput {
            txid: tx.txid(),
            vout: pt_idx as u32,
            asset: send_asset,
            asset_bf: output.assetblinder.unwrap(),
            value: output.satoshi,
            value_bf: output.amountblinder.unwrap(),
            redeem_script: Some(get_redeem_script(&utxo)),
        },
        tx,
    };

    Ok((utxo, Some(chaining_tx)))
}

unsafe fn sig_single_maker_tx(
    data: &GdkSesImpl,
    input: &crate::swaps::SigSingleInput,
    output: &crate::swaps::SigSingleOutput,
    assets: &BTreeMap<AssetId, Asset>,
) -> Result<crate::swaps::SigSingleMaker, anyhow::Error> {
    let (unspent_output, chaining_tx) = sig_single_maker_utxo(data, input, assets)?;

    let session = data.session;

    let create_swap_opts = gdk_json::CreateSwapOpts {
        swap_type: gdk_json::CreateSwapType::Liquidex,
        input_type: gdk_json::CreateSwapInputType::LiquidexV1,
        output_type: gdk_json::CreateSwapInputType::LiquidexV1,
        liquidex_v1: gdk_json::LiquidexOpts {
            receive: vec![gdk_json::LiquidexReceive {
                asset_id: output.asset,
                satoshi: output.value,
            }],
            send: vec![unspent_output.clone()],
        },
        receive_address: Some(output.address_info.clone()),
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_create_swap_transaction(
        session,
        GdkJson::new(&create_swap_opts).as_ptr(),
        &mut call,
    );
    ensure!(
        rc == 0,
        "GA_create_swap_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let created_swap = run_auth_handler::<gdk_json::CreateSwap>(
        data.hw_data.as_ref(),
        call,
        HandlerParams::new()
            .with_assets(assets)
            .with_tx_status(TxType::OfflineSwap),
    )
    .map_err(|e| anyhow!("creating swap failed: {}", e))?;

    Ok(crate::swaps::SigSingleMaker {
        proposal: created_swap.liquidex_v1.proposal,
        chaining_tx,
        unspent_output,
    })
}

unsafe fn get_balances(data: &GdkSesImpl) -> Result<gdk_json::BalanceList, anyhow::Error> {
    let subaccount = data.get_subaccount()?;
    let session = data.session;
    let balance = gdk_json::UnspentOutputsArgs {
        subaccount,
        num_confs: 0,
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_get_balance(session, GdkJson::new(&balance).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_get_balance failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let balances = run_auth_handler::<gdk_json::BalanceList>(
        data.hw_data.as_ref(),
        call,
        HandlerParams::new(),
    )
    .map_err(|e| anyhow!("loading balances failed: {}", e))?;
    Ok(balances)
}

fn get_blinded_value(
    value: u64,
    asset: &AssetId,
    value_bf: &elements::confidential::ValueBlindingFactor,
    asset_bf: &elements::confidential::AssetBlindingFactor,
) -> String {
    [
        value.to_string(),
        asset.to_string(),
        value_bf.to_string(),
        asset_bf.to_string(),
    ]
    .join(",")
}

unsafe fn get_blinded_values(data: &GdkSesImpl, txid: &str) -> Result<Vec<String>, anyhow::Error> {
    let txid = elements::Txid::from_str(txid)?;
    let transaction_list = load_transactions(data)?;
    let tx = transaction_list
        .iter()
        .find(|tx| tx.txhash == txid)
        .ok_or_else(|| anyhow!("tx not found"))?;
    let mut result = Vec::new();
    for input in tx.inputs.iter() {
        match (
            input.satoshi,
            input.asset_id,
            input.amountblinder,
            input.assetblinder,
        ) {
            (Some(value), Some(asset_id), Some(value_bf), Some(asset_bf)) => {
                result.push(get_blinded_value(value, &asset_id, &value_bf, &asset_bf))
            }
            _ => {}
        }
    }
    for output in tx.outputs.iter() {
        match (
            output.satoshi,
            output.asset_id,
            output.amountblinder,
            output.assetblinder,
        ) {
            (Some(value), Some(asset_id), Some(value_bf), Some(asset_bf)) => {
                result.push(get_blinded_value(value, &asset_id, &value_bf, &asset_bf))
            }
            _ => {}
        }
    }
    Ok(result)
}

unsafe fn make_pegout_payment(
    data: &GdkSesImpl,
    send_amount: i64,
    peg_addr: &str,
    send_amount_exact: i64,
) -> Result<worker::PegPayment, anyhow::Error> {
    let subaccount = data.get_subaccount()?;
    let session = data.session;
    let send_asset = data.policy_asset;

    let unspent_outputs = try_get_unspent_outputs(data)?.unspent_outputs;

    let inputs = unspent_outputs.get(&send_asset);
    let total = inputs
        .iter()
        .flat_map(|inputs| inputs.iter())
        .map(|input| input.satoshi)
        .sum::<u64>() as i64;
    ensure!(send_amount <= total, "Insufficient funds");
    let send_all = send_amount == total;

    let tx_addressee = gdk_json::TxAddressee {
        address: peg_addr.to_owned(),
        satoshi: send_amount as u64,
        asset_id: send_asset,
        is_greedy: Some(send_all),
    };
    let create_tx = gdk_json::CreateTransactionOpt {
        subaccount,
        addressees: vec![tx_addressee],
        utxos: unspent_outputs,
        // utxo_strategy: None,
        is_partial: false,
        used_utxos: None,
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_create_transaction(session, GdkJson::new(&create_tx).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_create_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let created_tx_json =
        run_auth_handler::<serde_json::Value>(data.hw_data.as_ref(), call, HandlerParams::new())
            .map_err(|e| anyhow!("creating transaction failed: {}", e))?;
    let created_tx =
        serde_json::from_value::<gdk_json::CreateTransactionResult>(created_tx_json.clone())
            .map_err(|e| anyhow!("parsing created transaction JSON failed: {}", e))?;
    debug!("created tx: {:?}", &created_tx);
    ensure!(created_tx.error.is_empty(), "{}", created_tx.error);
    ensure!(created_tx.fee.unwrap_or_default() > 0, "network fee is 0");

    let sent_amount = if send_all {
        send_amount - created_tx.fee.unwrap() as i64
    } else {
        send_amount
    };
    ensure!(send_amount_exact == sent_amount);

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_blind_transaction(session, GdkJson::new(&created_tx_json).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_blind_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let blinded_tx_json =
        run_auth_handler::<serde_json::Value>(data.hw_data.as_ref(), call, HandlerParams::new())
            .map_err(|e| anyhow!("blinding transaction failed: {}", e))?;
    debug!("blinded tx: {:?}", &blinded_tx_json);

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_sign_transaction(session, GdkJson::new(&blinded_tx_json).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_sign_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let signed_tx_json =
        run_auth_handler::<serde_json::Value>(data.hw_data.as_ref(), call, HandlerParams::new())
            .map_err(|e| anyhow!("signing tx failed: {}", e))?;

    let signed_tx =
        serde_json::from_value::<gdk_json::SignTransactionResult>(signed_tx_json.clone())?;
    ensure!(signed_tx.error.is_empty(), "{}", signed_tx.error);

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_send_transaction(session, GdkJson::new(&signed_tx_json).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_send_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let send_result = run_auth_handler::<gdk_json::SendTransactionResult>(
        data.hw_data.as_ref(),
        call,
        HandlerParams::new(),
    )
    .map_err(|e| anyhow!("sending tx failed: {}", e))?;
    info!("send succeed, waiting for txhash: {}", &send_result.txhash);
    let transaction = signed_tx
        .transaction
        .ok_or_else(|| anyhow!("transaction is empty"))?
        .into_inner();

    Ok(worker::PegPayment {
        sent_amount,
        sent_txid: send_result.txhash,
        signed_tx: elements::encode::serialize_hex(&transaction),
    })
}

unsafe fn get_tx_fee(
    data: &GdkSesImpl,
    asset_id: AssetId,
    send_amount: i64,
    addr: &str,
) -> Result<gdk_ses::TxFeeInfo, anyhow::Error> {
    let subaccount = data.get_subaccount()?;
    let session = data.session;

    let unspent_outputs = try_get_unspent_outputs(data)?.unspent_outputs;

    let inputs = unspent_outputs.get(&asset_id);
    let total = inputs
        .iter()
        .flat_map(|inputs| inputs.iter())
        .map(|input| input.satoshi)
        .sum::<u64>() as i64;
    ensure!(send_amount <= total, "Insufficient funds");
    let send_all = send_amount == total && asset_id == data.policy_asset;

    let tx_addressee = gdk_json::TxAddressee {
        address: addr.to_owned(),
        satoshi: send_amount as u64,
        asset_id,
        is_greedy: Some(send_all),
    };
    let create_tx = gdk_json::CreateTransactionOpt {
        subaccount,
        addressees: vec![tx_addressee],
        utxos: unspent_outputs,
        // utxo_strategy: None,
        is_partial: false,
        used_utxos: None,
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_create_transaction(session, GdkJson::new(&create_tx).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_create_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let created_tx = run_auth_handler::<gdk_json::CreateTransactionResult>(
        data.hw_data.as_ref(),
        call,
        HandlerParams::new(),
    )
    .map_err(|e| anyhow!("creating transaction failed: {}", e))?;
    debug!("created tx: {:?}", &created_tx);
    ensure!(created_tx.error.is_empty(), "{}", created_tx.error);
    ensure!(created_tx.fee.unwrap_or_default() > 0, "network fee is 0");
    let transaction = created_tx
        .transaction
        .ok_or_else(|| anyhow!("transaction is empty"))?
        .into_inner();
    let input_count = transaction.input.len();
    let fee = created_tx.fee.unwrap_or_default();
    ensure!(fee > 0);

    Ok(gdk_ses::TxFeeInfo { input_count, fee })
}

unsafe fn get_previous_addresses(
    data: &GdkSesImpl,
    last_pointer: Option<u32>,
    is_internal: bool,
) -> Result<gdk_json::PreviousAddresses, anyhow::Error> {
    let subaccount = data.get_subaccount()?;
    if is_internal {
        return Ok(gdk_json::PreviousAddresses {
            last_pointer: Some(0),
            list: vec![],
        });
    }
    let session = data.session;

    let mut call = std::ptr::null_mut();
    debug!("load AMP addresses, last_pointer: {:?}", last_pointer);
    let previous_addresses = gdk_json::PreviousAddressesOpts {
        subaccount,
        last_pointer,
    };
    let rc = gdk::GA_get_previous_addresses(
        session,
        GdkJson::new(&previous_addresses).as_ptr(),
        &mut call,
    );
    ensure!(
        rc == 0,
        "GA_get_previous_addresses failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let previous_addresses = run_auth_handler::<gdk_json::PreviousAddresses>(
        data.hw_data.as_ref(),
        call,
        HandlerParams::new(),
    )
    .map_err(|e| anyhow!("loading previous addresses failed: {}", e))?;
    Ok(previous_addresses)
}

unsafe fn set_memo(data: &GdkSesImpl, txid: &str, memo: &str) -> Result<(), anyhow::Error> {
    let session = data.session;

    let txid = CString::new(txid).unwrap();
    let memo = CString::new(memo).unwrap();
    let rc = gdk::GA_set_transaction_memo(session, txid.as_ptr(), memo.as_ptr(), 0);
    ensure!(
        rc == 0,
        "GA_set_transaction_memo failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );

    Ok(())
}

static GDK_INITIALIZED: std::sync::Once = std::sync::Once::new();

unsafe fn register(data: &mut GdkSesImpl) -> Result<(), anyhow::Error> {
    let session = data.session;

    let hw_data = data.login_info.wallet_info.hw_data();
    let mnemonic = data.login_info.wallet_info.mnemonic().cloned();

    let hw_device = HwData::get_hw_device(hw_data);
    let login_user = gdk_json::LoginUser {
        mnemonic,
        username: None,
        password: None,
    };

    let mut call: *mut gdk::GA_auth_handler = std::ptr::null_mut();
    let rc = gdk::GA_register_user(
        session,
        GdkJson::new(&hw_device).as_ptr(),
        GdkJson::new(&login_user).as_ptr(),
        &mut call,
    );
    ensure!(
        rc == 0,
        "GA_register_user failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let register_result =
        run_auth_handler::<serde_json::Value>(hw_data, call, HandlerParams::new())
            .map_err(|e| anyhow!("registration failed: {}", e))?;
    debug!("registration result: {}", register_result);

    Ok(())
}

unsafe fn login(data: &mut GdkSesImpl) -> Result<(), anyhow::Error> {
    let session = data.session;

    let hw_data = data.login_info.wallet_info.hw_data();
    let mnemonic = data.login_info.wallet_info.mnemonic().cloned();
    let watch_only = data.login_info.wallet_info.watch_only();
    let username = watch_only.map(|watch_only| watch_only.username.clone());
    let password = watch_only.map(|watch_only| watch_only.password.clone());

    let hw_device = HwData::get_hw_device(hw_data);
    let login_user = gdk_json::LoginUser {
        mnemonic,
        username,
        password,
    };

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_login_user(
        session,
        GdkJson::new(&hw_device).as_ptr(),
        GdkJson::new(&login_user).as_ptr(),
        &mut call,
    );
    ensure!(
        rc == 0,
        "GA_login_user failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let login_result =
        run_auth_handler::<gdk_json::LoginUserResult>(hw_data, call, HandlerParams::new())
            .map_err(|e| anyhow!("login failed: {}", e))?;
    debug!("wallet_hash_id: {:?}", login_result.wallet_hash_id);

    if !data.login_info.single_sig {
        let get_subaccounts_opts = gdk_json::GetSubaccountsOpts {
            refresh: Some(false),
        };
        let mut call = std::ptr::null_mut();
        let rc = gdk::GA_get_subaccounts(
            session,
            GdkJson::new(&get_subaccounts_opts).as_ptr(),
            &mut call,
        );
        ensure!(
            rc == 0,
            "GA_get_subaccounts failed: {}",
            last_gdk_error_details().unwrap_or_default()
        );
        let subaccounts =
            run_auth_handler::<gdk_json::GetSubaccountsResult>(hw_data, call, HandlerParams::new())
                .map_err(|e| anyhow!("loading subaccounts failed: {}", e))?;
        info!("subaccounts: {subaccounts:?}");

        let (subaccount_name, subaccount_type) = if data.login_info.single_sig {
            (SUBACCOUNT_NAME_REG, SUBACCOUNT_TYPE_REG)
        } else {
            (SUBACCOUNT_NAME_AMP, SUBACCOUNT_TYPE_AMP)
        };

        let account = subaccounts
            .subaccounts
            .into_iter()
            .find(|account| account.type_ == subaccount_type)
            .ok_or_else(|| anyhow!("no account"))
            .or_else(|_| {
                let mut call = std::ptr::null_mut();
                let new_subaccount = gdk_json::CreateSubaccount {
                    name: subaccount_name.to_owned(),
                    type_: subaccount_type.to_owned(),
                };
                let rc = gdk::GA_create_subaccount(
                    session,
                    GdkJson::new(&new_subaccount).as_ptr(),
                    &mut call,
                );
                ensure!(
                    rc == 0,
                    "GA_create_subaccount failed: {}",
                    last_gdk_error_details().unwrap_or_default()
                );
                let created_subaccount =
                    run_auth_handler::<gdk_json::Subaccount>(hw_data, call, HandlerParams::new())
                        .map_err(|e| anyhow!("creating AMP subaccount failed: {}", e))?;
                Ok(created_subaccount)
            })?;

        data.subaccount = Some(account.pointer);
        data.receiving_id = Some(account.receiving_id);
    } else {
        data.subaccount = Some(0);
    }

    Ok(())
}

unsafe fn set_watch_only(
    data: &mut GdkSesImpl,
    username: &str,
    password: &str,
) -> Result<(), anyhow::Error> {
    let session = data.session;
    let username = CString::new(username).unwrap();
    let password = CString::new(password).unwrap();
    let rc = gdk::GA_set_watch_only(session, username.as_ptr(), password.as_ptr());
    ensure!(
        rc == 0,
        "GA_set_watch_only failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    Ok(())
}

unsafe fn reconnect_hint(data: &mut GdkSesImpl, hint: gdk_json::ReconnectHint) {
    debug!("send reconnect hint: {:?}", hint);
    let session = data.session;

    let hint = gdk_json::ReconnectHintOpt { hint };
    let rc = gdk::GA_reconnect_hint(session, GdkJson::new(&hint).as_ptr());
    if rc != 0 {
        warn!(
            "GA_reconnect_hint failed: {}",
            last_gdk_error_details().unwrap_or_default()
        );
    }
}

pub unsafe fn select_network(info: &gdk_ses::LoginInfo) -> String {
    let network = match (info.env.data().network, info.single_sig) {
        (Network::Mainnet, false) => "liquid",
        (Network::Testnet, false) => "testnet-liquid",
        (Network::Mainnet, true) => "electrum-liquid",
        (Network::Testnet, true) => "electrum-testnet-liquid",
        _ => panic!("Unknown network: {:?}", info.env.data().network),
    };

    let custom_electrum = match info.network.clone() {
        None | Some(ffi::proto::network_settings::Selected::Blockstream(_)) => None,
        Some(ffi::proto::network_settings::Selected::Sideswap(_)) => match info.env {
            Env::Prod | Env::Staging | Env::LocalLiquid => {
                Some(("electrs.sideswap.io".to_owned(), 12001, true))
            }
            Env::Testnet | Env::LocalTestnet => {
                Some(("electrs.sideswap.io".to_owned(), 12002, true))
            }
            Env::Regtest | Env::Local => panic!("Unsupported network {:?}", info.env),
        },
        Some(ffi::proto::network_settings::Selected::SideswapCn(_)) => match info.env {
            Env::Prod | Env::Staging | Env::LocalLiquid => {
                Some(("cn.sideswap.io".to_owned(), 12001, true))
            }
            Env::Testnet | Env::LocalTestnet | Env::Regtest | Env::Local => None,
        },
        Some(ffi::proto::network_settings::Selected::Custom(
            ffi::proto::network_settings::Custom {
                host,
                port,
                use_tls,
            },
        )) => Some((host, port, use_tls)),
    };

    let (custom_host, custom_port, custom_tls) = match custom_electrum {
        Some(custom) if info.single_sig => custom,
        _ => return network.to_owned(),
    };

    let mut networks = std::ptr::null_mut();
    let rc = gdk::GA_get_networks(&mut networks);
    assert!(rc == 0, "GA_get_networks failed");
    let mut networks = GdkJson::owned(networks);
    let networks = networks.to_json::<serde_json::Value>().unwrap();

    let mut new_network = networks.as_object().unwrap().get(network).unwrap().clone();

    let custom_electrum_url = format!("{custom_host}:{custom_port}");
    new_network.as_object_mut().unwrap().insert(
        "electrum_url".to_owned(),
        serde_json::Value::String(custom_electrum_url),
    );
    new_network.as_object_mut().unwrap().insert(
        "electrum_tls".to_owned(),
        serde_json::Value::Bool(custom_tls),
    );

    let custom_name = format!("{network}-custom");

    let custom_name_cstr = CString::new(custom_name.clone()).unwrap();
    let new_network = GdkJson::new(&new_network);

    let rc = gdk::GA_register_network(custom_name_cstr.as_ptr(), new_network.as_ptr());
    assert!(rc == 0);

    custom_name
}

pub unsafe fn start_processing_impl(
    info: gdk_ses::LoginInfo,
    notif_callback: Option<NotifCallback>,
) -> Result<Box<dyn gdk_ses::GdkSes>, anyhow::Error> {
    debug!("start processing, single_sig: {}", info.single_sig);
    let datadir = info.cache_dir.to_owned();
    GDK_INITIALIZED.call_once(move || {
        let config = gdk_json::InitConfig {
            datadir,
            log_level: None,
        };
        let rc = gdk::GA_init(GdkJson::new(&config).as_ptr());
        assert!(rc == 0);
    });

    let mut session = std::ptr::null_mut();
    let rc = gdk::GA_create_session(&mut session);
    assert!(rc == 0);

    if let Some(notif_callback) = notif_callback {
        let notif_context = Box::into_raw(Box::new(NotifContext {
            account_id: info.account_id,
            notif_callback,
            session,
        }));

        let rc = gdk::GA_set_notification_handler(
            session,
            Some(notification_callback_cpp),
            notif_context as *mut libc::c_void,
        );
        assert!(rc == 0);
    }

    let network = select_network(&info);
    let policy_asset = AssetId::from_str(info.env.data().policy_asset).unwrap();
    let connect_config = gdk_json::ConnectConfig {
        name: network,
        proxy: info.proxy.clone(),
        use_tor: Some(info.proxy.is_some()),
    };
    debug!("GA_connect start...");
    let rc = gdk::GA_connect(session, GdkJson::new(&connect_config).as_ptr());
    ensure!(
        rc == 0,
        "GA_connect failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    debug!("GA_connect succeed");

    let data = GdkSesImpl {
        hw_data: info.wallet_info.hw_data().cloned(),
        session,
        policy_asset,
        login_info: info,
        subaccount: None,
        receiving_id: None,
    };

    Ok(Box::new(data))
}

pub fn start_processing(
    info: gdk_ses::LoginInfo,
    notif_callback: Option<NotifCallback>,
) -> Result<Box<dyn gdk_ses::GdkSes>, anyhow::Error> {
    unsafe { start_processing_impl(info, notif_callback) }
}

#[cfg(test)]
mod test;
