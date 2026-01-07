import 'package:apartment_rental_app/controller/apartment_home_controller.dart';
import 'package:apartment_rental_app/models/apartment_home_model.dart';
import 'package:apartment_rental_app/services/apartment_home_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// my_apartment_controller.dart

// ... Imports ...

class OwnerApartmentsNotifier extends StateNotifier<AsyncValue<List<Apartment>>> {
  final ApartmentHomeService _service;
  final FlutterSecureStorage _storage;

  OwnerApartmentsNotifier(this._service, this._storage) : super(const AsyncValue.loading()) {
    loadOwnerApartments(); 
  }

  Future<void> loadOwnerApartments() async {
    state = const AsyncValue.loading();
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) throw Exception("User not authenticated");
      final apartments = await _service.getOwnerApartments(token);
      state = AsyncValue.data(apartments);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteApartment(int id) async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) return;
    
    final success = await _service.deleteApartment(id, token);
    if (success && state.hasValue) {
      state = AsyncValue.data(state.value!.where((a) => a.id != id).toList());
    }
  }
}

// هذا هو البروفايدر الوحيد الذي يجب أن يحمل هذا الاسم
final ownerApartmentsProvider = StateNotifierProvider.autoDispose<OwnerApartmentsNotifier, AsyncValue<List<Apartment>>>((ref) {
  final service = ref.watch(apartmentHomeServiceProvider);
  final storage = ref.watch(storageProvider);
  return OwnerApartmentsNotifier(service, storage);
});