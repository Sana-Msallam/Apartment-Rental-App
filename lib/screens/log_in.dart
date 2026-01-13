import 'dart:ui';
import 'package:apartment_rental_app/constants/app_string.dart';
import 'package:apartment_rental_app/providers/profile_provider.dart';
import 'package:apartment_rental_app/screens/account_pending_screen.dart';
import 'package:apartment_rental_app/screens/home_screen.dart';
import 'package:apartment_rental_app/services/api_service.dart';
import 'package:apartment_rental_app/screens/sign_up.dart';
import 'package:apartment_rental_app/widgets/buildLabel.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:apartment_rental_app/widgets/custom_text_filed.dart';
import 'package:apartment_rental_app/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const Color kPrimaryColor = Color(0xFF234F68);

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

 void _handleLogin() async {
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      _showSnackBar('Please enter phone number and password');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = await ref.read(apiServiceProvider).login(phone, password);

      if (user != null && user.token != null) { 
        // 1. حفظ التوكن أولاً
        await ref.read(storageProvider).write(key: 'jwt_token', value: user.token);
        print("Token saved successfully: ${user.token}");  
        // هذه الخطوة تضمن أن البروفايل سيُجلب فوراً دون انتظار إعادة تشغيل التطبيق
        await ref.read(profileProvider.notifier).getProfile(user.token!);
        if (!mounted) return;
        
        // 3. الانتقال للشاشة الرئيسية
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        _showSnackBar('Login Failed: Invalid credentials');
      }
    } catch (e) {
      final errorMessage = e.toString();
      if(errorMessage.contains('403')|| errorMessage.contains('pending verification')){
        if(!mounted) return;
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AccountPendingScreen()),
      );
      }
      else{
        _showSnackBar('Error: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  void _showSnackBar(String message) {
    if (!mounted) return;
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
final texts = ref.watch(stringsProvider); // السطر المطلوب
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const Positioned.fill(
            child: Image(
              image: AssetImage('assets/images/start.png'),
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Center(
                          child: GlassContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 20),
                                Center(
                                  child: Text(
                                    texts.welcomeBack,
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : theme.primaryColor,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 35),
                                buildLabel(context, texts.phoneLabel),
                                CustomTextFiled(
                                  controller: _phoneController,
                                  hintText: "09xx xxx xxx",
                                  prefixIcon: Icons.phone_android_rounded,
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 20),
                                buildLabel(context, texts.passwordLabel),
                                CustomTextFiled(
                                  controller: _passwordController,
                                  hintText: "••••••••",
                                  isPassword: true,
                                  prefixIcon: Icons.lock_outline_rounded,
                                ),
                                const SizedBox(height: 30),
                                Center(
                                  child: _isLoading
                                      ? CircularProgressIndicator(
                                          color: theme.primaryColor,
                                        )
                                      : CustomButton(
                                          textButton: texts.loginButton,
                                          kPrimaryColor: isDark
                                              ? Colors.white
                                              : theme.primaryColor,

                                          vTextColor: isDark
                                              ? theme.primaryColor
                                              : Colors.white,

                                          width: 280,
                                          onTap: _handleLogin,
                                        ),
                                ),
                                const SizedBox(height: 25),
                                _buildRegisterLink(theme),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterLink(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final texts = ref.watch(stringsProvider); // إضافة السطر هنا
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          texts.noAccount,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterPage()),
          ),
          child: Text(
            texts.registerNow,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : theme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
