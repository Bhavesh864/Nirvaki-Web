import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/TabScreens/main_screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:yes_broker/layout.dart';
import 'package:yes_broker/pages/Auth/forget_password.dart';
import 'package:yes_broker/pages/largescreen_dashboard.dart';
import 'package:yes_broker/pages/smallscreen_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // builder: (context, child) {
      //   return Overlay(
      //     initialEntries: [
      //       OverlayEntry(
      //         builder: (context) => MediaQuery(
      //           data: MediaQuery.of(context)..copyWith(textScaleFactor: .0),
      //           child: LayoutView(),
      //         ),
      //       ),
      //     ],
      //   );
      //   // return MediaQuery(
      //   //   data: MediaQuery.of(context)..copyWith(textScaleFactor: 1.0),
      //   //   child: LayoutView(),
      //   // );
      // },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: LayoutView(),
      routes: {
        HomeScreen.routeName: (context) => Responsive.isMobile(context)
            ? const SmallScreen()
            : const LargeScreen(),
        ForgetPassword.routeName: (context) => const ForgetPassword(),
      },
    );
  }
}
