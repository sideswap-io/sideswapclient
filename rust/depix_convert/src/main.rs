use anyhow::{anyhow, bail};
use elements::pset::PartiallySignedTransaction;
use elements::{AssetId, Txid};
use sideswap_api::mkt::{self, AssetPair, AssetType, TradeDir};
use sideswap_api::ResponseMessage;
use sideswap_common::ws::auto::WrappedResponse;
use sideswap_common::ws::ws_req_sender::WsReqSender;
use sideswap_common::{b64, make_market_request, ws};
use sideswap_dealer::utxo_data::UtxoData;
use std::path::PathBuf;
use std::sync::mpsc::{self, channel};
use std::time::Duration;
use tokio::sync::mpsc::unbounded_channel;

#[derive(Debug, serde::Deserialize)]
struct Settings {
    env: sideswap_common::env::Env,
    work_dir: PathBuf,
    mnemonic: bip39::Mnemonic,
    script_variant: sideswap_lwk::ScriptVariant,
    receive_address: elements::Address,
}

struct Data {
    settings: Settings,
    ws: WsReqSender,
    utxo_data: Option<UtxoData>,
    wallet_command_sender: mpsc::Sender<sideswap_lwk::Command>,
    policy_asset: AssetId,
    send_asset: AssetId,
}

fn process_wallet_event(data: &mut Data, event: sideswap_lwk::Event) {
    match event {
        sideswap_lwk::Event::Utxos { utxo_data } => {
            data.utxo_data = Some(utxo_data);
        }
    }
}

fn process_ws_notif(data: &mut Data, notif: mkt::Notification) {
    match notif {
        mkt::Notification::TxBroadcast(notif) => {
            data.wallet_command_sender
                .send(sideswap_lwk::Command::BroadcastTx { tx: notif.tx })
                .expect("must be open");
        }
        _ => {}
    }
}

fn process_ws_event(data: &mut Data, event: ws::auto::WrappedResponse) {
    match event {
        ws::auto::WrappedResponse::Connected => {}
        ws::auto::WrappedResponse::Disconnected => {}
        ws::auto::WrappedResponse::Response(sideswap_api::ResponseMessage::Notification(
            sideswap_api::Notification::Market(notif),
        )) => {
            process_ws_notif(data, notif);
        }
        ws::auto::WrappedResponse::Response(_) => {}
    }
}

fn need_start_quotes(data: &Data) -> bool {
    data.utxo_data
        .as_ref()
        .map(|utxo_data| {
            utxo_data
                .utxos()
                .iter()
                .any(|utxo| utxo.asset == data.send_asset)
        })
        .unwrap_or(false)
}

async fn new_recv_address(data: &Data) -> Result<elements::Address, anyhow::Error> {
    let (res_sender, res_receiver) = tokio::sync::oneshot::channel();
    data.wallet_command_sender
        .send(sideswap_lwk::Command::NewAdddress {
            res_sender: res_sender.into(),
        })?;
    let address = res_receiver.await??;
    Ok(address)
}

enum QuoteStatus {
    Disconnected,
    Timeout,
    Quote(mkt::QuoteNotif),
}

async fn try_make_swap(data: &mut Data) -> Result<Txid, anyhow::Error> {
    let utxo_data = data
        .utxo_data
        .as_ref()
        .ok_or_else(|| anyhow!("utxo_data is empty"))?;

    let asset_pair = AssetPair {
        base: data.policy_asset,
        quote: data.send_asset,
    };

    let utxos = utxo_data
        .utxos()
        .iter()
        .filter(|utxo| utxo.asset == data.send_asset)
        .cloned()
        .collect::<Vec<_>>();

    let send_amount = utxos.iter().map(|utxo| utxo.value).sum::<u64>();

    let receive_address = data.settings.receive_address.clone();
    let change_address = new_recv_address(data).await?;
    // assert!(receive_address != change_address);

    let start_quote_resp = make_market_request!(
        data.ws,
        StartQuotes,
        mkt::StartQuotesRequest {
            asset_pair,
            asset_type: AssetType::Quote,
            amount: send_amount,
            trade_dir: TradeDir::Sell,
            utxos,
            receive_address,
            change_address,
            order_id: None,
            private_id: None,
        }
    )?;

    let deadline = tokio::time::Instant::now() + Duration::from_secs(15);

    let status = loop {
        let res = tokio::time::timeout_at(deadline, data.ws.recv()).await;

        match res {
            Ok(resp) => {
                let status = match &resp {
                    WrappedResponse::Connected => None,
                    WrappedResponse::Disconnected => Some(QuoteStatus::Disconnected),
                    WrappedResponse::Response(ResponseMessage::Response(_, _)) => None,
                    WrappedResponse::Response(ResponseMessage::Notification(
                        sideswap_api::Notification::Market(mkt::Notification::Quote(quote)),
                    )) if quote.quote_sub_id == start_quote_resp.quote_sub_id => {
                        Some(QuoteStatus::Quote(quote.clone()))
                    }
                    WrappedResponse::Response(ResponseMessage::Notification(_)) => None,
                };

                process_ws_event(data, resp);

                if let Some(status) = status {
                    break status;
                }

                continue;
            }

            Err(_err) => break QuoteStatus::Timeout,
        };
    };

    let quote = match status {
        QuoteStatus::Disconnected => bail!("server disconnected"),
        QuoteStatus::Timeout => bail!("quote timeout"),
        QuoteStatus::Quote(quote) => quote,
    };

    let quote_id = match quote.status {
        mkt::QuoteStatus::Success {
            quote_id,
            base_amount: _,
            quote_amount: _,
            server_fee: _,
            fixed_fee: _,
            ttl: _,
        } => quote_id,

        mkt::QuoteStatus::LowBalance {
            base_amount: _,
            quote_amount: _,
            server_fee: _,
            fixed_fee: _,
            available: _,
        } => {
            bail!("unexpected LowBalance quote status");
        }

        mkt::QuoteStatus::Error { error_msg } => bail!("quote error: {error_msg}"),
    };

    let quote_resp = make_market_request!(data.ws, GetQuote, mkt::GetQuoteRequest { quote_id })?;

    let utxo_data = data
        .utxo_data
        .as_ref()
        .ok_or_else(|| anyhow!("utxo_data is empty"))?;

    let pset = b64::decode(&quote_resp.pset)?;
    let pset = elements::encode::deserialize::<PartiallySignedTransaction>(&pset)?;
    let pset = utxo_data.sign_pset(pset);
    let pset = elements::encode::serialize(&pset);
    let pset = b64::encode(&pset);

    let accept_resp =
        make_market_request!(data.ws, TakerSign, mkt::TakerSignRequest { quote_id, pset })?;

    Ok(accept_resp.txid)
}

fn stop_quotes(data: &mut Data) {
    data.ws
        .send_request(sideswap_api::Request::Market(mkt::Request::StopQuotes(
            mkt::StopQuotesRequest {},
        )));
}

async fn process_timer(data: &mut Data) {
    if need_start_quotes(data) {
        let res = try_make_swap(data).await;

        match res {
            Ok(txid) => log::info!("swap succeed, txid: {txid}"),
            Err(err) => log::debug!("swap failed: {err}"),
        }

        stop_quotes(data);
    }
}

#[tokio::main]
async fn main() {
    let args = std::env::args().collect::<Vec<_>>();
    assert!(
        args.len() == 2,
        "Specify a single argument for the path to the config file"
    );
    let config_path = &args[1];

    let mut conf = config::Config::new();
    conf.merge(config::File::with_name(config_path))
        .expect("can't load config");
    conf.merge(config::Environment::with_prefix("app").separator("_"))
        .expect("reading env failed");
    let settings: Settings = conf.try_into().expect("invalid config");

    sideswap_dealer::logs::init(&settings.work_dir);

    sideswap_common::panic_handler::install_panic_handler();

    let server_url = settings.env.base_server_ws_url();

    let (req_sender, req_receiver) =
        tokio::sync::mpsc::unbounded_channel::<ws::auto::WrappedRequest>();
    let (resp_sender, resp_receiver) =
        tokio::sync::mpsc::unbounded_channel::<ws::auto::WrappedResponse>();
    tokio::spawn(sideswap_common::ws::auto::run(
        server_url,
        req_receiver,
        resp_sender,
    ));
    let ws = WsReqSender::new(req_sender, resp_receiver);

    let network = settings.env.d().network;

    let (wallet_command_sender, wallet_command_receiver) = channel::<sideswap_lwk::Command>();
    let (wallet_event_sender, mut wallet_event_receiver) =
        unbounded_channel::<sideswap_lwk::Event>();
    let wallet_params = sideswap_lwk::Params {
        network,
        work_dir: settings.work_dir.clone(),
        mnemonic: settings.mnemonic.clone(),
        script_variant: settings.script_variant,
    };
    sideswap_lwk::start(wallet_params, wallet_command_receiver, wallet_event_sender);

    let term_signal = sideswap_dealer::signals::TermSignal::new();

    let mut data = Data {
        settings,
        ws,
        utxo_data: None,
        wallet_command_sender,
        policy_asset: network.d().policy_asset.asset_id(),
        send_asset: network.d().known_assets.DePix.asset_id(),
    };

    let mut interval = tokio::time::interval(Duration::from_secs(1));

    let address = new_recv_address(&data).await.expect("must not fail");
    log::info!("new receive address: {address}");
    println!("new receive address: {address}");

    loop {
        tokio::select! {
            event = wallet_event_receiver.recv() => {
                let event = event.expect("must be open");
                process_wallet_event(&mut data, event);
            },

            event = data.ws.recv() => {
                process_ws_event(&mut data, event);
            },

            _ = interval.tick() => {
                process_timer(&mut data).await;
            },

            _ = term_signal.recv() => {
                break;
            },
        }
    }
}
