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
      }).catchError((e) {
        debugPrint("Backend logout background error: $e");
      });
    }

  } catch (e) {
    debugPrint("Logout Error: $e");
    if (context.mounted) {
       Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  LoginPage()),
        (route) => false,
      );
    }
  }
}

  void _showEditDialog(BuildContext context, UserModel user, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Theme.of(context).dividerColor),
        ),
        title: Text(
          "Edit Information",
          style: TextStyle(color: isDark ? Colors.white : Theme.of(context).primaryColor),
        ),
        content: const Text(
          "Would you like to update your details?",
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor),
            child: const Text("Edit", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
       
              
            

          Column(
            children: [
              const CustomAppBar(title: "My Profile"),
              Expanded(
                child: profileAsync.when(
                  loading: () => Center(
                    child: CircularProgressIndicator(color: theme.primaryColor),
                  ),
                  error: (err, stack) => Center(child: Text("Error: $err")),
                  data: (user) {
                    if (user == null) return const Center(child: Text("No User Data"));
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          _buildEnhancedHeader(context, user, isDark),
                          const SizedBox(height: 35),
                          _buildSectionTitle(context, "Account Settings"),
                          _buildSettingsList(context, ref, isDark, user),
                          const SizedBox(height: 30),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
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
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(isDark ? 0.3 : 0.1),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 58,
              backgroundColor: isDark ? Colors.white.withOpacity(0.2) : theme.primaryColor,
              child: CircleAvatar(
                radius: 54,
                backgroundColor: theme.cardColor,
                backgroundImage: user.personalPhoto != null ? NetworkImage(user.personalPhoto!) : null,
                child: user.personalPhoto == null
                    ? Icon(Icons.person, size: 50, color: isDark ? Colors.white : theme.primaryColor)
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          "${user.firstName} ${user.lastName}",
          style: theme.textTheme.displayLarge?.copyWith(fontSize: 26),
        ),
        const SizedBox(height: 25),
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
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.phone_iphone_rounded, size: 20, color: theme.primaryColor),
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

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 25, bottom: 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 14,
            letterSpacing: 1.2,
            color: theme.brightness == Brightness.dark ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context, WidgetRef ref, bool isDark, UserModel user) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor, width: 1.2), 
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuTile(
            context: context,
            icon: Icons.edit_note_rounded,
            title: "Edit My Information",
            isDark: isDark,
            onTap: () => _showEditDialog(context, user, isDark),
          ),
          _divider(context),
          _buildMenuTile(
            context: context,
            icon: Icons.bookmark_border_rounded,
            title: "My Bookings",
            isDark: isDark,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyBookingsScreen()),
            ),
          ),
          _divider(context),
          _buildMenuTile(
            context: context,
            icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            title: isDark ? "Dark Mode" : "Light Mode",
            isDark: isDark,
            trailing: Switch.adaptive(
              value: isDark,
              activeColor: theme.primaryColor,
              onChanged: (val) => ref.read(themeProvider.notifier).toggleTheme(),
            ),
            onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
          _divider(context),
          _buildMenuTile(
            context: context,
            icon: Icons.power_settings_new_rounded,
            title: "Log Out",
            isDark: isDark,
            isDestructive: true,
            onTap: () => _showLogoutDialog(context, ref, isDark),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Theme.of(context).dividerColor), 
        ),
        title: const Text("Logout"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("No")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              handleLogout(context, ref);
            },
            child: const Text("Yes", style: TextStyle(color: Colors.red)),
          ),
        ],
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Icon(
        icon,
        color: isDestructive ? Colors.redAccent : theme.primaryColor,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: isDestructive ? Colors.redAccent : (isDark ? Colors.white : Colors.black87),
        ),
      ),
      trailing: trailing ??
          Icon(Icons.chevron_right_rounded,
              color: isDark ? Colors.white24 : Colors.grey[400]),
    );
  }

  Widget _divider(BuildContext context) => Divider(
        height: 1,
        indent: 25,
        endIndent: 25,
        color: Theme.of(context).dividerColor,  
      );
}