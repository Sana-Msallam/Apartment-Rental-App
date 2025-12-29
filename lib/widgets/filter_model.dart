import 'package:apartment_rental_app/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterModel extends StatefulWidget {
  const FilterModel({super.key});

  @override
  State<FilterModel> createState() => _FilterModelState();
}

class _FilterModelState extends State<FilterModel> {
  String _selectedGovernorate = 'All';
  String? _selectedCity; 
  RangeValues _priceRange = const RangeValues(50, 1000);
  RangeValues _areaRange = const RangeValues(50, 500);

  final List<String> _governorates = [
    'All', 'Damascus', 'Aleppo', 'Homs', 'Hama', 'Draa', 'Latakia', 'Tartous', 'Suwayda', 'Deir ez-Zor', 'Idlib', 'Raqqa'
  ];
  
  final Map<String, List<String>> _citiesByGovernorate = {
    'Damascus': ['Midan', 'Mazzeh', 'Afif'],
    'Aleppo': ['As-Safira', 'Al-Bab', 'Manbij'],
    'Homs': ['Talkalakh', 'Al-Qusayr', 'Al-Rastan'],
    'Hama': ['Salamiyah', 'Masyaf', 'Al-Hamraa'],
    'Draa': ['Bosra', 'Al-Hirak', 'Nawa'],
    'Latakia': ['Kessab', 'Jableh', 'Mashqita'],
    'Tartous': ['Baniyas', 'Arwad', 'Safita'],
    'Suwayda': ['Shahba', 'Salkhad', 'Shaqqa'],
    'Deir ez-Zor': ['Mayadin', 'Abu Kamal', 'Al-Asharah'],
    'Idlib': ['Ariha', 'Jisr ash-Shughur', 'Maarat al-Numan'],
    'Raqqa': ['Al-Thawrah', 'Al-Karamah', 'Al-Mansoura'],
  };

  @override
  Widget build(BuildContext context) {
    // 1. تحديد الثيم الحالي
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              'Filter',
              style: AppConstants.titleText.copyWith(
                color: isDark ? Colors.white : AppConstants.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Governorate', isDark),
            const SizedBox(height: 10),
            _buildGovernorateDropdown(isDark),

            const SizedBox(height: 20),
            _buildSectionTitle('City', isDark),
            const SizedBox(height: 10),
            _buildCityDropdown(isDark),

            const SizedBox(height: 20),
            _buildSectionTitle('Price Range', isDark),
            const SizedBox(height: 10),
            _buildPriceRangeSlider(isDark),

            const SizedBox(height: 20),
            _buildSectionTitle('Area (sqm)', isDark),
            const SizedBox(height: 10),
            _buildAreaRangeSlider(isDark),
            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: BorderSide(color: isDark ? Colors.white38 : AppConstants.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Reset',
                      style: AppConstants.secondText.copyWith(
                        color: isDark ? Colors.white70 : AppConstants.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : AppConstants.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Apply',
                      style: GoogleFonts.lato(
                        color: isDark ? AppConstants.primaryColor : Colors.white,
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

  Widget _buildGovernorateDropdown(bool isDark) {
    return DropdownButtonFormField<String>(
      value: _selectedGovernorate,
      dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: isDark ? Colors.white24 : AppConstants.secondColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: isDark ? Colors.white24 : AppConstants.secondColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      ),
      items: _governorates.map((governorate) {
        return DropdownMenuItem(
          value: governorate,
          child: Text(governorate),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedGovernorate = newValue!;
          if (newValue == "All") {
            _selectedCity = null;
          } else {
            _selectedCity = _citiesByGovernorate[newValue]!.first;
          }
        });
      },
    );
  }

  Widget _buildCityDropdown(bool isDark) {
    final cities = _citiesByGovernorate[_selectedGovernorate] ?? [];
    return DropdownButtonFormField<String>(
      value: _selectedCity,
      dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: isDark ? Colors.white24 : AppConstants.secondColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: isDark ? Colors.white24 : AppConstants.secondColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      ),
      items: cities.map((city) {
        return DropdownMenuItem(
          value: city,
          child: Text(city),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedCity = newValue!;
        });
      },
    );
  }

  Widget _buildPriceRangeSlider(bool isDark) {
    return RangeSlider(
      values: _priceRange,
      min: 50,
      max: 1000,
      divisions: 10,
      activeColor: isDark ? Colors.white : AppConstants.primaryColor,
      inactiveColor: isDark ? Colors.white12 : AppConstants.secondColor,
      labels: RangeLabels(
        '${(_priceRange.start).toStringAsFixed(1)}M',
        '${(_priceRange.end).toStringAsFixed(1)}M',
      ),
      onChanged: (RangeValues values) {
        setState(() {
          _priceRange = values;
        });
      },
    );
  }

  Widget _buildAreaRangeSlider(bool isDark) {
    return RangeSlider(
      values: _areaRange,
      min: 50,
      max: 500,
      divisions: 10,
      activeColor: isDark ? Colors.white : AppConstants.primaryColor,
      inactiveColor: isDark ? Colors.white12 : AppConstants.secondColor,
      labels: RangeLabels(
        '${_areaRange.start.round()} sqm',
        '${_areaRange.end.round()} sqm',
      ),
      onChanged: (RangeValues values) {
        setState(() {
          _areaRange = values;
        });
      },
    );
  }
}