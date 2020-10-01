## Build instuctions

### Ubuntu/Debian

#### Install build dependencies

```bash
sudo apt-get install build-essential cmake mesa-common-dev git
```

#### Download and install Qt

Qt 5.14 or newer required - http://download.qt.io/official_releases/qt/5.14/

Make sure `qmake` is available in PATH

```bash
qmake --version
```

#### Install Rust

Please see install instructions at https://rustup.rs/

Make sure `cargo` is available in PATH

```bash
cargo --version
```

#### Install cxxbridge CLI

```bash
cargo install cxxbridge-cmd
```

Make sure `cxxbridge` is available in PATH

```bash
cxxbridge --version
```

`cxxbridge` CLI version must be `0.4.7` (other versions might result in build errors).

#### Clone repository

```bash
git clone https://github.com/sideswap-io/sideswapclient
cd sideswapclient
```

#### Check building Rust

```bash
cd rust
cargo build
```

#### Build

```bash
cd ..
mkdir build
cd build
cmake ..
make -j
```
