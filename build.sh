#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

APP="Cafeinate.app"
DMG="Cafeinate.dmg"
VERSION="${VERSION:-1.0}"

rm -rf "$DMG" build

xcodegen generate --quiet
xcodebuild \
    -project Cafeinate.xcodeproj \
    -scheme Cafeinate \
    -configuration Release \
    -destination "generic/platform=macOS" \
    -derivedDataPath build/dd \
    MARKETING_VERSION="$VERSION" \
    build | tail -1

mkdir -p build/dmg
cp -R "build/dd/Build/Products/Release/$APP" build/dmg/
ln -s /Applications build/dmg/Applications
hdiutil create -volname "Cafeinate" -srcfolder build/dmg -format UDZO -ov "$DMG" >/dev/null

rm -rf build
echo "Built $DMG"
