import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    required this.textButton,
    required this.vTextColor,
    required this.kPrimaryColor,
    this.width,
    this.vfont = 'Lato-Regular',
    this.onTap,
  });

  final String? textButton;
  final Color? vTextColor;
  final Color? kPrimaryColor;
  final double? width;
  final String? vfont;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color defaultButtonColor = isDark
        ? Colors.white
        : const Color(0xFF234F68);

    final Color defaultTextColor = isDark
        ? const Color(0xFF234F68)
        : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: kPrimaryColor ?? defaultButtonColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            textButton ?? "",
            style: TextStyle(
              fontFamily: vfont,
              color: vTextColor ?? defaultTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
