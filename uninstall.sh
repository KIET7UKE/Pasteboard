#!/bin/bash

# Configuration
APP_NAME="Pasteboard"
INSTALL_PATH="/Applications/$APP_NAME.app"

echo "🧹 Uninstalling $APP_NAME..."

# Quit the app if running
# We use AppleScript to ask it to quit nicely or pkill for more directness
pkill "$APP_NAME" 2>/dev/null

if [ -d "$INSTALL_PATH" ]; then
    echo "📦 Removing $APP_NAME from /Applications..."
    sudo rm -rf "$INSTALL_PATH"
else
    echo "⚠️ $APP_NAME was not found in /Applications."
fi

echo "✅ Uninstallation complete."
