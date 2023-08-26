import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LocalNotificationService {
  // static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // static void initialize() {
  //   // initializationSettings  for Android
  //   const InitializationSettings initializationSettings =
  //       InitializationSettings(
  //     android: AndroidInitializationSettings("@mipmap/ic_launcher"),
  //   );

  //   _notificationsPlugin.initialize(
  //     initializationSettings,
  //   );
  // }

  static void initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // DrawinIniti

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    // bool? initialized =
    // await notificationsPlugin.initialize(initializationSettings);

    // print('initialize----> $initialized');

    // _notificationsPlugin.initialize(
    //   initializationSettings,
    //   onDidReceiveNotificationResponse: (details) {
    //     print(details);
    //   },
    // );
  }

  static void displayAndNotication() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('brokr-in', 'Channel name',
            channelDescription: 'Channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await notificationsPlugin.show(
        0, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            "brokr-in", "pushnotificationappchannel",
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher'),
      );

      await notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['_id'],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (notificationResponse.payload != null) {
    print('======notification payload: $payload');
  }
}
