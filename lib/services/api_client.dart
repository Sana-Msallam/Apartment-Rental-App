import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  late Dio dio;
  static const _storage= FlutterSecureStorage(aOptions: AndroidOptions(
    encryptedSharedPreferences: true, 
  ),
);

  ApiClient(){
    dio= Dio(
      BaseOptions(
        baseUrl: 'http://10.43.150.84:8000/api/',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
        },
        ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async{
          String? token =await _storage.read(key: 'jwt_token');
          if(token != null){
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler){
          print("API Error: ${e.response?.statusCode} - ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }
}