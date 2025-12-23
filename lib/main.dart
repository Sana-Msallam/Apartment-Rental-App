import 'package:apartment_rental_app/screens/add_apartment_page.dart';
import 'package:apartment_rental_app/screens/apartment_details_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // try {
  //     await initializeDateFormatting('en', null); 
  // } catch (e) {
  //   print('Initialization failed: $e');
  // }

  // ✅ التعديل هنا: نشغل الكلاس الرئيسي الذي يحتوي على MaterialApp
  runApp(const Sakani()); 
}

class Sakani extends StatelessWidget {
  const Sakani({Key? key}) : super(key: key); // أضيفي const هنا للتحسين

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sakani Apartment Rental',
      debugShowCheckedModeBanner: false,
      // تأكدي أن الصفحة المطلوبة هي AddApartmentPage
      home:AddApartmentPage(),

//       home: ApartmentDetailsScreen(
//   apartment: dummyApartment, // استخدام الكائن التجريبي
// ),    
);
  }
}