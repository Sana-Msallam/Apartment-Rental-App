import 'dart:developer';
import 'dart:io';
import 'package:apartment_rental_app/constants/app_string.dart';
import 'package:apartment_rental_app/controller/apartment_home_controller.dart';
import 'package:apartment_rental_app/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:apartment_rental_app/widgets/glass_container.dart';
import 'package:apartment_rental_app/widgets/custom_text_filed.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:apartment_rental_app/widgets/buildLabel.dart';
// تأكد من استيراد ملف الـ Provider الخاص باللغة
// import 'package:apartment_rental_app/provider/strings_provider.dart'; 

Color kPrimaryColor = const Color(0xFF234F68);

class AddApartmentPage extends ConsumerStatefulWidget {
  const AddApartmentPage({super.key});

  @override
  ConsumerState<AddApartmentPage> createState() => _AddApartmentPageState();
}

class _AddApartmentPageState extends ConsumerState<AddApartmentPage> {
  final _formKey = GlobalKey<FormState>();

  // المتغيرات التي تخزن الحالة
  List<String> _currentCities = [];
  String? _selectedCity;
  String? _selectedgovernorates;
  String? _selectedTitleDeed;

  final TextEditingController _builtController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _spaceController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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
    // استدعاء نصوص اللغة المختارة (عربي أو إنجليزي)
    final texts = ref.watch(stringsProvider);
  final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dynamicColor = isDark ? Colors.white : theme.primaryColor;
    // استخراج المحافظات من الـ Map الموجود في ملف اللغة
    final List<String> governoratesList = texts.citiesByGovernorate.keys.toList();
    
    // قائمة أنواع الطابو المترجمة
    final List<String> titleDeedTypes = [
      texts.greenTabo,
      texts.courtDecision,
      texts.powerOfAttorney,
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.6)
                : Colors.transparent,
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: GlassContainer(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          texts.apartmentDetails, // مترجم
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: dynamicColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      buildLabel(context, texts.apartmentPhotos), // مترجم
                      const SizedBox(height: 8),
                      _buildPhotoUploadWidget(texts),
                      if (_selectedImages.isNotEmpty) _buildImagePreview(),

                      const SizedBox(height: 20),

                      buildLabel(context, texts.priceLabel), // مترجم
                      CustomTextFiled(
                        controller: _priceController,
                        hintText: " 1200",
                        prefixIcon: Icons.attach_money,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return texts.priceRequired;
                          if (int.tryParse(v) == null) return texts.invalidNumber;
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildLabel(context, texts.rooms), // مترجم
                                CustomTextFiled(
                                  controller: _roomsController,
                                  hintText: "3",
                                  prefixIcon: Icons.bed,
                                  keyboardType: TextInputType.number,
                                  validator: (v) => (v == null || v.isEmpty) ? texts.requiredField : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildLabel(context, texts.bathrooms), // مترجم
                                CustomTextFiled(
                                  controller: _bathroomsController,
                                  hintText: "2",
                                  prefixIcon: Icons.bathtub,
                                  keyboardType: TextInputType.number,
                                  validator: (v) => (v == null || v.isEmpty) ? texts.requiredField : null,
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
                                buildLabel(context, texts.spaceLabel), // مترجم
                                CustomTextFiled(
                                  controller: _spaceController,
                                  hintText: "120",
                                  prefixIcon: Icons.square_foot,
                                  validator: (v) => (v == null || v.isEmpty) ? texts.requiredField : null,
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
                                buildLabel(context, texts.floor), // مترجم
                                CustomTextFiled(
                                  controller: _floorController,
                                  hintText: "2",
                                  prefixIcon: Icons.layers,
                                  keyboardType: TextInputType.number,
                                  validator: (v) => (v == null || v.isEmpty) ? texts.requiredField : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),
                      buildLabel(context, texts.governorate), // مترجم
                      CustomDropdown(
                        hint: texts.selectGovernorate, // مترجم
                        value: _selectedgovernorates,
                        items: governoratesList,
                        icon: Icons.location_city,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedgovernorates = newValue;
                            _selectedCity = null;
                            // جلب المدن من ملف اللغة بناءً على المحافظة المختارة
                            _currentCities = texts.citiesByGovernorate[newValue] ?? [];
                          });
                        },
                      ),

                      const SizedBox(height: 15),

                      buildLabel(context, texts.city), // مترجم
                      CustomDropdown(
                        hint: _selectedgovernorates == null ? texts.selectGovFirst : texts.selectCity,
                        value: _selectedCity,
                        items: _currentCities,
                        icon: Icons.map,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCity = newValue;
                          });
                        },
                      ),

                      const SizedBox(height: 15),

                      buildLabel(context, texts.builtYear), // مترجم
                      CustomTextFiled(
                        controller: _builtController,
                        hintText: "2000",
                        prefixIcon: Icons.date_range,
                        validator: (v) => v!.isEmpty ? texts.requiredField : null,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 15),

                      buildLabel(context, texts.titleDeedType), // مترجم
                      CustomDropdown(
                        hint: texts.selectTitleDeed,
                        value: _selectedTitleDeed,
                        items: titleDeedTypes,
                        icon: Icons.assignment,
                        onChanged: (newValue) => setState(() => _selectedTitleDeed = newValue),
                      ),

                      const SizedBox(height: 15),

                      buildLabel(context, texts.description), // مترجم
                      CustomTextFiled(
                        controller: _descriptionController,
                        hintText: texts.descriptionHint,
                        prefixIcon: Icons.description,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) return texts.descriptionRequired;
                          if (value.length < 20) return texts.descriptionTooShort;
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      Center(
                        child: CustomButton(
                        
                          onTap: () => _submitData(texts), // نمرر نصوص اللغة للميثود
                          textButton: texts.addApartmentButton, // مترجم
                           kPrimaryColor: isDark
                                    ? Colors.white
                                    : theme.primaryColor,
                                vTextColor: isDark
                                    ? Colors.black
                                    : Colors.white,
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

  Widget _buildPhotoUploadWidget(var texts) {
    bool hasImages = _selectedImages.isNotEmpty;
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
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
                    ? "${_selectedImages.length} ${texts.imagesSelected}"
                    : texts.uploadPhotos,
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
                      _selectedImages.removeAt(index);
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

  Future<void> _submitData(var texts) async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(texts.imageError)),
      );
      return;
    }
    if (_selectedgovernorates == null || _selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(texts.locationError)),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final Map<String, dynamic> apartmentData = {
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

    final service = ref.read(addApartmentServiceProvider);
    final success = await service.addApartment(
      data: apartmentData,
      images: _selectedImages,
    );

    Navigator.pop(context); // إغلاق الـ Loading

    if (success) {
      ref.invalidate(apartmentProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(texts.addSuccess)),
      );
      Navigator.pop(context); // العودة للشاشة السابقة
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(texts.addError)),
      );
    }
    
  }
}