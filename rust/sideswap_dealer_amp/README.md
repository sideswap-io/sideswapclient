SideSwap AMP dealer
===============

## Building from source:

- Install Rust compiler.
- Build executable binary file.

```
git clone https://github.com/sideswap-io/sideswapclient
cd sideswapclient/rust/sideswap_dealer_amp
cargo build --release
```

Or download the compiled binary for Linux from `https://sideswap.io/download/sideswap_dealer_amp`.

## Running:

- Edit the `config/example.toml` file as needed (enter your mnemonic and asset price).
- Start the dealer.

```
/path/to/sideswap_dealer_amp /path/to/example.toml
```
