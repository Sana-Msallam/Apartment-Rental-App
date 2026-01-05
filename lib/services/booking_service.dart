import 'dart:io';
import 'package:apartment_rental_app/models/user_model.dart';
import 'package:dio/dio.dart';

class BookingService {
  final String _baseUrl = 'http://192.168.0.110:8000/api';

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Accept': 'application/json'},
      validateStatus: (status) => status! < 500,
    ),
  );

 // 1. تعديل دالة حساب السعر لتعيد إما السعر أو رسالة الخطأ
Future<dynamic> calculatePrice({
  required int apartmentId,
  required String startDate,
  required String endDate,
  required String token,
}) async {
  try {
    final response = await _dio.get(
      '$_baseUrl/booking/calculate',
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
      '$_baseUrl/booking',
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
        '$_baseUrl/booking',
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
        '$_baseUrl/booking/$bookingId/cancel',
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
        '$_baseUrl/booking/$bookingId/update',
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
        '$_baseUrl/review',
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


  Future<bool> rejectBooking(int bookingId, String token) async {
  try {
    final response = await _dio.patch(
      '$_baseUrl/booking/$bookingId/reject', 
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token.trim()}',
          'Accept': 'application/json',
        },
      ),
    );

    return response.statusCode == 200;
  } on DioException catch (e) {
    print("خطأ عند رفض الحجز: ${e.response?.data}");
    return false;
  }
}
}
