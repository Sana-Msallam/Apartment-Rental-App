import 'package:apartment_rental_app/controller/apartment_home_controller.dart';
import 'package:apartment_rental_app/screens/apartment_details_screen.dart';
import 'package:apartment_rental_app/widgets/apartmentCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteApartmentsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Favorite'),
      // يفضل استبدال Colors.white بـ Theme للـ Dark Mode
      backgroundColor: Colors.white,
      body: favoritesAsync.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (apartments) {
          // --- التعديل 1: إضافة RefreshIndicator للكل حتى لو القائمة فارغة ---
          return RefreshIndicator(
            onRefresh: () async {
  ref.invalidate(favoriteApartmentsProvider);
  // ننتظر حتى ينتهي الجلب الجديد للتأكد من اختفاء الدائرة
  await ref.read(favoriteApartmentsProvider.notifier).loadFavoriteApartments(); 
},
            child: apartments.isEmpty
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Text(
                          'No favorites yet!',
                          style: AppConstants.textNoData,
                        ),
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68, // نفس نسبة الهوم
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: apartments.length,
                    itemBuilder: (context, index) {
                      final apt = apartments[index];
                      return Apartmentcard(
                        id: apt.id,
                        imagePath: apt.imagePath,
                        price: apt.price,
                        governorate: apt.governorate,
                        city: apt.city,
                        space: apt.space,
                        average_rating: apt.averageRating,
                        is_favorite: apt.is_favorite,
                        // --- التعديل 2: إضافة التفاعل مع زر القلب ---
                        onFavoriteToggle: () {
                          // عند الضغط سيقوم الـ Notifier بحذفها وعمل invalidate للقائمة
                          ref.read(apartmentProvider.notifier).toggleFavorite(apt.id);
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApartmentDetailsScreen(
                                apartmentId: apt.id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          );
        },
        // loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 50, color: Colors.red),
              const SizedBox(height: 10),
              Text("Something went wrong", style: AppConstants.thirdText),
              TextButton(
                onPressed: () => ref.refresh(favoriteApartmentsProvider),
                child: const Text("Try Again"),
              )
            ],
          ),
        ),
      ),
    );
  }
}