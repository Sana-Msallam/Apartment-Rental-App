import 'package:apartment_rental_app/screens/log_in.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// يجب استيراد شاشتك الرئيسية (واجهة الشقق)
// import 'package:apartment_rental_app/screens/home_screen.dart';
// ولأغراض التجربة نستخدم شاشة تفاصيل الشقة
import 'package:apartment_rental_app/screens/apartment_details_screen.dart';
import 'package:apartment_rental_app/models/apartment_model.dart';

import '../main.dart';


const Color kGradientColorStart = Color(0x00234F68);
const Color kGradientColorMid = Color(0x66234F68);
const Color kGradientColorEnd = Color(0xCC234F68);

class StartPage extends StatelessWidget {
  StartPage({super.key});

  final storage = const FlutterSecureStorage(); // تهيئة خدمة التخزين هنا

  Color kPrimaryColor = Color(0xFF234F68);
  final String vfont = 'Lato-Regular';

  // 1. الدالة الجديدة التي تنفذ عملية فحص التوكن والانتقال
  Future<void> _handleStartButton(BuildContext context) async {
    // 💡 يمكن هنا عرض مؤشر تحميل أثناء انتظار قراءة التوكن، لكننا سنفترض سرعة القراءة

    String? token = await storage.read(key: 'jwt_token'); // قراءة التوكن المخزن

    if (token != null) {
      // التوكن موجود: توجيه المستخدم مباشرة إلى واجهة الشقق
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ApartmentDetailsScreen(apartment: dummyApartment),
        ),
      );
    } else {
      // لا يوجد توكن: توجيه المستخدم إلى صفحة تسجيل الدخول
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ... (كود عرض الصورة والخلفية المتدرجة لم يتغير) ...
          SizedBox(
            width: size.width,
            height: size.height,
            child: Image.asset('assets/images/start.png', fit: BoxFit.cover),
          ),
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  kGradientColorStart,
                  kGradientColorMid,
                  kGradientColorEnd,
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 60.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Sakani',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        fontFamily: 'Lato-BoldItalic',
                      ),
                    ),
                  ),

                  SizedBox(height: 90),

                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: CustomButton(
                      textButton: 'Let\'s started',
                      kPrimaryColor: Color(0xFFFFFFFF),
                      vTextColor: Color(0xFF234F68),
                      width: double.infinity,
                      

                      onPressed: () => _handleStartButton(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}