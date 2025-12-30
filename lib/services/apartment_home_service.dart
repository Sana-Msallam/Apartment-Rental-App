import 'dart:convert';

import 'package:apartment_rental_app/models/apartment_details_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/apartment_home_model.dart';

class ApartmentHomeService{
  final Dio _dio;
  static const _storage = FlutterSecureStorage();
  ApartmentHomeService(this._dio);
  factory ApartmentHomeService.create(){
    final dio=Dio();
    dio.options.baseUrl= 'http://192.168.0.126:8000/api';

    dio.options.connectTimeout=const Duration(seconds: 10);
    dio.options.receiveTimeout= const Duration(seconds: 10);
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options,handler) async{
         String? _token =await _storage.read(key: 'jwt_token');

         if (_token != null) {
           options.headers['Authorization'] = 'Bearer $_token';
         }
        options.headers['Accept']= 'application/json';

        return handler.next(options);
      },
      onError: (DioException e, handler){
        return handler.next(e);
      },
    ));

    return ApartmentHomeService(dio);
  }
  Future<List<Apartment>>fetchApartments()async{
    try{
      final response =await _dio.get('home');
      if(response.statusCode==200){
        final List<dynamic> rawData= response.data['data'];
        print("Data from API: ${response.data}");
        return rawData.map((json)=> Apartment.fromJson(json)).toList();
      //   if(rawData is List){
      //   return rawData.map((json)=> Apartment.fromJson(json)).toList();
      //   }
      //   else if (rawData is Map) {
      //   return rawData.values.map((json) => Apartment.fromJson(json)).toList();
      // }
      // return [];
      } else {
        throw Exception('Failed to load apartments');
      }

    }on DioException catch(e){
      throw Exception('Failed to load apartments: ${e.message}');
    } catch (e){
      throw Exception('An unknown error occurred: $e');
    }
  }
Future<ApartmentDetail> fetchApartmentDetails(int id) async {
  try {
    final response = await _dio.get('$id');
     print("Data from API: ${response.data}");
     
    if (response.data['data']!=null ) {
     
      return ApartmentDetail.fromJson(response.data['data']);
    } else {
      throw Exception("Failed to load apartment details");
    }
  }on DioException catch (e) {
    print("Dio Error: ${e.response?.data}");
    throw Exception("Network Error: ${e.message}");
  }
   catch (e) {
    throw Exception(" Error connecting to the server: $e");
  }
}
Future<List<Apartment>> fetchFilteredApartments({
  String? governorate,
  String? city,
  double? minPrice,
  double? maxPrice,
  double? minSpace,
  double? maxSpace,
}) async {
  try {
    final Map<String, dynamic> queryParams = {};
    if (governorate != null && governorate != "All") queryParams['governorate'] = governorate.toLowerCase(); 
    if (city != null && city != 'All'&& city.isNotEmpty) queryParams['city'] = city.toLowerCase(); 
    if (minPrice != null) queryParams['min_price'] = minPrice.toInt();
    if (maxPrice != null) queryParams['max_price'] = maxPrice.toInt();
    if (minSpace != null) queryParams['min_space'] = minSpace.toInt();
    if (maxSpace != null) queryParams['max_space'] = maxSpace.toInt();

   // print("Final URL: ${_dio.options.baseUrl}filter?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}");

    final response = await _dio.get('filter', queryParameters: queryParams);
     print("Data from API: ${response.data}");
    
    if (response.statusCode == 200) {
      final List<dynamic> rawData = response.data['data'];
      return rawData.map((json) => Apartment.fromJson(json)).toList();
      // if (rawData is Map) {
      //   return rawData.values.map((json) => Apartment.fromJson(json)).toList();
      // } 
    //  if (rawData is List) {
    //     return rawData.map((json) => Apartment.fromJson(json)).toList();
    //   }
    //   return [];
    } else {
      throw Exception('Failed to filter apartments');
    }
  } on DioException catch (e) {
    throw Exception('Filter Error: ${e.message}');
  }
}
}