import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/userModel/notification_model.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  // await showFlutterNotification(message);
  // // If you're going to use other Firebase services in the background, such as Firestore,
  // // make sure you call `initializeApp` before using other Firebase services.
  if (message.notification != null) {
    NotificationModel notificationModel = NotificationModel(
      title: message.notification?.title,
      notificationContent: message.notification?.body,
      receiveDate: Timestamp.now(),
      linkedItemId: message.data["id"],
      imageUrl: message.data["imageUrl"],
      userId: AppConst.getAccessToken(),
    );
    await NotificationModel.addNotification(notificationModel);
  }
  if (kDebugMode) {
    print('Handling a background message ${message.notification}');
  }
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

Future<void> showFlutterNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id.toString(),
          channel.name.toString(),
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
          ticker: 'ticker',
        ),
      ),
    );
  }
}

/// Renders the example application.

FirebaseMessaging messaging = FirebaseMessaging.instance;

Future<void> setAllNotification() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    await showFlutterNotification(message);
    if (message.notification != null) {
      NotificationModel notificationModel = NotificationModel(
        title: message.notification?.title,
        notificationContent: message.notification?.body,
        receiveDate: Timestamp.now(),
        linkedItemId: message.data["id"],
        imageUrl: message.data["imageUrl"],
        userId: AppConst.getAccessToken(),
      );
      await NotificationModel.addNotification(notificationModel);
    }
    if (kDebugMode) {
      print('handling a foreground app $message');
    }
  });
}

Future<NotificationSettings> requestPermissions() async {
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (kDebugMode) {
    print('User granted permission: ${settings.authorizationStatus}');
  }
  return settings;
}

Future<String?> getToken() async {
  try {
    final setting = await requestPermissions();
    if (setting.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await messaging.getToken(vapidKey: "BI8BYeg_2RdKlfKGL0EdOZ1s3WUdp8pPE449gusmPFsQ1-DC_l_Z7B6o0aJvI5ANVO19udscj4RDKCNTHHZKoUA");
      if (kDebugMode) {
        print('FCM token: $token');
      }
      AppConst.setFcmToken(token!);
      return token;
    }
    return null;
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  return null;
}

Future<void> setupInteractedMessage() async {
  // Get any messages which caused the application to open from
  // a terminated state.
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  // If the message also contains a data property with a "type" of "chat",
  // navigate to a chat screen
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }
  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

void _handleMessage(RemoteMessage message) {
  if (message.data['type'] == 'chat') {
    // Navigator.pushNamed(context, '/chat',
    //   arguments: ChatArguments(message),
    // );
  }
}
