import 'package:apartment_rental_app/constants/app_constants.dart';
import 'package:apartment_rental_app/constants/app_string.dart';
import 'package:apartment_rental_app/providers/apartment_home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';



class FilterModel extends ConsumerStatefulWidget {
  const FilterModel({super.key});

  @override
  ConsumerState<FilterModel> createState() => _FilterModelState();
} 

class _FilterModelState extends ConsumerState<FilterModel> {
  String _selectedGovernorate = 'All';
  String _selectedCity = 'All';
  RangeValues _priceRange = const RangeValues(1000, 50000);
  RangeValues _spaceRange = const RangeValues(50, 500);

  final List<String> _governorates = [
    'All', 'Damascus', 'Aleppo', 'Homs', 'Hama', 'Draa', 'Latakia', 'Tartous', 'Suwayda', 'Deir ez-Zor', 'Idlib', 'Raqqa'
  ];

  @override
  Widget build(BuildContext context) {
    final texts = ref.watch(stringsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;


    List<String> govList = [texts.all, ...texts.citiesByGovernorate.keys];

    List<String> cityList = [texts.all];
    if (_selectedGovernorate != texts.all) {
      cityList.addAll(texts.citiesByGovernorate[_selectedGovernorate] ?? []);
    }

    if (!govList.contains(_selectedGovernorate)) _selectedGovernorate = texts.all;
    if (!cityList.contains(_selectedCity)) _selectedCity = texts.all;



    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : AppConstants.secondColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              texts.isAr ? "فلترة" : "Filter",
              style: AppConstants.titleText.copyWith(
                color: isDark ? Colors.white : AppConstants.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            
            _buildSectionTitle(texts.governorate, isDark),
            const SizedBox(height: 10),
            _buildGovernorateDropdown(isDark, govList, texts),

            const SizedBox(height: 20),
            _buildSectionTitle(texts.city, isDark),
            const SizedBox(height: 10),
            _buildCityDropdown(isDark, cityList, texts), 

            const SizedBox(height: 20),
            _buildSectionTitle(texts.priceRange, isDark),
            const SizedBox(height: 10),
            _buildPriceRangeSlider(isDark),

            const SizedBox(height: 20),
            _buildSectionTitle(texts.spaceRange, isDark),
            const SizedBox(height: 10),
            _buildSpaceRangeSlider(isDark),
            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(


                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(apartmentProvider.notifier).loadApartments();
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: BorderSide(
                        color: isDark ? Colors.white38 : AppConstants.primaryColor
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      texts.isAr ? "إعادة تعيين" : "Reset", 
                      style: AppConstants.secondText.copyWith(
                        color: isDark ? Colors.white70 : AppConstants.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final String? finalGov = _selectedGovernorate == texts.all ? null : texts.getEnglishValue(_selectedGovernorate);
                      final String? finalCity = _selectedCity == texts.all ? null : texts.getEnglishValue(_selectedCity);
                      
                      ref.read(apartmentProvider.notifier).applyFilter(
                        governorate: finalGov,
                        city: finalCity,
                        minPrice: _priceRange.start,
                        maxPrice: _priceRange.end,
                        minSpace: _spaceRange.start,
                        maxSpace: _spaceRange.end,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      texts.isAr ? "تطبيق" : "Apply",
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: AppConstants.secondText.copyWith(
        color: isDark ? Colors.white70 : Colors.black87,
      ),
    );
  }
  InputDecoration _inputDecoration(bool isDark) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: isDark ? Colors.white24 : AppConstants.secondColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: isDark ? Colors.white24 : AppConstants.secondColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    );
  }

  Widget _buildGovernorateDropdown(bool isDark, List<String> list, AppStrings texts) {
    return DropdownButtonFormField<String>(
      value: _selectedGovernorate,
      dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: _inputDecoration(isDark),
      items: list.map((gov) => DropdownMenuItem(value: gov, child: Text(gov))).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedGovernorate = newValue!;
          _selectedCity = texts.all;
        });
      },
    );
  }

  Widget _buildCityDropdown(bool isDark, List<String> list, AppStrings texts) {
    return DropdownButtonFormField<String>(
      value: _selectedCity,
      dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: _inputDecoration(isDark),
      items: list.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
      onChanged: (newValue) => setState(() => _selectedCity = newValue!),
    );
  }

  Widget _buildPriceRangeSlider(bool isDark) {
    return RangeSlider(
      values: _priceRange,
      min: 1000,
      max: 50000,
      divisions: 49,
      activeColor: AppConstants.primaryColor,
      inactiveColor: AppConstants.secondColor,
      labels: RangeLabels(
        _priceRange.start.toStringAsFixed(0),
        _priceRange.end.toStringAsFixed(0),
      ),
      onChanged: (RangeValues values) {
        setState(() {
          _priceRange = values;
        });
      },
    );
  }

  Widget _buildSpaceRangeSlider(bool isDark) {
    return RangeSlider(
      values: _spaceRange, 
      min: 50,
      max: 500,
      divisions: 15,
      activeColor: AppConstants.primaryColor,
      inactiveColor: AppConstants.secondColor,
      labels: RangeLabels(
        '${_spaceRange.start.round()}',
        '${_spaceRange.end.round()}',
      ),


      onChanged: (RangeValues values) {
        setState(() {
          _spaceRange = values;
        });
      },
    );
  }
}