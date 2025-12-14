import 'package:flutter/material.dart';
import 'dart:io'; // للتعامل مع ملفات الصور

// تعريف الألوان (من الأفضل أن يتم تمريرها أو تعريفها كثوابت هنا أو في ملف الثوابت)
const Color kPrimaryColor = Color(0xFF234F68);
const Color vBorderColor = Color(0xFFC0C0C0);


class PhotoUpload extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final File? imageFile; 
  final VoidCallback onTap;
  final Color primaryColor;
  final Color borderColor;

  PhotoUpload({
    required this.hintText,
    required this.icon,
    required this.onTap,
    required this.primaryColor,
    required this.borderColor,
    this.imageFile,
  });


  @override
  Widget build(BuildContext context) {
    // 💡 التحقق مما إذا كانت الصورة محملة
    final bool isFileSelected = imageFile != null;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 15.0,
      ), 
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(color: isFileSelected ? primaryColor : borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // النص الذي يصف الحقل
            Text(
              hintText, 
              style: TextStyle(
                fontSize: 16, 
                color: isFileSelected ? primaryColor : borderColor, // تغيير اللون إذا تم الاختيار
              )
            ),
            
            ElevatedButton.icon(
              onPressed: onTap, 
              
              icon: Icon(
                isFileSelected ? Icons.check_circle : icon, 
                color: Colors.white,
              ),
              label: Text(
                isFileSelected ? 'Selected' : 'Upload', 
                style: TextStyle(color: Colors.white)
              ),
              
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  
                ),
            
              ),
            ),
          ],
        ),
      ),
    );
  }
}