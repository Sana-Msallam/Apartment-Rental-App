import 'package:apartment_rental_app/constants/app_string.dart';
import 'package:apartment_rental_app/controller/ThemeNotifier_controller.dart';
import 'package:apartment_rental_app/controller/profile_controller.dart';
import 'package:apartment_rental_app/models/user_model.dart';
import 'package:apartment_rental_app/screens/log_in.dart';
import 'package:apartment_rental_app/screens/my_bookings_screen.dart';
import 'package:apartment_rental_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets/custom_app_bar.dart';

const Color kPrimaryColor = Color(0xFF234F68);

// دالة تسجيل الخروج الموحدة والمحسنة
Future<void> handleLogout(BuildContext context, WidgetRef ref) async {
  try {
    final storage = ref.read(storageProvider);
    final apiService = ref.read(apiServiceProvider);

    // 1. جلب التوكن قبل الحذف لإخبار السيرفر
    String? token = await storage.read(key: 'jwt_token');

    // 2. تصفير الحالة محلياً فوراً لسرعة الاستجابة
    await storage.delete(key: 'jwt_token');
    ref.invalidate(profileProvider);

    // 3. الانتقال لصفحة تسجيل الدخول (استخدام pushAndRemoveUntil لمنع الرجوع)
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }

    // 4. إخبار السيرفر في الخلفية (اختياري لا يعطل الانتقال)
    if (token != null) {
      try {
        await apiService.logout();
        debugPrint("Backend logout successful");
      } catch (e) {
        debugPrint("Backend logout failed: $e");
      }
    }
  } catch (e) {
    debugPrint("Logout Error: $e");
  }
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final texts = ref.watch(stringsProvider);
    final isAr = ref.watch(isArabicProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // استخدام CustomAppBar الموحد مع نصوص رفيقتك
      appBar: CustomAppBar(title: texts.profile),
      body: profileAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: theme.primaryColor)),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (user) {
          if (user == null) return Center(child: Text(texts.noData));
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 30),
                _buildEnhancedHeader(context, user, isDark),
                const SizedBox(height: 35),
                _buildSectionTitle(context, texts.accountSettings),
                _buildSettingsList(context, ref, isDark, user, texts, isAr),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedHeader(BuildContext context, UserModel user, bool isDark) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 125, height: 125,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryColor.withOpacity(isDark ? 0.3 : 0.1),
                    blurRadius: 25, spreadRadius: 5,
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 58,
              backgroundColor: isDark ? Colors.white.withOpacity(0.2) : kPrimaryColor,
              child: CircleAvatar(
                radius: 54,
                backgroundColor: theme.cardColor,
                backgroundImage: user.personalPhoto != null && user.personalPhoto!.isNotEmpty 
                    ? NetworkImage(user.personalPhoto!) : null,
                child: user.personalPhoto == null
                    ? Icon(Icons.person, size: 50, color: isDark ? Colors.white : kPrimaryColor)
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          "${user.firstName} ${user.lastName}",
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 25),
        // حاوية رقم الهاتف الأنيقة
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: theme.dividerColor, width: 1.2),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.phone_iphone_rounded, size: 20, color: kPrimaryColor),
                ),
                const SizedBox(width: 15),
                Text(
                  user.phone ?? "No Phone Number",
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsList(BuildContext context, WidgetRef ref, bool isDark, UserModel user, AppStrings texts, bool isAr) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor, width: 1.2),
      ),
      child: Column(
        children: [
          _buildMenuTile(
            context: context,
            icon: Icons.bookmark_border_rounded,
            title: texts.myBookings,
            isDark: isDark,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyBookingsScreen())),
          ),
          _divider(context),
          _buildMenuTile(
            context: context,
            icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            title: isDark ? texts.darkMode : texts.lightMode,
            isDark: isDark,
            trailing: Switch.adaptive(
              value: isDark,
              activeColor: kPrimaryColor,
              onChanged: (val) => ref.read(themeProvider.notifier).toggleTheme(),
            ),
            onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
          _divider(context),
          _buildMenuTile(
            context: context,
            icon: Icons.language_rounded,
            title: isAr ? "اللغة العربية" : "English Language",
            isDark: isDark,
            trailing: Switch.adaptive(
              value: isAr,
              activeColor: kPrimaryColor,
              onChanged: (val) => ref.read(isArabicProvider.notifier).state = val,
            ),
            onTap: () => ref.read(isArabicProvider.notifier).state = !isAr,
          ),
          _divider(context),
          _buildMenuTile(
            context: context,
            icon: Icons.power_settings_new_rounded,
            title: texts.logout,
            isDark: isDark,
            isDestructive: true,
            onTap: () => _showLogoutDialog(context, ref, isDark, texts),
          ),
        ],
      ),
    );
  }

  // دالة الدايلوج المحسنة التي تستخدم Context الصفحة للانتقال
  void _showLogoutDialog(BuildContext pageContext, WidgetRef ref, bool isDark, AppStrings texts) {
    showDialog(
      context: pageContext,
      builder: (dialogContext) => AlertDialog(
        title: Text(texts.logout),
        content: Text(texts.areYouSureLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext), 
            child: Text(texts.no),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // إغلاق الدايلوج أولاً
              handleLogout(pageContext, ref); // الانتقال باستخدام Context الصفحة
            },
            child: Text(texts.yes, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 25, bottom: 15),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
    Widget? trailing,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      leading: Icon(icon, color: isDestructive ? Colors.redAccent : kPrimaryColor),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.redAccent : (isDark ? Colors.white : Colors.black87),
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ?? Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
    );
  }

  Widget _divider(BuildContext context) => Divider(height: 1, indent: 25, endIndent: 25, color: Theme.of(context).dividerColor);
}