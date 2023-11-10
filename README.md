# SideSwap client

SideSwap is released under the terms of the GNU General Public License. See [LICENSE](LICENSE) for more information.

SideSwap swap protocol: [doc/protocol.md](doc/protocol.md).

Client build instructions: [doc/build.md](doc/build.md).

Dealer example: [doc/dealer.md](doc/dealer.md).

API reference: [https://sideswap.io/docs/](https://sideswap.io/docs/).

SideSwap client uses [GDK library](https://github.com/Blockstream/gdk) from Blockstream.

# Android build instructions

Run app with gcm enabled:
flutter run -t .\lib\main.dart --flavor full
without:
flutter run -t .\lib\main_fdroid.dart --flavor fdroid

Build app with gcm:
flutter build apk --split-per-abi run -t .\lib\main.dart --flavor full
without:
flutter build apk --split-per-abi run -t .\lib\main_fdroid.dart --flavor fdroid

apk output directory
full: sideswap\build\app\outputs\apk\full\release
fdroid: sideswap\build\app\outputs\apk\fdroid\release

# Sideswap client and gdk library paths

Android:
sideswap/android/app/src/main/jniLibs

iOS/macos:
Open runner and add (if missing) lgreenaddress_full.a

Windows/linux
add dynamic library to executable folder
