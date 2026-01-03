import 'package:apartment_rental_app/screens/add_apartment_page.dart';
import 'package:apartment_rental_app/screens/apartment_details_screen.dart';
import 'package:apartment_rental_app/screens/booking_screen.dart';
import 'package:apartment_rental_app/screens/start.dart';
import 'package:apartment_rental_app/models/apartment_details_model.dart';
import 'package:apartment_rental_app/services/local_notifications_service.dart';
import 'package:apartment_rental_app/services/push_notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  // 💡 التصحيح المطلوب: استخدام الدالة الصحيحة (initializeDateFormatting)
  try {
      await initializeDateFormatting('en', null); 
  } catch (e) {
    // يمكنك طباعة الخطأ إذا حدث فشل في التهيئة
    print('Initialization failed: $e');
  }
  await const FlutterSecureStorage().deleteAll();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ) ;
 await Future.wait([
    PushNotificationsService.init(),
    LocalNotificationService.init(),
  ]);
  
  runApp(
       ProviderScope(
        child: Sakani(),
      ),
  );
}

class Sakani extends StatelessWidget {
  const Sakani({Key? key}) : super(key: key); // أضيفي const هنا للتحسين

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sakani Apartment Rental',

      home: StartPage(),
      debugShowCheckedModeBanner: false,
      // تأكدي أن الصفحة المطلوبة هي AddApartmentPage
      // home:AddApartmentPage(),

//       home: ApartmentDetailsScreen(
//   apartment: dummyApartment, // استخدام الكائن التجريبي
// ),    
);
  }
}