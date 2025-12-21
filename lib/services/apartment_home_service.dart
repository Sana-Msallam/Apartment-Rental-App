import 'dart:convert';

import 'package:dio/dio.dart';
import '../models/apartment_home_model.dart';

class ApartmentHomeService{
  final Dio _dio;
  ApartmentHomeService(this._dio);
  factory ApartmentHomeService.create(){
    final dio=Dio();
    dio.options.baseUrl='http://10.0.2.2:8000/api/';
    dio.options.connectTimeout=const Duration(seconds: 10);
    dio.options.receiveTimeout= const Duration(seconds: 10);
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options,handler){
        const String? _token ="2|0NNR4pikq3TqvX311PdgHtly3PsqCI4TFaDiKyoA026551c9";
        options.headers['Authorization']='Bearer $_token';
        options.headers['Accept']= 'application/json';
        print('Sending request with TOken...');
        return handler.next(options);
      },
      onError: (DioException e, handler){
        return handler.next(e);
      },
    ));
    
    return ApartmentHomeService(dio);
  }
  Future<List<Apartment>>fetchApartments()async{
    try{
      final response =await _dio.get('apartment/home');
      if(response.statusCode==200){
        List<dynamic> data= response.data['data'];
        print("Data from API: ${response.data}");
        return data.map((json)=> Apartment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load apartments');
      }

    }on DioException catch(e){
      throw Exception('Failed to load apartments: ${e.message}');
    } catch (e){
      throw Exception('An unknown error occurred: $e');
    }
  }
}