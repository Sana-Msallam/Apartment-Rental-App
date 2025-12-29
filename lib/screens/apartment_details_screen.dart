import 'package:apartment_rental_app/screens/booking_screen.dart';
import 'package:apartment_rental_app/screens/log_in.dart';
import 'package:flutter/material.dart';
import 'package:apartment_rental_app/models/apartment_model.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:apartment_rental_app/widgets/custom_app_bar.dart';

const Color kPrimaryColor = Color(0xFF234F68);

final dummyApartment = ApartmentModel(
  id: 101,
  price: 1200,
  rooms: 3,
  bathrooms: 2,
  space: 150,
  floor: 4,
  titleDeed: "Registered / Tapu",
  governorate: "Istanbul",
  city: "Basaksehir",
  imageUrls: [
    'assets/apartments/apartment-2094688_640.jpg', // المسار الكامل ضروري
    'assets/apartments/bedroom-1872196_1280.jpg',
  ],
  description:
      "A luxury apartment with a sea view, fully furnished with modern furniture, located in a quiet neighborhood close to all essential services and public transportation.",
  builtYear: "2021",
  ownerName: "Eng. Ahmed Mansour",
);

class ApartmentDetailsScreen extends StatefulWidget {
  final ApartmentModel apartment;
  const ApartmentDetailsScreen({super.key, required this.apartment});

  @override
  State<ApartmentDetailsScreen> createState() => _ApartmentDetailsScreenState();
}

class _ApartmentDetailsScreenState extends State<ApartmentDetailsScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.apartment.imageUrls.length * 1000;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(title: "Apartment Details"),
      body: Stack(
        children: [
          // المحتوى القابل للتمرير
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  _buildImageSlider(),

                  const SizedBox(height: 25),

                  _buildPriceHeader(),

                  const SizedBox(height: 20),

                  _buildTitleDeedCard(),

                  const SizedBox(height: 25),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFeaturesGrid(),

                        const SizedBox(height: 30),

                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : kPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.apartment.description,
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).cardColor,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 30),
                        const Divider(),
                        const SizedBox(height: 20),

                        Text(
                          "Property Owner",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : kPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildOwnerCard(),

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
              textButton: "Rental Now",
              kPrimaryColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : kPrimaryColor,
              vTextColor: Colors.white,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                    // BookingApp(
                    // apartmentId: widget.apartment.id,pricePerNight: 123, // نمرر الـ ID فقط
                    //         ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider() {
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
                itemBuilder: (context, index) {
                  int imgIndex = index % widget.apartment.imageUrls.length;
                  return Image.asset(
                    widget.apartment.imageUrls[imgIndex],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Theme.of(context).cardColor,
                      ),
                    ),
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
            widget.apartment.imageUrls.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: (_currentPage % widget.apartment.imageUrls.length) == index
                  ? 24
                  : 8,
              decoration: BoxDecoration(
                color:
                    (_currentPage % widget.apartment.imageUrls.length) == index
                    ? kPrimaryColor
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.apartment.city,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : kPrimaryColor,
                ),
              ),
              Text(
                widget.apartment.governorate,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
            ],
          ),
          Text(
            "\$${widget.apartment.price.toInt()}",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleDeedCard() {
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
            const Icon(Icons.verified_rounded, color: Colors.teal, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Title Deed Status",
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : kPrimaryColor,
                  ),
                ),
                Text(
                  widget.apartment.titleDeed,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _featureIcon(Icons.king_bed, "${widget.apartment.rooms} Rooms"),
        _featureIcon(Icons.bathtub, "${widget.apartment.bathrooms} Baths"),
        _featureIcon(Icons.square_foot, "${widget.apartment.space.toInt()}m²"),
        _featureIcon(Icons.layers, "Floor ${widget.apartment.floor}"),
      ],
    );
  }

  Widget _buildOwnerCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
        title: Text(
          widget.apartment.ownerName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Owner - Built in ${widget.apartment.builtYear}"),
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
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: kPrimaryColor, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _contactCircle(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Icon(icon, color: kPrimaryColor, size: 20),
    );
  }
}
