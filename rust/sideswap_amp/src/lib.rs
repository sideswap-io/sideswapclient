use std::{
    collections::{BTreeMap, HashMap},
    time::{Duration, Instant},
};

use anyhow::{anyhow, bail, ensure, Context};
use bitcoin::{
    bip32::{ChildNumber, Xpriv, Xpub},
    hashes::Hash,
};
use elements::pset;
use elements_miniscript::slip77::MasterBlindingKey;
use futures::{SinkExt, StreamExt};
use secp256k1::global::SECP256K1 as secp1;
use secp256k1_zkp::global::SECP256K1 as secp2;
use tokio::sync::{
    mpsc::{UnboundedReceiver, UnboundedSender},
    oneshot,
};
use tokio_tungstenite::tungstenite;
use wamp::common::{WampArgs, WampString};

use crate::wamp::{
    common::{Arg, WampDict, WampId},
    message::Msg,
};

mod models;
mod wamp;

const DEFAULT_AGENT_STR: &str = "sideswap_amp";

#[derive(Debug)]
pub enum Event {
    Connected {
        gaid: String,
    },
    Disconnected,
    BalanceUpdated {
        balances: BTreeMap<elements::AssetId, u64>,
    },
}

#[derive(Copy, Clone)]
pub enum Network {
    Liquid,
    LiquidTestnet,
}

impl Network {
    fn network_params(self) -> &'static NetworkParams {
        match self {
            Network::Liquid => &NETWORK_PARAMS_LIQUID,
            Network::LiquidTestnet => &NETWORK_PARAMS_LIQUID_TESTNET,
        }
    }

    fn known_assets(self) -> sideswap_common::env::KnownAssetIds {
        match self {
            Network::Liquid => sideswap_common::env::Network::Mainnet.known_assets(),
            Network::LiquidTestnet => sideswap_common::env::Network::Testnet.known_assets(),
        }
    }
}

pub struct Wallet {
    command_sender: UnboundedSender<Command>,
    policy_asset: elements::AssetId,
}

enum Command {
    ReceiveAddress(oneshot::Sender<Result<elements::Address, anyhow::Error>>),
    UnspentOutputs(oneshot::Sender<Vec<Utxo>>),
    SignTx(
        elements::Transaction,
        Vec<String>,
        oneshot::Sender<Result<elements::Transaction, anyhow::Error>>,
    ),
}

fn convert_pubkey(pk: elements::secp256k1_zkp::PublicKey) -> bitcoin::PublicKey {
    bitcoin::PublicKey::new(pk)
}

#[derive(Debug)]
pub struct Recipient {
    pub address: elements::Address,
    pub asset_id: elements::AssetId,
    pub amount: u64,
}

fn parse_args1<T1: serde::de::DeserializeOwned>(mut args: WampArgs) -> Result<T1, anyhow::Error> {
    match &mut *args {
        [value] => {
            let value = serde_json::from_value::<T1>(std::mem::take(value)).with_context(|| {
                format!("parsing args failed for {}", std::any::type_name::<T1>())
            })?;
            Ok(value)
        }
        _ => bail!("unexpected arguments count, expected vector of 1"),
    }
}

impl Wallet {
    pub fn new(mnemonic: bip39::Mnemonic, network: Network) -> (Wallet, UnboundedReceiver<Event>) {
        let (command_sender, command_receiver) = tokio::sync::mpsc::unbounded_channel();
        let (event_sender, event_receiver) = tokio::sync::mpsc::unbounded_channel();

        tokio::spawn(run(mnemonic, network, command_receiver, event_sender));

        let wallet = Wallet {
            command_sender,
            policy_asset: network.known_assets().bitcoin,
        };

        (wallet, event_receiver)
    }

    pub fn policy_asset(&self) -> elements::AssetId {
        self.policy_asset
    }

    pub async fn receive_address(&self) -> Result<elements::Address, anyhow::Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.command_sender
            .send(Command::ReceiveAddress(res_sender))?;
        res_receiver.await?
    }

    pub async fn unspent_outputs(&self) -> Result<Vec<Utxo>, anyhow::Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.command_sender
            .send(Command::UnspentOutputs(res_sender))?;
        let utxos = res_receiver.await?;
        Ok(utxos)
    }

    pub async fn sign(
        &self,
        mut recipients: Vec<Recipient>,
    ) -> Result<elements::Transaction, anyhow::Error> {
        let utxos = self.unspent_outputs().await?;

        let mut pset = pset::PartiallySignedTransaction::new_v2();

        let mut output_amounts = BTreeMap::<elements::AssetId, u64>::new();
        for recipient in recipients.iter() {
            ensure!(recipient.amount > 0);
            let output_amount = output_amounts.entry(recipient.asset_id).or_default();
            *output_amount = output_amount
                .checked_add(recipient.amount)
                .ok_or_else(|| anyhow!("output amount overflow"))?;
        }

        let mut input_amounts = BTreeMap::<elements::AssetId, u64>::new();
        let mut used_utxos = Vec::new();
        for utxo in utxos.into_iter() {
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
                input.final_script_sig = Some(get_redeem_script(&utxo.redeem_script));
                input.redeem_script = Some(utxo.redeem_script.clone());
                input.witness_utxo = Some(utxo.txout.clone());
                pset.add_input(input);

                *input_amounts.entry(utxo.tx_out_sec.asset).or_default() += utxo.tx_out_sec.value;

                used_utxos.push(utxo);
            }
        }

        for (&asset_id, &output_amount) in output_amounts.iter() {
            if asset_id != self.policy_asset {
                let input_amount = input_amounts.get(&asset_id).copied().unwrap_or_default();
                ensure!(input_amount >= output_amount);
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
        ensure!(policy_asset_input >= policy_asset_output + network_fee);
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

        let mut tx = pset.extract_tx()?;
        let tx_copy = tx.clone();

        let mut sighash_cache = elements::sighash::SighashCache::new(&tx_copy);
        for (index, (tx_input, utxo)) in tx.input.iter_mut().zip(used_utxos.iter()).enumerate() {
            let green_dummy_sig = hex::decode("304402207f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f02207f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f01").unwrap();

            let hash_ty = elements_miniscript::elements::EcdsaSighashType::All;
            let sighash = sighash_cache.segwitv0_sighash(
                index,
                &utxo.redeem_script,
                utxo.txout.value,
                hash_ty,
            );
            let msg = elements::secp256k1_zkp::Message::from_digest_slice(&sighash[..]).unwrap();

            let user_sig = secp1.sign_ecdsa_low_r(&msg, &utxo.priv_key_user.inner);

            let user_sig = elements_miniscript::elementssig_to_rawsig(&(user_sig, hash_ty));

            tx_input.witness.script_witness = vec![
                vec![],
                green_dummy_sig,
                user_sig,
                utxo.redeem_script.to_bytes(),
            ];
        }

        let (res_sender, res_receiver) = oneshot::channel();
        self.command_sender
            .send(Command::SignTx(tx, blinding_nonces, res_sender))?;
        let val = res_receiver.await??;

        Ok(val)
    }
}

// If the callback returns an error, the wallet connection is restarted
type Callback =
    Box<dyn FnOnce(&mut Data, Result<WampArgs, anyhow::Error>) -> Result<(), anyhow::Error> + Send>;

// If the callback returns an error, the wallet connection is restarted
type SubscribeCallback = fn(&mut Data, WampArgs) -> Result<(), anyhow::Error>;

type Connection =
    tokio_tungstenite::WebSocketStream<tokio_tungstenite::MaybeTlsStream<tokio::net::TcpStream>>;

struct Data {
    connection: Connection,
    pending_requests: HashMap<WampId, Callback>,
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
}

#[derive(Clone, Debug)]
pub struct Utxo {
    pub pointer: u32,
    pub txout: elements::TxOut,
    pub outpoint: elements::OutPoint,
    pub tx_out_sec: elements::TxOutSecrets,
    pub priv_key_user: bitcoin::PrivateKey,
    pub redeem_script: elements::Script,
}

pub fn get_redeem_script(prevout_script: &elements::Script) -> elements::Script {
    elements::script::Builder::new()
        .push_slice(
            elements::script::Builder::new()
                .push_int(0)
                .push_slice(&elements::WScriptHash::hash(prevout_script.as_bytes())[..])
                .into_script()
                .as_bytes(),
        )
        .into_script()
}

impl Data {
    fn get_address(&self, pointer: u32) -> elements::Address {
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
                    redeem_script,
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

    let params = match network {
        Network::Liquid => &elements::AddressParams::LIQUID,
        Network::LiquidTestnet => &elements::AddressParams::LIQUID_TESTNET,
    };

    let address = elements::Address {
        params,
        payload: elements::address::Payload::ScriptHash(script_hash),
        blinding_pubkey: None,
    };

    let blinder = master_blinding_key.blinding_key(secp2, &address.script_pubkey());

    address.to_confidential(blinder)
}

struct NetworkParams {
    service_pubkey: &'static str,
    service_chain_code: &'static str,
}

const NETWORK_PARAMS_LIQUID: NetworkParams = NetworkParams {
    service_chain_code: "02721cc509aa0c2f4a90628e9da0391b196abeabc6393ed4789dd6222c43c489",
    service_pubkey: "02c408c3bb8a3d526103fb93246f54897bdd997904d3e18295b49a26965cb41b7f",
};

const NETWORK_PARAMS_LIQUID_TESTNET: NetworkParams = NetworkParams {
    service_chain_code: "c660eec6d9c536f4121854146da22e02d4c91d72af004d41729b9a592f0788e5",
    service_pubkey: "02c47d84a5b256ee3c29df89642d14b6ed73d17a2b8af0aca18f6f1900f1633533",
};

fn parse_gait_path(gait_path: &str) -> Result<Vec<u32>, anyhow::Error> {
    let bytes = hex::decode(gait_path)?;
    ensure!(bytes.len() % 2 == 0);
    let value = bytes
        .chunks(2)
        .map(|chunk| u32::from_be_bytes([0, 0, chunk[0], chunk[1]]))
        .collect();
    Ok(value)
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

fn derive_service_xpub(
    network: Network,
    gait_path: &str,
    subaccount: u32,
) -> Result<Xpub, anyhow::Error> {
    let gait_path = parse_gait_path(gait_path)?;

    let network_params = network.network_params();
    let root_xpub = Xpub {
        network: bitcoin::Network::Testnet,
        depth: 0,
        parent_fingerprint: Default::default(),
        child_number: 0.into(),
        public_key: network_params
            .service_pubkey
            .parse()
            .expect("must be valid"),
        chain_code: network_params
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
    let params = match network {
        Network::Liquid => &elements::AddressParams::LIQUID,
        Network::LiquidTestnet => &elements::AddressParams::LIQUID_TESTNET,
    };
    elements::Address::p2pkh(&pk.into(), None, params)
}

async fn send(connection: &mut Connection, msg: Msg) -> Result<(), anyhow::Error> {
    let msg = serde_json::to_string(&msg).expect("should not fail");
    log::debug!("send: {}", msg);
    connection.send(tungstenite::Message::Text(msg)).await?;
    Ok(())
}

async fn process_msg(data: &mut Data, msg: Msg) -> Result<(), anyhow::Error> {
    match msg {
        Msg::Result {
            request, arguments, ..
        } => {
            if let Some(callback) = data.pending_requests.remove(&request) {
                match arguments {
                    Some(arguments) => {
                        callback(data, Ok(arguments))?;
                    }
                    None => {
                        callback(data, Err(anyhow::anyhow!("arguments is empty")))?;
                    }
                }
            }
            Ok(())
        }

        Msg::Error {
            typ,
            request,
            error,
            ..
        } => {
            match typ {
                wamp::message::SUBSCRIBE_ID => bail!("subscribe failed: {error}"),
                wamp::message::UNSUBSCRIBE_ID => bail!("unsubscribe failed: {error}"),
                wamp::message::CALL_ID => {
                    if let Some(callback) = data.pending_requests.remove(&request) {
                        callback(data, Err(anyhow::anyhow!("request failed: {error}")))?;
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

        Msg::Unsubscribed { .. } => bail!("unexpected unsubscribed event received"),

        Msg::Event {
            subscription,
            publication: _,
            details: _,
            arguments,
            arguments_kw: _,
        } => {
            if let Some(callback) = data.active_subscribe.get(&subscription) {
                if let Some(arguments) = arguments {
                    callback(data, arguments).with_context(|| {
                        format!("subscription {subscription} processing failed")
                    })?;
                } else {
                    log::error!("arguments is empty in subscription");
                }
            } else {
                log::error!("unknown subscription received");
            }
            Ok(())
        }

        // Unsupported messages
        Msg::Welcome { .. } => bail!("unexpected welcome message received"),
        Msg::Hello { .. } => bail!("unexpected hello message received"),
        Msg::Abort { reason, .. } => bail!("abort message received: {reason}"),
        Msg::Goodbye { reason, .. } => bail!("goodbye message received: {reason}"),
        Msg::Call { .. } => bail!("unexpected call message received"),
        Msg::Subscribe { .. } => bail!("unexpected subscribe message received"),
        Msg::Unsubscribe { .. } => bail!("unexpected unsubscribe message received"),
    }
}

async fn process_ws_msg(data: &mut Data, msg: tungstenite::Message) -> Result<(), anyhow::Error> {
    match msg {
        tungstenite::Message::Text(msg) => {
            log::debug!("recv: {}", msg);
            let msg = serde_json::from_str::<Msg>(&msg)?;
            process_msg(data, msg).await
        }
        tungstenite::Message::Binary(_) => {
            anyhow::bail!("unexpected binary message received");
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
            anyhow::bail!("unexpected frame message received");
        }
    }
}

async fn get_wamp_msg(connection: &mut Connection) -> Result<Msg, anyhow::Error> {
    loop {
        let ws_msg = match connection.next().await {
            Some(Ok(ws_msg)) => ws_msg,
            Some(Err(err)) => return Err(err.into()),
            None => bail!("connection closed unexpectedly"),
        };

        match ws_msg {
            tungstenite::Message::Text(data) => {
                log::debug!("recv: {}", data);
                let msg = serde_json::from_str::<Msg>(&data)?;
                return Ok(msg);
            }
            tungstenite::Message::Binary(_) => {
                anyhow::bail!("unexpected binary message received");
            }
            tungstenite::Message::Ping(msg) => {
                connection.send(tungstenite::Message::Pong(msg)).await?;
            }
            tungstenite::Message::Pong(_) => {}
            tungstenite::Message::Close(close) => {
                log::debug!("close event received: {close:?}");
            }
            tungstenite::Message::Frame(_) => {
                anyhow::bail!("unexpected frame message received");
            }
        }
    }
}

async fn make_request(
    data: &mut Data,
    procedure: &str,
    args: WampArgs,
    callback: Callback,
) -> Result<(), anyhow::Error> {
    let request = WampId::generate();

    let mut options = WampDict::new();
    options.insert("timeout".to_owned(), Arg::Integer(10000));

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
    let old_request = data.pending_requests.insert(request, callback);
    assert!(old_request.is_none());
    Ok(())
}

async fn process_command(data: &mut Data, command: Command) -> Result<(), anyhow::Error> {
    match command {
        Command::ReceiveAddress(res_channel) => {
            make_request(
                data,
                "com.greenaddress.vault.fund",
                vec![data.subaccount.into(), true.into(), "p2wsh".into()],
                Box::new(move |data, res| {
                    let res = res.and_then(|args| -> Result<elements::Address, anyhow::Error> {
                        let address = parse_args1::<models::ReceiveAddress>(args)?;
                        let address = data.get_address(address.pointer);
                        Ok(address)
                    });
                    let _ = res_channel.send(res);
                    Ok(())
                }),
            )
            .await?;

            Ok(())
        }

        Command::UnspentOutputs(res_channel) => {
            let _ = res_channel.send(data.utxos.clone());
            Ok(())
        }

        Command::SignTx(transaction, blinding_nonces, res_channel) => {
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

            make_request(
                data,
                "com.greenaddress.vault.sign_raw_tx",
                vec![transaction.into(), twofac_data, priv_data],
                Box::new(move |_data, res| {
                    let res =
                        res.and_then(|args| -> Result<elements::Transaction, anyhow::Error> {
                            let output = parse_args1::<Output>(args)?;
                            let transaction = hex::decode(&output.tx)?;
                            let transaction = elements::encode::deserialize(&transaction)?;
                            Ok(transaction)
                        });
                    let _ = res_channel.send(res);
                    Ok(())
                }),
            )
            .await?;

            Ok(())
        }
    }
}

async fn connect_ws(network: Network) -> Result<Connection, anyhow::Error> {
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

async fn login(connection: &mut Connection) -> Result<(), anyhow::Error> {
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
        bail!("unexpected response received: {resp:?}");
    }

    Ok(())
}

async fn get_challenge(
    connection: &mut Connection,
    master_key: &Xpriv,
    network: Network,
) -> Result<String, anyhow::Error> {
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
            ensure!(request == request_id);
            // FIXME: Fix unwrap
            arguments.unwrap()[0].as_str().unwrap().to_owned()
        }
        Msg::Error { request, error, .. } => {
            ensure!(request == request_id);
            bail!("get_trezor_challenge call failed: {}", error)
        }
        _ => bail!("unexpected response"),
    };

    Ok(resp)
}

struct AuthenticateResp {
    gait_path: String,
    wallet_id: String,
    gaid: String,
    subaccount: u32,
}

async fn authenticate(
    connection: &mut Connection,
    master_key: &Xpriv,
    challenge: &str,
) -> Result<AuthenticateResp, anyhow::Error> {
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
        "[v2,sw,csv,csv_opt]".into(),
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
            ensure!(request == request_id);
            let args = arguments.ok_or_else(|| anyhow!("empty response"))?;
            let auth_res = parse_args1::<models::AuthenticateResult>(args)?;
            let subaccount = auth_res
                .subaccounts
                .into_iter()
                .find(|subaccount| subaccount.type_ == "2of2_no_recovery")
                .ok_or_else(|| anyhow!("can't find 2of2_no_recovery subaccount"))?;
            log::info!("authenticaton succeed");
            Ok(AuthenticateResp {
                gait_path: auth_res.gait_path,
                wallet_id: auth_res.receiving_id,
                gaid: subaccount.receiving_id,
                subaccount: subaccount.pointer,
            })
        }
        Msg::Error { request, error, .. } => {
            ensure!(request == request_id);
            bail!("login.authenticate call failed: {}", error)
        }
        _ => bail!("unexpected response"),
    }
}

async fn subscribe(
    data: &mut Data,
    topic: WampString,
    callback: SubscribeCallback,
) -> Result<(), anyhow::Error> {
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

fn block_callback(_data: &mut Data, args: WampArgs) -> Result<(), anyhow::Error> {
    let block = parse_args1::<models::BlockEvent>(args)?;
    log::debug!("block callback: {block:?}");
    Ok(())
}

fn tx_callback(data: &mut Data, args: WampArgs) -> Result<(), anyhow::Error> {
    let tx = parse_args1::<models::TransactionEvent>(args)?;
    log::debug!("tx callback: {tx:?}");
    data.reload_utxos = true;
    Ok(())
}

fn send_event(data: &mut Data, event: Event) {
    let res = data.event_sender.send(event);
    if res.is_err() {
        log::warn!("event sending failed");
    }
}

async fn reload_wallet_utxos(data: &mut Data) -> Result<(), anyhow::Error> {
    let confs = 0u32;
    make_request(
        data,
        "com.greenaddress.txs.get_all_unspent_outputs",
        vec![confs.into(), data.subaccount.into()],
        Box::new(move |data, res| {
            let args = res?;
            let utxos = parse_args1::<Vec<models::Utxo>>(args)?;
            let utxos = data.unblind_utxos(utxos);

            let mut balances = BTreeMap::<elements::AssetId, u64>::new();
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

async fn connect(
    mnemonic: &bip39::Mnemonic,
    network: Network,
    command_receiver: &mut UnboundedReceiver<Command>,
    event_sender: UnboundedSender<Event>,
) -> Result<(), anyhow::Error> {
    let bitcoin_network = match network {
        Network::Liquid => bitcoin::Network::Bitcoin,
        Network::LiquidTestnet => bitcoin::Network::Testnet,
    };

    let seed = mnemonic.to_seed("");
    let master_blinding_key = MasterBlindingKey::from_seed(&seed);
    let master_key = Xpriv::new_master(bitcoin_network, &seed)?;

    let mut connection = connect_ws(network).await?;

    login(&mut connection).await?;

    let challenge = get_challenge(&mut connection, &master_key, network).await?;
    log::debug!("got challenge: {challenge}");

    let AuthenticateResp {
        gait_path,
        wallet_id,
        gaid,
        subaccount,
    } = authenticate(&mut connection, &master_key, &challenge).await?;
    log::debug!("authentication succeed");

    let user_xpriv = derive_user_xpriv(&master_key, subaccount);

    let service_xpub = derive_service_xpub(network, &gait_path, subaccount)?;

    let mut data = Data {
        connection,
        pending_requests: HashMap::new(),
        network,
        master_blinding_key,
        subaccount,
        user_xpriv,
        service_xpub,
        event_sender,
        pending_subscribe: HashMap::new(),
        active_subscribe: HashMap::new(),
        utxos: Vec::new(),
        reload_utxos: true,
    };

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

    send_event(&mut data, Event::Connected { gaid });

    loop {
        if data.reload_utxos {
            reload_wallet_utxos(&mut data).await?;
            data.reload_utxos = false;
        }

        tokio::select! {
            msg = data.connection.next() => {
                let msg = match msg {
                    Some(Ok(msg)) => msg,
                    Some(Err(err)) => return Err(err.into()),
                    None => return Ok(()),
                };
                process_ws_msg(&mut data, msg).await?;
            }

            command = command_receiver.recv() => {
                let command = match command {
                    Some(command) => command,
                    None => return Ok(()),
                };
                process_command(&mut data, command).await?;
            }
        }
    }
}

const DELAYS: [Duration; 6] = [
    Duration::from_secs(5),
    Duration::from_secs(10),
    Duration::from_secs(15),
    Duration::from_secs(30),
    Duration::from_secs(45),
    Duration::from_secs(60),
];

/// Returns a value sampled from an exponential distribution with a mean of 1.0
pub fn exponential_rand() -> f64 {
    -rand::random::<f64>().ln()
}

async fn run(
    mnemonic: bip39::Mnemonic,
    network: Network,
    mut command_receiver: UnboundedReceiver<Command>,
    event_sender: UnboundedSender<Event>,
) {
    let mut failed_count = 0;
    loop {
        let started = Instant::now();

        let res = connect(
            &mnemonic,
            network,
            &mut command_receiver,
            event_sender.clone(),
        )
        .await;

        if Instant::now().duration_since(started) < Duration::from_secs(60) {
            failed_count += 1;
        } else {
            failed_count = 0;
        }

        if let Err(err) = res {
            log::error!("connection failed: {err}");
            let _ = event_sender.send(Event::Disconnected);
            let delay = DELAYS
                .get(failed_count)
                .unwrap_or(DELAYS.last().expect("is not empty"));
            let randomized_delay = delay.mul_f64(exponential_rand());
            tokio::time::sleep(randomized_delay).await;
        }

        if command_receiver.is_closed() {
            return;
        }
    }
}

#[cfg(test)]
mod tests;
