import 'package:apartment_rental_app/constants/app_constants.dart';
import 'package:apartment_rental_app/controller/apartment_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
class FilterModel extends ConsumerStatefulWidget{
  const FilterModel({super.key});

  @override
  ConsumerState<FilterModel> createState() => _FilterModelState(); 
    
  }
  class _FilterModelState extends ConsumerState<FilterModel>{
    String _selectedGovernorate='All';
    String _selectedCity='All';
    RangeValues _priceRange= const RangeValues(500, 500000);
    
    RangeValues _spaceRange= const RangeValues(50, 500);

    final List<String> _governorates = ['All','Damascus', 'Aleppo', 'Homs', 'Hama', 'Draa', 'Latakia','Tartous','Suwayda','Deir ez-Zor' ,'Idlib','Raqqa'];
    final Map<String, List<String>> _citiesByGovernorate={
      'Damascus': ['All','Midan', 'Mazzeh', 'Afif'],
      'Aleppo':['All','As-Safira','Al-Bab','Manbij'],
      'Homs': ['All','Talkalakh', 'Al-Qusayr','Al-Rastan'],
      'Hama':['All','Salamiyah','Masyaf','Al-Hamraa'],
      'Draa':['All','Bosra','Al-Hirak','Nawa'],
      'Latakia':['All','Kessab','Jableh','Mashqita'],
      'Tartous':['All','Baniyas','Arwad','Safita'],
      'Suwayda':['All','Shahba','Salkhad','Shaqqa'],
      'Deir ez-Zor':['All','Mayadin','Abu Kamal','Al-Asharah'],
      'Idlib':['All','Ariha','Jisr ash-Shughur','Maarat al-Numan'],
      'Raqqa':['All','Al-Thawrah','Al-Karamah','Al-Mansoura'],
    };
    @override
    Widget build(BuildContext context){
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top:Radius.circular(25.0))
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize:MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppConstants.secondColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Filter',
                style:AppConstants.titleText,
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Governorate'),
              const SizedBox(height: 10),
              _buildGovernorateDropdown(),

              const SizedBox(height:20),
               _buildSectionTitle('City'),
              const SizedBox(height: 10),
              _buildCityDropdown(),

              const SizedBox(height:20),
               _buildSectionTitle('Price Range'),
              const SizedBox(height: 10),
              _buildPriceRangeSlider(),

              const SizedBox(height:20),
               _buildSectionTitle('Space (m²)'),
              const SizedBox(height: 10),
              _buildSpaceRangeSlider(),
              const SizedBox(height:30),

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
                        side: BorderSide(color:AppConstants.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Reset',
                        style: AppConstants.secondText,
                      ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (){
                         ref.read(apartmentProvider.notifier).applyFilter(
                          governorate: _selectedGovernorate == 'All'? null: _selectedGovernorate, 
                          city: _selectedCity == 'All'? null : _selectedCity,       
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
                            'Apply',
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
  Widget _buildSectionTitle(String title){
    return Text(
      title,
      style: AppConstants.secondText
    );
  }
  Widget _buildGovernorateDropdown(){
    return DropdownButtonFormField<String>(
      value: _selectedGovernorate ,
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppConstants.secondColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppConstants.primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      ),
      items: _governorates.map((governorate){
        return DropdownMenuItem(
          value: governorate,
          child: Text(governorate),
        );
      }).toList(),
      onChanged: (newValue){
  setState(() {
    _selectedGovernorate = newValue!;
    _selectedCity = 'All';
    
  });
},
    );
  }
  
  Widget _buildCityDropdown() {
    final cities = _citiesByGovernorate[_selectedGovernorate] ?? [];
    return DropdownButtonFormField<String>(
      value: _selectedCity,
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppConstants.secondColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color:AppConstants.primaryColor),
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
  Widget _buildPriceRangeSlider() {
    return RangeSlider(
      values: _priceRange,
      min: 500,
      max: 500000,
      divisions: 10,
      activeColor: AppConstants.primaryColor,
      inactiveColor: AppConstants.secondColor,
      labels: RangeLabels(
        '${(_priceRange.start).toStringAsFixed(1)}M',
        '${(_priceRange.end ).toStringAsFixed(1)}M',
      ),
      onChanged: (RangeValues values) {
        setState(() {
          _priceRange = values;
      });
      },
    );
  }
Widget _buildSpaceRangeSlider(){
  return RangeSlider(
    values: _spaceRange, 
    min: 50,
    max: 500,
    divisions: 10,
    activeColor:AppConstants.primaryColor,
    inactiveColor: AppConstants.secondColor,
     labels: RangeLabels(
        '${_spaceRange.start.round()} ',
        '${_spaceRange.end.round()} ',
      ),
   onChanged: (RangeValues values) {
        setState(() {
          _spaceRange = values;
        });
      },
    );
  }
}
  
