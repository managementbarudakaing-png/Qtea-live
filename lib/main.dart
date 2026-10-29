import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

const int appID = 1234567890;
const String appSign = "YOUR_APP_SIGN_HERE";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try { await Firebase.initializeApp(); } catch (e) { print("MOCK mode"); }
  runApp(const QteaLiveApp());
}

class QteaLiveApp extends StatelessWidget {
  const QteaLiveApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'QTEA LIVE', debugShowCheckedModeBanner: false, home: const AuthWrapper());
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    try {
      return StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF2B9AF3))));
        if (snapshot.hasData) return const QteaHome();
        return const LoginScreen();
      });
    } catch (e) { return const LoginScreen(); }
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
  String verificationId = "";
  bool isOTPSent = false;
  bool isLoading = false;

  Future<void> loginWithGoogle() async {
    setState(() => isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) { setState(() => isLoading = false); return; }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('MOCK GMAIL - Lanjut Home'), backgroundColor: Color(0xFF2B9AF3)));
      await Future.delayed(Duration(seconds: 1));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const QteaHome()));
    }
    setState(() => isLoading = false);
  }

  Future<void> sendOTP() async {
    if (phoneController.text.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Masukkan No HP +62'))); return; }
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneController.text.trim(),
        verificationCompleted: (cred) async => await FirebaseAuth.instance.signInWithCredential(cred),
        verificationFailed: (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: ${e.message}'))); setState(() => isLoading = false); },
        codeSent: (verId, resend) { setState(() { verificationId = verId; isOTPSent = true; isLoading = false; }); },
        codeAutoRetrievalTimeout: (verId) => verificationId = verId,
      );
    } catch (e) {
      setState(() { isOTPSent = true; isLoading = false; verificationId = "MOCK_VER_ID"; });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('MOCK OTP: ketik 123456'), backgroundColor: Color(0xFF2B9AF3)));
    }
  }

  Future<void> verifyOTP() async {
    setState(() => isLoading = true);
    try {
      if (verificationId == "MOCK_VER_ID") {
        if (otpController.text.trim() == "123456") Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const QteaHome()));
        else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Salah, coba 123456')));
        setState(() => isLoading = false); return;
      }
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpController.text.trim());
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const QteaHome()));
    } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP Salah'))); setState(() => isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SingleChildScrollView(padding: EdgeInsets.all(25), child: Column(children: [
      SizedBox(height: 60),
      Image.asset('assets/logo/qtea_q_icon_transparent.png', width: 100, height: 100, errorBuilder: (c,e,s) => Container(width:100,height:100,decoration:BoxDecoration(color:Color(0xFF2B9AF3),borderRadius:BorderRadius.circular(25)),child:Center(child:Text('Q',style:TextStyle(fontSize:60,fontWeight:FontWeight.bold,color:Colors.white))))),
      SizedBox(height:15),
      Text('QTEA LIVE', style: TextStyle(fontSize:28,fontWeight:FontWeight.bold,color:Color(0xFF2B9AF3))),
      Text('V4.4 LOGIN Gmail + HP', style: TextStyle(fontSize:11,color:Colors.black54)),
      SizedBox(height:40),
      SizedBox(width:double.infinity,height:55,child:ElevatedButton.icon(style:ElevatedButton.styleFrom(backgroundColor:Colors.white,side:BorderSide(color:Colors.grey.shade300),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(30))),onPressed:isLoading?null:loginWithGoogle,icon:Icon(Icons.email,color:Colors.red),label:Text('Login dengan Gmail',style:TextStyle(fontWeight:FontWeight.bold,color:Colors.black87)))),
      SizedBox(height:20),
      Row(children:[Expanded(child:Divider()),Padding(padding:EdgeInsets.symmetric(horizontal:10),child:Text('ATAU',style:TextStyle(color:Colors.grey))),Expanded(child:Divider())]),
      SizedBox(height:20),
      TextField(controller:phoneController,keyboardType:TextInputType.phone,decoration:InputDecoration(labelText:'No HP (+62...)',hintText:'+6281234567890',prefixIcon:Icon(Icons.phone,color:Color(0xFF2B9AF3)),border:OutlineInputBorder(borderRadius:BorderRadius.circular(15)))),
      SizedBox(height:12),
      if (isOTPSent) TextField(controller:otpController,keyboardType:TextInputType.number,decoration:InputDecoration(labelText:'Kode OTP 6 digit',hintText:'123456',prefixIcon:Icon(Icons.lock,color:Color(0xFF2B9AF3)),border:OutlineInputBorder(borderRadius:BorderRadius.circular(15)))),
      SizedBox(height:15),
      SizedBox(width:double.infinity,height:55,child:ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:Color(0xFF2B9AF3),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(15))),onPressed:isLoading?null:(isOTPSent?verifyOTP:sendOTP),child:isLoading?CircularProgressIndicator(color:Colors.white):Text(isOTPSent?'Verifikasi OTP':'Kirim OTP ke No HP',style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold)))),
    ])));
  }
}

class QteaHome extends StatefulWidget { const QteaHome({super.key}); @override State<QteaHome> createState() => _QteaHomeState(); }
class _QteaHomeState extends State<QteaHome> {
  Future<void> requestPermissions() async { await [Permission.camera, Permission.microphone].request(); }
  void goLive(String roomID, bool isHost) async { await requestPermissions(); if (!mounted) return; Navigator.push(context, MaterialPageRoute(builder: (context) => LivePage(roomID: roomID, isHost: isHost))); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor:Color(0xFF2B9AF3),title:Text('QTEA LIVE',style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold)),actions:[IconButton(onPressed:() async {await FirebaseAuth.instance.signOut(); await GoogleSignIn().signOut(); if(!mounted)return; Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>LoginScreen()));},icon:Icon(Icons.logout,color:Colors.white))]),
      body: Column(children:[
        Container(width:double.infinity,padding:EdgeInsets.all(15),color:Color(0xFF2B9AF3).withOpacity(0.08),child:SizedBox(width:double.infinity,child:ElevatedButton.icon(style:ElevatedButton.styleFrom(backgroundColor:Colors.red,padding:EdgeInsets.symmetric(vertical:14),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25))),onPressed:()=>goLive('qtea_${DateTime.now().millisecondsSinceEpoch}',true),icon:Icon(Icons.live_tv,color:Colors.white),label:Text('GO LIVE 🔴',style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold))))),
        Expanded(child:ListView.builder(itemCount:1,itemBuilder:(context,index){return Card(margin:EdgeInsets.symmetric(horizontal:15,vertical:6),child:ListTile(leading:Container(width:50,height:50,decoration:BoxDecoration(color:Color(0xFF2B9AF3).withOpacity(0.2),borderRadius:BorderRadius.circular(12)),child:Center(child:Image.asset('assets/logo/qtea_q_icon_transparent.png',width:30,height:30,errorBuilder:(c,e,s)=>Text('Q',style:TextStyle(color:Color(0xFF2B9AF3),fontWeight:FontWeight.bold))))),title:Text('Barudak Aing Official',style:TextStyle(fontWeight:FontWeight.bold)),subtitle:Text('QTEABDG01'),trailing:Icon(Icons.play_circle_fill,color:Colors.red),onTap:()=>goLive('qtea_bdg01',false)));})),
      ]),
    );
  }
}
class LivePage extends StatelessWidget {
  final String roomID; final bool isHost; const LivePage({super.key, required this.roomID, required this.isHost});
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltLiveStreaming(appID:appID,appSign:appSign,userID:'qtea_${DateTime.now().millisecondsSinceEpoch}',userName:isHost?'Host_QTEABDG01':'Viewer',liveID:roomID,config:isHost?ZegoUIKitPrebuiltLiveStreamingConfig.host():ZegoUIKitPrebuiltLiveStreamingConfig.audience());
  }
}
