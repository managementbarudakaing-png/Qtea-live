
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/live_room_screen.dart';
import 'screens/withdraw_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(QTEALiveApp());
}

class QTEALiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QTEA LIVE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF2B9AF3),
        scaffoldBackgroundColor: Color(0xFF0A0A0A),
        fontFamily: 'Poppins',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/live': (context) => LiveRoomScreen(),
        '/withdraw': (context) => WithdrawScreen(),
      },
    );
  }
}
