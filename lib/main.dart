import 'package:flutter/material.dart';
import 'package:[STRIPPED 69 bytes].dart';
import 'package:permission_handler/permission_handler.dart';

const int appID = 1234567890;
const String appSign = "YOUR_APP_SIGN_HERE";

void main() { runApp(const QteaLiveApp()); }

class QteaLiveApp extends StatelessWidget {
  const QteaLiveApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'QTEA LIVE', debugShowCheckedModeBanner: false, home: const LoginScreen());
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  bool isOTPSent = false;

  void loginGmail() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Gmail MOCK Berhasil!'), backgroundColor: Color(0xFF2B9AF3)));
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const QteaHome(userInfo: 'Gmail: deri.menyendiri@gmail.com')));
    });
  }

  void sendOTP() {
    if (phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Isi No HP dulu +62...')));
      return;
    }
    setState(() => isOTPSent = true);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP MOCK terkirim! Ketik 123456'), backgroundColor: Color(0xFF2B9AF3)));
  }

  void verifyOTP() {
    if (otpController.text.trim() == "123456") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => QteaHome(userInfo: 'HP: ${phoneController.text}')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP salah, coba 123456')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SingleChildScrollView(padding: EdgeInsets.all(25), child: Column(children: [
      SizedBox(height: 60),
      Image.asset('assets/logo/qtea_q_icon_transparent.png', width: 100, height: 100, errorBuilder: (c,e,s) => Container(width:100,height:100,decoration:BoxDecoration(color:Color(0xFF2B9AF3),borderRadius:BorderRadius.circular(25)),child:Center(child:Text('Q',style:TextStyle(fontSize:60,fontWeight:FontWeight.bold,color:Colors.white))))),
      SizedBox(height:15),
      Text('QTEA LIVE', style: TextStyle(fontSize:28,fontWeight:FontWeight.bold,color:Color(0xFF2B9AF3))),
      Text('V4.4 MOCK LOGIN • Logo Q Baru', style: TextStyle(fontSize:11,color:Colors.black54)),
      Container(margin:EdgeInsets.only(top:10),padding:EdgeInsets.symmetric(horizontal:12,vertical:6),decoration:BoxDecoration(color:Colors.green.withOpacity(0.1),borderRadius:BorderRadius.circular(20)),child:Text('Agency: QTEABDG01 GOLD 15%', style: TextStyle(fontSize:10,color:Colors.green,fontWeight:FontWeight.bold))),
      SizedBox(height:40),
      SizedBox(width:double.infinity,height:55,child:ElevatedButton.icon(style:ElevatedButton.styleFrom(backgroundColor:Colors.white,side:BorderSide(color:Colors.grey.shade300),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(30))),onPressed:loginGmail,icon:Icon(Icons.email,color:Colors.red),label:Text('Login dengan Gmail',style:TextStyle(fontWeight:FontWeight.bold,color:Colors.black87)))),
      SizedBox(height:20),
      Row(children:[Expanded(child:Divider()),Padding(padding:EdgeInsets.symmetric(horizontal:10),child:Text('ATAU',style:TextStyle(color:Colors.grey))),Expanded(child:Divider())]),
      SizedBox(height:20),
      TextField(controller:phoneController,keyboardType:TextInputType.phone,decoration:InputDecoration(labelText:'No HP (+62...)',hintText:'+6281234567890',prefixIcon:Icon(Icons.phone,color:Color(0xFF2B9AF3)),border:OutlineInputBorder(borderRadius:BorderRadius.circular(15)))),
      SizedBox(height:12),
      if (isOTPSent) TextField(controller:otpController,keyboardType:TextInputType.number,decoration:InputDecoration(labelText:'Kode OTP 6 digit',hintText:'123456',prefixIcon:Icon(Icons.lock,color:Color(0xFF2B9AF3)),border:OutlineInputBorder(borderRadius:BorderRadius.circular(15)))),
      SizedBox(height:15),
      SizedBox(width:double.infinity,height:55,child:ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:Color(0xFF2B9AF3),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(15))),onPressed:isOTPSent?verifyOTP:sendOTP,child:Text(isOTPSent?'Verifikasi OTP':'Kirim OTP ke No HP',style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold)))),
      SizedBox(height:20),
      Text('MOCK MODE: Gmail langsung masuk, No HP OTP = 123456\nDual Wallet: 9300 Beans (9000 WD + 300 No WD)', textAlign: TextAlign.center, style: TextStyle(fontSize:9,color:Colors.grey)),
    ])));
  }
}

class QteaHome extends StatefulWidget {
  final String userInfo;
  const QteaHome({super.key, this.userInfo = 'Guest'});
  @override
  State<QteaHome> createState() => _QteaHomeState();
}

class _QteaHomeState extends State<QteaHome> {
  Future<void> requestPermissions() async { await [Permission.camera, Permission.microphone].request(); }
  void goLive(String roomID, bool isHost) async { await requestPermissions(); if (!mounted) return; Navigator.push(context, MaterialPageRoute(builder: (context) => LivePage(roomID: roomID, isHost: isHost))); }
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      appBar: AppBar(backgroundColor:Color(0xFF2B9AF3),title:Row(children:[Image.asset('assets/logo/qtea_q_icon_transparent.png',width:28,height:28,errorBuilder:(c,e,s)=>Text('Q',style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold))),SizedBox(width:8),Text('QTEA LIVE',style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold))]),actions:[IconButton(onPressed:(){Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>LoginScreen()));},icon:Icon(Icons.logout,color:Colors.white))]),
      body: Column(children:[
        Container(width:double.infinity,padding:EdgeInsets.all(15),color:Color(0xFF2B9AF3).withOpacity(0.08),child:Column(children:[Text('Login: ${(context.widget as QteaHome).userInfo}',style:TextStyle(fontSize:10)),SizedBox(height:10),SizedBox(width:double.infinity,child:ElevatedButton.icon(style:ElevatedButton.styleFrom(backgroundColor:Colors.red,padding:EdgeInsets.symmetric(vertical:14),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25))),onPressed:()=>goLive('qtea_${DateTime.now().millisecondsSinceEpoch}',true),icon:Icon(Icons.live_tv,color:Colors.white),label:Text('GO LIVE 🔴',style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold))))])),
        Expanded(child:ListView.builder(itemCount:1,itemBuilder:(context,index){return Card(margin:EdgeInsets.symmetric(horizontal:15,vertical:6),child:ListTile(leading:Container(width:50,height:50,decoration:BoxDecoration(color:Color(0xFF2B9AF3).withOpacity(0.2),borderRadius:BorderRadius.circular(12)),child:Center(child:Image.asset('assets/logo/qtea_q_icon_transparent.png',width:30,height:30,errorBuilder:(c,e,s)=>Text('Q',style:TextStyle(color:Color(0xFF2B9AF3),fontWeight:FontWeight.bold))))),title:Text('Barudak Aing Official',style:TextStyle(fontWeight:FontWeight.bold)),subtitle:Text('QTEABDG01 • 1.2k viewers'),trailing:Icon(Icons.play_circle_fill,color:Colors.red),onTap:()=>goLive('qtea_bdg01',false)));})),
      ]),
    );
  }
}

class LivePage extends StatelessWidget {
  final String roomID; final bool isHost;
  const LivePage({super.key, required this.roomID, required this.isHost});
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltLiveStreaming(appID:appID,appSign:appSign,userID:'qtea_${DateTime.now().millisecondsSinceEpoch}',userName:isHost?'Host_QTEABDG01':'Viewer',liveID:roomID,config:isHost?ZegoUIKitPrebuiltLiveStreamingConfig.host():ZegoUIKitPrebuiltLiveStreamingConfig.audience());
  }
}
