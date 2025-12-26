import 'package:apartment_rental_app/screens/home_screen.dart';
import 'package:apartment_rental_app/screens/apartment_details_screen.dart';
import 'package:apartment_rental_app/screens/booking_screen.dart';
import 'package:apartment_rental_app/screens/start.dart';
import 'package:apartment_rental_app/models/apartment_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main()async  {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 💡 التصحيح المطلوب: استخدام الدالة الصحيحة (initializeDateFormatting)
  try {
      await initializeDateFormatting('en', null); 
  } catch (e) {
    // يمكنك طباعة الخطأ إذا حدث فشل في التهيئة
    print('Initialization failed: $e');
  }
  await const FlutterSecureStorage().deleteAll(); // سيمسح كل شيء مخزن في Secure Storage
  runApp(

       ProviderScope(
        child: Sakani(),
      ),
  );
}

final String vfont = 'vfo-Regular';

// void main() {
//   runApp(Sakani());
// }


class Sakani extends StatelessWidget {


  Sakani({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sakani Apartment Rental',

      home: StartPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
