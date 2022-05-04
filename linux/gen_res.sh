#!/bin/bash
set -o errexit -o pipefail -o noclobber -o nounset

cd "$(dirname "$0")"

glib-compile-resources --generate-source my_res.xml
