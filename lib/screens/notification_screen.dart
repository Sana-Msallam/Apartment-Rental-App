import 'package:apartment_rental_app/providers/notificatios_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
 class NotificationScreen extends ConsumerWidget{
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);
    return Scaffold(
      appBar: const CustomAppBar(title: 'Notifications'),
    backgroundColor: Colors.white,
      body: notificationsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppConstants.primaryColor),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error', style: AppConstants.textNoData),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Text(
                'No notifications',
                style: AppConstants.textNoData,
              ),
            );
          }
        return RefreshIndicator(
            onRefresh: () => ref.read(notificationsProvider.notifier).fetchNotification(),
            color: AppConstants.primaryColor,
            child: ListView.builder(
              itemCount: notifications.length,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: notification.isRead ? Colors.white : AppConstants.primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: notification.isRead ? Colors.grey.shade100 : AppConstants.primaryColor.withOpacity(0.1),
                      child: Icon(
                        notification.isRead ? Icons.notifications_none : Icons.notifications_active,
                        color: notification.isRead ? Colors.grey : AppConstants.primaryColor,
                      ),
                    ),
                    title: Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                        fontSize: 15,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        notification.body,
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                      ),
                    ),
                    trailing: Text(
                      "${notification.createdAt.hour}:${notification.createdAt.minute}",
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    onTap: () {
                      if (!notification.isRead) {
                        ref.read(notificationsProvider.notifier).markAsRead(notification.id);
                      }
                      // هنا يمكنك إضافة توجيه المستخدم لصفحة الحجز إذا كان الإشعار يخص حجز معين
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