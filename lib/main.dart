import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/firebase/Hive/timestamp.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/pages/add_inventory.dart';
import 'package:yes_broker/pages/add_lead.dart';
import 'package:yes_broker/pages/add_todo.dart';
import 'package:yes_broker/pages/largescreen_dashboard.dart';
import 'package:yes_broker/routes/routes.dart';

import 'firebase_options.dart';
import 'package:yes_broker/constants/utils/theme.dart';
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
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final routerDelegate = BeamerDelegate(
    setBrowserTabTitle: false,
    notFoundPage: const BeamPage(child: LayoutView()),
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/': (p0, p1, p2) => const LayoutView(),
        '/profile': (p0, p1, p2) => const LargeScreen(),
        AppRoutes.addInventory: (p0, p1, p2) => const AddInventory(),
        AppRoutes.addLead: (p0, p1, p2) => const AddLead(),
        AppRoutes.addTodo: (p0, p1, p2) => const AddTodo(),
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return !Responsive.isMobile(context)
        ? MaterialApp.router(
            backButtonDispatcher: BeamerBackButtonDispatcher(delegate: routerDelegate),
            debugShowCheckedModeBanner: false,
            title: 'Brokr',
            theme: TAppTheme.lightTheme,
            routeInformationParser: BeamerParser(),
            routerDelegate: routerDelegate,
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Brokr',
            theme: TAppTheme.lightTheme,
            home: const LayoutView(),
            routes: AppRoutes.routesTable,
          );
  }
}
