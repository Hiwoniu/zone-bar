#!/usr/bin/env bash
# Build ZoneBar.app (universal, release) into ./build
set -euo pipefail
cd "$(dirname "$0")/.."

CONFIG="${CONFIG:-release}"
APP="build/ZoneBar.app"

swift build -c "$CONFIG" --arch arm64 --arch x86_64
BIN="$(swift build -c "$CONFIG" --arch arm64 --arch x86_64 --show-bin-path)/ZoneBar"

rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp "$BIN" "$APP/Contents/MacOS/ZoneBar"
cp Resources/Info.plist "$APP/Contents/Info.plist"
cp Resources/AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"

# Ad-hoc sign so SMAppService (开机自启动) accepts the bundle.
codesign --force --deep --sign - "$APP"

echo "Built $APP"
echo "Install:  cp -R $APP /Applications/   (开机自启动需要从 /Applications 运行)"
