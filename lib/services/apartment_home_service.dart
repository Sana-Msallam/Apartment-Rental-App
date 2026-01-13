import 'dart:convert';
import 'package:apartment_rental_app/models/apartment_details_model.dart';
import 'package:apartment_rental_app/models/notification_model.dart';
import 'package:dio/dio.dart';
import '../models/apartment_home_model.dart';
import '../services/api_client.dart';
class ApartmentHomeService{
  final ApiClient _apiClient ;
  ApartmentHomeService(this._apiClient);
  
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
    } on DioException catch (e) {
      throw Exception('Failed to load apartments: ${e.message}');
    }
  }

  // 2. جلب تفاصيل شقة
  Future<ApartmentDetail> fetchApartmentDetails(int id) async {
    try {
      final response = await _apiClient.dio.get('apartment/$id');
      if (response.data['data'] != null) {
        return ApartmentDetail.fromJson(response.data['data']);
      } else {
        throw Exception("Failed to load apartment details");
      }
    } catch (e) {
      throw Exception("Error connecting to server: $e");
    }
  }

  // 3. الفلترة
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
      if (city != null && city != 'All' && city.isNotEmpty) queryParams['city'] = city.toLowerCase();
      if (minPrice != null) queryParams['min_price'] = minPrice.toInt();
      if (maxPrice != null) queryParams['max_price'] = maxPrice.toInt();
      if (minSpace != null) queryParams['min_space'] = minSpace.toInt();
      if (maxSpace != null) queryParams['max_space'] = maxSpace.toInt();

      final response = await _apiClient.dio.get('apartment/filter', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        final rawData = response.data['data'];
        if (rawData is List) {
          return rawData.map((e) => Apartment.fromJson(e)).toList();
        } else if (rawData is Map) {
          return rawData.values.map((e) => Apartment.fromJson(e)).toList();
        }
        return [];
      } else {
        throw Exception('Failed to filter apartments');
      }
    } catch (e) {
      throw Exception('Filter Error: $e');
    }
  }

  // 4. حذف شقة (للمالك)
  Future<bool> deleteApartment(int id, String token) async {
    try {
      final response = await _apiClient.dio.delete(
        'apartment/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 5. شقق المالك
  Future<List<Apartment>> getOwnerApartments(String token) async {
    try {
      final response = await _apiClient.dio.get(
        'apartment/owner',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final List<dynamic> rawData = response.data['data'];
        return rawData.map((json) => Apartment.fromJson(json)).toList();
      }
      throw Exception('Failed');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // 6. تبديل المفضلة (إضافة/إزالة)
  Future<bool> toggleFavorite(int apartmentId) async {
    try {
      final response = await _apiClient.dio.post(
        'favorite',
        data: {'apartment_id': apartmentId},
        
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Toggle Favorite Error: $e");
      return false;
    }
  }

  // 7. جلب قائمة المفضلة
  Future<List<Apartment>> fetchFavorites(String token) async {
    try {
      final response = await _apiClient.dio.get(
        'favorite',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final List<dynamic> rawData = response.data['data'];
        return rawData.map((json) => Apartment.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load favorites');
    }
  }
 
}