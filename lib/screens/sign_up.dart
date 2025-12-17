import 'dart:io';
import 'dart:ui';
import 'package:apartment_rental_app/screens/apartment_details_screen.dart';
import 'package:apartment_rental_app/screens/log_in.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:apartment_rental_app/widgets/custom_text_filed.dart';
import 'package:apartment_rental_app/widgets/photo_upload.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:apartment_rental_app/main.dart';
import 'package:apartment_rental_app/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const Color vBorderColor = Color(0xFFC0C0C0);
const Color kPrimaryColor = Color(0xFF234F68);
const double vheight = 15;
final String vfont = 'Lato-Regular';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final ApiService _apiService = ApiService();
  final storage = const FlutterSecureStorage();
  bool _isLoading = false;
  double _uploadProgress = 0.0;

  void _updateProgress(int sent, int total) {
    if (total != 0) {
      setState(() {
        _uploadProgress = sent / total; // حساب النسبة المئوية
      });
    }
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (personalImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('please upload a profile picture.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (idImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('please upload a ID picture.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final String dateOfBirth = _dateController.text;

    setState(() => _isLoading = true); // بدء التحميل

    try {
      final response = await _apiService.register(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
        dateOfBirth: dateOfBirth,
        personalImage: personalImage!,
        idImage: idImage!,
        onProgressUpdate: _updateProgress,
      );

      if (response == null) {
        // 1. معالجة حالة فشل الاتصال (Response is null)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connection Error: Failed to reach server.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        // 2. معالجة حالة النجاح (Status 200/201)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration Successful! please LogIn'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
        // 3. معالجة أخطاء العميل/الخادم (Status 4xx)
        // هذا هو المكان الصحيح لمعالجة أخطاء مثل الهاتف مستخدم بالفعل
        String errorMessage =
            response.data['message'] ??
            'Registration failed. Please check your data.';
        if (response.data['errors'] != null &&
            response.data['errors']['phone'] != null) {
          // نأخذ أول رسالة خطأ من مصفوفة أخطاء حقل الهاتف
          errorMessage = response.data['errors']['phone'][0];
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
      // ملاحظة: الـ Status Code 302 سيقع ضمن هذا الجزء كخطأ (4xx-5xx) ما لم يتم معالجته
      // بشكل خاص، ولكن يجب حله من جهة Laravel (كما ذكرنا سابقاً).
      // يمكنك إضافة معالجة لـ 5xx هنا إذا أردت (خطأ الخادم)
      else if (response.statusCode! >= 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Server Error (500): Try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // ... معالجة الأخطاء غير المتوقعة ...
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    // مشان اختيار التاريخ من الروزنامة
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: kPrimaryColor,
            colorScheme: ColorScheme.light(primary: kPrimaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
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

  File? personalImage;
  File? idImage;

  Future<void> _pickImage(
    ImageSource source, {
    required bool isPersonalPhoto,
  }) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      final File tempImage = File(pickedFile.path);

      if (!await isImageValid(tempImage)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'he image is outside the allowed limits: JPEG/PNG format ony, maximum size 2MB',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      //. إذا كانت الصورة صالحة، نقوم بتحديث الحالة والحفظ
      setState(() {
        if (isPersonalPhoto) {
          personalImage = tempImage;
        } else {
          idImage = tempImage;
        }
      });
    }
  }

  void showImageSourceOptions({required bool isPersonalPhoto}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
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
                title: const Text('Take a Photo with Camera'),
                onTap: () {
                  Navigator.pop(context); // 👈 إغلاق الـ BottomSheet
                  _pickImage(
                    ImageSource.camera,
                    isPersonalPhoto: isPersonalPhoto,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  Future<bool> isImageValid(File imageFile) async {
    const int maxSizeBytes = 2 * 1024 * 1024; // 2 ميغابايت
    final String path = imageFile.path.toLowerCase();

    final bool isJpgOrPng =
        path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.png');

    final int fileSize = await imageFile.length();
    final bool isSizeValid = fileSize <= maxSizeBytes;

    return isJpgOrPng && isSizeValid;
  }

  @override
  Widget build(BuildContext context) {
    final Color BorderColor = _selectedDate != null
        ? kPrimaryColor
        : vBorderColor;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: vheight),
                CustomTextFiled(
                  hintText: 'First Name',
                  controller: _firstNameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'the first name is required.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: vheight),
                CustomTextFiled(
                  hintText: 'Last Name',
                  controller: _lastNameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'the last name is required.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: vheight),
                CustomTextFiled(
                  hintText: 'Phone number',
                  suffixIconWidget: Icon(Icons.phone, color: kPrimaryColor),
                  controller: _phoneController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'the phone number is required.';
                    }
                    final phoneRegExp = RegExp(r'^[0-9]+$');
                    if (!phoneRegExp.hasMatch(value)) {
                      return 'please enter numbers only in the phone number.';
                    }
                    if (value.length < 10) {
                      return 'Phone number must be at least 10 digits.'; // رسالة الخطأ
                    }
                    return null;
                  },
                ),
                SizedBox(height: vheight),
                CustomTextFiled(
                  hintText: 'Password',
                  isPassword: true,
                  controller: _passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (_) {
                    setState(() {});
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'the Password is required.';
                    }
                    if (value.length < 8) {
                      return 'password must be at least 8 characters long.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: vheight),
                //  يستخدم controller حقل كلمة المرور للقراءة مباشرة
                CustomTextFiled(
                  hintText: 'Confirm Password',
                  isPassword: true,
                  controller: _confirmPasswordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'password confirm is required';
                    }

                    // هذا السطر يقرأ القيمة المكتوبة حالياً في حقل كلمة المرور.
                    final String originalPassword = _passwordController.text;

                    final String password = originalPassword
                        .trim(); // استخدام القيمة التي تم قراءتها
                    final String confirmPassword = value.trim();
                    if (confirmPassword != password) {
                      return 'the password do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: vheight),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  textAlign: TextAlign.left,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: 'Date of Birth (DD/MM/YYYY)',
                    hintStyle: const TextStyle(color: vBorderColor),

                    suffixIcon: Icon(
                      Icons.calendar_today,
                      color: kPrimaryColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: BorderColor),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (_selectedDate == null ||
                        value == null ||
                        value.isEmpty) {
                      return 'the Date of Birth is required.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: vheight),

                PhotoUpload(
                  hintText: 'Personal Photo ',
                  icon: Icons.person_pin,
                  imageFile: personalImage,
                  onTap: () => showImageSourceOptions(isPersonalPhoto: true),
                  primaryColor: kPrimaryColor,
                  borderColor: vBorderColor,
                ),

                PhotoUpload(
                  hintText: 'ID Photo',
                  icon: Icons.credit_card,
                  imageFile: idImage,

                  onTap: () => showImageSourceOptions(isPersonalPhoto: false),
                  primaryColor: kPrimaryColor,
                  borderColor: vBorderColor,
                ),
                SizedBox(height: 20),

                SizedBox(height: 20),
                if (_isLoading &&
                    _uploadProgress > 0.0 &&
                    _uploadProgress < 1.0)
                  Column(
                    children: [
                      LinearProgressIndicator(
                        value: _uploadProgress,
                        backgroundColor: vBorderColor,
                        color: kPrimaryColor,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Uploading... ${(_uploadProgress * 100).toStringAsFixed(0)}%',
                        style: TextStyle(color: kPrimaryColor),
                      ),
                      const SizedBox(height: 15),
                    ],
                  )
                else
                  SizedBox(height: vheight),

                CustomButton(
                  textButton: _isLoading
                      ? 'Loading...'
                      : 'REGISTER', // 👈 عرض حالة التحميل
                  vTextColor: Color(0xFFFFFFFF),
                  kPrimaryColor: _isLoading
                      ? kPrimaryColor.withOpacity(0.7)
                      : kPrimaryColor,
                  width: double.infinity,
                  onPressed: _isLoading ? () {} : _handleRegister,
                ),
                SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already Have An Acount? ',
                      style: TextStyle(
                        color: Color(0xFF898989),
                        fontFamily: vfont,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginPage();
                            },
                          ),
                        );
                      },
                      child: Text(
                        'LogIn',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: vfont,
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
    );
  }
}
