use std::time::Duration;

use anyhow::{bail, ensure};
use base64::Engine;
use elements::{pset::PartiallySignedTransaction, TxOutSecrets};
use network_fee::expected_network_fee;

use crate::{
    pset::{PsetInput, PsetOutput},
    server_api::{SignResponse, StartResponse},
};

pub mod network_fee;
pub mod pset;
pub mod server_api;

pub const BASE_URL_PROD: &str = "https://api.sideswap.io";
pub const BASE_URL_TESTNET: &str = "https://api-testnet.sideswap.io";

pub struct CreatePayjoin {
    pub base_url: String,
    pub user_agent: String,
    pub asset_id: elements::AssetId,
    pub amount: u64,
    pub address: elements::Address,
    pub subtract_fee_from_amount: bool,
    pub change_address: elements::Address,
    pub utxos: Vec<server_api::Utxo>,
}

pub struct CreatedPayjoin {
    pub pset: PartiallySignedTransaction,
    pub asset_fee: u64,
}

pub fn create_payjoin(req: CreatePayjoin) -> Result<CreatedPayjoin, anyhow::Error> {
    let CreatePayjoin {
        base_url,
        user_agent,
        asset_id: send_asset_id,
        amount: send_amount,
        address: send_address,
        subtract_fee_from_amount,
        change_address: client_change_address,
        utxos: client_utxos,
    } = req;

    ensure!(!client_utxos.is_empty());
    ensure!(client_utxos
        .iter()
        .all(|utxo| utxo.asset_id == req.asset_id));
    ensure!(send_address.is_blinded());
    ensure!(client_change_address.is_blinded());
    ensure!(send_address.params == client_change_address.params);
    ensure!(send_amount > 0);

    let agent: ureq::Agent = ureq::AgentBuilder::new()
        .timeout(Duration::from_secs(30))
        .build();

    let url = format!("{base_url}/payjoin");

    let req = server_api::Request::Start(server_api::StartRequest {
        asset_id: send_asset_id,
        user_agent,
        api_key: None,
    });
    let resp = make_server_request(&agent, &url, req)?;
    let StartResponse {
        order_id,
        expires_at: _,
        fee_address,
        change_address: server_change_address,
        utxos: server_utxos,
        price,
        fixed_fee,
    } = match resp {
        server_api::Response::Start(resp) => resp,
        _ => bail!("unexpected response {resp:?}"),
    };

    ensure!(send_address.params == fee_address.params);
    ensure!(send_address.params == server_change_address.params);
    ensure!(fee_address.is_blinded());
    ensure!(server_change_address.is_blinded());
    ensure!(!server_utxos.is_empty());

    let max_input_count = client_utxos.len() + server_utxos.len();
    let max_output_count = 4; // asset output, asset change, asset fee output, server change

    // FIXME: Separate between single-sig and multi-sig inputs
    let max_network_fee = expected_network_fee(max_input_count, 0, max_output_count);
    println!("max_network_fee: {max_network_fee}");

    let max_asset_fee = fixed_fee + (price * max_network_fee as f64).round() as u64;

    let send_amount = if subtract_fee_from_amount {
        ensure!(send_amount > max_asset_fee);
        send_amount - max_asset_fee
    } else {
        send_amount
    };

    let lbtc_asset_id = server_utxos.first().unwrap().asset_id;

    let mut selected_utxos = Vec::new();

    let mut utxo_asset_amount = 0;
    for utxo in client_utxos.into_iter() {
        utxo_asset_amount += utxo.value;
        selected_utxos.push(utxo);
        if utxo_asset_amount >= send_amount + max_asset_fee {
            break;
        }
    }

    let mut utxo_lbtc_amount = 0;
    for utxo in server_utxos.into_iter() {
        utxo_lbtc_amount += utxo.value;
        selected_utxos.push(utxo);
        if utxo_lbtc_amount >= max_network_fee {
            break;
        }
    }

    ensure!(utxo_asset_amount >= send_amount + max_asset_fee);
    ensure!(utxo_lbtc_amount >= max_network_fee);

    let ConstructedPset { blinded_pset } = construct_pset(ConstructPsetArgs {
        selected_utxos,
        send_address,
        send_asset_id,
        send_amount,
        fee_address,
        fixed_fee,
        price,
        client_change_address,
        utxo_asset_amount,
        utxo_lbtc_amount,
        server_change_address,
        lbtc_asset_id,
    })?;

    let server_pset = pset::remove_explicit_values(blinded_pset.clone());
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

    let pset = pset::copy_signatures(blinded_pset, server_signed_pset)?;

    Ok(CreatedPayjoin {
        pset,
        asset_fee: max_asset_fee,
    })
}

pub fn final_tx(
    pset_client: PartiallySignedTransaction,
    pset_server: PartiallySignedTransaction,
) -> Result<elements::Transaction, anyhow::Error> {
    let pset = pset::copy_signatures(pset_client, pset_server)?;
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

struct ConstructPsetArgs {
    selected_utxos: Vec<server_api::Utxo>,
    send_address: elements::Address,
    send_asset_id: elements::AssetId,
    send_amount: u64,
    fee_address: elements::Address,
    fixed_fee: u64,
    price: f64,
    client_change_address: elements::Address,
    utxo_asset_amount: u64,
    utxo_lbtc_amount: u64,
    server_change_address: elements::Address,
    lbtc_asset_id: elements::AssetId,
}

struct ConstructedPset {
    blinded_pset: PartiallySignedTransaction,
}

fn construct_pset(args: ConstructPsetArgs) -> Result<ConstructedPset, anyhow::Error> {
    let ConstructPsetArgs {
        selected_utxos,
        send_address,
        send_asset_id,
        send_amount,
        fee_address,
        fixed_fee,
        price,
        client_change_address,
        utxo_asset_amount,
        utxo_lbtc_amount,
        server_change_address,
        lbtc_asset_id,
    } = args;

    let mut pset = PartiallySignedTransaction::new_v2();
    let mut input_secrets = Vec::new();

    for utxo in selected_utxos.into_iter() {
        let input = crate::pset::pset_input(PsetInput {
            txid: utxo.txid,
            vout: utxo.vout,
            script_pub_key: utxo.script_pub_key.clone(),
            asset_commitment: utxo.asset_commitment.into(),
            value_commitment: utxo.value_commitment.into(),
        });

        pset.add_input(input);

        input_secrets.push(TxOutSecrets {
            asset: utxo.asset_id,
            asset_bf: utxo.asset_bf,
            value: utxo.value,
            value_bf: utxo.value_bf,
        });
    }

    pset.add_output(crate::pset::pset_output(PsetOutput {
        address: send_address,
        asset: send_asset_id,
        amount: send_amount,
    })?);

    // FIXME: Separate between single-sig and multi-sig inputs
    let network_fee = expected_network_fee(pset.inputs().len(), 0, 4);

    let asset_fee = fixed_fee + (price * network_fee as f64).round() as u64;

    pset.add_output(crate::pset::pset_output(PsetOutput {
        address: fee_address,
        asset: send_asset_id,
        amount: asset_fee,
    })?);

    let asset_change_amount = utxo_asset_amount - send_amount - asset_fee;
    if asset_change_amount > 0 {
        pset.add_output(crate::pset::pset_output(PsetOutput {
            address: client_change_address,
            asset: send_asset_id,
            amount: asset_change_amount,
        })?);
    }

    let lbtc_change_amount = utxo_lbtc_amount - network_fee;
    if lbtc_change_amount > 0 {
        pset.add_output(crate::pset::pset_output(PsetOutput {
            address: server_change_address,
            asset: lbtc_asset_id,
            amount: lbtc_change_amount,
        })?);
    }

    pset.add_output(crate::pset::pset_network_fee(lbtc_asset_id, network_fee));

    let pset = crate::pset::randomize_and_blind_pset(pset, &input_secrets)?;

    Ok(ConstructedPset { blinded_pset: pset })
}
