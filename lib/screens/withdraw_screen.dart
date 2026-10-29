
import 'package:flutter/material.dart';

class WithdrawScreen extends StatefulWidget {
  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  int beans = 15400; // contoh dari API
  double rate = 1.111;
  TextEditingController ewalletCtrl = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    int rp = (beans * rate).floor();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Withdraw - QTEA LIVE'), backgroundColor: Colors.black, foregroundColor: Color(0xFF2B9AF3)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFF2B9AF3))), child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Saldo Beans', style: TextStyle(color: Colors.white70)), Text('${beans} Beans', style: TextStyle(color: Color(0xFF2B9AF3), fontWeight: FontWeight.bold, fontSize: 18))]),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Estimasi Rupiah', style: TextStyle(color: Colors.white70)), Text('Rp ${rp.toString()}', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 18))]),
            SizedBox(height: 8),
            Text('Rate: 1 Bean = Rp 1.111 (Rp 10.000 = 9.000 beans) - Host 60%', style: TextStyle(color: Colors.white38, fontSize: 10)),
          ])),
          SizedBox(height: 20),
          Text('Metode Pencairan (Gratis tanpa modal)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(children: ['DANA','OVO','GOPAY'].map((e) => Container(margin: EdgeInsets.only(right: 8), padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Color(0xFF2B9AF3), borderRadius: BorderRadius.circular(20)), child: Text(e, style: TextStyle(color: Colors.white, fontSize: 12)))).toList()),
          SizedBox(height: 12),
          TextField(controller: ewalletCtrl, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Nomor DANA / OVO cth: 0812xxxx', hintStyle: TextStyle(color: Colors.white38), filled: true, fillColor: Color(0xFF1A1A1A), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
          SizedBox(height: 12),
          TextField(keyboardType: TextInputType.number, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Jumlah Beans min 9000', hintStyle: TextStyle(color: Colors.white38), filled: true, fillColor: Color(0xFF1A1A1A), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
          SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2B9AF3), padding: EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: (){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request WD berhasil! Tunggu approve admin'))); }, child: Text('Request Withdraw', style: TextStyle(fontWeight: FontWeight.bold)))),
          SizedBox(height: 12),
          Text('Status: PENDING -> APPROVED -> SUCCESS\nMin WD Rp 10.000\nFee 0% di awal\nHost dapat 60% dari semua gift', style: TextStyle(color: Colors.white54, fontSize: 11)),
        ]),
      ),
    );
  }
}
