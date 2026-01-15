import 'dart:ui';
import 'package:apartment_rental_app/constants/app_string.dart';
import 'package:apartment_rental_app/screens/UploadPhotosScreen.dart';
import 'package:apartment_rental_app/widgets/buildLabel.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:apartment_rental_app/widgets/custom_text_filed.dart';
import 'package:apartment_rental_app/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Color kPrimaryColor = Color(0xFF234F68);
const Color vBorderColor = Color(0xFFC0C0C0);

class PasswordScreen extends ConsumerStatefulWidget {
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
  ConsumerState<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends ConsumerState<PasswordScreen> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _handleNextStep() {
    if (_formKey.currentState!.validate()) {
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
    }
  }

  @override
  void dispose() {
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = ref.watch(stringsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dynamicColor = isDark ? Colors.white : theme.primaryColor;

    return Scaffold(
      extendBodyBehindAppBar: true, 
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/start.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints
                          .maxHeight, 
                    ),
                    child: SafeArea(
                      child: Padding(
                            padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Center(
                          child: GlassContainer(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                  
                                children: [
                                  Center(
                                    child: Text(
                                      texts.createPassword,
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: dynamicColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: Text(
                                      texts.passwordInstruction,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black54,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  buildLabel(context, texts.password),
                                  CustomTextFiled(
                                    controller: _passController,
                                    hintText: "••••••••",
                                    isPassword: true,
                                    prefixIcon: Icons.lock_outline_rounded,
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return texts.fieldRequired;
                                      if (value.length < 8)
                                        return texts.passTooShort;
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  buildLabel(context, texts.confirmPassword),
                                  CustomTextFiled(
                                    controller: _confirmPassController,
                                    hintText: "••••••••",
                                    isPassword: true,
                                    prefixIcon: Icons.lock_reset_rounded,
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return texts.fieldRequired;
                                      if (value != _passController.text)
                                        return texts.passNotMatch;
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 40),
                                  CustomButton(
                                    textButton: texts.next,
                                    onTap: _handleNextStep,
                                    width: double.infinity,
                                    kPrimaryColor: isDark
                                        ? Colors.white
                                        : theme.primaryColor,
                                    vTextColor:
                                        isDark ? Colors.black : Colors.white,
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
              );
            },
          ),
        ],
      ),
    );
  }
}
