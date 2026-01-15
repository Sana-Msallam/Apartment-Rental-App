import 'package:apartment_rental_app/models/apartment_home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:apartment_rental_app/constants/app_string.dart';
import 'package:apartment_rental_app/providers/apartment_home_provider.dart';
import 'package:apartment_rental_app/providers/my_apartment_provider.dart';
import 'package:apartment_rental_app/screens/booking_requests_tap.dart'; 
import '../widgets/apartmentCard.dart';
import '../constants/app_constants.dart';
import '../screens/apartment_details_screen.dart';
import '../screens/add_apartment_page.dart';

class MyApartmentsScreen extends ConsumerStatefulWidget {
  const MyApartmentsScreen({super.key});

  @override
  ConsumerState<MyApartmentsScreen> createState() => _MyApartmentsScreenState();
}

class _MyApartmentsScreenState extends ConsumerState<MyApartmentsScreen> {
    void _confirmDelete(BuildContext context, WidgetRef ref, int apartmentId, AppStrings texts) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(texts.delete),
        content: Text(texts.deleteConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(texts.cancel)),
          TextButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final nav = Navigator.of(ctx); 
              
              await ref.read(ownerApartmentsProvider.notifier).deleteApartment(apartmentId);
              
              if (!mounted) return; 
              nav.pop();
              messenger.showSnackBar(SnackBar(content: Text(texts.addSuccess))); 
            },
            child: Text(texts.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  Future<void> _handleRefresh() async {
    await ref.read(ownerApartmentsProvider.notifier).loadOwnerApartments();
  }

  @override
  Widget build(BuildContext context) {
    final texts = ref.watch(stringsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            texts.myApartments, 
            style: theme.appBarTheme.titleTextStyle ?? GoogleFonts.lato(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: texts.isAr ? "شققي" : "My Apartments"), 
              Tab(text: texts.requests ?? "Requests"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RefreshIndicator(
              onRefresh: _handleRefresh,
              color: AppConstants.primaryColor,
              backgroundColor: isDark ? const Color(0xFF22282A) : Colors.white,
              child: _buildMyApartmentsGrid(texts),
            ),
            
            const BookingRequestsTap(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppConstants.primaryColor,
          onPressed: () => Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const AddApartmentPage())
          ).then((_) {
            if (mounted) {
              ref.read(ownerApartmentsProvider.notifier).loadOwnerApartments();
            }
          }),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
  Widget _buildMyApartmentsGrid(AppStrings texts) {
    final apartmentsAsyncValue = ref.watch(ownerApartmentsProvider);

    return apartmentsAsyncValue.when(
      data: (List<Apartment> apartments) {
        if (apartments.isEmpty) {
          return ListView( 
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              Center(
                child: Text(
                  texts.noApartments,
                  style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54),
                ),
              ),
            ],
          );
        }
        return GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.65,
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApartmentDetailsScreen(apartmentId: apartment.id),
                  ),
                );
              },
              onFavoriteToggle: () {
                ref.read(apartmentProvider.notifier).toggleFavorite(apartment.id);
              },
              onDelete: () => _confirmDelete(context, ref, apartment.id, texts),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          Center(child: Text('Error: $error', textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}