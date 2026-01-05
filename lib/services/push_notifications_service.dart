import 'dart:developer';
import 'package:apartment_rental_app/services/local_notifications_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart'; 

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  // 1. تهيئة الإشعارات (Permissions & Listeners)
  static Future<void> init() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    }

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    handleForegroundMessage();

    messaging.onTokenRefresh.listen((newToken) async {
      log("FCM Token Refreshed: $newToken");
      await sendTokenToServer(newToken);
    });
  }

  // 2. جلب التوكن الخاص بالجهاز
  static Future<String?> getDeviceToken() async {
    try {
      String? token = await messaging.getToken();
      log("My FCM Token: $token");
      return token;
    } catch (e) {
      log("Error getting device token: $e");
      return null;
    }
  }

  // 3. إرسال التوكن للباك إند
  static Future<void> sendTokenToServer(String fcm_token, {String? authToken}) async {
    try {
      String? finalToken = authToken;
      if (finalToken == null) {
      final prefs = await SharedPreferences.getInstance();
      finalToken = prefs.getString('auth_token');
    }

    if (finalToken == null) {
      log("No auth token found, cannot update FCM on server.");
      return;
    }
      final dio = Dio();
      // إعدادات الـ Header لضمان قبول الطلب من السيرفر
      dio.options.headers["Authorization"] = "Bearer $finalToken";
      dio.options.headers["Accept"] = "application/json";
      
      final response = await dio.post(
        'http://192.168.0.113:8000/api/update-fcm-token', 
        data: {'fcm_token': fcm_token},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("FCM Token updated successfully on server.");
      }
    } catch (e) {
      log("Failed to send FCM token to server: $e");
    }
  }

  // 4. معالجة الإشعارات في الخلفية
  @pragma('vm:entry-point') // ضرورية لضمان عملها في الخلفية
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log("Background Message: ${message.notification?.title}");
  }

  // 5. معالجة الإشعارات والتطبيق مفتوح (Foreground)
  static void handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Foreground Message: ${message.notification?.title}");
      LocalNotificationService.showBasicNotification(message);
    });
  }
}