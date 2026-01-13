import 'package:apartment_rental_app/models/notification_model.dart';
import 'package:apartment_rental_app/services/api_client.dart';

class NotificationService {
  final ApiClient _apiClient;

  NotificationService(this._apiClient);

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _apiClient.dio.get('notifications'); // الرابط من الباك إند
      
      if (response.statusCode == 200) {
        final List notificationsData = response.data['data'];
        return notificationsData.map((json) => NotificationModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markRead(String id) async {
    try {
      await _apiClient.dio.post('notifications/$id/read'); 
    } catch (e) {
      rethrow;
    }
  }
  Future<int> getUnreadCount() async{
    try{
      final response = await _apiClient.dio.get('notifications/unread');
      if(response.statusCode== 200){
        return response.data['unread_count']?? 0;
      }
      return 0;
    }catch(e){
      return 0;
    }
  }
}