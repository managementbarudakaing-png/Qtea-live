
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/home_screen.dart';
import 'screens/live_room_screen.dart';
import 'screens/withdraw_screen.dart';
import 'screens/agency_screen.dart';
import 'ads/ad_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await QTEAAdManager().init(); // Load App Open + Rewarded (tanpa Interstitial)
  runApp(QTEALiveApp());
}

class QTEALiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QTEA LIVE V4.2 - Ads 60/15/25',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xFF2B9AF3), scaffoldBackgroundColor: Color(0xFF0A0A0A)),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/live': (context) => LiveRoomScreen(),
        '/withdraw': (context) => WithdrawScreen(),
        '/agency': (context) => AgencyScreen(),
      },
    );
  }
}

// Splash with App Open Ad
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      QTEAAdManager().showAppOpenAd(); // App Open Ad pas buka app - cuan
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, '/');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/logo/qtea_flat_blue_transparent.png', height: 120),
          SizedBox(height: 16),
          CircularProgressIndicator(color: Color(0xFF2B9AF3)),
        ]),
      ),
    );
  }
}
