use anyhow::anyhow;
use sideswap_api::{mkt::AssetPair, PricePair};

use crate::{dealer_ticker::dealer_ticker_to_asset_id, env::Env, http_client::HttpClient};

use super::Market;

pub async fn get_price(
    env: Env,
    client: &HttpClient,
    market: &Market,
) -> Result<PricePair, anyhow::Error> {
    let network = env.d().network;

    let asset_pair = AssetPair {
        base: dealer_ticker_to_asset_id(network, market.base),
        quote: dealer_ticker_to_asset_id(network, market.quote),
    };

    let base_url = env.base_server_http_url();
    let url = format!("{base_url}/market");

    let resp = client
        .post::<sideswap_api::market::Response>(
            &url,
            sideswap_api::market::Request::MarketDetails(
                sideswap_api::market::MarketDetailsRequest { asset_pair },
            ),
        )
        .await?;

    let resp = match resp {
        sideswap_api::market::Response::MarketDetails(resp) => resp,
    };

    let ind_price = resp
        .ind_price
        .ok_or_else(|| anyhow!("index price is not available"))?;

    Ok(PricePair {
        bid: ind_price.value(),
        ask: ind_price.value(),
    })
}
