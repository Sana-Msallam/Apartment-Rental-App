import 'package:apartment_rental_app/controller/booking_controller.dart';
import 'package:apartment_rental_app/models/apartment_details_model.dart';
import 'package:apartment_rental_app/services/booking_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/apartment_home_model.dart';
import '../services/apartment_home_service.dart';
import '../services/add_apartment_service.dart';

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

// جلب شقق المالك فقط
  Future<void> loadOwnerApartments() async {
    state = const AsyncValue.loading();
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) throw Exception("User not authenticated");

      // تأكد من إضافة هذه الدالة في ApartmentHomeService
      final ownerApartments = await _service.getOwnerApartments(token); 
      state = AsyncValue.data(ownerApartments);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
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
// أضيفي هذه الدالة داخل كلاس ApartmentNotifier
Future<void> toggleFavoriteStatus(int apartmentId) async {
  try {
    // 1. استدعاء الخدمة لتغيير الحالة في السيرفر
    final success = await _service.toggleFavorite(apartmentId);

    if (success && state.hasValue) {
      // 2. تحديث الحالة محلياً (Local State Update) لكي يشعر المستخدم بالسرعة
      final currentApartments = state.asData!.value;
      
      final updatedList = currentApartments.map((apt) {
        if (apt.id == apartmentId) {
          return Apartment(
            id: apt.id,
            price: apt.price,
            governorate: apt.governorate,
            city: apt.city,
            space: apt.space,
            imagePath: apt.imagePath,
            averageRating: apt.averageRating,
            is_favorite: !(apt.is_favorite), 
          );
        }
        return apt;
      }).toList();

      state = AsyncValue.data(updatedList);
    }
  } catch (e) {
    print("Error toggling favorite in Notifier: $e");
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
final addApartmentServiceProvider = Provider((ref) => AddApartmentService());
// Provider مخصص لشقق المالك فقط
final ownerApartmentsProvider = StateNotifierProvider<ApartmentNotifier, AsyncValue<List<Apartment>>>((ref) {
  final service = ref.watch(apartmentHomeServiceProvider);
  final bookingService = ref.watch(bookingServiceProvider);
  final storage = ref.watch(storageProvider);
  
  final notifier = ApartmentNotifier(service, bookingService, storage, ref);
  
  // استدعاء دالة جلب شقق المالك فور تشغيل الـ Provider
  notifier.loadOwnerApartments(); 
  
  return notifier;
});