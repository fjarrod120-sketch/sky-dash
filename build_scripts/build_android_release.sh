#!/bin/bash
# Build Android Release APK
set -e
cd "$(dirname "$0")/.."
echo "📱 Building Sky Dash (Android Release)..."
flutter build apk --release
echo "✅ Build complete! APK at: build/app/outputs/flutter-apk/app-release.apk"
