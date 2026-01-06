import 'dart:developer';
import 'package:apartment_rental_app/constants/app_constants.dart';
import 'package:apartment_rental_app/controller/apartment_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Apartmentcard extends StatelessWidget {
  final int id;
  final String imagePath;
  final int price;
  final String governorate;
  final String city;
  final int space;
  final dynamic average_rating;
  final VoidCallback onTap;
  final bool is_favorite;
  final VoidCallback? onDelete;
  final VoidCallback onFavoriteToggle;

  const Apartmentcard({
    super.key,
    required this.id,
    required this.imagePath,
    required this.price,
    required this.governorate,
    required this.city,
    required this.space,
    required this.onTap,
    required this.onFavoriteToggle,
    this.onDelete,
    this.average_rating,
    this.is_favorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: imagePath,
                    
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    httpHeaders: const {'Connection': 'keep-alive'},
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
                            Text('$price \$', style: AppConstants.secondText),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 18,
                                ),
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
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.grey, size: 12),
                                  const SizedBox(width: 2),
                                  Expanded(
                                    child: Text(
                                      '$governorate, $city',
                                      style: AppConstants.thirdText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //  const SizedBox(width: 6),
                            IconButton(
  onPressed: () {
    // هنا نستدعي الدالة التي تم تمريرها للكارد
    // إذا كان الكلاس StatefulWidget نستخدم widget.onFavoriteToggle()
    // إذا كان StatelessWidget نستخدم onFavoriteToggle() مباشرة
    onFavoriteToggle(); 
  },
  icon: Icon(
    is_favorite ? Icons.favorite : Icons.favorite_border,
    color: is_favorite ? Colors.red : Colors.grey,size: 18
  ),
),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.square_foot, color: Colors.grey, size: 14),
                            const SizedBox(width: 4),
                            Text('$space m²', style: AppConstants.thirdText),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (onDelete != null)
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}