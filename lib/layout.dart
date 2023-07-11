import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/pages/Auth/login_screen.dart';

class LayoutView extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  LayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ScreenTypeLayout.builder(
        breakpoints:
            const ScreenBreakpoints(desktop: 1366, tablet: 768, watch: 360),
        mobile: (p0) => const LoginScreen(),
        tablet: (p0) => const LoginScreen(),
        desktop: (p0) => const LoginScreen(),
      ),
    );
  }
}
