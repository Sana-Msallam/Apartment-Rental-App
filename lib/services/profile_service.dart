import 'dart:io';
import 'package:apartment_rental_app/models/user_model.dart';
import 'package:apartment_rental_app/services/api_client.dart';
import 'package:dio/dio.dart';

class ProfileService {
final ApiClient _apiClient;
ProfileService(this._apiClient);
  Dio get _dio => _apiClient.dio;

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
        'profile',
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
