
import 'package:flutter/material.dart';

class WithdrawScreen extends StatefulWidget {
  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  int topupBeans = 9000; // tidak bisa WD
  int earnedCoins = 18600; // bisa WD
  double rate = 1.111;

  @override
  Widget build(BuildContext context) {
    int rpWithdrawable = (earnedCoins * rate).floor();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Dompet - QTEA LIVE V3'), backgroundColor: Colors.black, foregroundColor: Color(0xFF2B9AF3)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            // WALLET A - TOPUP BEANS TIDAK BISA WD
            Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Icon(Icons.shopping_bag, color: Colors.grey), SizedBox(width:8), Text('Topup Beans (TIDAK BISA WD)', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))]),
              SizedBox(height: 8),
              Text('${topupBeans} Beans', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Hasil topup Rp 10.000 = 9.000 beans. Hanya untuk kirim gift. Tidak bisa dicairkan.', style: TextStyle(color: Colors.white38, fontSize: 11)),
              SizedBox(height: 8),
              Container(padding: EdgeInsets.symmetric(horizontal:8, vertical:2), decoration: BoxDecoration(color: Colors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(4)), child: Text('❌ TIDAK BISA WITHDRAW', style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold))),
            ])),
            SizedBox(height: 16),
            // WALLET B - EARNED COINS BISA WD
            Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFF2B9AF3), width:2)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Icon(Icons.monetization_on, color: Color(0xFF2B9AF3)), SizedBox(width:8), Text('Earned Coins (BISA WD)', style: TextStyle(color: Color(0xFF2B9AF3), fontWeight: FontWeight.bold))]),
              SizedBox(height: 8),
              Text('${earnedCoins} Coins', style: TextStyle(color: Color(0xFF2B9AF3), fontSize: 24, fontWeight: FontWeight.bold)),
              Text('≈ Rp ${rpWithdrawable}', style: TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Hasil gift dari viewer. Host dapat 60%. Inilah yang bisa di-WD.', style: TextStyle(color: Colors.white54, fontSize: 11)),
              SizedBox(height: 8),
              Container(padding: EdgeInsets.symmetric(horizontal:8, vertical:2), decoration: BoxDecoration(color: Color(0xFF2B9AF3).withOpacity(0.2), borderRadius: BorderRadius.circular(4)), child: Text('✅ BISA WITHDRAW - Min 9000 = Rp 10.000', style: TextStyle(color: Color(0xFF2B9AF3), fontSize: 10, fontWeight: FontWeight.bold))),
            ])),
            SizedBox(height: 20),
            Text('Metode Pencairan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(children: ['DANA','OVO','GOPAY','BCA'].map((e) => Container(margin: EdgeInsets.only(right:8), padding: EdgeInsets.symmetric(horizontal:12, vertical:8), decoration: BoxDecoration(color: e=='DANA'? Color(0xFF2B9AF3): Colors.grey[900], borderRadius: BorderRadius.circular(20)), child: Text(e, style: TextStyle(color: Colors.white, fontSize:12)))).toList()),
            SizedBox(height: 12),
            TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Nomor DANA: 0812xxxx', hintStyle: TextStyle(color: Colors.white38), filled: true, fillColor: Color(0xFF1A1A1A), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            SizedBox(height: 12),
            TextField(keyboardType: TextInputType.number, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Jumlah Earned Coins (min 9000)', hintStyle: TextStyle(color: Colors.white38), filled: true, fillColor: Color(0xFF1A1A1A), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            SizedBox(height: 20),
            SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2B9AF3), padding: EdgeInsets.symmetric(vertical:14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: (){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request WD ${earnedCoins} earned_coins berhasil! Topup beans tetap tidak bisa WD.'))); }, child: Text('Withdraw Earned Coins', style: TextStyle(fontWeight: FontWeight.bold)))),
            SizedBox(height: 12),
            Text('Aturan Anti-Jebol:\n- Topup Beans TIDAK BISA WD (anti topup->WD langsung)\n- Jackpot menang masuk Topup Beans lagi (harus gift lagi baru jadi Earned)\n- Hanya Host dapat Earned Coins 60% yang bisa WD', style: TextStyle(color: Colors.white54, fontSize:11)),
          ],
        ),
      ),
    );
  }
}
