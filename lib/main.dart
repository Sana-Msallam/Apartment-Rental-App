import 'package:apartment_rental_app/screens/apartment_details_screen.dart';
import 'package:apartment_rental_app/screens/booking_screen.dart';
import 'package:apartment_rental_app/screens/start.dart';
import 'package:apartment_rental_app/models/apartment_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
final ApartmentModel dummyApartment = ApartmentModel(
  city: 'Damascus',
  governorate: 'Syria',
  price: 2500,
  rooms: 3,
  bathrooms: 2,
  space: 120.5,
  floor: 5,
  titleDeed: 'milkeh',
  imageUrls: const [
    'assets/apartments/apartment-2094688_640.jpg',
    'assets/apartments/house-2414374_640.jpg',
    'assets/apartments/kitchen-416027_640.jpg',
    'assets/apartments/florida-home-1689859_640.jpg'
  ],
);

void main()async  {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 💡 التصحيح المطلوب: استخدام الدالة الصحيحة (initializeDateFormatting)
  try {
      await initializeDateFormatting('en', null); 
  } catch (e) {
    // يمكنك طباعة الخطأ إذا حدث فشل في التهيئة
    print('Initialization failed: $e');
  }

  runApp(Sakani());      
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
      home:StartPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
