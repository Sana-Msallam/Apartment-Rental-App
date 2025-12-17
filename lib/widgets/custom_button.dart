import 'package:flutter/material.dart';

//Color kPrimaryColor = Color(0xFF234F68);

class CustomButton extends StatelessWidget {
  CustomButton({
    required this.textButton,
    required this.vTextColor,
    required this.kPrimaryColor,
    required this.width,
    this.vfont = 'Lato-Regular',
    required this.onPressed,
    //  required Null Function() onTap,
  });
  final String textButton;
  final Color vTextColor; // Color(0xFFFFFFFF);
  final Color kPrimaryColor;
  final double? width;
  final String? vfont;
  final VoidCallback onPressed; // ✅ إضافة دالة عند الضغط

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        padding: EdgeInsets.symmetric(vertical: 22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        
      ),
      child: Center(
        child: Text(
          textButton,
          style: TextStyle(
            fontSize: 20,
            color:vTextColor,
            fontFamily: vfont,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      
    );
    
  }
}
