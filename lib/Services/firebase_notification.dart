import 'package:chat_app_with_backend/Remote/api_client.dart';
import 'package:chat_app_with_backend/Remote/api_endpoints.dart';
import 'package:chat_app_with_backend/Utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotification extends ApiClient {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;


 static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const AndroidInitializationSettings androidInitialize =
      AndroidInitializationSettings('mychat');

  static const DarwinInitializationSettings iosInitializationSettings =
      DarwinInitializationSettings(requestAlertPermission: true);

  // get FCM token from user device

  Future<String> getFCMToken() async {
    await _firebaseMessaging.requestPermission();

    String? fcmToken =
        await FirebaseMessaging.instance.getToken() ?? "Not defined";
    return fcmToken;
  }

  Future<void> sendPushNotification(String msg, String recipientId) async {
    try {
      String userId = await Utils.getUserId();

      Map<String, dynamic> body = {
        "msg": msg,
        "userId": recipientId,
        "recipientId": userId,
      };

      Response response =
          await postRequest(path: ApiEndPoints.sendNotification, body: body);

      dynamic res = response.data;

      if (response.statusCode == 200) {
        Vx.log(res['msg']);
      }
    } catch (e) {
      Vx.log("Error while sending Push Notification ${e.toString()}");
    }
  }

  Future initialize() async {

    const initializationsSettings = InitializationSettings(
        android: androidInitialize, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  Future sendLocalNotification({
    var id = 0,
    required String title,
    required String body,
    var payload,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'you_can_name_it_whater1',
      'channel_name',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: darwinNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails);
  }

 
}
