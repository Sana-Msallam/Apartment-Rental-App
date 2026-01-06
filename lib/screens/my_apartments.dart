import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:apartment_rental_app/constants/app_string.dart';
import 'package:apartment_rental_app/controller/apartment_home_controller.dart';
import 'package:apartment_rental_app/controller/my_apartment_controller.dart';
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
              // تخزين المراجع قبل الـ await لضمان عملها
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

  @override
  Widget build(BuildContext context) {
    final texts = ref.watch(stringsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final apartmentsAsyncValue = ref.watch(ownerApartmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(texts.myApartments, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: RefreshIndicator(
          onRefresh: () => ref.read(ownerApartmentsProvider.notifier).loadOwnerApartments(),
          child: apartmentsAsyncValue.when(
            data: (apartments) {
              if (apartments.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(), 
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    Center(child: Text(texts.noApartments)),
                  ],
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.only(top: 10, bottom: 80),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApartmentDetailsScreen(apartmentId: apartment.id),
                        ),
                      );
                    },
                    onDelete: () => _confirmDelete(context, ref, apartment.id, texts),
                    imagePath: apartment.imagePath,
                    price: apartment.price,
                    governorate: apartment.governorate,
                    city: apartment.city,
                    space: apartment.space,
                    average_rating: apartment.averageRating,
                   
                    onFavoriteToggle: () {  },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConstants.primaryColor,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddApartmentPage()),
        ).then((_) {
          if (mounted) {
            ref.read(ownerApartmentsProvider.notifier).loadOwnerApartments();
          }
        }),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}