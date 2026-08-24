#!/usr/bin/env bash
# Xcode build-phase script: copies libsideswap_client.dylib into the app bundle.
#
# Runs for every macOS build (also plain `flutter run -d macos`), so the app has
# the rust library next to it without a manual copy. dlopen() of the bare leaf
# name resolves it through the target's @executable_path/../Frameworks rpath.
#
# The library is taken from the cargo target dir of the sideswap_rust checkout,
# or, for developers who do not build it themselves, from macos/Frameworks/
# (a manual drop location, gitignored - the Android jniLibs/ equivalent).
#
# A missing library is a warning, not an error: the app builds without it (it
# will fail to start), and builds that provide the dylib some other way (CI,
# deploy/) must keep working.
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
workspace_root="$(cd "$script_dir/../.." && pwd)"
rust_root="${SIDESWAP_RUST_DIR:-$workspace_root/../sideswap_rust}"

case "${CONFIGURATION:-Debug}" in
  Debug) cargo_profile=debug ;;
  *) cargo_profile=release ;;
esac

cargo_src="$rust_root/target/$cargo_profile/libsideswap_client.dylib"
manual_src="$workspace_root/macos/Frameworks/libsideswap_client.dylib"

if [ -f "$cargo_src" ]; then
  src="$cargo_src"
elif [ -f "$manual_src" ]; then
  src="$manual_src"
else
  echo "warning: libsideswap_client.dylib not found at $cargo_src nor at $manual_src - run the 'Sideswap: cargo sideswap_client (desktop)' task, or drop a prebuilt library into macos/Frameworks/, or the app will fail to start"
  exit 0
fi

dst_dir="$BUILT_PRODUCTS_DIR/$FULL_PRODUCT_NAME/Contents/Frameworks"
mkdir -p "$dst_dir"
cp -f "$src" "$dst_dir/libsideswap_client.dylib"

# On an incremental build the bundle is already signed and Xcode may skip the
# signing step afterwards, which would leave the seal stale ("nested code is
# modified or invalid") now that a file was added. Sign the library and re-seal
# the bundle here; on a full build Xcode signs again afterwards anyway.
sign() { codesign --force --timestamp=none --sign "${EXPANDED_CODE_SIGN_IDENTITY:--}" "$@"; }

app="$BUILT_PRODUCTS_DIR/$FULL_PRODUCT_NAME"
entitlements=""
if [ -n "${CODE_SIGN_ENTITLEMENTS:-}" ] && [ -f "$SRCROOT/$CODE_SIGN_ENTITLEMENTS" ]; then
  entitlements="$SRCROOT/$CODE_SIGN_ENTITLEMENTS"
fi

{
  sign "$dst_dir/libsideswap_client.dylib"
  if [ -n "$entitlements" ]; then
    sign --entitlements "$entitlements" "$app"
  else
    sign "$app"
  fi
} || echo "warning: failed to codesign after copying libsideswap_client.dylib"

echo "Copied $src -> $dst_dir"
