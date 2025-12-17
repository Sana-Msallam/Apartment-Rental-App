import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AppConstants {
  AppConstants._();
  static const Color primaryColor=Color(0xFF234F68);
  static final Color secondColor = Colors.grey.shade300; 

  static final TextStyle titleText=GoogleFonts.lato(
    fontSize: 20,
     fontWeight: FontWeight.bold,
    color: primaryColor,
  );
  static final TextStyle secondText=GoogleFonts.lato(
    fontSize: 16,
     fontWeight: FontWeight.bold,
    color: primaryColor,
  );
  static final TextStyle thirdText = GoogleFonts.lato(
    fontSize: 12,
    color: Colors.grey[600],
  );
  static final TextStyle titleScreen=GoogleFonts.lato(
    fontSize: 20,
     fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static TextStyle textNoData= GoogleFonts.lato(
    fontSize: 18,
    color: secondColor,
  );
}