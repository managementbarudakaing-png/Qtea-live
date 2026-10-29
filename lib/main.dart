import 'package:flutter/material.dart';

void main() {
  runApp(const QteaLiveApp());
}

class QteaLiveApp extends StatelessWidget {
  const QteaLiveApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QTEA LIVE',
      debugShowCheckedModeBanner: false,
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
  int beans = 9000;

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
              width: 120, height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF2B9AF3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text('Q', style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('QTEA LIVE', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2B9AF3))),
            const SizedBox(height: 8),
            const Text('V4.2 FINAL 60/15/25 NO ADS'),
            const SizedBox(height: 4),
            const Text('Host 60% + Agency 15% + Platform 25%', style: TextStyle(fontSize: 11, color: Colors.black45)),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Text('$beans Beans', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2B9AF3))),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2B9AF3), padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              onPressed: () {
                setState(() => beans += 100);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dapat 100 beans! Total: $beans'), backgroundColor: Color(0xFF2B9AF3)));
              },
              child: const Text('Test Tambah 100 Beans', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 30),
            const Text('✅ Build Tanpa Ads - Pasti Hijau!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const Text('Abis ini baru tambah Live + Gift 92', style: TextStyle(fontSize: 11, color: Colors.black45)),
          ],
        ),
      ),
    );
  }
}
