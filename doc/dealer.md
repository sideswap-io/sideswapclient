# SideSwap dealer example

## Build instructions

Example dealer connects to the production server and uses [https://blockchain.info/ticker](https://blockchain.info/ticker) to get index price for demonstration purposes.

1. Start Liquid node:

Download server from [https://github.com/ElementsProject/elements/releases](https://github.com/ElementsProject/elements/releases)

Linux/macOS:

```shell
/path/to/elementsd -conf=/dev/null -daemon=0 -server=1 -datadir=/path/to/datadir -validatepegin=0 \
    -rpcuser=dealer -rpcpassword=<YOUR_RPC_PASSWORD>
```

Wait until node fully syncs blockchain.
RPC connection from the automated dealer to `elementsd` is used by retreive UTXO list and construct/sign PSET.
Dealing funds will be stored in the node's wallet.

More details [https://help.blockstream.com/hc/en-us/articles/900002026026-How-do-I-set-up-a-Liquid-node-](https://help.blockstream.com/hc/en-us/articles/900002026026-How-do-I-set-up-a-Liquid-node-).

2. Receive dealer's address.

```shell
elements-cli -rpcpassword=<YOUR_RPC_PASSWORD> getnewaddress
```

Send some balance to the dealer's address (0.0002 L-BTC should be enough for the test).

Check that the dealer received it:

```shell
elements-cli -rpcpassword=<YOUR_RPC_PASSWORD> getwalletinfo
```

Output:

```
{
  "balance": {
    "bitcoin": 0.00020000
  },
  ...
}
```

3. Update dealer's config (`rust/sideswap_dealer_example/config/dealer_example_config.toml`):

```
...
password = "<YOUR_RPC_PASSWORD>"
```

Change RPC `password` here.

4. Download and install Rust compiler. Please use instructions at [https://rustup.rs/](https://rustup.rs/).

5. Start dealer

```shell
cd rust/sideswap_dealer_example
cargo run -- config/dealer_example_config.toml
```

6. Open `https://sideswap.io` to see your orders. The dealer will submit own and quote other's orders.
