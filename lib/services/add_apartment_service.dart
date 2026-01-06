import 'dart:io';
import 'package:apartment_rental_app/services/api_client.dart';
import 'package:dio/dio.dart';

class AddApartmentService {
  final ApiClient _apiClient =ApiClient();
  Future<bool> addApartment({
    required Map<String, dynamic> data,
    required List<File> images,
  }) async {
    try{
      FormData formData= FormData.fromMap({
        ...data,
        "images[]": images.map((image)=>MultipartFile.fromFileSync(
          image.path, filename: image.path.split('/').last)).toList(),

       });
      final response = await _apiClient.dio.post(
        'apartment', 
        data: formData,
      );

      return response.statusCode == 201;
    }on DioException catch (e) {
  print("Server Validation Error: ${e.response?.data}"); 
  return false;
}
     catch (e) {
      return false;
    }
  }
}