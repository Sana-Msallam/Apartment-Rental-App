import 'dart:developer';
import 'dart:io';
import 'package:apartment_rental_app/controller/apartment_home_controller.dart';
import 'package:apartment_rental_app/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:apartment_rental_app/widgets/glass_container.dart';
import 'package:apartment_rental_app/widgets/custom_text_filed.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:apartment_rental_app/widgets/buildLabel.dart';

Color kPrimaryColor = const Color(0xFF234F68);

class AddApartmentPage extends ConsumerStatefulWidget {
  const AddApartmentPage({super.key});

  @override
  ConsumerState<AddApartmentPage> createState() => _AddApartmentPageState();
}

class _AddApartmentPageState extends ConsumerState<AddApartmentPage> {
  final _formKey =GlobalKey<FormState>();
  final Map<String, List<String>> _citiesByGovernorate = {
  'Damascus': ['Midan', 'Mazzeh', 'Afif'],
 'Aleppo':['As-Safira','Al-Bab','Manbij'],
      'Homs': ['Talkalakh', 'Al-Qusayr','Al-Rastan'],
      'Hama':['Salamiyah','Masyaf','Al-Hamraa'],
      'Draa':['Bosra','Al-Hirak','Nawa'],
      'Latakia':['Kessab','Jableh','Mashqita'],
      'Tartous':['Baniyas','Arwad','Safita'],
      'Suwayda':['Shahba','Salkhad','Shaqqa'],
      'Deir ez-Zor':['Mayadin','Abu Kamal','Al-Asharah'],
      'Idlib':['Ariha','Jisr ash-Shughur','Maarat al-Numan'],
      'Raqqa':['Al-Thawrah','Al-Karamah','Al-Mansoura'],
};

// متغير لتخزين القائمة الحالية للمدن (تبدأ فارغة)
List<String> _currentCities = [];
String? _selectedCity; // بدلاً من _cityController
  
    final TextEditingController _builtController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _spaceController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedgovernorates;
  String? _selectedTitleDeed;

  final List<String> _governorates = [
    'Damascus',
    'Aleppo',
    'Homs',
    'Hama',
    'Draa',
    'Latakia',
    'Tartous',
    'Suwayda',
    'Deir ez-Zor',
    'Idlib',
    'Raqqa',
  ];

  final List<String> _titleDeedTypes = [
    'Green Tabo',
    'Court Decision',
    'Power of Attorney',
  ];

  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages = images.map((e) => File(e.path)).toList();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: kPrimaryColor),
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: Image(
              image: AssetImage('assets/images/start.png'),
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: GlassContainer(
               child:  Form(
                  key: _formKey,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        "Apartment Details",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    buildLabel("Apartment Photos"),
                    const SizedBox(height: 8),
                    _buildPhotoUploadWidget(),
                    if (_selectedImages.isNotEmpty) _buildImagePreview(),

                    const SizedBox(height: 20),

                    buildLabel("Price (\$)"),
                    CustomTextFiled(
                      controller: _priceController,
                      hintText: " 1200",
                      prefixIcon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (v){
              if (v == null || v.isEmpty)return "Price is required";
              if(v== 0)return "Price must be greater than 0";
              if (int.tryParse(v) == null) return "Please enter a valid number";
            } ,
                    ),

                    const SizedBox(height: 15),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildLabel("Rooms"),
                              CustomTextFiled(
                                controller: _roomsController,
                                hintText: "3",
                                prefixIcon: Icons.bed,
                                keyboardType: TextInputType.number,
                                validator: (v){
              if (v == null || v.isEmpty)return "rooms is required";
              if(v== 0)return "rooms must be greater than 0";
              if (int.tryParse(v) == null) return "Please enter a valid number";
            } ,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildLabel("Bathrooms"),
                              CustomTextFiled(
                                controller: _bathroomsController,
                                hintText: "2",
                                prefixIcon: Icons.bathtub,
                                keyboardType: TextInputType.number,
                                validator: (v){
              if (v == null || v.isEmpty)return "bathrooms is required";
              if(v== 0)return "bathrooms must be greater than 0";
              if (int.tryParse(v) == null) return "Please enter a valid number";
            } ,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                   

const SizedBox(height: 15),

Row(
  children: [
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabel("Space (m²)"),
          CustomTextFiled(
            controller: _spaceController, 
            hintText: "120",
            prefixIcon: Icons.square_foot,
            validator: (v){
              if (v == null || v.isEmpty)return "Space is required";
              if(v== 0)return "space must be greater than 0";
              if (int.tryParse(v) == null) return "Please enter a valid number";
              
              return null;
            } ,
            keyboardType: TextInputType.number, 
          ),
        ],
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabel("Floor"),
          CustomTextFiled(
            controller: _floorController, 
            hintText: "2",
            prefixIcon: Icons.layers,
            keyboardType: TextInputType.number,
            validator: (v){
              if (v == null || v.isEmpty)return "Price is required";
              if (int.tryParse(v) == null) return "Please enter a valid number";
            } ,
          ),
        ],
      ),
    ),
  ],
),



// ... الآن يكمل الكود لـ buildLabel("governorate")

                    const SizedBox(height: 15),
                    buildLabel("Governorate"),
                    CustomDropdown(
                      hint: "Select Governorate",
                      value: _selectedgovernorates,
                      items: _governorates,
                      icon: Icons.location_city,
                      onChanged: (newValue) {
                          setState(() {
                          _selectedgovernorates = newValue;
                          _selectedCity= null;
                          _currentCities=_citiesByGovernorate[newValue]?? [];
                      });
                      },
                    ),

                    const SizedBox(height: 15),

                    buildLabel("City"),
                    CustomDropdown(
                     hint: _selectedgovernorates == null ? "Select Governorate First": "Select City",
                     value: _selectedCity,
                     items: _currentCities,
                     icon: Icons.map,
                     onChanged: (newValue){
                      setState(() {
                        _selectedCity =newValue;
                      });
                     },
                    ),

                    const SizedBox(height: 15),
                    
                    buildLabel("builtYear"),
                    CustomTextFiled(
                      controller: _builtController,
                      hintText: "2000",
                      prefixIcon: Icons.date_range,
                      validator: (v) => v!.isEmpty ? "Required" : null,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 15),

                    buildLabel("Title Deed Type"),
                    CustomDropdown(
                      hint: "Select Title Deed",
                      value: _selectedTitleDeed,
                      items: _titleDeedTypes,
                      icon: Icons.assignment,
                      onChanged: (newValue) =>
                          setState(() => _selectedTitleDeed = newValue),
                
                    ),

                    const SizedBox(height: 15),

                    buildLabel("Description"),
                    CustomTextFiled(
                      controller: _descriptionController,
                      hintText: "Describe your apartment...",
                      prefixIcon: Icons.description,
                       keyboardType: TextInputType.text,
                      validator: (value){
                        if (value == null || value.isEmpty)return "Description is required";
                        if (value.length < 20) return "Description must be at least 20 characters";
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    Center(
                      child: CustomButton(
                        onTap: _submitData,
                        textButton: 'Add Apartment',
                        vTextColor: Colors.white,
                        kPrimaryColor: kPrimaryColor,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoUploadWidget() {
    bool hasImages = _selectedImages.isNotEmpty;
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: hasImages ? kPrimaryColor : Colors.grey.shade400,
            width: hasImages ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              hasImages ? Icons.check_circle : Icons.camera_alt,
              color: kPrimaryColor,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                hasImages
                    ? "${_selectedImages.length} Images Selected"
                    : "upload apartment photos",
                style: TextStyle(
                  color: hasImages ? Colors.black : Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(Icons.upload_file, color: kPrimaryColor.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _selectedImages[index],
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedImages.removeAt(
                        index,
                      ); // حذف الصورة من القائمة حسب رقمها (index)
                    });
                  },
                  child: const CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close, size: 15, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  Future<void> _submitData() async{
    if (!_formKey.currentState!.validate()) {
    return;
  }
  if (_selectedImages.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please upload at least one image')),
    );
    return;
  }
  if (_selectedgovernorates == null || _selectedCity == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select Governorate and City')),
    );
    return;
  }
    showDialog(context: context,
    barrierDismissible: false,
     builder: (context)=> const Center(child: CircularProgressIndicator()),
     );
     final Map<String, dynamic> apartmentData={
    "price": int.tryParse(_priceController.text) ?? 0,
    "rooms": int.tryParse(_roomsController.text) ?? 0,
    "space": int.tryParse(_spaceController.text) ?? 0, 
    "floor": int.tryParse(_floorController.text) ?? 0,
    "bathrooms": int.tryParse(_bathroomsController.text) ?? 0,
    "governorate": _selectedgovernorates,
    "city": _selectedCity,
    "built_date": "${_builtController.text}-1-1",
    "title_deed": _selectedTitleDeed,
    "description": _descriptionController.text,
     };
     final Service =ref.read(addApartmentServiceProvider);
     final success =await Service.addApartment(
      data: apartmentData,
    images: _selectedImages,
     );
     Navigator.pop(context);
     if(success){
      ref.invalidate(apartmentProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Add Apartment Successfully!")),
      );
      
      Navigator.pop(context);
     }else{
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to add apartment. Try again.")),
    );
     }
     }
  }

