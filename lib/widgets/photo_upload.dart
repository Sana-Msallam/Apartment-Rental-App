import 'dart:io';
import 'package:flutter/material.dart';

class PhotoUpload extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final File? imageFile;
  final VoidCallback onTap;
  final Color primaryColor;
  final Color borderColor;

  const PhotoUpload({
    super.key,
    required this.hintText,
    required this.icon,
    this.imageFile,
    required this.onTap,
    required this.primaryColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFileSelected = imageFile != null;
    final Color activeBorderColor = isFileSelected ? primaryColor : borderColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58, 
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15), 
          border: Border.all(
            color: activeBorderColor,
            width: isFileSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isFileSelected ? Icons.check_circle : icon,
              color: primaryColor,
              size: 22,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                isFileSelected ? 'Image selected' : hintText,
                style: TextStyle(
                  color: isFileSelected ? Colors.black : borderColor,
                  fontSize: 16,
                ),
              ),
            ),
            if (!isFileSelected)
              Icon(Icons.upload_file, color: primaryColor.withOpacity(0.5), size: 20),
          ],
        ),
      ),
    );
  }
}