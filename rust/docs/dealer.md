# SideSwap dealer

Tutorial on how to run own dealer.

## Decide in which market you want to participate

There are 3 types of markets - Stablecoin, AMP and Token. Stablecoin markets are based on selected list of stablecoin assets. Currently available stablecoins: USDt, EURx, DePix and MEX. Assets can be traded against L-BTC (Liquid Bitcoin) or each other. AMP markets are based on selected list of AMP assets. Some of the AMP assets are SSWP, CMSTR, BMN2. Token markets can be any registered in the GDK registry asset. Currently the dealer only supports the PPRGB asset as a token market asset and all the other token markets are ignored. To see the list of all supported markets you can visit https://sideswap.io/dealer-demo/api/metadata

## Decide which wallet to use

- LWK (https://github.com/sideswap-io/sideswapclient/tree/master/rust/sideswap_dealer_lwk)
Uses a single-sig native or nested segwit account.  Easy to start, as only a mnemonic is needed. Can't be used to hold AMP assets. However, loading UTXOs can become slow after accumulating a lot of history.

- AMP (https://github.com/sideswap-io/sideswapclient/tree/master/rust/sideswap_dealer_amp)
Uses AMP account and the Green backend. Easy to start, as only a mnemonic is needed. Can be used to trade all types of assets (including AMP).

- Elements node (https://github.com/sideswap-io/sideswapclient/tree/master/rust/sideswap_dealer_elements).
Uses single-sig native and nested segwit addresses. Can't be used to hold AMP assets. Recommended for high volume of transactions, as setup is more complicated. It also supports the old instant swaps API (API key required).

The listed clients share most of the same code and configuration format. Only the wallet code is different.

## Decide how orders should be managed

### Automatically

The orders will be managed by the dealer itself. The dealer loads prices from an URL (such as Binance or Bitfinex) or from the config and automatically submits orders.
Supported price sources:
- Binance (L-BTC/USDt, L-BTC/EURx, EURx/USDt, L-BTC/MEX, USDt/MEX).
- Bitfinex (L-BTC/USDt, L-BTC/EURx, EURx/USDt).
- BitPreço (L-BTC/DePix, USDt/DePix).
- SideSwap (all the markets where the index price is available, currently all the stablecoin markets and CMSTR/L-BTC).
- Or fixed price in USD. Available for any asset (asset/L-BTC and asset/USDt markets).

### Custom script or program

The dealer opens HTTP and WebSocket endpoints and the client uses them to manage orders.

Demo dealer (with HTTP and WebSocket endpoints) is hosted by SideSwap for testing purposes.
OpenAPI specification: https://sideswap.io/dealer-demo/spec
Swagger UI: https://sideswap.io/dealer-demo/
WebSocket: wss://sideswap.io/dealer-demo-ws/
Use https://github.com/sideswap-io/sideswapclient/blob/master/rust/sideswap_dealer/src/market/api.rs to see the WebSocket messages format (starting from the `To` and `From` messages).

Liquid Testnet demo with some balance is available at https://testnet.sideswap.io/dealer-demo/ and wss://testnet.sideswap.io/dealer-demo-ws/.

##  Get the binary to run

### Building from source
1. Install Rust compiler. See https://rustup.rs for instructions.
2. Clone sources:
```shell
git clone https://github.com/sideswap-io/sideswapclient
```
3. Build the dealer.
Example for `sideswap_dealer_lwk`:
```shell
cd sideswapclient/rust/sideswap_dealer_lwk
cargo build --release
```
### Download compiled binary
Compiled for Linux binaries are available at https://sideswap.io/download/.
Example for `sideswap_dealer_lwk`:
```shell
curl https://sideswap.io/download/sideswap_dealer_lwk > sideswap_dealer_lwk
chmod +x sideswap_dealer_lwk
```

## Examples

Make sure you have a mnemonic backup and that it is securely generated. A leaked or lost mnemonic will result in an irreversible loss of funds!

### LWK dealer example

1. Save the config file as `config_lwk.toml`:
```toml
env = "Testnet" # Use "Prod" to use the Liquid network and connection to the production SideSwap server
work_dir = "/tmp/sideswap/lwk" # Work dir to store temporary files
mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about" # Or use own mnemonic
script_variant = "wpkh" # Use "shwpkh" for legacy segwit addresses

[[price_stream]]
base = "L-BTC"
quote = "USDt"
interest = 1.01
source = "Binance"
```

2. Start the dealer.
```shell
curl https://sideswap.io/download/sideswap_dealer_lwk > sideswap_dealer_lwk
chmod +x sideswap_dealer_lwk
./sideswap_dealer_lwk config_lwk.toml
```

Then go to https://testnet.sideswap.io/swap-market/ and your orders should appear there.
Debug log will be available at `/tmp/sideswap/lwk/logs/sideswap_dealer.txt`.
Make sure that the mnemonic is not used by the SideSwap wallet at the same time.

### AMP dealer example

1. Save the config file as `config_amp.toml`:
```toml
env = "Testnet" # Use "Prod" to use the Liquid network and connection to the production SideSwap server
work_dir = "/tmp/sideswap/amp" # Work dir to store temporary files
mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon  abandon about" # Or use own mnemonic

[[price_stream]]
base = "SSWP"
quote = "L-BTC"
source = "Fixed"
interest = 1.0
fixed.bid = 0.8
fixed.ask = 0.9

[[price_stream]]
base = "SSWP"
quote = "USDt"
source = "Fixed"
interest = 1.0
fixed.bid = 0.8
fixed.ask = 0.9
```

2. Start the dealer.
```shell
curl https://sideswap.io/download/sideswap_dealer_amp > sideswap_dealer_amp
chmod +x sideswap_dealer_amp
./sideswap_dealer_amp config_amp.toml
```

Then go to https://testnet.sideswap.io/swap-market/ and your orders should appear there.
Debug log will be available at `/tmp/sideswap/amp/logs/sideswap_dealer.txt`.

Your AMP ID should be whitelisted to hold the relevant AMP asset.
The L-BTC (or USDt) asset should be available on the AMP account to be able to submit buy orders.
Make sure that the mnemonic is not used by the SideSwap wallet at the same time.

### LWK dealer with manual order management

1. Save the config file as `config_manual.toml`:
```toml
env = "Testnet" # Use "Prod" to use the Liquid network and connection to the production SideSwap server
work_dir = "/tmp/sideswap/manual" # Work dir to store temporary files
mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon  abandon about" # Or use own mnemonic
script_variant = "wpkh" # Use "shwpkh" for legacy segwit addresses

price_stream = []

[web_server]
listen_on = "127.0.0.1:3101"
server_url = "http://127.0.0.1:3101/api"

[ws_server]
listen_on = "127.0.0.1:3102"
```

2. Start the dealer.
```shell
curl https://sideswap.io/download/sideswap_dealer_lwk > sideswap_dealer_lwk
chmod +x sideswap_dealer_lwk
./sideswap_dealer_lwk config_manual.toml
```

Open http://127.0.0.1:3101/ to see the Swagger UI locally.

Load the wallet balance:

```shell
curl -XGET 'http://127.0.0.1:3101/api/balances' -H 'accept: application/json; charset=utf-8'
```

Output:
```json
{"balance":{"L-BTC":0.00328108}}
```

Submit your order:

```shell
curl -XPOST 'http://127.0.0.1:3101/api/ submit_order?base=L-BTC&quote=USDt&base_amount=0.001&price=97555.5&trade_dir=Sell' -H 'accept: application/json; charset=utf-8'
```

```json
{
  "active_amount": 0.001,
  "base": "L-BTC",
  "client_order_id": null,
  "order_id": 1739600319429,
  "orig_amount": 0.001,
  "price": 97555.5,
  "quote": "USDt",
  "trade_dir": "Sell"
}
```

Connect to `ws://127.0.0.1:3102` to send and receive WebSocket messages:
```shell
websocat ws://127.0.0.1:3102
```

```json
{"Notif":{"notif":{"ServerConnected":{"own_orders":[{"order_id":1739600319429,"client_order_id":null,"base":"L-BTC","quote":"USDt","trade_dir":"Sell","orig_amount":0.001,"active_amount":0.001,"price":97555.5}]}}}}
{"Notif":{"notif":{"Balances":{"balance":{"L-BTC":0.00328108}}}}}
```

Then go to https://testnet.sideswap.io/swap-market/ and your order should appear there.
Debug log will be available at `/tmp/sideswap/manual/logs/sideswap_dealer.txt`.
Make sure that the mnemonic is not used by the SideSwap wallet at the same time.
