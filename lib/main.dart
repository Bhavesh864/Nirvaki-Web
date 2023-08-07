import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:hive_flutter/adapters.dart';
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

// Future<dynamic> dynamicLinksget() async {
//   if (!kIsWeb) {
//     final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

//     if (initialLink != null) {
//       final Uri deepLink = initialLink.link;
//       print(deepLink);
//       // Example of using the dynamic link to push the user to a different screen
//       // Navigator.pushNamed(context, deepLink.path);
//     }
//     FirebaseDynamicLinks.instance.onLink.listen(
//       (pendingDynamicLinkData) {
//         // Set up the `onLink` event listener next as it may be received here

//         final Uri deepLink = pendingDynamicLinkData.link;
//         // Example of using the dynamic link to push the user to a different screen
//         // Navigator.pushNamed(context, deepLink.path);
//       },
//     );
//     return initialLink;
//   }
// }

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
