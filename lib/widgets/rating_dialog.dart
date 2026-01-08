import 'package:apartment_rental_app/controller/apartment_home_controller.dart';
import 'package:apartment_rental_app/constants/app_string.dart'; // استيراد ملف النصوص
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void showRatingDialog(BuildContext context, WidgetRef ref, int bookingId, int apartmentId, String apartmentName) {

  final texts = ref.read(stringsProvider);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      int localStars = 0;
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        // تبديل العنوان حسب اللغة
        title: Text(
          texts.isAr ? "أهلاً بعودتك 😍" : "Welcome Back 😍", 
          textAlign: TextAlign.center
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // تبديل السؤال مع الحفاظ على اسم الشقة
            Text(
              texts.isAr 
                  ? "كيف كانت تجربتك في $apartmentName؟" 
                  : "How was your experience at $apartmentName?",
              textAlign: TextAlign.center,
            ),
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
            // تبديل كلمة "لاحقاً"
            child: Text(
              texts.isAr ? "لاحقاً" : "Later", 
              style: const TextStyle(color: Colors.grey)
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (localStars > 0) {
                // الحفاظ على استدعاء الـ controller تماماً كما كان
                ref.read(apartmentProvider.notifier).addReview(bookingId, localStars, apartmentId);
                Navigator.pop(context);
              }
            },
            // تبديل نص الزر
            child: Text(texts.isAr ? "قيم الآن" : "Rate Now"),
          ),
        ],
      );
    },
  );
}