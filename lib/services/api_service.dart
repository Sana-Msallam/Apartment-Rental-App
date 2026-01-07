import 'dart:io';
import 'package:apartment_rental_app/models/user_model.dart';
import 'package:apartment_rental_app/services/push_notifications_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // ✅ التغيير لـ SecureStorage

class ApiService {
  final String _baseUrl = 'http://192.168.0.112:8000/api';
  
  // تعريف التخزين الآمن
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Accept': 'application/json'},
      validateStatus: (status) => status! < 500,
    ),
  );

  // ✅ تعديل دالة الحفظ لتستخدم SecureStorage واسم jwt_token
  Future<void> _saveToken(String? token) async {
    if (token != null) {
      await _storage.write(key: 'jwt_token', value: token);
      print("✅ Token saved successfully to SecureStorage: $token");
      print("✅ تم حفظ التوكن بنجاح: $token");
  } else {
    print("⚠️ التوكن قيمته null، لم يتم الحفظ!");
  
    }
  }

  // ✅ تعديل دالة المسح لتستخدم SecureStorage
  Future<void> _clearToken() async {
    await _storage.delete(key: 'jwt_token');
    print("🗑️ Token removed from SecureStorage");
  }

  // --- تسجيل الدخول ---
  Future<UserModel?> login(String phone, String password) async {
    try {
      String? fcmToken = await PushNotificationsService.getDeviceToken();
      
      final response = await _dio.post(
        '$_baseUrl/login',
        data: {
          'phone': phone,
          'password': password,
          'fcm_token': fcmToken ?? "",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        final userData = responseData['user'] ?? responseData['data'] ?? responseData;
        final String? token = responseData['token'] ?? userData['token'];

        // حفظ التوكن في المخزن الآمن
        await _saveToken(token);

        return UserModel.fromJson(userData, token: token);
      } else {
        print("❌ Login Failed: ${response.data}");
        return null;
      }
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      print("Unexpected Error during login: $e");
      return null;
    }
  }

  // --- إنشاء حساب جديد ---
  Future<UserModel?> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String dateOfBirth,
    required File personalImage,
    required File idImage,
    required String email,
  }) async {
    try {
      String? fcmToken = await PushNotificationsService.getDeviceToken();

      FormData formData = FormData.fromMap({
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'password': password,
        'date_of_birth': dateOfBirth,
        'email': email,
        'fcm_token': fcmToken ?? "",
        'personal_photo': await MultipartFile.fromFile(personalImage.path),
        'ID_photo': await MultipartFile.fromFile(idImage.path),
      });

      Response response = await _dio.post(
        '$_baseUrl/signUp',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        final userData = responseData['user'] ?? responseData['data'] ?? responseData;
        final String? token = responseData['token'] ?? userData?['token'];

        // حفظ التوكن في المخزن الآمن
        await _saveToken(token);

        return UserModel.fromJson(userData, token: token);
      } else {
        print("❌ Register Failed: ${response.data}");
        return null;
      }
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      print("Unexpected Error during registration: $e");
      return null;
    }
  }

  // --- تسجيل الخروج ---
  Future<bool> logout(String token) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print("✅ Logout successful from Backend");
        // مسح التوكن من المخزن الآمن
        await _clearToken();
        return true;
      }
      return false;
    } on DioException catch (e) {
      print("Logout Error: ${e.response?.data}");
      return false;
    } catch (e) {
      print("Logout Unexpected Error: $e");
      return false;
    }
  }

  void _handleDioError(DioException e) {
    if (e.response != null) {
      print("Server Response Error: ${e.response?.data}");
    } else {
      print("Connection Error: ${e.message}");
    }
  }
}