import 'package:apartment_rental_app/main.dart';
import 'package:apartment_rental_app/models/user_model.dart';
import 'package:apartment_rental_app/screens/add_apartment_page.dart';
import 'package:apartment_rental_app/screens/apartment_details_screen.dart';
import 'package:apartment_rental_app/screens/notification_screen.dart';
import 'package:apartment_rental_app/widgets/filter_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/apartmentCard.dart';
import '../constants/app_constants.dart';
import '../screens/favorites_screen.dart';
import '../screens/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildCustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              'Our Recommendation',
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddApartmentPage(),
                      // ApartmentDetailsScreen(apartment: dummyApartment,user: UserModel.currentUser!, // تأكد من تمرير اليوزر هنا
                    ),
                    //    ),
                  );
                },
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    final properties = [
                      {
                        'imagePath': 'assets/images/door1.jpg',
                        'price': '400.000',
                        'governorate ': 'Damascus',
                        'city': 'Mazzeh',
                        'area': '250',
                      },
                      {
                        'imagePath': 'assets/images/door2.jpg',
                        'price': '500.000',
                        'governorate ': 'Damascus',
                        'city': 'Midan',
                        'area': '100',
                      },
                      {
                        'imagePath': 'assets/images/door3.jpg',
                        'price': '600.000',
                        'governorate ': 'Damascus',
                        'city': 'BabToma',
                        'area': '200',
                      },
                      {
                        'imagePath': 'assets/images/door4.jpg',
                        'price': '250.000',
                        'governorate ': 'Damascus',
                        'city': 'Afif',
                        'area': '150',
                      },
                      {
                        'imagePath': 'assets/images/door1.jpg',
                        'price': '400.000',
                        'governorate ': 'Damascus',
                        'city': 'Mazzeh',
                        'area': '250',
                      },
                      {
                        'imagePath': 'assets/images/door2.jpg',
                        'price': '500.000',
                        'governorate ': 'Damascus',
                        'city': 'Midan',
                        'area': '100',
                      },
                      {
                        'imagePath': 'assets/images/door3.jpg',
                        'price': '600.000',
                        'governorate ': 'Damascus',
                        'city': 'BabToma',
                        'area': '200',
                      },
                      {
                        'imagePath': 'assets/images/door4.jpg',
                        'price': '250.000',
                        'governorate ': 'Damascus',
                        'city': 'Afif',
                        'area': '150',
                      },
                    ];
                    final property = properties[index];
                    return Apartmentcard(
                      imagePath: property['imagePath']!,
                      price: property['price']!,
                      governorate: property['governorate ']!,
                      city: property['city']!,
                      area: property['area']!,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildCustomBottomNavBar(),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Row(
          children: [
            Image(
              image: AssetImage('assets/images/Logo.png'),
              height: 60,
              width: 60,
            ),
            const SizedBox(width: 10),
            Text(
              'Sakani',
              style: GoogleFonts.lemon(
                fontSize: 18,
                color: AppConstants.primaryColor,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: Colors.grey[800],
                size: 28,
              ),
              onPressed: () {
                // Navigator.push(
                //   context,
                // MaterialPageRoute(builder: (context)=> NotificationScreen())
                // );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: AppConstants.primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Builder(
            builder: (context) => _buildNavBarItem(context, Icons.home, true),
          ),
          Builder(
            builder: (context) =>
                _buildNavBarItem(context, Icons.favorite_border, false),
          ),
          Builder(
            builder: (context) => _buildNavBarItem(context, Icons.tune, false),
          ),

          Builder(
            builder: (context) =>
                _buildNavBarItem(context, Icons.person, false),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(BuildContext context, IconData icon, bool isActive) {
    return IconButton(
      icon: Icon(
        icon,
        color: isActive ? Colors.white : Colors.white70,
        size: 28,
      ),
      onPressed: () {
        if (icon == Icons.tune) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (context) => const FilterModel(),
          );
        } else if (icon == Icons.favorite_border) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoritesScreen()),
          );
        } else if (icon == Icons.person) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
      },
    );
  }
}
