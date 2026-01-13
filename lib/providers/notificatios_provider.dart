import 'package:apartment_rental_app/models/notification_model.dart';
import 'package:apartment_rental_app/providers/apartment_home_provider.dart';
import 'package:apartment_rental_app/services/notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider= Provider((ref)=> NotificationService(ref.watch(apiClientProvider)));
final unreadCountProvider= StateProvider<int>((ref)=>0);


final notificationsProvider = StateNotifierProvider<NotificationNotifier, AsyncValue<List<NotificationModel>>>((ref){
  final service = ref.watch(notificationServiceProvider);
  return NotificationNotifier(service, ref)..fetchNotification();
});

class NotificationNotifier extends StateNotifier<AsyncValue<List<NotificationModel>>>{
  final NotificationService _service;
  final Ref ref;

  NotificationNotifier(this._service, this.ref): super(const AsyncValue.loading());

  Future<void> fetchNotification() async {
    state = const AsyncValue.loading();
    try{
      final list = await _service.getNotifications();
      state= AsyncValue.data(list);
      final unreadCount = list.where((n) => !n.isRead).length;
      ref.read(unreadCountProvider.notifier).state = unreadCount;
    } catch(e,stack){
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refreshUnreadCount() async {
    try {
      final count = await _service.getUnreadCount();
      ref.read(unreadCountProvider.notifier).state = count;
    } catch (e) {
      print("Error updating count: $e");
    }
  }

  Future<void> markAsRead(String id) async {
    try{
    await _service.markRead(id);

   final currentState = ref.read(unreadCountProvider);
      if (currentState > 0) {
        ref.read(unreadCountProvider.notifier).state = currentState - 1;
      }
      
      fetchNotification();
      } catch (e) {
        print("Error marking as read: $e");    }
  }
}
