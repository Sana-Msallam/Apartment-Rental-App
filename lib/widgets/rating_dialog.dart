import 'package:apartment_rental_app/controller/apartment_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void showRatingDialog(BuildContext context, WidgetRef ref, int bookingId, int apartmentId, String apartmentName) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      int localStars = 0;
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Welcome Back 😍", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(" How Was Your Experience ?$apartmentName؟"),
            const SizedBox(height: 20),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              itemCount: 5,
              itemSize: 40,
              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) => localStars = rating.toInt(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Later", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (localStars > 0) {
                ref.read(apartmentProvider.notifier).addReview(bookingId, localStars,apartmentId);
                Navigator.pop(context);
              }
            },
            child: const Text("تقييم الآن"),
          ),
        ],
      );
    },
  );
}