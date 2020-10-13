use sideswap_api::*;
use sideswap_common::*;

// Put your dealer logic here.
// UTXO availability and reservation, max_trade_amount will be checked later

pub fn get_proposal(
    settings: &super::Settings,
    rfq_send_amount: types::Amount,
    other_asset: &Asset,
    dealer_send_bitcoin: bool,
) -> Result<types::Amount, anyhow::Error> {
    let bitcoin_price = match other_asset.ticker.as_ref() {
        // For USDt use download_bitcoin_last_usd_price to get bitcoin price
        TICKER_TETHER => super::prices::download_bitcoin_last_usd_price()
            .map_err(|e| anyhow!("download price failed: {}", e))?,
        // Ignore all other assets
        _ => bail!("unknown asset: {}", &other_asset.ticker),
    };

    // Please note that this does not take into account server and network fee (will be applied to bitcoin receiver)

    // Calculate how much dealer will send in the proposal
    let proposal = if dealer_send_bitcoin {
        rfq_send_amount.to_bitcoin() / (bitcoin_price * settings.profit_ratio)
    } else {
        rfq_send_amount.to_bitcoin() * (bitcoin_price / settings.profit_ratio)
    };

    Ok(types::Amount::from_bitcoin(proposal))
}
