SideSwap dealer example
=======================

To be able connect as dealer to production server you will need own API key. More details at [sideswap.io](https://sideswap.io/).

Example dealer connects to staging server (`api-test.sideswap.io`) and uses [https://blockchain.info/ticker](https://blockchain.info/ticker) to get quoting price for demonstration purposes.

1. Download elements node:

Download server from https://github.com/ElementsProject/elements/releases

2. Start elements node:

```shell
/path/to/elementsd -conf=/dev/null -daemon=0 -server=1 -datadir=/path/to/datadir -validatepegin=0 \
    -rpcport=7041 -rpcuser=dealer -rpcpassword=<YOUR_RPC_PASSWORD> -zmqpubhashblock=tcp://0.0.0.0:14356
```

Dealer funds will be stored in the node wallet.

`rpcport`/`rpcuser`/`rpcpassword` are used for dealer connection to retreive UTXO list and construct/sign PSBT (using `rpcauth` is recommened for better security, please see elements instructions on how set it up).

`zmqpubhashblock` is used to detect new blocks and refresh UTXO list.

3. Download and install rust compiler:

Please use instructions at [https://rustup.rs/](https://rustup.rs/)

4. Update dealer config:


```
server_host = "api-test.sideswap.io"
server_port = 443
server_use_tls = true
api_key = "74b1331e904f354a1db3133ba6b21d52a4b99c7dfbbf677fa1c58bcbd602976c"
log_settings = "config/dealer_example_logs.yml"
max_trade_size = 0.001 # 0.001 L-BTC
profit_ratio = 1.015 # 1.5%

[rpc]
host = "localhost"
port = 7041
login = "dealer"
password = "<YOUR_RPC_PASSWORD>"

[zmq]
host = "localhost"
port = 14356
```

Change `api_key` and rpc `password`.

5. Start dealer

```shell
cd rust/sideswap_dealer_example
cargo run -- config/dealer_example_config.toml
```

Note that you will compete with other dealers and your profit_ratio value will affect outbids.

6. Connect client to the staging server:

```shell
./sideswap --staging
```

Please note that you need to use separate elements node for the client.
