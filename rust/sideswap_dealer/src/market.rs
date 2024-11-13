//! New market swap API (replaces both old swap API and instant swaps)

use std::{
    collections::{BTreeMap, BTreeSet, VecDeque},
    time::Duration,
};

use elements::{pset::PartiallySignedTransaction, Address, AssetId, OutPoint, Txid};
use sideswap_api::{
    market::{
        AddOrderRequest, AddUtxosRequest, AssetPair, CancelOrderRequest, EditOrderRequest,
        LoginRequest, LoginResponse, MakerSignNotif, MakerSignRequest, Notification, OrdId,
        OwnOrder, QuoteId, RegisterRequest, RegisterResponse, RemoveUtxosRequest, Request,
        ResolveGaidRequest, TradeDir,
    },
    AssetBlindingFactor, AssetsRequestParam, ErrorCode, MarketType, ResponseMessage, Utxo,
    ValueBlindingFactor,
};
use sideswap_common::{
    b64,
    channel_helpers::UncheckedUnboundedSender,
    make_market_request, make_request,
    ws::{
        auto::{WrappedRequest, WrappedResponse},
        ws_req_sender::WsReqSender,
    },
};
use sideswap_types::{normal_float::NormalFloat, utxo_ext::UtxoExt};
use tokio::sync::mpsc::{unbounded_channel, UnboundedReceiver, UnboundedSender};

#[derive(Debug, Clone)]
pub struct Params {
    pub env: sideswap_common::env::Env,

    pub server_url: String,

    pub work_dir: String,
}

pub struct Order {
    pub asset_pair: AssetPair,
    pub trade_dir: TradeDir,
    pub base_amount: u64,
    pub price: NormalFloat,
}

pub enum Command {
    Orders {
        orders: Vec<Order>,
    },
    Utxos {
        utxos: Vec<Utxo>,
    },
    NewAddress {
        address: Address,
    },
    Gaid {
        gaid: String,
    },
    SignedSwap {
        quote_id: QuoteId,
        pset: PartiallySignedTransaction,
    },
}

pub enum Event {
    SignSwap {
        quote_id: QuoteId,
        pset: PartiallySignedTransaction,
        blinding_nonces: Vec<String>,
    },
    GetNewAddress,
    SwapSucceed {
        asset_pair: AssetPair,
        trade_dir: TradeDir,
        base_amount: u64,
        quote_amount: u64,
        price: NormalFloat,
        txid: Txid,
    },
}

/// How many free addresses are available
const ADDRESS_POOL_COUNT: usize = 2;

#[derive(Default)]
struct MarketData {
    dealer_orders: Vec<Order>,
    server_orders: BTreeMap<OrdId, OwnOrder>,
}

struct Data {
    ws: WsReqSender,

    wallet_utxos: Vec<Utxo>, // Only confidential UTXOs here
    server_utxos: BTreeSet<OutPoint>,

    addresses: VecDeque<Address>,
    gaid: Option<String>,
    amp_assets: BTreeSet<AssetId>,

    markets: BTreeMap<(AssetPair, TradeDir), MarketData>,

    token: Option<String>,
    event_sender: UncheckedUnboundedSender<Event>,
}

async fn try_login(data: &mut Data) -> Result<LoginResponse, anyhow::Error> {
    let assets = make_request!(
        data.ws,
        Assets,
        Some(AssetsRequestParam {
            embedded_icons: Some(false),
            all_assets: Some(true),
            amp_asset_restrictions: Some(false)
        })
    )?;

    data.amp_assets = assets
        .assets
        .iter()
        .filter_map(|asset| (asset.market_type == Some(MarketType::Amp)).then_some(asset.asset_id))
        .collect();

    if let Some(token) = &data.token {
        let res = make_market_request!(
            data.ws,
            Login,
            LoginRequest {
                token: token.clone()
            }
        );

        match res {
            Ok(resp) => return Ok(resp),
            Err(err) if err.error_code() == ErrorCode::UnknownToken => {
                log::warn!("token not found: {err}");
                data.token = None;
            }
            Err(err) => {
                anyhow::bail!("unexpected login error: {err}");
            }
        }
    }

    log::debug!("register...");

    let RegisterResponse { token } = make_market_request!(data.ws, Register, RegisterRequest {})?;

    let resp = make_market_request!(
        data.ws,
        Login,
        LoginRequest {
            token: token.clone()
        }
    )?;

    data.token = Some(token);

    // FIXME: Save settings

    Ok(resp)
}

async fn process_ws_connected(data: &mut Data) {
    let LoginResponse { orders, utxos } = try_login(data).await.expect("login failed unexpectedly");

    for order in orders {
        data.markets
            .entry((order.asset_pair, order.trade_dir))
            .or_default()
            .server_orders
            .insert(order.order_id, order);
    }

    data.server_utxos = utxos.into_iter().collect();
}

fn process_ws_disconnected(data: &mut Data) {
    for market in data.markets.values_mut() {
        market.server_orders.clear();
    }
}

fn process_sign_notif(data: &mut Data, notif: MakerSignNotif) {
    let pset = b64::decode(&notif.pset).expect("invalid base64 pset");
    let pset =
        elements::encode::deserialize::<PartiallySignedTransaction>(&pset).expect("invalid pset");

    // FIXME: Verify PSET amounts

    data.event_sender.send(Event::SignSwap {
        quote_id: notif.quote_id,
        pset,
        blinding_nonces: notif.blinding_nonces,
    });
}

async fn process_market_notif(data: &mut Data, notif: Notification) {
    match notif {
        Notification::MarketAdded(_) => {}
        Notification::MarketRemoved(_) => {}

        Notification::OwnOrderCreated(notif) => {
            data.markets
                .entry((notif.order.asset_pair, notif.order.trade_dir))
                .or_default()
                .server_orders
                .insert(notif.order.order_id, notif.order);
        }
        Notification::OwnOrderRemoved(notif) => {
            for market in data.markets.values_mut() {
                market.server_orders.remove(&notif.order_id);
            }
        }

        Notification::UtxoAdded(notif) => {
            data.server_utxos.insert(notif.utxo);
        }
        Notification::UtxoRemoved(notif) => {
            data.server_utxos.remove(&notif.utxo);
        }

        Notification::PublicOrderCreated(_) => {}
        Notification::PublicOrderRemoved(_) => {}

        Notification::MakerSign(notif) => {
            process_sign_notif(data, notif);
        }

        Notification::Quote(_) => {}
        Notification::MarketPrice(_) => {}
        Notification::ChartUpdate(_) => {}
        Notification::HistoryUpdated(notif) => {
            if let Some(txid) = notif.order.txid {
                if notif.is_new {
                    data.event_sender.send(Event::SwapSucceed {
                        asset_pair: notif.order.asset_pair,
                        trade_dir: notif.order.trade_dir,
                        base_amount: notif.order.base_amount,
                        quote_amount: notif.order.quote_amount,
                        price: notif.order.price,
                        txid,
                    });
                }
            }
        }
    }
}

async fn process_ws_event(data: &mut Data, event: WrappedResponse) {
    match event {
        WrappedResponse::Connected => {
            process_ws_connected(data).await;
        }

        WrappedResponse::Disconnected => {
            process_ws_disconnected(data);
        }

        WrappedResponse::Response(ResponseMessage::Notification(
            sideswap_api::Notification::Market(notif),
        )) => {
            process_market_notif(data, notif).await;
        }

        WrappedResponse::Response(_) => {}
    }
}

fn process_to_message(data: &mut Data, to: Command) {
    match to {
        Command::Orders { orders } => {
            for market in data.markets.values_mut() {
                market.dealer_orders.clear();
            }

            for order in orders {
                data.markets
                    .entry((order.asset_pair, order.trade_dir))
                    .or_default()
                    .dealer_orders
                    .push(order);
            }
        }

        Command::Utxos { utxos } => {
            data.wallet_utxos = utxos
                .into_iter()
                .filter(|utxo| {
                    utxo.asset_bf != AssetBlindingFactor::zero()
                        && utxo.value_bf != ValueBlindingFactor::zero()
                })
                .collect();
        }

        Command::NewAddress { address } => {
            data.addresses.push_back(address);
        }

        Command::Gaid { gaid } => {
            data.gaid = Some(gaid);
        }

        Command::SignedSwap { quote_id, pset } => {
            let pset = elements::encode::serialize(&pset);
            let pset = b64::encode(&pset);

            data.ws.callback_request(
                sideswap_api::Request::Market(Request::MakerSign(MakerSignRequest {
                    quote_id,
                    pset,
                })),
                Box::new(|res| {
                    if let Err(err) = res {
                        log::error!("MakerSign failed: {err}");
                    }
                }),
            );
        }
    }
}

async fn try_sync_utxos(data: &mut Data) -> Result<(), anyhow::Error> {
    let wallet_outputs = data
        .wallet_utxos
        .iter()
        .map(UtxoExt::outpoint)
        .collect::<BTreeSet<_>>();

    let removed = data
        .server_utxos
        .difference(&wallet_outputs)
        .copied()
        .collect::<Vec<_>>();

    if !removed.is_empty() {
        let count = removed.len();
        for utxo in removed.iter() {
            log::debug!("try to remove utxo: {utxo}");
        }
        make_market_request!(data.ws, RemoveUtxos, RemoveUtxosRequest { utxos: removed })?;
        log::debug!("removed {count} utxos");
    }

    let mut added = Vec::new();
    for utxo in data.wallet_utxos.iter() {
        if !data.server_utxos.contains(&utxo.outpoint()) {
            log::debug!("try to add utxo: {}", utxo.outpoint());
            added.push(utxo.clone());
        }
    }

    if !added.is_empty() {
        let count = added.len();
        make_market_request!(data.ws, AddUtxos, AddUtxosRequest { utxos: added })?;
        log::debug!("added {count} utxos");
    }

    Ok(())
}

async fn try_sync_market(
    ws: &mut WsReqSender,
    market: &mut MarketData,
    addresses: &mut VecDeque<Address>,
    gaid: &Option<String>,
    amp_assets: &BTreeSet<AssetId>,
) -> Result<(), anyhow::Error> {
    // Drop removed orders
    while market.server_orders.len() > market.dealer_orders.len() {
        let order = market.server_orders.last_key_value().expect("must exist").1;

        make_market_request!(
            ws,
            CancelOrder,
            CancelOrderRequest {
                order_id: order.order_id
            }
        )?;

        market.server_orders.pop_last();
    }

    // Sync existing orders
    for (dealer_order, server_order) in market
        .dealer_orders
        .iter_mut()
        .zip(market.server_orders.values_mut())
    {
        if dealer_order.base_amount != server_order.orig_amount
            || dealer_order.price != server_order.price
        {
            let resp = make_market_request!(
                ws,
                EditOrder,
                EditOrderRequest {
                    order_id: server_order.order_id,
                    base_amount: Some(dealer_order.base_amount),
                    price: Some(dealer_order.price),
                    receive_address: None,
                    change_address: None,
                }
            )?;

            *server_order = resp.order;
        }
    }

    // Add new orders
    while market.dealer_orders.len() > market.server_orders.len()
        && addresses.len() >= ADDRESS_POOL_COUNT
    {
        let dealer_order = &market.dealer_orders[market.server_orders.len()];

        // TODO: Reuse addresses?

        let recv_asset = match dealer_order.trade_dir {
            TradeDir::Sell => dealer_order.asset_pair.quote,
            TradeDir::Buy => dealer_order.asset_pair.base,
        };

        let receive_address = if amp_assets.contains(&recv_asset) {
            let gaid = gaid.as_ref().ok_or_else(|| anyhow::anyhow!("no gaid"))?;

            let resp = make_market_request!(
                ws,
                ResolveGaid,
                ResolveGaidRequest {
                    asset_id: recv_asset,
                    gaid: gaid.clone(),
                }
            )?;

            resp.address
        } else {
            addresses.pop_front().expect("must exist")
        };

        let change_address = addresses.pop_front().expect("must exist");

        let resp = make_market_request!(
            ws,
            AddOrder,
            AddOrderRequest {
                asset_pair: dealer_order.asset_pair,
                base_amount: dealer_order.base_amount,
                price: dealer_order.price,
                trade_dir: dealer_order.trade_dir,
                ttl: None,
                receive_address,
                change_address,
                private: false,
            }
        )?;

        market.server_orders.insert(resp.order.order_id, resp.order);
    }

    Ok(())
}

async fn process_timer(data: &mut Data) {
    if !data.ws.connected() {
        return;
    }

    let res = try_sync_utxos(data).await;
    if let Err(err) = res {
        log::warn!("utxo sync failed: {err}");
    }

    data.markets
        .retain(|_, market| !market.dealer_orders.is_empty() || !market.server_orders.is_empty());

    for market in data.markets.values_mut() {
        let res = try_sync_market(
            &mut data.ws,
            market,
            &mut data.addresses,
            &data.gaid,
            &data.amp_assets,
        )
        .await;
        if let Err(err) = res {
            log::error!("market sync failed: {err}");
        }
    }

    if data.addresses.len() < ADDRESS_POOL_COUNT {
        data.event_sender.send(Event::GetNewAddress);
    }
}

pub async fn run(
    params: Params,
    mut command_receiver: UnboundedReceiver<Command>,
    event_sender: UnboundedSender<Event>,
) {
    let (req_sender, req_receiver) = unbounded_channel::<WrappedRequest>();
    let (resp_sender, resp_receiver) = unbounded_channel::<WrappedResponse>();
    tokio::spawn(sideswap_common::ws::auto::run(
        params.server_url.clone(),
        req_receiver,
        resp_sender,
    ));
    let ws = WsReqSender::new(req_sender, resp_receiver);

    let mut data = Data {
        ws,
        wallet_utxos: Vec::new(),
        server_utxos: BTreeSet::new(),
        addresses: VecDeque::new(),
        gaid: None,
        amp_assets: BTreeSet::new(),
        // FIXME: Load from the work dir
        markets: BTreeMap::new(),
        token: None,
        event_sender: event_sender.into(),
    };

    let mut interval = tokio::time::interval(Duration::from_secs(1));

    loop {
        tokio::select! {
            event = data.ws.recv() => {
                process_ws_event(&mut data, event).await;
            },

            to = command_receiver.recv() => {
                match to {
                    Some(to) => {
                        process_to_message(&mut data, to);
                    },
                    None => {
                        log::debug!("stop worker thread");
                        break;
                    },
                }
            },

            _ = interval.tick() => {
                process_timer(&mut data).await;
            },
        }
    }
}
