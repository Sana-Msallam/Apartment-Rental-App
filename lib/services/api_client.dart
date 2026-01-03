import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  late Dio dio;
  static const _storage= FlutterSecureStorage();

  ApiClient(){
    dio= Dio(
      BaseOptions(
        baseUrl: 'http://192.168.1.105:8000/api/',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
        },
        ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, hanler) async{
          print("🚀 Sending Request to: ${options.path}"); // أضيفي هذا السطر
          String? token =await _storage.read(key: 'jwt_token');
          if(token != null){
            options.headers['Authorization'] = 'Bearer $token';
          }
          return hanler.next(options);
        },
        onError: (DioException e, handler){
          print("API Error: ${e.response?.statusCode} - ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }
}