import 'package:apartment_rental_app/controller/booking_controller.dart';
import 'package:apartment_rental_app/models/apartment_details_model.dart';
import 'package:apartment_rental_app/services/booking_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/apartment_home_model.dart';
import '../services/apartment_home_service.dart';

final apartmentHomeServiceProvider = Provider((ref) => ApartmentHomeService());
final bookingServiceProvider = Provider((ref) => BookingService());
final storageProvider = Provider((ref) => const FlutterSecureStorage());

class ApartmentNotifier extends StateNotifier<AsyncValue<List<Apartment>>> {
  final ApartmentHomeService _service;
  final BookingService _bookingService;
  final FlutterSecureStorage _storage; 
  final Ref ref;

  ApartmentNotifier(this._service, this._bookingService, this._storage, this.ref) 
      : super(const AsyncValue.loading()) {
    loadApartments();
  }

  Future<void> loadApartments() async {
    state = const AsyncValue.loading();
    try {
      final apartments = await _service.fetchApartments();
      state = AsyncValue.data(apartments);
    } catch (e, stackTrace) {
      print(" Actual Error: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> applyFilter({
    String? governorate,
    String? city,
    double? minPrice,
    double? maxPrice,
    double? minSpace,
    double? maxSpace,
  }) async {
    state = const AsyncValue.loading();
    try {
      final filtered = await _service.fetchFilteredApartments(
        governorate: governorate,
        city: city,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minSpace: minSpace,
        maxSpace: maxSpace,
      );
      state = AsyncValue.data(filtered);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

 Future<void> addReview(int bookingId, int stars, int apartmentId) async {
  final token = await _storage.read(key: 'jwt_token');
  if (token == null) return;

  try {
    final success = await _bookingService.submitBookingReview(
      bookingId: bookingId,
      apartmentId: apartmentId,
      stars: stars,
      token: token,
    );

    if (success) {
      ref.read(bookingProvider.notifier).fetchMyBookings(); 
      loadApartments(); 
      
      print("✅ تم الإرسال، التحديث يجري في الخلفية");
    } else {
      print("❌ السيرفر رفض العملية");
    }
  } catch (e) {
    print("❌ خطأ تقني: $e");
  }
}
  
}

final apartmentProvider = StateNotifierProvider<ApartmentNotifier, AsyncValue<List<Apartment>>>((ref) {
  final service = ref.watch(apartmentHomeServiceProvider);
  final bookingService = ref.watch(bookingServiceProvider);
  final storage = ref.watch(storageProvider);  
  
  return ApartmentNotifier(service, bookingService, storage, ref);
});

final FutureProviderFamily<ApartmentDetail, int> apartmentDetailProvider = 
    FutureProvider.family<ApartmentDetail, int>((ref, id) async {
  final service = ref.read(apartmentHomeServiceProvider);
  return service.fetchApartmentDetails(id);
});