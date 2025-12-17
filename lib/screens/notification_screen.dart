import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
 class NotificationScreen extends StatelessWidget{
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Notifications'),
    backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'No notifications',
          style: AppConstants.textNoData
        ),
      ) ,
    );
  }
}