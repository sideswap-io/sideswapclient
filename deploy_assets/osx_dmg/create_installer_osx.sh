#!/bin/sh
if ! brew ls --versions create-dmg > /dev/null; then
  brew install create-dmg
fi

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
