import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsManager {
  static final AdsManager _instance = AdsManager._();
  factory AdsManager() => _instance;
  AdsManager._();

  bool _initialized = false;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isLoading = false;

  static const String _testInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testRewardedId = 'ca-app-pub-3940256099942544/5224354917';

  Future<void> init() async {
    if (_initialized) return;
    try {
      await MobileAds.instance.initialize();
      _initialized = true;
    } catch (e) {
      debugPrint('AdsManager: Init failed: $e');
    }
  }

  void loadInterstitial() {
    if (!_initialized || _isLoading) return;
    _isLoading = true;
    InterstitialAd.load(
      adUnitId: _testInterstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoading = false;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitial();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              _isLoading = false;
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          debugPrint('AdsManager: Interstitial failed: $error');
        },
      ),
    );
  }

  bool showInterstitial() {
    if (_interstitialAd == null) { loadInterstitial(); return false; }
    _interstitialAd!.show();
    return true;
  }

  void loadRewarded() {
    if (!_initialized || _isLoading) return;
    _isLoading = true;
    RewardedAd.load(
      adUnitId: _testRewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoading = false;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              loadRewarded();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedAd = null;
              _isLoading = false;
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          debugPrint('AdsManager: Rewarded failed: $error');
        },
      ),
    );
  }

  bool showRewarded({required void Function(int rewardAmount) onReward}) {
    if (_rewardedAd == null) { loadRewarded(); return false; }
    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        onReward(reward.amount ?? 50);
      },
    );
    return true;
  }

  void preload() { loadInterstitial(); loadRewarded(); }
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _interstitialAd = null;
    _rewardedAd = null;
  }
}
