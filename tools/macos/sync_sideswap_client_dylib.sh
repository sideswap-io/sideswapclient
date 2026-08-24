#!/usr/bin/env bash
# Builds sideswap_client for macOS with cargo.
#
# The copy into the .app bundle is done by the "Sideswap: copy sideswap_client
# dylib" Xcode build phase (macos/Runner.xcodeproj), so every macOS build --
# including a plain `flutter run -d macos` -- picks the library up. This script
# only produces it, and is used as the preLaunchTask of the
# "desktop (debug mode, build Rust dylib)" launch configuration.
#
# The rust checkout defaults to the ../sideswap_rust sibling of the flutter
# repo; override with SIDESWAP_RUST_DIR.
set -euo pipefail

workspace_root="$(cd "$(dirname "$0")/../.." && pwd)"
rust_root="${SIDESWAP_RUST_DIR:-$workspace_root/../sideswap_rust}"
profile="${1:-debug}"

if [ ! -d "$rust_root" ]; then
  echo "sideswap_rust checkout not found at $rust_root" >&2
  echo "Clone https://github.com/sideswap-io/sideswap_rust next to this repo, or set SIDESWAP_RUST_DIR." >&2
  exit 1
fi

cd "$rust_root"
case "$profile" in
  debug) cargo build -p sideswap_client ;;
  release) cargo build -p sideswap_client --release ;;
  *) echo "Unknown profile '$profile' (expected debug or release)" >&2; exit 1 ;;
esac

echo "Built $(cd "$rust_root" && pwd)/target/$profile/libsideswap_client.dylib"
