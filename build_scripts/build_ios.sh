#!/bin/bash
# Build iOS Release (requires macOS with Xcode)
set -e
cd "$(dirname "$0")/.."
echo "🍎 Building Sky Dash (iOS Release)..."
flutter build ios --release --no-codesign
echo "✅ Build complete!"
echo "   Archive via Xcode: open ios/Runner.xcworkspace"
echo "   Or generate IPA: flutter build ipa --release"
