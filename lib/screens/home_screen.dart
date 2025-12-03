import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCustomAppBar(),


    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(
                image:AssetImage('assets/images/person'),
                fit: BoxFit.cover,
                ),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'sana Msallam',
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          // استبدل كود Stack بـ Builder
Builder(
  builder: (context) { // نحصل على context جديد هنا
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.grey[700]),
          onPressed: () {
            // نستخدم الـ context الجديد الذي جاء من الـ Builder
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('لديك إشعارات جديدة')),
            );
          },
        ),
        Positioned(
          right: 11,
          top: 11,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(
              minWidth: 8,
              minHeight: 8,
            ),
          ),
        )
      ],
    );
  },
)
        ],
      ),
    );
  }
}
