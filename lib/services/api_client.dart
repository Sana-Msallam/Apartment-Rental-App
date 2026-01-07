import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  late Dio dio;
  static const _storage= FlutterSecureStorage(aOptions: AndroidOptions(
    encryptedSharedPreferences: true, // تفعيل التشفير المتوافق مع أندرويد الحديث
  ),
);

  ApiClient(){
    dio= Dio(
      BaseOptions(
        baseUrl: 'http://192.168.0.105:8000/api/',
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