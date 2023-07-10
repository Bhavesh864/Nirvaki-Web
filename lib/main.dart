import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/TabScreens/main_screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yes_broker/constants/colors.dart';
import 'package:yes_broker/constants/theme.dart';
import 'package:yes_broker/pages/add_inventory.dart';
import 'TabScreens/account_screens/profile_screen.dart';
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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: TAppTheme.lightTheme,
      // theme: FlexThemeData.light(
      //   scheme: FlexScheme.materialBaseline,
      //   surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      //   blendLevel: 7,
      //   subThemesData: const FlexSubThemesData(
      //     blendOnLevel: 10,
      //     blendOnColors: false,
      //     useTextTheme: true,
      //     useM2StyleDividerInM3: true,
      //   ),
      //   visualDensity: FlexColorScheme.comfortablePlatformDensity,
      //   useMaterial3: true,
      //   swapLegacyOnMaterial3: true,
      //   fontFamily: GoogleFonts.dmSans().fontFamily,
      // ),
      // darkTheme: FlexThemeData.dark(
      //   scheme: FlexScheme.materialBaseline,
      //   surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      //   blendLevel: 13,
      //   subThemesData: const FlexSubThemesData(
      //     blendOnLevel: 20,
      //     useTextTheme: true,
      //     useM2StyleDividerInM3: true,
      //   ),
      //   visualDensity: FlexColorScheme.comfortablePlatformDensity,
      //   useMaterial3: true,
      //   swapLegacyOnMaterial3: true,
      // ),
      // themeMode: ThemeMode.light,
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
