#!/bin/bash

set -o errexit -o pipefail -o noclobber -o nounset

cd "$(dirname "$0")"

rm -f ./assets.json
echo '{"id":1, "method": "assets", "params": null}' | websocat wss://api.sideswap.io/json-rpc-ws | jq .result.assets > ./assets.json
