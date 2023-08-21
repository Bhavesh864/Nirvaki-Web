import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:responsive_builder/responsive_builder.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/Hive/hive_methods.dart';
import 'package:yes_broker/constants/firebase/userModel/broker_info.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/pages/Auth/login/login_screen.dart';
import 'package:yes_broker/pages/largescreen_dashboard.dart';
import 'package:yes_broker/pages/smallscreen_dashboard.dart';
import 'package:yes_broker/screens/main_screens/public_view_screen/public_inventory_details.dart';
import 'package:yes_broker/screens/main_screens/public_view_screen/public_lead_details.dart';

class LayoutView extends StatefulWidget {
  const LayoutView({super.key});

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  Stream<User?>? authState;

  @override
  void initState() {
    super.initState();
    final token = UserHiveMethods.getdata("token");
    authState = authentication.authStateChanges();
    if (token != null) {
      AppConst.setAccessToken(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: authState,
      builder: (context, snapshot) {
        AppConst.setIsAuthenticated(snapshot.hasData ? true : false);

        return Scaffold(
          body: ScreenTypeLayout.builder(
            breakpoints: const ScreenBreakpoints(desktop: 1366, tablet: 768, watch: 360),
            mobile: (p0) => _buildMobileLayout(snapshot.hasData),
            tablet: (p0) => _buildTabletLayout(snapshot.hasData),
            desktop: (p0) => _buildDesktopLayout(snapshot.hasData),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(bool isAuthenticated) {
    print('is Auth ------$isAuthenticated');
    if (isAuthenticated) {
      return const SmallScreen();
    } else {
      return const LoginScreen();
    }
  }

  Widget _buildTabletLayout(bool isAuthenticated) {
    if (isAuthenticated) {
      return const LargeScreen();
    } else {
      final location = Beamer.of(context).currentBeamLocation.state.routeInformation.location!;

      if (location.isNotEmpty && location.contains('inventory-details')) {
        return PublicViewInventoryDetails(
          inventoryId: extractItemIdFromPath(location, 'inventory')!,
        );
      } else if (location.isNotEmpty && location.contains('lead-details')) {
        return PublicViewLeadDetails(
          leadId: extractItemIdFromPath(location, 'lead')!,
        );
      }
      return const LoginScreen();
    }
  }

  Widget _buildDesktopLayout(bool isAuthenticated) {
    if (isAuthenticated) {
      return const LargeScreen();
    } else {
      final location = Beamer.of(context).currentBeamLocation.state.routeInformation.location!;

      if (location.isNotEmpty && location.contains('inventory-details')) {
        AppConst.setPublicView(true);
        return PublicViewInventoryDetails(
          inventoryId: extractItemIdFromPath(location, 'inventory')!,
        );
      } else if (location.isNotEmpty && location.contains('lead-details')) {
        AppConst.setPublicView(true);

        return PublicViewLeadDetails(
          leadId: extractItemIdFromPath(location, 'lead')!,
        );
      }
      return const LoginScreen();
    }
  }
}

String? extractItemIdFromPath(String path, String itemType) {
  List<String> segments = Uri.parse(path).pathSegments;

  if (segments.length >= 3 && segments[0] == itemType && segments[1] == '$itemType-details') {
    String itemId = segments[2];
    return itemId;
  } else {
    return null;
  }
}
