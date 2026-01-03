// import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';

import 'package:apartment_rental_app/models/user_model.dart' show UserModel;
import 'package:apartment_rental_app/screens/booking_screen.dart';
import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apartment_rental_app/models/apartment_details_model.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:apartment_rental_app/widgets/custom_app_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../controller/apartment_home_controller.dart'; 
import '../constants/app_constants.dart';

const Color kPrimaryColor = Color(0xFF234F68);

class ApartmentDetailsScreen extends ConsumerStatefulWidget {
  final int apartmentId; 
  const ApartmentDetailsScreen({super.key, required this.apartmentId});

  @override
  ConsumerState<ApartmentDetailsScreen> createState() => _ApartmentDetailsScreenState();
}

class _ApartmentDetailsScreenState extends ConsumerState<ApartmentDetailsScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apartmentAsync = ref.watch(apartmentDetailProvider(widget.apartmentId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Apartment Details"),
      body: apartmentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryColor)),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (apartment) {
          return Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildImageSlider(apartment), 
                      const SizedBox(height: 25),
                      _buildPriceHeader(apartment),
                      const SizedBox(height: 20),
                      _buildStatusCard(apartment),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFeaturesGrid(apartment),
                            const SizedBox(height: 30),
                            const Text(
                              "Description",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kPrimaryColor),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              apartment.description,
                              style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.5),
                            ),
                            const SizedBox(height: 30),
                            const Divider(),
                            const SizedBox(height: 20),
                            const Text(
                              "Property Owner",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryColor),
                            ),
                            const SizedBox(height: 15),
                            _buildOwnerCard(apartment),
                            const SizedBox(height: 150),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: CustomButton(
                  textButton: "Rent Now",
                  kPrimaryColor: kPrimaryColor,
                  vTextColor: Colors.white,
                  onTap: () async { 
                    const storage = FlutterSecureStorage();
                    String? userData = await storage.read(key: 'jwt_token');
                    if (userData != null) {
                     final user = UserModel.fromJson(jsonDecode(userData), token: userData);
                    Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingApp(
                                   user:user ,
                                    apartmentId: apartment.id,
                         ),
                      
                       ),
                    );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  Widget _buildImageSlider(ApartmentDetail apartment) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: apartment.imageUrls.length, 
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: apartment.imageUrls[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.grey[200]),
                    errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            apartment.imageUrls.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _currentPage == index ? 24 : 8,
              decoration: BoxDecoration(
                color: _currentPage == index ? kPrimaryColor : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceHeader(ApartmentDetail apartment) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${apartment.price} \$", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: kPrimaryColor)),
          Row(
                      children: [
                        const Icon(Icons.location_on,color: Colors.grey, size: 18),
                        const SizedBox(width: 4),
                       
                           Text(
                          '${apartment.governorate}, ${apartment.city}',
                          style:AppConstants.titleText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                      ],
                    ),
           
        ],
      ),
    );
  }

 Widget _buildStatusCard(ApartmentDetail apartment) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: kPrimaryColor.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            // أيقونة التحقق
            const Icon(Icons.verified_rounded, color: Colors.teal, size: 28),
            const SizedBox(width: 12),
            
            // عمود معلومات التحقق
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Verification Status", 
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text("Verified Property", 
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kPrimaryColor)),
                ],
              ),
            ),

            // خط فاصل صغير عمودي لإعطاء جمالية
            Container(
              height: 30,
              width:1,
              color: Colors.grey.withOpacity(0.3),
              margin: const EdgeInsets.symmetric(horizontal: 10),
            ),

            // عمود سند الملكية
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Title Deed", 
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(apartment.titleDeed, // هنا يظهر "Green" أو نوع السند
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.teal)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesGrid(ApartmentDetail apartment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _featureIcon(Icons.king_bed, "${apartment.rooms} Rooms"),
        _featureIcon(Icons.bathtub, "${apartment.bathrooms} Baths"),
        _featureIcon(Icons.square_foot, "${apartment.space} m²"),
        _featureIcon(Icons.layers, "Floor ${apartment.floor}"),
        _featureIcon(Icons.calendar_month, "Built in${apartment.builtDate.split('-')[0]}")
      ],
    );
  }

  Widget _buildOwnerCard(ApartmentDetail apartment) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: kPrimaryColor.withOpacity(0.1),
          child: const Icon(Icons.person, color: kPrimaryColor, size: 30),
        ),
        title: Text("${apartment.first_name} ${apartment.last_name}", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Contact: ${apartment.owner_phone}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _contactCircle(Icons.message),
            const SizedBox(width: 8),
            _contactCircle(Icons.phone),
          ],
        ),
      ),
    );
  }

  Widget _featureIcon(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: kPrimaryColor.withOpacity(0.05), shape: BoxShape.circle),
          child: Icon(icon, color: kPrimaryColor, size: 22),
        ),
        const SizedBox(height: 6),
        Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _contactCircle(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey[300]!)),
      child: Icon(icon, color: kPrimaryColor, size: 20),
    );
  }
}
