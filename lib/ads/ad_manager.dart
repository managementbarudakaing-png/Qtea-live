import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class QteaAdManager {
  static final QteaAdManager _instance = QteaAdManager._internal();
  factory QteaAdManager() => _instance;
  QteaAdManager._internal();

  AppOpenAd? _appOpenAd;
  RewardedAd? _rewardedAd;
  bool _isShowingAppOpen = false;

  // TEST AD UNITS - Ganti dengan ID asli nanti
  static String get appOpenAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/9257395921'; // Test App Open
    }
    return 'ca-app-pub-3940256099942544/5575463023';
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917'; // Test Rewarded
    }
    return 'ca-app-pub-3940256099942544/1712485313';
  }

  void initialize() {
    MobileAds.instance.initialize();
    loadAppOpenAd();
    loadRewardedAd();
  }

  // APP OPEN AD - 3 sec on app open - QTEA LIVE V4.2
  void loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      orientation: AppOpenAd.orientation.portrait,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _appOpenAd = null;
              loadAppOpenAd();
              _isShowingAppOpen = false;
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _appOpenAd = null;
              _isShowingAppOpen = false;
              loadAppOpenAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed: $error');
          _appOpenAd = null;
        },
      ),
    );
  }

  void showAppOpenAdIfAvailable() {
    if (_appOpenAd == null) {
      loadAppOpenAd();
      return;
    }
    if (_isShowingAppOpen) return;
    _isShowingAppOpen = true;
    _appOpenAd!.show();
  }

  // REWARDED AD - Watch ad get 100 free beans, max 10x/day
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedAd = null;
              loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('RewardedAd failed: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  void showRewardedAd({required Function(RewardItem) onRewarded}) {
    if (_rewardedAd == null) {
      loadRewardedAd();
      return;
    }
    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        onRewarded(reward);
      },
    );
  }

  void dispose() {
    _appOpenAd?.dispose();
    _rewardedAd?.dispose();
  }
}
