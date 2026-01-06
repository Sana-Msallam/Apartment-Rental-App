import 'dart:io';
import 'package:apartment_rental_app/constants/app_string.dart';
import 'package:apartment_rental_app/screens/account_pending_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import 'package:apartment_rental_app/controller/profile_controller.dart';
import 'package:apartment_rental_app/services/api_service.dart';
import 'package:apartment_rental_app/screens/log_in.dart';
import 'package:apartment_rental_app/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:apartment_rental_app/widgets/photo_upload.dart';

const Color kPrimaryColor = Color(0xFF234F68);
const Color vBorderColor = Color(0xFFC0C0C0);

class UploadPhotosScreen extends ConsumerStatefulWidget {
  final String firstName, lastName, phone, email, dateOfBirth, password;

  const UploadPhotosScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.dateOfBirth,
    required this.password,
  });

  @override
  // تأكدي أن هذه هي ConsumerState وليس State فقط
  ConsumerState<UploadPhotosScreen> createState() => _UploadPhotosScreenState();
}

class _UploadPhotosScreenState extends ConsumerState<UploadPhotosScreen> {
  final ApiService _apiService = ApiService();
  File? personalImage;
  File? idImage;
  bool _isLoading = false;

  void _handleRegister() async {
    final texts = ref.read(stringsProvider);
    if (personalImage == null || idImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(texts.errorUploadBoth),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _apiService.register(
        firstName: widget.firstName,
        lastName: widget.lastName,
        phone: widget.phone,
        email: widget.email,
        password: widget.password,
        dateOfBirth: widget.dateOfBirth,
        personalImage: personalImage!,
        idImage: idImage!,
      );

      if (response != null) {
        if (!mounted) return;
        ref.invalidate(profileProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(texts.isAr ? "تم التسجيل بنجاح!" : "Registration Successful!"),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>/* AccountPendingScreen()*/   LoginPage()),
            );
          }
        });
      } else {
        _showError('Registration failed. Please try again.');
      }
    } catch (e) {
      _showError('Unexpected error occurred: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<bool> isImageValid(File imageFile) async {
    const int maxSizeBytes = 2 * 1024 * 1024;
    final String path = imageFile.path.toLowerCase();
    final bool isJpgOrPng =
        path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.png');
    final int fileSize = await imageFile.length();
    return isJpgOrPng && (fileSize <= maxSizeBytes);
  }

  Future<void> _pickImage(
    ImageSource source, {
    required bool isPersonalPhoto,
  }) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final File tempImage = File(pickedFile.path);
      if (!await isImageValid(tempImage)) {
        _showError('Image must be JPG/PNG and less than 2MB');
        return;
      }
      setState(() {
        if (isPersonalPhoto)
          personalImage = tempImage;
        else
          idImage = tempImage;
      });
    }
  }

  void showImageSourceOptions({required bool isPersonalPhoto}) {
    final theme = Theme.of(context);
    final texts = ref.read(stringsProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: theme.primaryColor),
              title: Text(
               texts.gallery,
                style: theme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(
                  ImageSource.gallery,
                  isPersonalPhoto: isPersonalPhoto,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: theme.primaryColor),
              title: Text(texts.camera, style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _pickImage(
                  ImageSource.camera,
                  isPersonalPhoto: isPersonalPhoto,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dynamicColor = isDark ? Colors.white : theme.primaryColor;
final texts = ref.watch(stringsProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
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

          Positioned.fill(
            child: SafeArea(
              child: SingleChildScrollView(

                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Center(
                  child: GlassContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          size: 60,
                          color: dynamicColor,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          texts.uploadDocuments,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: dynamicColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          texts.uploadInstruction,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 30),
                        PhotoUpload(
                          hintText: texts.personalPhoto,
                          icon: Icons.person_pin,
                          imageFile: personalImage,
                          onTap: () =>
                              showImageSourceOptions(isPersonalPhoto: true),
                          primaryColor: theme.primaryColor,
                          borderColor: isDark
                              ? Colors.white24
                              : Colors.grey.shade300,
                        ),
                        const SizedBox(height: 20),
                        PhotoUpload(
                          hintText: texts.idPhoto,
                          icon: Icons.credit_card,
                          imageFile: idImage,
                          onTap: () =>
                              showImageSourceOptions(isPersonalPhoto: false),
                          primaryColor: theme.primaryColor,
                          borderColor: isDark
                              ? Colors.white24
                              : Colors.grey.shade300,
                        ),
                        const SizedBox(height: 40),
                        _isLoading
                            ? CircularProgressIndicator(
                                color: theme.primaryColor,
                              )
                            : CustomButton(
                                textButton: texts.finishRegistration,
                                onTap: _handleRegister,
                                width: double.infinity,
                                kPrimaryColor: isDark
                                    ? Colors.white
                                    : theme.primaryColor,
                                vTextColor: isDark
                                    ? Colors.black
                                    : Colors.white,
                              ),
                      ],
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
