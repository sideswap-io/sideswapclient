use std::sync::mpsc::{channel, Sender};
use std::time::Duration;

use sideswap_api::market::AssetPair;
use sideswap_common::channel_helpers::UncheckedUnboundedSender;
use sideswap_dealer::utxo_data::UtxoData;
use sideswap_dealer::{market, price_stream, utxo_data};
use tokio::sync::mpsc::unbounded_channel;

mod wallet;

#[derive(Debug, serde::Deserialize)]
struct Settings {
    env: sideswap_common::env::Env,
    work_dir: String,
    mnemonic: bip39::Mnemonic,
    web_server: Option<market::WebServerConfig>,
    price_stream: price_stream::Config,
}

struct Data {
    market_command_sender: UncheckedUnboundedSender<market::Command>,
    wallet_command_sender: Sender<wallet::Command>,
    utxo_data: UtxoData,
    price_stream: price_stream::Data,
}

fn process_wallet_event(data: &mut Data, event: wallet::Event) {
    match event {
        wallet::Event::Utxos { utxo_data } => {
            data.market_command_sender.send(market::Command::Utxos {
                utxos: utxo_data.utxos().to_vec(),
            });
            data.utxo_data = utxo_data;
        }
        wallet::Event::Address { address } => data
            .market_command_sender
            .send(market::Command::NewAddress { address }),
    }
}

fn process_market_event(data: &mut Data, event: market::Event) {
    match event {
        market::Event::SignSwap { quote_id, pset } => {
            log::info!("sign swap, quote_id: {}", quote_id.value());

            let pset = data.utxo_data.sign_pset(pset);

            data.market_command_sender
                .send(market::Command::SignedSwap { quote_id, pset });
        }

        market::Event::GetNewAddress => {
            data.wallet_command_sender
                .send(wallet::Command::NewAdddress)
                .expect("must be open");
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
    }
}

fn process_timer(data: &mut Data) {
    data.market_command_sender
        .send(market::Command::AutomaticOrders {
            orders: data.price_stream.market_prices(),
        });
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

    log::info!("started");

    sideswap_common::panic_handler::install_panic_handler();

    let network = settings.env.d().network;

    let market_params = market::Params {
        env: settings.env,
        server_url: settings.env.base_server_ws_url(),
        work_dir: settings.work_dir.clone(),
        web_server: settings.web_server.clone(),
    };
    let (market_command_sender, mut market_event_receiver) = market::start(market_params);

    let (wallet_command_sender, wallet_command_receiver) = channel::<wallet::Command>();
    let (wallet_event_sender, mut wallet_event_receiver) = unbounded_channel::<wallet::Event>();
    let wallet_params = wallet::Params {
        network,
        work_dir: settings.work_dir.clone(),
        mnemonic: settings.mnemonic.clone(),
    };
    wallet::start(wallet_params, wallet_command_receiver, wallet_event_sender);

    let price_stream = price_stream::Data::new(settings.env, settings.price_stream.clone());

    let mut data = Data {
        market_command_sender: market_command_sender.into(),
        wallet_command_sender,
        utxo_data: UtxoData::new(utxo_data::Params {
            confifential_only: true,
        }),
        price_stream,
    };

    let mut interval = tokio::time::interval(Duration::from_secs(1));

    loop {
        tokio::select! {
             event = wallet_event_receiver.recv() => {
                 let event = event.expect("must be open");
                 process_wallet_event(&mut data, event);
            },

            event = market_event_receiver.recv() => {
                let event = event.expect("channel must be open");
                process_market_event(&mut data, event);
            },

            _ = data.price_stream.run() => {}

            _ = interval.tick() => {
                process_timer(&mut data);
            },
        }
    }
}
