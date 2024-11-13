use std::time::Duration;

use serde::Deserialize;
use sideswap_common::{channel_helpers::UncheckedUnboundedSender, http_client::HttpClient};

use crate::{ExchangePair, Msg};

#[derive(Debug, Clone, Deserialize)]
pub struct Settings {
    btc_usdt: String,
    btc_eurx: String,
    eurx_usdt: String,
}

#[derive(Deserialize)]
struct TickerPrice {
    price: String,
}

async fn current_price(client: &HttpClient, url: &str) -> Result<f64, anyhow::Error> {
    let resp = client.get_json::<TickerPrice>(url).await?;
    let price = resp.price.parse()?;
    Ok(price)
}

async fn try_load(
    client: &HttpClient,
    url: &str,
    exchange_pair: ExchangePair,
    msg_tx: &UncheckedUnboundedSender<Msg>,
) {
    let res = current_price(client, url).await;
    msg_tx.send(Msg::External(exchange_pair, res));
}

pub async fn reload(settings: Settings, msg_tx: UncheckedUnboundedSender<Msg>) {
    let client = HttpClient::new();
    loop {
        try_load(&client, &settings.btc_usdt, ExchangePair::BtcUsdt, &msg_tx).await;
        try_load(&client, &settings.btc_eurx, ExchangePair::BtcEur, &msg_tx).await;
        try_load(&client, &settings.eurx_usdt, ExchangePair::EurUsdt, &msg_tx).await;
        tokio::time::sleep(Duration::from_secs(30)).await;
    }
}
