import 'dart:io';
import 'dart:ui';
import 'package:apartment_rental_app/constants/app_string.dart';
import 'package:apartment_rental_app/screens/PasswordScreen.dart';
import 'package:apartment_rental_app/widgets/buildLabel.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:apartment_rental_app/widgets/custom_text_filed.dart';
import 'package:apartment_rental_app/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

const Color vBorderColor = Color(0xFFC0C0C0);
const Color kPrimaryColor = Color(0xFF234F68);
const double vheight = 15;
final String vfont = 'Lato-Regular';

class RegisterPage extends ConsumerStatefulWidget {
  RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _onNextPressed() {
    if (_formKey.currentState!.validate()) {
      String formattedDateForServer = "";
      if (_selectedDate != null) {
        formattedDateForServer =
            DateFormat('yyyy-MM-dd').format(_selectedDate!);
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PasswordScreen(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            phone: _phoneController.text.trim(),
            dateOfBirth: formattedDateForServer,
            email: _emailController.text.trim(),
          ),
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final texts = ref.watch(stringsProvider);

    final titleColor = isDark ? Colors.white : theme.primaryColor;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: Image(
              image: AssetImage('assets/images/start.png'),
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                              texts.createAccount,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: titleColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          buildLabel(context, texts.firstName),
                          CustomTextFiled(
                            controller: _firstNameController,
                            hintText: texts.firstNameHint,
                            prefixIcon: Icons.person_outline,
                            validator: (v) => v!.isEmpty ? "Required" : null,
                          ),
                          const SizedBox(height: 15),
                          buildLabel(context, texts.lastName),
                          CustomTextFiled(
                            controller: _lastNameController,
                            hintText: texts
                                .lastNameHint, 
                            prefixIcon: Icons.person_outline,
                            validator: (v) => v!.isEmpty ? "Required" : null,
                          ),
                          const SizedBox(height: 15),
                          buildLabel(context, texts.emailAddress),
                          CustomTextFiled(
                            controller: _emailController,
                            hintText:
                                "example@mail.com",
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty)
                                return "Email is required";
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(v)) {
                                return texts.invalidEmail;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          buildLabel(context,
                              texts.phoneLabel), 
                          CustomTextFiled(
                            controller: _phoneController,
                            hintText: "09xx xxx xxx",
                            prefixIcon: Icons.phone_android_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (v) {
                              if (v == null || v.isEmpty)
                                return "Phone number is required";
                              if (v.length < 10) return texts.phoneInvalid;
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          buildLabel(context, texts.birthDate),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: CustomTextFiled(
                                controller: _dateController,
                                hintText: texts
                                    .birthDateHint, 
                                validator: (v) =>
                                    v!.isEmpty ? texts.requiredField : null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          CustomButton(
                            onTap: _onNextPressed,
                            textButton: texts.next,
                            kPrimaryColor:
                                isDark ? Colors.white : theme.primaryColor,
                            vTextColor: isDark ? Colors.black : Colors.white,
                            width: double.infinity,
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
