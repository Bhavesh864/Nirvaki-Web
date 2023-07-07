import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/TabScreens/account_screens/profile_screen.dart';
import 'package:yes_broker/TabScreens/main_screens/home_screen.dart';
import 'package:yes_broker/constants/colors.dart';

import 'package:yes_broker/layout.dart';
import 'package:yes_broker/pages/Auth/forget_password.dart';
import 'package:yes_broker/pages/add_inventory.dart';
import 'package:yes_broker/pages/largescreen_dashboard.dart';
import 'package:yes_broker/pages/smallscreen_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: const MaterialColor(
          0xFF4460EF,
          <int, Color>{
            50: Color(0x1A4460EF),
            100: Color(0x334460EF),
            200: Color(0x4D4460EF),
            300: Color(0x664460EF),
            400: Color(0x804460EF),
            500: Color(0xFF4460EF),
            600: Color(0x994460EF),
            700: Color(0xB34460EF),
            800: Color(0xCC4460EF),
            900: Color(0xE64460EF),
          },
        ),
        textTheme: GoogleFonts.dmSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: LayoutView(),
      routes: {
        HomeScreen.routeName: (context) =>
            Responsive.isMobile(context) ? SmallScreen() : LargeScreen(),
        ForgetPassword.routeName: (context) => const ForgetPassword(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        AddInventory.routeName: (context) => const AddInventory(),
      },
    );
  }
}
