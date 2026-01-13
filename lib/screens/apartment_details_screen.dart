import 'dart:convert';
import 'package:apartment_rental_app/constants/app_string.dart';
import 'package:apartment_rental_app/models/user_model.dart' show UserModel;
import 'package:apartment_rental_app/screens/booking_screen.dart';
import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apartment_rental_app/models/apartment_details_model.dart';
import 'package:apartment_rental_app/widgets/custom_button.dart';
import 'package:apartment_rental_app/widgets/custom_app_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../providers/apartment_home_provider.dart';
import '../constants/app_constants.dart';

const Color kPrimaryColor = Color(0xFF234F68);

class ApartmentDetailsScreen extends ConsumerStatefulWidget {
  final int apartmentId;
  const ApartmentDetailsScreen({super.key, required this.apartmentId});

  @override
  ConsumerState<ApartmentDetailsScreen> createState() =>
      _ApartmentDetailsScreenState();
}

class _ApartmentDetailsScreenState
    extends ConsumerState<ApartmentDetailsScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // استدعاء نصوص اللغة
    final texts = ref.watch(stringsProvider);
    final apartmentAsync =
        ref.watch(apartmentDetailProvider(widget.apartmentId));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // ترجمة عنوان الأب بار
      appBar: CustomAppBar(title: texts.apartmentDetails),
      body: apartmentAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: kPrimaryColor)),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (apartment) {
          return Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildImageSlider(apartment),
                      const SizedBox(height: 25),
                      _buildPriceHeader(apartment),
                      const SizedBox(height: 20),
                      _buildStatusCard(
                          apartment, isDark, theme, texts), // نمرر texts
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFeaturesGrid(apartment, texts), // نمرر texts
                            const SizedBox(height: 30),
                            Text(
                              texts.description, // مترجم
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              apartment.description,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[700],
                                  height: 1.5),
                            ),
                            const SizedBox(height: 30),
                            const Divider(),
                            const SizedBox(height: 20),
                            Text(
                              isDark && !texts.isAr
                                  ? "Property Owner"
                                  : (texts.isAr
                                      ? "صاحب العقار"
                                      : "Property Owner"),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor),
                            ),
                            const SizedBox(height: 15),
                            _buildOwnerCard(apartment, isDark, theme, texts),
                            const SizedBox(height: 150),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: CustomButton(
                  textButton: texts.isAr
                      ? "احجز الآن"
                      : "Rent Now", // يمكنك إضافتها للـ AppStrings
                  kPrimaryColor: kPrimaryColor,
                  vTextColor: Colors.white,
                  onTap: () async {
                    print("Button Clicked");
                    // 1. الوصول للـ storage عبر الـ Provider لضمان نفس الإعدادا
                    // محاولة قراءة التوكن بكل المفاتيح المحتملة
                    final storage = ref.read(storageProvider);
                    String? token = await storage.read(key: 'jwt_token');
                    print("DEBUG: Final Token Check: $token");
                    if (token != null && token.isNotEmpty) {
                      // 2. إذا كان التوكن موجوداً، ننتقل لواجهة الحجز
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingApp(
                            apartmentId: apartment.id,
                            pricePerNight: apartment.price,
                          ),
                        ),
                      );
                    } else {
                      print("DEBUG: Token is null or empty!");
                      // 3. إذا كان التوكن غير موجود، يجب توجيه المستخدم لتسجيل الدخول
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Access Denied: Please login again"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      // يمكنك هنا عمل Navigator لشاشة الـ Login
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- Widgets المعدلة لتدعم الترجمة ---

  Widget _buildImageSlider(ApartmentDetail apartment) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: apartment.imageUrls.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: apartment.imageUrls[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey[200]),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            apartment.imageUrls.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _currentPage == index ? 24 : 8,
              decoration: BoxDecoration(
                color: _currentPage == index ? kPrimaryColor : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceHeader(ApartmentDetail apartment) {
    final texts = ref.watch(stringsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${apartment.price} \$",
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor)),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.grey, size: 18),
              const SizedBox(width: 4),
              Text(
                '${texts.translate(apartment.governorate)}, ${texts.translate(apartment.city)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
      ApartmentDetail apartment, bool isDark, ThemeData theme, dynamic texts) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isDark ? theme.cardColor : kPrimaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color:
                  isDark ? Colors.grey[800]! : kPrimaryColor.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified_rounded, color: Colors.teal, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(texts.isAr ? "الحالة" : "Status",
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(texts.isAr ? "عقار مؤكد" : "Verified Property",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : kPrimaryColor)),
                ],
              ),
            ),
            Container(
              height: 30,
              width: 1,
              color: Colors.grey.withOpacity(0.3),
              margin: const EdgeInsets.symmetric(horizontal: 10),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(texts.titleDeedType,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                // ابحث عن هذا السطر داخل _buildStatusCard
                Text(
                    texts.translate(
                        apartment.titleDeed), // تم استخدام translate هنا
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal)),
              ],
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildFeaturesGrid(ApartmentDetail apartment, dynamic texts) {
  return Row( // استخدمي Row بدلاً من Wrap لضمان بقائهم في صف واحد
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _featureIcon(Icons.king_bed, "${apartment.rooms} ${texts.rooms}"),
      _featureIcon(Icons.bathtub, "${apartment.bathrooms} ${texts.bathrooms}"),
      _featureIcon(Icons.square_foot, "${apartment.space} ${texts.isAr ? 'م²' : 'm²'}"),
      _featureIcon(Icons.layers, "${texts.floor} ${apartment.floor}"),
      _featureIcon(Icons.calendar_month, "${texts.builtYear}: ${apartment.builtDate.split('-')[0]}"),
    ],
  );
}

  Widget _buildOwnerCard(
      ApartmentDetail apartment, bool isDark, ThemeData theme, dynamic texts) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : kPrimaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: kPrimaryColor.withOpacity(0.1),
          child: const Icon(Icons.person, color: kPrimaryColor, size: 30),
        ),
        title: Text("${apartment.first_name} ${apartment.last_name}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black)),
        subtitle: Text(
            "${texts.isAr ? 'تواصل' : 'Contact'}: ${apartment.owner_phone}",
            style: const TextStyle(color: Colors.grey)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _contactCircle(Icons.message),
            const SizedBox(width: 8),
            _contactCircle(Icons.phone),
          ],
        ),
      ),
    );
  }

  Widget _featureIcon(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.08), shape: BoxShape.circle),
          child: Icon(icon, color: kPrimaryColor, size: 22),
        ),
        const SizedBox(height: 6),
        Text(text,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _contactCircle(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          shape: BoxShape.circle, border: Border.all(color: Colors.grey[300]!)),
      child: Icon(icon, color: kPrimaryColor, size: 20),
    );
  }
}
