import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';

class ProfileScreen extends StatelessWidget{
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'No Data ',
          style: AppConstants.textNoData
        ),
      ) ,
    );
  }
}