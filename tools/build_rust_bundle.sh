#!/usr/bin/env bash
# Build the rust libs bundle from one pinned sideswap_rust commit, in WSL.
#
# It mirrors the `rust-libs` job of `.github/workflows/build.yml`. It is the
# unreproducible route: the `protoc` and the MinGW toolchain of this machine
# are not the ones of the runner. See `docs/adr/0015-github-actions-builds.md`
# decision 12.
#
#   bash build_rust_bundle.sh <sha> <ndk_home> <out_dir>
#
# <out_dir> receives `rust-libs.tar.gz`. `tools/build_local_release.py` calls
# this script; do not run it by hand.

set -euo pipefail

if [ $# -ne 3 ]; then
  echo "usage: build_rust_bundle.sh <sha> <ndk_home> <out_dir>" >&2
  exit 2
fi

sha="$1"
ndk="$2"
out="$3"

# The runner links the DLL with the posix threading variant, because that is
# the Ubuntu default there. Here the default is the win32 variant, so the
# variant is named. The runtime libraries below come from this same compiler,
# and a bundle whose runtime is not the one that linked the DLL fails to load.
mingw_cc=x86_64-w64-mingw32-gcc-posix
if ! command -v "$mingw_cc" >/dev/null 2>&1; then
  echo "$mingw_cc is not installed. Install gcc-mingw-w64-x86-64 and g++-mingw-w64-x86-64." >&2
  exit 1
fi

if [ ! -x "$ndk/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android21-clang" ]; then
  echo "WSL_NDK_HOME does not hold an NDK: $ndk" >&2
  exit 1
fi

# `wsl bash -c` is not a login shell, so cargo is not on PATH. `-l` would put
# it there, and print the profile banner to stdout with it.
source "$HOME/.cargo/env"

root="$HOME/.cache/sideswap-rust-bundle"
src="$root/$sha"
# One target directory for every pin. The next pin then reuses the compiled
# dependencies instead of compiling them again.
export CARGO_TARGET_DIR="$root/target"

# A scratch checkout of its own, inside the WSL file system. The developer
# checkout `../sideswap_rust` is never read and never written. A checkout on a
# `/mnt` mount is too slow for a target directory of several gigabytes.
mkdir -p "$src"
cd "$src"
git init -q .
git remote get-url origin >/dev/null 2>&1 ||
  git remote add origin https://github.com/sideswap-io/sideswap_rust.git
git fetch -q --depth 1 origin "$sha"
git checkout -q --detach FETCH_HEAD

# After the checkout, so `rust-toolchain.toml` decides which toolchain gets the
# targets. A moved pin may move the channel, and a target is installed per
# toolchain, so a fresh channel starts with neither of these two.
rustup target add aarch64-linux-android x86_64-pc-windows-gnu

export CARGO_TARGET_X86_64_PC_WINDOWS_GNU_LINKER="$mingw_cc"
export CC_x86_64_pc_windows_gnu="$mingw_cc"
cargo build --release --target x86_64-pc-windows-gnu -p sideswap_client

bin="$ndk/toolchains/llvm/prebuilt/linux-x86_64/bin"
export ANDROID_NDK_HOME="$ndk"
export CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER="$bin/aarch64-linux-android21-clang"
export CC_aarch64_linux_android="$bin/aarch64-linux-android21-clang"
export AR_aarch64_linux_android="$bin/llvm-ar"
cargo build --release --target aarch64-linux-android -p sideswap_client

# A fresh bundle directory, so a second run of the same pin never carries a
# stale file into the archive.
rm -rf bundle
mkdir -p bundle/android/arm64-v8a bundle/windows
cp "$CARGO_TARGET_DIR/aarch64-linux-android/release/libsideswap_client.so" bundle/android/arm64-v8a/
cp "$CARGO_TARGET_DIR/x86_64-pc-windows-gnu/release/sideswap_client.dll" bundle/windows/
# The DLL is a MinGW build, so its four runtime libraries ship beside it. Ask
# the compiler that linked the DLL where its own runtime is. A search of
# `/usr/lib/gcc` cannot do that: several gcc versions and both threading
# variants can be installed side by side.
for lib in libgcc_s_seh-1.dll libssp-0.dll libstdc++-6.dll; do
  found="$("$mingw_cc" -print-file-name="$lib")"
  if [ "$found" = "$lib" ]; then
    echo "missing $lib. Install gcc-mingw-w64-x86-64 and g++-mingw-w64-x86-64." >&2
    exit 1
  fi
  cp "$found" bundle/windows/
done
cp /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll bundle/windows/

mkdir -p "$out"
tar -czf "$out/rust-libs.tar.gz" -C bundle .
ls -la bundle/android/arm64-v8a bundle/windows "$out/rust-libs.tar.gz"
