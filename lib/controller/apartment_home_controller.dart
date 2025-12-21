import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/apartment_home_model.dart';
import '../services/apartment_home_service.dart';

final apartmentHomeServiceProvider =Provider((ref)=> ApartmentHomeService.create());
class ApartmentNotifier extends StateNotifier<AsyncValue<List<Apartment>>>{
  final ApartmentHomeService _service;
  ApartmentNotifier(this._service): super(const AsyncValue.loading()){
    _loadApartments();
  }
  Future<void> _loadApartments() async{
    state = const AsyncValue.loading();
    try{
      final apartments =await _service.fetchApartments();
      state = AsyncValue.data(apartments);
    }
    catch(e,stackTrace){
      state = AsyncValue.error(e,stackTrace);
    }
  }
}
final apartmentProvider =StateNotifierProvider<ApartmentNotifier,
    AsyncValue<List<Apartment>>>((ref){
      final service = ref.watch(apartmentHomeServiceProvider);
      return ApartmentNotifier(service);
});