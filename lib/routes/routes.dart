import 'package:flutter/material.dart';
import 'package:yes_broker/TabScreens/main_screens/home_screen.dart';

import '../Customs/responsive.dart';
import '../TabScreens/account_screens/profile_screen.dart';
import '../pages/Auth/forget_password.dart';
import '../pages/add_inventory.dart';
import '../pages/largescreen_dashboard.dart';
import '../pages/smallscreen_dashboard.dart';

const HomeScreenPageRoute = 'Home';
const TodoPageRoute = 'Todo';
const InventoryPageRoute = 'Inventory';
const LeadPageRoute = 'Lead';
const CalendarPageRoute = 'Calendar';
const ChatPageRoute = 'Chat';

List menuItems = [
  HomeScreenPageRoute,
  TodoPageRoute,
  InventoryPageRoute,
  LeadPageRoute,
  CalendarPageRoute,
  ChatPageRoute,
];

class AppRoutes {
  // static const String homeScreen = '/home_screen';
  // static const String forgetPassword = '/home_screen';
  // static const String profileScreen = '/home_screen';
  // static const String addInventory = '/home_screen';

  static Map<String, WidgetBuilder> routes = {
    // filtersScreen: (context) => FiltersScreen()
    HomeScreen.routeName: (context) =>
        Responsive.isMobile(context) ? SmallScreen() : LargeScreen(),
    ForgetPassword.routeName: (context) => const ForgetPassword(),
    ProfileScreen.routeName: (context) => const ProfileScreen(),
    AddInventory.routeName: (context) => AddInventory(),
  };
}
