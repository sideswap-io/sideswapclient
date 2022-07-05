#! /usr/bin/env bash
set -e

apt update -qq
apt upgrade -yqq

apt install --no-install-recommends unzip autoconf automake autotools-dev pkg-config build-essential libtool python3{,-dev,-pip,-virtualenv} python{,-dev}-is-python3 ninja-build clang{,-format,-tidy} git swig openjdk-11-jdk curl libudev-dev lld -yqq
update-java-alternatives -s java-1.11.0-openjdk-amd64
pip3 install meson==0.58.0

curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain 1.60.0
source /root/.cargo/env

mkdir /build

cd /build
git clone https://github.com/blockstream/gdk
cd gdk
git checkout release_0.0.53
./tools/build.sh --clang

cd /build
git clone https://github.com/sideswap-io/sideswapclient

export GDK_DIR=/build/gdk/build-clang/src

pushd sideswapclient/rust/sideswap_headless_trader/
cargo build --release
popd

pushd sideswapclient/rust/sideswap_headless/
cargo build --release
popd
