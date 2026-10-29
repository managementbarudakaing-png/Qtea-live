
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List gifts = [];
  
  @override
  void initState() {
    super.initState();
    loadGifts();
  }

  loadGifts() async {
    String data = await rootBundle.loadString('assets/qtea_gifts_92.json');
    setState(() {
      gifts = json.decode(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/logo/qtea_flat_blue_transparent.png', height: 32, errorBuilder: (_,__,___)=> Icon(Icons.live_tv, color: Color(0xFF2B9AF3))),
            SizedBox(width: 8),
            Text('QTEA LIVE', style: TextStyle(color: Color(0xFF2B9AF3), fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Color(0xFF2B9AF3), borderRadius: BorderRadius.circular(20)),
            child: Row(children: [Icon(Icons.monetization_on, size: 16), Text(' 9.000', style: TextStyle(fontWeight: FontWeight.bold))]),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          // Filter tags
          Container(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              children: ['HOT','PK','PARTY','NEW','HOKI 2','HOKI 50'].map((t) => Container(
                margin: EdgeInsets.only(right: 8),
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: t=='HOT'? Color(0xFF2B9AF3): Colors.grey[900], borderRadius: BorderRadius.circular(20)),
                child: Center(child: Text(t, style: TextStyle(color: Colors.white, fontSize: 12))),
              )).toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 8, mainAxisSpacing: 8),
              itemCount: 20,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/live'),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey[900]),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), gradient: LinearGradient(colors: [Colors.pink[200]!, Colors.blue[200]!], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                        ),
                        Positioned(top: 8, left: 8, child: Container(padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: i%3==0? Colors.red: Color(0xFF2B9AF3), borderRadius: BorderRadius.circular(4)), child: Text(i%3==0? 'PK':'HOT', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)))),
                        Positioned(top: 8, right: 8, child: Row(children: [Icon(Icons.visibility, size: 12, color: Colors.white), Text(' ${1200+i*123}', style: TextStyle(color: Colors.white, fontSize: 10))])),
                        Positioned(bottom: 0, left: 0, right: 0, child: Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)), gradient: LinearGradient(colors: [Colors.transparent, Colors.black87], begin: Alignment.topCenter, end: Alignment.bottomCenter)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Host ${i+1} • Bandung', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)), Text('Ngobrol santai', style: TextStyle(color: Colors.white70, fontSize: 10))]))),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Color(0xFF2B9AF3),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_kabaddi), label: 'PK'),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Party'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}
