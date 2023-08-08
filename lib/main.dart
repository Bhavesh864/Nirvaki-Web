import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:yes_broker/constants/firebase/Hive/hive_methods.dart';
import 'package:yes_broker/constants/firebase/Hive/timestamp.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';

import 'firebase_options.dart';
import 'package:yes_broker/constants/utils/theme.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/layout.dart';

//View agenda outline; ------------------- Icon for timelinetab

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brokr',
      theme: TAppTheme.lightTheme,
      home: LayoutView(),
      routes: AppRoutes.routesTable,
    );
  }
}
