import 'package:apartment_rental_app/controller/apartment_home_controller.dart';
import 'package:apartment_rental_app/main.dart';
import 'package:apartment_rental_app/screens/apartment_details_screen.dart';
import 'package:apartment_rental_app/screens/notification_screen.dart';
import 'package:apartment_rental_app/widgets/filter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/apartmentCard.dart';
// import '../widgets/property_card.dart';
import '../constants/app_constants.dart';
import '../screens/favorites_screen.dart';
import '../screens/profile_screen.dart';
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              child: Consumer(
                builder: (context, ref, child){
                  final apartmentsAsyncValue= ref.watch(apartmentProvider);
                  return apartmentsAsyncValue.when(
                    data: (apartments){
                      if(apartments.isEmpty){
                        return const Center(child: Text('No apartments found.'));
                      }
                      return GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.68,
                      ),
                          itemCount: apartments.length,
                          itemBuilder: (context, index){
                        final apartment=apartments[index];
                        return Apartmentcard(
                          imagePath: apartment.imagePath, // <-- سيتم تعديله لاحقًا ليقبل رابط شبكة
                          price: apartment.price,
                          governorate: apartment.governorate,
                          city: apartment.city,
                          space: apartment.space,
                        );
                          },
                      );
                    },
                    loading: ()=> const Center(child: CircularProgressIndicator()),
                    error: (error, stack)=> Center(
                      child: Text('Something went wrong: ${error.toString()}'),
                    ),
                  );
                },
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
            icon: Icon(Icons.notifications_none,
        color: Colors.grey[800],
        size: 28,
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
