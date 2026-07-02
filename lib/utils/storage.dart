import 'package:shared_preferences/shared_preferences.dart';

class GameStorage {
  static final GameStorage _instance = GameStorage._();
  factory GameStorage() => _instance;
  GameStorage._();

  SharedPreferences? _prefs;

  static const String _kHighScore = 'high_score';
  static const String _kGems = 'gems';
  static const String _kOwnedSkins = 'owned_skins';
  static const String _kActiveSkin = 'active_skin';
  static const String _kLastLoginDate = 'last_login_date';
  static const String _kRewardedAdsToday = 'rewarded_ads_today';
  static const String _kSoundEnabled = 'sound_enabled';
  static const String _kMusicEnabled = 'music_enabled';
  static const String _kTotalGamesPlayed = 'total_games_played';
  static const String _kTotalObstaclesPassed = 'total_obstacles_passed';
  static const String _kDailyLoginStreak = 'daily_login_streak';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int getHighScore() => _prefs?.getInt(_kHighScore) ?? 0;
  Future<bool> setHighScore(int score) => _prefs!.setInt(_kHighScore, score);
  int getGems() => _prefs?.getInt(_kGems) ?? 0;
  Future<bool> setGems(int gems) => _prefs!.setInt(_kGems, gems);
  Future<bool> addGems(int amount) => setGems(getGems() + amount);
  bool spendGems(int amount) {
    final current = getGems();
    if (current < amount) return false;
    setGems(current - amount);
    return true;
  }

  List<String> getOwnedSkins() {
    final raw = _prefs?.getStringList(_kOwnedSkins) ?? [];
    if (raw.isEmpty) raw.add('ninja_frog');
    return raw;
  }
  Future<bool> addSkin(String skinId) {
    final owned = getOwnedSkins();
    if (!owned.contains(skinId)) owned.add(skinId);
    return _prefs!.setStringList(_kOwnedSkins, owned);
  }
  String getActiveSkin() => _prefs?.getString(_kActiveSkin) ?? 'ninja_frog';
  Future<bool> setActiveSkin(String skinId) => _prefs!.setString(_kActiveSkin, skinId);
  String? getLastLoginDate() => _prefs?.getString(_kLastLoginDate);
  Future<void> setLastLoginDate(String date) => _prefs!.setString(_kLastLoginDate, date);
  int getDailyLoginStreak() => _prefs?.getInt(_kDailyLoginStreak) ?? 0;
  Future<void> setDailyLoginStreak(int streak) => _prefs!.setInt(_kDailyLoginStreak, streak);
  int getRewardedAdsToday() => _prefs?.getInt(_kRewardedAdsToday) ?? 0;
  Future<void> setRewardedAdsToday(int count) => _prefs!.setInt(_kRewardedAdsToday, count);
  bool isSoundEnabled() => _prefs?.getBool(_kSoundEnabled) ?? true;
  Future<bool> setSoundEnabled(bool enabled) => _prefs!.setBool(_kSoundEnabled, enabled);
  bool isMusicEnabled() => _prefs?.getBool(_kMusicEnabled) ?? true;
  Future<bool> setMusicEnabled(bool enabled) => _prefs!.setBool(_kMusicEnabled, enabled);
  int getTotalGamesPlayed() => _prefs?.getInt(_kTotalGamesPlayed) ?? 0;
  Future<void> incrementGamesPlayed() => _prefs!.setInt(_kTotalGamesPlayed, getTotalGamesPlayed() + 1);
  int getTotalObstaclesPassed() => _prefs?.getInt(_kTotalObstaclesPassed) ?? 0;
  Future<void> addObstaclesPassed(int count) => _prefs!.setInt(_kTotalObstaclesPassed, getTotalObstaclesPassed() + count);
}
