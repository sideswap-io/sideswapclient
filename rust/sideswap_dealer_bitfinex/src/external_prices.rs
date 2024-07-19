use std::time::Duration;

use serde::Deserialize;
use sideswap_common::channel_helpers::UncheckedUnboundedSender;
use sideswap_dealer::dealer::DealerTicker;

use crate::Msg;

#[derive(Debug, Clone, Deserialize)]
pub struct Settings {
    usdt_url: String,
    eurx_url: String,
}

#[derive(Deserialize)]
struct TickerPrice {
    price: String,
}

async fn current_price(client: &reqwest::Client, url: &str) -> Result<f64, anyhow::Error> {
    let resp = client.get(url).send().await?.json::<TickerPrice>().await?;
    let price = resp.price.parse()?;
    Ok(price)
}

async fn try_load(
    client: &reqwest::Client,
    url: &str,
    ticker: DealerTicker,
    msg_tx: &UncheckedUnboundedSender<Msg>,
) {
    let res = current_price(client, url).await;
    msg_tx.send(Msg::External(ticker, res));
}

pub async fn reload(settings: Settings, msg_tx: UncheckedUnboundedSender<Msg>) {
    let client = reqwest::Client::new();
    loop {
        try_load(&client, &settings.usdt_url, DealerTicker::USDt, &msg_tx).await;
        try_load(&client, &settings.eurx_url, DealerTicker::EURx, &msg_tx).await;
        tokio::time::sleep(Duration::from_secs(30)).await;
    }
}
