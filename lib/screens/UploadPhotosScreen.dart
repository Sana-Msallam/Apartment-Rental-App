import 'dart:io';
import 'dart:ui';
import 'package:apartment_rental_app/services/api_service.dart';
import 'package:apartment_rental_app/screens/log_in.dart'; // تأكدي من المسار الصحيح
import 'package:apartment_rental_app/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:apartment_rental_app/widgets/photo_upload.dart';

const Color kPrimaryColor = Color(0xFF234F68);
const Color vBorderColor = Color(0xFFC0C0C0);

class UploadPhotosScreen extends StatefulWidget {
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
  State<UploadPhotosScreen> createState() => _UploadPhotosScreenState();
}

class _UploadPhotosScreenState extends State<UploadPhotosScreen> {
  final ApiService _apiService = ApiService();
  File? personalImage;
  File? idImage;
  bool _isLoading = false;

  void _updateProgress(int sent, int total) {
    if (total != 0) {
      setState(() {});
    }
  }

  void _handleRegister() async {
    if (personalImage == null || idImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload both images!"),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration Successful!'),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        });
      } else
        _showError('Registration failed. Please try again.');
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
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: kPrimaryColor),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(
                  ImageSource.gallery,
                  isPersonalPhoto: isPersonalPhoto,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: kPrimaryColor),
              title: const Text('Take a Photo'),
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
          const Positioned.fill(
            child: Image(
              image: AssetImage('assets/images/start.png'),
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: SafeArea(
              child: Padding(
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 40,
                      ),
                     
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified_user_outlined,
                              size: 60,
                              color:
                                  kPrimaryColor,
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Upload Documents",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Please upload your photos for verification.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 44, 44, 44),
                              ),
                            ),
                            const SizedBox(height: 30),

                            PhotoUpload(
                              hintText: 'Personal Photo',
                              icon: Icons.person_pin,
                              imageFile: personalImage,
                              onTap: () =>
                                  showImageSourceOptions(isPersonalPhoto: true),
                              primaryColor: kPrimaryColor,
                              borderColor: Colors.white10,
                            ),
                            const SizedBox(height: 20),

                            PhotoUpload(
                              hintText: 'ID Photo',
                              icon: Icons.credit_card,
                              imageFile: idImage,
                              onTap: () => showImageSourceOptions(
                                isPersonalPhoto: false,
                              ),
                              primaryColor: kPrimaryColor,
                              borderColor: Colors.white10,
                            ),

                            const SizedBox(height: 40),

                            _isLoading
                                ? const CircularProgressIndicator(
                                    color:kPrimaryColor,
                                  )
                                : CustomButton(
                                    textButton: 'Finish Registration',
                                    onTap: _handleRegister,
                                    width: double.infinity,
                                    vTextColor: Colors.white,
                                    kPrimaryColor: kPrimaryColor,
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
