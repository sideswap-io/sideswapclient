
### Creating a new swap

HTTP POST: `http://<API_ADDRESS>/orders/new`

Request:
`asset_id` - selected asset id
`asset_amount` - asset amount as a float number (positive for selling asset, negative for buying specified asset)
`ttl_seconds` - for how long the order will be live
`price` - asset price in L-BTC
`private` - if true, the order will not be visible in the public order book
`unique_key` - optional key that can be used to prevent taking multiple orders from the same client.

Response:
`order_id` - new order id
`asset_id` - same as in the request
`bitcoin_amount` - bitcoin amount in satoshi
`asset_amount` - asset amount in satoshi
`price` - same as in the request
`private` - same as in the request

Example request:
```
curl -H"Content-Type: application/json" http://127.0.0.1:8080/orders/new -d '{"asset_id":"649f01bd72fbe33a70508e752044a2b0f91cf73612b70e03f337d095daa8b002", "asset_amount":1, "price": 0.0001, "ttl_seconds": 60, "private": true, "unique_key":"12345"}'

{"order_id":"fe1eb9b0baada0c880c27c32202e03e13ec6583f6d2ffd3b940d58ca89217a34","asset_id":"649f01bd72fbe33a70508e752044a2b0f91cf73612b70e03f337d095daa8b002","bitcoin_amount":10000,"asset_amount":1,"price":0.0001,"private":true}
```

When a new order is created, display the QR code of this string for mobile applications:
```
https://app.sideswap.io/submit/?order_id=<ORDER_ID>
```
In desktop applications, the same string can be used with the URL button (copy and paste the link as text).
Once a new swap request has been created, you can check its status.
If an order has expired, a new request can be created for a specific user (with the same `unique_key` value).
Creating new requests locks the available UTOXs, so only a limited number of requests can be active at the same time. So it's often better to use a short TTL.

### Get existing swap status

HTTP GET: `http://<API_ADDRESS>/orders/<ORDER_ID>/status`

Response:
`status` - order status
`txid` - transaction hash if swap succeed

Possible order statuses:
`Active` - order is active and waiting for the user
`Expired` - order timed out
`Succeed` - swap succeed (txid will be set in this case)

Example request:
```
curl http://127.0.0.1:8080/orders/a24f266aa771ee1fb2c607d326aee054a12893bcb87c2bcc5ec2a5c6066aee22/status
{"status":"Active","txid":null}
```

### Dealer errors
All dealer errors are returned in this format:
```
{"error_msg":"<ERROR_MESSAGE>"}
```

Example errors:
`no inputs found` - no free UTXOs found (e.g. if there are too many active orders)
`duplicated order requested` - request with the same unique_key already exists and is in `Active` or `Succeed` state
`too many active requests` - there are too many active PSET sign requests in the queue
`unknown order` - order id is not known

### Running the dealer
The following instructions have been tested on Debian 12 (Bookworm).
Install build dependencies:
```
sudo apt install build-essential git clang lld autoconf automake pkg-config libtool curl cmake python python-is-python3 libudev-dev
```

Install Rust:
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > "$HOME/rustup.sh"
bash "$HOME/rustup.sh" -y -q
source "$HOME/.cargo/env"
```

Build GDK:
```
cd $HOME
git clone https://github.com/sideswap-io/gdk
cd gdk
git checkout sswp4
./tools/build.sh --clang
```

Build and run the dealer:
```
cd $HOME
git clone https://github.com/sideswap-io/sideswapclient
cd sideswapclient/rust/sideswap_headless_server
export GDK_DIR=$HOME/gdk/build-clang
cargo run --release -- config/testnet.toml
```

Or download the precompiled binary. The latest build for Linux is available at `https://sideswap.io/download/sideswap_headless_server`.
```
curl https://sideswap.io/download/sideswap_headless_server > sideswap_headless_server
chmod +x sideswap_headless_server
./sideswap_headless_server config/testnet.toml
```
