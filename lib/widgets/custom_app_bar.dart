import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  
  const CustomAppBar({
    super.key,
    required this.title,
  });
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppConstants.titleScreen,
      ),
      backgroundColor: AppConstants.primaryColor,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      elevation: 4,
      centerTitle: true,
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}