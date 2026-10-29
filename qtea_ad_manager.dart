
// QTEA LIVE V4.2 - AdMob System untuk penghasilan tambahan
// File: lib/ads/ad_manager.dart

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class QTEAAdManager {
  static final QTEAAdManager _instance = QTEAAdManager._internal();
  factory QTEAAdManager() => _instance;
  QTEAAdManager._internal();

  // GANTI DENGAN AD UNIT ID LU SETELAH DAFTAR ADMOB
  // Test IDs (pakai ini dulu biar gak kena banned)
  String get appOpenAdUnitId => Platform.isAndroid 
      ? 'ca-app-pub-3940256099942544/9257395921' // Test App Open
      : 'ca-app-pub-3940256099942544/5575463023';

  String get interstitialAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712' // Test Interstitial
      : 'ca-app-pub-3940256099942544/4411468910';

  String get rewardedAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917' // Test Rewarded - buat free beans
      : 'ca-app-pub-3940256099942544/1712485313';

  String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  AppOpenAd? _appOpenAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool isAppOpenAdLoaded = false;

  // 1. INIT ADMOB
  Future<void> init() async {
    await MobileAds.instance.initialize();
    loadAppOpenAd();
    loadInterstitialAd();
    loadRewardedAd();
  }

  // 2. APP OPEN AD - Muncul pas buka aplikasi (cuan paling gede)
  void loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          isAppOpenAdLoaded = true;
          print('QTEA: App Open Ad loaded - siap cuan');
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
      loadAppOpenAd(); // Load lagi buat next open
    }
  }

  // 3. INTERSTITIAL - Muncul pas keluar live room atau ganti tab
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {},
      ),
    );
  }

  void showInterstitialAd({VoidCallback? onAdDismissed}) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadInterstitialAd();
          if (onAdDismissed != null) onAdDismissed();
        },
      );
      _interstitialAd!.show();
    } else {
      if (onAdDismissed != null) onAdDismissed();
    }
  }

  // 4. REWARDED AD - Tonton iklan dapat 100 topup_beans gratis (TIDAK BISA WD tapi bisa buat gift)
  // Ini yang bikin user betah & lu tetap cuan
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
          // User dapat 100 topup_beans gratis (TIDAK BISA WD)
          // Tapi harus nonton iklan, lu dapat $0.02-$0.10 per view
          int freeBeans = 100;
          onRewarded(freeBeans);
          // Simpan ke database: topup_beans += 100
          print('QTEA: User dapat $freeBeans free beans dari iklan');
        },
      );
    }
  }

  // Banner ad widget
  Widget getBannerAd() {
    final BannerAd banner = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    )..load();

    return Container(
      alignment: Alignment.center,
      width: banner.size.width.toDouble(),
      height: banner.size.height.toDouble(),
      child: AdWidget(ad: banner),
    );
  }
}

// Cara pakai di main.dart:
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await QTEAAdManager().init();
//   runApp(QTEALiveApp());
// }
//
// Di SplashScreen:
// @override
// void initState() {
//   super.initState();
//   // Tampilkan App Open Ad pas buka app
//   Future.delayed(Duration(seconds: 1), () {
//     QTEAAdManager().showAppOpenAd();
//   });
// }
//
// Di HomeScreen - Tombol Free Beans:
// ElevatedButton(
//   onPressed: () {
//     QTEAAdManager().showRewardedAd(onRewarded: (beans) {
//       // Tambah topup_beans user 100
//       // Show snackbar: Dapat 100 beans gratis!
//     });
//   },
//   child: Text('Nonton Iklan Dapat 100 Beans Gratis')
// )
