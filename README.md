# SideSwap client

SideSwap is released under the terms of the GNU General Public License. See [LICENSE](LICENSE) for more information.

SideSwap swap protocol: [rust/docs/protocol.md](rust/docs/protocol.md).

Dealer documentation: [rust/docs/dealer.md](rust/docs/dealer.md).

API reference: [https://sideswap.io/docs/](https://sideswap.io/docs/).

SideSwap client uses [GDK library](https://github.com/Blockstream/gdk) from Blockstream.

# Android build instructions

Run app with gcm enabled:
flutter run -t .\lib\main.dart --flavor full

Build app with gcm:
flutter build apk --split-per-abi run -t .\lib\main.dart --flavor full

apk output directory
full: sideswap\build\app\outputs\apk\full\release

# Android - fdroid version

Run once - add pubm to env path:
dart pub global activate pubm

Activate fdroid pubspec.yaml version:
pubm -f fdroid -v

then run:
flutter clean
flutter pub get
Now app is configured without firebase stuff

Run fdroid app:
flutter run -t .\lib\main_fdroid.dart --flavor fdroid

Build fdroid app:
flutter build apk --split-per-abi run -t .\lib\main_fdroid.dart --flavor fdroid

apk output directory
fdroid: sideswap\build\app\outputs\apk\fdroid\release

Back to main andoid version:
pubm -f main -v
flutter clean
flutter pub get

# Sideswap client and gdk library paths

Android:
sideswap/android/app/src/main/jniLibs

iOS/macos:
Open runner and add (if missing) lgreenaddress_full.a

Windows/linux
add dynamic library to executable folder
