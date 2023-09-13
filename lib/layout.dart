import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:yes_broker/chat/controller/chat_controller.dart';

import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/Hive/hive_methods.dart';
import 'package:yes_broker/constants/firebase/userModel/broker_info.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/pages/Auth/login/login_screen.dart';
import 'package:yes_broker/pages/largescreen_dashboard.dart';
import 'package:yes_broker/pages/smallscreen_dashboard.dart';
import 'package:yes_broker/screens/main_screens/public_view_screen/public_inventory_details.dart';
import 'package:yes_broker/screens/main_screens/public_view_screen/public_lead_details.dart';

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

    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(chatControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(chatControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    final token = UserHiveMethods.getdata("token");
    authState = authentication.authStateChanges();
    if (token != null) {
      AppConst.setAccessToken(token);
    }
    setAllNotification();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // void showNotification() async {
  //   AndroidNotificationDetails androidDetails = const AndroidNotificationDetails('brokr', 'Chat app', priority: Priority.max, importance: Importance.high);
  //   NotificationDetails notifyDetails = NotificationDetails(android: androidDetails);
  //   print("Before showNotification");
  //   await notificationsPlugin.show(0, 'Chat App Title', 'This is body', notifyDetails);
  //   print("After showNotification");
  // }

  // setupnotification() async {
  //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //   const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
  //   const DarwinInitializationSettings darwinInitializationSettings = DarwinInitializationSettings();
  //   const InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings, iOS: darwinInitializationSettings);
  //   const AndroidNotificationChannel channel = AndroidNotificationChannel(
  //     'high_importance_channel', // id
  //     'High Importance Notifications', // title
  //     description: 'This channel is used for important notifications.', // description
  //     importance: Importance.max,
  //   );
  //   createChannel(channel);

  //   flutterLocalNotificationsPlugin.initialize(initializationSettings);

  //   FirebaseMessaging.onMessage.listen((event) async {
  //     final notication = event.notification;
  //     final android = event.notification?.android;
  //     if (notication != null && android != null) {
  //       flutterLocalNotificationsPlugin.show(
  //         notication.hashCode,
  //         notication.title,
  //         notication.body,
  //         NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             channel.id,
  //             channel.name,
  //             channelDescription: channel.description,
  //           ),
  //         ),
  //       );
  //     }
  //   });
  // }

  // void createChannel(AndroidNotificationChannel channel) async {
  //   final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
  //   await plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  // }

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
