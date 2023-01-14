#!/bin/bash
set -o errexit -o pipefail -o noclobber -o nounset

cd "$(dirname "$0")/../rust/sideswap_client"

function build() {
	BASE_PATH=$(dirname "$0")
	cargo build --release --target=$ARCH
}

echo "GDK_DIR: $GDK_DIR"

if [[ "$OSTYPE" == "darwin"* ]]
then
	if [ "$(uname -m)" = "arm64" ]; then
		rustup target add aarch64-apple-darwin
		ARCH=aarch64-apple-darwin build
	else
		rustup target add x86_64-apple-darwin
		ARCH=x86_64-apple-darwin build
	fi
fi
