use std::time::Duration;

use anyhow::{bail, ensure};
use base64::Engine;
use elements::{pset::PartiallySignedTransaction, secp256k1_zkp::SECP256K1, AssetId, TxOutSecrets};
use sideswap_common::{
    network::Network,
    recipient::Recipient,
    send_tx::{
        coin_select::{self, InOut},
        pset::{construct_pset, ConstructPsetArgs, ConstructedPset, PsetInput, PsetOutput},
    },
};

use crate::server_api::{SignResponse, StartResponse};

pub mod server_api;

pub const BASE_URL_PROD: &str = "https://api.sideswap.io";
pub const BASE_URL_TESTNET: &str = "https://api-testnet.sideswap.io";

pub struct Utxo {
    pub txid: elements::Txid,
    pub vout: u32,
    pub asset_id: elements::AssetId,
    pub value: u64,
    pub asset_bf: elements::confidential::AssetBlindingFactor,
    pub value_bf: elements::confidential::ValueBlindingFactor,
    pub script_pub_key: elements::script::Script,
}

pub struct CreatePayjoin {
    pub network: Network,
    pub base_url: String,
    pub user_agent: String,
    pub utxos: Vec<Utxo>,
    pub multisig_wallet: bool,
    pub use_all_utxos: bool,
    pub recipients: Vec<Recipient>,
    pub deduct_fee: Option<usize>,
    pub fee_asset: AssetId,
}

#[derive(Clone)]
pub struct CreatedPayjoin {
    pub pset: PartiallySignedTransaction,
    pub blinding_nonces: Vec<String>,
    pub asset_fee: u64,
    pub network_fee: u64,
}

pub trait Wallet {
    fn change_address(&mut self) -> Result<elements::Address, anyhow::Error>;
}

fn take_utxos<'a>(
    mut utxos: Vec<Utxo>,
    required: impl Iterator<Item = &'a InOut>,
) -> Vec<PsetInput> {
    let mut selected = Vec::new();
    for required in required {
        let index = utxos
            .iter()
            .position(|utxo| utxo.asset_id == required.asset_id && utxo.value == required.value)
            .expect("must exists");
        let utxo = utxos.remove(index);

        let (asset_commitment, value_commitment) = if utxo.asset_bf
            == elements::confidential::AssetBlindingFactor::zero()
            || utxo.value_bf == elements::confidential::ValueBlindingFactor::zero()
        {
            (
                elements::confidential::Asset::Explicit(utxo.asset_id),
                elements::confidential::Value::Explicit(utxo.value),
            )
        } else {
            let gen = elements::secp256k1_zkp::Generator::new_blinded(
                SECP256K1,
                utxo.asset_id.into_tag(),
                utxo.asset_bf.into_inner(),
            );
            (
                elements::confidential::Asset::Confidential(gen),
                elements::confidential::Value::new_confidential(
                    SECP256K1,
                    utxo.value,
                    gen,
                    utxo.value_bf,
                ),
            )
        };

        let input = PsetInput {
            txid: utxo.txid,
            vout: utxo.vout,
            script_pub_key: utxo.script_pub_key,
            asset_commitment,
            value_commitment,
            tx_out_sec: TxOutSecrets {
                asset: utxo.asset_id,
                asset_bf: utxo.asset_bf,
                value: utxo.value,
                value_bf: utxo.value_bf,
            },
        };
        selected.push(input);
    }
    selected
}

pub fn create_payjoin(
    wallet: &mut impl Wallet,
    req: CreatePayjoin,
) -> Result<CreatedPayjoin, anyhow::Error> {
    let CreatePayjoin {
        network,
        base_url,
        user_agent,
        utxos: client_utxos,
        multisig_wallet,
        use_all_utxos,
        recipients,
        deduct_fee,
        fee_asset,
    } = req;

    ensure!(!client_utxos.is_empty());
    ensure!(recipients.iter().all(|r| r.address.is_blinded()));
    ensure!(recipients.iter().all(|r| r.amount > 0));

    let agent: ureq::Agent = ureq::AgentBuilder::new()
        .timeout(Duration::from_secs(30))
        .build();

    let url = format!("{base_url}/payjoin");

    let req = server_api::Request::Start(server_api::StartRequest {
        asset_id: fee_asset,
        user_agent,
        api_key: None,
    });
    let resp = make_server_request(&agent, &url, req)?;
    let StartResponse {
        order_id,
        expires_at: _,
        fee_address: server_fee_address,
        change_address: server_change_address,
        utxos: server_utxos,
        price,
        fixed_fee,
    } = match resp {
        server_api::Response::Start(resp) => resp,
        _ => bail!("unexpected response {resp:?}"),
    };

    ensure!(server_fee_address.is_blinded());
    ensure!(server_change_address.is_blinded());
    ensure!(!server_utxos.is_empty());

    let policy_asset = network.d().policy_asset.asset_id();
    let coin_select::payjoin::Res {
        user_inputs,
        client_inputs,
        server_inputs,
        user_outputs,
        change_outputs,
        server_fee,
        server_change,
        fee_change,
        network_fee,
        cost: _,
    } = coin_select::payjoin::try_coin_select(coin_select::payjoin::Args {
        multisig_wallet,
        policy_asset,
        fee_asset,
        price,
        fixed_fee,
        use_all_utxos,
        wallet_utxos: client_utxos
            .iter()
            .map(|utxo| InOut {
                asset_id: utxo.asset_id,
                value: utxo.value,
            })
            .collect(),
        server_utxos: server_utxos
            .iter()
            .map(|utxo| InOut {
                asset_id: utxo.asset_id,
                value: utxo.value,
            })
            .collect(),
        user_outputs: recipients
            .iter()
            .map(|r| InOut {
                asset_id: r.asset_id,
                value: r.amount,
            })
            .collect(),
        deduct_fee,
    })?;

    let mut inputs = Vec::new();
    let mut outputs = Vec::new();

    let server_utxos = server_utxos
        .into_iter()
        .map(|utxo| Utxo {
            txid: utxo.txid,
            vout: utxo.vout,
            asset_id: utxo.asset_id,
            value: utxo.value,
            asset_bf: utxo.asset_bf,
            value_bf: utxo.value_bf,
            script_pub_key: utxo.script_pub_key,
        })
        .collect::<Vec<_>>();

    inputs.append(&mut take_utxos(
        client_utxos,
        user_inputs.iter().chain(client_inputs.iter()),
    ));
    inputs.append(&mut take_utxos(server_utxos, server_inputs.iter()));

    for (output, recipient) in user_outputs.iter().zip(recipients.into_iter()) {
        // Use corrected amount if deduct_fee was set
        outputs.push(PsetOutput {
            asset_id: output.asset_id,
            amount: output.value,
            address: recipient.address,
        });
    }

    for output in change_outputs.iter().chain(fee_change.iter()) {
        let address = wallet.change_address()?;
        outputs.push(PsetOutput {
            asset_id: output.asset_id,
            amount: output.value,
            address,
        });
    }

    outputs.push(PsetOutput {
        asset_id: server_fee.asset_id,
        amount: server_fee.value,
        address: server_fee_address,
    });

    if let Some(output) = server_change {
        outputs.push(PsetOutput {
            asset_id: output.asset_id,
            amount: output.value,
            address: server_change_address,
        });
    }

    let ConstructedPset {
        blinded_pset,
        blinding_nonces,
    } = construct_pset(ConstructPsetArgs {
        policy_asset,
        offlines: Vec::new(),
        inputs,
        outputs,
        network_fee: network_fee.value,
    })?;

    let mut server_pset = blinded_pset.clone();
    sideswap_common::pset_blind::remove_explicit_values(&mut server_pset);
    let server_pset = elements::encode::serialize(&server_pset);

    let req = server_api::Request::Sign(server_api::SignRequest {
        order_id,
        pset: base64::engine::general_purpose::STANDARD.encode(server_pset),
    });
    let resp = make_server_request(&agent, &url, req)?;
    let SignResponse {
        pset: server_signed_pset,
    } = match resp {
        server_api::Response::Sign(resp) => resp,
        _ => bail!("unexpected response {resp:?}"),
    };
    let server_signed_pset = elements::encode::deserialize::<PartiallySignedTransaction>(
        &base64::engine::general_purpose::STANDARD.decode(server_signed_pset)?,
    )?;

    let pset = copy_signatures(blinded_pset, server_signed_pset)?;

    Ok(CreatedPayjoin {
        pset,
        blinding_nonces,
        asset_fee: server_fee.value,
        network_fee: network_fee.value,
    })
}

fn copy_signatures(
    mut dst: PartiallySignedTransaction,
    src: PartiallySignedTransaction,
) -> Result<PartiallySignedTransaction, anyhow::Error> {
    ensure!(dst.inputs().len() == src.inputs().len());
    ensure!(dst.outputs().len() == src.outputs().len());
    for (dst, src) in dst.inputs_mut().iter_mut().zip(src.inputs().iter()) {
        if src.final_script_witness.is_some() {
            dst.final_script_sig = src.final_script_sig.clone();
            dst.final_script_witness = src.final_script_witness.clone();
        }
    }
    Ok(dst)
}

pub fn final_tx(
    pset_client: PartiallySignedTransaction,
    pset_server: PartiallySignedTransaction,
) -> Result<elements::Transaction, anyhow::Error> {
    let pset = copy_signatures(pset_client, pset_server)?;
    let tx = pset.extract_tx()?;
    Ok(tx)
}

fn make_server_request(
    agent: &ureq::Agent,
    url: &str,
    req: server_api::Request,
) -> Result<server_api::Response, anyhow::Error> {
    let res = agent.post(url).send_json(req);

    match res {
        Ok(resp) => {
            let resp = resp.into_json::<server_api::Response>()?;
            Ok(resp)
        }
        Err(ureq::Error::Transport(err)) => {
            bail!("unexpected HTTP transport error: {err}");
        }
        Err(ureq::Error::Status(400, resp)) => {
            let err = resp.into_json::<server_api::Error>()?.error;
            bail!("unexpected server error: {err}");
        }
        Err(ureq::Error::Status(status, resp)) => {
            let err = resp.into_string()?;
            bail!("unexpected HTTP status: {status}: {err}");
        }
    }
}
