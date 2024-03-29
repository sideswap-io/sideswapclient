SideSwap trader
===============

## Building from source:

- Install Rust compiler.
- Build GDK. Use branch `sswp5` from `https://github.com/sideswap-io/gdk`.
- Export `GDK_DIR` env variable with the directory path where `libgreenaddress_full.a` file is located.
- Build executable binary file as usual.

```
git clone https://github.com/sideswap-io/sideswapclient
cd sideswapclient/rust/sideswap_headless_trader
export GDK_DIR=/path/to/gdk/build-clang
cargo build --release
```

Or download the compiled binary for Linux from `https://sideswap.io/download/sideswap_headless_trader`.

## Running:

- Edit the `config/prod.toml` file as needed (enter your mnemonic and asset price).
- Start the trader.

```
/path/to/sideswap_headless_trader /path/to/prod.toml
```
