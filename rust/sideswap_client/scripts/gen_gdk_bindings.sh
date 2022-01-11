#!/bin/bash

set -o errexit -o pipefail -o noclobber -o nounset

BASE_DIR="$(dirname "$0")"

# GA_get_wallet_identifier is lost for some reasons

bindgen include/gdk.h -o "$BASE_DIR/../src/gdk.rs" --allowlist-type "GA_.*" --allowlist-function "GA_.*"
