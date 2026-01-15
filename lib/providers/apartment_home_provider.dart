import 'package:apartment_rental_app/providers/booking_provider.dart';
import 'package:apartment_rental_app/models/apartment_details_model.dart';
import 'package:apartment_rental_app/services/api_client.dart';
import 'package:apartment_rental_app/services/booking_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/apartment_home_model.dart';

import 'package:apartment_rental_app/services/booking_service.dart';
import 'package:apartment_rental_app/services/apartment_home_service.dart';
import 'package:apartment_rental_app/services/add_apartment_service.dart';
import 'my_apartment_provider.dart';
export 'package:apartment_rental_app/providers/my_apartment_provider.dart';

final apiClientProvider= Provider(( ref)=> ApiClient());
final bookingServiceProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider); 
  return BookingService(apiClient); 
});

final apartmentHomeServiceProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApartmentHomeService(apiClient); 
});

final storageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true, 
    ),
  );
});
class ApartmentNotifier extends StateNotifier<AsyncValue<List<Apartment>>> {
  final ApartmentHomeService _service;
  final BookingService _bookingService;
  final FlutterSecureStorage _storage;
  final Ref ref;

  ApartmentNotifier(this._service, this._bookingService, this._storage, this.ref)
      : super(const AsyncValue.loading());
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
  Future<void> toggleFavorite(int id) async {
    if (!state.hasValue) return;

    final currentList = state.value!;
    state = AsyncValue.data([
      for (final apt in currentList)
        if (apt.id == id) apt.copyWith(is_favorite: !apt.is_favorite) else apt
    ]);

    try {
      final success= await _service.toggleFavorite(id);
      if(!success){
          loadApartments();
      }
    } catch (e) {
      loadApartments();
    }
  }
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
      }
    } catch (e) {
      print("Review Error: $e");
    }
  }
}
final apartmentProvider = StateNotifierProvider<ApartmentNotifier, AsyncValue<List<Apartment>>>((ref) {
  final notifier = ApartmentNotifier(
    ref.watch(apartmentHomeServiceProvider),
    ref.watch(bookingServiceProvider),
    ref.watch(storageProvider),
    ref,
  );
  notifier.loadApartments(); 
  return notifier;
});

final apartmentDetailProvider = FutureProvider.family<ApartmentDetail, int>((ref, id) async {
  final service = ref.read(apartmentHomeServiceProvider);
  return service.fetchApartmentDetails(id);
});
final addApartmentServiceProvider = Provider((ref) => AddApartmentService());


final favoriteApartmentsProvider = StateNotifierProvider.autoDispose<ApartmentNotifier, AsyncValue<List<Apartment>>>((ref) {
  final service = ref.watch(apartmentHomeServiceProvider);
  final bookingService = ref.watch(bookingServiceProvider);
  final storage = ref.watch(storageProvider);
  
  final notifier = ApartmentNotifier(service, bookingService, storage, ref);
  notifier.loadFavoriteApartments(); 
  return notifier;
});
