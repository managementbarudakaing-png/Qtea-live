import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ads/ad_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const QteaLiveApp());
}

class QteaLiveApp extends StatelessWidget {
  const QteaLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QTEA LIVE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2B9AF3),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const QteaHome(),
    );
  }
}

class QteaHome extends StatefulWidget {
  const QteaHome({super.key});

  @override
  State<QteaHome> createState() => _QteaHomeState();
}

class _QteaHomeState extends State<QteaHome> {
  final QteaAdManager adManager = QteaAdManager();
  int beans = 0;

  @override
  void initState() {
    super.initState();
    adManager.loadAppOpenAd();
    adManager.loadRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2B9AF3), Colors.white],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF2B9AF3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text(
                  'Q',
                  style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'QTEA LIVE',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B9AF3),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'V4.2 FINAL 60/15/25',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 4),
            const Text(
              'Host 60% + Agency 15% + Platform 25%',
              style: TextStyle(fontSize: 11, color: Colors.black45),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Text(
                '$beans Beans',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B9AF3),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B9AF3),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                adManager.showRewardedAd(
                  onRewarded: (reward) {
                    setState(() {
                      beans += 100;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Dapat ${reward.amount} beans! Total: $beans'),
                        backgroundColor: const Color(0xFF2B9AF3),
                      ),
                    );
                  },
                );
              },
              child: const Text(
                'Nonton Iklan Dapat 100 Beans',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF2B9AF3)),
              ),
              onPressed: () {
                adManager.showAppOpenAdIfAvailable();
              },
              child: const Text(
                'Test App Open Ad (3 detik)',
                style: TextStyle(color: Color(0xFF2B9AF3)),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Build Berhasil! Siap Live Streaming',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'No Interstitial - Hanya App Open + Rewarded',
              style: TextStyle(fontSize: 11, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
