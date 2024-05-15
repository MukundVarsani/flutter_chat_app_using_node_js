import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotification {
  PushNotification() {
    FirebaseMessaging.onBackgroundMessage(backGroundHandler);
  }
  Future<void> backGroundHandler(RemoteMessage message) async {
    // Vx.log(message.data.toString());
    // Vx.log(message.notification?.title);
  }



  messageOpen(){
     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    Vx.log('onMessageOPende Work');
  });

  }

  
}


class LocalNotification{
  
  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationsSettings =  InitializationSettings(android: androidInitialize,
);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings );
  }

  static Future showBigTextNotification({var id =0,required String title, required String body,
    var payload, required FlutterLocalNotificationsPlugin fln
  } ) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    const AndroidNotificationDetails(
      'you_can_name_it_whater1',
      'channel_name',

      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    var not= NotificationDetails(android: androidPlatformChannelSpecifics,);
    await fln.show(0, title, body,not );
  }
}
