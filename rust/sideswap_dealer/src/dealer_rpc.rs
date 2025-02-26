//! Old instant swaps and swap API (deprecated)

use crate::utxo_data::{self, UtxoData, UtxoWithKey};

use anyhow::{anyhow, ensure};
use elements::pset::PartiallySignedTransaction;
use elements::OutPoint;
use log::{debug, error, info, warn};
use serde::{Deserialize, Serialize};
use sideswap_api::{Asset, *};
use sideswap_common::{
    b64,
    dealer_ticker::{DealerTicker, TickerLoader},
    make_request,
    rpc::{self, ListUnspent},
    types::{self, Amount},
    ws::{self, auto::WrappedResponse, ws_req_sender::WsReqSender},
};
use std::collections::{BTreeMap, BTreeSet};
use std::sync::Arc;
use std::time::{Duration, Instant};
use tokio::sync::mpsc::{unbounded_channel, UnboundedReceiver, UnboundedSender};

// Keep some extra amount in the wallet for the various fees (server, network, external exchange)
const INSTANT_SWAP_WORK_AMOUNT: f64 = 0.995;

// Extra asset UTXO amount to cover future price edits
const EXTRA_ASSET_UTXO_FRACTION: f64 = 0.03;

const MIN_BITCOIN_AMOUNT: f64 = 0.0001;

const PRICE_EXPIRATON_TIME: std::time::Duration = std::time::Duration::from_secs(60);

const PRICE_EDIT_MIN_DELAY: std::time::Duration = std::time::Duration::from_secs(5);

#[derive(Clone)]
pub struct Params {
    pub env: sideswap_common::env::Env,

    pub server_url: String,

    pub rpc: rpc::RpcServer,

    pub tickers: BTreeSet<DealerTicker>,

    pub bitcoin_amount_submit: Amount,
    pub bitcoin_amount_min: Amount,
    pub bitcoin_amount_max: Amount,

    pub api_key: Option<String>,

    pub ticker_loader: Arc<TickerLoader>,
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

pub struct OwnOrder {
    pub order_id: OrderId,
    pub bitcoin_amount: Amount,
    pub price: f64,
}

#[derive(Debug, Hash, PartialEq, Eq, Ord, PartialOrd, Clone, Copy)]
struct OwnOrderKey {
    ticker: DealerTicker,
    send_bitcoins: bool,
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

fn take_order(
    params: &Params,
    assets: &Assets,
    details: &Details,
    wallet_balances: &WalletBalances,
    dealer_prices: &DealerPrices,
    ticker_loader: &TickerLoader,
) -> Result<(), anyhow::Error> {
    ensure!(details.bitcoin_amount >= params.bitcoin_amount_min.to_sat());
    ensure!(details.bitcoin_amount <= params.bitcoin_amount_max.to_sat());
    let asset = assets
        .iter()
        .find(|asset| asset.asset_id == details.asset)
        .unwrap();
    let ticker = ticker_loader
        .ticker(&details.asset)
        .ok_or_else(|| anyhow!("unknown asset {}", asset.name))?;
    let dealer_price = dealer_prices
        .get(&ticker)
        .cloned()
        .ok_or(anyhow!("dealer price for {ticker:?} is not known"))?;
    let actual_bitcoin_amount = Amount::from_sat(if details.send_bitcoins {
        details.bitcoin_amount + details.server_fee
    } else {
        details.bitcoin_amount - details.server_fee
    });
    let asset_amount = types::asset_float_amount(details.asset_amount, asset.precision);
    let actual_price = asset_amount / actual_bitcoin_amount.to_bitcoin();
    assert!(actual_price > 0.0);
    let bitcoin_amount_max = get_bitcoin_amount(
        asset,
        wallet_balances,
        ticker,
        actual_price,
        details.send_bitcoins,
    );
    if details.send_bitcoins {
        ensure!(
            actual_price >= dealer_price.dealer.submit_price.ask,
            "actual_price: {}, dealer_price.ask: {}",
            actual_price,
            dealer_price.dealer.submit_price.ask
        );
        ensure!(actual_bitcoin_amount.to_bitcoin() <= dealer_price.dealer.limit_btc_dealer_send);
    } else {
        ensure!(
            actual_price <= dealer_price.dealer.submit_price.bid,
            "actual_price: {}, dealer_price.bid: {}",
            actual_price,
            dealer_price.dealer.submit_price.bid
        );
        ensure!(actual_bitcoin_amount.to_bitcoin() <= dealer_price.dealer.limit_btc_dealer_recv);
    }
    ensure!(
        details.bitcoin_amount <= bitcoin_amount_max.to_sat(),
        "bitcoin amount: {}, max bitcoin amount: {}",
        details.bitcoin_amount,
        bitcoin_amount_max
    );
    Ok(())
}

async fn get_pset(
    order_id: &OrderId,
    details: &Details,
    utxos: &Utxos,
    params: &Params,
    extra_asset_utxo: bool,
) -> Result<PsetMakerRequest, anyhow::Error> {
    let bitcoin_asset = params.env.nd().policy_asset.asset_id();
    let (send_asset, send_amount) = if details.send_bitcoins {
        (bitcoin_asset, details.bitcoin_amount + details.server_fee)
    } else {
        (details.asset, details.asset_amount)
    };

    let mut asset_utxos: Vec<_> = utxos
        .values()
        .filter(|utxo| {
            utxo.item.asset == send_asset
                && utxo.item.amountblinder != ValueBlindingFactor::zero()
                && utxo.item.assetblinder != AssetBlindingFactor::zero()
        })
        .collect();
    let utxos_amounts: Vec<i64> = asset_utxos.iter().map(|utxo| utxo.amount).collect();
    let total: i64 = utxos_amounts.iter().sum();
    ensure!(send_amount <= total);
    let utxo_amount = if extra_asset_utxo && !details.send_bitcoins {
        i64::min(
            total,
            f64::round(send_amount as f64 * (1.0 + EXTRA_ASSET_UTXO_FRACTION)) as i64,
        )
    } else {
        send_amount
    };
    let selected = types::select_utxo(utxos_amounts, utxo_amount);

    let mut inputs = Vec::<sideswap_api::Utxo>::new();

    for amount in selected {
        let index = asset_utxos
            .iter()
            .position(|v| v.amount == amount)
            .expect("utxo must exists");
        let utxo = asset_utxos.swap_remove(index);

        inputs.push(sideswap_api::Utxo {
            txid: utxo.item.txid,
            vout: utxo.item.vout,
            asset: send_asset,
            asset_bf: utxo.item.assetblinder,
            value: amount as u64,
            value_bf: utxo.item.amountblinder,
            redeem_script: utxo.item.redeem_script.clone(),
        });
    }

    let recv_addr = rpc::make_rpc_call(&params.rpc, rpc::GetNewAddressCall {})
        .await
        .expect("getting new address failed");
    let change_addr = rpc::make_rpc_call(&params.rpc, rpc::GetNewAddressCall {})
        .await
        .expect("getting new address failed");

    let addr_request = PsetMakerRequest {
        order_id: *order_id,
        price: details.price,
        private: false,
        ttl_seconds: None,
        inputs,
        recv_addr,
        change_addr,
        signed_half: None,
    };
    Ok(addr_request)
}

fn sign_pset(data: &Data, notif: &SignNotification) -> Result<SignRequest, anyhow::Error> {
    let pset = b64::decode(&notif.pset)?;
    let pset = elements::encode::deserialize::<PartiallySignedTransaction>(&pset)?;

    let pset = data.utxo_data.sign_pset(pset);

    let pset = elements::encode::serialize(&pset);

    let sign_request = SignRequest {
        order_id: notif.order_id,
        signed_pset: b64::encode(&pset),
        side: notif.details.side,
    };

    Ok(sign_request)
}

fn get_bitcoin_amount(
    asset: &Asset,
    wallet_balances: &WalletBalances,
    ticker: DealerTicker,
    price: f64,
    send_bitcoins: bool,
) -> Amount {
    let wallet_asset = wallet_balances.get(&ticker).cloned().unwrap_or_default();
    let wallet_bitcoin = wallet_balances
        .get(&DealerTicker::LBTC)
        .cloned()
        .unwrap_or_default()
        / (1.0 + asset.server_fee().value());
    if send_bitcoins {
        Amount::from_bitcoin(wallet_bitcoin)
    } else {
        Amount::from_bitcoin(wallet_asset / price)
    }
}

async fn cancel_order(ws: &mut WsReqSender, order_id: &OrderId) {
    let cancel_result = make_request!(
        ws,
        Cancel,
        CancelRequest {
            order_id: *order_id,
        }
    );
    if let Err(e) = cancel_result {
        error!("cancelling order failed: {}", e);
    }
}

async fn update_price(
    own: &mut Option<OwnOrder>,
    send_bitcoins: bool,
    assets: &Assets,
    ticker: DealerTicker,
    index_prices: &DealerPrices,
    wallet_balances: &WalletBalances,
    utxos: &Utxos,
    params: &Params,
    ws: &mut WsReqSender,
) {
    let asset = assets
        .iter()
        .find(|asset| asset.ticker.0 == ticker.to_string())
        .unwrap();
    let price_with_limits = index_prices.get(&ticker).cloned();
    let server_fee = Amount::from_bitcoin(f64::max(
        asset.server_fee().value() * params.bitcoin_amount_submit.to_bitcoin(),
        types::SWAP_MARKETS_MIN_SERVER_FEE.to_bitcoin(),
    ));
    let server_fee_interest =
        1.0 + server_fee.to_bitcoin() / params.bitcoin_amount_submit.to_bitcoin();

    let price = price_with_limits.map(|price| {
        pick_price(
            &apply_interest(&price.dealer.submit_price, server_fee_interest),
            send_bitcoins,
        )
    });

    let bitcoin_amount_limit_external = price_with_limits
        .map(|price| {
            if send_bitcoins {
                price.dealer.limit_btc_dealer_send
            } else {
                price.dealer.limit_btc_dealer_recv
            }
        })
        .unwrap_or_default();
    let bitcoin_amount_limit_wallet = price
        .map(|price| get_bitcoin_amount(asset, wallet_balances, ticker, price, send_bitcoins))
        .unwrap_or_default()
        .to_bitcoin();
    let bitcoin_amount_limit = bitcoin_amount_limit_wallet.min(bitcoin_amount_limit_external);
    let order_allowed = params.bitcoin_amount_submit.to_bitcoin() <= bitcoin_amount_limit;

    match (own.as_mut(), price) {
        (None, Some(price)) if order_allowed => {
            let submit_result = make_request!(
                ws,
                Submit,
                SubmitRequest {
                    order: PriceOrder {
                        asset: asset.asset_id,
                        bitcoin_amount: Some(if send_bitcoins {
                            -params.bitcoin_amount_submit.to_bitcoin()
                        } else {
                            params.bitcoin_amount_submit.to_bitcoin()
                        }),
                        asset_amount: None,
                        price: Some(price),
                        index_price: None,
                    },
                }
            );
            if let Ok(submit_resp) = submit_result {
                let pset = get_pset(
                    &submit_resp.order_id,
                    &submit_resp.details,
                    utxos,
                    params,
                    true,
                )
                .await;
                match pset {
                    Ok(pset_maker_req) => {
                        let addr_result = make_request!(ws, PsetMaker, pset_maker_req);
                        match addr_result {
                            Ok(_) => {
                                *own = Some(OwnOrder {
                                    order_id: submit_resp.order_id,
                                    bitcoin_amount: params.bitcoin_amount_submit,
                                    price,
                                });
                            }
                            Err(e) => error!("sending Addr request failed: {}", e),
                        }
                    }
                    Err(e) => error!("creating PSET failed: {}", e),
                }
            }
        }
        // Amount is not enough or index price is not known, do nothing
        (None, _) => {}

        (Some(data), _) if !order_allowed => {
            info!("cancel order {}, submit is not allowed", data.order_id);
            cancel_order(ws, &data.order_id).await;
        }
        (Some(data), None) => {
            info!("cancel order {} because index price expired", data.order_id);
            cancel_order(ws, &data.order_id).await;
        }

        (Some(data), Some(price)) => {
            if data.price != price {
                let edit_result = make_request!(
                    ws,
                    Edit,
                    EditRequest {
                        order_id: data.order_id,
                        price: Some(price),
                        index_price: None,
                    }
                );
                match edit_result {
                    Ok(_) => {
                        data.price = price;
                    }
                    Err(e) => {
                        error!("price update failed: {}", e);
                        let cancel_result = make_request!(
                            ws,
                            Cancel,
                            CancelRequest {
                                order_id: data.order_id,
                            }
                        );
                        if let Err(e) = cancel_result {
                            error!("cancelling request failed: {}", e);
                        }
                        *own = None;
                    }
                }
            }
        }
    }
}

struct InstantSwap {
    _send_asset: AssetId,
}

struct Data {
    policy_asset: AssetId,
    ticker_loader: Arc<TickerLoader>,
    params: Params,
    ws: WsReqSender,
    assets: Vec<Asset>,
    server_connected: bool,
    utxos: Utxos,
    orders: BTreeMap<OrderId, OrderCreatedNotification>,
    taken_orders: BTreeSet<OrderId>,
    wallet_balances: WalletBalances,
    dealer_prices: DealerPrices,
    pending_signs: BTreeMap<OrderId, Details>,
    own_orders: BTreeMap<OwnOrderKey, Option<OwnOrder>>,
    wallet_balance: Option<rpc::GetWalletInfo>,
    last_price_edit: Instant,
    instant_swaps: BTreeMap<OrderId, InstantSwap>,
    event_sender: UnboundedSender<Event>,
    internal_sender: UnboundedSender<Internal>,
    utxo_data: UtxoData,
}

async fn process_timer(data: &mut Data) {
    let now = std::time::Instant::now();
    if data.server_connected && now.duration_since(data.last_price_edit) >= PRICE_EDIT_MIN_DELAY {
        for (key, own) in data.own_orders.iter_mut() {
            update_price(
                own,
                key.send_bitcoins,
                &data.assets,
                key.ticker,
                &data.dealer_prices,
                &data.wallet_balances,
                &data.utxos,
                &data.params,
                &mut data.ws,
            )
            .await;
        }
        data.last_price_edit = now;
    }

    for order in data.orders.values() {
        if data.taken_orders.get(&order.order_id).is_some() {
            continue;
        }

        let result = take_order(
            &data.params,
            &data.assets,
            &order.details,
            &data.wallet_balances,
            &data.dealer_prices,
            &data.ticker_loader,
        );
        if result.is_ok() {
            info!("take order: {:?}", order);
            let result = get_pset(
                &order.order_id,
                &order.details,
                &data.utxos,
                &data.params,
                false,
            )
            .await;
            match result {
                Ok(pset_req) => {
                    let taker_pset_req = PsetTakerRequest {
                        order_id: pset_req.order_id,
                        price: pset_req.price,
                        inputs: pset_req.inputs,
                        recv_addr: pset_req.recv_addr,
                        change_addr: pset_req.change_addr,
                    };
                    let addr_result = make_request!(data.ws, PsetTaker, taker_pset_req);
                    if let Err(e) = addr_result {
                        error!("sending addr details failed: {}", e);
                    } else {
                        data.taken_orders.insert(order.order_id);
                    }
                }
                Err(e) => error!("sending quote failed: {}", e),
            }
        }
    }

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
            let asset_id = data.ticker_loader.asset_id(*ticker);
            let price_stream = BroadcastPriceStreamRequest {
                asset: *asset_id,
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
        Notification::OrderCreated(order) if order.own.is_none() => {
            data.orders.insert(order.order_id, order);
            data.internal_sender.send(Internal::Timer).unwrap();
        }

        Notification::OrderRemoved(order) => {
            data.orders.remove(&order.order_id);
        }

        Notification::Sign(notif) => {
            debug!("sign notification received, order_id: {}", &notif.order_id);

            // TODO: Verify PSET

            let result = sign_pset(data, &notif).unwrap();
            make_request!(data.ws, Sign, result).expect("sending signed PSBT failed");
            data.pending_signs.insert(notif.order_id, notif.details);
        }

        Notification::Complete(msg) => {
            for own in data.own_orders.values_mut() {
                if own.as_ref().map(|own| &own.order_id) == Some(&msg.order_id) {
                    *own = None;
                }
            }

            let details = data.pending_signs.remove(&msg.order_id);
            match msg.txid {
                Some(txid) => {
                    info!("order {} complete succesfully", msg.order_id);
                    let details = details.expect("details must exists");
                    let ticker = data.ticker_loader.ticker(&details.asset).unwrap();
                    let send_bitcoins = details.send_bitcoins;
                    let bitcoin_amount = Amount::from_sat(if send_bitcoins {
                        details.bitcoin_amount + details.server_fee
                    } else {
                        details.bitcoin_amount - details.server_fee
                    });
                    let swap_succeed = SwapSucceed {
                        txid,
                        ticker,
                        bitcoin_amount,
                        dealer_send_bitcoins: send_bitcoins,
                    };
                    data.event_sender.send(Event::Swap(swap_succeed)).unwrap();
                }
                None => info!("order {} complete unsuccesfully", msg.order_id),
            };
        }

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
                let ticker = data.ticker_loader.ticker(&asset_id).unwrap();
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

            let login_resp = make_request!(data.ws, Login, LoginRequest { session_id: None })
                .expect("subscribing to order list failed");
            assert!(login_resp.orders.is_empty());
            for asset in data.assets.iter().filter(|asset| {
                data.ticker_loader
                    .ticker(&asset.asset_id)
                    .map(|ticker| data.params.tickers.contains(&ticker))
                    .unwrap_or(false)
            }) {
                let subscribe_resp = make_request!(
                    data.ws,
                    Subscribe,
                    SubscribeRequest {
                        asset: Some(asset.asset_id),
                    }
                )
                .expect("subscribing to order list failed");
                for order in subscribe_resp.orders {
                    data.orders.insert(order.order_id, order);
                }
            }

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
            data.orders.clear();
            data.taken_orders.clear();
            for own_order in data.own_orders.values_mut() {
                *own_order = None;
            }
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
                    data.ticker_loader
                        .ticker(&asset.asset_id)
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
    assert!(
        params.bitcoin_amount_min.to_bitcoin() >= MIN_BITCOIN_AMOUNT,
        "bitcoin_amount_min can't be less than {}",
        MIN_BITCOIN_AMOUNT
    );
    assert!(params.bitcoin_amount_submit >= params.bitcoin_amount_min);
    assert!(params.bitcoin_amount_submit <= params.bitcoin_amount_max);

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
        policy_asset,
        ticker_loader: Arc::clone(&params.ticker_loader),
        params,
        ws,
        assets: Vec::new(),
        server_connected: false,
        utxos: Utxos::new(),
        orders: BTreeMap::new(),
        taken_orders: BTreeSet::<OrderId>::new(),
        wallet_balances: WalletBalances::default(),
        dealer_prices: DealerPrices::new(),
        pending_signs: BTreeMap::<OrderId, Details>::new(),
        own_orders: BTreeMap::<OwnOrderKey, Option<OwnOrder>>::new(),
        wallet_balance: None,
        last_price_edit: Instant::now(),
        instant_swaps: BTreeMap::new(),
        event_sender,
        internal_sender,
        utxo_data: UtxoData::new(utxo_data::Params {
            confifential_only: true,
        }),
    };

    for &ticker in data.params.tickers.iter() {
        for &send_bitcoins in [false, true].iter() {
            let key = OwnOrderKey {
                ticker,
                send_bitcoins,
            };
            data.own_orders.insert(key, None);
        }
    }

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
