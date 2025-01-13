use std::sync::Arc;
use std::time::Duration;

use elements::pset::PartiallySignedTransaction;
use sideswap_api::mkt::AssetPair;
use sideswap_api::{AssetBlindingFactor, ValueBlindingFactor};
use sideswap_common::channel_helpers::UncheckedUnboundedSender;
use sideswap_dealer::{market, price_stream};

#[derive(Debug, serde::Deserialize)]
struct Settings {
    env: sideswap_common::env::Env,
    #[serde(default)]
    disable_new_swaps: bool,
    work_dir: String,
    mnemonic: bip39::Mnemonic,
    web_server: Option<market::WebServerConfig>,
    ws_server: Option<market::WsServerConfig>,
    price_stream: price_stream::Config,
}

struct Data {
    wallet: Arc<sideswap_amp::Wallet>,
    market_command_sender: UncheckedUnboundedSender<market::Command>,
    sync_utxos: bool,
    price_stream: price_stream::Data,
}

async fn sign_swap(
    wallet: &sideswap_amp::Wallet,
    pset: PartiallySignedTransaction,
) -> Result<PartiallySignedTransaction, anyhow::Error> {
    let all_utxos = wallet.unspent_outputs().await?;
    let pset = wallet.user_sign_swap_pset(pset, all_utxos)?;
    Ok(pset)
}

fn process_wallet_event(data: &mut Data, event: sideswap_amp::Event) {
    match event {
        sideswap_amp::Event::Connected {
            gaid,
            block_height: _,
        } => {
            log::debug!("wallet connected, gaid: {gaid}");
            data.market_command_sender
                .send(market::Command::Gaid { gaid });
            data.sync_utxos = true;
        }
        sideswap_amp::Event::Disconnected => {}
        sideswap_amp::Event::BalanceUpdated { balances } => {
            log::debug!("balance updated: {balances:?}");
            data.sync_utxos = true;
        }
        sideswap_amp::Event::NewBlock { .. } => {}
        sideswap_amp::Event::NewTx { .. } => {
            data.sync_utxos = true;
        }
    }
}

async fn process_market_event(data: &mut Data, event: market::Event) {
    match event {
        market::Event::SignSwap { quote_id, pset } => {
            log::info!("sign swap, quote_id: {}", quote_id.value());

            let wallet = Arc::clone(&data.wallet);
            let market_command_sender = data.market_command_sender.clone();

            tokio::spawn(async move {
                let res = sign_swap(&wallet, pset).await;

                match res {
                    Ok(pset) => {
                        market_command_sender.send(market::Command::SignedSwap { quote_id, pset });
                    }
                    Err(err) => {
                        log::error!("swap sign failed: {err}");
                    }
                }
            });
        }

        market::Event::NewAddress { res_sender } => {
            let wallet = Arc::clone(&data.wallet);
            tokio::spawn(async move {
                let res = wallet
                    .receive_address()
                    .await
                    .map_err(|err| anyhow::anyhow!("loading address failed: {err}"));
                res_sender.send(res);
            });
        }

        market::Event::SwapSucceed {
            asset_pair: AssetPair { base, quote },
            trade_dir,
            base_amount,
            quote_amount,
            price,
            txid,
        } => {
            log::info!("market swap, base: {base}, quote: {quote}, base amount: {base_amount}, quote amount: {quote_amount}, price: {price}, txid: {txid}, trade_dir: {trade_dir:?}");
        }

        market::Event::BroadcastTx { tx } => {
            let wallet = Arc::clone(&data.wallet);
            tokio::spawn(async move {
                let res = wallet.broadcast_tx(tx).await;
                match res {
                    Ok(txid) => log::debug!("tx broadcast succeed: {txid}"),
                    Err(err) => log::error!("tx broadcast failed: {err}"),
                }
            });
        }
    }
}

async fn sync_utxos(data: &mut Data) -> Result<(), anyhow::Error> {
    let utxos = data.wallet.unspent_outputs().await?;

    let utxos = utxos
        .into_iter()
        .filter(|utxo| {
            utxo.tx_out_sec.asset_bf != AssetBlindingFactor::zero()
                && utxo.tx_out_sec.value_bf != ValueBlindingFactor::zero()
        })
        .map(|utxo| sideswap_api::Utxo {
            txid: utxo.outpoint.txid,
            vout: utxo.outpoint.vout,
            asset: utxo.tx_out_sec.asset,
            asset_bf: utxo.tx_out_sec.asset_bf,
            value: utxo.tx_out_sec.value,
            value_bf: utxo.tx_out_sec.value_bf,
            redeem_script: Some(utxo.redeem_script),
        })
        .collect();

    data.market_command_sender
        .send(market::Command::Utxos { utxos });

    Ok(())
}

async fn process_timer(data: &mut Data) {
    data.market_command_sender
        .send(market::Command::AutomaticOrders {
            orders: data.price_stream.market_prices(),
        });

    if data.sync_utxos {
        let res = sync_utxos(data).await;

        match res {
            Ok(()) => {
                log::debug!("utxo sync succeed");
                data.sync_utxos = false;
            }
            Err(err) => {
                log::error!("utxo sync failed: {err}");
            }
        }
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

    let network = settings.env.d().network;

    let (wallet, mut wallet_events) = sideswap_amp::Wallet::new(settings.mnemonic.clone(), network);

    let market_params = market::Params {
        env: settings.env,
        disable_new_swaps: settings.disable_new_swaps,
        server_url: settings.env.base_server_ws_url(),
        work_dir: settings.work_dir.clone(),
        web_server: settings.web_server.clone(),
        ws_server: settings.ws_server.clone(),
    };
    let (market_command_sender, mut market_event_receiver) = market::start(market_params);

    let price_stream = price_stream::Data::new(settings.env, settings.price_stream.clone());

    let mut data = Data {
        wallet: Arc::new(wallet),
        market_command_sender: market_command_sender.into(),
        sync_utxos: false,
        price_stream,
    };

    let mut interval = tokio::time::interval(Duration::from_secs(1));

    let term_signal = sideswap_dealer::signals::TermSignal::new();

    loop {
        tokio::select! {
            event = wallet_events.recv() => {
                let event = event.expect("must be open");
                process_wallet_event(&mut data, event);
            },

            event = market_event_receiver.recv() => {
                let event = event.expect("channel must be open");
                process_market_event(&mut data, event).await;
            },

            _ = data.price_stream.run() => {}

            _ = interval.tick() => {
                process_timer(&mut data).await;
            },

            _ = term_signal.recv() => {
                break;
            },
        }
    }
}
