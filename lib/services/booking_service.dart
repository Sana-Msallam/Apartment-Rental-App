import 'dart:io';
import 'package:apartment_rental_app/models/user_model.dart';
import 'package:apartment_rental_app/services/api_client.dart';
import 'package:dio/dio.dart';
import '../models/booking_request_model.dart';

class BookingService {
  final ApiClient _apiClient;
  BookingService(this._apiClient);
  Dio get _dio => _apiClient.dio;

 

 // 1. تعديل دالة حساب السعر لتعيد إما السعر أو رسالة الخطأ
Future<dynamic> calculatePrice({
  required int apartmentId,
  required String startDate,
  required String endDate,
  required String token,
}) async {
  try {
    final response = await _dio.get(
      'booking/calculate',
      queryParameters: {
        'apartment_id': apartmentId,
        'start_date': startDate,
        'end_date': endDate,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      return response.data['data']; // يعيد السعر (double)
    } else {
      return response.data['message'] ?? "Error calculation"; 
    }
  } catch (e) {
    return "Connection Error";
  }
}

// 2. تعديل دالة التأكيد
Future<bool> confirmBooking({
  required int apartmentId,
  required String startDate,
  required String endDate,
  required String token,
}) async {
  try {
    final response = await _dio.post(
      'booking',
      data: {
        'apartment_id': apartmentId,
        'start_date': startDate,
        'end_date': endDate,
        'status': 'pending',
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      // نرمي استثناء يحتوي على رسالة Laravel
      throw response.data['message'] ?? "Booking failed";
    }
  } on DioException catch (e) {
     // إذا كان الخطأ من السيرفر (مثل 403)
     if (e.response != null) {
       throw e.response?.data['message'] ?? "Server Error";
     }
     throw "Network Error";
  }
}

  Future<dynamic> getMyBookings(String token) async {
    try {
      final response = await _dio.get(
        'http://192.168.1.105:8000/api/booking',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${token.trim()}',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print("Error fetching bookings: $e");
    }
    return null;
  }

  Future<bool> cancelBookings(int bookingId, String token) async {
    try {
      final response = await _dio.patch(
        'booking/$bookingId/cancel',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${token.trim()}',
            'Accept': 'application/json',
          },
        ),
      );

      print("Cancel Status Code: ${response.statusCode}");
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      print(
        " خطأ عند الإلغاء: ${e.response?.statusCode} - ${e.response?.data}",
      );
      return false;
    }
  }

  Future<bool> updateBookingDate(
    int bookingId,
    String start,
    String end,
    String token,
  ) async {
    try {
      final response = await _dio.patch(
        'booking/$bookingId/update',
        data: {'start_date': start, 'end_date': end},

        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print("Server Response Status: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> submitBookingReview({
    required int bookingId,
    required int apartmentId,
    required int stars,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        'review',
        data: {
          'booking_id': bookingId,
          'apartment_id': apartmentId,
          'stars': stars,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } on DioException catch (e) {
      print(" خطأ السيرفر: ${e.response?.data}");
      return false;
    }
  }

Future<List<BookingRequestModel>> fetchAllBookingRequests() async{
  try{
      final response =await _apiClient.dio.get('booking/request');
      if(response.statusCode==200){
        final List<dynamic> rawData= response.data['data'];
        print("Data from API: ${response.data}");
        return rawData.map((json)=> BookingRequestModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load apartments');
      }

    }on DioException catch(e){
      throw Exception('Failed to load apartments: ${e.message}');
    } catch (e){
      throw Exception('An unknown error occurred: $e');
    }
}
Future<void> acceptBooking(int bookingId) async{
  try{
    final response = await _apiClient.dio.patch('booking/$bookingId/accept');
    if (response.statusCode == 200) {
      print("Booking accepted successfully");
    } else {
      throw Exception('Failed to accept booking');
    }
  } on DioException catch (e) {
    throw Exception('Error: ${e.message}');
  }
  }
  
Future<void> rejectBooking(int bookingId) async{
  try{
    final response = await _apiClient.dio.patch('booking/$bookingId/reject');
    if (response.statusCode == 200) {
      print("Booking rejected successfully");
    } else {
      throw Exception('Failed to reject booking');
    }
  } on DioException catch (e) {
    throw Exception('Error: ${e.message}');
  }
    
  }
}



