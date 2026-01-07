import 'package:apartment_rental_app/controller/booking_controller.dart';
import 'package:apartment_rental_app/models/apartment_details_model.dart';
import 'package:apartment_rental_app/services/api_client.dart';
import 'package:apartment_rental_app/services/booking_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/apartment_home_model.dart';
import '../services/apartment_home_service.dart';
import '../services/add_apartment_service.dart';

final apiClientProvider= Provider(( ref)=> ApiClient());
final bookingServiceProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider); // جلب الـ apiClient أولاً
  return BookingService(apiClient); // تمريره للسيرفس
});

// تأكدي أيضاً من تحديث ApartmentHomeService إذا كان يعتمد على ApiClient
final apartmentHomeServiceProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApartmentHomeService(apiClient); 
});

final storageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true, // هنا نضعها لتوحيد القراءة والكتابة
    ),
  );
});
class ApartmentNotifier extends StateNotifier<AsyncValue<List<Apartment>>> {
  final ApartmentHomeService _service;
  final BookingService _bookingService;
  final FlutterSecureStorage _storage; 
  final Ref ref;

  ApartmentNotifier(
    this._service,
    this._bookingService, 
    this._storage, this.ref) 
    : super(const AsyncValue.loading()) {
  }

  Future<void> loadApartments() async {

    state = const AsyncValue.loading();
    try {
      final apartments = await _service.fetchApartments();
      if (!mounted) return;
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
      final ownerApartments = await _service.getOwnerApartments(); 
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
Future<void> toggleFavoriteStatus(int apartmentId) async {
  try {
    final success = await _service.toggleFavorite(apartmentId);

    if (success) {
      // 1. تحديث قائمة الهوم
      if (state.hasValue) {
        final currentApartments = state.asData!.value;
        if (!mounted) return;
        state = AsyncValue.data(
          currentApartments.map((apt) {
            if (apt.id == apartmentId) {
              return apt.copyWith(is_favorite: !(apt.is_favorite ?? false));
            }
            return apt;
          }).toList(),
        );
      }
      // 2. إجبار واجهة المفضلة على إعادة جلب البيانات من السيرفر لتكون محدثة
      ref.invalidate(favoriteApartmentsProvider);
    }
  } catch (e) {
    print("Error toggling favorite: $e");
  }
}
Future<void> loadFavoriteApartments() async {
  state = const AsyncValue.loading();
  try {
    final favorites = await _service.fetchFavorites();
    state = AsyncValue.data(favorites);
  } catch (e, stackTrace) {
    print("Error loading favorites: $e");
    if (!mounted) return;
    state = AsyncValue.error(e, stackTrace);
  }
}
}

final apartmentProvider = StateNotifierProvider<ApartmentNotifier, AsyncValue<List<Apartment>>>((ref) {
  final service = ref.watch(apartmentHomeServiceProvider);
  final bookingService = ref.watch(bookingServiceProvider);
  final storage = ref.watch(storageProvider);  
  final notifier = ApartmentNotifier(service, bookingService, storage, ref);
  notifier.loadApartments(); // استدعاء الجلب هنا فقط للهوم
  return notifier;
});

final FutureProviderFamily<ApartmentDetail, int> apartmentDetailProvider = 
    FutureProvider.family<ApartmentDetail, int>((ref, id) async {
  final service = ref.read(apartmentHomeServiceProvider);
  return service.fetchApartmentDetails(id);
});
final addApartmentServiceProvider = Provider((ref) => AddApartmentService());
final ownerApartmentsProvider = StateNotifierProvider<ApartmentNotifier, AsyncValue<List<Apartment>>>((ref) {
  final service = ref.watch(apartmentHomeServiceProvider);
  final bookingService = ref.watch(bookingServiceProvider);
  final storage = ref.watch(storageProvider);
  
  final notifier = ApartmentNotifier(service, bookingService, storage, ref);
  notifier.loadOwnerApartments(); 
  return notifier;
});

final favoriteApartmentsProvider = StateNotifierProvider.autoDispose<ApartmentNotifier, AsyncValue<List<Apartment>>>((ref) {
  final service = ref.watch(apartmentHomeServiceProvider);
  final bookingService = ref.watch(bookingServiceProvider);
  final storage = ref.watch(storageProvider);
  
  final notifier = ApartmentNotifier(service, bookingService, storage, ref);
  notifier.loadFavoriteApartments(); 
  return notifier;
});
