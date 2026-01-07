import 'dart:io';
import 'package:apartment_rental_app/models/user_model.dart';
import 'package:dio/dio.dart';

class ProfileService {
  final String _baseUrl = 'http://192.168.0.112:8000/api';

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Accept': 'application/json'},
    //  validateStatus: (status) => status! < 500,
    ),
  );

  void _handleDioError(DioException e) {
    print("Server Response Error: ${e.response?.data}");
    if (e.response != null) {
      print("Error:${e.response?.data}");
    } else {
      print(" ${e.message}");
    }
    return null;
  }
Future<UserModel?> fetchUserProfile(String token) async {
  try {
    final response = await _dio.get(
      '$_baseUrl/profile',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      // التأكد من استخراج البيانات حسب هيكلة Laravel (data أو user)
      final userData = response.data['data'] ?? response.data['user'] ?? response.data;
      return UserModel.fromJson(userData, token: token);
    }
    return null;
  } on DioException catch (e) {
    // لا ترجعي null هنا، بل ارمي الخطأ لكي يظهر في الـ UI
    throw e.response?.data['message'] ?? "حدث خطأ في الاتصال بالسيرفر";
  }
}
}
