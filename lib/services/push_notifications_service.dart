import 'dart:developer';

import 'package:apartment_rental_app/services/local_notifications_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class PushNotificationsService {
 static FirebaseMessaging messaging= FirebaseMessaging.instance;
 
 static Future init() async{
  await messaging.requestPermission();
  String? token= await messaging.getToken();
  log(token ?? 'null'); 
  FirebaseMessaging.onBackgroundMessage(handlebackgroundMessage);
  //foreground
  handleForegroundMessage();
 
 }
 static  Future<void> handlebackgroundMessage(RemoteMessage message) async{
  await Firebase.initializeApp();
  log(message.notification?.title?? 'null');
 }
 static void handleForegroundMessage() async{
   FirebaseMessaging.onMessage.listen(
    (RemoteMessage message){
  //Local
  LocalNotificationService.showBasicNotification(
    message,
  );
 });
 }
}