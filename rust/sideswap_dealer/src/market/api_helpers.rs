use sideswap_api::mkt;

use super::api;

impl From<super::Error> for api::Error {
    fn from(err: super::Error) -> Self {
        api::Error {
            code: err.code(),
            text: err.text(),
            details: err.details(),
        }
    }
}

impl From<mkt::TradeDir> for api::TradeDir {
    fn from(value: mkt::TradeDir) -> Self {
        match value {
            mkt::TradeDir::Sell => api::TradeDir::Sell,
            mkt::TradeDir::Buy => api::TradeDir::Buy,
        }
    }
}

impl Into<mkt::TradeDir> for api::TradeDir {
    fn into(self) -> mkt::TradeDir {
        match self {
            api::TradeDir::Sell => mkt::TradeDir::Sell,
            api::TradeDir::Buy => mkt::TradeDir::Buy,
        }
    }
}

impl From<super::Market> for api::Market {
    fn from(value: super::Market) -> Self {
        api::Market {
            base: value.base.to_string(),
            quote: value.quote.to_string(),
        }
    }
}

impl From<super::Metadata> for api::Metadata {
    fn from(value: super::Metadata) -> Self {
        api::Metadata {
            server_connected: value.server_connected,
            assets: value.assets.into_iter().map(Into::into).collect(),
            markets: value.markets.into_iter().map(Into::into).collect(),
        }
    }
}

impl From<super::Balances> for api::BalancesNotif {
    fn from(value: super::Balances) -> Self {
        api::BalancesNotif {
            balance: value
                .balance
                .into_iter()
                .map(|(ticker, value)| (ticker.to_string(), value))
                .collect(),
        }
    }
}

impl From<super::PublicOrder> for api::PublicOrder {
    fn from(value: super::PublicOrder) -> Self {
        api::PublicOrder {
            order_id: value.order_id.value(),
            trade_dir: value.trade_dir.into(),
            amount: value.amount,
            price: value.price.value(),
            online: value.online,
        }
    }
}

impl From<super::OwnOrder> for api::OwnOrder {
    fn from(value: super::OwnOrder) -> Self {
        api::OwnOrder {
            order_id: value.order_id.value(),
            client_order_id: value.client_order_id,
            base: value.exchange_pair.base.to_string(),
            quote: value.exchange_pair.quote.to_string(),
            trade_dir: value.trade_dir.into(),
            orig_amount: value.orig_amount,
            active_amount: value.active_amount,
            price: value.price.value(),
        }
    }
}

impl From<super::HistoryOrder> for api::HistoryOrder {
    fn from(value: super::HistoryOrder) -> Self {
        api::HistoryOrder {
            id: value.id.value(),
            order_id: value.order_id.value(),
            client_order_id: value.client_order_id,
            base: value.exchange_pair.base.to_string(),
            quote: value.exchange_pair.quote.to_string(),
            trade_dir: value.trade_dir.into(),
            base_amount: value.base_amount,
            quote_amount: value.quote_amount,
            price: value.price.value(),
            txid: value.txid.map(|txid| txid.to_string()),
            status: value.status.into(),
        }
    }
}

impl From<super::OrderBook> for api::OrderBook {
    fn from(value: super::OrderBook) -> Self {
        api::OrderBook {
            orders: value.orders.into_iter().map(Into::into).collect(),
        }
    }
}

impl From<super::OwnOrders> for api::OwnOrders {
    fn from(value: super::OwnOrders) -> Self {
        api::OwnOrders {
            orders: value.orders.into_iter().map(Into::into).collect(),
        }
    }
}

impl From<super::HistoryOrders> for api::HistoryOrders {
    fn from(value: super::HistoryOrders) -> Self {
        api::HistoryOrders {
            orders: value.orders.into_iter().map(Into::into).collect(),
            total: value.total,
        }
    }
}
