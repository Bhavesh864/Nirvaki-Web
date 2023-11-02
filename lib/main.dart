import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/constants/utils/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      backButtonDispatcher: BeamerBackButtonDispatcher(delegate: routerDelegate),
      debugShowCheckedModeBanner: false,
      title: 'Nirvaki',
      theme: TAppTheme.lightTheme,
      routeInformationParser: BeamerParser(),
      routerDelegate: routerDelegate,
    );
  }
}
