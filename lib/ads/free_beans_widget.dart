
import 'package:flutter/material.dart';
import 'ad_manager.dart';

class FreeBeansWidget extends StatefulWidget {
  @override
  _FreeBeansWidgetState createState() => _FreeBeansWidgetState();
}

class _FreeBeansWidgetState extends State<FreeBeansWidget> {
  int todayWatched = 2;
  int maxPerDay = 10;
  int beansPerAd = 100;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF2B9AF3), Colors.purple]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.play_circle_fill, color: Colors.white, size: 32),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nonton Iklan Dapat ${beansPerAd} Beans Gratis!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                Text('${todayWatched}/${maxPerDay} hari ini • Beans TIDAK BISA WD tapi bisa buat gift', style: TextStyle(color: Colors.white70, fontSize: 10)),
                SizedBox(height: 4),
                LinearProgressIndicator(value: todayWatched/maxPerDay, backgroundColor: Colors.white24, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              ],
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Color(0xFF2B9AF3), padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
            onPressed: todayWatched >= maxPerDay ? null : () {
              QTEAAdManager().showRewardedAd(onRewarded: (beans) {
                setState(() => todayWatched++);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Dapat $beans beans gratis! Tonton ${maxPerDay - todayWatched} lagi hari ini')),
                );
                // TODO: Call API untuk tambah topup_beans user
              });
            },
            child: Text(todayWatched >= maxPerDay ? 'Habis' : 'Tonton', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
