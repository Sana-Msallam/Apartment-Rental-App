import 'dart:developer';
import 'package:apartment_rental_app/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Apartmentcard extends StatelessWidget {
  final int id;
  final String imagePath;
  final int price;
  final String governorate;
  final String city;
  final int space;
  final dynamic average_rating; // استعملت dynamic ليتناسب مع أي نوع بيانات قادم من الباك
  final VoidCallback onTap;

  const Apartmentcard({
    super.key,
    required this.id,
    required this.imagePath,
    required this.price,
    required this.governorate,
    required this.city,
    required this.space,
    required this.onTap,
    this.average_rating,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final secondaryTextColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.all(5.0),
      elevation: isDark ? 0 : 4, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: isDark 
            ? BorderSide(color: Colors.white.withOpacity(0.1), width: 1) 
            : BorderSide.none,
      
      ),
      
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: imagePath,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                httpHeaders: const {
                  'Connection': 'keep-alive',
                },
                placeholder: (context, url) => Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, size: 50),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$price \$',
                          style: AppConstants.secondText,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                            const SizedBox(width: 2),
                            Text(
                              average_rating?.toString() ?? "0", 
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.grey, size: 12),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '$governorate, $city',
                                  style: AppConstants.thirdText,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.favorite_border_outlined, size: 18),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.square_foot, color: Colors.grey, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '$space m²',
                          style: AppConstants.thirdText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}