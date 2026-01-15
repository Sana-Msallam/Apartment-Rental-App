import 'package:apartment_rental_app/constants/app_string.dart';
import 'package:apartment_rental_app/providers/apartment_home_provider.dart';
import 'package:apartment_rental_app/providers/notificatios_provider.dart';
import 'package:apartment_rental_app/screens/apartment_details_screen.dart';
import 'package:apartment_rental_app/screens/my_apartments.dart';
import 'package:apartment_rental_app/screens/notification_screen.dart';
import 'package:apartment_rental_app/services/push_notifications_service.dart';
import 'package:apartment_rental_app/widgets/filter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/apartmentCard.dart'; 
import '../constants/app_constants.dart';
import '../screens/favorites_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/add_apartment_page.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _onRefresh();
    });
    PushNotificationsService.handleForegroundMessage(ref);
  }
  Future<void> _onRefresh() async {
    ref.read(notificationsProvider.notifier).refreshUnreadCount();
    await ref.read(apartmentProvider.notifier).loadApartments();
  }

  @override
  Widget build(BuildContext context) {
    final texts = ref.watch(stringsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildCustomAppBar(context, isDark),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppConstants.primaryColor,
        backgroundColor: isDark ? const Color(0xFF22282A) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text(
                texts.recommendation,
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: ref.watch(apartmentProvider).when(
                  data: (apartments) {
                    if (apartments.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                          Center(
                            child: Text(
                              texts.noApartments,
                              style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.black54),
                            ),
                          ),
                        ],
                      );
                    }

                    return GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.68,
                      ),
                      itemCount: apartments.length,
                      itemBuilder: (context, index) {
                        final apartment = apartments[index];
                        
                        return Apartmentcard(
                          id: apartment.id,
                          imagePath: apartment.imagePath,
                          price: apartment.price,
                          governorate: texts.translate(apartment.governorate),
                          city: texts.translate(apartment.city),
                          space: apartment.space,
                          average_rating: apartment.averageRating,
                          is_favorite: apartment.is_favorite ?? false, 
                          onFavoriteToggle: () {
                            ref.read(apartmentProvider.notifier).toggleFavorite(apartment.id);
                          },
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
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                      Center(
                        child: Text(
                          'Something went wrong: ${error.toString()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: isDark ? Colors.red[200] : Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        backgroundColor: AppConstants.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddApartmentPage()),
          );
        },
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildCustomBottomNavBar(),
    );
  }

  PreferredSizeWidget _buildCustomAppBar(BuildContext context, bool isDark) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Row(
          children: [
            const Image(
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
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: isDark ? Colors.white : Colors.grey[800],
                  size: 28,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationScreen()),
                  );
                },
              ),
              Consumer(
                builder: (context, ref, child) {
                  final unreadCount = ref.watch(unreadCountProvider);
                  
                  if (unreadCount == 0) return const SizedBox.shrink();

                  return Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red, 
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5), 
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        unreadCount > 9 ? '+9' : '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Container(
      height: 75,
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
          _buildNavBarItem(Icons.home, true),
          _buildNavBarItem(Icons.favorite_border, false),
          _buildNavBarItem(Icons.tune, false),
          _buildNavBarItem(Icons.all_inbox, false),
          _buildNavBarItem(Icons.person, false),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, bool isActive) {
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
        }
        else if (icon == Icons.all_inbox) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>   const MyApartmentsScreen()),
          );
         }
         else if (icon == Icons.person) { 
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
      },
    );
  }
}