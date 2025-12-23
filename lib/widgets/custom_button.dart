import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  CustomButton({
    required this.textButton,
    required this.vTextColor,
    required this.kPrimaryColor,
    required this.width,
    this.vfont = 'Lato-Regular',
    this.onTap,
  });
  final String textButton;
  final Color vTextColor; // Color(0xFFFFFFFF);
  final Color kPrimaryColor;
  final double? width;
  final String? vfont;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          padding: EdgeInsets.symmetric(vertical: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: Center(
          child: Text(
            textButton,
            style: TextStyle(
              fontSize: 20,
              color: vTextColor,
              fontFamily: vfont,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
