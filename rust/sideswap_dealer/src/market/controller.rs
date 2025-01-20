use elements::{Address, AssetId};
use sideswap_api::{
    mkt::{AssetPair, AssetType, OrdId, QuoteId, TradeDir},
    Asset,
};
use sideswap_common::{
    channel_helpers::UncheckedUnboundedSender, dealer_ticker::dealer_ticker_to_asset_id,
    exchange_pair::ExchangePair, network::Network, types::asset_int_amount_,
};
use sideswap_types::{normal_float::NormalFloat, timestamp_ms::TimestampMs};
use tokio::sync::{mpsc::UnboundedSender, oneshot};

use super::{
    try_convert_asset_amount, Balances, ClientCommand, ClientEvent, ClientId, Error, HistoryOrders,
    Metadata, OrderBook, OwnOrder, OwnOrders, StartQuotesResp,
};

#[derive(Clone)]
pub struct Controller {
    network: Network,
    command_sender: UnboundedSender<ClientCommand>,
}

async fn recv<T>(receiver: oneshot::Receiver<T>) -> Result<T, Error> {
    receiver.await.map_err(Into::into)
}

async fn recv_res<T>(receiver: oneshot::Receiver<Result<T, super::Error>>) -> Result<T, Error> {
    let resp = receiver.await??;
    Ok(resp)
}

impl Controller {
    pub fn new(network: Network, command_sender: UnboundedSender<ClientCommand>) -> Controller {
        Controller {
            network,
            command_sender,
        }
    }

    fn send_command(&self, command: ClientCommand) {
        let res = self.command_sender.send(command);
        if let Err(err) = res {
            log::error!("client command sending failed: {err}");
        }
    }

    fn make_request(&self, command: ClientCommand) -> Result<(), Error> {
        self.command_sender.send(command)?;
        Ok(())
    }

    pub async fn metadata(&self) -> Result<Metadata, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(ClientCommand::Metadata {
            res_sender: res_sender.into(),
        })?;
        let resp = recv(res_receiver).await?;
        Ok(resp)
    }

    pub async fn get_asset(&self, asset_id: &AssetId) -> Result<Asset, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(ClientCommand::GetAsset {
            asset_id: *asset_id,
            res_sender: res_sender.into(),
        })?;
        let resp = recv_res(res_receiver).await?;
        Ok(resp)
    }

    pub async fn get_gaid(&self) -> Result<String, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(ClientCommand::GetGaid {
            res_sender: res_sender.into(),
        })?;
        let resp = recv_res(res_receiver).await?;
        Ok(resp)
    }

    pub async fn resolve_gaid(&self, asset_id: AssetId, gaid: String) -> Result<Address, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(ClientCommand::ResolveGaid {
            asset_id,
            gaid,
            res_sender: res_sender.into(),
        })?;
        let resp = recv_res(res_receiver).await?;
        Ok(resp)
    }

    pub async fn order_book(&self, exchange_pair: ExchangePair) -> Result<OrderBook, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(ClientCommand::OrderBook {
            exchange_pair,
            res_sender: res_sender.into(),
        })?;
        let resp = recv_res(res_receiver).await?;
        Ok(resp)
    }

    pub async fn own_order(&self, order_id: OrdId) -> Result<OwnOrder, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(ClientCommand::GetOwnOrder {
            order_id,
            res_sender: res_sender.into(),
        })?;
        let resp = recv_res(res_receiver).await?;
        Ok(resp)
    }

    pub async fn own_orders(&self) -> Result<OwnOrders, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(ClientCommand::GetOwnOrders {
            res_sender: res_sender.into(),
        })?;
        let resp = recv_res(res_receiver).await?;
        Ok(resp)
    }

    pub async fn new_address(&self) -> Result<Address, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(ClientCommand::NewAddress {
            res_sender: res_sender.into(),
        })?;
        let address = res_receiver.await?.map_err(Error::WalletError)?;
        Ok(address)
    }

    async fn resolve_recv_address(&self, recv_asset_id: AssetId) -> Result<Address, Error> {
        let recv_asset = self.get_asset(&recv_asset_id).await?;
        let recv_amp = recv_asset.market_type == Some(sideswap_api::MarketType::Amp);

        let receive_address = if recv_amp {
            let gaid = self.get_gaid().await?;
            self.resolve_gaid(recv_asset_id, gaid).await?
        } else {
            self.new_address().await?
        };
        Ok(receive_address)
    }

    pub async fn submit_order(
        &self,
        exchange_pair: ExchangePair,
        base_amount: f64,
        price: NormalFloat,
        trade_dir: TradeDir,
        client_order_id: Option<Box<String>>,
    ) -> Result<OwnOrder, Error> {
        let recv_asset = match trade_dir {
            TradeDir::Sell => exchange_pair.quote,
            TradeDir::Buy => exchange_pair.base,
        };
        let recv_asset_id = dealer_ticker_to_asset_id(self.network, recv_asset);

        let receive_address = self.resolve_recv_address(recv_asset_id).await?;
        let change_address = self.new_address().await?;

        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(ClientCommand::SubmitOrder {
            exchange_pair,
            base_amount,
            price,
            trade_dir,
            client_order_id,
            res_sender: res_sender.into(),
            receive_address,
            change_address,
        })?;
        let resp = recv_res(res_receiver).await?;
        Ok(resp)
    }

    pub async fn edit_order(
        &self,
        order_id: OrdId,
        base_amount: Option<f64>,
        price: Option<NormalFloat>,
    ) -> Result<OwnOrder, Error> {
        let order = self.own_order(order_id).await?;
        let base_precision = order.exchange_pair.base.asset_precision();
        let base_amount = base_amount.map(|amount| asset_int_amount_(amount, base_precision));

        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(ClientCommand::EditOrder {
            order_id,
            base_amount,
            price,
            res_sender: res_sender.into(),
        })?;
        let resp = recv_res(res_receiver).await?;
        Ok(resp)
    }

    pub async fn cancel_order(&self, order_id: OrdId) -> Result<(), Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(ClientCommand::CancelOrder {
            order_id,
            res_sender: res_sender.into(),
        })?;
        let resp = recv_res(res_receiver).await?;
        Ok(resp)
    }

    pub async fn balances(&self) -> Result<Balances, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(ClientCommand::Balances {
            res_sender: res_sender.into(),
        })?;
        let resp = recv(res_receiver).await?;
        Ok(resp)
    }

    pub async fn get_history_orders(
        &self,
        start_time: Option<TimestampMs>,
        end_time: Option<TimestampMs>,
        skip: Option<usize>,
        count: Option<usize>,
    ) -> Result<HistoryOrders, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(ClientCommand::GetHistory {
            start_time,
            end_time,
            skip,
            count,
            res_sender: res_sender.into(),
        })?;
        let resp = recv_res(res_receiver).await?;
        Ok(resp)
    }

    pub fn client_connected(
        &self,
        client_id: ClientId,
        event_sender: UncheckedUnboundedSender<ClientEvent>,
    ) {
        self.send_command(ClientCommand::ClientConnected {
            client_id,
            event_sender: event_sender.into(),
        });
    }

    pub fn client_disconnected(&self, client_id: ClientId) {
        self.send_command(ClientCommand::ClientDisconnected { client_id });
    }

    pub async fn subscribe(
        &self,
        client_id: ClientId,
        exchange_pair: ExchangePair,
    ) -> Result<OrderBook, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(ClientCommand::WsSubscribe {
            client_id,
            exchange_pair,
            res_sender: res_sender.into(),
        })?;
        let resp = recv_res(res_receiver).await?;
        Ok(resp)
    }

    pub async fn start_quotes(
        &self,
        client_id: ClientId,
        exchange_pair: ExchangePair,
        asset_type: AssetType,
        amount: f64,
        trade_dir: TradeDir,
        order_id: Option<OrdId>,
        private_id: Option<Box<String>>,
    ) -> Result<StartQuotesResp, Error> {
        let asset_pair = AssetPair {
            base: dealer_ticker_to_asset_id(self.network, exchange_pair.base),
            quote: dealer_ticker_to_asset_id(self.network, exchange_pair.quote),
        };

        let base_trade_dir = trade_dir.base_trade_dir(asset_type);
        let recv_asset = TradeDir::recv_asset(base_trade_dir);
        let receive_asset_id = asset_pair.asset(recv_asset);

        let receive_address = self.resolve_recv_address(receive_asset_id).await?;
        let change_address = self.new_address().await?;

        let asset = exchange_pair.asset(asset_type);
        let asset_precision = asset.asset_precision();
        let amount = try_convert_asset_amount(amount, asset_precision)?;

        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(ClientCommand::WsStartQuotes {
            req: super::StartQuotesReq {
                client_id,
                asset_pair,
                asset_type,
                amount,
                trade_dir,
                order_id,
                private_id,
                receive_address,
                change_address,
            },
            res_sender: res_sender.into(),
        })?;

        let resp = recv_res(res_receiver).await?;
        Ok(resp)
    }

    pub fn stop_quotes(&self) {
        let res = self.make_request(ClientCommand::WsStopQuotes {});
        if let Err(err) = res {
            log::error!("stopping quotes failed: {err}");
        }
    }

    pub async fn accept_quote(&self, quote_id: QuoteId) -> Result<elements::Txid, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(ClientCommand::WsAcceptQuote {
            req: super::AcceptQuoteReq { quote_id },
            res_sender: res_sender.into(),
        })?;
        let super::AcceptQuoteResp { txid } = recv_res(res_receiver).await?;
        Ok(txid)
    }
}
