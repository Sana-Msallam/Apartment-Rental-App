import 'package:apartment_rental_app/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Apartmentcard extends StatelessWidget{
  final String imagePath;
  final int price;
  final String governorate;
  final String city;
  final int space;

  const Apartmentcard({
    super.key,
    required this.imagePath,
    required this.price,
    required this.governorate,
    required this.city,
    required this.space,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(5.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Image.asset(
              imagePath,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$price',
                  style: AppConstants.secondText,
                ),
                const SizedBox(height:4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child:
                    Row(
                      children: [
                        const Icon(Icons.location_on,color: Colors.grey, size: 12),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                          '$governorate _$city',
                          style:AppConstants.thirdText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        ),
                      ],
                    ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite_border_outlined, size: 18),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.square_foot, color: Colors.grey, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '$space''M',
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
    );
  }
}
