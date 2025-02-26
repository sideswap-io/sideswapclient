use crate::{
    ffi, gdk, gdk_json,
    gdk_ses::{self, Balances, ElectrumServer, GdkSes, NotifCallback, SignWith},
    models,
    worker::{self, AccountId},
};
use anyhow::{anyhow, bail, ensure};
use elements::{
    hashes::Hash, pset::PartiallySignedTransaction, secp256k1_zkp::global::SECP256K1, TxOutSecrets,
};
use elements::{AssetId, EcdsaSighashType};
use gdk_ses::HwData;
use log::{debug, info, warn};
use secp256k1::SecretKey;
use serde_bytes::ByteBuf;
use sideswap_api::Asset;
use sideswap_common::{
    b64,
    env::Env,
    green_backend::GREEN_DUMMY_SIG,
    network::Network,
    pset::p2pkh_script,
    pset_blind::get_blinding_nonces,
    recipient::Recipient,
    send_tx::{self, coin_select::InOut},
};
use sideswap_jade::{
    jade_mng::{self, JadeStatus},
    models::JadeNetwork,
};
use sideswap_payjoin::Wallet;
use std::collections::{BTreeMap, BTreeSet, HashMap};
use std::ffi::{CStr, CString};
use std::str::FromStr;

const SUBACCOUNT_NAME_REG: &str = "Main account";
const SUBACCOUNT_TYPE_REG: &str = "p2sh-p2wpkh";

const SUBACCOUNT_NAME_AMP: &str = "AMP";
const SUBACCOUNT_TYPE_AMP: &str = "2of2_no_recovery";

struct CreatedTx {
    pset: PartiallySignedTransaction,
    blinding_nonces: Vec<String>,
}

pub struct CreatedTxCache {
    created_txs: BTreeMap<String, CreatedTx>,
}

impl Default for CreatedTxCache {
    fn default() -> Self {
        Self::new()
    }
}

impl CreatedTxCache {
    pub fn new() -> Self {
        Self {
            created_txs: Default::default(),
        }
    }
}

pub struct GdkSesImpl {
    login_info: gdk_ses::LoginInfo,
    hw_data: Option<HwData>,

    session: *mut gdk::GA_session,
    subaccount: Option<i32>,
    receiving_id: Option<String>,
    policy_asset: AssetId,
}

unsafe impl Send for GdkSesImpl {}

pub fn encode_pset(pset: &PartiallySignedTransaction) -> String {
    let pset = elements::encode::serialize(pset);
    b64::encode(&pset)
}

pub fn decode_pset(pset: &str) -> Result<PartiallySignedTransaction, anyhow::Error> {
    let pset = b64::decode(pset)?;
    let pset = elements::encode::deserialize(&pset)?;
    Ok(pset)
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

    fn get_balances(&self) -> Result<Balances, anyhow::Error> {
        unsafe { get_balances(self) }
    }

    fn get_transactions_impl(&self) -> Result<Vec<gdk_json::Transaction>, anyhow::Error> {
        unsafe { load_transactions(self) }
    }

    fn get_receive_address(&self) -> Result<gdk_json::AddressInfo, anyhow::Error> {
        unsafe { try_get_addr_info(self, false) }
    }

    fn get_change_address(&self) -> Result<gdk_json::AddressInfo, anyhow::Error> {
        unsafe { try_get_addr_info(self, true) }
    }

    fn create_tx(
        &mut self,
        cache: &mut CreatedTxCache,
        tx: ffi::proto::CreateTx,
    ) -> Result<ffi::proto::CreatedTx, anyhow::Error> {
        if let Some(fee_asset) = tx.fee_asset_id.as_ref() {
            let fee_asset = AssetId::from_str(fee_asset)?;
            unsafe { try_create_payjoin(self, cache, tx, fee_asset) }
        } else {
            unsafe { try_create_tx(self, cache, tx) }
        }
    }

    fn send_tx(
        &mut self,
        cache: &mut CreatedTxCache,
        id: &str,
        assets: &BTreeMap<AssetId, Asset>,
    ) -> Result<elements::Txid, anyhow::Error> {
        let tx = cache
            .created_txs
            .remove(id)
            .ok_or_else(|| anyhow!("can't find created tx"))?;

        let res = unsafe { try_send_tx(self, &tx, assets) };

        if res.is_err() {
            // Allow retrying
            cache.created_txs.insert(id.to_owned(), tx);
        }

        res
    }

    fn broadcast_tx(&mut self, tx: &str) -> Result<(), anyhow::Error> {
        unsafe { broadcast_tx(self, tx) }
    }

    fn get_utxos(&self) -> Result<gdk_json::UnspentOutputs, anyhow::Error> {
        unsafe { try_get_unspent_outputs(self) }
    }

    fn get_blinded_values(&self, txid: &elements::Txid) -> Result<Vec<String>, anyhow::Error> {
        unsafe { get_blinded_values(self, txid) }
    }

    fn get_previous_addresses(
        &mut self,
        last_pointer: Option<u32>,
        internal: bool,
    ) -> Result<gdk_json::PreviousAddresses, anyhow::Error> {
        unsafe { get_previous_addresses(self, last_pointer, internal) }
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

    fn sign_pset(
        &mut self,
        utxos: &gdk_json::UnspentOutputs,
        pset: &str,
        nonces: &[String],
        assets: &BTreeMap<AssetId, Asset>,
        tx_type: jade_mng::TxType,
        sign_with: SignWith,
    ) -> Result<String, anyhow::Error> {
        unsafe { sign_pset(self, utxos, pset, nonces, assets, tx_type, sign_with) }
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
        assert!(!ptr.is_null());
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
        if !self.str.is_null() {
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

pub fn unlock_hw(env: Env, jade: &jade_mng::ManagedJade) -> Result<(), anyhow::Error> {
    // (status_callback)(gdk_ses::JadeStatus::ReadStatus);
    let res = jade.read_status();
    // (status_callback)(gdk_ses::JadeStatus::Idle);
    let status = res?;
    debug!("jade state: {:?}", status.jade_state);

    match status.jade_state {
        sideswap_jade::models::State::Ready => {
            debug!("jade already unlocked");
        }
        sideswap_jade::models::State::Locked => {
            let network = get_jade_network(env);
            let _status = jade.start_status(JadeStatus::AuthUser);
            let resp = jade.auth_user(network)?;
            debug!("jade unlock result: {}", resp);
            ensure!(resp, "unlock failed");
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
    tx_type: jade_mng::TxType,
    nonces: Option<Vec<String>>,
}

impl<'a> HandlerParams<'a> {
    fn new() -> Self {
        HandlerParams {
            assets: None,
            tx_type: jade_mng::TxType::Normal,
            nonces: None,
        }
    }

    fn with_assets(mut self, assets: &'a BTreeMap<AssetId, Asset>) -> Self {
        self.assets = Some(assets);
        self
    }

    fn with_tx_type(mut self, tx_type: jade_mng::TxType) -> Self {
        self.tx_type = tx_type;
        self
    }

    fn with_blinding_nonces(mut self, nonces: Vec<String>) -> Self {
        self.nonces = Some(nonces);
        self
    }
}

unsafe fn run_auth_handler<T: serde::de::DeserializeOwned>(
    hw_data: Option<&HwData>,
    call: *mut gdk::GA_auth_handler,
    params: HandlerParams,
) -> Result<T, anyhow::Error> {
    run_auth_handler_impl(hw_data, call, params)
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

pub fn get_jade_asset_info(
    all_assets: &BTreeMap<AssetId, Asset>,
    required: BTreeSet<AssetId>,
) -> Vec<sideswap_jade::models::AssetInfo> {
    required
        .into_iter()
        .filter_map(|asset_id| {
            let asset = all_assets.get(&asset_id)?;
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
        })
        .collect()
}

pub fn get_jade_network(env: Env) -> JadeNetwork {
    match env.d().network {
        Network::Liquid => JadeNetwork::Liquid,
        Network::LiquidTestnet => JadeNetwork::TestnetLiquid,
    }
}

pub fn unblind(
    txout: &elements::TxOut,
    shared_secret: secp256k1::SecretKey,
) -> Result<elements::TxOutSecrets, elements::UnblindError> {
    let (commitment, additional_generator) = match (txout.value, txout.asset) {
        (
            elements::confidential::Value::Confidential(com),
            elements::confidential::Asset::Confidential(gen),
        ) => (com, gen),
        _ => return Err(elements::UnblindError::NotConfidential),
    };

    let rangeproof = txout
        .witness
        .rangeproof
        .as_ref()
        .ok_or(elements::UnblindError::MissingRangeproof)?;

    let (opening, _) = rangeproof.rewind(
        SECP256K1,
        commitment,
        shared_secret,
        txout.script_pubkey.as_bytes(),
        additional_generator,
    )?;

    let (asset, asset_bf) = opening.message.as_ref().split_at(32);
    let asset = AssetId::from_slice(asset)?;
    let asset_bf = sideswap_api::AssetBlindingFactor::from_slice(&asset_bf[..32])?;

    let value = opening.value;
    let value_bf = sideswap_api::ValueBlindingFactor::from_slice(opening.blinding_factor.as_ref())?;

    Ok(elements::TxOutSecrets {
        asset,
        asset_bf,
        value,
        value_bf,
    })
}

unsafe fn run_auth_handler_impl<T: serde::de::DeserializeOwned>(
    hw_data: Option<&HwData>,
    call: *mut gdk::GA_auth_handler,
    params: HandlerParams,
) -> Result<T, anyhow::Error> {
    // Destroy auth handler if function returns early
    let _auth_handler_owner = AuthHandlerOwner { call };

    let mut _jade_status = None;

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
            unlock_hw(hw_data.env, &hw_data.jade)?;
        }

        match required_data.action {
            gdk_json::HwAction::GetXpubs => {
                let paths = required_data.paths.unwrap();
                let mut xpubs = Vec::new();

                for path in paths {
                    let xpub = if let Some(xpub) = hw_data.xpubs.get(&path) {
                        *xpub
                    } else {
                        let network = get_jade_network(hw_data.env);
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

                let mut blinding_keys = Vec::new();
                for script in scripts.iter() {
                    let script = hex::decode(script).unwrap();
                    let resp = hw_data.jade.blinding_key(script)?;
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

                let mut nonces = Vec::new();
                let mut blinding_keys = Vec::new();
                for (script, public_key) in scripts.iter().zip(public_keys.iter()) {
                    let script = hex::decode(script).unwrap();
                    let their_pubkey = hex::decode(public_key).unwrap();
                    let resp = hw_data.jade.shared_nonce(script.clone(), their_pubkey)?;
                    nonces.push(hex::encode(&resp));

                    if blinding_keys_required {
                        let resp = hw_data.jade.blinding_key(script)?;
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
                _jade_status = Some(
                    hw_data
                        .jade
                        .start_status(JadeStatus::SignTx(params.tx_type)),
                );

                let transaction = required_data.transaction.unwrap();
                let tx = hex::decode(&transaction)?;
                let tx = elements::encode::deserialize::<elements::Transaction>(&tx)?;
                let transaction_inputs = required_data.transaction_inputs.unwrap();
                let transaction_outputs = required_data.transaction_outputs.unwrap();
                let use_ae_protocol = required_data.use_ae_protocol.unwrap_or_default();
                ensure!(use_ae_protocol);

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

                let mut trusted_commitments =
                    Vec::<Option<sideswap_jade::models::TrustedCommitment>>::new();
                let mut change = Vec::<Option<sideswap_jade::models::Output>>::new();

                for (index, (output, txout)) in
                    transaction_outputs.iter().zip(tx.output.iter()).enumerate()
                {
                    let commitment1 = if let Some(nonces) = params.nonces.as_ref() {
                        let nonce = &nonces[index];
                        if !nonce.is_empty() {
                            let blinding_key = secp256k1::SecretKey::from_str(nonce).unwrap();
                            let secret = unblind(txout, blinding_key).unwrap();
                            Some(sideswap_jade::models::TrustedCommitment {
                                asset_id: output.asset_id.into(),
                                value: output.satoshi,
                                asset_generator: txout.asset.commitment().unwrap().into(),
                                blinding_key: txout.nonce.commitment().unwrap().into(),
                                abf: secret.asset_bf,
                                vbf: secret.value_bf,
                                value_commitment: txout.value.commitment().unwrap().into(),
                            })
                        } else {
                            None
                        }
                    } else {
                        None
                    };
                    let commitment2 =
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

                            Some(sideswap_jade::models::TrustedCommitment {
                                asset_id: output.asset_id.into(),
                                value: output.satoshi,
                                asset_generator: asset_commitment.commitment().unwrap().into(),
                                blinding_key: output.blinding_key.clone().unwrap().into(),
                                abf: output.assetblinder.unwrap(),
                                vbf: output.amountblinder.unwrap(),
                                value_commitment: value_commitment.commitment().unwrap().into(),
                            })
                        } else {
                            None
                        };

                    trusted_commitments.push(commitment1.or(commitment2));

                    let change_output = if let Some(user_path) = output.user_path.as_ref() {
                        let variant = match output.address_type.unwrap() {
                            gdk_json::AddressType::P2shP2wpkh => {
                                Some(sideswap_jade::models::OutputVariant::P2wpkhP2sh)
                            }
                            gdk_json::AddressType::P2wsh => None,
                        };
                        Some(sideswap_jade::models::Output {
                            path: user_path.clone(),
                            recovery_xpub: None,
                            is_change: output.is_change.unwrap_or_default()
                                || output.is_internal.unwrap_or_default(),
                            variant,
                        })
                    } else {
                        None
                    };

                    change.push(change_output);
                }

                let network = get_jade_network(hw_data.env);

                let additional_info = match params.tx_type {
                    jade_mng::TxType::Normal | jade_mng::TxType::MakerUtxo => None,
                    jade_mng::TxType::Swap | jade_mng::TxType::OfflineSwap => {
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
                                    *input_sum.entry(output.asset_id).or_default() -=
                                        output.satoshi;
                                } else {
                                    *output_sum.entry(output.asset_id).or_default() +=
                                        output.satoshi;
                                }
                            }
                        }
                        ensure!(output_sum.len() == 1);
                        let _recv_asset = *output_sum.keys().next().unwrap();

                        let wallet_input_summary = input_sum
                            .into_iter()
                            .map(|(asset_id, amount)| {
                                sideswap_jade::models::AdditionalInfoSummary {
                                    asset_id: asset_id.into(),
                                    satoshi: amount,
                                }
                            })
                            .collect();

                        let wallet_output_summary = output_sum
                            .into_iter()
                            .map(|(asset_id, amount)| {
                                sideswap_jade::models::AdditionalInfoSummary {
                                    asset_id: asset_id.into(),
                                    satoshi: amount,
                                }
                            })
                            .collect();
                        // Should be true only for offline maker transactions
                        let is_partial =
                            transaction_inputs.len() == 1 && transaction_outputs.len() == 1;

                        Some(sideswap_jade::models::ReqSignTxAdditionalInfo {
                            is_partial,
                            tx_type: sideswap_jade::models::TxType::Swap,
                            wallet_input_summary,
                            wallet_output_summary,
                        })
                    }
                };

                let asset_info = params
                    .assets
                    .map(|all_assets| {
                        let asset_ids = transaction_inputs
                            .iter()
                            .map(|input| input.asset_id)
                            .chain(transaction_outputs.iter().map(|output| output.asset_id))
                            .collect::<BTreeSet<_>>();

                        get_jade_asset_info(all_assets, asset_ids)
                    })
                    .unwrap_or_default();

                let sign_tx = sideswap_jade::models::ReqSignTx {
                    network,
                    use_ae_signatures: true,
                    txn: ByteBuf::from(hex::decode(&transaction).unwrap()),
                    num_inputs: transaction_inputs.len() as u32,
                    trusted_commitments: trusted_commitments.clone(),
                    change,
                    asset_info,
                    additional_info,
                };

                let sign_tx_result = hw_data.jade.sign_tx(sign_tx)?;
                ensure!(sign_tx_result, "sign tx request failed");

                let mut signer_commitments = Vec::new();
                for input in transaction_inputs.iter() {
                    let req = if !input.skip_signing.unwrap_or_default() {
                        Some(sideswap_jade::models::ReqTxInput {
                            is_witness: true,
                            path: input.user_path.clone().unwrap().clone(),
                            script: ByteBuf::from(input.prevout_script.clone().unwrap().as_bytes()),
                            sighash: input.user_sighash,
                            asset_id: input.asset_id.into(),
                            value: input.satoshi,
                            abf: input.assetblinder.unwrap(),
                            vbf: input.amountblinder.unwrap(),
                            value_commitment: input
                                .commitment
                                .as_ref()
                                .unwrap()
                                .as_ref()
                                .commitment()
                                .unwrap(),
                            asset_generator: input
                                .asset_tag
                                .as_ref()
                                .unwrap()
                                .as_ref()
                                .commitment()
                                .unwrap(),
                            ae_host_commitment: input.ae_host_commitment.clone().unwrap(),
                            ae_host_entropy: input.ae_host_entropy.clone().unwrap(),
                        })
                    } else {
                        None
                    };
                    let resp = hw_data.jade.tx_input(req)?;
                    signer_commitments.push(hex::encode(&resp));
                }

                let mut signatures = Vec::new();
                for input in transaction_inputs.iter() {
                    let req = if !input.skip_signing.unwrap_or_default() {
                        Some(input.ae_host_entropy.unwrap())
                    } else {
                        None
                    };
                    let resp = hw_data.jade.get_signature(req)?;
                    signatures.push(resp.map(hex::encode));
                }

                let result = gdk_json::SignTx {
                    signatures,
                    signer_commitments,

                    asset_commitments: trusted_commitments
                        .iter()
                        .map(|v| v.as_ref().map(|v| v.asset_generator))
                        .collect(),
                    value_commitments: trusted_commitments
                        .iter()
                        .map(|v| v.as_ref().map(|v| v.value_commitment))
                        .collect(),
                    assetblinders: trusted_commitments
                        .iter()
                        .map(|v| v.as_ref().map(|v| v.abf))
                        .collect(),
                    amountblinders: trusted_commitments
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
                let ae_host_commitment = required_data.ae_host_commitment.unwrap();
                let ae_host_entropy = required_data.ae_host_entropy.unwrap();

                let signer_commitment =
                    hw_data
                        .jade
                        .sign_message(sideswap_jade::models::SignMessageReq {
                            path,
                            message,
                            ae_host_commitment,
                        })?;
                let signature = hw_data
                    .jade
                    .get_signature(Some(ae_host_entropy))?
                    .ok_or_else(|| anyhow!("empty signature"))?;

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

pub fn convert_tx(tx: &gdk_json::Transaction) -> models::Transaction {
    let created_at = tx.created_at_ts / 1000;
    let mut balances = std::collections::BTreeMap::<AssetId, i64>::new();
    for input in tx.inputs.iter() {
        if let (Some(asset_id), Some(amount)) = (input.asset_id, input.satoshi) {
            *balances.entry(asset_id).or_default() -= amount as i64
        }
    }
    for output in tx.outputs.iter() {
        if let (Some(asset_id), Some(amount)) = (output.asset_id, output.satoshi) {
            *balances.entry(asset_id).or_default() += amount as i64
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

    models::Transaction {
        txid: tx.txhash,
        network_fee: tx.fee,
        vsize: tx.transaction_vsize,
        memo: tx.memo.clone(),
        balances,
        created_at,
        block_height: tx.block_height,
        balances_all,
        max_pointer_external,
        max_pointer_internal,
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
) -> Result<gdk_json::UnspentOutputs, anyhow::Error> {
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
    let unspent_outputs = run_auth_handler::<gdk_json::UnspentOutputsRaw>(
        data.hw_data.as_ref(),
        call,
        HandlerParams::new(),
    )
    .map_err(|e| anyhow!("loading unspent outputs failed: {}", e))?;

    let utxos = unspent_outputs
        .unspent_outputs
        .into_iter()
        .filter(|(asset, _list)| asset != "error")
        .map(|(asset_id, list)| -> Result<_, anyhow::Error> {
            let asset_id = AssetId::from_str(&asset_id).map_err(|_err| {
                anyhow::anyhow!("loading unspent outputs failed, invalid asset id: {asset_id}")
            })?;
            let list = serde_json::from_value::<Vec<gdk_json::UnspentOutput>>(list)
                .map_err(|err| anyhow::anyhow!("parsing gdk_json::UnspentOutput failed: {err}"))?;
            Ok((asset_id, list))
        })
        .collect::<Result<BTreeMap<_, _>, _>>()?;

    Ok(gdk_json::UnspentOutputs {
        unspent_outputs: utxos,
    })
}

unsafe fn get_selected_utxos(
    unspent_outputs: std::collections::BTreeMap<AssetId, Vec<gdk_json::UnspentOutput>>,
    utxos: &[ffi::proto::OutPoint],
) -> Result<Vec<gdk_json::UnspentOutput>, anyhow::Error> {
    let selected_outpoints = utxos
        .iter()
        .map(|outpoint| -> Result<elements::OutPoint, anyhow::Error> {
            Ok(elements::OutPoint {
                txid: outpoint.txid.parse()?,
                vout: outpoint.vout,
            })
        })
        .collect::<Result<BTreeSet<_>, _>>()?;
    ensure!(selected_outpoints.len() == utxos.len());

    let mut inputs = Vec::new();
    for unspent_outputs in unspent_outputs.into_values() {
        for utxo in unspent_outputs.into_iter() {
            if selected_outpoints.contains(&elements::OutPoint {
                txid: utxo.txhash,
                vout: utxo.vout,
            }) {
                inputs.push(utxo);
            }
        }
    }
    ensure!(
        utxos.len() == inputs.len(),
        "Not all UTXOs found, please try again"
    );

    Ok(inputs)
}

struct TxSize {
    input_count: i32,
    output_count: i32,
    size: i64,
    vsize: i64,
    discount_vsize: i64,
    network_fee: i64,
    fee_per_byte: f64,
}

fn get_tx_size(
    mut tx: elements::Transaction,
    policy_asset: &AssetId,
    utxos: &[gdk_json::UnspentOutput],
) -> TxSize {
    let network_fee = tx.fee_in(*policy_asset);

    let tx_copy = tx.clone();
    let mut sighash_cache = elements::sighash::SighashCache::new(&tx_copy);

    let bytes_to_grind = 0; // Upper bound (because Jade can't grind)
    let secret_key = SecretKey::from_slice(&[0xcd; 32]).expect("must not fail");

    for (input_index, input) in tx.input.iter_mut().enumerate() {
        let utxo = utxos.iter().find(|utxo| {
            utxo.txhash == input.previous_output.txid && utxo.vout == input.previous_output.vout
        });

        if let Some(utxo) = utxo {
            let redeem_script = get_redeem_script(&utxo);
            input.script_sig = elements::script::Builder::new()
                .push_slice(redeem_script.as_bytes())
                .into_script();

            input.witness.script_witness = get_witness(
                &mut sighash_cache,
                utxo,
                input_index,
                elements::EcdsaSighashType::All,
                &secret_key,
                bytes_to_grind,
            );
        }
    }

    TxSize {
        input_count: tx.input.len() as i32,
        output_count: tx.output.len() as i32,
        size: tx.size() as i64,
        vsize: tx.vsize() as i64,
        discount_vsize: tx.discount_vsize() as i64,
        network_fee: network_fee as i64,
        fee_per_byte: network_fee as f64 / tx.discount_vsize() as f64,
    }
}

unsafe fn try_create_tx(
    data: &mut GdkSesImpl,
    cache: &mut CreatedTxCache,
    req: ffi::proto::CreateTx,
) -> Result<ffi::proto::CreatedTx, anyhow::Error> {
    let utxos = try_get_unspent_outputs(data)?.unspent_outputs;
    let utxos = if req.utxos.is_empty() {
        utxos
            .into_values()
            .flat_map(|utxos| utxos.into_iter())
            .collect::<Vec<_>>()
    } else {
        get_selected_utxos(utxos, &req.utxos)?
    };

    let deduct_fee = req.deduct_fee_output.map(|index| index as usize);
    if let Some(index) = deduct_fee {
        let addresse = req
            .addressees
            .get(index)
            .ok_or_else(|| anyhow!("invalid deduct_fee_output value: out of range"))?;
        let asset_id = AssetId::from_str(&addresse.asset_id)?;
        ensure!(
            asset_id == data.policy_asset,
            "can't deduct fee from the specified output because output asset is not L-BTC"
        );
    }

    let recipients = req
        .addressees
        .iter()
        .map(|addresse| -> Result<Recipient, anyhow::Error> {
            let asset_id = AssetId::from_str(&addresse.asset_id)?;
            let address = elements::Address::from_str(&addresse.address)?;
            let amount = u64::try_from(addresse.amount)?;
            Ok(Recipient {
                address,
                amount,
                asset_id,
            })
        })
        .collect::<Result<Vec<_>, _>>()?;
    ensure!(!recipients.is_empty());

    let send_tx::coin_select::normal_tx::Res {
        asset_inputs,
        bitcoin_inputs,
        user_outputs,
        change_outputs,
        fee_change,
        network_fee,
    } = send_tx::coin_select::normal_tx::try_coin_select(send_tx::coin_select::normal_tx::Args {
        multisig_wallet: !data.login_info.single_sig,
        policy_asset: data.policy_asset,
        use_all_utxos: !req.utxos.is_empty(),
        wallet_utxos: utxos
            .iter()
            .map(|utxo| InOut {
                asset_id: utxo.asset_id,
                value: utxo.satoshi,
            })
            .collect(),
        user_outputs: recipients
            .iter()
            .map(|recipient| InOut {
                asset_id: recipient.asset_id,
                value: recipient.amount,
            })
            .collect(),
        deduct_fee,
    })?;

    let used_utxos = take_utxos(utxos, asset_inputs.iter().chain(bitcoin_inputs.iter()));

    let mut outputs = Vec::new();
    for (output, recipient) in user_outputs.iter().zip(recipients.into_iter()) {
        // Use corrected amount if deduct_fee was set
        outputs.push(send_tx::pset::PsetOutput {
            asset_id: output.asset_id,
            amount: output.value,
            address: recipient.address,
        });
    }

    for output in change_outputs.iter().chain(fee_change.iter()) {
        let address = data.change_address()?;
        outputs.push(send_tx::pset::PsetOutput {
            asset_id: output.asset_id,
            amount: output.value,
            address,
        });
    }

    let inputs = used_utxos
        .iter()
        .map(|utxo| {
            let script_pub_key = utxo
                .script
                .clone()
                .unwrap_or_else(|| p2pkh_script(&utxo.public_key.unwrap()));

            send_tx::pset::PsetInput {
                txid: utxo.txhash,
                vout: utxo.vout,
                script_pub_key,
                asset_commitment: utxo.asset_tag.into_inner(),
                value_commitment: utxo.commitment.into_inner(),
                tx_out_sec: TxOutSecrets {
                    asset: utxo.asset_id,
                    asset_bf: utxo.assetblinder,
                    value: utxo.satoshi,
                    value_bf: utxo.amountblinder,
                },
            }
        })
        .collect::<Vec<_>>();

    let network_fee = network_fee.value;
    let send_tx::pset::ConstructedPset {
        blinded_pset: pset,
        blinded_outputs,
    } = send_tx::pset::construct_pset(send_tx::pset::ConstructPsetArgs {
        policy_asset: data.policy_asset,
        offlines: Vec::new(),
        inputs,
        outputs,
        network_fee,
    })?;

    let tx = pset.extract_tx()?;

    let id = tx.txid().to_string();

    let TxSize {
        input_count,
        output_count,
        size,
        vsize,
        discount_vsize,
        network_fee,
        fee_per_byte,
    } = get_tx_size(tx, &data.policy_asset, &used_utxos);

    cache.created_txs.insert(
        id.clone(),
        CreatedTx {
            pset,
            blinding_nonces: get_blinding_nonces(&blinded_outputs),
        },
    );

    let mut addressees = req.addressees.clone();
    assert!(addressees.len() == user_outputs.len());
    if let Some(index) = deduct_fee {
        addressees[index].amount = user_outputs[index].value as i64;
    }

    Ok(ffi::proto::CreatedTx {
        id,
        req,
        input_count,
        output_count,
        size,
        vsize,
        discount_vsize,
        network_fee,
        server_fee: None,
        fee_per_byte,
        addressees,
    })
}

unsafe fn try_create_payjoin(
    data: &mut GdkSesImpl,
    cache: &mut CreatedTxCache,
    req: ffi::proto::CreateTx,
    fee_asset: AssetId,
) -> Result<ffi::proto::CreatedTx, anyhow::Error> {
    let utxos = try_get_unspent_outputs(data)?.unspent_outputs;

    let all_utxos = if req.utxos.is_empty() {
        utxos
            .into_values()
            .flat_map(|utxos| utxos.into_iter())
            .collect::<Vec<_>>()
    } else {
        get_selected_utxos(utxos, &req.utxos)?
    };

    ensure!(all_utxos
        .iter()
        .all(|utxo| utxo.public_key.is_some() || utxo.script.is_some()));

    let utxos = all_utxos
        .iter()
        .map(|utxo| {
            let script_pub_key = utxo
                .script
                .clone()
                .unwrap_or_else(|| p2pkh_script(&utxo.public_key.unwrap()));
            sideswap_payjoin::Utxo {
                txid: utxo.txhash,
                vout: utxo.vout,
                script_pub_key,
                asset_id: utxo.asset_id,
                value: utxo.satoshi,
                asset_bf: utxo.assetblinder,
                value_bf: utxo.amountblinder,
            }
        })
        .collect::<Vec<_>>();

    let recipients = req
        .addressees
        .iter()
        .map(|addr| -> Result<Recipient, anyhow::Error> {
            Ok(Recipient {
                asset_id: AssetId::from_str(&addr.asset_id)?,
                amount: addr.amount.try_into()?,
                address: elements::Address::from_str(&addr.address)?,
            })
        })
        .collect::<Result<Vec<_>, _>>()?;
    ensure!(!recipients.is_empty());

    let deduct_fee = req.deduct_fee_output.map(|index| index as usize);
    if let Some(index) = deduct_fee {
        let recipient = recipients
            .get(index)
            .ok_or_else(|| anyhow!("no output with index {index}"))?;
        ensure!(
            recipient.asset_id == fee_asset,
            "can't deduct fee from the specified output"
        );
    }

    let resp = sideswap_payjoin::create_payjoin(
        data,
        sideswap_payjoin::CreatePayjoin {
            network: data.login_info.env.d().network,
            base_url: data.login_info.env.base_server_http_url(),
            user_agent: worker::USER_AGENT.to_owned(),
            utxos,
            multisig_wallet: !data.login_info.single_sig,
            use_all_utxos: !req.utxos.is_empty(),
            recipients,
            deduct_fee,
            fee_asset,
        },
    )?;

    let tx = resp.pset.extract_tx()?;

    let id = tx.txid().to_string();

    let TxSize {
        input_count,
        output_count,
        size,
        vsize,
        discount_vsize,
        network_fee,
        fee_per_byte,
    } = get_tx_size(tx, &data.policy_asset, &all_utxos);

    cache.created_txs.insert(
        id.clone(),
        CreatedTx {
            pset: resp.pset,
            blinding_nonces: resp.blinding_nonces,
        },
    );

    let mut addressees = req.addressees.clone();
    if let Some(index) = req.deduct_fee_output {
        addressees[index as usize].amount -= resp.asset_fee as i64;
    }

    Ok(ffi::proto::CreatedTx {
        id,
        req,
        input_count,
        output_count,
        size,
        vsize,
        discount_vsize,
        network_fee,
        server_fee: Some(resp.asset_fee as i64),
        fee_per_byte,
        addressees,
    })
}

impl sideswap_payjoin::Wallet for GdkSesImpl {
    fn change_address(&mut self) -> Result<elements::Address, anyhow::Error> {
        self.get_change_address().map(|info| info.address)
    }
}

unsafe fn try_send_tx(
    data: &mut GdkSesImpl,
    tx: &CreatedTx,
    assets: &BTreeMap<AssetId, Asset>,
) -> Result<elements::Txid, anyhow::Error> {
    let session = data.session;

    let utxos = try_get_unspent_outputs(data)?.unspent_outputs;
    let utxos = utxos
        .into_values()
        .flat_map(|utxos| utxos.into_iter())
        .collect();

    let pset = b64::encode(&elements::encode::serialize(&tx.pset));

    let sign_pset = gdk_json::SignPsetOpt {
        utxos,
        psbt: pset,
        blinding_nonces: tx.blinding_nonces.clone(),
        sign_with: Vec::new(),
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
        HandlerParams::new()
            .with_assets(assets)
            .with_blinding_nonces(tx.blinding_nonces.clone()),
    )
    .map_err(|e| anyhow!("signing pset failed: {}", e))?;
    let signed_pset = serde_json::from_value::<gdk_json::SignPsetResult>(signed_pset_json.clone())?;

    let pset_server = tx.pset.clone();
    let pset_client = elements::encode::deserialize::<elements::pset::PartiallySignedTransaction>(
        &b64::decode(&signed_pset.psbt)?,
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

unsafe fn broadcast_tx(data: &mut GdkSesImpl, tx: &str) -> Result<(), anyhow::Error> {
    let session = data.session;
    let broadcast_tx = gdk_json::BroadcastTxOpt {
        transaction: tx.to_owned(),
        memo: None,
        simulate_only: None,
    };
    let mut call = std::ptr::null_mut();
    let rc =
        gdk::GA_broadcast_transaction(session, GdkJson::new(&broadcast_tx).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_broadcast_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );

    let _broadcast_res = run_auth_handler::<gdk_json::BroadcastTxRes>(
        data.hw_data.as_ref(),
        call,
        HandlerParams::new(),
    )
    .map_err(|err| anyhow!("tx broadcast failed: {err}"))?;

    Ok(())
}

unsafe fn verify_and_sign_pset(
    data: &GdkSesImpl,
    amounts: &crate::swaps::Amounts,
    pset: &str,
    nonces: &[String],
    assets: &BTreeMap<AssetId, Asset>,
) -> Result<String, anyhow::Error> {
    let session = data.session;

    let unspent_outputs = try_get_unspent_outputs(data)?;

    let mut utxos = Vec::<gdk_json::UnspentOutput>::new();
    for (_asset_id, list) in unspent_outputs.unspent_outputs.iter() {
        utxos.extend(list.iter().cloned());
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

    sign_pset(
        data,
        &unspent_outputs,
        pset,
        nonces,
        assets,
        jade_mng::TxType::Swap,
        SignWith::User,
    )
}

unsafe fn sign_pset(
    data: &GdkSesImpl,
    utxos: &gdk_json::UnspentOutputs,
    pset: &str,
    nonces: &[String],
    assets: &BTreeMap<AssetId, Asset>,
    tx_type: jade_mng::TxType,
    sign_with: SignWith,
) -> Result<String, anyhow::Error> {
    let session = data.session;

    let utxos = utxos
        .unspent_outputs
        .values()
        .map(|utxo| utxo.iter())
        .flatten()
        .cloned()
        .collect::<Vec<_>>();

    let sign_pset = gdk_json::SignPsetOpt {
        utxos,
        psbt: pset.to_owned(),
        blinding_nonces: nonces.to_owned(),
        sign_with: sign_with.to_json(),
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
            .with_tx_type(tx_type),
    )
    .map_err(|e| anyhow!("signing pset failed: {}", e))?;

    Ok(signed_pset.psbt)
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

unsafe fn get_blinded_values(
    data: &GdkSesImpl,
    txid: &elements::Txid,
) -> Result<Vec<String>, anyhow::Error> {
    let transaction_list = load_transactions(data)?;
    let tx = transaction_list
        .iter()
        .find(|tx| tx.txhash == *txid)
        .ok_or_else(|| anyhow!("tx not found"))?;
    let mut result = Vec::new();
    for input in tx.inputs.iter() {
        if let (Some(value), Some(asset_id), Some(value_bf), Some(asset_bf)) = (
            input.satoshi,
            input.asset_id,
            input.amountblinder,
            input.assetblinder,
        ) {
            result.push(get_blinded_value(value, &asset_id, &value_bf, &asset_bf))
        }
    }
    for output in tx.outputs.iter() {
        if let (Some(value), Some(asset_id), Some(value_bf), Some(asset_bf)) = (
            output.satoshi,
            output.asset_id,
            output.amountblinder,
            output.assetblinder,
        ) {
            result.push(get_blinded_value(value, &asset_id, &value_bf, &asset_bf))
        }
    }
    Ok(result)
}

unsafe fn get_previous_addresses(
    data: &GdkSesImpl,
    last_pointer: Option<u32>,
    is_internal: bool,
) -> Result<gdk_json::PreviousAddresses, anyhow::Error> {
    let subaccount = data.get_subaccount()?;
    let session = data.session;

    let mut call = std::ptr::null_mut();
    debug!("load AMP addresses, last_pointer: {:?}", last_pointer);

    let is_internal = if data.login_info.single_sig {
        Some(is_internal)
    } else {
        ensure!(!is_internal);
        None
    };

    let previous_addresses = gdk_json::PreviousAddressesOpts {
        subaccount,
        last_pointer,
        is_internal,
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

    let (hw_device, login_user) = if data.subaccount.is_none() {
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

        (hw_device, login_user)
    } else {
        (
            gdk_json::HwDevice { device: None },
            gdk_json::LoginUser {
                mnemonic: None,
                username: None,
                password: None,
            },
        )
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

    let hw_data = data.login_info.wallet_info.hw_data();
    // NOTE: hw_data must not be set here, otherwise GA_register_user will fail!
    let hw_device = HwData::get_hw_device(None);
    let login_user = gdk_json::LoginUser {
        mnemonic: None,
        username: Some(username.to_owned()),
        password: Some(password.to_owned()),
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
    let network = match (info.env.d().network, info.single_sig) {
        (Network::Liquid, false) => "liquid",
        (Network::LiquidTestnet, false) => "testnet-liquid",
        (Network::Liquid, true) => "electrum-liquid",
        (Network::LiquidTestnet, true) => "electrum-testnet-liquid",
    };

    let custom_electrum = match &info.electrum_server {
        ElectrumServer::Blockstream => None,
        ElectrumServer::SideSwap => match info.env {
            Env::Prod | Env::LocalLiquid => Some(("electrs.sideswap.io", 12001, true)),
            Env::Testnet | Env::LocalTestnet => Some(("electrs.sideswap.io", 12002, true)),
        },
        ElectrumServer::SideSwapCn => match info.env {
            Env::Prod | Env::LocalLiquid => Some(("cn.sideswap.io", 12001, true)),
            Env::Testnet | Env::LocalTestnet => None,
        },
        ElectrumServer::Custom {
            host,
            port,
            use_tls,
        } => Some((host.as_str(), *port, *use_tls)),
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
) -> Result<Box<dyn gdk_ses::GdkSes + Send>, anyhow::Error> {
    debug!("start processing, single_sig: {}", info.single_sig);
    let datadir = info.cache_dir.to_owned();
    GDK_INITIALIZED.call_once(move || {
        let config = gdk_json::InitConfig {
            datadir,
            // log_level: Some("trace".to_owned()),
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
    let policy_asset = info.env.nd().policy_asset.asset_id();
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
) -> Result<Box<dyn gdk_ses::GdkSes + Send>, anyhow::Error> {
    unsafe { start_processing_impl(info, notif_callback) }
}

fn take_utxos<'a>(
    mut utxos: Vec<gdk_json::UnspentOutput>,
    required: impl Iterator<Item = &'a InOut>,
) -> Vec<gdk_json::UnspentOutput> {
    let mut selected = Vec::new();
    for required in required {
        let index = utxos
            .iter()
            .position(|utxo| utxo.asset_id == required.asset_id && utxo.satoshi == required.value)
            .expect("must exists");
        let utxo = utxos.remove(index);
        selected.push(utxo);
    }
    selected
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

pub fn get_witness(
    sighash_cache: &mut elements::sighash::SighashCache<&elements::Transaction>,
    utxo: &gdk_json::UnspentOutput,
    input_index: usize,
    sighash_type: EcdsaSighashType,
    priv_key: &SecretKey,
    bytes_to_grind: usize,
) -> Vec<Vec<u8>> {
    let value = utxo.commitment.into_inner();
    let sighash =
        sighash_cache.segwitv0_sighash(input_index, &utxo.prevout_script, value, sighash_type);
    let message =
        elements::secp256k1_zkp::Message::from_digest_slice(&sighash[..]).expect("must not fail");

    let signature = SECP256K1.sign_ecdsa_grind_r(&message, &priv_key, bytes_to_grind);
    let signature = elements_miniscript::elementssig_to_rawsig(&(signature, sighash_type));

    match utxo.address_type {
        gdk_json::AddressType::P2shP2wpkh => {
            let pub_key = priv_key.public_key(&SECP256K1);
            vec![signature, pub_key.serialize().to_vec()]
        }
        gdk_json::AddressType::P2wsh => {
            vec![
                vec![],
                GREEN_DUMMY_SIG.to_vec(),
                signature,
                utxo.prevout_script.to_bytes(),
            ]
        }
    }
}
