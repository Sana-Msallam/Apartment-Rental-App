import 'dart:ui';
import 'package:apartment_rental_app/screens/UploadPhotosScreen.dart';
import 'package:apartment_rental_app/widgets/buildLabel.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:apartment_rental_app/widgets/custom_text_filed.dart';
import 'package:apartment_rental_app/widgets/glass_container.dart';
import 'package:flutter/material.dart';

// الألوان والتعريفات الثابتة المستخدمة في الـ Widgets الخاصة بك
const Color kPrimaryColor = Color(0xFF234F68);
const Color vBorderColor = Color(0xFFC0C0C0);
const Color kBackgroundColor = Color(0xFFF5F5F5);

// 1. صفحة إنشاء كلمة السر
class PasswordScreen extends StatefulWidget {
  final String firstName, lastName, phone, email, dateOfBirth;

  const PasswordScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.dateOfBirth,
  });
  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void _handleNextStep() {
    // نقوم بالتحقق مرة واحدة فقط
    if (_formKey.currentState!.validate()) {
      print("All validations passed! Proceeding to next step...");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadPhotosScreen(
            firstName: widget.firstName,
            lastName: widget.lastName,
            phone: widget.phone,
            dateOfBirth: widget.dateOfBirth,
            email: widget.email,
            password: _passController.text.trim(),
          ),
        ),
      );
    } else {
      print("Validation failed. User must fix errors first.");
    }
  }

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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                "Create Password",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Center(
                              child: Text(
                                "Choose a strong password to protect your account.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 44, 44, 44),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),

                            buildLabel("Password"),
                            CustomTextFiled(
                              controller: _passController,
                              hintText: "••••••••",
                              isPassword: true,
                              prefixIcon: Icons.lock_outline_rounded,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Password is required';
                                if (value.length < 8)
                                  return 'Minimum 8 characters';
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            buildLabel("Confirm Password"),
                            CustomTextFiled(
                              controller: _confirmPassController,
                              hintText: "••••••••",
                              isPassword: true,
                              prefixIcon: Icons.lock_reset_rounded,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Please confirm password';
                                if (value != _passController.text)
                                  return 'Passwords do not match';
                                return null;
                              },
                            ),

                            const SizedBox(height: 40),

                            Center(
                              child: CustomButton(
                                textButton: 'Next Step',
                                onTap: _handleNextStep,
                                width: 280,
                                vTextColor: Colors.white,
                                kPrimaryColor: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
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
