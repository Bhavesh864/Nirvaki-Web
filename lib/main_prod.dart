import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:yes_broker/prod/firebase_options.dart';
import 'constants/notification/app_notification.dart';
import 'package:yes_broker/constants/firebase/Hive/timestamp.dart';
import 'main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  if (kIsWeb) {
    await firestore.enablePersistence(const PersistenceSettings(synchronizeTabs: true));
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
  Hive.registerAdapter(TimestampAdapter());
  await Hive.openBox("users");
  await Hive.openBox("organization");

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
