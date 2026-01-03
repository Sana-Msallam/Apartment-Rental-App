import 'package:apartment_rental_app/controller/apartment_home_controller.dart';
import 'package:apartment_rental_app/main.dart';
import 'package:apartment_rental_app/screens/apartment_details_screen.dart';
import 'package:apartment_rental_app/screens/booking_screen.dart';
import 'package:apartment_rental_app/screens/notification_screen.dart';
import 'package:apartment_rental_app/widgets/filter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/apartmentCard.dart';
import '../constants/app_constants.dart';
import '../screens/favorites_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/add_apartment_page.dart';
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
        final isDark = Theme.of(context).brightness == Brightness.dark;


    return Scaffold(
 backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildCustomAppBar(context, isDark),
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
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final apartmentsAsyncValue = ref.watch(apartmentProvider);
                  
                  return apartmentsAsyncValue.when(
                    data: (apartments) {
                      if (apartments.isEmpty) {
                        return Center(child: Text('No apartments found.',
                        style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),));
                      }
                      
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: apartments.length,
                        itemBuilder: (context, index) {
                          final apartment = apartments[index];
                          return GestureDetector(
                            child: Apartmentcard(
                              id:apartment.id,
                              onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ApartmentDetailsScreen(
                                    apartmentId: apartment.id,
                                  ),
                                ),
                              );
                            },
                              imagePath: apartment.imagePath,
                              price: apartment.price,
                              governorate: apartment.governorate,
                              city: apartment.city,
                              space: apartment.space,
                              average_rating: apartment.averageRating,
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Text('Something went wrong: ${error.toString()}',style: TextStyle(color: isDark ? Colors.red[200] : Colors.red),),
                    ),
                  );
                },
              ), 
            ), 
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 8, // لجعله نافر بشكل واضح
        backgroundColor: AppConstants.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddApartmentPage()),
          );
        },
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
      
      // اختيار مكان الزر (اختياري)
       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildCustomBottomNavBar(),
    );
  }
PreferredSizeWidget _buildCustomAppBar(BuildContext context, bool isDark) {
      return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Row(children: [
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
color: AppConstants.primaryColor,              ),
            ),
            const Spacer(),
           IconButton(
            icon: Icon(Icons.notifications_none,
color: isDark ? Colors.white : Colors.grey[800],        size: 28,
      ),
      onPressed: (){
        // Navigator.push(
        //   context, 
        // MaterialPageRoute(builder: (context)=> NotificationScreen())
        // );
      },
           )
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
            MaterialPageRoute(builder: (context) =>  const FavoritesScreen()),
          
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