#!/bin/bash

set -o errexit -o pipefail -o noclobber -o nounset

PREFIX="$(dirname $0)/../distr/libwally"
BUILD_DIR="./build-libwally-tmp"

echo "install to $PREFIX"

function build_common() {
    rm -rf "$BUILD_DIR" && mkdir "$BUILD_DIR"
    pushd "$BUILD_DIR"
    ../configure --host="$HOST_NAME" --enable-elements --disable-shared --enable-static --prefix="$PREFIX/$INSTALL_NAME"
    make -j
    make install
    popd
}

function build_android() {
    export PATH="$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH"
    export CC="$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/bin/${ANDROID_ARCH}21-clang"
    export CFLAGS="-isystem $ANDROID_NDK_ROOT/sysroot/usr"
    build_common
}

function build_ios() {
    export BUILD_FLAGS="-arch arm64 -miphoneos-version-min=10.0 -isysroot $(xcrun --sdk iphoneos --show-sdk-path)"
    export MACOSX_DEPLOYMENT_TARGET="10.4"
    export CC=$(xcrun --find --sdk iphoneos clang)
    export CFLAGS="${BUILD_FLAGS}"
    export LDFLAGS="${BUILD_FLAGS}"
    HOST_NAME=arm-apple-darwin INSTALL_NAME=aarch64-apple-ios build_common
}

if [[ "$OSTYPE" == "linux-gnu"* ]]
then
    echo "ANDROID_NDK_ROOT: $ANDROID_NDK_ROOT"

    CFLAGS="-fPIC" HOST_NAME= INSTALL_NAME=x86_64-unknown-linux-gnu build_common

    HOST_NAME=armv7a-linux-androideabi  ANDROID_ARCH=armv7a-linux-androideabi   INSTALL_NAME=armv7a-linux-androideabi   build_android
    HOST_NAME=aarch64-linux-android     ANDROID_ARCH=aarch64-linux-android      INSTALL_NAME=aarch64-linux-android      build_android
    HOST_NAME=i686-linux-android        ANDROID_ARCH=i686-linux-android         INSTALL_NAME=i686-linux-android         build_android
    HOST_NAME=x86_64-linux-android      ANDROID_ARCH=x86_64-linux-android       INSTALL_NAME=x86_64-linux-android       build_android
fi

if [[ "$OSTYPE" == "darwin"* ]]
then
    #HOST_NAME= INSTALL_NAME=x86_64-apple-darwin build_common

    build_ios
fi
