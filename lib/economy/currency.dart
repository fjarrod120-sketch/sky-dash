import '../utils/storage.dart';

class PlayerEconomy {
  static final PlayerEconomy _instance = PlayerEconomy._();
  factory PlayerEconomy() => _instance;
  PlayerEconomy._();
  final _storage = GameStorage();
  int get gems => _storage.getGems();
  void addGems(int amount) => _storage.addGems(amount);
  bool spendGems(int amount) => _storage.spendGems(amount);

  DailyLoginResult checkDailyLogin() {
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';
    final lastLogin = _storage.getLastLoginDate();
    final streak = _storage.getDailyLoginStreak();
    if (lastLogin == todayStr) {
      return DailyLoginResult(alreadyClaimed: true, streak: streak, bonus: 0);
    }
    int newStreak;
    if (lastLogin == null) {
      newStreak = 1;
    } else {
      final last = DateTime.tryParse(lastLogin);
      if (last != null) {
        newStreak = now.difference(last).inDays == 1 ? streak + 1 : 1;
      } else {
        newStreak = 1;
      }
    }
    const dailyBonuses = [25, 50, 100, 150, 200, 250, 500];
    final bonusIndex = (newStreak - 1).clamp(0, dailyBonuses.length - 1);
    final bonus = dailyBonuses[bonusIndex];
    _storage.setLastLoginDate(todayStr);
    _storage.setDailyLoginStreak(newStreak);
    _storage.addGems(bonus);
    return DailyLoginResult(alreadyClaimed: false, streak: newStreak, bonus: bonus);
  }

  int get remainingRewardedAds {
    final count = _storage.getRewardedAdsToday();
    return (5 - count).clamp(0, 5);
  }
  void consumeRewardedAd() => _storage.setRewardedAdsToday(_storage.getRewardedAdsToday() + 1);
}

class DailyLoginResult {
  final bool alreadyClaimed;
  final int streak;
  final int bonus;
  DailyLoginResult({required this.alreadyClaimed, required this.streak, required this.bonus});
}
