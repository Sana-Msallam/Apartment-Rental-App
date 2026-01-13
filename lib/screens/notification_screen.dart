import 'package:apartment_rental_app/constants/app_string.dart';
import 'package:apartment_rental_app/providers/notificatios_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final texts = ref.watch(stringsProvider);
    final notificationsAsync = ref.watch(notificationsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: CustomAppBar(title: texts.notifications),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: notificationsAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: theme.primaryColor),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error', style: AppConstants.textNoData),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Text(
                texts.noNotifications,
                style: AppConstants.textNoData,
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(notificationsProvider.notifier).fetchNotification(),
            color: AppConstants.primaryColor,
            child: ListView.builder(
              itemCount: notifications.length,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: notification.isRead
                        ? (isDark ? theme.cardColor : Colors.white)
                        : (isDark
                            ? theme.primaryColor.withOpacity(0.15)
                            : theme.primaryColor.withOpacity(0.05)),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.grey.shade100,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],

                    
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: notification.isRead
                          ? (isDark ? Colors.white10 : Colors.grey.shade100)
                          : theme.primaryColor.withOpacity(0.1),
                      child: Icon(
                        notification.isRead
                            ? Icons.notifications_none
                            : Icons.notifications_active,
                        color: notification.isRead
                            ? (isDark ? Colors.grey : Colors.grey)
                            : theme.primaryColor,
                      ),
                    ),
                    title: Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: notification.isRead
                            ? FontWeight.normal: FontWeight.bold,
                        fontSize: 15,
                        color:
                            isDark ? Colors.white : AppConstants.primaryColor,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        notification.body,
                        style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.grey.shade700, fontSize: 13),
                      ),
                    ),
                    trailing: Text(
                      "${notification.createdAt.hour}:${notification.createdAt.minute}",
                      style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey),
                    ),
                    onTap: () {
                      if (!notification.isRead) {
                        ref
                            .read(notificationsProvider.notifier)
                            .markAsRead(notification.id);
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}