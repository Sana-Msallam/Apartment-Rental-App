import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
      StreamController();
  static onTap(NotificationResponse notificationResponse) {
    // log(notificationResponse.id!.toString());
    // log(notificationResponse.payload!.toString());
    streamController.add(notificationResponse);
    // Navigator.push(context, route);
  }

  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }
  //basic Notification
  static void  showBasicNotification(RemoteMessage message) async {
    AndroidNotificationDetails android = AndroidNotificationDetails(
      'high_importance_channel', // معرف القناة (يجب أن يكون موحداً)
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high, 
      showWhen: true,
      playSound: true,
    );
    NotificationDetails details = NotificationDetails(
      android: android,
      iOS: DarwinNotificationDetails(),
    );
    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      details,
      payload: jsonEncode(message.data),
    );
  }
}