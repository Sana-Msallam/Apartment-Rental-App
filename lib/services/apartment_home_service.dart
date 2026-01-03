import 'dart:convert';

import 'package:apartment_rental_app/models/apartment_details_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/apartment_home_model.dart';
import '../services/api_client.dart';
class ApartmentHomeService{
  final ApiClient _apiClient = ApiClient();
  
  Future<List<Apartment>>fetchApartments()async{
    try{
      final response =await _apiClient.dio.get('apartment/home');
      if(response.statusCode==200){
        final List<dynamic> rawData= response.data['data'];
        print("Data from API: ${response.data}");
        return rawData.map((json)=> Apartment.fromJson(json)).toList();
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
    final response = await _apiClient.dio.get('apartment/$id');
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
    
    // تحويل القيم إلى lowercase لتطابق قاعدة بيانات السيرفر
    if (governorate != null && governorate != "All") {
      queryParams['governorate'] = governorate.toLowerCase();
    }
    if (city != null && city != 'All' && city.isNotEmpty) {
      queryParams['city'] = city.toLowerCase();
    }
    if (minPrice != null) queryParams['min_price'] = minPrice.toInt();
    if (maxPrice != null) queryParams['max_price'] = maxPrice.toInt();
    if (minSpace != null) queryParams['min_space'] = minSpace.toInt();
    if (maxSpace != null) queryParams['max_space'] = maxSpace.toInt();

    // طباعة الرابط النهائي للتأكد
    print("Final URL: ${_apiClient.dio.options.baseUrl}filter?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}");

    final response = await _apiClient.dio.get(
      'apartment/filter',
      queryParameters: queryParams,
    );
    
    print("Data from API: ${response.data}");

    if (response.statusCode == 200) {
      final rawData = response.data['data'];
      List<Apartment> apartments = [];

      // معالجة ذكية لنوع البيانات القادم من السيرفر
      if (rawData is List) {
        // إذا كان السيرفر أرسل قائمة عادية [...]
        apartments = rawData.map((e) => Apartment.fromJson(e)).toList();
      } else if (rawData is Map) {
        // إذا كان السيرفر أرسل كائن {0: {}, 1: {}}
        // نقوم باستخراج القيم (values) فقط وتحويلها لقائمة
        apartments = rawData.values.map((e) => Apartment.fromJson(e)).toList();
      }
      
      return apartments; // إرجاع القائمة النهائية للواجهة
      
    } else {
      throw Exception('Failed to filter apartments');
    }
  } on DioException catch (e) {
    print("Dio Error: ${e.response?.data ?? e.message}");
    throw Exception('Filter Error: ${e.message}');
  } catch (e) {
    print("General Error: $e");
    throw Exception('An unexpected error occurred');
  }
}
}