//! Old instant swaps API (deprecated)

use crate::rpc::ListUnspent;
use crate::types::{dealer_ticker_from_asset_id, dealer_ticker_to_asset_id, DealerTicker};
use crate::utxo_data::{self, UtxoData, UtxoWithKey};

use super::rpc;
use elements::pset::PartiallySignedTransaction;
use elements::OutPoint;
use log::{debug, error, info, warn};
use serde::{Deserialize, Serialize};
use sideswap_api::{Asset, *};
use sideswap_common::network::Network;
use sideswap_common::types::Amount;
use sideswap_common::ws::auto::WrappedResponse;
use sideswap_common::ws::ws_req_sender::WsReqSender;
use sideswap_common::{b64, make_request, ws};
use std::collections::{BTreeMap, BTreeSet};
use std::time::Duration;
use tokio::sync::mpsc::{unbounded_channel, UnboundedReceiver, UnboundedSender};

// Keep some extra amount in the wallet for the various fees (server, network, external exchange)
const INSTANT_SWAP_WORK_AMOUNT: f64 = 0.995;

const PRICE_EXPIRATON_TIME: std::time::Duration = std::time::Duration::from_secs(60);

#[derive(Debug, Clone)]
pub struct Params {
    pub env: sideswap_common::env::Env,

    pub server_url: String,

    pub rpc: rpc::RpcServer,

    pub api_key: Option<String>,
}

#[derive(Serialize, Deserialize, Debug, Clone, Copy, PartialEq)]
pub struct DealerPrice {
    /// Instant and regular submit swaps
    pub submit_price: PricePair,

    /// Maximum amount of LBTC the dealer is allowed to receive to own wallet (in one swap)
    pub limit_btc_dealer_recv: f64,

    /// Maximum amount of LBTC the dealer is allowed to send from own wallet (in one swap)
    pub limit_btc_dealer_send: f64,

    /// Instant swaps balancing flag to let users know
    pub balancing: bool,
}

pub struct UpdatePrice {
    pub ticker: DealerTicker,
    pub price: Option<DealerPrice>,
}

pub struct ToLimitBalance {
    pub ticker: DealerTicker,
    pub recv_limit: bool,
    pub balance: f64,
}

pub enum Command {
    Price(UpdatePrice),
    ResetPrices(Empty),
    IndexPriceUpdate(PriceUpdateBroadcast),
}

pub enum Event {
    Swap(SwapSucceed),
    ServerConnected(Empty),
    ServerDisconnected(Empty),
    Utxos(UtxoData, ListUnspent),
}

enum Internal {
    Timer,
    ReloadUtxo,
}

#[derive(Debug)]
pub struct SwapSucceed {
    pub txid: elements::Txid,
    pub ticker: DealerTicker,
    pub bitcoin_amount: sideswap_common::types::Amount,
    pub dealer_send_bitcoins: bool,
}

#[derive(Clone, Debug)]
pub struct Utxo {
    pub item: rpc::UnspentItem,
    pub amount: i64,
}

pub type Utxos = BTreeMap<OutPoint, Utxo>;

pub type WalletBalances = BTreeMap<DealerTicker, f64>;
pub type DealerPrices = BTreeMap<DealerTicker, DealerPriceTimestamp>;

#[derive(Clone, Copy, PartialEq, Debug)]
pub struct DealerPriceTimestamp {
    pub dealer: DealerPrice,
    pub timestamp: std::time::Instant,
}

pub fn apply_interest(price: &PricePair, interest: f64) -> PricePair {
    // Limit to 10% as sanity check
    assert!((1.0..=1.1).contains(&interest));
    PricePair {
        bid: price.bid / interest,
        ask: price.ask * interest,
    }
}

pub fn pick_price(price: &PricePair, send_bitcoins: bool) -> f64 {
    if send_bitcoins {
        price.ask
    } else {
        price.bid
    }
}

struct InstantSwap {
    _send_asset: AssetId,
}

struct Data {
    network: Network,
    policy_asset: AssetId,
    params: Params,
    ws: WsReqSender,
    assets: Vec<Asset>,
    server_connected: bool,
    utxos: Utxos,
    wallet_balances: WalletBalances,
    dealer_prices: DealerPrices,
    wallet_balance: Option<rpc::GetWalletInfo>,
    instant_swaps: BTreeMap<OrderId, InstantSwap>,
    event_sender: UnboundedSender<Event>,
    internal_sender: UnboundedSender<Internal>,
    utxo_data: UtxoData,
}

async fn process_timer(data: &mut Data) {
    for (ticker, dealer_price) in data.dealer_prices.iter() {
        let base_price = dealer_price.dealer.submit_price;

        // Correct price for the server fee on instant swaps
        let submit_price = apply_interest(
            &base_price,
            1.0 + sideswap_common::pset::INSTANT_SWAPS_SERVER_FEE,
        );

        let wallet_asset_amount = data
            .wallet_balances
            .get(ticker)
            .copied()
            .unwrap_or_default();
        let wallet_btc_amount = data
            .wallet_balances
            .get(&DealerTicker::LBTC)
            .copied()
            .unwrap_or_default();

        let mut list = PriceOffers::default();
        let max_send_asset_amount = f64::min(
            wallet_btc_amount * submit_price.ask,
            dealer_price.dealer.limit_btc_dealer_send * submit_price.ask,
        ) * INSTANT_SWAP_WORK_AMOUNT;
        let max_send_bitcoin_amount = f64::min(
            dealer_price.dealer.limit_btc_dealer_recv,
            wallet_asset_amount / submit_price.bid,
        ) * INSTANT_SWAP_WORK_AMOUNT;
        if max_send_asset_amount > 0.0 {
            list.push(PriceOffer {
                client_send_bitcoins: false,
                price: submit_price.ask,
                max_send_amount: Amount::from_bitcoin(max_send_asset_amount).to_sat(),
            });
        }
        if max_send_bitcoin_amount > 0.0 {
            list.push(PriceOffer {
                client_send_bitcoins: true,
                price: submit_price.bid,
                max_send_amount: Amount::from_bitcoin(max_send_bitcoin_amount).to_sat(),
            });
        }

        if data.server_connected && data.params.api_key.is_some() {
            let asset_id = dealer_ticker_to_asset_id(data.network, *ticker);
            let price_stream = BroadcastPriceStreamRequest {
                asset: asset_id,
                list,
                balancing: dealer_price.dealer.balancing,
            };
            let broadcast_price_resp = make_request!(data.ws, BroadcastPriceStream, price_stream);
            if let Err(e) = broadcast_price_resp {
                error!("broadcast price failed: {}", e);
            }
        }
    }

    let wallet_result = rpc::make_rpc_call(&data.params.rpc, rpc::GetWalletInfoCall {}).await;
    match wallet_result {
        Ok(v) => {
            if data.wallet_balance.as_ref() != Some(&v) {
                data.wallet_balance = Some(v);
                data.internal_sender.send(Internal::ReloadUtxo).unwrap();
            }
        }
        Err(e) => error!("wallet balance loading failed: {}", e),
    }

    let now = std::time::Instant::now();
    let expired = data
        .dealer_prices
        .iter()
        .filter(|(_, price)| now.duration_since(price.timestamp) > PRICE_EXPIRATON_TIME)
        .map(|(ticker, _)| *ticker)
        .collect::<Vec<_>>();
    for ticker in expired {
        warn!("remove expired ticker: {ticker}");
        data.dealer_prices.remove(&ticker);
    }
}

async fn process_ws_notif(data: &mut Data, msg: Notification) {
    match msg {
        Notification::StartSwapDealer(swap_notif) => {
            info!("start instant swap, order_id: {}", swap_notif.order_id);
            let inputs: Vec<_> = data
                .utxos
                .values()
                .filter(|utxo| {
                    utxo.item.asset == swap_notif.send_asset
                        && utxo.item.amountblinder != ValueBlindingFactor::zero()
                        && utxo.item.assetblinder != AssetBlindingFactor::zero()
                })
                .map(|utxo| sideswap_api::Utxo {
                    txid: utxo.item.txid,
                    vout: utxo.item.vout,
                    asset: utxo.item.asset,
                    asset_bf: utxo.item.assetblinder,
                    value: utxo.item.amount.to_sat(),
                    value_bf: utxo.item.amountblinder,
                    redeem_script: utxo.item.redeem_script.clone(),
                })
                .collect();

            let recv_addr = rpc::make_rpc_call(&data.params.rpc, rpc::GetNewAddressCall {})
                .await
                .expect("getting new address failed");
            let change_addr = rpc::make_rpc_call(&data.params.rpc, rpc::GetNewAddressCall {})
                .await
                .expect("getting new address failed");

            let start_swap_dealer_resp = make_request!(
                data.ws,
                StartSwapDealer,
                StartSwapDealerRequest {
                    order_id: swap_notif.order_id,
                    inputs,
                    recv_addr,
                    change_addr,
                }
            );
            if let Err(e) = start_swap_dealer_resp {
                error!("starting swap failed: {}", e);
            }

            data.instant_swaps.insert(
                swap_notif.order_id,
                InstantSwap {
                    _send_asset: swap_notif.send_asset,
                },
            );
        }

        Notification::BlindedSwapDealer(swap_notif) => {
            info!("got blinded pset, order_id: {}", swap_notif.order_id);
            let pset = b64::decode(&swap_notif.pset).expect("must not fail");
            let pset = elements::encode::deserialize::<PartiallySignedTransaction>(&pset)
                .expect("parsing pset failed");

            // TODO: Verify amounts
            // let recv_output = tx
            //     .output
            //     .iter()
            //     .filter(|output| output.script_pubkey == swap.recv_addr.script_pubkey())
            //     .filter_map(|output| {
            //         output.unblind(&secp, swap.recv_addr_blinding_key).ok()
            //     })
            //     .find(|output| {
            //         debug!(
            //             "unblinded recv output, amount: {}, asset: {}",
            //             output.value, output.asset
            //         );
            //         output.value == swap.recv_amount as u64
            //             && output.asset
            //                 == elements::AssetId::from_slice(&swap.recv_asset.0)
            //                     .unwrap()
            //     });
            // if recv_output.is_none() {
            //     error!("can't find own output for swap {}", data.order_id);
            //     continue;
            // }
            //assert!(recv_output.is_some());

            let pset = data.utxo_data.sign_pset(pset);

            let pset = elements::encode::serialize(&pset);
            let signed_swap_resp = make_request!(
                data.ws,
                SignedSwapDealer,
                SignedSwapDealerRequest {
                    order_id: swap_notif.order_id,
                    pset: b64::encode(&pset),
                }
            );
            if let Err(e) = signed_swap_resp {
                error!("starting swap failed: {}", e);
            }
        }

        Notification::SwapDone(swap) => {
            debug!("instant swap complete: {:?}", &swap);
            let _active_swap = data
                .instant_swaps
                .remove(&swap.order_id)
                .expect("order not found");
            if swap.status == SwapDoneStatus::Success {
                let txid = swap.txid.unwrap();
                // All reported amounts are from the client side
                let dealer_send_bitcoins = swap.recv_asset == data.policy_asset;
                let (asset_id, bitcoin_amount) = if swap.recv_asset == data.policy_asset {
                    (swap.send_asset, swap.recv_amount)
                } else {
                    (swap.recv_asset, swap.send_amount)
                };
                let bitcoin_amount = Amount::from_sat(bitcoin_amount);
                let ticker = dealer_ticker_from_asset_id(data.network, &asset_id).unwrap();
                let instant_swap_succeed = SwapSucceed {
                    txid,
                    dealer_send_bitcoins,
                    bitcoin_amount,
                    ticker,
                };
                data.event_sender
                    .send(Event::Swap(instant_swap_succeed))
                    .unwrap();
            }
        }

        _ => {}
    }
}

async fn process_ws_msg(data: &mut Data, msg: WrappedResponse) {
    match msg {
        WrappedResponse::Connected => {
            data.assets = make_request!(
                data.ws,
                Assets,
                Some(AssetsRequestParam {
                    embedded_icons: Some(false),
                    all_assets: Some(true),
                    amp_asset_restrictions: Some(false),
                })
            )
            .expect("loading assets failed")
            .assets;

            data.event_sender
                .send(Event::ServerConnected(None))
                .unwrap();

            if let Some(api_key) = &data.params.api_key {
                make_request!(
                    data.ws,
                    LoginDealer,
                    LoginDealerRequest {
                        api_key: api_key.to_owned(),
                    }
                )
                .expect("dealer login failed");
            }

            data.server_connected = true;

            data.internal_sender.send(Internal::ReloadUtxo).unwrap();
        }

        WrappedResponse::Disconnected => {
            data.server_connected = false;
            data.event_sender
                .send(Event::ServerDisconnected(None))
                .unwrap();
        }

        WrappedResponse::Response(ResponseMessage::Notification(notif)) => {
            process_ws_notif(data, notif).await;
        }
        WrappedResponse::Response(ResponseMessage::Response(_, _)) => {}
    }
}

async fn process_command(data: &mut Data, to: Command) {
    match to {
        Command::Price(UpdatePrice { ticker, price }) => {
            match price {
                Some(v) => data.dealer_prices.insert(
                    ticker,
                    DealerPriceTimestamp {
                        dealer: v,
                        timestamp: std::time::Instant::now(),
                    },
                ),
                None => data.dealer_prices.remove(&ticker),
            };
            data.internal_sender.send(Internal::Timer).unwrap();
        }

        Command::ResetPrices(_) => {
            data.dealer_prices.clear();
            data.internal_sender.send(Internal::Timer).unwrap();
        }

        Command::IndexPriceUpdate(price_update) => {
            if data.server_connected {
                let price_update = make_request!(data.ws, PriceUpdateBroadcast, price_update);
                if let Err(e) = price_update {
                    error!("price update failed: {}", e);
                }
            }
        }
    }
}

async fn process_internal_msg(data: &mut Data, internal: Internal) {
    match internal {
        Internal::Timer => process_timer(data).await,

        Internal::ReloadUtxo => {
            let unspent = rpc::make_rpc_call(&data.params.rpc, rpc::ListUnspentCall { minconf: 0 })
                .await
                .expect("list_unspent failed");

            let mut utxos_with_key = Vec::new();
            for unspent in unspent.iter() {
                let utxo = sideswap_api::Utxo {
                    txid: unspent.txid,
                    vout: unspent.vout,
                    asset: unspent.asset,
                    asset_bf: unspent.assetblinder,
                    value: unspent.amount.to_sat(),
                    value_bf: unspent.amountblinder,
                    redeem_script: unspent.redeem_script.clone(),
                };
                let priv_key = match data.utxo_data.get_priv_key(&utxo.outpoint()) {
                    Some(priv_key) => priv_key,
                    None => rpc::make_rpc_call(
                        &data.params.rpc,
                        rpc::DumpPrivKeyCall {
                            address: unspent.address.clone(),
                        },
                    )
                    .await
                    .expect("must not fail"),
                };
                utxos_with_key.push(UtxoWithKey { utxo, priv_key });
            }
            data.utxo_data.reset(utxos_with_key);

            data.event_sender
                .send(Event::Utxos(data.utxo_data.clone(), unspent.clone()))
                .expect("channel must be open");

            let mut asset_amounts = BTreeMap::<AssetId, f64>::new();
            for item in unspent.iter() {
                let asset_amount = asset_amounts.entry(item.asset).or_default();
                *asset_amount += item.amount.to_btc();
            }

            let wallet_balances_new = data
                .assets
                .iter()
                .flat_map(|asset| {
                    asset_amounts
                        .get(&asset.asset_id)
                        .map(|balance| (asset, *balance))
                })
                .flat_map(|(asset, balance)| {
                    dealer_ticker_from_asset_id(data.network, &asset.asset_id)
                        .map(|ticker| (ticker, balance))
                })
                .collect::<BTreeMap<_, _>>();

            if data.wallet_balances != wallet_balances_new {
                data.wallet_balances = wallet_balances_new;
            }

            let old_keys: BTreeSet<_> = data.utxos.keys().cloned().collect();
            use sideswap_types::utxo_ext::UtxoExt;
            let new_keys: BTreeSet<_> = unspent.iter().map(|item| item.outpoint()).collect();
            for item in unspent.iter() {
                data.utxos.entry(item.outpoint()).or_insert_with(|| {
                    debug!(
                        "add new utxo: {}/{}, asset: {}, amount: {}",
                        &item.txid, item.vout, item.asset, item.amount
                    );
                    Utxo {
                        amount: item.amount.to_sat() as i64,
                        item: item.clone(),
                    }
                });
            }
            for key in old_keys.difference(&new_keys) {
                debug!("remove consumed utxo: {}/{}", &key.txid, key.vout);
                data.utxos.remove(key);
            }
        }
    }
}

async fn worker(
    params: Params,
    mut command_receiver: UnboundedReceiver<Command>,
    event_sender: UnboundedSender<Event>,
) {
    let (req_sender, req_receiver) =
        tokio::sync::mpsc::unbounded_channel::<ws::auto::WrappedRequest>();
    let (resp_sender, resp_receiver) =
        tokio::sync::mpsc::unbounded_channel::<ws::auto::WrappedResponse>();
    tokio::spawn(sideswap_common::ws::auto::run(
        params.server_url.clone(),
        req_receiver,
        resp_sender,
    ));
    let ws = WsReqSender::new(req_sender, resp_receiver);

    let policy_asset = params.env.nd().policy_asset.asset_id();

    let (internal_sender, mut internal_receiver) = unbounded_channel::<Internal>();

    let mut data = Data {
        network: params.env.d().network,
        policy_asset,
        params,
        ws,
        assets: Vec::new(),
        server_connected: false,
        utxos: Utxos::new(),
        wallet_balances: WalletBalances::default(),
        dealer_prices: DealerPrices::new(),
        wallet_balance: None,
        instant_swaps: BTreeMap::new(),
        event_sender,
        internal_sender,
        utxo_data: UtxoData::new(utxo_data::Params {
            confifential_only: true,
        }),
    };

    let mut interval = tokio::time::interval(Duration::from_secs(1));

    loop {
        tokio::select! {
            _ = interval.tick() => {
                process_timer(&mut data).await;
            },

            msg = data.ws.recv() => {
                process_ws_msg(&mut data, msg).await;
            },

            command = command_receiver.recv() => {
                match command {
                    Some(to) => {
                        process_command(&mut data, to).await;
                    },
                    None => {
                        log::debug!("stop processing");
                        return;
                    },
                }
            },

            internal = internal_receiver.recv() => {
                let internal = internal.expect("channel must be open");
                process_internal_msg(&mut data, internal).await;
            },
        }
    }
}

pub fn spawn_async(params: Params) -> (UnboundedSender<Command>, UnboundedReceiver<Event>) {
    let (command_sender, command_receiver) = unbounded_channel::<Command>();
    let (event_sender, event_receiver) = unbounded_channel::<Event>();

    tokio::task::spawn(worker(params, command_receiver, event_sender));

    (command_sender, event_receiver)
}
