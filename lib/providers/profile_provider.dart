import 'package:apartment_rental_app/models/user_model.dart';
import 'package:apartment_rental_app/services/api_client.dart';
import 'package:apartment_rental_app/services/api_service.dart';
import 'package:apartment_rental_app/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


final storageProvider = Provider((ref) => const FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
));
class ProfileNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final ProfileService _service;
  final FlutterSecureStorage _storage;

  ProfileNotifier(this._service, this._storage)
    : super(const AsyncValue.loading()) {
    fetchInitialProfile();
  }

  Future<void> fetchInitialProfile() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token != null) {
      print("Check Token: $token"); 
      await getProfile(token);
    } else {
      state = const AsyncValue.data(null); 
    }
  }

Future<void> updateTokenAndFetch(String token) async {
  state = const AsyncValue.loading(); 
  await _storage.write(key: 'jwt_token', value: token); 
  await getProfile(token); 
}


  Future<void> getProfile(String token) async {
    state = const AsyncValue.loading();
    try {
      final user = await _service.fetchUserProfile(token);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
final apiClientProvider = Provider((ref) => ApiClient());

final profileServiceProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfileService(apiClient); 
});
final apiServiceProvider = Provider<ApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiService(apiClient);
});
final profileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<UserModel?>>((ref) {
    final service = ref.watch(profileServiceProvider);
    final storage = ref.watch(storageProvider);
    return ProfileNotifier(service,storage,

      );

    });
    
