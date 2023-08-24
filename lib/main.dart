import 'package:beamer/beamer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/adapters.dart';
import 'firebase_options.dart';

import 'package:yes_broker/constants/firebase/Hive/timestamp.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/routes/routes.dart';
import 'constants/notification/app_notification.dart';
import 'package:yes_broker/constants/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  getToken();
  await setupFlutterNotifications();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await Hive.initFlutter();
  Hive.registerAdapter(TimestampAdapter());
  await Hive.openBox("users");
  await Hive.openBox<CardDetails>("carddetails");

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return !Responsive.isMobile(context)
    return MaterialApp.router(
      backButtonDispatcher: BeamerBackButtonDispatcher(delegate: routerDelegate),
      debugShowCheckedModeBanner: false,
      title: 'Brokr',
      theme: TAppTheme.lightTheme,
      routeInformationParser: BeamerParser(),
      routerDelegate: routerDelegate,
    );
    // : MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     title: 'Brokr',
    //     theme: TAppTheme.lightTheme,
    //     home: const LayoutView(),
    //     routes: AppRoutes.routesTable,
    //   );
  }
}

// Future<void> setupnotification() async {
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description: 'This channel is used for important notifications.', // description
//     importance: Importance.max,
//   );
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     if (notification != null && android != null) {
//       flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               channelDescription: channel.description,
//               icon: android.smallIcon,
//             ),
//           ));
//     }
//   });
// }
