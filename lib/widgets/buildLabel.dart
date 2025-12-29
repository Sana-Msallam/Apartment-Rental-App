import 'package:apartment_rental_app/screens/booking_screen.dart';
import 'package:flutter/material.dart';

Widget buildLabel(BuildContext context, String text) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Padding(
    padding: const EdgeInsets.only(bottom: 6, left: 4),
    child: Text(
      text,
      style: TextStyle(
color: Theme.of(context).textTheme.bodyLarge?.color,
 fontSize: 13,
        fontWeight: FontWeight.w500, 
      ),
    ),
  );
}
