import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });


    @override
Widget build(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final appBarTheme = Theme.of(context).appBarTheme;

  return AppBar(
    title: Text(
      title,
      style: appBarTheme.titleTextStyle ,
    ),
    backgroundColor: appBarTheme.backgroundColor, 
    
    iconTheme: appBarTheme.iconTheme,
    elevation: appBarTheme.elevation,
    centerTitle: true,
  );
}

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}