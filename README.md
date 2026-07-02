# Sky Dash ☁️⚡

An addictive vertical dodger mobile game built with **Flutter** and **Flame Engine**.

**Tap to jump. Dodge obstacles. Collect gems. Unlock skins.**

## Quick Start (on your Mac)

```bash
brew install flutter
git clone https://github.com/fjarrod120-sketch/sky-dash.git
cd sky-dash
flutter pub get
flutter build apk --debug
```

## Game Features

- **Infinite gameplay** — procedural obstacles with increasing speed
- **9 unlockable character skins** — Ninja Frog (free) → Dark Matter (35K gems)
- **Gem economy** — earn by playing, daily bonuses, milestone rewards
- **AdMob integration** — rewarded ads for gem bonuses, interstitials between games
- **IAP coin packs** — $1.99 to $19.99 gem bundles (wrapper ready for store setup)

## Project Structure

```
lib/
├── game/          # Core loop: player, obstacles, particles, score, parallax bg
├── screens/       # Menu, Game, Game Over, Shop, Settings
├── economy/       # Currency, Ads, IAP, Shop data
├── skins/         # Skin manager + config (reskin hook)
├── audio/         # Sound manager (FlameAudio wrapper)
└── utils/         # Constants, SharedPreferences storage
```

## To build for release

1. Replace AdMob test IDs in `android/.../AndroidManifest.xml` and `lib/economy/ads_manager.dart`
2. Configure IAP product IDs in Google Play Console / App Store Connect
3. Set up signing keystore
4. Run `./build_scripts/build_android_release.sh`
