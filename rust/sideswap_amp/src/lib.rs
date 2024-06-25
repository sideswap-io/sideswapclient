use std::{
    collections::{BTreeMap, HashMap},
    fmt::Debug,
    time::{Duration, Instant},
};

use bitcoin::{
    bip32::{ChildNumber, Xpriv, Xpub},
    hashes::Hash,
};
use elements::{
    pset::{self, PartiallySignedTransaction},
    AssetId, Transaction,
};
use elements_miniscript::slip77::MasterBlindingKey;
use futures::{SinkExt, StreamExt};
use secp256k1::global::SECP256K1 as secp1;
use secp256k1_zkp::global::SECP256K1 as secp2;
use sideswap_common::{abort, network::Network, retry_delay::RetryDelay, verify};
use tokio::sync::{
    mpsc::{UnboundedReceiver, UnboundedSender},
    oneshot,
};
use tokio_tungstenite::tungstenite;
pub use tx_cache::TxCache;
use wamp::common::{WampArgs, WampString};

use crate::wamp::{
    common::{Arg, WampDict, WampId},
    message::Msg,
};

mod models;
mod tx_cache;
mod wamp;

const DEFAULT_AGENT_STR: &str = "sideswap_amp";

const AMP_SUBACCOUNT_DEFAULT_NAME: &str = "AMP";

const AMP_SUBACCOUNT_TYPE: &str = "2of2_no_recovery";

#[derive(Debug)]
pub enum Event {
    Connected { gaid: String, block_height: u32 },
    Disconnected,
    BalanceUpdated { balances: BTreeMap<AssetId, u64> },
    NewBlock { block_height: u32 },
    NewTx { txid: elements::Txid },
}

pub struct Wallet {
    command_sender: UnboundedSender<Command>,
    policy_asset: AssetId,
    master_blinding_key: MasterBlindingKey,
    master_xpub: Xpub,
}

enum SignAction {
    SignOnly,
    SignAndSend,
}

#[derive(thiserror::Error, Debug)]
pub enum Error {
    #[error("Channel was closed sending {0}")]
    SendError(&'static str),
    #[error("Channel was closed receiving")]
    RecvError,
    #[error("Parsing failed for {0}: {1}")]
    BackendJsonError(&'static str, serde_json::Error),
    #[error("Unexpected arguments count: {0}, expected at least {1} elements")]
    BackendUnexpectedCount(usize, usize),
    #[error("Send amount can't be 0")]
    ZeroSendAmount,
    #[error("Amount overflow")]
    AmountOverflow,
    #[error(
        "Not enough amount for asset {asset_id}, required: {required}, available: {available}"
    )]
    NotEnoughAmount {
        asset_id: AssetId,
        required: u64,
        available: u64,
    },
    #[error("Blind error: {0}")]
    BlindError(#[from] sideswap_common::pset_blind::Error),
    #[error("WS error: {0}")]
    WsError(#[from] tokio_tungstenite::tungstenite::Error),
    #[error("Protocol error: {0}")]
    ProtocolError(&'static str),
    #[error("Wamp error: {context}: {error}")]
    WampError {
        context: &'static str,
        error: String,
    },
    #[error("script_sig or redeem_script for {0}:{1}")]
    NoRedeem(elements::Txid, u32),
    #[error("PSET error: {0}")]
    PsetError(#[from] elements::pset::Error),
    #[error("Request timeout")]
    RequestTimeout,
    #[error("HTTP connection error: {0}")]
    HttpConnectionError(#[from] tungstenite::http::Error),
}

impl<T> From<tokio::sync::mpsc::error::SendError<T>> for Error {
    fn from(value: tokio::sync::mpsc::error::SendError<T>) -> Self {
        Error::SendError(std::any::type_name_of_val(&value))
    }
}

impl From<tokio::sync::oneshot::error::RecvError> for Error {
    fn from(_value: tokio::sync::oneshot::error::RecvError) -> Self {
        Error::RecvError
    }
}

type ResSender<T> = oneshot::Sender<Result<T, Error>>;

enum Command {
    ReceiveAddress(ResSender<elements::Address>),
    UnspentOutputs(oneshot::Sender<Vec<Utxo>>),
    SignOrSendTx(
        elements::Transaction,
        Vec<String>,
        SignAction,
        ResSender<elements::Transaction>,
    ),
    LoadTxs(u64, ResSender<models::Transactions>),
    BlockHeight(ResSender<u32>),
}

fn convert_pubkey(pk: elements::secp256k1_zkp::PublicKey) -> bitcoin::PublicKey {
    bitcoin::PublicKey::new(pk)
}

#[derive(Debug)]
pub struct Recipient {
    pub address: elements::Address,
    pub asset_id: AssetId,
    pub amount: u64,
}

fn parse_args1<T1: serde::de::DeserializeOwned>(mut args: WampArgs) -> Result<T1, Error> {
    match &mut *args {
        [value, ..] => {
            let value = serde_json::from_value::<T1>(std::mem::take(value))
                .map_err(|err| Error::BackendJsonError(std::any::type_name::<T1>(), err))?;
            Ok(value)
        }
        _ => abort!(Error::BackendUnexpectedCount(args.len(), 1)),
    }
}

fn parse_args2<T1: serde::de::DeserializeOwned, T2: serde::de::DeserializeOwned>(
    mut args: WampArgs,
) -> Result<(T1, T2), Error> {
    match &mut *args {
        [value1, value2, ..] => {
            let value1 = serde_json::from_value::<T1>(std::mem::take(value1))
                .map_err(|err| Error::BackendJsonError(std::any::type_name::<T1>(), err))?;
            let value2 = serde_json::from_value::<T2>(std::mem::take(value2))
                .map_err(|err| Error::BackendJsonError(std::any::type_name::<T2>(), err))?;
            Ok((value1, value2))
        }
        _ => abort!(Error::BackendUnexpectedCount(args.len(), 2)),
    }
}

#[derive(Clone)]
pub struct CreatedTx {
    pub pset: PartiallySignedTransaction,
    pub blinding_nonces: Vec<String>,
    pub used_utxos: Vec<Utxo>,
    pub network_fee: u64,
}

#[derive(Clone)]
pub struct SignPset {
    pub pset: PartiallySignedTransaction,
    pub blinding_nonces: Vec<String>,
    pub used_utxos: Vec<Utxo>,
}

impl From<CreatedTx> for SignPset {
    fn from(
        CreatedTx {
            pset,
            blinding_nonces,
            used_utxos,
            network_fee: _,
        }: CreatedTx,
    ) -> Self {
        SignPset {
            pset,
            blinding_nonces,
            used_utxos,
        }
    }
}

impl Wallet {
    pub fn new(mnemonic: bip39::Mnemonic, network: Network) -> (Wallet, UnboundedReceiver<Event>) {
        let bitcoin_network = match network {
            Network::Liquid => bitcoin::Network::Bitcoin,
            Network::LiquidTestnet => bitcoin::Network::Testnet,
        };

        let seed = mnemonic.to_seed("");
        let master_blinding_key = MasterBlindingKey::from_seed(&seed);
        let master_key = Xpriv::new_master(bitcoin_network, &seed).expect("must not fail");
        let master_xpub = Xpub::from_priv(secp1, &master_key);

        let (command_sender, command_receiver) = tokio::sync::mpsc::unbounded_channel();
        let (event_sender, event_receiver) = tokio::sync::mpsc::unbounded_channel();

        tokio::spawn(run(
            master_blinding_key,
            master_key,
            network,
            command_receiver,
            event_sender,
        ));

        let wallet = Wallet {
            command_sender,
            policy_asset: network.d().policy_asset.asset_id(),
            master_blinding_key,
            master_xpub,
        };

        (wallet, event_receiver)
    }

    pub fn policy_asset(&self) -> AssetId {
        self.policy_asset
    }

    pub fn master_xpub(&self) -> &Xpub {
        &self.master_xpub
    }

    pub async fn receive_address(&self) -> Result<elements::Address, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.command_sender
            .send(Command::ReceiveAddress(res_sender))?;
        res_receiver.await?
    }

    pub async fn unspent_outputs(&self) -> Result<Vec<Utxo>, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.command_sender
            .send(Command::UnspentOutputs(res_sender))?;
        let utxos = res_receiver.await?;
        Ok(utxos)
    }

    pub async fn create_tx(&self, mut recipients: Vec<Recipient>) -> Result<CreatedTx, Error> {
        let all_utxos = self.unspent_outputs().await?;

        let mut pset = pset::PartiallySignedTransaction::new_v2();

        let mut output_amounts = BTreeMap::<AssetId, u64>::new();
        for recipient in recipients.iter() {
            verify!(recipient.amount > 0, Error::ZeroSendAmount);
            let output_amount = output_amounts.entry(recipient.asset_id).or_default();
            *output_amount = output_amount
                .checked_add(recipient.amount)
                .ok_or(Error::AmountOverflow)?;
        }

        let mut input_amounts = BTreeMap::<AssetId, u64>::new();
        let mut used_utxos = Vec::new();
        for utxo in all_utxos.into_iter() {
            let add_input = if utxo.tx_out_sec.asset == self.policy_asset {
                // TODO: Add only required LBTC inputs
                true
            } else {
                let input_amount = input_amounts
                    .get(&utxo.tx_out_sec.asset)
                    .copied()
                    .unwrap_or_default();
                let output_amount = output_amounts
                    .get(&utxo.tx_out_sec.asset)
                    .copied()
                    .unwrap_or_default();
                output_amount > input_amount
            };
            if add_input {
                let mut input = pset::Input::from_prevout(utxo.outpoint);
                input.redeem_script = Some(get_redeem_script(&utxo.prevout_script));
                input.witness_utxo = Some(utxo.txout.clone());
                pset.add_input(input);

                *input_amounts.entry(utxo.tx_out_sec.asset).or_default() += utxo.tx_out_sec.value;

                used_utxos.push(utxo);
            }
        }

        for (&asset_id, &output_amount) in output_amounts.iter() {
            if asset_id != self.policy_asset {
                let input_amount = input_amounts.get(&asset_id).copied().unwrap_or_default();
                verify!(
                    input_amount >= output_amount,
                    Error::NotEnoughAmount {
                        asset_id,
                        required: output_amount,
                        available: input_amount
                    }
                );
                let change_amount = input_amount - output_amount;
                if change_amount > 0 {
                    let change_address = self.receive_address().await?;
                    recipients.push(Recipient {
                        address: change_address,
                        asset_id,
                        amount: change_amount,
                    });
                }
            }
        }

        // TODO: Load addresses from backend only after all checks succeed
        // TODO: Load addresses from backend concurrently

        // FIXME: Use correct network fee
        let network_fee = sideswap_payjoin::network_fee::expected_network_fee(
            0,
            pset.n_inputs(),
            recipients.len() + 1, // 1 change outputs for LBTC
        );
        let policy_asset_input = input_amounts
            .get(&self.policy_asset)
            .copied()
            .unwrap_or_default();
        let policy_asset_output = output_amounts
            .get(&self.policy_asset)
            .copied()
            .unwrap_or_default();
        verify!(
            policy_asset_input >= policy_asset_output + network_fee,
            Error::NotEnoughAmount {
                asset_id: self.policy_asset,
                required: policy_asset_output + network_fee,
                available: policy_asset_input
            }
        );
        let policy_asset_change = policy_asset_input - policy_asset_output - network_fee;

        if policy_asset_change > 0 {
            let change_address = self.receive_address().await?;
            recipients.push(Recipient {
                address: change_address,
                asset_id: self.policy_asset,
                amount: policy_asset_change,
            });
        }

        for recipient in recipients {
            let output = pset::Output {
                script_pubkey: recipient.address.script_pubkey(),
                amount: Some(recipient.amount),
                asset: Some(recipient.asset_id),
                blinding_key: recipient.address.blinding_pubkey.map(convert_pubkey),
                blinder_index: Some(0),
                ..Default::default()
            };
            pset.add_output(output);
        }

        let fee_output = pset::Output::new_explicit(
            elements::Script::default(),
            network_fee,
            self.policy_asset,
            None,
        );

        pset.add_output(fee_output);

        let inp_txout_sec = used_utxos
            .iter()
            .map(|utxo| utxo.tx_out_sec)
            .collect::<Vec<_>>();
        let blinding_nonces = sideswap_common::pset_blind::blind_pset(&mut pset, &inp_txout_sec)?;

        Ok(CreatedTx {
            pset,
            blinding_nonces,
            used_utxos,
            network_fee,
        })
    }

    async fn sign_or_send_pset(
        &self,
        created_tx: SignPset,
        sign_action: SignAction,
    ) -> Result<Transaction, Error> {
        let SignPset {
            pset,
            blinding_nonces,
            used_utxos,
        } = created_tx;

        let mut tx = pset.extract_tx()?;
        let tx_copy = tx.clone();

        for (pset_input, tx_input) in pset.inputs().iter().zip(tx.input.iter_mut()) {
            let redeem_script = used_utxos
                .iter()
                .find(|utxo| utxo.outpoint == tx_input.previous_output)
                .map(|utxo| get_redeem_script(&utxo.prevout_script))
                .or_else(|| pset_input.redeem_script.clone());

            if let Some(redeem_script) = redeem_script {
                tx_input.script_sig = elements::script::Builder::new()
                    .push_slice(redeem_script.as_bytes())
                    .into_script();
            } else if let Some(final_script) = pset_input.final_script_sig.clone() {
                tx_input.script_sig = final_script;
            } else {
                // Green backend won't sign without script_sig
                abort!(Error::NoRedeem(
                    pset_input.previous_txid,
                    pset_input.previous_output_index
                ))
            }
        }

        let mut sighash_cache = elements::sighash::SighashCache::new(&tx_copy);
        for (index, tx_input) in tx.input.iter_mut().enumerate() {
            if let Some(utxo) = used_utxos
                .iter()
                .find(|utxo| utxo.outpoint == tx_input.previous_output)
            {
                let green_dummy_sig = hex::decode("304402207f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f02207f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f01").unwrap();

                let hash_ty = elements_miniscript::elements::EcdsaSighashType::All;
                let sighash = sighash_cache.segwitv0_sighash(
                    index,
                    &utxo.prevout_script,
                    utxo.txout.value,
                    hash_ty,
                );
                let msg =
                    elements::secp256k1_zkp::Message::from_digest_slice(&sighash[..]).unwrap();

                let user_sig = secp1.sign_ecdsa_low_r(&msg, &utxo.priv_key_user.inner);

                let user_sig = elements_miniscript::elementssig_to_rawsig(&(user_sig, hash_ty));

                tx_input.witness.script_witness = vec![
                    vec![],
                    green_dummy_sig,
                    user_sig,
                    utxo.prevout_script.to_bytes(),
                ];
            }
        }

        let (res_sender, res_receiver) = oneshot::channel();
        self.command_sender.send(Command::SignOrSendTx(
            tx,
            blinding_nonces,
            sign_action,
            res_sender,
        ))?;
        let val = res_receiver.await??;

        Ok(val)
    }

    pub async fn sign_swap_pset(
        &self,
        created_tx: SignPset,
    ) -> Result<PartiallySignedTransaction, Error> {
        // TODO: Verify PSET

        let mut pset = created_tx.pset.clone();

        let tx = self
            .sign_or_send_pset(created_tx, SignAction::SignOnly)
            .await?;

        sideswap_common::pset::copy_tx_signatures(&tx, &mut pset);

        Ok(pset)
    }

    pub async fn sign_and_broadcast_pset(
        &self,
        created_tx: SignPset,
    ) -> Result<Transaction, Error> {
        self.sign_or_send_pset(created_tx, SignAction::SignAndSend)
            .await
    }

    fn unblind_ep(
        &self,
        cache: &mut TxCache,
        txid: &elements::Txid,
        ep: models::TransactionEp,
    ) -> Option<(AssetId, u64)> {
        if !ep.is_relevant {
            return None;
        }

        if let (Some(asset_id), Some(value)) = (ep.asset_tag.explicit(), ep.commitment.explicit()) {
            return Some((asset_id, value));
        }

        let outpoint = if ep.is_output {
            elements::OutPoint {
                txid: *txid,
                vout: ep.pt_idx,
            }
        } else {
            elements::OutPoint {
                txid: ep.prevtxhash?,
                vout: ep.previdx?,
            }
        };

        if let Some(secret) = cache.get_secret(&outpoint) {
            return Some((secret.asset, secret.value));
        }

        let blinding_key = self.master_blinding_key.blinding_private_key(&ep.script);

        let txout = elements::TxOut {
            asset: ep.asset_tag,
            value: ep.commitment,
            nonce: ep.nonce_commitment,
            script_pubkey: ep.script,
            witness: elements::TxOutWitness {
                surjection_proof: ep.surj_proof,
                rangeproof: ep.range_proof,
            },
        };

        let unblinded_res = txout.unblind(secp2, blinding_key);
        match unblinded_res {
            Ok(tx_out_sec) => {
                cache.add_secret(outpoint, tx_out_sec);
                Some((tx_out_sec.asset, tx_out_sec.value))
            }
            Err(err) => {
                log::error!("unblinding failed: {}", err);
                None
            }
        }
    }

    fn convert_tx(&self, cache: &mut TxCache, tx: models::Transaction) -> tx_cache::Transaction {
        let inputs = tx
            .eps
            .iter()
            .filter_map(|ep| match (ep.is_output, ep.prevtxhash, ep.previdx) {
                (false, Some(txid), Some(vout)) => Some(tx_cache::TransactionInput {
                    prevtxid: txid,
                    previdx: vout,
                }),
                _ => None,
            })
            .collect();

        let outputs = tx
            .eps
            .iter()
            .filter_map(|ep| {
                if ep.is_output {
                    Some(tx_cache::TransactionOutput { pt_idx: ep.pt_idx })
                } else {
                    None
                }
            })
            .collect();

        let mut amounts = BTreeMap::new();
        for ep in tx.eps {
            let is_output = ep.is_output;
            if let Some((asset_id, value)) = self.unblind_ep(cache, &tx.txhash, ep) {
                let sign = if is_output { 1 } else { -1 };
                *amounts.entry(asset_id).or_default() += (value as i64) * sign;
            }
        }

        amounts.retain(|_, value| *value != 0);

        tx_cache::Transaction {
            txid: tx.txhash,
            created_at: tx.created_at_ts,
            block_height: tx.block_height,
            amounts,
            network_fee: tx.fee,
            inputs,
            outputs,
        }
    }

    pub async fn block_height(&self) -> Result<u32, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.command_sender.send(Command::BlockHeight(res_sender))?;
        let resp = res_receiver.await??;
        Ok(resp)
    }

    pub async fn reload_txs(&self, cache: &mut TxCache) -> Result<(), Error> {
        loop {
            let sync_timestamp = cache.start_sync_timestamp();

            let (res_sender, res_receiver) = oneshot::channel();
            self.command_sender
                .send(Command::LoadTxs(sync_timestamp, res_sender))?;
            let resp = res_receiver.await??;

            let new_txs = resp
                .list
                .into_iter()
                .map(|tx| self.convert_tx(cache, tx))
                .collect();
            cache.add_txs(new_txs);

            if !resp.more {
                break;
            }
        }
        Ok(())
    }

    pub fn tx_blinded_values(&self, txid: &elements::Txid, cache: &TxCache) -> Option<String> {
        let tx = cache.txs().iter().find(|tx| tx.txid == *txid)?;

        let mut secrets = Vec::new();

        for input in tx.inputs.iter() {
            let outpoint = elements::OutPoint {
                txid: input.prevtxid,
                vout: input.previdx,
            };
            if let Some(secret) = cache.get_secret(&outpoint) {
                secrets.push(secret);
            }
        }

        for output in tx.outputs.iter() {
            let outpoint = elements::OutPoint {
                txid: tx.txid,
                vout: output.pt_idx,
            };
            if let Some(secret) = cache.get_secret(&outpoint) {
                secrets.push(secret);
            }
        }

        let blinded_values = secrets
            .iter()
            .map(|secret| {
                [
                    secret.value.to_string(),
                    secret.asset.to_string(),
                    secret.value_bf.to_string(),
                    secret.asset_bf.to_string(),
                ]
            })
            .flatten()
            .collect::<Vec<_>>();

        Some(blinded_values.join(","))
    }
}

// If the callback returns an error, the wallet connection is restarted
type Callback = Box<dyn FnOnce(&mut Data, Result<WampArgs, Error>) -> Result<(), Error> + Send>;

// If the callback returns an error, the wallet connection is restarted
type SubscribeCallback = fn(&mut Data, WampArgs) -> Result<(), Error>;

type Connection =
    tokio_tungstenite::WebSocketStream<tokio_tungstenite::MaybeTlsStream<tokio::net::TcpStream>>;

struct PendingRequest {
    callback: Callback,
    expires_at: Instant,
}

type PendingRequests = BTreeMap<WampId, PendingRequest>;

struct Data {
    connection: Connection,
    pending_requests: PendingRequests,
    network: Network,
    master_blinding_key: MasterBlindingKey,
    subaccount: u32,
    user_xpriv: Xpriv,
    service_xpub: Xpub,
    event_sender: UnboundedSender<Event>,
    pending_subscribe: HashMap<WampId, SubscribeCallback>,
    active_subscribe: HashMap<WampId, SubscribeCallback>,
    utxos: Vec<Utxo>,
    reload_utxos: bool,
    ca_addresses: Vec<elements::Address>,
    block_height: u32,
}

#[derive(Clone)]
pub struct Utxo {
    pub pointer: u32,
    pub txout: elements::TxOut,
    pub outpoint: elements::OutPoint,
    pub tx_out_sec: elements::TxOutSecrets,
    pub priv_key_user: bitcoin::PrivateKey,
    // Example: 522103cab1a2a707d13ff3fcc9d08f888724e01c37d54ad8e8d9b274cb33eaebe3461321037888f798b59ff4e1122bdf52ad4c541be32ca755311746b67af2bc5e58df188b52ae
    pub prevout_script: elements::Script,
}

// Example: 0020953851a48d22e33a16eb11e9fb89ce1a410db6f0f681ec5b834b036fb84264c9
pub fn get_redeem_script(prevout_script: &elements::Script) -> elements::Script {
    elements::script::Builder::new()
        .push_int(0)
        .push_slice(&elements::WScriptHash::hash(prevout_script.as_bytes())[..])
        .into_script()
}

fn derive_ga_path(master_key: &Xpriv) -> Vec<u8> {
    let register_key = master_key
        .derive_priv(&secp2, &[ChildNumber::Hardened { index: 0x4741 }])
        .expect("must not fail");

    let pub_key = register_key
        .private_key
        .public_key(&elements::secp256k1_zkp::global::SECP256K1)
        .serialize();

    let ga_key = "GreenAddress.it HD wallet path";

    let data = [register_key.chain_code.as_bytes(), pub_key.as_slice()].concat();

    use hmac::Mac;
    let mut mac =
        hmac::Hmac::<sha2::Sha512>::new_from_slice(ga_key.as_bytes()).expect("must not fail");
    mac.update(&data);
    let result = mac.finalize();
    result.into_bytes().to_vec()
}

impl Data {
    fn derive_address(&self, pointer: u32) -> elements::Address {
        get_address(
            &self.user_xpriv,
            &self.service_xpub,
            &self.master_blinding_key,
            self.network,
            pointer,
        )
    }

    fn unblind_utxos(&self, utxos: Vec<models::Utxo>) -> Vec<Utxo> {
        utxos
            .into_iter()
            .filter_map(|utxo| {
                let txout = elements::TxOut {
                    asset: utxo.asset_tag,
                    value: utxo.commitment,
                    nonce: utxo.nonce_commitment,
                    script_pubkey: utxo.script,
                    witness: elements::TxOutWitness {
                        surjection_proof: utxo.surj_proof,
                        rangeproof: utxo.range_proof,
                    },
                };
                let blinding_key = self
                    .master_blinding_key
                    .blinding_private_key(&txout.script_pubkey);
                let out_point = elements::OutPoint {
                    txid: utxo.txhash,
                    vout: utxo.pt_idx,
                };

                let tx_out_sec = match (&txout.asset, &txout.value) {
                    (
                        elements::confidential::Asset::Explicit(asset_id),
                        elements::confidential::Value::Explicit(value),
                    ) => elements::TxOutSecrets {
                        asset: *asset_id,
                        asset_bf: elements::confidential::AssetBlindingFactor::zero(),
                        value: *value,
                        value_bf: elements::confidential::ValueBlindingFactor::zero(),
                    },
                    (
                        elements::confidential::Asset::Confidential(_),
                        elements::confidential::Value::Confidential(_),
                    ) => {
                        let unblinded_res = txout.unblind(secp2, blinding_key);
                        match unblinded_res {
                            Ok(tx_out_sec) => tx_out_sec,
                            Err(err) => {
                                log::error!("unblinding {} failed: {}", out_point, err);
                                return None;
                            }
                        }
                    }
                    _ => {
                        log::error!(
                            "mixed confidential/non-confidential values in {}",
                            out_point
                        );
                        return None;
                    }
                };

                let DerivedKeys {
                    priv_key_user,
                    redeem_script,
                } = derive_keys(&self.user_xpriv, &self.service_xpub, utxo.pointer);

                Some(Utxo {
                    txout,
                    tx_out_sec,
                    outpoint: out_point,
                    pointer: utxo.pointer,
                    priv_key_user,
                    prevout_script: redeem_script,
                })
            })
            .collect()
    }
}

struct DerivedKeys {
    priv_key_user: bitcoin::PrivateKey,
    redeem_script: elements::Script,
}

fn derive_keys(user_xpriv: &Xpriv, service_xpub: &Xpub, pointer: u32) -> DerivedKeys {
    let pub_key_green = service_xpub
        .derive_pub(secp1, &[ChildNumber::Normal { index: pointer }])
        .expect("should not fail")
        .to_pub();
    let priv_key_user = user_xpriv
        .derive_priv(secp1, &[ChildNumber::Normal { index: pointer }])
        .expect("should not fail")
        .to_priv();

    let pub_key_user = priv_key_user.public_key(secp1);

    let redeem_script = elements::script::Builder::new()
        .push_opcode(elements::opcodes::all::OP_PUSHNUM_2)
        .push_slice(&pub_key_green.to_bytes())
        .push_slice(&pub_key_user.to_bytes())
        .push_opcode(elements::opcodes::all::OP_PUSHNUM_2)
        .push_opcode(elements::opcodes::all::OP_CHECKMULTISIG)
        .into_script();

    DerivedKeys {
        priv_key_user,
        redeem_script,
    }
}

fn get_address(
    user_xpriv: &Xpriv,
    service_xpub: &Xpub,
    master_blinding_key: &MasterBlindingKey,
    network: Network,
    pointer: u32,
) -> elements::Address {
    let DerivedKeys {
        priv_key_user: _,
        redeem_script,
    } = derive_keys(user_xpriv, service_xpub, pointer);

    let script = elements::script::Builder::new()
        .push_int(0)
        .push_slice(&elements::WScriptHash::hash(redeem_script.as_bytes())[..])
        .into_script();

    let script_hash = elements::ScriptHash::hash(script.as_bytes());

    let address = elements::Address {
        params: network.d().elements_params,
        payload: elements::address::Payload::ScriptHash(script_hash),
        blinding_pubkey: None,
    };

    let blinder = master_blinding_key.blinding_key(secp2, &address.script_pubkey());

    address.to_confidential(blinder)
}

fn parse_gait_path(gait_path: &str) -> Result<Vec<u32>, Error> {
    let bytes =
        hex::decode(gait_path).map_err(|_| Error::ProtocolError("invalid gait_path hex"))?;
    verify!(
        bytes.len() % 2 == 0,
        Error::ProtocolError("invalid gait_path size")
    );
    let value = bytes
        .chunks(2)
        .map(|chunk| u32::from_be_bytes([0, 0, chunk[0], chunk[1]]))
        .collect();
    Ok(value)
}

fn derive_subaccount_xpriv(master_key: &Xpriv, subaccount: u32) -> Xpriv {
    // harden(3), harden(subaccount), 1
    let user_path = [
        ChildNumber::Hardened { index: 3 },
        ChildNumber::Hardened { index: subaccount },
    ];
    master_key
        .derive_priv(secp1, &user_path)
        .expect("should not fail")
}

fn derive_user_xpriv(master_key: &Xpriv, subaccount: u32) -> Xpriv {
    // harden(3), harden(subaccount), 1
    let user_path = [
        ChildNumber::Hardened { index: 3 },
        ChildNumber::Hardened { index: subaccount },
        ChildNumber::Normal { index: 1 },
    ];
    master_key
        .derive_priv(secp1, &user_path)
        .expect("should not fail")
}

fn derive_service_xpub(network: Network, gait_path: &str, subaccount: u32) -> Result<Xpub, Error> {
    let gait_path = parse_gait_path(gait_path)?;

    let root_xpub = Xpub {
        network: bitcoin::Network::Testnet,
        depth: 0,
        parent_fingerprint: Default::default(),
        child_number: 0.into(),
        public_key: network.d().service_pubkey.parse().expect("must be valid"),
        chain_code: network
            .d()
            .service_chain_code
            .parse()
            .expect("must be valid"),
    };

    let path_prefix = 3;
    let mut path = vec![path_prefix];
    path.extend_from_slice(&gait_path);
    path.push(subaccount);

    let path = path
        .into_iter()
        .map(Into::into)
        .collect::<Vec<ChildNumber>>();

    let mut subaccount_xpub = root_xpub.derive_pub(secp1, &path).expect("should not fail");
    subaccount_xpub.parent_fingerprint = Default::default();
    Ok(subaccount_xpub)
}

fn get_challenge_address(master_key: &Xpriv, network: Network) -> elements::Address {
    let pk = master_key.to_keypair(secp1).public_key();
    elements::Address::p2pkh(&pk.into(), None, network.d().elements_params)
}

async fn send(connection: &mut Connection, msg: Msg) -> Result<(), Error> {
    let msg = serde_json::to_string(&msg).expect("should not fail");
    log::debug!("send: {}", msg);
    connection.send(tungstenite::Message::Text(msg)).await?;
    Ok(())
}

async fn process_msg(data: &mut Data, msg: Msg) -> Result<(), Error> {
    match msg {
        Msg::Result {
            request, arguments, ..
        } => {
            if let Some(req) = data.pending_requests.remove(&request) {
                match arguments {
                    Some(arguments) => {
                        (req.callback)(data, Ok(arguments))?;
                    }
                    None => {
                        (req.callback)(data, Err(Error::ProtocolError("arguments is empty")))?;
                    }
                }
            }
            Ok(())
        }

        Msg::Error {
            typ,
            request,
            error,     // Example: com.greenaddress.error
            arguments, // Example: ["http://greenaddressit.com/error#sessionexpired","Session expired"]
            ..
        } => {
            match typ {
                wamp::message::SUBSCRIBE_ID => {
                    abort!(Error::ProtocolError("subscribe failed: {error}"))
                }
                wamp::message::UNSUBSCRIBE_ID => abort!(Error::WampError {
                    context: "unsubscribe failed",
                    error,
                }),
                wamp::message::CALL_ID => {
                    if let Some(req) = data.pending_requests.remove(&request) {
                        let args = arguments.ok_or(Error::ProtocolError("empty args"))?;
                        let (_error_url, error_text) = parse_args2::<String, String>(args)?;
                        (req.callback)(
                            data,
                            Err(Error::WampError {
                                context: "green backend",
                                error: error_text,
                            }),
                        )?;
                    } else {
                        log::error!("unknown request: {request}");
                    }
                }
                typ => {
                    log::error!("unknown response type: {typ}");
                }
            };

            Ok(())
        }

        Msg::Subscribed {
            request,
            subscription,
        } => {
            log::debug!("subscribed sucesfully, request: {request}, subscription: {subscription}");
            if let Some(callback) = data.pending_subscribe.remove(&request) {
                data.active_subscribe.insert(subscription, callback);
            }
            Ok(())
        }

        Msg::Unsubscribed { .. } => abort!(Error::ProtocolError(
            "unexpected unsubscribed event received"
        )),

        Msg::Event {
            subscription,
            publication: _,
            details: _,
            arguments,
            arguments_kw: _,
        } => {
            if let Some(callback) = data.active_subscribe.get(&subscription) {
                if let Some(arguments) = arguments {
                    callback(data, arguments)?;
                } else {
                    log::error!("arguments is empty in subscription");
                }
            } else {
                log::error!("unknown subscription received");
            }
            Ok(())
        }

        // Unsupported messages
        Msg::Welcome { .. } => abort!(Error::ProtocolError("unexpected welcome message received")),
        Msg::Hello { .. } => abort!(Error::ProtocolError("unexpected hello message received")),
        Msg::Abort { reason, .. } => abort!(Error::WampError {
            context: "abort message received",
            error: reason,
        }),
        Msg::Goodbye { reason, .. } => abort!(Error::WampError {
            context: "goodbye message received",
            error: reason,
        }),
        Msg::Call { .. } => abort!(Error::ProtocolError("unexpected call message received")),
        Msg::Subscribe { .. } => abort!(Error::ProtocolError(
            "unexpected subscribe message received"
        )),
        Msg::Unsubscribe { .. } => abort!(Error::ProtocolError(
            "unexpected unsubscribe message received"
        )),
    }
}

async fn process_ws_msg(data: &mut Data, msg: tungstenite::Message) -> Result<(), Error> {
    match msg {
        tungstenite::Message::Text(msg) => {
            log::debug!("recv: {}", msg);
            let msg = serde_json::from_str::<Msg>(&msg)
                .map_err(|err| Error::BackendJsonError(std::any::type_name::<Msg>(), err))?;
            process_msg(data, msg).await
        }
        tungstenite::Message::Binary(_) => {
            abort!(Error::ProtocolError("unexpected binary message received"))
        }
        tungstenite::Message::Ping(msg) => {
            data.connection
                .send(tungstenite::Message::Pong(msg))
                .await?;
            Ok(())
        }
        tungstenite::Message::Pong(_) => Ok(()),
        tungstenite::Message::Close(close) => {
            log::debug!("close event received: {close:?}");
            Ok(())
        }
        tungstenite::Message::Frame(_) => {
            abort!(Error::ProtocolError("unexpected frame message received"))
        }
    }
}

async fn get_wamp_msg(connection: &mut Connection) -> Result<Msg, Error> {
    loop {
        let ws_msg = match connection.next().await {
            Some(Ok(ws_msg)) => ws_msg,
            Some(Err(err)) => return Err(err.into()),
            None => abort!(Error::ProtocolError("connection closed unexpectedly")),
        };

        match ws_msg {
            tungstenite::Message::Text(data) => {
                log::debug!("recv: {}", data);
                let res = serde_json::from_str::<Msg>(&data)
                    .map_err(|err| Error::BackendJsonError("msg", err));
                return res;
            }
            tungstenite::Message::Binary(_) => {
                abort!(Error::ProtocolError("unexpected binary message received"));
            }
            tungstenite::Message::Ping(msg) => {
                connection.send(tungstenite::Message::Pong(msg)).await?;
            }
            tungstenite::Message::Pong(_) => {}
            tungstenite::Message::Close(close) => {
                log::debug!("close event received: {close:?}");
            }
            tungstenite::Message::Frame(_) => {
                abort!(Error::ProtocolError("unexpected frame message received"));
            }
        }
    }
}

async fn make_request(
    data: &mut Data,
    procedure: &str,
    args: WampArgs,
    callback: Callback,
) -> Result<(), Error> {
    let request = WampId::generate();

    let mut options = WampDict::new();
    options.insert("timeout".to_owned(), Arg::Integer(30000));

    send(
        &mut data.connection,
        Msg::Call {
            request,
            options,
            procedure: procedure.to_owned(),
            arguments: Some(args),
            arguments_kw: None,
        },
    )
    .await?;
    let old_request = data.pending_requests.insert(
        request,
        PendingRequest {
            callback,
            expires_at: Instant::now() + Duration::from_secs(60),
        },
    );
    assert!(old_request.is_none());
    Ok(())
}

async fn recv_addr_request(data: &mut Data, callback: Callback) -> Result<(), Error> {
    let return_pointer = true;
    let addr_type = "p2wsh";
    make_request(
        data,
        "com.greenaddress.vault.fund",
        vec![
            data.subaccount.into(),
            return_pointer.into(),
            addr_type.into(),
        ],
        callback,
    )
    .await
}

async fn process_command(data: &mut Data, command: Command) -> Result<(), Error> {
    match command {
        Command::ReceiveAddress(res_channel) => {
            recv_addr_request(
                data,
                Box::new(move |data, res| {
                    let res = res.and_then(|args| -> Result<elements::Address, Error> {
                        let address = parse_args1::<models::ReceiveAddress>(args)?;
                        let address = data.derive_address(address.pointer);
                        Ok(address)
                    });
                    let _ = res_channel.send(res);
                    Ok(())
                }),
            )
            .await
        }

        Command::UnspentOutputs(res_channel) => {
            let _ = res_channel.send(data.utxos.clone());
            Ok(())
        }

        Command::SignOrSendTx(transaction, blinding_nonces, sign_action, res_channel) => {
            let transaction = elements::encode::serialize_hex(&transaction);

            #[derive(serde::Serialize)]
            struct TwofacData {}
            let twofac_data = TwofacData {};
            let twofac_data = serde_json::to_value(twofac_data).expect("should not fail");

            #[derive(serde::Serialize)]
            struct PrivData {
                blinding_nonces: Vec<String>,
            }
            let priv_data = PrivData { blinding_nonces };
            let priv_data = serde_json::to_value(priv_data).expect("should not fail");

            #[derive(serde::Deserialize)]
            struct Output {
                // txhash: elements::Txid,
                tx: String,
            }

            let procedure = match sign_action {
                SignAction::SignOnly => "com.greenaddress.vault.sign_raw_tx",
                SignAction::SignAndSend => "com.greenaddress.vault.send_raw_tx",
            };
            make_request(
                data,
                procedure,
                vec![transaction.into(), twofac_data, priv_data],
                Box::new(move |_data, res| {
                    let res = res.and_then(|args| -> Result<elements::Transaction, Error> {
                        let output = parse_args1::<Output>(args)?;
                        let transaction = hex::decode(&output.tx)
                            .map_err(|_| Error::ProtocolError("invalid hex in tx"))?;
                        let transaction = elements::encode::deserialize(&transaction)
                            .map_err(|_| Error::ProtocolError("can't deserialize tx"))?;
                        Ok(transaction)
                    });
                    let _ = res_channel.send(res);
                    Ok(())
                }),
            )
            .await
        }

        Command::LoadTxs(timestamp, res_channel) => {
            make_request(
                data,
                "com.greenaddress.txs.get_list_v3",
                vec![data.subaccount.into(), timestamp.into()],
                Box::new(move |_data, res| {
                    let res = res.and_then(|args| -> Result<models::Transactions, Error> {
                        let transactions = parse_args1::<models::Transactions>(args)?;
                        Ok(transactions)
                    });
                    let _ = res_channel.send(res);
                    Ok(())
                }),
            )
            .await
        }

        Command::BlockHeight(res_channel) => {
            let _ = res_channel.send(Ok(data.block_height));
            Ok(())
        }
    }
}

async fn connect_ws(network: Network) -> Result<Connection, Error> {
    let url = match network {
        Network::Liquid => "wss://green-liquid-mainnet.blockstream.com/v2/ws",
        Network::LiquidTestnet => "wss://green-liquid-testnet.blockstream.com/v2/ws",
    };
    let url: url::Url = url.parse().expect("must be valid");
    let host = url.host().expect("must be set").to_string();

    let request = tungstenite::http::Request::builder()
        .uri(url.as_ref())
        .header("Host", host)
        .header("Connection", "Upgrade")
        .header("Upgrade", "websocket")
        .header("User-Agent", DEFAULT_AGENT_STR)
        .header("Sec-WebSocket-Version", "13")
        .header("Sec-WebSocket-Protocol", "wamp.2.json")
        .header(
            "Sec-WebSocket-Key",
            tungstenite::handshake::client::generate_key(),
        );

    let request = request.body(())?;

    let (connection, _resp) = tokio_tungstenite::connect_async(request).await?;

    Ok(connection)
}

async fn login(connection: &mut Connection) -> Result<(), Error> {
    let mut details = WampDict::new();
    let mut client_roles = WampDict::new();
    for role in [
        wamp::common::ClientRole::Subscriber,
        wamp::common::ClientRole::Publisher,
    ] {
        client_roles.insert(String::from(role.to_str()), Arg::Dict(WampDict::new()));
    }
    for role in [
        wamp::common::ClientRole::Caller,
        wamp::common::ClientRole::Callee,
    ] {
        let mut features = WampDict::new();
        features.insert("call_timeout".to_owned(), Arg::Bool(true));
        let mut options = WampDict::new();
        options.insert("features".to_owned(), Arg::Dict(features));
        client_roles.insert(String::from(role.to_str()), Arg::Dict(options));
    }
    details.insert("roles".to_owned(), Arg::Dict(client_roles));

    send(
        connection,
        Msg::Hello {
            realm: "realm1".to_owned(),
            details,
        },
    )
    .await?;

    let resp = get_wamp_msg(connection).await?;
    if let Msg::Welcome { session, .. } = resp {
        log::debug!("welcome message received, session: {session}");
    } else {
        abort!(Error::WampError {
            context: "unexpected response received",
            error: serde_json::to_string(&resp).expect("must not fail"),
        });
    }

    Ok(())
}

async fn get_challenge(
    connection: &mut Connection,
    master_key: &Xpriv,
    network: Network,
) -> Result<String, Error> {
    let challenge_address = get_challenge_address(master_key, network).to_string();
    let args = vec![challenge_address.into(), true.into()];

    let request_id = WampId::generate();

    send(
        connection,
        Msg::Call {
            request: request_id,
            options: WampDict::new(),
            procedure: "com.greenaddress.login.get_trezor_challenge".to_owned(),
            arguments: Some(args),
            arguments_kw: None,
        },
    )
    .await?;

    let resp = get_wamp_msg(connection).await?;
    let resp = match resp {
        Msg::Result {
            request, arguments, ..
        } => {
            verify!(
                request == request_id,
                Error::ProtocolError("unexpected request_id")
            );
            let args = arguments.ok_or(Error::ProtocolError("empty args"))?;
            parse_args1::<String>(args)?
        }
        Msg::Error { request, error, .. } => {
            verify!(
                request == request_id,
                Error::ProtocolError("unexpected request_id")
            );
            abort!(Error::WampError {
                context: "get_trezor_challenge call failed",
                error
            });
        }
        _ => abort!(Error::ProtocolError("unexpected response")),
    };

    Ok(resp)
}

struct AuthenticateResp {
    gait_path: String,
    wallet_id: String,
    amp_subaccount: Option<models::Subaccount>,
    block_height: u32,
    next_subaccount: u32,
}

const USER_AGENT_CAPS: &'static str = "[v2,sw,csv,csv_opt] sideswap_amp";

async fn authenticate(
    connection: &mut Connection,
    master_key: &Xpriv,
    challenge: &str,
) -> Result<Option<AuthenticateResp>, Error> {
    let login_path = vec![ChildNumber::from(0x4741b11e)];

    let login_xpriv = master_key
        .derive_priv(&secp1, &login_path)
        .expect("should not fail");
    let login_keypair = login_xpriv.to_keypair(secp1);
    let message = format!("greenaddress.it      login {}", challenge);
    let message_hash = bitcoin::sign_message::signed_msg_hash(&message);
    let message = bitcoin::secp256k1::Message::from_digest(message_hash.to_byte_array());
    let signature = secp1
        .sign_ecdsa(&message, &login_keypair.secret_key())
        .to_string();

    let args = vec![
        signature.into(),
        true.into(),
        "GA".into(),
        "".into(),
        USER_AGENT_CAPS.into(),
    ];

    let request_id = WampId::generate();

    send(
        connection,
        Msg::Call {
            request: request_id,
            options: WampDict::new(),
            procedure: "com.greenaddress.login.authenticate".to_owned(),
            arguments: Some(args),
            arguments_kw: None,
        },
    )
    .await?;

    let resp = get_wamp_msg(connection).await?;

    match resp {
        Msg::Result {
            request, arguments, ..
        } => {
            verify!(
                request == request_id,
                Error::ProtocolError("unexpected request_id")
            );
            let args = arguments.ok_or(Error::ProtocolError("empty response"))?;

            if args.get(0).and_then(|resp| resp.as_bool()) == Some(false) {
                log::debug!("login failed, not account found");
                return Ok(None);
            }

            let auth_res = parse_args1::<models::AuthenticateResult>(args)?;

            let next_subaccount = auth_res
                .subaccounts
                .iter()
                .map(|subaccount| subaccount.pointer)
                .max()
                .unwrap_or(0)
                + 1;

            let amp_subaccount = auth_res
                .subaccounts
                .into_iter()
                .find(|subaccount| subaccount.type_ == AMP_SUBACCOUNT_TYPE);

            log::info!("authenticaton succeed");
            Ok(Some(AuthenticateResp {
                gait_path: auth_res.gait_path,
                wallet_id: auth_res.receiving_id,
                amp_subaccount,
                block_height: auth_res.block_height,
                next_subaccount,
            }))
        }
        Msg::Error { request, error, .. } => {
            verify!(
                request == request_id,
                Error::ProtocolError("unexpected request_id")
            );
            abort!(Error::WampError {
                context: "login.authenticate call failed",
                error
            })
        }
        _ => abort!(Error::ProtocolError("unexpected response")),
    }
}

async fn create_subaccount(
    connection: &mut Connection,
    master_key: &Xpriv,
    pointer: u32,
) -> Result<String, Error> {
    let subaccount_xpriv = derive_subaccount_xpriv(master_key, pointer);
    let subaccount_xpub = Xpub::from_priv(secp1, &subaccount_xpriv).to_string();

    let xpubs: WampArgs = vec![subaccount_xpub.into()];
    let sigs: WampArgs = vec!["".into()];

    let args = vec![
        pointer.into(),
        AMP_SUBACCOUNT_DEFAULT_NAME.into(),
        AMP_SUBACCOUNT_TYPE.into(),
        xpubs.into(),
        sigs.into(),
    ];

    let request_id = WampId::generate();

    send(
        connection,
        Msg::Call {
            request: request_id,
            options: WampDict::new(),
            procedure: "com.greenaddress.txs.create_subaccount_v2".to_owned(),
            arguments: Some(args),
            arguments_kw: None,
        },
    )
    .await?;

    let resp = get_wamp_msg(connection).await?;

    match resp {
        Msg::Result {
            request, arguments, ..
        } => {
            verify!(
                request == request_id,
                Error::ProtocolError("unexpected request_id")
            );
            let args = arguments.ok_or(Error::ProtocolError("empty response"))?;
            let gaid = parse_args1::<String>(args)?;
            log::info!("AMP subaccount created");
            Ok(gaid)
        }
        Msg::Error { request, error, .. } => {
            verify!(
                request == request_id,
                Error::ProtocolError("unexpected request_id")
            );
            abort!(Error::WampError {
                context: "txs.create_subaccount_v2 call failed",
                error
            })
        }
        _ => abort!(Error::ProtocolError("unexpected response")),
    }
}

async fn register(connection: &mut Connection, master_key: &Xpriv) -> Result<(), Error> {
    let pubkey = hex::encode(&master_key.private_key.public_key(secp2).serialize());
    let chaincode = hex::encode(&master_key.chain_code.as_bytes());
    let ga_path = hex::encode(derive_ga_path(master_key));

    let args = vec![
        pubkey.into(),
        chaincode.into(),
        USER_AGENT_CAPS.into(),
        ga_path.into(),
    ];

    let request_id = WampId::generate();

    send(
        connection,
        Msg::Call {
            request: request_id,
            options: WampDict::new(),
            procedure: "com.greenaddress.login.register".to_owned(),
            arguments: Some(args),
            arguments_kw: None,
        },
    )
    .await?;

    let resp = get_wamp_msg(connection).await?;

    match resp {
        Msg::Result {
            request, arguments, ..
        } => {
            verify!(
                request == request_id,
                Error::ProtocolError("unexpected request_id")
            );
            let args = arguments.ok_or(Error::ProtocolError("empty response"))?;

            let register_res = parse_args1::<bool>(args)?;
            verify!(register_res, Error::ProtocolError("registration failed"));
            log::info!("registration succeed");
            Ok(())
        }
        Msg::Error { request, error, .. } => {
            verify!(
                request == request_id,
                Error::ProtocolError("unexpected request_id")
            );
            abort!(Error::WampError {
                context: "login.register call failed",
                error
            });
        }
        _ => abort!(Error::ProtocolError("unexpected response")),
    }
}

async fn subscribe(
    data: &mut Data,
    topic: WampString,
    callback: SubscribeCallback,
) -> Result<(), Error> {
    let request = WampId::generate();
    log::debug!("send subscribe request, request: {request}, topic: {topic}");

    let mut options = WampDict::new();
    options.insert("match".to_owned(), Arg::String("exact".to_owned()));

    send(
        &mut data.connection,
        Msg::Subscribe {
            request,
            options,
            topic,
        },
    )
    .await?;

    data.pending_subscribe.insert(request, callback);

    Ok(())
}

fn block_callback(data: &mut Data, args: WampArgs) -> Result<(), Error> {
    let block = parse_args1::<models::BlockEvent>(args)?;
    log::debug!("block callback: {block:?}");
    data.block_height = block.count;
    let _ = data.event_sender.send(Event::NewBlock {
        block_height: block.count,
    });
    Ok(())
}

fn tx_callback(data: &mut Data, args: WampArgs) -> Result<(), Error> {
    let tx = parse_args1::<models::TransactionEvent>(args)?;
    log::debug!("tx callback: {tx:?}");
    data.reload_utxos = true;
    let _ = data.event_sender.send(Event::NewTx { txid: tx.txhash });
    Ok(())
}

fn send_event(data: &mut Data, event: Event) {
    let res = data.event_sender.send(event);
    if res.is_err() {
        log::warn!("event sending failed");
    }
}

async fn reload_wallet_utxos(data: &mut Data) -> Result<(), Error> {
    let confs = 0u32;
    make_request(
        data,
        "com.greenaddress.txs.get_all_unspent_outputs",
        vec![confs.into(), data.subaccount.into()],
        Box::new(move |data, res| {
            let args = res?;
            let utxos = parse_args1::<Vec<models::Utxo>>(args)?;
            let utxos = data.unblind_utxos(utxos);

            let mut balances = BTreeMap::<AssetId, u64>::new();
            for utxo in utxos.iter() {
                *balances.entry(utxo.tx_out_sec.asset).or_default() += utxo.tx_out_sec.value;
            }
            send_event(data, Event::BalanceUpdated { balances });
            data.utxos = utxos;
            Ok(())
        }),
    )
    .await?;
    Ok(())
}

async fn request_timeout(reqs: &mut PendingRequests) -> PendingRequest {
    let (&wamp_id, req) = reqs
        .iter()
        .min_by_key(|req| req.1.expires_at)
        .expect("reqs can't be empty");
    let timeout = req.expires_at.saturating_duration_since(Instant::now());
    tokio::time::sleep(timeout).await;
    log::error!("request {wamp_id} timeout");
    reqs.remove(&wamp_id).expect("must be known")
}

async fn connection_check(data: &mut Data) -> Result<(), Error> {
    make_request(
        data,
        "com.greenaddress.addressbook.get_my_addresses",
        vec![data.subaccount.into()],
        Box::new(move |_data, res| {
            let _args = res?;
            log::debug!("connection check succeed");
            Ok(())
        }),
    )
    .await?;
    Ok(())
}

// TODO: Upload 20 CA addresses when AMP account is created
// TODO: Upload CA addresses periodically?
// TODO: Upload CA addresses if the server can't resolve our gaid?
async fn upload_ca_addresses(data: &mut Data, num: u32) -> Result<(), Error> {
    log::debug!("upload {num} ca addresses");
    for _ in 0..num {
        recv_addr_request(
            data,
            Box::new(move |data, res| {
                let address = parse_args1::<models::ReceiveAddress>(res?)?;
                let address = data.derive_address(address.pointer);
                data.ca_addresses.push(address);
                Ok(())
            }),
        )
        .await?;
    }
    Ok(())
}

async fn send_ca_addresses(data: &mut Data) -> Result<(), Error> {
    let addresses = std::mem::take(&mut data.ca_addresses);
    let addresses = addresses
        .into_iter()
        .map(|a| serde_json::Value::String(a.to_string()))
        .collect::<Vec<_>>();
    if !addresses.is_empty() {
        log::debug!("send {} ca addresses", addresses.len());
        make_request(
            data,
            "com.greenaddress.txs.upload_authorized_assets_confidential_address",
            vec![data.subaccount.into(), addresses.into()],
            Box::new(move |_data, res| {
                let success = parse_args1::<bool>(res?)?;
                verify!(
                    success,
                    Error::ProtocolError("uploading ca addresses failed")
                );
                Ok(())
            }),
        )
        .await?;
    }
    Ok(())
}

async fn processing_loop(
    data: &mut Data,
    command_receiver: &mut UnboundedReceiver<Command>,
) -> Result<(), Error> {
    // Prevent "Session expired"
    let mut connection_check_interval = tokio::time::interval(Duration::from_secs(3000));

    loop {
        if data.reload_utxos {
            reload_wallet_utxos(data).await?;
            data.reload_utxos = false;
        }

        if !data.ca_addresses.is_empty() && data.pending_requests.is_empty() {
            send_ca_addresses(data).await?;
        }

        tokio::select! {
            msg = data.connection.next() => {
                let msg = match msg {
                    Some(Ok(msg)) => msg,
                    Some(Err(err)) => return Err(err.into()),
                    None => return Ok(()),
                };
                process_ws_msg(data, msg).await?;
            }

            command = command_receiver.recv() => {
                let command = match command {
                    Some(command) => command,
                    None => return Ok(()),
                };
                process_command(data, command).await?;
            }

            req = request_timeout(&mut data.pending_requests), if !data.pending_requests.is_empty() => {
                (req.callback)(data, Err(Error::RequestTimeout))?;
                // Restart processing just in case
                abort!(Error::ProtocolError("disconnect because of request timeout"));
            }

            _ = connection_check_interval.tick() => {
                connection_check(data).await?;
            }
        }
    }
}

async fn connect(
    master_blinding_key: &MasterBlindingKey,
    master_key: &Xpriv,
    network: Network,
    command_receiver: &mut UnboundedReceiver<Command>,
    event_sender: UnboundedSender<Event>,
) -> Result<(), Error> {
    let mut connection = connect_ws(network).await?;

    login(&mut connection).await?;

    let challenge = get_challenge(&mut connection, &master_key, network).await?;
    log::debug!("got challenge: {challenge}");

    let auth_res = authenticate(&mut connection, &master_key, &challenge).await?;
    let AuthenticateResp {
        gait_path,
        wallet_id,
        amp_subaccount,
        block_height,
        next_subaccount,
    } = match auth_res {
        Some(auth) => {
            log::debug!("authentication succeed");
            auth
        }
        None => {
            log::debug!("authentication failed, try register...");
            register(&mut connection, master_key).await?;

            let challenge = get_challenge(&mut connection, &master_key, network).await?;
            log::debug!("got challenge: {challenge}");
            let auth_res = authenticate(&mut connection, &master_key, &challenge).await?;

            auth_res.ok_or(Error::ProtocolError(
                "login after registration failed unexpectedly",
            ))?
        }
    };

    let (subaccount, gaid, required_ca) = match amp_subaccount {
        Some(subaccount) => (
            subaccount.pointer,
            subaccount.receiving_id,
            subaccount.required_ca,
        ),
        None => {
            let new_gaid = create_subaccount(&mut connection, master_key, next_subaccount).await?;
            (next_subaccount, new_gaid, 20)
        }
    };

    let user_xpriv = derive_user_xpriv(&master_key, subaccount);

    let service_xpub = derive_service_xpub(network, &gait_path, subaccount)?;

    let mut data = Data {
        connection,
        pending_requests: BTreeMap::new(),
        network,
        master_blinding_key: master_blinding_key.clone(),
        subaccount,
        user_xpriv,
        service_xpub,
        event_sender,
        pending_subscribe: HashMap::new(),
        active_subscribe: HashMap::new(),
        utxos: Vec::new(),
        reload_utxos: true,
        ca_addresses: Vec::new(),
        block_height,
    };

    send_event(&mut data, Event::Connected { gaid, block_height });

    subscribe(
        &mut data,
        "com.greenaddress.blocks".to_owned(),
        block_callback,
    )
    .await?;

    subscribe(
        &mut data,
        format!("com.greenaddress.txs.wallet_{wallet_id}"),
        tx_callback,
    )
    .await?;

    upload_ca_addresses(&mut data, required_ca).await?;

    let res = processing_loop(&mut data, command_receiver).await;

    while let Some(req) = data.pending_requests.pop_first() {
        let _ = (req.1.callback)(&mut data, Err(Error::ProtocolError("connection closed")));
    }

    res
}

async fn run(
    master_blinding_key: MasterBlindingKey,
    master_key: Xpriv,
    network: Network,
    mut command_receiver: UnboundedReceiver<Command>,
    event_sender: UnboundedSender<Event>,
) {
    let mut retry_delay = RetryDelay::default();
    loop {
        let started = Instant::now();

        let res = connect(
            &master_blinding_key,
            &master_key,
            network,
            &mut command_receiver,
            event_sender.clone(),
        )
        .await;

        if Instant::now().duration_since(started) >= Duration::from_secs(60) {
            // Connection worked correctly for some time, no need to wait a lot before trying to restart
            retry_delay = RetryDelay::default();
        }

        if let Err(err) = res {
            log::error!("connection failed: {err}");
            let _ = event_sender.send(Event::Disconnected);
            tokio::time::sleep(retry_delay.next_delay()).await;
        }

        if command_receiver.is_closed() {
            return;
        }
    }
}

#[cfg(test)]
mod tests;
