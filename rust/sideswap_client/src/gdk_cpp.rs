use crate::ffi;
use crate::gdk;
use crate::gdk_json;
use crate::gdk_ses;
use crate::gdk_ses::NotifCallback;
use crate::models;
use crate::models::Transaction;
use crate::swaps;
use crate::swaps::secp;
use crate::swaps::MakerChainingTx;
use crate::worker;
use crate::worker::AccountId;
use bitcoin::hashes::Hash;
use elements::encode::Encodable;
use gdk_ses::HwData;
use serde_bytes::ByteBuf;
use sideswap_api::AssetId;
use sideswap_api::BlindingFactor;
use sideswap_api::PsetInput;
use sideswap_common::env::Network;
use std::collections::BTreeMap;
use std::collections::HashMap;
use std::ffi::{CStr, CString};
use std::str::FromStr;

const SUBACCOUNT_NAME_AMP: &str = "AMP";
const SUBACCOUNT_TYPE_AMP: &str = "2of2_no_recovery";

pub struct GdkSesCpp {
    login_info: gdk_ses::LoginInfo,

    hw_data: Option<HwData>,

    session: *mut gdk::GA_session,
    subaccount: Option<i32>,
    receiving_id: Option<String>,
    policy_asset: AssetId,
}

impl gdk_ses::GdkSes for GdkSesCpp {
    fn login(&mut self) -> Result<(), anyhow::Error> {
        unsafe { login(self) }
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
        try_get_gaid(&self)
    }

    fn update_sync_interval(&self, _time: u32) {}

    fn get_balances(&self) -> Result<std::collections::BTreeMap<AssetId, i64>, anyhow::Error> {
        unsafe { get_balances(self) }
    }

    fn get_transactions(&self) -> Result<Vec<Transaction>, anyhow::Error> {
        let result = unsafe { load_transactions(self) };
        result.map(|list| list.iter().map(|tx| convert_tx(tx)).collect::<Vec<_>>())
    }

    fn get_recv_address(&self) -> Result<String, anyhow::Error> {
        unsafe { try_get_recv_addr(self) }
    }

    fn create_tx(&mut self, tx: ffi::proto::CreateTx) -> Result<serde_json::Value, anyhow::Error> {
        unsafe { try_create_tx(self, tx) }
    }

    fn send_tx(&mut self, tx: &serde_json::Value) -> Result<sideswap_api::Txid, anyhow::Error> {
        unsafe { try_send_tx(self, tx) }
    }

    fn get_utxos(&self) -> Result<ffi::proto::from::UtxoUpdate, anyhow::Error> {
        unsafe { get_utxos(self) }
    }

    fn get_tx_fee(
        &mut self,
        asset_id: AssetId,
        send_amount: i64,
        addr: &str,
    ) -> Result<i64, anyhow::Error> {
        unsafe { get_tx_fee(self, asset_id, send_amount, addr) }
    }

    fn make_pegout_payment(
        &mut self,
        send_amount: i64,
        peg_addr: &str,
        send_amount_exact: i64,
    ) -> Result<worker::PegPayment, anyhow::Error> {
        unsafe { make_pegout_payment(&self, send_amount, peg_addr, send_amount_exact) }
    }

    fn get_blinded_values(&self, txid: &str) -> Result<Vec<String>, anyhow::Error> {
        unsafe { get_blinded_values(&self, txid) }
    }

    fn get_previous_addresses(
        &mut self,
        last_pointer: Option<u32>,
        internal: bool,
    ) -> Result<gdk_json::PreviousAddresses, anyhow::Error> {
        unsafe { get_previous_addresses(&self, last_pointer, internal) }
    }

    fn get_swap_inputs(
        &self,
        send_asset: &AssetId,
    ) -> Result<Vec<sideswap_api::PsetInput>, anyhow::Error> {
        unsafe { get_swap_inputs(&self, send_asset) }
    }

    fn sig_single_maker_tx(
        &mut self,
        input: &swaps::SigSingleInput,
        output: &swaps::SigSingleOutput,
    ) -> Result<swaps::SigSingleMaker, anyhow::Error> {
        unsafe { sig_single_maker_tx(&self, input, output) }
    }

    fn verify_and_sign_pset(
        &mut self,
        amounts: &crate::swaps::Amounts,
        pset: &str,
        nonces: &[String],
    ) -> Result<String, anyhow::Error> {
        unsafe { verify_and_sign_pset(self, amounts, pset, nonces) }
    }

    fn set_memo(&mut self, txid: &str, memo: &str) -> Result<(), anyhow::Error> {
        unsafe { set_memo(self, txid, memo) }
    }
}

impl GdkSesCpp {
    fn get_subaccount(&self) -> Result<i32, anyhow::Error> {
        self.subaccount.ok_or_else(|| anyhow!("not connected"))
    }
}

impl Drop for GdkSesCpp {
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

fn unlock_hw(hw_data: &HwData) -> Result<(), anyhow::Error> {
    hw_data.clear_queue();
    hw_data.jade.send(sideswap_jade::Req::ReadStatus);
    hw_data.set_status(gdk_ses::JadeStatus::ReadStatus);
    let resp = hw_data.get_resp();
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
            let network = if hw_data.env.data().mainnet {
                sideswap_jade::models::JadeNetwork::Liquid
            } else {
                sideswap_jade::models::JadeNetwork::TestnetLiquid
            };
            hw_data.jade.send(sideswap_jade::Req::AuthUser(network));
            hw_data.set_status(gdk_ses::JadeStatus::AuthUser);
            let resp = hw_data.get_resp_with_timeout(std::time::Duration::from_secs(360));
            let res = match resp {
                Ok(sideswap_jade::Resp::AuthUser(v)) => v,
                resp => bail!("unexpected Jade response: {:?}", resp),
            };
            debug!("jade unlock result: {}", res);
            ensure!(res, "unlock failed");
        }
        sideswap_jade::models::State::Uninit
        | sideswap_jade::models::State::Unsaved
        | sideswap_jade::models::State::Temp => {
            bail!("unexpected jade state: {:?}", status.jade_state);
        }
    }

    Ok(())
}

unsafe fn run_auth_handler_impl<T: serde::de::DeserializeOwned>(
    hw_data: Option<&HwData>,
    call: *mut gdk::GA_auth_handler,
) -> Result<T, anyhow::Error> {
    let result = run_auth_handler(hw_data, call);
    if let Some(hw_data) = hw_data {
        hw_data.set_status(gdk_ses::JadeStatus::Idle);
    }
    result
}

unsafe fn run_auth_handler<T: serde::de::DeserializeOwned>(
    hw_data: Option<&HwData>,
    call: *mut gdk::GA_auth_handler,
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
        unlock_hw(hw_data)?;

        match required_data.action {
            gdk_json::HwAction::GetXpubs => {
                let paths = required_data.paths.unwrap();
                let mut xpubs = Vec::new();
                // TODO: Send requests in parallel
                for path in paths {
                    hw_data.clear_queue();
                    let network = if hw_data.env.data().mainnet {
                        sideswap_jade::models::JadeNetwork::Liquid
                    } else {
                        sideswap_jade::models::JadeNetwork::TestnetLiquid
                    };
                    hw_data.jade.send(sideswap_jade::Req::ResolveXpub(
                        sideswap_jade::models::ResolveXpubReq { network, path },
                    ));
                    let resp = hw_data.get_resp();
                    let resp = match resp {
                        Ok(sideswap_jade::Resp::ResolveXpub(v)) => v,
                        resp => bail!("unexpected Jade response: {:?}", resp),
                    };
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
                    let script = hex::decode(&script).unwrap();
                    let public_key = hex::decode(&public_key).unwrap();
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
                hw_data.set_status(gdk_ses::JadeStatus::SignTx);

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
                            value_commitment: None,
                        });
                        change.push(None);
                        continue;
                    }

                    let asset_id_rev = output.asset_id.0.iter().cloned().rev().collect::<Vec<_>>();
                    let public_key = hex::decode(output.blinding_key.as_ref().unwrap()).unwrap();

                    let vbf = if output_index == last_blinded_index {
                        hw_data.jade.send(sideswap_jade::Req::GetBlindingFactor(
                            sideswap_jade::models::GetBlindingFactorReq {
                                hash_prevouts: hash_prevouts.clone(),
                                output_index: output_index as u32,
                                factor_type: sideswap_jade::models::BlindingFactorType::Asset,
                            },
                        ));

                        let resp = hw_data.get_resp();
                        let abf = match resp {
                            Ok(sideswap_jade::Resp::GetBlindingFactor(v)) => v,
                            resp => bail!("unexpected Jade response: {:?}", resp),
                        };
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
                            secp(),
                            output.satoshi,
                            abf,
                            &inputs,
                            &outputs,
                        );

                        Some(vbf.into_inner().as_ref().to_vec())
                    } else {
                        None
                    };

                    hw_data.jade.send(sideswap_jade::Req::GetCommitments(
                        sideswap_jade::models::GetCommitmentsReq {
                            asset_id: asset_id_rev.clone(),
                            value: output.satoshi,
                            hash_prevouts: hash_prevouts.clone(),
                            output_index: output_index as u32,
                            vbf,
                        },
                    ));

                    let resp = hw_data.get_resp();
                    let commitment = match resp {
                        Ok(sideswap_jade::Resp::GetCommitments(v)) => v,
                        resp => bail!("unexpected Jade response: {:?}", resp),
                    };

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

                let network = if hw_data.env.data().mainnet {
                    sideswap_jade::models::JadeNetwork::Liquid
                } else {
                    sideswap_jade::models::JadeNetwork::TestnetLiquid
                };

                let sign_tx = sideswap_jade::models::ReqSignTx {
                    network: network.name().to_owned(),
                    use_ae_signatures: true,
                    txn: ByteBuf::from(hex::decode(&transaction.transaction).unwrap()),
                    num_inputs: signing_inputs.len() as u32,
                    trusted_commitments: commitments.clone(),
                    change,
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
                for input in signing_inputs.iter() {
                    hw_data.jade.send(sideswap_jade::Req::TxInput(
                        sideswap_jade::models::ReqTxInput {
                            is_witness: true,
                            path: input.user_path.clone(),
                            script: ByteBuf::from(hex::decode(&input.prevout_script).unwrap()),
                            value_commitment: ByteBuf::from(
                                hex::decode(&input.commitment).unwrap(),
                            ),
                            ae_host_commitment: ByteBuf::from(
                                hex::decode(&input.ae_host_commitment).unwrap(),
                            ),
                        },
                    ));
                    let resp = hw_data.get_resp();
                    let tx_input = match resp {
                        Ok(sideswap_jade::Resp::TxInput(v)) => v,
                        resp => bail!("unexpected Jade response: {:?}", resp),
                    };
                    signer_commitments.push(hex::encode(&tx_input));
                }

                let mut signatures = Vec::new();
                for input in signing_inputs.iter() {
                    hw_data.jade.send(sideswap_jade::Req::GetSignature(
                        hex::decode(&input.ae_host_entropy).unwrap(),
                    ));
                    let resp = hw_data.get_resp();
                    let signature = match resp {
                        Ok(sideswap_jade::Resp::GetSignature(v)) => v,
                        resp => bail!("unexpected Jade response: {:?}", resp),
                    };
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
                    .send(sideswap_jade::Req::GetSignature(ae_host_entropy));
                let resp = hw_data.get_resp();
                let signature = match resp {
                    Ok(sideswap_jade::Resp::GetSignature(v)) => v,
                    resp => bail!("unexpected Jade response: {:?}", resp),
                };

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

fn convert_tx(tx: &gdk_json::Transaction) -> Transaction {
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

    let balances_all = tx
        .inputs
        .iter()
        .map(convert_input)
        .chain(tx.outputs.iter().map(convert_output))
        .flatten()
        .collect();

    let tx = Transaction {
        txid: tx.txhash.clone(),
        network_fee: tx.fee,
        size: tx.transaction_size,
        vsize: tx.transaction_vsize,
        memo: tx.memo.clone(),
        balances,
        created_at,
        block_height: tx.block_height,
        balances_all,
    };
    tx
}

unsafe fn load_transactions(data: &GdkSesCpp) -> Result<Vec<gdk_json::Transaction>, anyhow::Error> {
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

fn try_get_gaid(data: &GdkSesCpp) -> Result<String, anyhow::Error> {
    data.receiving_id
        .clone()
        .ok_or_else(|| anyhow!("not connected"))
}

unsafe fn try_get_recv_addr(data: &GdkSesCpp) -> Result<String, anyhow::Error> {
    let session = data.session;
    let subaccount = data.get_subaccount()?;

    let get_addr = gdk_json::RecvAddrOpt { subaccount };
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

unsafe fn try_create_tx(
    data: &mut GdkSesCpp,
    tx: ffi::proto::CreateTx,
) -> Result<serde_json::Value, anyhow::Error> {
    let session = data.session;
    let subaccount = data.get_subaccount()?;
    let send_asset = AssetId::from_str(&tx.balance.asset_id).unwrap();

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
    let unspent_outputs =
        run_auth_handler_impl::<gdk_json::UnspentOutputsResult>(data.hw_data.as_ref(), call)
            .map_err(|e| anyhow!("loading unspent outputs failed: {}", e))?
            .unspent_outputs;

    let bitcoin_balance = unspent_outputs
        .get(&data.policy_asset)
        .map(|inputs| inputs.iter().map(|input| input.satoshi).sum::<u64>())
        .unwrap_or_default();
    let inputs = unspent_outputs.get(&send_asset);
    let total = inputs
        .iter()
        .map(|inputs| inputs.iter())
        .flatten()
        .map(|input| input.satoshi)
        .sum::<u64>() as i64;
    ensure!(tx.balance.amount <= total, "Insufficient funds");
    ensure!(
        bitcoin_balance > 0,
        "Insufficient L-BTC AMP to pay network fee"
    );
    let send_all = tx.balance.amount == total && send_asset == data.policy_asset;

    let tx_addressee = gdk_json::TxAddressee {
        address: tx.addr.clone(),
        satoshi: tx.balance.amount as u64,
        asset_id: send_asset,
    };
    let create_tx = gdk_json::CreateTransactionOpt {
        subaccount,
        addressees: vec![tx_addressee],
        utxos: unspent_outputs,
        send_all,
        utxo_strategy: None,
        is_partial: None,
        used_utxos: None,
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
    ensure!(created_tx.error.is_empty(), "{}", created_tx.error);
    ensure!(created_tx.fee.unwrap_or_default() > 0, "network fee is 0");

    Ok(created_tx_json)
}

unsafe fn try_send_tx(
    data: &mut GdkSesCpp,
    tx: &serde_json::Value,
) -> Result<sideswap_api::Txid, anyhow::Error> {
    let session = data.session;

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_sign_transaction(session, GdkJson::new(&tx).as_ptr(), &mut call);
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
    ensure!(signed_tx.error.is_empty(), "{}", signed_tx.error);
    debug!("signed tx: {:?}", &signed_tx);

    ensure!(signed_tx
        .transaction_outputs
        .iter()
        .all(|v| v.address.is_none() == v.is_fee.unwrap_or_default()));

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

    Ok(send_result.txhash)
}

unsafe fn get_swap_inputs(
    data: &GdkSesCpp,
    send_asset: &AssetId,
) -> Result<Vec<sideswap_api::PsetInput>, anyhow::Error> {
    let subaccount = data.get_subaccount()?;
    let session = data.session;

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
    let mut unspent_outputs =
        run_auth_handler_impl::<gdk_json::UnspentOutputsResult>(data.hw_data.as_ref(), call)
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

    Ok(inputs)
}

unsafe fn verify_and_sign_pset(
    data: &GdkSesCpp,
    amounts: &crate::swaps::Amounts,
    pset: &str,
    nonces: &[String],
) -> Result<String, anyhow::Error> {
    let subaccount = data.get_subaccount()?;
    let session = data.session;

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
    let mut unspent_outputs_json =
        run_auth_handler_impl::<gdk_json::UnspentOutputsResult>(data.hw_data.as_ref(), call)
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
    let mut sats = BTreeMap::<AssetId, i64>::new();
    for input in pset_details.inputs.iter() {
        ensure!(input.subaccount == subaccount);
        ensure!(input.asset_id == amounts.send_asset);
        *sats.entry(input.asset_id).or_default() -= input.satoshi as i64;
    }
    for output in pset_details.outputs.iter() {
        ensure!(output.subaccount == subaccount);
        ensure!(output.asset_id == amounts.send_asset || output.asset_id == amounts.recv_asset);
        *sats.entry(output.asset_id).or_default() += output.satoshi as i64;
    }
    let send_amount = -sats.get(&amounts.send_asset).cloned().unwrap_or_default();
    let recv_amount = sats.get(&amounts.recv_asset).cloned().unwrap_or_default();
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
    let signed_pset =
        run_auth_handler_impl::<gdk_json::SignPsetResult>(data.hw_data.as_ref(), call)
            .map_err(|e| anyhow!("signing pset failed: {}", e))?;
    Ok(signed_pset.psbt)
}

unsafe fn sig_single_maker_utxo(
    data: &GdkSesCpp,
    input: &crate::swaps::SigSingleInput,
) -> Result<(gdk_json::UnspentOutput, Option<MakerChainingTx>), anyhow::Error> {
    let subaccount = data.get_subaccount()?;
    let session = data.session;
    let send_asset = AssetId::from_slice(input.asset.into_inner().as_ref()).unwrap();

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
    let unspent_outputs =
        run_auth_handler_impl::<gdk_json::UnspentOutputsResult>(data.hw_data.as_ref(), call)
            .map_err(|e| anyhow!("loading unspent outputs failed: {}", e))?
            .unspent_outputs;

    if let Some(unspent_output) = unspent_outputs
        .get(&send_asset)
        .cloned()
        .unwrap_or_default()
        .into_iter()
        .find(|utxo| utxo.satoshi == input.value)
    {
        return Ok((unspent_output, None));
    }

    let get_addr = gdk_json::RecvAddrOpt { subaccount };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_get_receive_address(session, GdkJson::new(&get_addr).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_get_receive_address failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let recv_addr = run_auth_handler_impl::<gdk_json::RecvAddrResult>(data.hw_data.as_ref(), call)?;
    debug!("recv addr: {:?}", &recv_addr);

    let tx_addressee = gdk_json::TxAddressee {
        address: recv_addr.address.clone(),
        satoshi: input.value,
        asset_id: send_asset,
    };
    let create_tx = gdk_json::CreateTransactionOpt {
        subaccount,
        addressees: vec![tx_addressee],
        utxos: unspent_outputs,
        send_all: false,
        utxo_strategy: None,
        is_partial: None,
        used_utxos: None,
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_create_transaction(session, GdkJson::new(&create_tx).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_create_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let mut created_tx_json =
        run_auth_handler_impl::<serde_json::Value>(data.hw_data.as_ref(), call)
            .map_err(|e| anyhow!("creating transaction failed: {}", e))?;
    let created_tx =
        serde_json::from_value::<gdk_json::CreateTransactionResult>(created_tx_json.clone())
            .map_err(|e| anyhow!("parsing created transaction JSON failed: {}", e))?;
    debug!("created tx: {:?}", &created_tx);
    ensure!(created_tx.error.is_empty(), "{}", created_tx.error);
    ensure!(created_tx.fee.unwrap_or_default() > 0, "network fee is 0");

    created_tx_json.as_object_mut().unwrap().insert(
        "sign_with".to_owned(),
        serde_json::json!(["user", "green-backend"]),
    );

    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_sign_transaction(session, GdkJson::new(&created_tx_json).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_sign_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let signed_tx =
        run_auth_handler_impl::<gdk_json::SignTransactionResult>(data.hw_data.as_ref(), call)
            .map_err(|e| anyhow!("signing tx failed: {}", e))?;
    debug!("signed tx: {:?}", &signed_tx);
    ensure!(signed_tx.error.is_empty(), "{}", signed_tx.error);

    let tx = elements::encode::deserialize::<elements::Transaction>(&hex::decode(
        &signed_tx.transaction,
    )?)?;

    let (pt_idx, output) = signed_tx
        .transaction_outputs
        .iter()
        .enumerate()
        .find(|(_, output)| {
            output.address.as_ref() == Some(&recv_addr.address)
                && output.satoshi == input.value
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
    let asset_commitment = tx_out
        .asset
        .commitment()
        .ok_or_else(|| anyhow!("asset_commitment is empty"))?;
    let value_commitment = tx_out
        .value
        .commitment()
        .ok_or_else(|| anyhow!("value_commitment is empty"))?;
    let nonce_commitment = tx_out
        .nonce
        .commitment()
        .ok_or_else(|| anyhow!("nonce_commitment is empty"))?;

    let unspent = gdk_json::UnspentOutput {
        address_type: recv_addr.address_type,
        txhash: sideswap_api::Hash32::from_slice(&tx.txid().into_inner()).unwrap(),
        pointer: recv_addr.pointer,
        pt_idx: pt_idx as u32,
        asset_id: output.asset_id.unwrap(),
        satoshi: input.value,
        amountblinder: Some(output_value_bf),
        assetblinder: Some(output_asset_bf),
        subaccount: recv_addr.subaccount,
        is_internal: false,
        nonce_commitment: Some(nonce_commitment.to_string()),
        confidential: true,
        asset_commitment: Some(asset_commitment.to_string()),
        value_commitment: Some(value_commitment.to_string()),
        user_sighash: None,
        delayed_signature: None,
        prevout_script: Some(recv_addr.script),
    };

    let chaining_tx = MakerChainingTx {
        input: sideswap_api::PsetInput {
            txid: sideswap_api::Hash32::from_slice(&tx.txid().into_inner()).unwrap(),
            vout: pt_idx as u32,
            asset: send_asset,
            asset_bf: output.assetblinder.unwrap(),
            value: output.satoshi,
            value_bf: output.amountblinder.unwrap(),
            redeem_script: None,
        },
        tx,
    };

    Ok((unspent, Some(chaining_tx)))
}

unsafe fn sig_single_maker_tx(
    data: &GdkSesCpp,
    input: &crate::swaps::SigSingleInput,
    output: &crate::swaps::SigSingleOutput,
) -> Result<crate::swaps::SigSingleMaker, anyhow::Error> {
    let subaccount = data.get_subaccount()?;
    let (mut unspent_output, chaining_tx) = sig_single_maker_utxo(data, input)?;
    unspent_output.user_sighash = Some(elements::SigHashType::SinglePlusAnyoneCanPay as u8);
    unspent_output.delayed_signature = Some(true);

    let session = data.session;

    let tx_addressee = gdk_json::TxAddressee {
        address: output.address.to_string(),
        satoshi: output.value,
        asset_id: AssetId::from_slice(output.asset.into_inner().as_ref()).unwrap(),
    };
    let create_tx = gdk_json::CreateTransactionOpt {
        subaccount,
        addressees: vec![tx_addressee],
        utxos: BTreeMap::new(),
        send_all: false,
        utxo_strategy: Some(gdk_common::model::UtxoStrategy::Manual),
        is_partial: Some(true),
        used_utxos: Some(vec![unspent_output]),
    };
    let mut call = std::ptr::null_mut();
    let rc = gdk::GA_create_transaction(session, GdkJson::new(&create_tx).as_ptr(), &mut call);
    ensure!(
        rc == 0,
        "GA_create_transaction failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
    let mut created_tx_json =
        run_auth_handler_impl::<serde_json::Value>(data.hw_data.as_ref(), call)
            .map_err(|e| anyhow!("creating transaction failed: {}", e))?;
    let created_tx =
        serde_json::from_value::<gdk_json::CreateTransactionResult>(created_tx_json.clone())
            .map_err(|e| anyhow!("parsing created transaction JSON failed: {}", e))?;
    debug!("created tx: {:?}", &created_tx);
    ensure!(created_tx.error.is_empty(), "{}", created_tx.error);
    ensure!(
        created_tx.fee.unwrap_or_default() == 0,
        "network fee is expected to be 0"
    );

    created_tx_json
        .as_object_mut()
        .unwrap()
        .insert("sign_with".to_owned(), serde_json::json!(["user"]));

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
    debug!("signed tx: {:?}", &signed_tx);
    ensure!(signed_tx.error.is_empty(), "{}", signed_tx.error);

    let tx = elements::encode::deserialize::<elements::Transaction>(&hex::decode(
        &signed_tx.transaction,
    )?)?;

    ensure!(signed_tx.transaction_outputs.len() == 1);
    let output = &signed_tx.transaction_outputs[0];
    let output_asset_bf = elements::confidential::AssetBlindingFactor::from_slice(
        &output
            .assetblinder
            .ok_or_else(|| anyhow!("assetblinder is not set"))?
            .0,
    )
    .unwrap();
    let output_value_bf = elements::confidential::ValueBlindingFactor::from_slice(
        &output
            .amountblinder
            .ok_or_else(|| anyhow!("amountblinder is not set"))?
            .0,
    )
    .unwrap();
    let output_sender_sk = output
        .eph_private_key
        .ok_or_else(|| anyhow!("eph_private_key is not set"))?
        .clone();

    ensure!(signed_tx.used_utxos.len() == 1);
    ensure!(signed_tx.used_utxos[0].prevout_script.is_some());

    Ok(crate::swaps::SigSingleMaker {
        tx,
        input_prevout_script: signed_tx.used_utxos[0].prevout_script.clone(),
        output_asset_bf,
        output_value_bf,
        output_sender_sk,
        chaining_tx,
    })
}

unsafe fn get_balances(data: &GdkSesCpp) -> Result<gdk_json::BalanceList, anyhow::Error> {
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
    let balances = run_auth_handler_impl::<gdk_json::BalanceList>(data.hw_data.as_ref(), call)
        .map_err(|e| anyhow!("loading balances failed: {}", e))?;
    Ok(balances)
}

unsafe fn get_utxos(data: &GdkSesCpp) -> Result<ffi::proto::from::UtxoUpdate, anyhow::Error> {
    let subaccount = data.get_subaccount()?;
    let session = data.session;

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
    let unspent_outputs =
        run_auth_handler_impl::<gdk_json::UnspentOutputsResult>(data.hw_data.as_ref(), call)
            .map_err(|e| anyhow!("loading unspent outputs failed: {}", e))?;
    let utxos = unspent_outputs
        .unspent_outputs
        .values()
        .flatten()
        .map(|utxo| ffi::proto::from::utxo_update::Utxo {
            txid: utxo.txhash.to_string(),
            vout: utxo.pt_idx,
            asset_id: utxo.asset_id.to_string(),
            amount: utxo.satoshi,
        })
        .collect();
    Ok(ffi::proto::from::UtxoUpdate {
        account: worker::get_account(data.login_info.account_id),
        utxos,
    })
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

unsafe fn get_blinded_values(data: &GdkSesCpp, txid: &str) -> Result<Vec<String>, anyhow::Error> {
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
    data: &GdkSesCpp,
    send_amount: i64,
    peg_addr: &str,
    send_amount_exact: i64,
) -> Result<worker::PegPayment, anyhow::Error> {
    let subaccount = data.get_subaccount()?;
    let session = data.session;
    let send_asset = data.policy_asset;

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
    let unspent_outputs =
        run_auth_handler_impl::<gdk_json::UnspentOutputsResult>(data.hw_data.as_ref(), call)
            .map_err(|e| anyhow!("loading unspent outputs failed: {}", e))?
            .unspent_outputs;

    let inputs = unspent_outputs.get(&send_asset);
    let total = inputs
        .iter()
        .map(|inputs| inputs.iter())
        .flatten()
        .map(|input| input.satoshi)
        .sum::<u64>() as i64;
    ensure!(send_amount <= total, "Insufficient funds");
    let send_all = send_amount == total;

    let tx_addressee = gdk_json::TxAddressee {
        address: peg_addr.to_owned(),
        satoshi: send_amount as u64,
        asset_id: send_asset,
    };
    let create_tx = gdk_json::CreateTransactionOpt {
        subaccount,
        addressees: vec![tx_addressee],
        utxos: unspent_outputs,
        send_all,
        utxo_strategy: None,
        is_partial: None,
        used_utxos: None,
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
    ensure!(created_tx.error.is_empty(), "{}", created_tx.error);
    ensure!(created_tx.fee.unwrap_or_default() > 0, "network fee is 0");

    let sent_amount = if send_all {
        send_amount - created_tx.fee.unwrap() as i64
    } else {
        send_amount
    };
    ensure!(send_amount_exact == sent_amount);

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
    ensure!(signed_tx.error.is_empty(), "{}", signed_tx.error);

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

    Ok(worker::PegPayment {
        sent_amount,
        sent_txid: send_result.txhash,
        signed_tx: signed_tx.transaction,
    })
}

unsafe fn get_tx_fee(
    data: &GdkSesCpp,
    asset_id: AssetId,
    send_amount: i64,
    addr: &str,
) -> Result<i64, anyhow::Error> {
    let subaccount = data.get_subaccount()?;
    let session = data.session;

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
    let unspent_outputs =
        run_auth_handler_impl::<gdk_json::UnspentOutputsResult>(data.hw_data.as_ref(), call)
            .map_err(|e| anyhow!("loading unspent outputs failed: {}", e))?
            .unspent_outputs;

    let inputs = unspent_outputs.get(&asset_id);
    let total = inputs
        .iter()
        .map(|inputs| inputs.iter())
        .flatten()
        .map(|input| input.satoshi)
        .sum::<u64>() as i64;
    ensure!(send_amount <= total, "Insufficient funds");
    let send_all = send_amount == total && asset_id == data.policy_asset;

    let tx_addressee = gdk_json::TxAddressee {
        address: addr.to_owned(),
        satoshi: send_amount as u64,
        asset_id,
    };
    let create_tx = gdk_json::CreateTransactionOpt {
        subaccount,
        addressees: vec![tx_addressee],
        utxos: unspent_outputs,
        send_all,
        utxo_strategy: None,
        is_partial: None,
        used_utxos: None,
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
    ensure!(created_tx.error.is_empty(), "{}", created_tx.error);
    ensure!(created_tx.fee.unwrap_or_default() > 0, "network fee is 0");

    Ok(created_tx.fee.unwrap() as i64)
}

unsafe fn get_previous_addresses(
    data: &GdkSesCpp,
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
    let previous_addresses =
        run_auth_handler_impl::<gdk_json::PreviousAddresses>(data.hw_data.as_ref(), call)
            .map_err(|e| anyhow!("loading previous addresses failed: {}", e))?;
    Ok(previous_addresses)
}

unsafe fn set_memo(data: &GdkSesCpp, txid: &str, memo: &str) -> Result<(), anyhow::Error> {
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

unsafe fn login(data: &mut GdkSesCpp) -> Result<(), anyhow::Error> {
    let session = data.session;
    let hw_data = data.login_info.hw_data.as_ref();

    if data.login_info.watch_only.is_none() {
        let mut call = std::ptr::null_mut();
        let hw_device = HwData::get_hw_device(hw_data);
        let login_user = gdk_json::LoginUser {
            mnemonic: data.login_info.mnemonic.clone(),
            username: None,
            password: None,
        };
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
        let register_result = run_auth_handler_impl::<serde_json::Value>(hw_data, call)
            .map_err(|e| anyhow!("registration failed: {}", e))?;
        debug!("registration result: {}", register_result);
    }

    let mnemonic = data.login_info.mnemonic.clone();
    let username = data
        .login_info
        .watch_only
        .as_ref()
        .map(|watch_only| watch_only.username.clone());
    let password = data
        .login_info
        .watch_only
        .as_ref()
        .map(|watch_only| watch_only.password.clone());
    let hw_device = HwData::get_hw_device(hw_data);
    let login_user = gdk_json::LoginUser {
        mnemonic: mnemonic.clone(),
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
    let login_result = run_auth_handler_impl::<gdk_json::LoginUserResult>(hw_data, call)
        .map_err(|e| anyhow!("login failed: {}", e))?;
    debug!("wallet_hash_id: {:?}", login_result.wallet_hash_id);

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

    data.subaccount = Some(account.pointer);
    data.receiving_id = Some(account.receiving_id);

    Ok(())
}

unsafe fn set_watch_only(
    data: &mut GdkSesCpp,
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

unsafe fn reconnect_hint(data: &mut GdkSesCpp, hint: gdk_json::ReconnectHint) {
    debug!("send reconnect hint: {:?}", hint);
    let session = data.session;

    let hint = gdk_json::ReconnectHintOpt { hint };
    let rc = gdk::GA_reconnect_hint(session, GdkJson::new(&hint).as_ptr());
    assert!(
        rc == 0,
        "GA_reconnect_hint failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );
}

pub unsafe fn start_processing_impl(
    info: gdk_ses::LoginInfo,
    notif_callback: NotifCallback,
) -> Box<dyn gdk_ses::GdkSes> {
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

    let network = match info.env.data().network {
        Network::Mainnet => "liquid",
        _ => "testnet-liquid",
    };
    let policy_asset = AssetId::from_str(info.env.data().policy_asset).unwrap();
    let connect_config = gdk_json::ConnectConfig {
        name: network.to_owned(),
    };
    let rc = gdk::GA_connect(session, GdkJson::new(&connect_config).as_ptr());
    assert!(
        rc == 0,
        "connection failed: {}",
        last_gdk_error_details().unwrap_or_default()
    );

    let data = GdkSesCpp {
        hw_data: info.hw_data.clone(),
        session,
        policy_asset,
        login_info: info,
        subaccount: None,
        receiving_id: None,
    };

    Box::new(data)
}

pub fn start_processing(
    info: gdk_ses::LoginInfo,
    notif_callback: NotifCallback,
) -> Box<dyn gdk_ses::GdkSes> {
    unsafe { start_processing_impl(info, notif_callback) }
}
