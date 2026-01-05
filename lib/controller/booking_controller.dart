import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apartment_rental_app/services/booking_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BookingState {
  final List<dynamic> currentBookings;
  final List<dynamic> cancelledBookings;
  final List<dynamic> historyBookings;
  final bool isLoading;

  BookingState({
    this.currentBookings = const [],
    this.cancelledBookings = const [],
    this.historyBookings = const [],
    this.isLoading = false,
  });

  BookingState copyWith({
    List<dynamic>? currentBookings,
    List<dynamic>? cancelledBookings,
    List<dynamic>? historyBookings,
    bool? isLoading,
  }) {
    return BookingState(
      currentBookings: currentBookings ?? this.currentBookings,
      cancelledBookings: cancelledBookings ?? this.cancelledBookings,
      historyBookings: historyBookings ?? this.historyBookings, // تم الإصلاح هنا 👈
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class BookingController extends StateNotifier<BookingState> {
  BookingController() : super(BookingState());

  final BookingService _service = BookingService();
  final _storage = const FlutterSecureStorage();

  Future<void> fetchMyBookings() async {
    try {
      state = state.copyWith(isLoading: true);
      String? token = await _storage.read(key: 'jwt_token');

      if (token != null) {
        final dynamic response = await _service.getMyBookings(token);

        if (response != null && response is Map) {
          final List<dynamic> bookingsList = response['data'] ?? [];
state = state.copyWith(
            // 1. القائمة النشطة: pending, confirmed, accepted, active
            currentBookings: bookingsList.where((b) {
              final s = b['status'].toString().toLowerCase();
              return s == 'pending' || s == 'confirmed' || s == 'accepted' || s == 'active';
            }).toList(),

            // 2. قائمة الأرشيف: تشمل الملغي من المستخدم (cancelled) والمرفوض من المؤجر (rejected) 👈
            cancelledBookings: bookingsList.where((b) {
              final s = b['status'].toString().toLowerCase();
              return s == 'cancelled' || s == 'rejected';
            }).toList(),

            // 3. السجل: الحجوزات المكتملة فقط 👈
            historyBookings: bookingsList.where((b) {
              final s = b['status'].toString().toLowerCase();
              return s == 'completed';
            }).toList(),
            
            isLoading: false,
          );
        } else {
          state = state.copyWith(isLoading: false);
        }
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      print("Fetch Error: $e");
      state = state.copyWith(isLoading: false);
    }
  }

  // تابع الإلغاء (Cancel Booking) - تم إعادته وإصلاحه 👈
  Future<void> cancelBooking(int bookingId) async {
    try {
      String? token = await _storage.read(key: 'jwt_token');
      if (token == null) return;

      // استدعاء السيرفس (تأكدي أن الاسم في السيرفس cancelBookings)
      final bool success = await _service.cancelBookings(bookingId, token);

      if (success) {
        print("✅ Booking $bookingId cancelled successfully");
        await fetchMyBookings();
      } else {
        print(" Failed to cancel booking on server");
      }
    } catch (e) {
      print(" Error in cancelBooking: $e");
    }
  }

  Future<bool> updateBooking(int bookingId, String start, String end) async {
    try {
      String? token = await _storage.read(key: 'jwt_token');
      if (token == null) return false;

      final success = await _service.updateBookingDate(bookingId, start, end, token);
      if (success) {
        await fetchMyBookings();
        return true;
      }
      return false;
    } catch (e) {
      print("Update Error: $e");
      return false;
    }
  }
}

final bookingProvider = StateNotifierProvider<BookingController, BookingState>((ref) {
  return BookingController();
});