#!/bin/bash
# Build Android APK (debug)
set -e
cd "$(dirname "$0")/.."
echo "📱 Building Sky Dash (Android Debug)..."
flutter build apk --debug
echo "✅ Build complete! APK at: build/app/outputs/flutter-apk/app-debug.apk"
