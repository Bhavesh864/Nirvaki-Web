import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // showFlutterNotification(message);

  AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
      'brokr-in', 'Chat app',
      priority: Priority.max,
      importance: Importance.high,
      icon: "@mipmap/ic_launcher");
  NotificationDetails notifyDetails =
      NotificationDetails(android: androidDetails);
  await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
      message.notification?.body, notifyDetails);

  if (kDebugMode) {
    print('Handling a background message ${message.notification}');
  }
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

// /// Initialize the [FlutterLocalNotificationsPlugin] package.
// late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> setupFlutterNotifications() async {
  if (kIsWeb) {
    return;
  }

  if (!isFlutterLocalNotificationsInitialized) {
    channel = const AndroidNotificationChannel(
      'brokr', // id
      'brokr', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    const initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: darwinInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    isFlutterLocalNotificationsInitialized = true;
  }
}

Future<void> showFlutterNotification(RemoteMessage message) async {
  if (!kIsWeb) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      print("before");
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description, icon: ""),
        ),
      );
      print("after");
    }
  }
}

/// Renders the example application.

FirebaseMessaging messaging = FirebaseMessaging.instance;

Future<void> setAllNotification() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showFlutterNotification(message);
    if (kDebugMode) {
      print('handling a foreground app $message');
    }
  });
}

// FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//   if (kDebugMode) {
//     print('handling a onmessage opened app $message');
//   }
//   showFlutterNotification(message);
// });

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
      String? token = await messaging.getToken();
      if (kDebugMode) {
        print('FCM token==========: $token');
      }
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
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
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
