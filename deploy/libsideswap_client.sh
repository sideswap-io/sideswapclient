#!/bin/bash
set -o errexit -o pipefail -o noclobber -o nounset

cd "$(dirname "$0")/../rust/sideswap_client"

function build() {
	BASE_PATH=$(dirname "$0")
	cargo build --release --target=$ARCH
}

echo "GDK_DIR: $GDK_DIR"

if [[ "$OSTYPE" == "linux-gnu"* ]]
then
	echo "ANDROID_NDK_ROOT: $ANDROID_NDK_ROOT"

	rustup target add armv7-linux-androideabi
	rustup target add aarch64-linux-android
	rustup target add i686-linux-android
	rustup target add x86_64-linux-android

	export PATH="$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH"

	ARCH=armv7-linux-androideabi build
	ARCH=aarch64-linux-android build
	ARCH=i686-linux-android build
	ARCH=x86_64-linux-android build
fi

if [[ "$OSTYPE" == "darwin"* ]]
then
	rustup target add aarch64-apple-ios
	ARCH=aarch64-apple-ios build
fi
