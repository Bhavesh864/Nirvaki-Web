import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

// class LocalNotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

//   // static void initialize() {
//   //   // initializationSettings  for Android
//   //   const InitializationSettings initializationSettings =
//   //       InitializationSettings(
//   //     android: AndroidInitializationSettings("@mipmap/ic_launcher"),
//   //   );

//   //   _notificationsPlugin.initialize(
//   //     initializationSettings,
//   //   );
//   // }

//   static void initialize() async {
//     AndroidInitializationSettings androidSetting = const AndroidInitializationSettings("@mipmap/ic_launcher");
//     // DrawinIniti

//     InitializationSettings initializationSettings = InitializationSettings(
//       android: androidSetting,
//     );

//     bool? initialized = await notificationsPlugin.initialize(initializationSettings);

//     print('initialize----> $initialized');

//     // _notificationsPlugin.initialize(
//     //   initializationSettings,
//     //   onDidReceiveNotificationResponse: (details) {
//     //     print(details);
//     //   },
//     // );
//   }

//   static void createanddisplaynotification(RemoteMessage message) async {
//     try {
//       final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: AndroidNotificationDetails(
//           "chat_app",
//           "pushnotificationappchannel",
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       );

//       await _notificationsPlugin.show(
//         id,
//         message.notification!.title,
//         message.notification!.body,
//         notificationDetails,
//         payload: message.data['_id'],
//       );
//     } on Exception catch (e) {
//       print(e);
//     }
//   }

// }

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(android: AndroidNotificationDetails('brokr', 'channelName', importance: Importance.max), iOS: DarwinNotificationDetails());
  }

  Future showNotification({int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(id, title, body, await notificationDetails());
  }
}
