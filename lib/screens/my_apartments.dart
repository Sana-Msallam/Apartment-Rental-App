import 'package:apartment_rental_app/controller/apartment_home_controller.dart';
import 'package:apartment_rental_app/screens/apartment_details_screen.dart';
import 'package:apartment_rental_app/screens/booking_requests_tap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/apartmentCard.dart';
import '../constants/app_constants.dart';
import '../screens/add_apartment_page.dart';

class MyApartmentsScreen extends ConsumerWidget {
  const MyApartmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            "My Apartment",
            style: theme.appBarTheme.titleTextStyle,
          ),
          centerTitle: true,
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: "All"),
              Tab(text: "Reqeust"), // مكتمل ومرفوض // ملغي من المستخدم
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMyApartmentsTab(ref, context),
            const BookingRequestsTap(), // محتوى التبويب الأول
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppConstants.primaryColor,
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddApartmentPage())),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  // دالة بناء قائمة الشقق (التي كانت تسبب لكِ الخطأ)
  Widget _buildMyApartmentsTab(WidgetRef ref, BuildContext context) {
    // استخدمي ownerApartmentsProvider بدلاً من apartmentProvider لكي تظهر شققه فقط
    final apartmentsAsyncValue = ref.watch(ownerApartmentsProvider); 

    return apartmentsAsyncValue.when(
      data: (apartments) {
        if (apartments.isEmpty) {
          return const Center(child: Text('You haven\'t added any apartments yet.'));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
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
              governorate: apartment.governorate,
              city: apartment.city,
              space: apartment.space,
              average_rating: apartment.averageRating,
              is_favorite: apartment.is_favorite,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApartmentDetailsScreen(apartmentId: apartment.id),
                  ),
                );
              },
              // حل المشكلة: يجب تمرير onFavoriteToggle حتى لو لم نحتاجها هنا بقوة
              onFavoriteToggle: () {
                ref.read(apartmentProvider.notifier).toggleFavoriteStatus(apartment.id);
              },
              onDelete: () {
                // كود الحذف
                print("Delete apartment with id: ${apartment.id}");
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}