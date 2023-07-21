import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:yes_broker/constants/firebase/userModel/broker_info.dart';

import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/pages/Auth/login_screen.dart';
import 'package:yes_broker/pages/largescreen_dashboard.dart';
import 'package:yes_broker/pages/smallscreen_dashboard.dart';

class LayoutView extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  LayoutView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return StreamBuilder(
        stream: authentication.authStateChanges(),
        builder: (context, snapshot) {
          return Scaffold(
            body: ScreenTypeLayout.builder(
              breakpoints: const ScreenBreakpoints(desktop: 1366, tablet: 768, watch: 360),
              mobile: (p0) => snapshot.hasData ? SmallScreen() : const LoginScreen(),
              tablet: (p0) => snapshot.hasData ? LargeScreen() : const LoginScreen(),
              desktop: (p0) => snapshot.hasData ? LargeScreen() : const LoginScreen(),
            ),
          );
        });
  }
}
