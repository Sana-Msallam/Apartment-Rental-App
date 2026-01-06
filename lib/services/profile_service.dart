import 'dart:io';
import 'package:apartment_rental_app/models/user_model.dart';
import 'package:dio/dio.dart';

class ProfileService {
  final String _baseUrl = 'http://192.168.1.102:8000/api';

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
      print("Server Raw Data: ${response.data}");    
      if (response.statusCode == 200) {
        final userData =
            response.data['user'] ?? response.data['data'] ?? response.data;
        return UserModel.fromJson(userData, token: token);
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
    return null;
  }
}
