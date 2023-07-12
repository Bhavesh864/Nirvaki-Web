import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:yes_broker/constants/utils/theme.dart';
import 'package:yes_broker/routes/routes.dart';
import 'firebase_options.dart';
import 'package:yes_broker/layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      routes: AppRoutes.routes,
    );
  }
}
