#!/bin/bash

set -o errexit -o pipefail -o noclobber -o nounset

cd "$(dirname "$0")/../rust/sideswap_client"

function build() {
    BASE_PATH=$(dirname "$0")
    WALLY_DIR="$BASE_PATH/../distr/libwally/$WALLI_ARCH_NAME/lib"
    export WALLY_DIR=$(realpath "$WALLY_DIR")
    echo "Using WALLY_DIR: $WALLY_DIR"
    cargo build --release --target=$ARCH
}

if [[ "$OSTYPE" == "linux-gnu"* ]]
then
	echo "ANDROID_NDK_ROOT: $ANDROID_NDK_ROOT"

	rustup target add armv7-linux-androideabi
	rustup target add aarch64-linux-android
	#rustup target add i686-linux-android
	rustup target add x86_64-linux-android

    export PATH="$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH"

	WALLI_ARCH_NAME=armv7a-linux-androideabi ARCH=armv7-linux-androideabi build
	WALLI_ARCH_NAME=aarch64-linux-android ARCH=aarch64-linux-android build
	#WALLI_ARCH_NAME=i686-linux-android ARCH=i686-linux-android build
	WALLI_ARCH_NAME=x86_64-linux-android ARCH=x86_64-linux-android build
fi

if [[ "$OSTYPE" == "darwin"* ]]
then
	rustup target add aarch64-apple-ios
	WALLI_ARCH_NAME=aarch64-apple-ios ARCH=aarch64-apple-ios build
fi
