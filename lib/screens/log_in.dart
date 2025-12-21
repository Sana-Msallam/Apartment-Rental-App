import 'dart:ui';
import 'package:apartment_rental_app/screens/home_screen.dart';
import 'package:apartment_rental_app/services/api_service.dart';
import 'package:apartment_rental_app/screens/sign_up.dart';
import 'package:apartment_rental_app/widgets/buildLabel.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:apartment_rental_app/widgets/custom_text_filed.dart';
import 'package:apartment_rental_app/widgets/glass_container.dart';
import 'package:flutter/material.dart';
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
      // 1. استلام كائن المستخدم (UserModel) مباشرة
      final user = await _apiService.login(phone, password);

      // 2. التحقق إذا كان الكائن موجوداً (نجاح)
      if (user != null) {
        // 3. بما أننا وضعنا التوكن داخل الموديل، نصل إليه عبر user.token
        if (user.token != null && user.token!.isNotEmpty) {
          await storage.write(key: 'jwt_token', value: user.token);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login Successful!'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
        } else {
          _showSnackBar('Login failed: Token not found in user data');
        }
      } else {
        // إذا رجع null معناها البيانات خاطئة أو السيرفر لم يستجب
        _showSnackBar('Login Failed: Invalid credentials or Connection Error');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // دالة مساعدة لتقليل تكرار الكود
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. هذا السطر هو الأهم لمنع اهتزاز أو تحرك الخلفية عند ظهور الكيبورد
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // 2. طبقة الصورة الثابتة (مفصولة تماماً)
          const Positioned.fill(
            child: Image(
              image: AssetImage('assets/images/start.png'),
              fit: BoxFit.cover,
            ),
          ),

          // 3. طبقة المحتوى مع معالجة يدوية لمساحة الكيبورد
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                // نستخدم هذا الـ Padding لنجعل المستطيل يرتفع فوق الكيبورد يدوياً
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Center(
                    child: GlassContainer(
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min, // ليأخذ العمود حجم محتواه فقط
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Welcome Back",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Center(
                            child: Text(
                              "Sign in to your account",
                              style: TextStyle(
                                color: Color.fromARGB(255, 44, 44, 44),
                              ),
                            ),
                          ),
                          const SizedBox(height: 35),

                          buildLabel("Last Name"),

                          CustomTextFiled(
                            controller: _phoneController,
                            hintText: "09xx xxx xxx",
                            prefixIcon: Icons.phone_android_rounded,
                          ),

                          const SizedBox(height: 20),
                          Text(
                            "Password",
                            style: TextStyle(color: kPrimaryColor),
                          ),
                          const SizedBox(height: 8),

                          CustomTextFiled(
                            controller: _passwordController,
                            hintText: "••••••••",
                            isPassword: true,
                            prefixIcon: Icons.lock_outline_rounded,
                          ),

                          const SizedBox(height: 30),

                          _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.blueAccent,
                                  ),
                                )
                              : Center(
                                  child: CustomButton(
                                    textButton: 'LOGIN',
                                    vTextColor: const Color(0xFFFFFFFF),
                                    kPrimaryColor: kPrimaryColor,
                                    width: 280,
                                    onTap: _handleLogin,
                                  ),
                                ),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t Have An Account? ',
                                style: TextStyle(color: Colors.white),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}