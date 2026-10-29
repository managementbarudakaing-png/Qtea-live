
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class LiveRoomScreen extends StatefulWidget {
  @override
  _LiveRoomScreenState createState() => _LiveRoomScreenState();
}

class _LiveRoomScreenState extends State<LiveRoomScreen> {
  List gifts = [];
  bool showGiftPanel = false;

  @override
  void initState() {
    super.initState();
    loadGifts();
  }

  loadGifts() async {
    try {
      String data = await rootBundle.loadString('assets/qtea_gifts_92.json');
      setState(() { gifts = json.decode(data); });
    } catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Video Placeholder (ganti dengan ZegoUIKit)
          Container(
            color: Colors.black,
            child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.live_tv, size: 80, color: Color(0xFF2B9AF3)),
                SizedBox(height: 16),
                Text('LIVE ROOM - Host Bandung', style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(height: 8),
                Text('ZEGOCLOUD SDK disini\nBeauty Filter ON', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54)),
              ]),
            ),
          ),
          // Chat overlay
          Positioned(left: 12, bottom: 80, right: 100, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)), child: Text('User123: Halo kak! 🔥', style: TextStyle(color: Colors.white, fontSize: 12))),
            SizedBox(height: 4),
            Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Color(0xFF2B9AF3).withOpacity(0.8), borderRadius: BorderRadius.circular(12)), child: Text('🎉 USER 123 MENANG 50.000 KOIN DI NAGA DEWA!', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
          ])),
          // Top bar
          SafeArea(child: Padding(padding: EdgeInsets.all(12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              CircleAvatar(backgroundColor: Color(0xFF2B9AF3), child: Text('H')),
              SizedBox(width: 8),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Host Sunda', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)), Text('1.2k viewers', style: TextStyle(color: Colors.white70, fontSize: 10))]),
              SizedBox(width: 8),
              Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)), child: Text('+ Follow', style: TextStyle(color: Colors.white, fontSize: 10))),
            ]),
            Row(children: [
              Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)), child: Row(children: [Icon(Icons.monetization_on, color: Colors.yellow, size: 14), Text(' 9.000', style: TextStyle(color: Colors.white, fontSize: 12))])),
              SizedBox(width: 8),
              GestureDetector(onTap: ()=> Navigator.pop(context), child: Icon(Icons.close, color: Colors.white)),
            ]),
          ]))),
          // Bottom bar
          Positioned(bottom: 0, left: 0, right: 0, child: Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, Colors.black87], begin: Alignment.topCenter, end: Alignment.bottomCenter)), child: Row(children: [
            Expanded(child: Container(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)), child: Text('Ngobrol...', style: TextStyle(color: Colors.white70, fontSize: 12)))),
            SizedBox(width: 8),
            GestureDetector(onTap: ()=> setState(()=> showGiftPanel = !showGiftPanel), child: Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF2B9AF3), shape: BoxShape.circle), child: Icon(Icons.card_giftcard, color: Colors.white, size: 20))),
          ]))),
          // Gift Panel
          if(showGiftPanel) Positioned(bottom: 0, left: 0, right: 0, child: Container(height: 320, decoration: BoxDecoration(color: Color(0xFF1A1A1A), borderRadius: BorderRadius.vertical(top: Radius.circular(20))), child: Column(children: [
            Padding(padding: EdgeInsets.all(12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('92 Gifts - QTEA LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), GestureDetector(onTap: ()=> setState(()=> showGiftPanel=false), child: Icon(Icons.close, color: Colors.white))])),
            Expanded(child: gifts.isEmpty ? Center(child: Text('Loading gifts...', style: TextStyle(color: Colors.white54))) : GridView.builder(padding: EdgeInsets.all(8), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.8), itemCount: gifts.length, itemBuilder: (context, i){
              final g = gifts[i];
              return Container(margin: EdgeInsets.all(4), decoration: BoxDecoration(color: g['type']=='JP'? Color(0xFF2B9AF3).withOpacity(0.2): Colors.grey[900], borderRadius: BorderRadius.circular(8), border: Border.all(color: g['type']=='JP'? Color(0xFF2B9AF3): Colors.transparent)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(g['type']=='JP'? '🍀':'🎁', style: TextStyle(fontSize: 20)),
                SizedBox(height: 2),
                Text(g['name'], textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold), maxLines: 2),
                Text('${g['price']} coin', style: TextStyle(color: Colors.yellow, fontSize: 8)),
                if(g['type']=='JP') Text('WIN ${g['winrate']}%', style: TextStyle(color: Colors.greenAccent, fontSize: 6)),
              ]));
            })),
            Padding(padding: EdgeInsets.all(12), child: Row(children: [
              Expanded(child: Text('Host 60% - JP masuk Pool - Murni tidak masuk Pool', style: TextStyle(color: Colors.white54, fontSize: 9))),
              Container(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: Color(0xFF2B9AF3), borderRadius: BorderRadius.circular(20)), child: Text('Kirim', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            ])),
          ]))),
        ],
      ),
    );
  }
}
