#!/bin/bash

# Configuration
APP_NAME="Pasteboard"
BUILD_DIR="./build"
INSTALL_PATH="/Applications/$APP_NAME.app"

echo "🚀 Building $APP_NAME for Release..."

# Ensure we are in the project root
if [ ! -d "$APP_NAME.xcodeproj" ]; then
    echo "❌ Error: $APP_NAME.xcodeproj not found in current directory."
    exit 1
fi

# Clean up previous builds
rm -rf "$BUILD_DIR"

# Build the project
# Note: We build the target directly to avoid scheme dependency issues if xcodebuild can't find a shared scheme
xcodebuild -project "$APP_NAME.xcodeproj" \
           -target "$APP_NAME" \
           -configuration Release \
           -derivedDataPath "$BUILD_DIR" \
           build || { echo "❌ Build failed."; exit 1; }

# Locate the built .app
BUILT_APP=$(find "$BUILD_DIR" -name "$APP_NAME.app" -type d | head -n 1)

if [ -z "$BUILT_APP" ]; then
    echo "❌ Error: Could not find the built .app file."
    exit 1
fi

echo "📦 Installing $APP_NAME to /Applications..."

# Remove old version if it exists
if [ -d "$INSTALL_PATH" ]; then
    sudo rm -rf "$INSTALL_PATH"
fi

# Copy built app to /Applications
sudo cp -R "$BUILT_APP" "/Applications/"

echo "✅ Installation complete! You can find $APP_NAME in your /Applications folder."
echo "⚠️  Note: You may need to grant Accessibility permissions to $APP_NAME system-wide for the hotkey and auto-paste to work."
