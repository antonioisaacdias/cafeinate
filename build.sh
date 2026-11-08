#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

APP="Cafeinate.app"
DMG="Cafeinate.dmg"
MIN_OS="13.0"

rm -rf "$APP" "$DMG" build
mkdir -p "$APP/Contents/MacOS" build

swiftc -O main.swift -target "arm64-apple-macos$MIN_OS" -o build/Cafeinate-arm64
swiftc -O main.swift -target "x86_64-apple-macos$MIN_OS" -o build/Cafeinate-x86_64
lipo -create build/Cafeinate-arm64 build/Cafeinate-x86_64 -output "$APP/Contents/MacOS/Cafeinate"

cat > "$APP/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key><string>Cafeinate</string>
    <key>CFBundleIdentifier</key><string>local.widget-cafeinate</string>
    <key>CFBundleName</key><string>Cafeinate</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>CFBundleShortVersionString</key><string>1.0</string>
    <key>LSMinimumSystemVersion</key><string>$MIN_OS</string>
    <key>LSUIElement</key><true/>
</dict>
</plist>
EOF

codesign --force --sign - "$APP"

mkdir -p build/dmg
cp -R "$APP" build/dmg/
ln -s /Applications build/dmg/Applications
hdiutil create -volname "Cafeinate" -srcfolder build/dmg -format UDZO -ov "$DMG" >/dev/null

rm -rf build
echo "Built $APP and $DMG"
