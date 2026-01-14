import 'package:apartment_rental_app/models/booking_request_model.dart';
import 'package:apartment_rental_app/services/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apartment_rental_app/services/booking_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BookingState {
  final List<BookingRequestModel> currentBookings;
  final List<BookingRequestModel> cancelledBookings;
  final List<BookingRequestModel> historyBookings;
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
    List<BookingRequestModel>? currentBookings,
    List<BookingRequestModel>? cancelledBookings,
    List<BookingRequestModel>? historyBookings,
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

      if (token != null) {
        final dynamic response = await _service.getMyBookings(token);

        if (response != null && response is Map) {
          final List<dynamic> bookingsList = response['data'] ?? [];
          
          // تحويل القائمة الخام إلى قائمة موديلات (Objects)
          final List<BookingRequestModel> allBookings = bookingsList
            .map((json) => BookingRequestModel.fromJson(json))
            .toList();

          state = state.copyWith(
            // ✅ نستخدم allBookings الآن بدلاً من bookingsList
            currentBookings: allBookings.where((b) {
              final s = b.status.toLowerCase().trim();
              return s == 'pending' || s == 'confirmed' || s == 'accepted' || s == 'active';
            }).toList(),

            cancelledBookings: allBookings.where((b) {
              final s = b.status.toLowerCase().trim();
              return s == 'cancelled' || s == 'rejected';
            }).toList(),

            historyBookings: allBookings.where((b) {
              final s = b.status.toLowerCase().trim();
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
  Future<void> cancelBooking(int bookingId) async {
    try {
      String? token = await _storage.read(key: 'jwt_token');
      if (token == null) return;

      // نفترض أن السيرفس لديه دالة تسمى cancelBooking
      final success = await _service.cancelBookings(bookingId, token);
      if (success) {
        await fetchMyBookings(); // تحديث القائمة بعد الإلغاء
      }
    } catch (e) {
      print("Cancel Error: $e");
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
