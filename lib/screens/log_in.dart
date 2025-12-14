import 'package:apartment_rental_app/screens/apartment_details_screen.dart';
import 'package:apartment_rental_app/screens/api_service.dart';
import 'package:apartment_rental_app/screens/sign_up.dart';
import 'package:apartment_rental_app/widgets/apartment_model.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:apartment_rental_app/widgets/custom_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:apartment_rental_app/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final String vfont = 'Lato-Regular';

Color kPrimaryColor = Color(0xFF234F68);

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();


  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _handleLogin() async {
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter phone number and password')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await _apiService.login(phone, password);
      if (response != null) {
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = response.data;
          // إذا نجح تسجيل الدخول (الباك اند عادة يرجع 200)
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login Successful !')));
          String accessToken = responseData['access_token'];
           await storage.write(key: 'jwt_token', value: accessToken);
          // الانتقال للصفحة التالية
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ApartmentDetailsScreen(apartment: dummyApartment),
            ),
          );
        } else {
          //هون معنى انو مارجع null بسفي شي من المعلومات خطا
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Failed: Invalid credentials')),
          );
        }
      } else {
        // حالة الـ null (انقطاع إنترنت أو مشكلة تقنية بالسيرفر)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connection Error: Please check your internet'),
          ),
        );
      }
    } catch (e) {
      // هذه تعمل في حال حدث خطأ "غير متوقع" في الكود نفسه
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = _isLoading
        ? kPrimaryColor.withOpacity(0.7) // لون باهت (70% شفافية) أثناء التحميل
        : kPrimaryColor;
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Spacer(flex: 2),
            Image.asset('assets/images/icon.png'),
            Spacer(flex: 1),
            CustomTextFiled(
              hintText: 'Phone number',
              controller: _phoneController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              suffixIconWidget: Icon(Icons.phone, color: kPrimaryColor),
            ),
            SizedBox(height: 18),
            CustomTextFiled(
              hintText: 'Passowrd',
              isPassword: true,
              controller: _passwordController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            SizedBox(height: 18),
            CustomButton(
              textButton: _isLoading ? 'Loading...' : 'LOGIN',
              vTextColor: Color(0xFFFFFFFF),
              kPrimaryColor: buttonColor,
              width: double.infinity,
              onPressed: _isLoading ? () {} : _handleLogin,
            ),
            SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t Have An Acount? ',
                  style: TextStyle(color: Color(0xFF898989), fontFamily: vfont),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return RegisterPage();
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Register',

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                      fontFamily: vfont,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}
