// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:apartment_rental_app/screens/home_screen.dart';

// class AccountPendingScreen extends StatefulWidget {
//   const AccountPendingScreen({super.key});

//   @override
//   State<AccountPendingScreen> createState() => _AccountPendingScreenState();
// }

// class _AccountPendingScreenState extends State<AccountPendingScreen> {

//   @override
//   void initState() {
//     super.initState();
    
//     // إعداد المستمع للإشعارات وأنتِ داخل التطبيق (Foreground)
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       // إذا وصل إشعار وكان يحتوي على بيانات تدل على القبول
//       if (message.data['status'] == 'approved' || message.notification?.title == "Account Approved") {
        
//         // الانتقال فوراً للشاشة الرئيسية
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomeScreen()),
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false, // منع الرجوع
//       child: Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const CircularProgressIndicator(),
//               const SizedBox(height: 30),
//               const Icon(Icons.verified_user_outlined, size: 80, color: Color(0xFF234F68)),
//               const Text("انتظار تفعيل الحساب...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//               const Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: Text("ستنتقل للتطبيق تلقائياً فور موافقة الإدارة", textAlign: TextAlign.center),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }