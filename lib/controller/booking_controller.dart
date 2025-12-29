import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apartment_rental_app/services/booking_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final bookingProvider = StateNotifierProvider<BookingController, BookingState>((ref) {
  return BookingController();
});

class BookingState {
  final List<dynamic> currentBookings;
  final List<dynamic> cancelledBookings;
  final bool isLoading;

  BookingState({
    this.currentBookings = const [],
    this.cancelledBookings = const [],
    this.isLoading = false,
  });

  BookingState copyWith({
    List<dynamic>? currentBookings,
    List<dynamic>? cancelledBookings,
    bool? isLoading,
  }) {
    return BookingState(
      currentBookings: currentBookings ?? this.currentBookings,
      cancelledBookings: cancelledBookings ?? this.cancelledBookings,
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
          final Map<String, dynamic> responseData = Map<String, dynamic>.from(response);
          
          final List<dynamic> bookingsList = responseData['data'] ?? [];

          state = state.copyWith(
            currentBookings: bookingsList.where((b) => b['status'] != 'cancelled').toList(),
            cancelledBookings: bookingsList.where((b) => b['status'] == 'cancelled').toList(),
            isLoading: false,
          );
        } else {
          state = state.copyWith(isLoading: false, currentBookings: [], cancelledBookings: []);
        }
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      print("Fetch Error: $e");
      state = state.copyWith(isLoading: false);
    }
  }
  Future<bool> updateBookingDate(int bookingId, String start,String end,String token) async {
    try {
    String? token = await _storage.read(key: 'jwt_token');
    if (token == null) return false;

    bool success = await _service.updateBookingDate(bookingId, start, end, token);
    
    if (success) {
      await fetchMyBookings(); 
    }
    return success;
  } catch (e) {
    print("Update Controller Error: $e");
    return false;
  }
}

  Future<bool> cancelBooking(int bookingId) async {
    String? token = await _storage.read(key: 'jwt_token');
    if (token == null) return false;
    
    bool success = await _service.cancelBookings(bookingId, token);
    if (success) {
      await fetchMyBookings();
    }
    return success;
  }
}