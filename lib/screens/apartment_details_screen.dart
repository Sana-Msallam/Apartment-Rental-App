import 'package:apartment_rental_app/screens/booking_screen.dart';
import 'package:apartment_rental_app/widgets/apartment_model.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ApartmentDetailsScreen extends StatefulWidget {
  ApartmentDetailsScreen({required this.apartment});
  final ApartmentModel apartment;

  @override
  State<ApartmentDetailsScreen> createState() => _ApartmentDetailsScreenState();
}

class _ApartmentDetailsScreenState extends State<ApartmentDetailsScreen> {
  static const Color kPrimaryColor = Color(0xFF234F68);
  static const Color vBorderColor = Color(0xFFC0C0C0);
  final int _virtualItemCount = 10000;
  final String vfont = 'Lato-Regular';

  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    int initialPage = _virtualItemCount ~/ 2;
    _pageController = PageController(initialPage: initialPage);

    // تحديث _currentPage ليستخدم الفهرس الحقيقي (Actual Index)
    _currentPage = initialPage % widget.apartment.imageUrls.length;
    // الاستماع لتغيير الصفحة وتحديث الـState
    _pageController.addListener(() {
      if (_pageController.page != null) {
        // تحديث رقم الصفحة الحالي عند التمرير
        setState(() {
          _currentPage =
              _pageController.page!.round() % widget.apartment.imageUrls.length;
        });
      }
    });
  }

  @override
  void dispose() {
    // التخلص من المتحكم عند إغلاق الشاشة
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildFeatureItem(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. الأيقونة داخل الدائرة
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kPrimaryColor, width: 1.5),
            color: Colors.transparent,
          ),
          child: Icon(icon, color: kPrimaryColor, size: 28),
        ),
        const SizedBox(width: 8),
        // . تجميع النصوص (القيمة والتسمية) عمودياً
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: vfont,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Color.fromARGB(255, 8, 8, 8),
                fontFamily: vfont,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDotIndicator(int index) {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? kPrimaryColor
            : Colors.white54, // تغيير اللون حسب الصفحة الحالية
        border: Border.all(color: kPrimaryColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double galleryHeight = MediaQuery.of(context).size.height * 0.35;

    return Scaffold(
      appBar: (AppBar(
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border, color: kPrimaryColor),
          ),
        ],
      )),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. قسم الصور (Image Gallery)
            SizedBox(
              height: galleryHeight,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 156, 156, 156),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _virtualItemCount,

                          itemBuilder: (context, index) {
                            final int actualIndex =
                                index % widget.apartment.imageUrls.length;
                            return Image.asset(
                              widget.apartment.imageUrls[actualIndex],
                              fit: BoxFit.cover,
                              height: galleryHeight,
                              width: double.infinity,
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // مؤشرات الصفحات (Dots)
                  Positioned(
                    bottom: 25,
                    right: 0,
                    left: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.apartment.imageUrls.length,
                        (index) => _buildDotIndicator(index),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. قسم التفاصيل (Details Section)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // السعر والعنوان
                  Text(
                    '${widget.apartment.price.toStringAsFixed(0)}\$/Month',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: kPrimaryColor,
                      fontFamily: vfont,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${widget.apartment.city}, ${widget.apartment.governorate}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 83, 83, 83),
                      fontFamily: vfont,
                    ),
                  ),

                  const SizedBox(height: 20),
                  Divider(height: 1, color: vBorderColor, thickness: 1),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        // الصف الأول (غرف النوم والحمامات)
                        Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: _buildFeatureItem(
                                  Icons.king_bed,
                                  'Bed Room',
                                  widget.apartment.rooms.toString(),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: _buildFeatureItem(
                                  Icons.bathtub,
                                  'Bath Room',
                                  widget.apartment.bathrooms.toString(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // الصف الثاني (المساحة والطابق)
                        Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: _buildFeatureItem(
                                  Icons.square_foot,
                                  'Space',
                                  '${widget.apartment.space.toStringAsFixed(0)} sqft',
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: _buildFeatureItem(
                                  Icons.stairs,
                                  'Floor',
                                  widget.apartment.floor.toString(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 1, color: vBorderColor, thickness: 1),
                  const SizedBox(height: 20),

                  // معلومات إضافية
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        ' More Information:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 114, 90, 3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // حالة سند الملكية
                  Row(
                    children: [
                      _buildFeatureItem(Icons.assignment_outlined, "", ""),

                      Text(
                        '${widget.apartment.titleDeed}',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          fontFamily: vfont,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      _buildFeatureItem(Icons.money_rounded, "", ''),
                      Text(
                        'Cash Only',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          fontFamily: vfont,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                  CustomButton(
                    textButton: 'Rental Now',
                    vTextColor: Color(0xFFFFFFFF),
                    kPrimaryColor: kPrimaryColor,
                    width: double.infinity,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // نفترض أن BookingApp هي شاشة الحجز التي تريد الانتقال إليها
                          builder: (context) => BookingApp(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
