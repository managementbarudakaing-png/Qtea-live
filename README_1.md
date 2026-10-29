
# QTEA LIVE - Starter Project (GRATIS TANPA MODAL)

## Cara Jalanin 3 Langkah:

1. Install Flutter: https://docs.flutter.dev/get-started/install
2. Di terminal:
   flutter pub get
   flutter run

3. Untuk Live Video Gratis:
   - Daftar https://www.zegocloud.com (gratis 10.000 menit)
   - Copy AppID & AppSign ke lib/screens/live_room_screen.dart
   - Ganti placeholder dengan ZegoUIKitPrebuiltLiveStreaming

## File Penting:

- assets/qtea_gifts_92.json -> 92 gift (30 JP + 62 Murni)
- assets/qtea_topup_packages.json -> Harga Rp 10.000 = 9.000 coin
- assets/logo/ -> Logo QTEA LIVE flat biru

## Aturan Gift:
- Host 60% - Jackpot HANYA dari Gift JP - Gift Murni tidak masuk Pool
- Gift JP 2 koin winrate 45% (buat pemanasan)
- Gift JP 50 koin NAGA DEWA winrate 2% tapi x1000-x10000 (50.000-500.000 coin)

## Topup:
- Rp 10.000 = 9.000 coin (base)
- Manual transfer DANA dulu biar gratis tanpa potongan payment gateway

## Next:
- Import qtea_gifts_92.sql ke MySQL / Firebase
- Jalankan qtea_jackpot_api.js di backend (Node.js)

By Deri Cahill - QTEA LIVE 2026


## FITUR WD (Withdraw) - BARU:
- Min WD 9000 beans = Rp 10.000
- Rate 1 bean = Rp 1.111
- File: qtea_withdraw.sql + qtea_withdraw_api.js
- Screen: lib/screens/withdraw_screen.dart -> route /withdraw
- Host: Me -> Withdraw -> DANA/OVO/GOPAY
- Admin approve manual di /api/admin/withdrawals
