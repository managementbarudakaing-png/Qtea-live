
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/live_room_screen.dart';
import 'screens/withdraw_screen.dart';
import 'screens/agency_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(QTEALiveApp());
}

class QTEALiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QTEA LIVE V4.1 60/15/25',
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
