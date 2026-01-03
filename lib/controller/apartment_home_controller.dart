import 'package:apartment_rental_app/models/apartment_details_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/apartment_home_model.dart';
import '../services/apartment_home_service.dart';
import '../services/add_apartment_service.dart';

final apartmentHomeServiceProvider =Provider((ref)=> ApartmentHomeService());
class ApartmentNotifier extends StateNotifier<AsyncValue<List<Apartment>>>{
  final ApartmentHomeService _service;
  ApartmentNotifier(this._service): super(const AsyncValue.loading()){
    loadApartments();
  }
  Future<void> loadApartments() async{
    state = const AsyncValue.loading();
    try{
      final apartments =await _service.fetchApartments();
      state = AsyncValue.data(apartments);
    }
    catch(e,stackTrace){
      state = AsyncValue.error(e,stackTrace);
    }
  }
  Future<void> applyFilter({
  String? governorate,
  String? city,
  double? minPrice,
  double? maxPrice,
  double? minSpace,
  double? maxSpace,
  }) async{
    state = const AsyncValue.loading();
    try{
      final filtered = await _service.fetchFilteredApartments(
      governorate: governorate,
      city: city,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minSpace: minSpace,
      maxSpace: maxSpace,
      );
      state = AsyncValue.data(filtered);
    } catch (e, stack){
      state =AsyncValue.error(e, stack);
    }
  }
}
final apartmentProvider =StateNotifierProvider<ApartmentNotifier,
    AsyncValue<List<Apartment>>>((ref){
      final service = ref.watch(apartmentHomeServiceProvider);
      return ApartmentNotifier(service);
});
final FutureProviderFamily<ApartmentDetail, int> apartmentDetailProvider = 
    FutureProvider.family<ApartmentDetail, int>((ref, id) async {
  
  final service = ref.read(apartmentHomeServiceProvider);
  return service.fetchApartmentDetails(id);
});
final addApartmentServiceProvider = Provider((ref) => AddApartmentService());