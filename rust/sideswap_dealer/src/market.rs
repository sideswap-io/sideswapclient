//! New market swap API (replaces both old swap API and instant swaps)

use std::{
    collections::{BTreeMap, BTreeSet, VecDeque},
    time::Duration,
};

use elements::{pset::PartiallySignedTransaction, Address, AssetId, OutPoint, Txid};
use sideswap_api::{
    market::{
        self, AddOrderRequest, AddUtxosRequest, AssetPair, CancelOrderRequest, EditOrderRequest,
        ListMarketsRequest, LoginRequest, LoginResponse, MakerSignNotif, MakerSignRequest,
        MarketInfo, Notification, OrdId, OwnOrder, QuoteId, RegisterRequest, RegisterResponse,
        RemoveUtxosRequest, Request, ResolveGaidRequest, TradeDir,
    },
    Asset, AssetBlindingFactor, AssetsRequestParam, ErrorCode, MarketType, ResponseMessage, Utxo,
    ValueBlindingFactor,
};
use sideswap_common::{
    b64,
    channel_helpers::{UncheckedOneshotSender, UncheckedUnboundedSender},
    make_market_request, make_request,
    network::Network,
    types::{asset_float_amount_, asset_int_amount_},
    verify,
    ws::{
        auto::{WrappedRequest, WrappedResponse},
        ws_req_sender::{self, WsReqSender},
    },
};
use sideswap_types::{
    asset_precision::AssetPrecision,
    normal_float::{NormalFloat, NotNormalError},
    timestamp_ms::TimestampMs,
    utxo_ext::UtxoExt,
};
use tokio::sync::mpsc::{unbounded_channel, UnboundedReceiver, UnboundedSender};

mod persistent_state;
mod web_server;
mod ws_server;

pub use web_server::Config as WebServerConfig;
pub use ws_server::Config as WsServerConfig;

use crate::types::{
    dealer_ticker_from_asset_id, dealer_ticker_to_asset_id, DealerTicker, ExchangePair,
};

#[derive(Debug, Clone)]
pub struct Params {
    pub env: sideswap_common::env::Env,
    pub server_url: String,
    pub work_dir: String,
    pub web_server: Option<WebServerConfig>,
    pub ws_server: Option<WsServerConfig>,
}

// Public messages

pub struct AutomaticOrder {
    pub asset_pair: AssetPair,
    pub trade_dir: TradeDir,
    pub base_amount: u64,
    pub price: NormalFloat,
}

pub enum Command {
    AutomaticOrders {
        orders: Vec<AutomaticOrder>,
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

// Private messages

struct Market {
    base: DealerTicker,
    quote: DealerTicker,
}

struct Metadata {
    server_connected: bool,
    assets: Vec<Asset>,
    markets: Vec<Market>,
}

type Balance = BTreeMap<DealerTicker, f64>;

struct Balances {
    wallet: Balance,
    server: Balance,
}

#[derive(Clone)]
struct PublicOrder_ {
    order_id: OrdId,
    trade_dir: TradeDir,
    amount: f64,
    price: NormalFloat,
}

#[derive(Clone)]
struct OrderBook {
    orders: Vec<PublicOrder_>,
    timestamp: TimestampMs,
}

struct OwnOrders {
    orders: Vec<OwnOrder_>,
}

struct OwnOrder_ {
    exchange_pair: ExchangePair,
    order_id: OrdId,
    trade_dir: TradeDir,
    orig_amount: f64,
    active_amount: f64,
    price: NormalFloat,
}

#[derive(Debug, thiserror::Error)]
enum Error {
    #[error("WS request error: {0}")]
    WsRequestError(#[from] ws_req_sender::Error),
    #[error("Unexpected response, expected: {0}")]
    UnexpectedResponse(&'static str),
    #[error("Try again")]
    TryAgain,
    #[error("Server connection is down")]
    ServerDisconnected,
    #[error("Channel closed, please report bug")]
    ChannelClosed,
    #[error("Unknown ticker: {0}")]
    UnknownTicker(String),
    #[error("Invalid float: {0}")]
    InvalidFloat(NotNormalError),
}

#[derive(Clone)]
enum ClientEvent {
    ServerConnected,
    OrderAdded {
        exchange_pair: ExchangePair,
        order: PublicOrder_,
    },
    OrderRemoved {
        exchange_pair: ExchangePair,
        order_id: OrdId,
    },
    MarketPrice {
        exchange_pair: ExchangePair,
        ind_price: Option<NormalFloat>,
        last_price: Option<NormalFloat>,
    },
}

enum ClientCommand {
    Metadata {
        res_sender: UncheckedOneshotSender<Metadata>,
    },
    Balances {
        res_sender: UncheckedOneshotSender<Balances>,
    },
    OrderBook {
        exchange_pair: ExchangePair,
        res_sender: UncheckedOneshotSender<Result<OrderBook, Error>>,
    },
    OwnOrders {
        res_sender: UncheckedOneshotSender<Result<OwnOrders, Error>>,
    },
    SubmitOrder {
        exchange_pair: ExchangePair,
        base_amount: f64,
        price: NormalFloat,
        trade_dir: TradeDir,
        res_sender: UncheckedOneshotSender<Result<OwnOrder_, Error>>,
    },
    CancelOrder {
        order_id: OrdId,
        res_sender: UncheckedOneshotSender<Result<(), Error>>,
    },

    ClientConnected {
        client_id: ClientId,
        event_sender: UncheckedUnboundedSender<ClientEvent>,
    },
    ClientDisconnected {
        client_id: ClientId,
    },
    WsSubscribe {
        client_id: ClientId,
        exchange_pair: ExchangePair,
        res_sender: UncheckedOneshotSender<Result<OrderBook, Error>>,
    },
}

#[derive(Copy, Clone, PartialEq, Eq, PartialOrd, Ord)]
struct ClientId(u64);

/// How many free addresses are available
const ADDRESS_POOL_COUNT: usize = 2;

#[derive(Default)]
struct OrderData {
    dealer_orders: Vec<AutomaticOrder>,
    server_orders: BTreeMap<OrdId, OwnOrder>,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Mode {
    PriceStream,
    WebServer,
}

impl Mode {
    fn check_ws_edit_allowed(self) {
        match self {
            Mode::PriceStream => {
                panic!("Web server is not allowed to control orders");
            }
            Mode::WebServer => {}
        }
    }
}

type ClientSender = UncheckedUnboundedSender<ClientEvent>;

struct PublicSubscribe {
    orders: BTreeMap<OrdId, PublicOrder_>,
    clients: BTreeMap<ClientId, ClientSender>,
    last_price: Option<NormalFloat>,
    ind_price: Option<NormalFloat>,
}

struct Data {
    network: Network,
    mode: Mode,

    work_dir: String,
    state: persistent_state::Data,

    ws: WsReqSender,

    wallet_utxos: Vec<Utxo>, // Only confidential UTXOs here
    server_utxos: BTreeSet<OutPoint>,

    addresses: VecDeque<Address>,
    gaid: Option<String>,
    assets: Vec<Asset>,
    amp_assets: BTreeSet<AssetId>,

    dealer_orders: BTreeMap<(AssetPair, TradeDir), OrderData>,

    event_sender: UncheckedUnboundedSender<Event>,

    markets: BTreeMap<AssetPair, MarketInfo>,

    clients: BTreeMap<ClientId, ClientSender>,

    subscribed: BTreeMap<ExchangePair, PublicSubscribe>,
}

impl From<tokio::sync::oneshot::error::RecvError> for Error {
    fn from(_value: tokio::sync::oneshot::error::RecvError) -> Self {
        Error::ChannelClosed
    }
}

impl<T> From<tokio::sync::mpsc::error::SendError<T>> for Error {
    fn from(_value: tokio::sync::mpsc::error::SendError<T>) -> Self {
        Error::ChannelClosed
    }
}

fn get_exchange_pair(asset_pair: &AssetPair, network: Network) -> Option<ExchangePair> {
    let base = dealer_ticker_from_asset_id(network, &asset_pair.base)?;
    let quote = dealer_ticker_from_asset_id(network, &asset_pair.quote)?;
    Some(ExchangePair { base, quote })
}

fn convert_public_order(
    order: &market::PublicOrder,
    base_precision: AssetPrecision,
) -> PublicOrder_ {
    PublicOrder_ {
        order_id: order.order_id,
        trade_dir: order.trade_dir,
        amount: asset_float_amount_(order.amount, base_precision),
        price: order.price,
    }
}

fn convert_own_order(order: &market::OwnOrder, network: Network) -> Option<OwnOrder_> {
    let exchange_pair = get_exchange_pair(&order.asset_pair, network)?;
    let base_precision = exchange_pair.base.asset_precision();

    Some(OwnOrder_ {
        exchange_pair,
        order_id: order.order_id,
        trade_dir: order.trade_dir,
        orig_amount: asset_float_amount_(order.orig_amount, base_precision),
        active_amount: asset_float_amount_(order.active_amount, base_precision),
        price: order.price,
    })
}

fn save_state(data: &Data) {
    persistent_state::save(&data.work_dir, &data.state);
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

    for asset in assets.assets.iter() {
        let ticker = dealer_ticker_from_asset_id(data.network, &asset.asset_id);
        if let Some(ticker) = ticker {
            let expected = ticker.asset_precision();
            let actual = asset.precision;
            assert_eq!(
                expected, actual,
                "invalid asset precision: {actual}, expected: {expected}, ticker: {ticker}"
            );
        }
    }

    data.amp_assets = assets
        .assets
        .iter()
        .filter_map(|asset| (asset.market_type == Some(MarketType::Amp)).then_some(asset.asset_id))
        .collect();

    data.assets = assets.assets;

    let resp = make_market_request!(data.ws, ListMarkets, ListMarketsRequest {})?;
    data.markets = resp
        .markets
        .into_iter()
        .map(|market| (market.asset_pair, market))
        .collect();

    if let Some(token) = &data.state.token {
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
                data.state.token = None;
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

    data.state.token = Some(token);
    save_state(data);

    Ok(resp)
}

async fn process_ws_connected(data: &mut Data) {
    let LoginResponse { orders, utxos } = try_login(data).await.expect("login failed unexpectedly");

    for orders in data.dealer_orders.values_mut() {
        orders.server_orders.clear();
    }

    for order in orders {
        data.dealer_orders
            .entry((order.asset_pair, order.trade_dir))
            .or_default()
            .server_orders
            .insert(order.order_id, order);
    }

    data.server_utxos = utxos.into_iter().collect();

    for event_sender in data.clients.values() {
        event_sender.send(ClientEvent::ServerConnected);
    }
}

fn process_ws_disconnected(data: &mut Data) {
    for market in data.dealer_orders.values_mut() {
        market.server_orders.clear();
    }

    // This will disconnect all WS clients, we need to force them to re-subscribe
    data.clients.clear();
    data.subscribed.clear();
}

fn process_sign_notif(data: &mut Data, notif: MakerSignNotif) {
    let pset = b64::decode(&notif.pset).expect("invalid base64 pset");
    let pset =
        elements::encode::deserialize::<PartiallySignedTransaction>(&pset).expect("invalid pset");

    // FIXME: Verify PSET amounts

    data.event_sender.send(Event::SignSwap {
        quote_id: notif.quote_id,
        pset,
    });
}

fn process_market_notif(data: &mut Data, notif: Notification) {
    match notif {
        Notification::MarketAdded(notif) => {
            data.markets.insert(notif.market.asset_pair, notif.market);
        }
        Notification::MarketRemoved(notif) => {
            data.markets.remove(&notif.asset_pair);
        }

        Notification::OwnOrderCreated(notif) => {
            data.dealer_orders
                .entry((notif.order.asset_pair, notif.order.trade_dir))
                .or_default()
                .server_orders
                .insert(notif.order.order_id, notif.order);
        }
        Notification::OwnOrderRemoved(notif) => {
            for market in data.dealer_orders.values_mut() {
                market.server_orders.remove(&notif.order_id);
            }
        }

        Notification::UtxoAdded(notif) => {
            data.server_utxos.insert(notif.utxo);
        }
        Notification::UtxoRemoved(notif) => {
            data.server_utxos.remove(&notif.utxo);
        }

        Notification::PublicOrderCreated(notif) => {
            let exchange_pair =
                get_exchange_pair(&notif.order.asset_pair, data.network).expect("must be known");
            let subscribed = data
                .subscribed
                .get_mut(&exchange_pair)
                .expect("must be known");

            let base_precision = exchange_pair.base.asset_precision();
            let order = convert_public_order(&notif.order, base_precision);

            for event_sender in subscribed.clients.values() {
                event_sender.send(ClientEvent::OrderAdded {
                    exchange_pair,
                    order: order.clone(),
                });
            }

            subscribed.orders.insert(order.order_id, order);
        }
        Notification::PublicOrderRemoved(notif) => {
            let exchange_pair =
                get_exchange_pair(&notif.asset_pair, data.network).expect("must be known");
            let subscribed = data
                .subscribed
                .get_mut(&exchange_pair)
                .expect("must be known");

            for event_sender in subscribed.clients.values() {
                event_sender.send(ClientEvent::OrderRemoved {
                    exchange_pair,
                    order_id: notif.order_id,
                });
            }

            subscribed.orders.remove(&notif.order_id);
        }

        Notification::MakerSign(notif) => {
            process_sign_notif(data, notif);
        }

        Notification::Quote(_) => {}

        Notification::MarketPrice(notif) => {
            let exchange_pair =
                get_exchange_pair(&notif.asset_pair, data.network).expect("must be known");
            let subscribed = data
                .subscribed
                .get_mut(&exchange_pair)
                .expect("must be known");

            subscribed.ind_price = notif.ind_price;
            subscribed.last_price = notif.last_price;

            for event_sender in subscribed.clients.values() {
                event_sender.send(ClientEvent::MarketPrice {
                    exchange_pair,
                    ind_price: notif.ind_price,
                    last_price: notif.last_price,
                });
            }
        }

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
            process_market_notif(data, notif);
        }

        WrappedResponse::Response(_) => {}
    }
}

async fn subscribe(
    data: &mut Data,
    exchange_pair: ExchangePair,
    client_id: Option<ClientId>,
) -> Result<OrderBook, Error> {
    verify!(data.ws.connected(), Error::ServerDisconnected);

    let new_market = !data.subscribed.contains_key(&exchange_pair);

    if new_market {
        let asset_pair = AssetPair {
            base: dealer_ticker_to_asset_id(data.network, exchange_pair.base),
            quote: dealer_ticker_to_asset_id(data.network, exchange_pair.quote),
        };

        let resp =
            make_market_request!(data.ws, Subscribe, market::SubscribeRequest { asset_pair })?;
        let base_precision = exchange_pair.base.asset_precision();
        let orders = resp
            .orders
            .into_iter()
            .map(|order| (order.order_id, convert_public_order(&order, base_precision)))
            .collect();

        data.subscribed.insert(
            exchange_pair,
            PublicSubscribe {
                orders,
                clients: BTreeMap::new(),
                ind_price: None,
                last_price: None,
            },
        );
    }

    let subscribed = data.subscribed.get_mut(&exchange_pair).expect("must exist");

    let order_book = OrderBook {
        orders: subscribed.orders.values().cloned().collect(),
        timestamp: TimestampMs::now(),
    };

    if let Some(client_id) = client_id {
        let client_event = data.clients.get(&client_id).expect("must exist");
        subscribed.clients.insert(client_id, client_event.clone());

        if !new_market {
            client_event.send(ClientEvent::MarketPrice {
                exchange_pair,
                ind_price: subscribed.ind_price,
                last_price: subscribed.last_price,
            });
        }
    }

    Ok(order_book)
}

async fn process_client_command(data: &mut Data, command: ClientCommand) {
    match command {
        ClientCommand::Metadata { res_sender } => {
            res_sender.send(Metadata {
                server_connected: data.ws.connected(),
                assets: data
                    .assets
                    .iter()
                    .filter(|asset| {
                        dealer_ticker_from_asset_id(data.network, &asset.asset_id).is_some()
                    })
                    .cloned()
                    .collect(),
                markets: data
                    .markets
                    .values()
                    .filter_map(|market| -> Option<Market> {
                        let exchange_pair = get_exchange_pair(&market.asset_pair, data.network)?;
                        Some(Market {
                            base: exchange_pair.base,
                            quote: exchange_pair.quote,
                        })
                    })
                    .collect(),
            });
        }

        ClientCommand::Balances { res_sender } => {
            let mut wallet = BTreeMap::<AssetId, u64>::new();
            let mut server = BTreeMap::<AssetId, u64>::new();

            for utxo in data.wallet_utxos.iter() {
                *wallet.entry(utxo.asset).or_default() += utxo.value;
                if data.server_utxos.contains(&utxo.outpoint()) {
                    *server.entry(utxo.asset).or_default() += utxo.value;
                }
            }

            let convert_balances = |balances: BTreeMap<AssetId, u64>| {
                balances
                    .into_iter()
                    .filter_map(|(asset_id, balance)| -> Option<(DealerTicker, f64)> {
                        let ticker = dealer_ticker_from_asset_id(data.network, &asset_id)?;
                        let value = asset_float_amount_(balance, ticker.asset_precision());
                        Some((ticker, value))
                    })
                    .collect()
            };

            res_sender.send(Balances {
                wallet: convert_balances(wallet),
                server: convert_balances(server),
            });
        }

        ClientCommand::OrderBook {
            exchange_pair,
            res_sender,
        } => {
            // This will block only when a new market added
            let res = subscribe(data, exchange_pair, None).await;
            res_sender.send(res);
        }

        ClientCommand::OwnOrders { res_sender } => {
            let res = if data.ws.connected() {
                let mut orders = Vec::new();
                for market in data.dealer_orders.values() {
                    for order in market.server_orders.values() {
                        let order = convert_own_order(order, data.network).expect("must not fail");
                        orders.push(order);
                    }
                }
                Ok(OwnOrders { orders })
            } else {
                Err(Error::TryAgain)
            };
            res_sender.send(res);
        }

        ClientCommand::SubmitOrder {
            exchange_pair,
            base_amount,
            price,
            trade_dir,
            res_sender,
        } => {
            data.mode.check_ws_edit_allowed();

            let base_precision = exchange_pair.base.asset_precision();
            let base_amount = asset_int_amount_(base_amount, base_precision);

            let asset_pair = AssetPair {
                base: dealer_ticker_to_asset_id(data.network, exchange_pair.base),
                quote: dealer_ticker_to_asset_id(data.network, exchange_pair.quote),
            };

            // FIXME: Return error or wait until addresses are available received
            // FIXME: Resolve GAID for AMP buy requests
            if data.addresses.len() >= 2 {
                let network = data.network;
                data.ws.callback_request(
                    sideswap_api::Request::Market(Request::AddOrder(market::AddOrderRequest {
                        asset_pair,
                        base_amount,
                        price,
                        trade_dir,
                        ttl: None,
                        receive_address: data.addresses.pop_front().expect("must not fail"),
                        change_address: data.addresses.pop_front().expect("must not fail"),
                        private: false,
                    })),
                    Box::new(move |res| {
                        let res = match res {
                            Ok(sideswap_api::Response::Market(market::Response::AddOrder(
                                resp,
                            ))) => {
                                Ok(convert_own_order(&resp.order, network).expect("must not fail"))
                            }
                            Ok(_) => Err(Error::UnexpectedResponse("AddOrder")),
                            Err(err) => Err(Error::WsRequestError(err)),
                        };
                        res_sender.send(res);
                    }),
                );
            } else {
                // FIXME: Do something better here
                res_sender.send(Err(Error::TryAgain));
            }
        }

        ClientCommand::CancelOrder {
            order_id,
            res_sender,
        } => {
            data.mode.check_ws_edit_allowed();

            data.ws.callback_request(
                sideswap_api::Request::Market(Request::CancelOrder(market::CancelOrderRequest {
                    order_id,
                })),
                Box::new(move |res| {
                    let res = match res {
                        Ok(sideswap_api::Response::Market(market::Response::CancelOrder(
                            _resp,
                        ))) => Ok(()),
                        Ok(_) => Err(Error::UnexpectedResponse("CancelOrder")),
                        Err(err) => Err(Error::WsRequestError(err)),
                    };
                    res_sender.send(res);
                }),
            );
        }

        ClientCommand::ClientConnected {
            client_id,
            event_sender,
        } => {
            if data.ws.connected() {
                event_sender.send(ClientEvent::ServerConnected);
            }
            let prev_data = data.clients.insert(client_id, event_sender);
            assert!(prev_data.is_none());
        }

        ClientCommand::ClientDisconnected { client_id } => {
            // The client may be already disconnected by us
            data.clients.remove(&client_id);

            for subscribed in data.subscribed.values_mut() {
                subscribed.clients.remove(&client_id);
            }
        }

        ClientCommand::WsSubscribe {
            client_id,
            exchange_pair,
            res_sender,
        } => {
            let res = subscribe(data, exchange_pair, Some(client_id)).await;
            res_sender.send(res);
        }
    }
}

fn process_command(data: &mut Data, command: Command) {
    match command {
        Command::AutomaticOrders { orders } => {
            match data.mode {
                Mode::PriceStream => {}
                Mode::WebServer => {
                    assert!(orders.is_empty(), "Please disable automatic price streaming as the web server is used to control orders");
                }
            }

            for market in data.dealer_orders.values_mut() {
                market.dealer_orders.clear();
            }

            for order in orders {
                data.dealer_orders
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
    market: &mut OrderData,
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
    if data.addresses.len() < ADDRESS_POOL_COUNT {
        data.event_sender.send(Event::GetNewAddress);
    }

    if data.ws.connected() {
        let res = try_sync_utxos(data).await;
        if let Err(err) = res {
            log::warn!("utxo sync failed: {err}");
        }

        match data.mode {
            Mode::PriceStream => {
                // Sync orders
                for market in data.dealer_orders.values_mut() {
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
            }

            Mode::WebServer => {
                // Do nothing, web server is used to manage the orders
            }
        }
    }
}

async fn run(
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

    let (client_sender, mut client_receiver) = unbounded_channel::<ClientCommand>();

    if let Some(config) = params.web_server.clone() {
        web_server::start(config, client_sender.clone());
    }

    if let Some(config) = params.ws_server.clone() {
        ws_server::start(config, client_sender);
    }

    let mode = if params.web_server.is_some() {
        Mode::WebServer
    } else {
        Mode::PriceStream
    };

    let state = persistent_state::load(&params.work_dir);

    let mut data = Data {
        network: params.env.d().network,
        mode,
        work_dir: params.work_dir,
        state,
        ws,
        wallet_utxos: Vec::new(),
        server_utxos: BTreeSet::new(),
        addresses: VecDeque::new(),
        gaid: None,
        assets: Vec::new(),
        amp_assets: BTreeSet::new(),
        dealer_orders: BTreeMap::new(),
        event_sender: event_sender.into(),
        markets: BTreeMap::new(),
        clients: BTreeMap::new(),
        subscribed: BTreeMap::new(),
    };

    let mut interval = tokio::time::interval(Duration::from_secs(1));

    loop {
        tokio::select! {
            event = data.ws.recv() => {
                process_ws_event(&mut data, event).await;
            },

            command = command_receiver.recv() => {
                match command {
                    Some(command) => {
                        process_command(&mut data, command);
                    },
                    None => {
                        log::debug!("stop worker thread");
                        break;
                    },
                }
            },

            command = client_receiver.recv() => {
                let command = command.expect("channel must be open");
                process_client_command(&mut data, command).await;
            },

            _ = interval.tick() => {
                process_timer(&mut data).await;
            },
        }
    }
}

pub fn start(params: Params) -> (UnboundedSender<Command>, UnboundedReceiver<Event>) {
    let (command_sender, command_receiver) = unbounded_channel::<Command>();
    let (event_sender, event_receiver) = unbounded_channel::<Event>();

    tokio::spawn(run(params, command_receiver, event_sender));

    (command_sender, event_receiver)
}
