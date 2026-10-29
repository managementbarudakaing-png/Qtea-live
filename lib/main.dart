import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class QteaAdManager {
  static const String appOpenAdUnitId = 'ca-app-pub-3940256099942544/9257395921';
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

  AppOpenAd? _appOpenAd;
  RewardedAd? _rewardedAd;
  bool _isShowingAppOpenAd = false;

  void loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenAd!.show();
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed: $error');
        },
      ),
      orientation: AppOpenAd.orientation.portrait,
    );
  }

  void showAppOpenAdIfAvailable() {
    if (_appOpenAd == null) {
      loadAppOpenAd();
      return;
    }
    if (_isShowingAppOpenAd) return;
    
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAppOpenAd = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAppOpenAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAppOpenAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
    );
    _appOpenAd!.show();
  }

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('RewardedAd failed: $error');
        },
      ),
    );
  }

  void showRewardedAd({required Function(RewardItem) onRewarded}) {
    if (_rewardedAd == null) {
      loadRewardedAd();
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
      },
    );
    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        onRewarded(reward);
      },
    );
  }
}
