import 'package:apartment_rental_app/screens/home_screen.dart';
import 'package:apartment_rental_app/screens/log_in.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// يجب استيراد شاشتك الرئيسية (واجهة الشقق)
// import 'package:apartment_rental_app/screens/home_screen.dart';
// ولأغراض التجربة نستخدم شاشة تفاصيل الشقة
import 'package:apartment_rental_app/screens/apartment_details_screen.dart';
import 'package:apartment_rental_app/models/apartment_details_model.dart';

import '../main.dart';

const Color kGradientColorStart = Color(0x00234F68);
const Color kGradientColorMid = Color(0x66234F68);
const Color kGradientColorEnd = Color(0xCC234F68);

class StartPage extends StatelessWidget {
  StartPage({super.key});

  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
    encryptedSharedPreferences: true, // تفعيل التشفير المتوافق مع أندرويد الحديث
  ),

  );

  Future<void> _handleStartButton(BuildContext context) async {
    String? token = await storage.read(key: 'jwt_token');
    if (context.mounted) {
      if (token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const Color myBlue = Color(0xFF234F68);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : myBlue,
      body: Stack(
        children: [

          Positioned.fill(
            child: Opacity(
              opacity: isDark ? 0.5 : 0.9,
              child: Image.asset('assets/images/start.png', fit: BoxFit.cover),
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    isDark ? Colors.transparent : myBlue.withOpacity(0.4),
                    Colors.transparent,
                    isDark ? Colors.black.withOpacity(0.5) : myBlue,
                  ],
                  stops: const [0.1, 0.4, 1.0],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 5),
                const Text(
                  'Sakani',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontFamily: 'Lato-BoldItalic',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Find your perfect home easily",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(flex: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 40,
                  ),
                  child: CustomButton(
                    textButton: 'Get Started',
                    kPrimaryColor: isDark ? Colors.white : myBlue,
                    vTextColor: isDark ? const Color(0xFF424242) : Colors.white,
                    width: double.infinity,
                    onTap: () => _handleStartButton(context),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
