import 'package:apartment_rental_app/models/booking_request_model.dart';
import 'package:apartment_rental_app/services/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apartment_rental_app/services/booking_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BookingState {
  final List<dynamic> currentBookings;
  final List<dynamic> cancelledBookings;
  final List<dynamic> historyBookings;
  final List<BookingRequestModel> pendingRequests;
  final bool isLoading;

  BookingState({
    this.currentBookings = const [],
    this.cancelledBookings = const [],
    this.historyBookings = const [],
    this.pendingRequests= const[],
    this.isLoading = false,
  });

  BookingState copyWith({
    List<dynamic>? currentBookings,
    List<dynamic>? cancelledBookings,
    List<dynamic>? historyBookings,
    List<BookingRequestModel>? pendingRequests,
    bool? isLoading,
  }) {
    return BookingState(
      currentBookings: currentBookings ?? this.currentBookings,
      cancelledBookings: cancelledBookings ?? this.cancelledBookings,
      historyBookings: historyBookings ?? this.historyBookings, // تم الإصلاح هنا 👈
      pendingRequests: pendingRequests?? this.pendingRequests,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final storageProvider = Provider((ref) => const FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
));
class BookingController extends StateNotifier<BookingState> {
  BookingController(this._service, this._storage) : super(BookingState());

  final BookingService _service ;
final FlutterSecureStorage _storage;

  Future<void> fetchMyBookings() async {
    try {
      state = state.copyWith(isLoading: true);
      String? token = await _storage.read(key: 'jwt_token');
      print("DEBUG: Booking Token: $token");

      if (token != null) {
        final dynamic response = await _service.getMyBookings(token);

        if (response != null && response is Map) {
          final List<dynamic> bookingsList = response['data'] ?? [];
          print("RAW BOOKINGS FROM SERVER: $bookingsList"); // هذا السطر سيخبرنا بكل شيء
          state = state.copyWith(
            // 1. القائمة النشطة: pending, confirmed, accepted, active
            currentBookings: bookingsList.where((b) {
              final s = b['status'].toString().toLowerCase().trim();
              return s == 'pending' || s == 'confirmed' || s == 'accepted' || s == 'active';
            }).toList(),

            // 2. قائمة الأرشيف: تشمل الملغي من المستخدم (cancelled) والمرفوض من المؤجر (rejected) 👈
            cancelledBookings: bookingsList.where((b) {
              final s = b['status'].toString().toLowerCase().trim();
              return s == 'cancelled' || s == 'rejected';
            }).toList(),

            // 3. السجل: الحجوزات المكتملة فقط 👈
            historyBookings: bookingsList.where((b) {
              final s = b['status'].toString().toLowerCase().trim();
              return s == 'completed';
            }).toList(),
            
            isLoading: false,
          );
        } else {
          state = state.copyWith(isLoading: false);
        }
      } else {
        print("DEBUG: Token is NULL in BookingController");
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
 Future<void> fetchOwnerRequests() async{
  try{
    state =state.copyWith(isLoading: true);
    final requests = await _service.fetchAllBookingRequests();
    state =state.copyWith(pendingRequests: requests, isLoading: false);
  }catch (e){
    print("Error fetching requests: $e");
      state = state.copyWith(isLoading: false);
  }
 }
 Future<void> acceptRequest(int bookingId) async {
    try {
      _updateLocalStatus(bookingId, 'Accepted');
      await _service.acceptBooking(bookingId);
      await fetchOwnerRequests(); 
    } catch (e) {
      print("Accept Error: $e");
      await fetchOwnerRequests(); 
    }
  }

  // تابع رفض الطلب
  Future<void> rejectRequest(int bookingId) async {
    try {
      _updateLocalStatus(bookingId, 'Rejected');
      await _service.rejectBooking(bookingId);
      await fetchOwnerRequests();
    } catch (e) {
      print("Reject Error: $e");
      await fetchOwnerRequests();
    }
  }
   
  void _updateLocalStatus(int bookingId, String newStatus){
    final List<BookingRequestModel> updateList = state.pendingRequests.map((req){
      return  req.id == bookingId? req.copyWith(status: newStatus) :req;
    }).toList();
    state = state.copyWith(pendingRequests: updateList);
  }
}

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// 2. تعريف بروفايدر السيرفس
final bookingServiceProvider = Provider<BookingService>((ref) {
  final apiClient = ref.watch(apiClientProvider); 
  return BookingService(apiClient);
});

// 3. تعريف بروفايدر الكنترولر
final bookingProvider = StateNotifierProvider<BookingController, BookingState>((ref) {
  final service = ref.watch(bookingServiceProvider); 
  final storage = ref.watch(storageProvider); // نأخذ الـ storage المشفر من الـ Provider
  return BookingController(service, storage);
});
