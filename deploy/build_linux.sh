#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y --no-install-recommends \
  autoconf automake autotools-dev pkg-config build-essential libtool \
  clang git curl cmake ca-certificates \
  libssl-dev libtool-bin  lld libudev-dev protobuf-compiler \
  ninja-build libgtk-3-dev liblzma-dev

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
 | sh -s -- --default-toolchain 1.86.0 -y
. "$HOME/.cargo/env"

cd "$(dirname "$0")/.."

rm -rf deps
mkdir deps

pushd deps

echo "Downloading Flutter. This may take some time..."
curl -s https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.32.1-stable.tar.xz \
 | tar -xJ -C ./
chown -R "$(whoami)" ./flutter

echo "Building sideswap rust library..."
git clone https://github.com/sideswap-io/sideswap_rust
pushd sideswap_rust
git checkout 91791efbceb3fac4774d1e42a519e70b14b876cf
cargo build --release --package sideswap_client
popd

popd

echo "Building sideswap flutter app..."
./deps/flutter/bin/flutter clean
./deps/flutter/bin/flutter build linux --release

echo "Copying the binary to the output directory..."
mkdir -p ./output
rm -rf ./output/sideswap_linux
cp -r ./build/linux/x64/release/bundle ./output/sideswap_linux
cp ./deps/sideswap_rust/target/release/libsideswap_client.so ./output/sideswap_linux/lib
