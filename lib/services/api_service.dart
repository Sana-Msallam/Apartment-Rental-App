import 'dart:io';
import 'package:apartment_rental_app/models/user_model.dart';
import 'package:dio/dio.dart';

class ApiService {
  final String _baseUrl = 'http://192.168.0.126:8000/api';

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Accept': 'application/json'},
      validateStatus: (status) => status! < 500,
    ),
  );

  Future<UserModel?> login(String phone, String password) async {
    try {
      print(' try to login$_baseUrl/login');

      final response = await _dio.post(
        '$_baseUrl/login',
        data: {'phone': phone, 'password': password},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        print('response data =  $responseData');

        final userData =
            responseData['user'] ?? responseData['data'] ?? responseData;

        final String? token = responseData['token'] ?? userData['token'];
        print(' code ${response.statusCode}');
        return UserModel.fromJson(userData, token: token);
      }
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      print(' Error $e');
      return null;
    }
  }

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
      FormData formData = FormData.fromMap({
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'password': password,
        'date_of_birth': dateOfBirth,
        'personal_photo': await MultipartFile.fromFile(
          personalImage.path,
          filename: personalImage.path.split('/').last,
        ),
        'ID_photo': await MultipartFile.fromFile(
          idImage.path,
          filename: idImage.path.split('/').last,
        ),
        'email': email,
      });

      Response response = await _dio.post(
        '$_baseUrl/signUp',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      print(' ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData =
            response.data['user'] ?? response.data['data'] ?? response.data;
        final String? token = response.data['token'] ?? userData?['token'];
        return UserModel.fromJson(userData, token: token);
      } else if (response.statusCode == 422) {
        print("422: ${response.data}");
      }
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      print(" Error $e");
      return null;
    }
    return null;
  }

  void _handleDioError(DioException e) {
    print("Server Response Error: ${e.response?.data}");
    if (e.response != null) {
      print("Error:${e.response?.data}");
    } else {
      print(" ${e.message}");
    }
    return null;
  }
}
