import 'package:apartment_rental_app/controller/booking_controller.dart';
import 'package:apartment_rental_app/models/apartment_details_model.dart';
import 'package:apartment_rental_app/services/booking_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/apartment_home_model.dart';
import '../services/apartment_home_service.dart';
import '../services/add_apartment_service.dart';

// 1. Providers الخدمات (تعريف لمرة واحدة فقط)
final apartmentHomeServiceProvider = Provider((ref) => ApartmentHomeService());
final bookingServiceProvider = Provider((ref) => BookingService());
final storageProvider = Provider((ref) => const FlutterSecureStorage());
final addApartmentServiceProvider = Provider((ref) => AddApartmentService());

// 2. كلاس Notifier الموحد (للرئيسية والمفضلة)
class ApartmentNotifier extends StateNotifier<AsyncValue<List<Apartment>>> {
  final ApartmentHomeService _service;
  final BookingService _bookingService;
  final FlutterSecureStorage _storage;
  final Ref ref;

  ApartmentNotifier(this._service, this._bookingService, this._storage, this.ref)
      : super(const AsyncValue.loading());

  // تحميل الشقق العامة
  Future<void> loadApartments() async {
    state = const AsyncValue.loading();
    try {
      final apartments = await _service.fetchApartments();
      if (!mounted) return;
      state = AsyncValue.data(apartments);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // تحميل المفضلة (تأكدي من وجود fetchFavoriteApartments في السيرفس)
  Future<void> loadFavoriteApartments() async {
    state = const AsyncValue.loading();
    try {
      final token = await _storage.read(key: 'jwt_token');
      final apartments = await _service.fetchFavorites(token ?? "");
      if (!mounted) return;
      state = AsyncValue.data(apartments);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // ميزة تبديل المفضلة (القلب)
  Future<void> toggleFavorite(int id) async {
    if (!state.hasValue) return;

    final currentList = state.value!;
    // تحديث الواجهة فوراً (Optimistic UI)
    state = AsyncValue.data([
      for (final apt in currentList)
        if (apt.id == id) apt.copyWith(is_favorite: !apt.is_favorite) else apt
    ]);

    try {
      final token = await _storage.read(key: 'jwt_token');
      await _service.toggleFavorite(id, token ?? "");
    } catch (e) {
      // في حال فشل الاتصال، نعيد تحميل القائمة لضمان دقة البيانات
      loadApartments();
    }
  }

  // الفلترة
  Future<void> applyFilter({
    String? governorate, String? city,
    double? minPrice, double? maxPrice,
    double? minSpace, double? maxSpace,
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

  // تقييم الشقة بعد الحجز
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
        loadApartments(); // تحديث القائمة الرئيسية لتظهر النجوم الجديدة
      }
    } catch (e) {
      print("Review Error: $e");
    }
  }
}

// 3. الـ Providers (الربط النهائي)

// شاشة الهوم الرئيسية
final apartmentProvider = StateNotifierProvider<ApartmentNotifier, AsyncValue<List<Apartment>>>((ref) {
  final notifier = ApartmentNotifier(
    ref.watch(apartmentHomeServiceProvider),
    ref.watch(bookingServiceProvider),
    ref.watch(storageProvider),
    ref,
  );
  notifier.loadApartments(); // يبدأ التحميل فوراً عند تشغيل الهوم
  return notifier;
});

// شاشة المفضلة
final favoriteApartmentsProvider = StateNotifierProvider.autoDispose<ApartmentNotifier, AsyncValue<List<Apartment>>>((ref) {
  final notifier = ApartmentNotifier(
    ref.watch(apartmentHomeServiceProvider),
    ref.watch(bookingServiceProvider),
    ref.watch(storageProvider),
    ref,
  );
  notifier.loadFavoriteApartments(); // يبدأ التحميل من قائمة المفضلة
  return notifier;
});

// تفاصيل شقة واحدة
final apartmentDetailProvider = FutureProvider.family<ApartmentDetail, int>((ref, id) async {
  final service = ref.read(apartmentHomeServiceProvider);
  return service.fetchApartmentDetails(id);
});