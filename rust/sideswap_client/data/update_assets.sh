#!/bin/bash

set -o errexit -o pipefail -o noclobber -o nounset

cd "$(dirname "$0")"

rm -f ./assets.json
rm -f ./assets-testnet.json
echo '{"id":1, "method": "assets", "params": null}' | websocat --buffer-size 1048576 wss://api.sideswap.io/json-rpc-ws | jq .result.assets > ./assets.json
echo '{"id":1, "method": "assets", "params": null}' | websocat --buffer-size 1048576 wss://api-testnet.sideswap.io/json-rpc-ws | jq .result.assets > ./assets-testnet.json
