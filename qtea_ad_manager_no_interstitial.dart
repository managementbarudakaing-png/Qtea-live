
// QTEA LIVE V4.2 - AdMob System TANPA Interstitial (Sesuai Request)
// Hanya 2 iklan: App Open + Rewarded

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class QTEAAdManager {
  static final QTEAAdManager _instance = QTEAAdManager._internal();
  factory QTEAAdManager() => _instance;
  QTEAAdManager._internal();

  // Test IDs - Ganti dengan Ad Unit ID asli setelah daftar AdMob
  String get appOpenAdUnitId => Platform.isAndroid 
      ? 'ca-app-pub-3940256099942544/9257395921' // Test App Open
      : 'ca-app-pub-3940256099942544/5575463023';

  String get rewardedAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917' // Test Rewarded
      : 'ca-app-pub-3940256099942544/1712485313';

  String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  AppOpenAd? _appOpenAd;
  RewardedAd? _rewardedAd;
  bool isAppOpenAdLoaded = false;

  Future<void> init() async {
    await MobileAds.instance.initialize();
    loadAppOpenAd();
    loadRewardedAd();
  }

  // 1. APP OPEN AD - Pas buka aplikasi (cuan gede, tidak ganggu)
  void loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          isAppOpenAdLoaded = true;
          print('QTEA: App Open Ad loaded');
        },
        onAdFailedToLoad: (error) {
          print('QTEA: App Open Ad failed: $error');
        },
      ),
    );
  }

  void showAppOpenAd() {
    if (_appOpenAd != null) {
      _appOpenAd!.show();
      _appOpenAd = null;
      isAppOpenAdLoaded = false;
      loadAppOpenAd();
    }
  }

  // 2. REWARDED AD - Nonton iklan dapat 100 topup_beans gratis (TIDAK BISA WD)
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {},
      ),
    );
  }

  void showRewardedAd({required Function(int rewardBeans) onRewarded}) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadRewardedAd();
        },
      );
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          int freeBeans = 100;
          onRewarded(freeBeans);
        },
      );
    }
  }
}
