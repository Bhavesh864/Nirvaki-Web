import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:yes_broker/chat/controller/chat_controller.dart';

import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/Hive/hive_methods.dart';
import 'package:yes_broker/constants/firebase/userModel/broker_info.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/customs/custom_text.dart';
import 'package:yes_broker/pages/Auth/login/login_screen.dart';
import 'package:yes_broker/pages/largescreen_dashboard.dart';
import 'package:yes_broker/pages/smallscreen_dashboard.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';

import 'package:yes_broker/screens/main_screens/public_view_screen/public_inventory_details.dart';
import 'package:yes_broker/screens/main_screens/public_view_screen/public_lead_details.dart';
import 'constants/firebase/userModel/user_info.dart' as userinfo;
import 'constants/notification/app_notification.dart';

class LayoutView extends ConsumerStatefulWidget {
  const LayoutView({super.key});

  @override
  ConsumerState<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends ConsumerState<LayoutView> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  Stream<User?>? authState;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      ref.read(chatControllerProvider).setUserState(true);
    } else {
      ref.read(chatControllerProvider).setUserState(false);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // final token = UserHiveMethods.getdata("token");
    // print("========token-==$token");
    // authState = authentication.authStateChanges();
    // if (token != null) {
    //   AppConst.setAccessToken(token);
    //   getUserData(token);
    // }
    authState = authentication.authStateChanges();
    setAllNotification();
    super.initState();
  }

  // getUserData(token) async {
  //   print("-----------------object----------");
  //   final userinfo.User? user = await userinfo.User.getUser(token);
  //   ref.read(userDataProvider.notifier).storeUserData(user!);
  //   AppConst.setRole(user.role);
  //   print("checking========${user.email}");
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    // return StreamBuilder(
    //   stream: authState,
    //   builder: (context, snapshot) {
    //     AppConst.setIsAuthenticated(snapshot.hasData ? true : false);

    //     return Scaffold(
    //       body: ScreenTypeLayout.builder(
    //         breakpoints: const ScreenBreakpoints(desktop: 1366, tablet: 768, watch: 360),
    //         mobile: (p0) => _buildMobileLayout(snapshot.hasData),
    //         tablet: (p0) => _buildTabletLayout(snapshot.hasData),
    //         desktop: (p0) => _buildDesktopLayout(snapshot.hasData),
    //       ),
    //     );
    //   },
    // );

    return StreamBuilder(
      stream: authState,
      builder: (context, snapshot) {
        AppConst.setIsAuthenticated(snapshot.hasData ? true : false);
        return Scaffold(
          body: OfflineBuilder(
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
            ) {
              final bool connected = connectivity != ConnectivityResult.none;
              if (!connected) {
                ref.read(chatControllerProvider).setUserState(false);
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: CustomText(
                      title: 'You are Offline...Please check your internet connection!',
                      size: 25,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              return ScreenTypeLayout.builder(
                breakpoints: const ScreenBreakpoints(desktop: 1366, tablet: 768, watch: 360),
                mobile: (p0) => _buildMobileLayout(snapshot.hasData),
                tablet: (p0) => _buildTabletLayout(snapshot.hasData),
                desktop: (p0) => _buildDesktopLayout(snapshot.hasData),
              );
            },
            child: const Text('data'),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(bool isAuthenticated) {
    if (isAuthenticated) {
      return const SmallScreen();
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

  Widget _buildTabletLayout(bool isAuthenticated) {
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
