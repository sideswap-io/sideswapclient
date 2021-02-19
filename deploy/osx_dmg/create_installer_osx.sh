#!/bin/bash

set -o errexit -o pipefail -o noclobber -o nounset

rm -rf package
mkdir package

cp -r ../../build/SideSwap.app ./package/

macdeployqt ./package/SideSwap.app -qmldir=../../qml

rm -rf SideSwap_installer.dmg
create-dmg \
  --volname "SideSwap_installer" \
  --volicon "icon.icns" \
  --background "dmg_background.png"\
  --window-pos 200 190 \
  --window-size 650 450 \
  --icon-size 100 \
  --icon "SideSwap.app" 140 220 \
  --hide-extension "SideSwap.app" \
  --app-drop-link 500 220 \
  "SideSwap_installer.dmg" \
  "./package"
