use std::time::Duration;

use serde::Deserialize;
use sideswap_api::market::AssetPair;
use sideswap_common::channel_helpers::UncheckedUnboundedSender;
use sideswap_dealer::{
    dealer_rpc, market, price_stream,
    rpc::{self, RpcServer},
    utxo_data::{self, UtxoData},
};

#[derive(Debug, Deserialize)]
struct Settings {
    env: sideswap_common::env::Env,
    #[serde(default)]
    disable_new_swaps: bool,
    work_dir: String,
    rpc: RpcServer,
    api_key: Option<String>,
    web_server: Option<market::WebServerConfig>,
    ws_server: Option<market::WsServerConfig>,
    price_stream: price_stream::Config,
}

struct Data {
    settings: Settings,
    dealer_sender: UncheckedUnboundedSender<dealer_rpc::Command>,
    market_command_sender: UncheckedUnboundedSender<market::Command>,
    utxo_data: UtxoData,
    price_stream: price_stream::Data,
}

fn process_dealer_event(data: &mut Data, event: dealer_rpc::Event) {
    match event {
        dealer_rpc::Event::Swap(swap) => {
            log::info!(
                "swap succeed, bitcoin_amount: {}",
                swap.bitcoin_amount.to_bitcoin()
            );
        }
        dealer_rpc::Event::ServerConnected(_) => {}
        dealer_rpc::Event::ServerDisconnected(_) => {}
        dealer_rpc::Event::Utxos(utxo_data, _unspent) => {
            data.utxo_data = utxo_data;

            data.market_command_sender.send(market::Command::Utxos {
                utxos: data.utxo_data.utxos().to_vec(),
            });
        }
    }
}

fn process_market_event(data: &mut Data, event: market::Event) {
    match event {
        market::Event::SignSwap { quote_id, pset } => {
            let pset = data.utxo_data.sign_pset(pset);
            data.market_command_sender
                .send(market::Command::SignedSwap { quote_id, pset });
        }

        market::Event::GetNewAddress => {
            let rpc_server = data.settings.rpc.clone();
            let command_sender = data.market_command_sender.clone();
            tokio::spawn(async move {
                let address = rpc::make_rpc_call(&rpc_server, rpc::GetNewAddressCall {})
                    .await
                    .expect("getting new address failed");
                command_sender.send(market::Command::NewAddress { address });
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
    }
}

fn process_timer(data: &mut Data) {
    for update in data.price_stream.dealer_prices() {
        data.dealer_sender.send(dealer_rpc::Command::Price(update));
    }

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

    let server_url = settings.env.base_server_ws_url();

    let params = dealer_rpc::Params {
        env: settings.env,
        server_url: server_url.clone(),
        rpc: settings.rpc.clone(),
        api_key: settings.api_key.clone(),
    };
    let (dealer_sender, mut dealer_receiver) = dealer_rpc::spawn_async(params);

    let market_params = market::Params {
        env: settings.env,
        disable_new_swaps: settings.disable_new_swaps,
        server_url,
        work_dir: settings.work_dir.clone(),
        web_server: settings.web_server.clone(),
        ws_server: settings.ws_server.clone(),
    };
    let (market_command_sender, mut market_event_receiver) = market::start(market_params);

    let price_stream = price_stream::Data::new(settings.env, settings.price_stream.clone());

    let mut data = Data {
        settings,
        dealer_sender: dealer_sender.into(),
        market_command_sender: market_command_sender.into(),
        utxo_data: UtxoData::new(utxo_data::Params {
            confifential_only: true,
        }),
        price_stream,
    };

    let mut interval = tokio::time::interval(Duration::from_secs(1));

    loop {
        tokio::select! {
            event = dealer_receiver.recv() => {
                let event = event.expect("channel must be open");
                process_dealer_event(&mut data, event);
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