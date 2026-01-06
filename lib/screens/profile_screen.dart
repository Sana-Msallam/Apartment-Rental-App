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

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> handleLogout(BuildContext context, WidgetRef ref) async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'jwt_token');
      await storage.delete(key: 'jwt_token');
      ref.invalidate(profileProvider);

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }

      if (token != null) {
        ApiService().logout(token).then((success) {
          debugPrint("Backend logout status: $success");
        }).catchError((e) => debugPrint("Backend error: $e"));
      }
    } catch (e) {
      debugPrint("Logout Error: $e");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final texts = ref.watch(stringsProvider);
    final isAr = ref.watch(isArabicProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: texts.profile),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryColor)),
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
        // الصورة الشخصية مع الظل
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryColor.withOpacity(isDark ? 0.3 : 0.1),
                    blurRadius: 25,
                    spreadRadius: 5,
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
                backgroundImage: user.personalPhoto != null ? NetworkImage(user.personalPhoto!) : null,
                child: user.personalPhoto == null
                    ? Icon(Icons.person, size: 50, color: isDark ? Colors.white : kPrimaryColor)
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        // الاسم
        Text(
          "${user.firstName} ${user.lastName}",
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 25),
        // ✅ رقم الهاتف - رجعناه متل ما كان (Container أنيق)
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
          // الحجوزات
          _buildMenuTile(
            context: context,
            icon: Icons.bookmark_border_rounded,
            title: texts.myBookings,
            isDark: isDark,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyBookingsScreen())),
          ),
          _divider(context),
          
          // المود (ليلي / نهاري)
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

          // ✅ زر اللغة - صار Switch مثل المود تماماً
          _buildMenuTile(
            context: context,
            icon: Icons.language_rounded,
            title: isAr ? "اللغة العربية" : "English Language",
            isDark: isDark,
            trailing: Switch.adaptive(
              value: isAr, // بكون On إذا كانت اللغة عربية
              activeColor: kPrimaryColor,
              onChanged: (val) => ref.read(isArabicProvider.notifier).state = val,
            ),
            onTap: () {
              // عند الضغط على الصف كاملاً يقلب الحالة
              ref.read(isArabicProvider.notifier).state = !isAr;
            },
          ),
          _divider(context),

          // تسجيل الخروج
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

  // المساعدة في بناء الواجهة
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
    final theme = Theme.of(context);
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

  void _showLogoutDialog(BuildContext context, WidgetRef ref, bool isDark, AppStrings texts) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(texts.logout),
        content: Text(texts.areYouSureLogout),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(texts.no)),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              handleLogout(context, ref);
            },
            child: Text(texts.yes, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}