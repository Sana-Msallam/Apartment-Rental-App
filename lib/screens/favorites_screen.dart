import 'package:apartment_rental_app/providers/apartment_home_provider.dart';
import 'package:apartment_rental_app/screens/apartment_details_screen.dart';
import 'package:apartment_rental_app/widgets/apartmentCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import 'package:apartment_rental_app/constants/app_string.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final texts = ref.watch(stringsProvider);
    final favoritesAsync = ref.watch(favoriteApartmentsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: texts.favorites),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: favoritesAsync.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (apartments) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(favoriteApartmentsProvider);
              await ref.read(favoriteApartmentsProvider.notifier).loadFavoriteApartments();
            },
            child: apartments.isEmpty
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Text(
                          texts.noFavorites,
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
                      childAspectRatio: 0.68,
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
                        onFavoriteToggle: () {
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
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 50, color: Colors.red),
              const SizedBox(height: 10),
              Text(texts.somethingWentWrong, style: AppConstants.thirdText),
              TextButton(
                onPressed: () => ref.refresh(favoriteApartmentsProvider),
                child: Text(texts.tryAgain),
              )
            ],
          ),
        ),
      ),
    );
  }
}