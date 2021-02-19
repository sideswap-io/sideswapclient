## Client build instuctions

For dealer example build instructions see [dealer.md](dealer.md)

### Ubuntu/Debian

#### Install build dependencies

```bash
sudo apt-get install build-essential cmake git
```

#### Install Flutter

#### Install Rust

Please see install instructions at https://rustup.rs/

Make sure `cargo` is available in PATH

```bash
cargo --version
```

#### Build libwally-core

Checkout libwally-core from https://github.com/sideswap-io/libwally-core (fix_pset_load branch)

make sure that this installed:

```
sudo apt-get install build-essential autoconf automake libtool
```

```bash
git clone https://github.com/sideswap-io/libwally-core
cd libwally-core
git checkout fix_pset_load
./tools/autogen.sh
export ANDROID_NDK_ROOT=$HOME/android-sdk/ndk-bundle
/path/to/sideswapclient/deploy/libwally.sh
```

#### Clone repository

```bash
git clone https://github.com/sideswap-io/sideswapclient
cd sideswapclient
```

#### Build rust libs

```bash
/path/to/sideswapclient/deploy/libsideswap_client.sh
```

#### Build app

```bash
flutter build apk --target-platform android-arm64 --split-per-abi
```
