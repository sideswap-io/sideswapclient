SideSwap trader
===============

## Building:

- Install Rust compiler

- Build GDK version 0.0.51

- Export `GDK_DIR` env variable with the directory path where `libgreenaddress_full.a` file is located

- Build executable binary file as usual:

```
git clone https://github.com/sideswap-io/sideswapclient
cd sideswapclient/rust/sideswap_headless_trader
export GDK_DIR=/path/to/gdk/build-clang/src
cargo build --release
```

## Running:

- Edit `config/prod.toml` file as needed (enter your mnemonic and asset price).

- Start the trader:

```
/path/to/sideswap_headless_trader /path/to/prod.toml
```
