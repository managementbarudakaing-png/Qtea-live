
import 'package:flutter/material.dart';

class AgencyScreen extends StatefulWidget {
  @override
  _AgencyScreenState createState() => _AgencyScreenState();
}

class _AgencyScreenState extends State<AgencyScreen> {
  bool isAgencyOwner = true;
  String agencyCode = 'QTEABDG01';
  String agencyName = 'Barudak Aing Agency';
  String level = 'GOLD';
  int commissionRate = 15;
  int activeHosts = 12;
  int totalHosts = 18;
  int balanceCoins = 45600;
  int totalEarnings = 234000;

  @override
  Widget build(BuildContext context) {
    int rp = (balanceCoins * 1.111).floor();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Agency 60/15/25 - QTEA LIVE'), backgroundColor: Colors.black, foregroundColor: Color(0xFF2B9AF3)),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2B9AF3), Colors.purple]), borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Split Final: Host 60% + Agency 15% + Platform 25%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            SizedBox(height: 8),
            Text('Host tetap dapat 60% FULL meski punya agency! Agency dapat bonus 15% dari platform (bukan potong host).', style: TextStyle(color: Colors.white70, fontSize: 11)),
            SizedBox(height: 8),
            Row(children: [
              _chip('Host 60%', Color(0xFF2B9AF3)),
              SizedBox(width: 6),
              _chip('Agency 15%', Colors.yellow),
              SizedBox(width: 6),
              _chip('Platform 25%', Colors.grey),
            ]),
          ])),
          SizedBox(height: 16),
          Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFF2B9AF3), width: 2)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(agencyName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(12)), child: Text(level, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10))),
            ]),
            SizedBox(height: 4),
            Text('Kode: $agencyCode | Komisi: $commissionRate% | ${activeHosts} host aktif | Host tetap 60%', style: TextStyle(color: Colors.white70, fontSize: 11)),
            SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Saldo Komisi Bisa WD', style: TextStyle(color: Colors.white54, fontSize: 11)), Text('${balanceCoins} coins', style: TextStyle(color: Color(0xFF2B9AF3), fontSize: 20, fontWeight: FontWeight.bold)), Text('≈ Rp $rp', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold))]),
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2B9AF3)), onPressed: (){}, child: Text('WD Agency 15%')),
            ]),
          ])),
          SizedBox(height: 16),
          Text('Contoh Gift 5.000 beans:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(8)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(children: [Text('Host', style: TextStyle(color: Colors.white54, fontSize: 10)), Text('3.000', style: TextStyle(color: Color(0xFF2B9AF3), fontWeight: FontWeight.bold)), Text('60%', style: TextStyle(color: Colors.white, fontSize: 10))]),
            Column(children: [Text('Agency', style: TextStyle(color: Colors.white54, fontSize: 10)), Text('750', style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)), Text('15%', style: TextStyle(color: Colors.white, fontSize: 10))]),
            Column(children: [Text('Platform', style: TextStyle(color: Colors.white54, fontSize: 10)), Text('1.250', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)), Text('25%', style: TextStyle(color: Colors.white, fontSize: 10))]),
          ])),
          SizedBox(height: 16),
          Text('Link Referral Agency', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white24)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text('https://qtea.live/join?agency=$agencyCode', style: TextStyle(color: Color(0xFF2B9AF3), fontSize: 12))), Icon(Icons.copy, color: Colors.white54, size: 16)])),
          SizedBox(height: 16),
          Text('Host di Agency Lu (12) - Mereka tetap dapat 60%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          ...List.generate(5, (i) => Container(margin: EdgeInsets.only(bottom: 8), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(8)), child: Row(children: [
            CircleAvatar(backgroundColor: Color(0xFF2B9AF3), radius: 18, child: Text('H${i+1}')),
            SizedBox(width: 8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Host Bandung ${i+1}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)), Text('Host: ${3000+i*500} (60%) | Komisi lu: ${750+i*100} (15%)', style: TextStyle(color: Colors.white54, fontSize: 10))])),
            Container(padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)), child: Text('ACTIVE', style: TextStyle(color: Colors.white, fontSize: 8))),
          ]))),
        ],
      ),
    );
  }

  Widget _chip(String t, Color c) => Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(12)), child: Text(t, style: TextStyle(color: t.contains('Agency')? Colors.black: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)));
}
