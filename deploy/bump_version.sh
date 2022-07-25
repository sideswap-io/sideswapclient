#!/bin/bash
set -o errexit -o pipefail -o noclobber -o nounset

cd "$(dirname "$0")/../flutter"

VERSION="$1"

VERSION_SHORT=$(echo "$VERSION" | cut -d'+' -f1)
BUILD_NUMBER=$(echo "$VERSION" | cut -d'+' -f2)
VERSION_SHORT_COMMAS=$(echo "$VERSION_SHORT" | sed -e 's/\./,/g')

echo "Version: $VERSION_SHORT"
echo "Build number: $BUILD_NUMBER"

# could be replaced when https://github.com/flutter/flutter/pull/106145 (when it lands in stable flutter)
sed -i "66 c #define VERSION_AS_NUMBER $VERSION_SHORT_COMMAS" desktop/windows/runner/Runner.rc
sed -i "72 c #define VERSION_AS_STRING \"$VERSION_SHORT\"" desktop/windows/runner/Runner.rc

sed -i "6 c version: $VERSION" desktop/pubspec.yaml
sed -i "6 c version: $VERSION" mobile/pubspec.yaml
sed -i "6 c version: $VERSION" fdroid/pubspec.yaml

sed -i "1 c const appVersion = '$VERSION_SHORT';" lib/app_version.dart
sed -i "2 c const appBuildNumber = $BUILD_NUMBER;" lib/app_version.dart
