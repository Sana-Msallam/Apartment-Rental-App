 import 'package:apartment_rental_app/screens/booking_screen.dart';
import 'package:flutter/material.dart';




Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Text(
        text,
        style: const TextStyle(color: kPrimaryColor, fontSize: 13),
      ),
    );
  }