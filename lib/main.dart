import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:hive_flutter/adapters.dart';
import 'firebase_options.dart';
import 'package:yes_broker/constants/utils/theme.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    // options: FirebaseOptions(apiKey: apiKey, appId: appId, messagingSenderId: messagingSenderId, projectId: projectId)
  );
  await Hive.initFlutter();
  await Hive.openBox('users');
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
