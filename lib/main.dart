import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/firebase/Hive/timestamp.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/pages/Auth/signup/company_details.dart';
import 'package:yes_broker/pages/Auth/signup/personal_details.dart';
import 'package:yes_broker/pages/Auth/signup/signup_screen.dart';
import 'package:yes_broker/pages/add_inventory.dart';
import 'package:yes_broker/pages/add_lead.dart';
import 'package:yes_broker/pages/add_todo.dart';
import 'package:yes_broker/pages/edit_todo.dart';
import 'package:yes_broker/pages/largescreen_dashboard.dart';
import 'package:yes_broker/routes/routes.dart';

import 'firebase_options.dart';
import 'package:yes_broker/constants/utils/theme.dart';
import 'package:yes_broker/layout.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        AppRoutes.editTodo: (p0, p1, data) {
          return const EditTodo();
        },
        AppRoutes.singupscreen: (p0, p1, p2) => const SignUpScreen(),
        AppRoutes.personalDetailsScreen: (p0, p1, p2) => const PersonalDetailsAuthScreen(),
        AppRoutes.companyDetailsScreen: (p0, p1, p2) => const CompanyDetailsAuthScreen(),
      },
    ),
  );

  @override
  void initState() {
    super.initState();
  }

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
