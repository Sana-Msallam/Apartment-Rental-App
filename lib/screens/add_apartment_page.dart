import 'dart:io';
import 'package:apartment_rental_app/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:apartment_rental_app/widgets/glass_container.dart';
import 'package:apartment_rental_app/widgets/custom_text_filed.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:apartment_rental_app/widgets/buildLabel.dart';

Color kPrimaryColor = const Color(0xFF234F68);

class AddApartmentPage extends StatefulWidget {
  const AddApartmentPage({super.key});

  @override
  State<AddApartmentPage> createState() => _AddApartmentPageState();
}

class _AddApartmentPageState extends State<AddApartmentPage> {
  
    final TextEditingController _builtController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _spaceController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
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

                    buildLabel(context,"Apartment Photos"),
                    const SizedBox(height: 8),
                    _buildPhotoUploadWidget(),
                    if (_selectedImages.isNotEmpty) _buildImagePreview(),

                    const SizedBox(height: 20),

                    buildLabel(context,"Price (\$)"),
                    CustomTextFiled(
                      controller: _priceController,
                      hintText: "e.g. 1200",
                      prefixIcon: Icons.attach_money,
                    ),

                    const SizedBox(height: 15),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildLabel(context,"Rooms"),
                              CustomTextFiled(
                                controller: _roomsController,
                                hintText: "3",
                                prefixIcon: Icons.bed,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildLabel(context,"Bathrooms"),
                              CustomTextFiled(
                                controller: _bathroomsController,
                                hintText: "2",
                                prefixIcon: Icons.bathtub,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    buildLabel(context,"region"),
                    CustomDropdown(
                      hint: "Select",
                      value: _selectedgovernorates,
                      items: _governorates,
                      icon: Icons.location_city,
                      onChanged: (newValue) =>
                          setState(() => _selectedgovernorates = newValue),
                    ),

                    const SizedBox(height: 15),

                  buildLabel(context,"City"),
                    CustomTextFiled(
                      controller: _cityController,
                      hintText: "e.g. Al-Midan",
                      prefixIcon: Icons.map,
                    ),

                    const SizedBox(height: 15),
                    
                    buildLabel(context,"builtYear"),
                    CustomTextFiled(
                      controller: _builtController,
                      hintText: "2000",
                      prefixIcon: Icons.date_range,
                    ),

                    const SizedBox(height: 15),

                  buildLabel(context,"Title Deed Type"),
                    CustomDropdown(
                      hint: "Select Title Deed",
                      value: _selectedTitleDeed,
                      items: _titleDeedTypes,
                      icon: Icons.assignment,
                      onChanged: (newValue) =>
                          setState(() => _selectedTitleDeed = newValue),
                    ),

                    const SizedBox(height: 15),

                    buildLabel(context,"Description"),
                    CustomTextFiled(
                      controller: _descriptionController,
                      hintText: "Describe your apartment...",
                      prefixIcon: Icons.description,
                    ),

                    const SizedBox(height: 30),

                    Center(
                      child: CustomButton(
                        textButton: 'POST APARTMENT',
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
color: Theme.of(context).cardColor, // يأخذ لون الثيم الموحد
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
                      );
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
}
