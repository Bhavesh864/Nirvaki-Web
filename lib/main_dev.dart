import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cron/cron.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/adapters.dart';
import 'dev/firebase_options.dart';
import 'constants/notification/app_notification.dart';
import 'package:yes_broker/constants/firebase/Hive/timestamp.dart';
import 'main.dart';
import 'dart:html' as html;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  if (kIsWeb) {
    // await firestore.enablePersistence(const PersistenceSettings(synchronizeTabs: true));
  } else {
    firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  getToken();
  await setupFlutterNotifications();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await Hive.initFlutter();
  setUpBrowserNavigationListener();
  Hive.registerAdapter(TimestampAdapter());
  await Hive.openBox("users");
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// void setUpBrowserNavigationListener() {
//   // Add a listener to the browser's history navigation event
//   html.window.onPopState.listen((html.PopStateEvent event) {
//     // Perform actions when the user navigates back or forward in the browser
//     // This function will be called when the user clicks the browser's back or forward button
//     // Add your code to handle the navigation event here
//     print('Browser navigation event detected: ${event.state}');

//     // You can call your specific task or function here upon back/forward navigation
//     // For example:
//     // performSpecificTask();
//   });
// }

void setUpBrowserNavigationListener() {
  // Add a listener to the browser's history navigation event
  html.window.onPopState.listen((html.PopStateEvent event) {
    // Prevent the default behavior of navigating back or forward
    html.window.history.pushState(null, '', html.window.location.href);

    // Perform actions or show a message when the user tries to navigate back or forward
    print('Browser navigation event detected: ${event.state}');
    print('You cannot navigate back or forward in this app.');
    // You can also trigger other actions here based on your app's requirements
  });
}
