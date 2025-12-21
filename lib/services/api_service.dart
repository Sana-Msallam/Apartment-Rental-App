import 'dart:io';
import 'package:dio/dio.dart';

class ApiService {
  // 💡 1. تعريف baseUrl كمتغير خاص داخل الفئة
  final String _baseUrl = 'http://10.0.2.2:8000/api';

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  Future<Response?> login(String phone, String password) async {
    try {
      // 💡 2. استخدام _dio و _baseUrl وتصحيح اسم المتغير
      Response response = await _dio.post(
        '$_baseUrl/login',
        data: {'password': password, 'phone': phone},
      );

      if (response.statusCode == 200) {
        return response;
        // هذا عادة يحتوي على التوكن (Token) ومعلومات المستخدم
      }
      return null; // نرجع null إذا كان Status Code غير 200
    } on DioException catch (e) {
      // 💡 3. تحسين معالجة أخطاء Dio
      print("Dio Error: ${e.message}");
      if (e.response != null) {
        print("Server response data: ${e.response!.data}");
        return e.response; // إرجاع الرد لمعالجته في واجهة المستخدم
      }
      return null;
    } catch (e) {
      print("General Error: $e");
      return null;
    }
  }

  Future<Response?> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String dateOfBirth,
    required File personalImage,
    required File idImage,
    required Function(int sent, int total) onProgressUpdate,
  }) async {
    try {
      // إعداد بيانات الصور كـ MultipartFile
      String personalFileName = personalImage.path.split('/').last;
      String idFileName = idImage.path.split('/').last;

      // تجميع كل البيانات في FormData
      FormData formData = FormData.fromMap({
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'password': password,
        'date_of_birth': dateOfBirth,
        // يتم إرسال الملفات باستخدام MultipartFile
        'personal_photo': await MultipartFile.fromFile(
          personalImage.path,
          filename: personalFileName,
        ),
        'ID_photo': await MultipartFile.fromFile(
          idImage.path,
          filename: idFileName,
        ),
      });

      // إرسال الطلب POST (💡 استخدام _dio و _baseUrl وتصحيح اسم المتغير)
      Response response = await _dio.post(
        '$_baseUrl/signUp',
        data: formData,
        onSendProgress: onProgressUpdate,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response; // إذا نجح التسجيل (عادة 200 أو 201)
      }
      return null;
    } on DioException catch (e) {
      print("Dio Error during registration: ${e.message}");
      // إذا كان الخطأ هو خطأ من السيرفر (مثل رقم الهاتف موجود بالفعل)
      if (e.response != null) {
        print("Server response data: ${e.response!.data}");
        return e.response; // إرجاع الرد لمعالجته في RegisterPage
      }
      return null;
    } catch (e) {
      print("General Error during registration: $e");
      return null;
    }
  }
}
