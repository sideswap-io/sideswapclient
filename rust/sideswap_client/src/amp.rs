use crate::ffi;
use crate::gdk;
use crate::gdk_json;
use crate::models;
use crate::worker;
use bitcoin::hashes::Hash;
use elements::encode::Encodable;
use serde_bytes::ByteBuf;
use sideswap_api::AssetId;
use sideswap_api::BlindingFactor;
use sideswap_api::PsetInput;
use sideswap_common::env::Env;
use sideswap_common::env::Network;
use sideswap_common::types::Amount;
use std::collections::BTreeMap;
use std::collections::HashMap;
use std::ffi::{CStr, CString};
use std::str::FromStr;

const SUBACCOUNT_NAME_AMP: &str = "AMP";
const SUBACCOUNT_TYPE_AMP: &str = "2of2_no_recovery";

pub struct Amp(std::sync::Arc<std::sync::Mutex<Data>>);

pub type PsetUtoxs = Vec<serde_json::Value>;

impl Amp {
    pub fn send(&self, to: To) {
        self.0.lock().unwrap().amp_sender.send(to).unwrap();
    }

    pub fn get_swap_inputs(
        &self,
        send_asset: &AssetId,
    ) -> Result<worker::SwapInputs, anyhow::Error> {
        unsafe { get_swap_inputs(&mut self.0.lock().unwrap(), send_asset) }
    }

    pub fn verify_pset(
        &self,
        amounts: &crate::swaps::Amounts,
        pset: &str,
        send_amp: bool,
        recv_amp: bool,
    ) -> Result<PsetUtoxs, anyhow::Error> {
        unsafe {
            verify_pset(
                &mut self.0.lock().unwrap(),
                amounts,
                pset,
                send_amp,
                recv_amp,
            )
        }
    }

    pub fn sign_pset(
        &self,
        pset: &str,
        nonces: &[String],
        utxos: PsetUtoxs,
    ) -> Result<String, anyhow::Error> {
        unsafe { sign_pset(&mut self.0.lock().unwrap(), pset, nonces, utxos) }
    }

    pub fn get_gaid(&self) -> Result<String, anyhow::Error> {
        try_get_gaid(&mut self.0.lock().unwrap())
    }

    pub fn get_balance(&self, asset: &AssetId) -> Amount {
        unsafe {
            let balances = get_balances(&mut self.0.lock().unwrap()).unwrap_or_default();
            let balance = balances.get(asset).cloned().unwrap_or_default();
            Amount::from_sat(balance as i64)
        }
    }

    pub fn get_blinded_values(&self, txid: &str) -> Result<Vec<String>, anyhow::Error> {
        unsafe { get_blinded_values(&mut self.0.lock().unwrap(), txid) }
    }

    pub fn make_pegout_payment(
        &self,
        send_amount: i64,
        peg_addr: &str,
    ) -> Result<worker::PegPayment, anyhow::Error> {
        unsafe { make_pegout_payment(&mut self.0.lock().unwrap(), send_amount, peg_addr) }
    }
}

#[derive(Clone)]
pub enum LoginWallet {
    Software(SoftwareWallet),
    Hardware(HardwareWallet),
}

#[derive(Clone)]
pub struct SoftwareWallet {
    pub mnemonic: String,
}

#[derive(Clone)]
pub struct HardwareWallet {
    pub wallet_name: String,
    pub device_port: sideswap_jade::Port,
}

impl LoginWallet {
    fn get_mnemonic(&self) -> Option<String> {
        match self {
            LoginWallet::Software(v) => Some(v.mnemonic.clone()),
            LoginWallet::Hardware(_) => None,
        }
    }

    fn get_hw_device(&self) -> gdk_json::HwDevice {
        let device = match self {
            LoginWallet::Software(_) => None,
            LoginWallet::Hardware(v) => Some(gdk_json::HwDeviceDetails {
                name: v.wallet_name.clone(),
                supports_ae_protocol: 1,
                supports_arbitrary_scripts: true,
                supports_host_unblinding: true,
                supports_liquid: 1,
                supports_low_r: true,
            }),
        };
        gdk_json::HwDevice { device }
    }
}

#[derive(Clone)]
pub struct LoginInfo {
    pub env: Env,
    pub wallet: LoginWallet,
}

pub enum To {
    Notification(gdk_json::Notification),
    JadeFatalError(anyhow::Error),

    Login(LoginInfo),
    Logout,
    AppState(bool),
    GetRecvAddr,
    CreateTx(ffi::proto::CreateTx),
    SendTx,
}

#[derive(Debug)]
pub enum From {
    Register(Result<String, String>),
    Balances(BTreeMap<AssetId, u64>),
    Transactions(Vec<models::Transaction>),
    RecvAddr(String),
    CreateTx(ffi::proto::from::CreateTxResult),
    SendTx(ffi::proto::from::SendResult),
    SentTx(sideswap_api::Txid),
    Error(String),
    ConnectionStatus(bool),
}

struct Wallet {
    session: Option<*mut gdk::GA_session>,
    account: gdk_json::Subaccount,
    signed_tx: Option<serde_json::Value>,
    login_info: LoginInfo,
    policy_asset: AssetId,
}

unsafe impl Send for Wallet {}

struct HwData {
    secp: elements::secp256k1_zkp::Secp256k1<elements::secp256k1_zkp::All>,
    jade: sideswap_jade::Jade,
    resp_receiver: std::sync::mpsc::Receiver<sideswap_jade::Resp>,
}

impl HwData {
    fn clear_queue(&self) {
        // TODO: Should we clear pending queue here?
        while let Ok(msg) = self.resp_receiver.try_recv() {
            warn!("unexpected Jade response ignored: {:?}", msg);
        }
    }
    fn get_resp_with_timeout(
        &self,
        time: std::time::Duration,
    ) -> Result<sideswap_jade::Resp, anyhow::Error> {
        self.resp_receiver
            .recv_timeout(time)
            .map_err(|_| anyhow!("Jade receive timeout"))
    }
    fn get_resp(&self) -> Result<sideswap_jade::Resp, anyhow::Error> {
        self.get_resp_with_timeout(std::time::Duration::from_secs(10))
    }
}

struct Data {
    amp_sender: crossbeam_channel::Sender<To>,
    worker: crossbeam_channel::Sender<worker::Message>,
    notif_context: *mut NotifContext,
    wallet: Option<Wallet>,
    hw_data: Option<HwData>,
    top_block: Option<u32>,
    pending_txs: bool,
}

unsafe impl Send for Data {}

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

    unsafe fn as_ptr(&self) -> *const gdk::GA_json {
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

unsafe fn run_auth_handler_impl<T: serde::de::DeserializeOwned>(
    hw_data: Option<&HwData>,
    call: *mut gdk::GA_auth_handler,
) -> Result<T, anyhow::Error> {
    // FIXME: Destroy auth handler if function returns early

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
        match required_data.action {
            gdk_json::HwAction::GetXpubs => {
                let paths = required_data.paths.unwrap();
                let mut xpubs = Vec::new();
                // TODO: Send requests in parallel
                for path in paths {
                    hw_data.clear_queue();
                    // FIXME: Use correct network
                    hw_data
                        .jade
                        .resolve_xpub(sideswap_jade::Network::TestnetLiquid, path);
                    let resp = hw_data.get_resp()?;
                    let resp = match resp {
                        sideswap_jade::Resp::ResolveXpub(v) => v,
                        _ => bail!("unexpected Jade response"),
                    }?;
                    xpubs.push(resp);
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
                    let script = hex::decode(&script).unwrap();
                    hw_data.jade.get_blinding_key(script);
                }

                let mut blinding_keys = Vec::new();
                for _ in scripts.iter() {
                    let resp = hw_data.get_resp()?;
                    let resp = match resp {
                        sideswap_jade::Resp::GetBlindingKey(v) => v,
                        _ => bail!("unexpected Jade response"),
                    }?;
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
                    let script = hex::decode(&script).unwrap();
                    let public_key = hex::decode(&public_key).unwrap();
                    hw_data.jade.get_shared_nonce(script.clone(), public_key);
                    if blinding_keys_required {
                        hw_data.jade.get_blinding_key(script);
                    }
                }

                let mut nonces = Vec::new();
                let mut blinding_keys = Vec::new();
                for _ in scripts.iter() {
                    let resp = hw_data.get_resp()?;
                    let resp = match resp {
                        sideswap_jade::Resp::GetSharedNonce(v) => v,
                        _ => bail!("unexpected Jade response"),
                    }?;
                    nonces.push(hex::encode(&resp));

                    if blinding_keys_required {
                        let resp = hw_data.get_resp()?;
                        let resp = match resp {
                            sideswap_jade::Resp::GetBlindingKey(v) => v,
                            _ => bail!("unexpected Jade response"),
                        }?;
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
                let transaction = required_data.transaction.unwrap();
                let signing_inputs = required_data.signing_inputs.unwrap();
                let transaction_outputs = required_data.transaction_outputs.unwrap();
                let use_ae_protocol = required_data.use_ae_protocol.unwrap_or_default();
                ensure!(use_ae_protocol);

                hw_data.clear_queue();

                let mut prevout_enc = elements::hashes::sha256d::Hash::engine();
                for input in signing_inputs.iter() {
                    let txid = elements::Txid::from_str(&input.txhash).unwrap();
                    let prevout = elements::OutPoint::new(txid, input.pt_idx);
                    prevout.consensus_encode(&mut prevout_enc).unwrap();
                }
                let hash_prevouts =
                    elements::hashes::sha256d::Hash::from_engine(prevout_enc).to_vec();

                let last_blinded_index = transaction_outputs
                    .iter()
                    .enumerate()
                    .rfind(|(_, output)| !output.is_fee)
                    .ok_or_else(|| anyhow!("can't find non-fee output"))?
                    .0;
                debug!(
                    "last blinded index: {}, output count: {}",
                    last_blinded_index,
                    transaction_outputs.len(),
                );

                #[derive(Debug)]
                struct Output {
                    value: u64,
                    abf: elements::confidential::AssetBlindingFactor,
                    vbf: elements::confidential::ValueBlindingFactor,
                }
                let mut outputs = Vec::<Output>::new();
                let mut commitments = Vec::<sideswap_jade::models::TrustedCommitment>::new();
                let mut change = Vec::<Option<sideswap_jade::models::Change>>::new();

                for (output_index, output) in transaction_outputs.iter().enumerate() {
                    if output.is_fee {
                        commitments.push(sideswap_jade::models::TrustedCommitment {
                            asset_id: None,
                            value: None,
                            asset_generator: None,
                            blinding_key: None,
                            abf: None,
                            vbf: None,
                            hmac: None,
                            value_commitment: None,
                        });
                        change.push(None);
                        continue;
                    }

                    let asset_id_rev = output.asset_id.0.iter().cloned().rev().collect::<Vec<_>>();
                    let public_key = hex::decode(output.public_key.as_ref().unwrap()).unwrap();

                    let vbf = if output_index == last_blinded_index {
                        hw_data.jade.get_blinding_factor(
                            hash_prevouts.clone(),
                            output_index as u32,
                            sideswap_jade::BlindingFactorType::Asset,
                        );

                        let resp = hw_data.get_resp()?;
                        let abf = match resp {
                            sideswap_jade::Resp::GetBlindingFactor(v) => v,
                            _ => bail!("unexpected Jade response"),
                        }?;
                        let abf =
                            elements::confidential::AssetBlindingFactor::from_slice(&abf).unwrap();

                        let inputs = signing_inputs
                            .iter()
                            .map(|v| {
                                (
                                    v.satoshi,
                                    elements::confidential::AssetBlindingFactor::from_slice(
                                        &v.assetblinder.unwrap().0,
                                    )
                                    .unwrap(),
                                    elements::confidential::ValueBlindingFactor::from_slice(
                                        &v.amountblinder.unwrap().0,
                                    )
                                    .unwrap(),
                                )
                            })
                            .collect::<Vec<_>>();

                        let mut outputs = outputs
                            .iter()
                            .map(|v| (v.value, v.abf.clone(), v.vbf.clone()))
                            .collect::<Vec<_>>();
                        outputs.push((
                            transaction.fee,
                            elements::confidential::AssetBlindingFactor::zero(),
                            elements::confidential::ValueBlindingFactor::zero(),
                        ));

                        let vbf = elements::confidential::ValueBlindingFactor::last(
                            &hw_data.secp,
                            output.satoshi,
                            abf,
                            &inputs,
                            &outputs,
                        );

                        Some(vbf.into_inner().as_ref().to_vec())
                    } else {
                        None
                    };

                    hw_data.jade.get_commitments(
                        asset_id_rev.clone(),
                        output.satoshi,
                        hash_prevouts.clone(),
                        output_index as u32,
                        vbf,
                    );

                    let resp = hw_data.get_resp()?;
                    let commitment = match resp {
                        sideswap_jade::Resp::GetCommitments(v) => v,
                        _ => bail!("unexpected Jade response"),
                    }?;

                    outputs.push(Output {
                        value: output.satoshi,
                        abf: elements::confidential::AssetBlindingFactor::from_slice(
                            &commitment.abf,
                        )?,
                        vbf: elements::confidential::ValueBlindingFactor::from_slice(
                            &commitment.vbf,
                        )?,
                    });

                    commitments.push(sideswap_jade::models::TrustedCommitment {
                        asset_id: Some(ByteBuf::from(asset_id_rev)),
                        value: Some(output.satoshi),
                        asset_generator: Some(commitment.asset_generator.clone()),
                        blinding_key: Some(ByteBuf::from(public_key)),
                        abf: Some(commitment.abf.clone()),
                        vbf: Some(commitment.vbf.clone()),
                        hmac: Some(commitment.hmac.clone()),
                        value_commitment: Some(commitment.value_commitment.clone()),
                    });

                    if output.is_change {
                        change.push(Some(sideswap_jade::models::Change {
                            csv_blocks: 0,
                            path: output.user_path.clone().unwrap(),
                            recovery_xpub: None,
                        }));
                    } else {
                        change.push(None);
                    }
                }

                debug!("blinding succeed: {:?}", &outputs);

                let sign_tx = sideswap_jade::models::ReqSignTx {
                    network: sideswap_jade::Network::TestnetLiquid.name().to_owned(),
                    use_ae_signatures: true,
                    txn: ByteBuf::from(hex::decode(&transaction.transaction).unwrap()),
                    num_inputs: signing_inputs.len() as u32,
                    trusted_commitments: commitments.clone(),
                    change,
                };

                hw_data.jade.sign_tx(sign_tx);
                // TODO: Decide how much we should wait here
                let resp = hw_data.get_resp_with_timeout(std::time::Duration::from_secs(120))?;
                let sign_tx_result = match resp {
                    sideswap_jade::Resp::SignTx(v) => v,
                    _ => bail!("unexpected Jade response"),
                }?;
                ensure!(sign_tx_result, "sign tx request failed");

                let mut signatures = Vec::new();
                let mut signer_commitments = Vec::new();
                for input in signing_inputs.iter() {
                    hw_data.jade.tx_input(sideswap_jade::models::ReqTxInput {
                        is_witness: true,
                        path: input.user_path.clone(),
                        script: ByteBuf::from(hex::decode(&input.prevout_script).unwrap()),
                        value_commitment: ByteBuf::from(hex::decode(&input.commitment).unwrap()),
                        ae_host_commitment: ByteBuf::from(
                            hex::decode(&input.ae_host_commitment).unwrap(),
                        ),
                    });
                    let resp = hw_data.get_resp()?;
                    let tx_input = match resp {
                        sideswap_jade::Resp::TxInput(v) => v,
                        _ => bail!("unexpected Jade response"),
                    }?;
                    signer_commitments.push(hex::encode(&tx_input));

                    hw_data
                        .jade
                        .get_signature(hex::decode(&input.ae_host_entropy).unwrap());
                    let resp = hw_data.get_resp()?;
                    let signature = match resp {
                        sideswap_jade::Resp::GetSignature(v) => v,
                        _ => bail!("unexpected Jade response"),
                    }?;
                    signatures.push(hex::encode(&signature));
                }

                use std::convert::TryInto;
                let result = gdk_json::SignTx {
                    signatures,
                    signer_commitments,

                    asset_commitments: commitments
                        .iter()
                        .map(|v| v.asset_generator.as_ref().map(|v| hex::encode(v)))
                        .collect(),
                    value_commitments: commitments
                        .iter()
                        .map(|v| v.value_commitment.as_ref().map(|v| hex::encode(v)))
                        .collect(),
                    assetblinders: commitments
                        .iter()
                        .map(|v| {
                            v.abf
                                .as_ref()
                                .map(|v| sideswap_api::Hash32(v.as_slice().try_into().unwrap()))
                        })
                        .collect(),
                    amountblinders: commitments
                        .iter()
                        .map(|v| {
                            v.vbf
                                .as_ref()
                                .map(|v| sideswap_api::Hash32(v.as_slice().try_into().unwrap()))
                        })
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
                let ae_host_entropy = hex::decode(required_data.ae_host_entropy.unwrap()).unwrap();

                hw_data.clear_queue();

                hw_data.jade.sign_message(path, message, ae_host_commitment);
                let resp = hw_data.get_resp()?;
                let signer_commitment = match resp {
                    sideswap_jade::Resp::SignMessage(v) => v,
                    _ => bail!("unexpected Jade response"),
                }?;

                hw_data.jade.get_signature(ae_host_entropy);
                let resp = hw_data.get_resp()?;
                let signature = match resp {
                    sideswap_jade::Resp::GetSignature(v) => v,
                    _ => bail!("unexpected Jade response"),
                }?;

                // Convert signature into DER format
                let signature = match signature.len() {
                    64 => signature.as_slice(),
                    65 => &signature[1..],
                    _ => bail!("unexpected signature size: {}", signature.len()),
                };
                let signature = secp256k1::Signature::from_compact(&signature)?
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
                bail!("GetMasterBlindingKey not implemented")
            }
        };
    };

    let rc = gdk::GA_destroy_auth_handler(call);
    assert!(rc == 0);

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

struct NotifContext(crossbeam_channel::Sender<To>);

unsafe extern "C" fn notification_handler(
    context: *mut std::os::raw::c_void,
    details: *mut gdk::GA_json,
) {
    let context = &*(context as *const NotifContext);
    let mut details = GdkJson::owned(details);
    debug!("amp notification: {}", details.to_str());
    let details = details.to_json::<gdk_json::Notification>();
    match details {
        Ok(v) => {
            let _ = context.0.send(To::Notification(v));
        }
        Err(e) => warn!("notification parsing fails: {}", e),
    }
}

fn last_gdk_error_details() -> Result<String, anyhow::Error> {
    let mut json = std::ptr::null_mut();
    let rc = unsafe { gdk::GA_get_thread_error_details(&mut json) };
    ensure!(rc == 0, "GA_get_thread_error_details failed");
    let mut json = unsafe { GdkJson::owned(json) };
    let json = json.to_json::<gdk_json::ErrorDetailsResult>()?;
    Ok(json.details)
}

fn send_from(data: &Data, from: From) {
    let result = data.worker.send(worker::Message::Amp(from));
    if let Err(e) = result {
        warn!("sending failed: {}", e);
    }
}

fn convert_tx(tx: &gdk_json::Transaction, top_block: u32) -> models::Transaction {
    let created_at = tx.created_at_ts as i64 / 1000;
    let mut balances = std::collections::BTreeMap::<AssetId, i64>::new();
    for input in tx.inputs.iter() {
        match (input.asset_id, input.satoshi) {
            (Some(asset_id), Some(amount)) => {
                *balances.entry(asset_id.clone()).or_default() -= amount as i64
            }
            _ => {}
        }
    }
    for output in tx.outputs.iter() {
        match (output.asset_id, output.satoshi) {
            (Some(asset_id), Some(amount)) => {
                *balances.entry(asset_id.clone()).or_default() += amount as i64
            }
            _ => {}
        }
    }
    let balances = balances
        .iter()
        .map(|(asset_id, balance)| models::Balance {
            asset: asset_id.clone(),
            value: *balance,
        })
        .collect::<Vec<_>>();
    let count = if tx.block_height == 0 || tx.block_height > top_block {
        0
    } else {
        top_block - tx.block_height + 1
    };
    let pending_confs = if count < worker::TX_CONF_COUNT {
        Some(count as u8)
    } else {
        None
    };

    let tx = models::Transaction {
        txid: tx.txhash.clone(),
        network_fee: tx.fee,
        memo: tx.memo.clone(),
        balances,
        created_at,
        pending_confs,
        size: tx.transaction_size,
        vsize: tx.transaction_vsize,
    };
    tx
}

unsafe fn notification(data: &mut Data, msg: gdk_json::Notification) {
    if let Some(block) = msg.block {
        let top_block_unknown = data.top_block.is_none();
        data.top_block = Some(block.block_height);
        if data.pending_txs || top_block_unknown {
            update_tx_and_balances(data);
        }
    }

    if let Some(_transaction) = msg.transaction {
        update_tx_and_balances(data);
    }

    if let Some(network) = msg.network {
        // if network.current_state && network.login_required.unwrap_or(false) {
        //     info!("try reconnect AMP account");
        //     app_state(data, false);
        //     app_state(data, true);
        //     // info!("try reconnect AMP account");
        //     // if let Some(wallet) = data.wallet.as_mut() {
        //     //     if let Some(session) = wallet.session {
        //     //         let login_result = try_login(session, &wallet.mnemonic);
        //     //         if let Err(e) = login_result {
        //     //             warn!("AMP account reconnect failed: {}", e);
        //     //             send_from(data, From::Error(format!("reconnect failed: {}", e)));
        //     //         } else {
        //     //             info!("AMP account reconnect succeed");
        //     //             send_from(data, From::ConnectionStatus(true));
        //     //             update_tx_and_balances(data);
        //     //         }
        //     //     }
        //     // }
        // }
        if network.current_state == gdk_json::ConnectionState::Disconnected {
            send_from(data, From::ConnectionStatus(false));
        }
    }
}

unsafe fn jade_fatal_error(data: &mut Data, error: anyhow::Error) {
    if let Some(_) = data.wallet.as_ref() {
        send_from(data, From::Error(format!("Jade error: {}", error)));
    }
}

unsafe fn try_login(
    session: *mut gdk::GA_session,
    info: &LoginInfo,
    hw_data: Option<&HwData>,
) -> Result<(), anyhow::Error> {
    let mnemonic = info.wallet.get_mnemonic();
    let hw_device = info.wallet.get_hw_device();
    let login_user = gdk_json::LoginUser {
        mnemonic: mnemonic.clone(),
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
    let login = run_auth_handler_impl::<gdk_json::LoginUserResult>(hw_data, call)
        .map_err(|e| anyhow!("login failed: {}", e))?;
    debug!("wallet_hash_id: {:?}", login.wallet_hash_id);
    Ok(())
}

unsafe fn try_connect(
    session: *mut gdk::GA_session,
    notif_context: *mut NotifContext,
    login_info: &LoginInfo,
    hw_data: Option<&HwData>,
) -> Result<Wallet, anyhow::Error> {
    let rc = gdk::GA_set_notification_handler(
        session,
        Some(notification_handler),
        notif_context as *mut libc::c_void,
    );
    assert!(rc == 0);

    let network = match login_info.env.data().network {
        Network::Mainnet => "liquid",
        Network::Testnet => "testnet-liquid",
        Network::Regtest | Network::Local => {
            bail!("unsupported env")
        }
    };
    let policy_asset = AssetId::from_str(login_info.env.data().policy_asset).unwrap();
    let connect_config = gdk_json::ConnectConfig {
        name: network.to_owned(),
        log_level: Some("info".to_owned()),
    };
    let rc = gdk::GA_connect(session, GdkJson::new(&connect_config).as_ptr());
    ensure!(
        rc == 0,
        "connection failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );

    let mut call = std::ptr::null_mut();
    let mnemonic = login_info.wallet.get_mnemonic().unwrap_or_default();
    let mnemonic = CString::new(mnemonic.clone()).unwrap();
    let hw_device = login_info.wallet.get_hw_device();
    let rc = gdk::GA_register_user(
        session,
        GdkJson::new(&hw_device).as_ptr(),
        mnemonic.as_ptr(),
        &mut call,
    );
    ensure!(
        rc == 0,
        "GA_register_user failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let register_result = run_auth_handler_impl::<serde_json::Value>(hw_data, call)
        .map_err(|e| anyhow!("registration failed: {}", e))?;
    debug!("registration result: {}", register_result);

    try_login(session, &login_info, hw_data)?;

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
    let subaccounts = run_auth_handler_impl::<gdk_json::GetSubaccountsResult>(hw_data, call)
        .map_err(|e| anyhow!("loading subaccounts failed: {}", e))?;

    let account = subaccounts
        .subaccounts
        .into_iter()
        .find(|account| account.type_ == SUBACCOUNT_TYPE_AMP)
        .ok_or_else(|| anyhow!("no account found"))
        .or_else(|_| {
            let mut call = std::ptr::null_mut();
            let new_subaccount = gdk_json::CreateSubaccount {
                name: SUBACCOUNT_NAME_AMP.to_owned(),
                type_: SUBACCOUNT_TYPE_AMP.to_owned(),
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
                run_auth_handler_impl::<gdk_json::Subaccount>(hw_data, call)
                    .map_err(|e| anyhow!("creating AMP subaccount failed: {}", e))?;
            Ok(created_subaccount)
        })?;

    let wallet = Wallet {
        session: Some(session),
        account,
        signed_tx: None,
        login_info: login_info.clone(),
        policy_asset,
    };

    Ok(wallet)
}

unsafe fn login(data: &mut Data, login_info: LoginInfo) {
    logout(data);

    let mut session = std::ptr::null_mut();
    let rc = gdk::GA_create_session(&mut session);
    assert!(rc == 0);

    if let LoginWallet::Hardware(details) = &login_info.wallet {
        let amp_sender_copy = data.amp_sender.clone();
        let (resp_sender, resp_receiver) = std::sync::mpsc::channel();
        let callback = move |msg| {
            match msg {
                sideswap_jade::Resp::FatalError(e) => {
                    // TODO: Unblock blocked receiver sending some arbitrary response:
                    // let _ = resp_sender.send(SomeRandomResponse);
                    let _ = amp_sender_copy.send(To::JadeFatalError(e));
                }
                _ => {
                    let _ = resp_sender.send(msg);
                }
            };
        };
        let jade_result = sideswap_jade::Jade::new(details.device_port.clone(), callback);
        match jade_result {
            Ok(jade) => {
                data.hw_data = Some(HwData {
                    secp: elements::secp256k1_zkp::Secp256k1::new(),
                    jade,
                    resp_receiver,
                })
            }
            Err(e) => {
                send_from(
                    data,
                    From::Register(Err(format!("Jade open failed: {}", e))),
                );
                return;
            }
        };
    }

    let login_result = try_connect(
        session,
        data.notif_context,
        &login_info,
        data.hw_data.as_ref(),
    );
    match login_result {
        Ok(wallet) => {
            send_from(
                data,
                From::Register(Ok(wallet.account.receiving_id.clone())),
            );
            data.wallet = Some(wallet);
            send_from(data, From::ConnectionStatus(true));
            update_tx_and_balances(data);
        }

        Err(e) => {
            send_from(data, From::ConnectionStatus(false));
            let rc = gdk::GA_destroy_session(session);
            assert!(rc == 0);

            send_from(
                data,
                From::Register(Err(format!("AMP register error: {}", e))),
            );
        }
    }
}

unsafe fn logout(data: &mut Data) {
    if let Some(wallet) = data.wallet.as_mut() {
        if let Some(session) = wallet.session.clone() {
            send_from(data, From::ConnectionStatus(false));
            let rc = gdk::GA_destroy_session(session);
            assert!(rc == 0);
        }
        data.wallet = None;
        data.hw_data = None;
    }
}

unsafe fn app_state(data: &mut Data, active: bool) {
    if let Some(wallet) = data.wallet.as_ref() {
        match (wallet.session.clone(), active) {
            (Some(session), false) => {
                send_from(data, From::ConnectionStatus(false));

                debug!("destroy GDK session because app is not active");
                let rc = gdk::GA_destroy_session(session);
                assert!(rc == 0);
                data.wallet.as_mut().unwrap().session = None;
            }
            (None, true) => {
                debug!("create GDK session because app is active");
                let mut connection_index = 0;
                loop {
                    let mut session = std::ptr::null_mut();
                    let rc = gdk::GA_create_session(&mut session);
                    assert!(rc == 0);

                    let login_result = try_connect(
                        session,
                        data.notif_context,
                        &wallet.login_info,
                        data.hw_data.as_ref(),
                    );

                    match login_result {
                        Ok(wallet) => {
                            debug!("recreating GDK session succeed");
                            data.wallet = Some(wallet);
                            send_from(data, From::ConnectionStatus(true));
                            update_tx_and_balances(data);
                            break;
                        }

                        Err(e) => {
                            error!("recreating GDK session failed");
                            let rc = gdk::GA_destroy_session(session);
                            assert!(rc == 0);
                            if connection_index == 2 {
                                send_from(data, From::Error(format!("AMP login error: {}", e)));
                                break;
                            }
                        }
                    }
                    connection_index += 1;
                }
            }
            _ => {}
        }
    }
}

unsafe fn load_transactions(data: &mut Data) -> Result<Vec<gdk_json::Transaction>, anyhow::Error> {
    let wallet = data.wallet.as_ref().ok_or_else(|| anyhow!("no wallet"))?;
    let session = wallet
        .session
        .clone()
        .ok_or_else(|| anyhow!("no session"))?;

    let mut result = HashMap::new();
    let mut first = 0;
    // Looks like 900 is max tx count that could be loaded at once
    let count = 900;
    let mut load_more = true;
    while load_more {
        let list_transactions = gdk_json::ListTransactions {
            subaccount: wallet.account.pointer,
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
        let transaction_list =
            run_auth_handler_impl::<gdk_json::TransactionList>(data.hw_data.as_ref(), call)?;
        load_more = transaction_list.transactions.len() as i32 == count;
        first += transaction_list.transactions.len() as i32;
        for tx in transaction_list.transactions.into_iter() {
            result.insert(tx.txhash.clone(), tx);
        }
    }
    Ok(result.into_values().collect())
}

unsafe fn try_update_tx_list(data: &mut Data) -> Result<(), anyhow::Error> {
    ensure!(data.top_block.is_some());
    let transaction_list = load_transactions(data)?;
    let top_block = data.top_block.unwrap();
    let mut items = Vec::new();
    let mut pending_txs = false;
    for tx in transaction_list {
        let converted_tx = convert_tx(&tx, top_block);
        pending_txs |= converted_tx.pending_confs.is_some();
        items.push(converted_tx);
    }
    if !items.is_empty() {
        send_from(data, From::Transactions(items));
    }
    data.pending_txs = pending_txs;

    Ok(())
}

unsafe fn update_tx_and_balances(data: &mut Data) {
    let update_tx_list_result = try_update_tx_list(data);
    if let Err(e) = update_tx_list_result {
        error!("updating AMP tx list failed: {}", e);
    }

    let balances = get_balances(data);
    match balances {
        Ok(balances) => {
            send_from(data, From::Balances(balances));
        }
        Err(e) => error!("updating AMP balances failed: {}", e),
    }
}

fn try_get_gaid(data: &mut Data) -> Result<String, anyhow::Error> {
    let wallet = data
        .wallet
        .as_ref()
        .ok_or_else(|| anyhow!("no AMP wallet"))?;
    Ok(wallet.account.receiving_id.clone())
}

unsafe fn try_get_recv_addr(data: &mut Data) -> Result<String, anyhow::Error> {
    let wallet = data
        .wallet
        .as_mut()
        .ok_or_else(|| anyhow!("no AMP wallet"))?;
    let session = wallet
        .session
        .clone()
        .ok_or_else(|| anyhow!("no session"))?;

    let get_addr = gdk_json::RecvAddrOpt {
        subaccount: wallet.account.pointer,
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_get_receive_address(session, GdkJson::new(&get_addr).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_get_receive_address failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let recv_addr = run_auth_handler_impl::<gdk_json::RecvAddrResult>(data.hw_data.as_ref(), call)
        .map_err(|e| anyhow!("receiving new address failed: {}", e))?;
    debug!("recv addr: {:?}", &recv_addr);
    Ok(recv_addr.address)
}

unsafe fn get_recv_addr(data: &mut Data) {
    let recv_addr_result = try_get_recv_addr(data);
    match recv_addr_result {
        Ok(addr) => {
            send_from(data, From::RecvAddr(addr));
        }
        Err(e) => {
            send_from(data, From::Error(format!("failed: {}", e)));
        }
    }
}

unsafe fn try_create_tx(
    data: &mut Data,
    tx: ffi::proto::CreateTx,
) -> Result<ffi::proto::CreatedTx, anyhow::Error> {
    let wallet = data
        .wallet
        .as_mut()
        .ok_or_else(|| anyhow!("no AMP wallet"))?;
    let session = wallet
        .session
        .clone()
        .ok_or_else(|| anyhow!("no session"))?;
    let send_asset = AssetId::from_str(&tx.balance.asset_id).unwrap();

    let mut call = std::ptr::null_mut();
    let unspent_outputs = gdk_json::UnspentOutputsArgs {
        subaccount: wallet.account.pointer,
        num_confs: 0,
    };
    let rc =
        gdk::GA_get_unspent_outputs(session, GdkJson::new(&unspent_outputs).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_get_unspent_outputs failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let unspent_outputs_json =
        run_auth_handler_impl::<gdk_json::UnspentOutputsJsonResult>(data.hw_data.as_ref(), call)
            .map_err(|e| anyhow!("loading unspent outputs failed: {}", e))?;
    let mut unspent_outputs = serde_json::from_value::<gdk_json::UnspentOutputs>(
        unspent_outputs_json.unspent_outputs.clone(),
    )
    .map_err(|e| anyhow!("parsing unspent outputs failed: {}", e))?;

    let bitcoin_balance = unspent_outputs
        .get(&wallet.policy_asset)
        .map(|inputs| inputs.iter().map(|input| input.satoshi).sum::<u64>())
        .unwrap_or_default();
    let inputs = unspent_outputs.remove(&send_asset).unwrap_or_default();
    let total = inputs.iter().map(|input| input.satoshi).sum::<u64>() as i64;
    ensure!(tx.balance.amount <= total, "Insufficient funds");
    ensure!(
        bitcoin_balance > 0,
        "Insufficient L-BTC AMP to pay network fee"
    );
    let send_all = tx.balance.amount == total;

    let tx_addressee = gdk_json::TxAddressee {
        address: tx.addr.clone(),
        satoshi: tx.balance.amount as u64,
        asset_id: send_asset,
    };
    let create_tx = gdk_json::CreateTransactionOpt {
        subaccount: wallet.account.pointer,
        addressees: vec![tx_addressee],
        utxos: unspent_outputs_json.unspent_outputs,
        send_all,
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_create_transaction(session, GdkJson::new(&create_tx).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_create_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let created_tx_json = run_auth_handler_impl::<serde_json::Value>(data.hw_data.as_ref(), call)
        .map_err(|e| anyhow!("creating transaction failed: {}", e))?;
    let created_tx =
        serde_json::from_value::<gdk_json::CreateTransactionResult>(created_tx_json.clone())
            .map_err(|e| anyhow!("parsing created transaction JSON failed: {}", e))?;
    debug!("created tx: {:?}", &created_tx);
    ensure!(created_tx.fee > 0, "network fee is 0");

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_sign_transaction(session, GdkJson::new(&created_tx_json).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_sign_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let signed_tx_json = run_auth_handler_impl::<serde_json::Value>(data.hw_data.as_ref(), call)
        .map_err(|e| anyhow!("signing tx failed: {}", e))?;
    let signed_tx =
        serde_json::from_value::<gdk_json::SignTransactionResult>(signed_tx_json.clone())
            .map_err(|e| anyhow!("parsing signed transaction JSON failed: {}", e))?;
    debug!("created tx: {:?}", &created_tx);

    ensure!(signed_tx
        .transaction_outputs
        .iter()
        .all(|v| v.address.is_none() == v.is_fee));
    let addressees = signed_tx
        .transaction_outputs
        .iter()
        .filter(|v| !v.is_change && !v.is_fee)
        .map(|v| gdk_common::model::AddressAmount {
            address: v.address.as_ref().unwrap().clone(),
            satoshi: v.satoshi,
            asset_id: Some(v.asset_id.clone()),
        })
        .collect::<Vec<_>>();
    let result = worker::get_created_tx(&tx, &signed_tx.transaction, &addressees)?;

    wallet.signed_tx = Some(signed_tx_json);

    Ok(result)
}

unsafe fn create_tx(data: &mut Data, tx: ffi::proto::CreateTx) {
    let create_tx_result = try_create_tx(data, tx);

    let result = match create_tx_result {
        Ok(tx) => ffi::proto::from::create_tx_result::Result::CreatedTx(tx),
        Err(e) => ffi::proto::from::create_tx_result::Result::ErrorMsg(e.to_string()),
    };
    let create_result = ffi::proto::from::CreateTxResult {
        result: Some(result),
    };

    send_from(data, From::CreateTx(create_result));
}

unsafe fn try_send_tx(data: &mut Data) -> Result<(), anyhow::Error> {
    let wallet = data
        .wallet
        .as_mut()
        .ok_or_else(|| anyhow!("no AMP wallet"))?;
    let signed_tx = wallet
        .signed_tx
        .take()
        .ok_or_else(|| anyhow!("signed transaction not found"))?;
    let session = wallet
        .session
        .clone()
        .ok_or_else(|| anyhow!("no session"))?;

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_send_transaction(session, GdkJson::new(&signed_tx).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_send_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let send_result =
        run_auth_handler_impl::<gdk_json::SendTransactionResult>(data.hw_data.as_ref(), call)
            .map_err(|e| anyhow!("sending tx failed: {}", e))?;
    info!("send succeed, waiting for txhash: {}", &send_result.txhash);

    send_from(data, From::SentTx(send_result.txhash));

    Ok(())
}

unsafe fn send_tx(data: &mut Data) {
    let send_result = try_send_tx(data);
    if let Err(e) = send_result {
        let send_result = ffi::proto::from::SendResult {
            result: Some(ffi::proto::from::send_result::Result::ErrorMsg(
                e.to_string(),
            )),
        };
        send_from(data, From::SendTx(send_result));
    }
}

unsafe fn get_swap_inputs(
    data: &mut Data,
    send_asset: &AssetId,
) -> Result<worker::SwapInputs, anyhow::Error> {
    let change_addr = try_get_recv_addr(data)?;

    let wallet = data
        .wallet
        .as_mut()
        .ok_or_else(|| anyhow!("no AMP wallet"))?;
    let session = wallet
        .session
        .clone()
        .ok_or_else(|| anyhow!("no session"))?;

    let mut config = std::ptr::null_mut();
    let rc = gdk::GA_get_twofactor_config(session, &mut config);
    ensure!(
        rc == 0,
        "GA_get_twofactor_config failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let mut config = GdkJson::owned(config);
    let config = config.to_json::<gdk_json::TwoFactorConfig>()?;
    ensure!(
        !config.any_enabled,
        "Two-Factor authentication not supported"
    );

    let mut call = std::ptr::null_mut();
    let unspent_outputs = gdk_json::UnspentOutputsArgs {
        subaccount: wallet.account.pointer,
        num_confs: 0,
    };
    let rc =
        gdk::GA_get_unspent_outputs(session, GdkJson::new(&unspent_outputs).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_get_unspent_outputs failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let mut unspent_outputs =
        run_auth_handler_impl::<gdk_json::UnspentOutputsParsedResult>(data.hw_data.as_ref(), call)
            .map_err(|e| anyhow!("loading unspent outputs failed: {}", e))?;
    let inputs = unspent_outputs
        .unspent_outputs
        .remove(send_asset)
        .unwrap_or_default()
        .into_iter()
        .map(|utxo| PsetInput {
            txid: utxo.txhash,
            vout: utxo.pt_idx,
            asset: utxo.asset_id,
            asset_bf: utxo.assetblinder.unwrap(),
            value: utxo.satoshi,
            value_bf: utxo.amountblinder.unwrap(),
            // No need to set redeem_script for AMP asset inputs
            redeem_script: None,
        })
        .collect();

    Ok(worker::SwapInputs {
        inputs,
        change_addr,
    })
}

unsafe fn verify_pset(
    data: &mut Data,
    amounts: &crate::swaps::Amounts,
    pset: &str,
    send_amp: bool,
    recv_amp: bool,
) -> Result<PsetUtoxs, anyhow::Error> {
    let wallet = data
        .wallet
        .as_mut()
        .ok_or_else(|| anyhow!("no AMP wallet"))?;
    let session = wallet
        .session
        .clone()
        .ok_or_else(|| anyhow!("no session"))?;
    ensure!(
        send_amp != recv_amp,
        "unsupported swap type (send_amp != recv_amp)"
    );

    let mut call = std::ptr::null_mut();
    let unspent_outputs = gdk_json::UnspentOutputsArgs {
        subaccount: wallet.account.pointer,
        num_confs: 0,
    };
    let rc =
        gdk::GA_get_unspent_outputs(session, GdkJson::new(&unspent_outputs).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_get_unspent_outputs failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let mut unspent_outputs_json =
        run_auth_handler_impl::<gdk_json::UnspentOutputsJsonMapResult>(data.hw_data.as_ref(), call)
            .map_err(|e| anyhow!("loading unspent outputs failed: {}", e))?;
    let utxos = unspent_outputs_json
        .unspent_outputs
        .remove(&amounts.send_asset)
        .unwrap_or_default();

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
    let pset_details =
        run_auth_handler_impl::<gdk_json::PsetDetailsResult>(data.hw_data.as_ref(), call)
            .map_err(|e| anyhow!("loading PSET details failed: {}", e))?;
    debug!("decoded AMP pset details: {:?}", &pset_details);
    // There could be only AMP asset inputs and outputs currenly
    // (because L-BTC goes from/to the regular wallet)
    ensure!(send_amp != recv_amp);
    let amp_asset = if send_amp {
        amounts.send_asset
    } else {
        amounts.recv_asset
    };
    for data in pset_details
        .inputs
        .iter()
        .chain(pset_details.outputs.iter())
    {
        ensure!(data.asset_id == amp_asset);
        ensure!(data.subaccount == wallet.account.pointer);
    }
    let input_total = pset_details
        .inputs
        .iter()
        .map(|data| data.satoshi)
        .sum::<u64>();
    let output_total = pset_details
        .outputs
        .iter()
        .map(|data| data.satoshi)
        .sum::<u64>();
    if send_amp {
        ensure!(input_total >= output_total);
        ensure!(input_total - output_total == amounts.send_amount);
    }
    if recv_amp {
        ensure!(input_total == 0);
        ensure!(output_total == amounts.recv_amount);
    }
    Ok(utxos)
}

unsafe fn sign_pset(
    data: &mut Data,
    pset: &str,
    nonces: &[String],
    utxos: PsetUtoxs,
) -> Result<String, anyhow::Error> {
    let wallet = data
        .wallet
        .as_mut()
        .ok_or_else(|| anyhow!("no AMP wallet"))?;
    let session = wallet
        .session
        .clone()
        .ok_or_else(|| anyhow!("no session"))?;

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
    let signed_pset =
        run_auth_handler_impl::<gdk_json::SignPsetResult>(data.hw_data.as_ref(), call)
            .map_err(|e| anyhow!("signing pset failed: {}", e))?;
    Ok(signed_pset.psbt)
}

unsafe fn get_balances(data: &mut Data) -> Result<gdk_json::BalanceList, anyhow::Error> {
    let wallet = data
        .wallet
        .as_mut()
        .ok_or_else(|| anyhow!("no AMP wallet"))?;
    let session = wallet
        .session
        .clone()
        .ok_or_else(|| anyhow!("no session"))?;
    let balance = gdk_json::UnspentOutputsArgs {
        subaccount: wallet.account.pointer,
        num_confs: 0,
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_get_balance(session, GdkJson::new(&balance).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_get_balance failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let balances = run_auth_handler_impl::<gdk_json::BalanceList>(data.hw_data.as_ref(), call)
        .map_err(|e| anyhow!("loading balances failed: {}", e))?;
    Ok(balances)
}

fn get_blinded_value(
    value: u64,
    asset: &AssetId,
    value_bf: &BlindingFactor,
    asset_bf: &BlindingFactor,
) -> String {
    [
        value.to_string(),
        asset.to_string(),
        value_bf.to_string(),
        asset_bf.to_string(),
    ]
    .join(",")
}

unsafe fn get_blinded_values(data: &mut Data, txid: &str) -> Result<Vec<String>, anyhow::Error> {
    let txid = sideswap_api::Txid::from_str(txid)?;
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
    data: &mut Data,
    send_amount: i64,
    peg_addr: &str,
) -> Result<worker::PegPayment, anyhow::Error> {
    let wallet = data
        .wallet
        .as_mut()
        .ok_or_else(|| anyhow!("no AMP wallet"))?;
    let session = wallet
        .session
        .clone()
        .ok_or_else(|| anyhow!("no session"))?;
    let send_asset = wallet.policy_asset;

    let mut call = std::ptr::null_mut();
    let unspent_outputs = gdk_json::UnspentOutputsArgs {
        subaccount: wallet.account.pointer,
        num_confs: 0,
    };
    let rc =
        gdk::GA_get_unspent_outputs(session, GdkJson::new(&unspent_outputs).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_get_unspent_outputs failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let unspent_outputs_json =
        run_auth_handler_impl::<gdk_json::UnspentOutputsJsonResult>(data.hw_data.as_ref(), call)
            .map_err(|e| anyhow!("loading unspent outputs failed: {}", e))?;
    let mut unspent_outputs = serde_json::from_value::<gdk_json::UnspentOutputs>(
        unspent_outputs_json.unspent_outputs.clone(),
    )
    .map_err(|e| anyhow!("parsing unspent outputs failed: {}", e))?;

    let inputs = unspent_outputs.remove(&send_asset).unwrap_or_default();
    let total = inputs.iter().map(|input| input.satoshi).sum::<u64>() as i64;
    ensure!(send_amount <= total, "Insufficient funds");
    let send_all = send_amount == total;

    let tx_addressee = gdk_json::TxAddressee {
        address: peg_addr.to_owned(),
        satoshi: send_amount as u64,
        asset_id: send_asset,
    };
    let create_tx = gdk_json::CreateTransactionOpt {
        subaccount: wallet.account.pointer,
        addressees: vec![tx_addressee],
        utxos: unspent_outputs_json.unspent_outputs,
        send_all,
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_create_transaction(session, GdkJson::new(&create_tx).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_create_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let created_tx_json = run_auth_handler_impl::<serde_json::Value>(data.hw_data.as_ref(), call)
        .map_err(|e| anyhow!("creating transaction failed: {}", e))?;
    let created_tx =
        serde_json::from_value::<gdk_json::CreateTransactionResult>(created_tx_json.clone())
            .map_err(|e| anyhow!("parsing created transaction JSON failed: {}", e))?;
    debug!("created tx: {:?}", &created_tx);
    ensure!(created_tx.fee > 0, "network fee is 0");

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_sign_transaction(session, GdkJson::new(&created_tx_json).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_sign_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let signed_tx_json = run_auth_handler_impl::<serde_json::Value>(data.hw_data.as_ref(), call)
        .map_err(|e| anyhow!("signing tx failed: {}", e))?;

    let signed_tx =
        serde_json::from_value::<gdk_json::SignTransactionResult>(signed_tx_json.clone())?;

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_send_transaction(session, GdkJson::new(&signed_tx_json).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_send_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let send_result =
        run_auth_handler_impl::<gdk_json::SendTransactionResult>(data.hw_data.as_ref(), call)
            .map_err(|e| anyhow!("sending tx failed: {}", e))?;
    info!("send succeed, waiting for txhash: {}", &send_result.txhash);

    let sent_amount = if send_all {
        send_amount - created_tx.fee as i64
    } else {
        send_amount
    };

    Ok(worker::PegPayment {
        sent_amount,
        sent_txid: send_result.txhash,
        signed_tx: signed_tx.transaction,
    })
}

static GDK_INITIALIZED: std::sync::Once = std::sync::Once::new();

pub fn start_processing(work_dir: &str, worker: crossbeam_channel::Sender<worker::Message>) -> Amp {
    let (amp_sender, amp_receiver) = crossbeam_channel::unbounded::<To>();

    let notif_context = Box::into_raw(Box::new(NotifContext(amp_sender.clone())));

    let data = std::sync::Arc::new(std::sync::Mutex::new(Data {
        amp_sender,
        worker,
        notif_context,
        wallet: None,
        hw_data: None,
        top_block: None,
        pending_txs: false,
    }));

    GDK_INITIALIZED.call_once(|| unsafe {
        let config = gdk_json::InitConfig {
            datadir: work_dir.to_owned(),
        };
        let rc = gdk::GA_init(GdkJson::new(&config).as_ptr());
        assert!(rc == 0);
    });

    let data_copy = data.clone();
    std::thread::spawn(move || unsafe {
        while let Ok(msg) = amp_receiver.recv() {
            let mut data = data_copy.lock().unwrap();
            match msg {
                To::Notification(msg) => notification(&mut data, msg),
                To::JadeFatalError(error) => jade_fatal_error(&mut data, error),

                To::Login(info) => login(&mut data, info),
                To::Logout => logout(&mut data),
                To::AppState(active) => app_state(&mut data, active),
                To::GetRecvAddr => get_recv_addr(&mut data),
                To::CreateTx(tx) => create_tx(&mut data, tx),
                To::SendTx => send_tx(&mut data),
            }
        }

        debug!("shutdown GDK AMP account processing...");
        let mut data = data_copy.lock().unwrap();
        logout(&mut data);
    });

    Amp(data)
}
