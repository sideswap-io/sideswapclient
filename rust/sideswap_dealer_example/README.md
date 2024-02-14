
## Running example dealer

1. Install Rust: https://rustup.rs

2. Clone the sources:
```
git clone https://github.com/sideswap-io/sideswapclient
cd sideswapclient/rust/sideswap_dealer_example
```

3. Start the Elements node: https://github.com/ElementsProject/elements
Make sure RPC access is enabled, for example:
```
elementsd -rpcuser=username -rpcpassword=password -rpcport=12345
```

4. Modify `dealer_example_config.toml`:

Set the RPC parameters for the `Elements` node:
```
[rpc]
host = "localhost"
port = 12345
login = "username"
password = "password"
```

If the dealer has access to instant swaps API, set `api_key`:
```
api_key = "<YOUR_API_KEY>"
```
Without an API key, it has access only to public order books (https://sideswap.io/swap-market).
With an API key, it also has access to instant swaps (https://sideswap.io/instant).

Set the `interest_submit` value.
This determines how much profit the dealer will take on each swap.
The default value of `1.01` means that the dealer should take 1% on each swap.
For example, for 0.5% profit taking, set it to `1.005`.

5. Start the dealer:
```
cargo run -- config/dealer_example_config.toml
```
It may crash if some RPC or server request timeouts or fails.
The operating system should be configured to automatically restart the process.
