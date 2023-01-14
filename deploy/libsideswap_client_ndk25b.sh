#!/bin/bash
set -o errexit -o pipefail -o noclobber -o nounset

cd "$(dirname "$0")/../rust/sideswap_client"

function print_linux_target() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]
    then
        echo "TARGET=$TARGET"
        echo "TOOLCHAIN=$TOOLCHAIN" 
        echo "API=$API"
        echo "CC=$CC"
        echo "AS=$AS"
        echo "CXX=$CXX"
        echo "GDK_DIR=$GDK_DIR"
        echo "LD=$LD"
        echo "RANLIB=$RANLIB"
        echo "STRIP=$STRIP"
        echo "AR=$AR"
        echo "ARCH=$ARCH"
    fi
}

function build() { 
    print_linux_target
	BASE_PATH=$(dirname "$0")
	cargo build --release --target=$ARCH
}

function linux_target() {
    export CC=$TOOLCHAIN/bin/$TARGET$API-clang
    export AS=$CC
    export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
}

echo "GDKDIR: $GDKDIR"

if [[ "$OSTYPE" == "linux-gnu"* ]]
then
    echo "If failed try to use rust toolchain beta or nightly"
	echo "ANDROID_NDK_ROOT: $ANDROID_NDK_ROOT"
    
    export TOOLCHAIN=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64
	export PATH="$TOOLCHAIN/bin:$PATH"
    export API=32
    export LD=$TOOLCHAIN/bin/ld
    export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
    export STRIP=$TOOLCHAIN/bin/llvm-strip
    export AR=$TOOLCHAIN/bin/llvm-ar

	rustup target add armv7-linux-androideabi
	rustup target add aarch64-linux-android
	rustup target add i686-linux-android
	rustup target add x86_64-linux-android

	export TARGET=armv7a-linux-androideabi 
    linux_target
    GDK_DIR=$GDKDIR/build-clang-android-armeabi-v7a/src ARCH=armv7-linux-androideabi build
	
    export TARGET=aarch64-linux-android
    linux_target
    GDK_DIR=$GDKDIR/build-clang-android-arm64-v8a/src ARCH=$TARGET build

    export TARGET=i686-linux-android 
    linux_target 
    GDK_DIR=$GDKDIR/build-clang-android-x86/src ARCH=$TARGET build

    export TARGET=x86_64-linux-android 
    linux_target 
    GDK_DIR=$GDKDIR/build-clang-android-x86_64/src	ARCH=$TARGET build
fi

if [[ "$OSTYPE" == "darwin"* ]]
then
	rustup target add aarch64-apple-ios
	ARCH=aarch64-apple-ios build
fi
