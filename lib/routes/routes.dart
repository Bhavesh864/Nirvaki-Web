import 'package:flutter/material.dart';

// Flutter Packages Imports
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:yes_broker/pages/Auth/login_screen.dart';
import 'package:yes_broker/pages/add_workitems.dart';

// Local Files Imports
import '../Customs/responsive.dart';
import '../screens/main_screens/caledar_screen.dart';
import '../screens/main_screens/chat_screen.dart';
import '../screens/main_screens/home_screen.dart';
import '../screens/main_screens/inventroy_screen.dart';
import '../screens/main_screens/lead_screen.dart';
import '../screens/main_screens/todo_screen.dart';
import '../constants/utils/constants.dart';
import '../pages/Auth/forget_password.dart';
import '../pages/add_inventory.dart';
import '../pages/add_lead.dart';
import '../pages/largescreen_dashboard.dart';
import '../pages/smallscreen_dashboard.dart';
import '../screens/account_screens/profile_screen.dart';
import '../widgets/calendar_view.dart';
import '../widgets/todo/todo_list_view.dart';

// labels
const homeScreenPageLabel = 'Home';
const todoPageLabel = 'Todo';
const inventoryPageLabel = 'Inventory';
const leadPageLabel = 'Lead';
const calendarPageLabel = 'Calendar';
const chatPageLabel = 'Chat';
const profilePageLabel = 'Profile';

// icons
const IconData homeIcon = Icons.home_outlined;
const IconData todoIcon = Icons.list_outlined;
const IconData inventoryIcon = MaterialSymbols.location_home;
const IconData leadIcon = MaterialSymbols.location_away;
const IconData chatIcon = Icons.chat_outlined;
const IconData calendarIcon = Icons.calendar_month_outlined;

List<MenuItem> sideBarItems = [
  MenuItem(
    label: homeScreenPageLabel,
    iconData: homeIcon,
    screen: const HomeScreen(),
  ),
  MenuItem(
    label: todoPageLabel,
    iconData: todoIcon,
    screen: const TodoTabScreen(),
  ),
  MenuItem(
    label: inventoryPageLabel,
    iconData: inventoryIcon,
    screen: const InventoryScreen(),
  ),
  MenuItem(
    label: leadPageLabel,
    iconData: leadIcon,
    screen: const LeadScreen(),
  ),
  MenuItem(
    label: calendarPageLabel,
    iconData: chatIcon,
    screen: const ChatScreen(),
  ),
  MenuItem(
    label: chatPageLabel,
    iconData: calendarIcon,
    screen: const CalendarScreen(),
  ),
  MenuItem(
    label: profilePageLabel,
    screen: const ProfileScreen(),
  ),
];

List<BottomBarItem> bottomBarItems = [
  BottomBarItem(
    label: homeScreenPageLabel,
    iconData: homeIcon,
    screen: const SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          CustomCalendarView(),
          TodoListView(),
        ],
      ),
    ),
  ),
  BottomBarItem(
    label: inventoryPageLabel,
    iconData: inventoryIcon,
    screen: const InventoryScreen(),
  ),
  BottomBarItem(
    label: leadPageLabel,
    iconData: leadIcon,
    screen: const LeadScreen(),
  ),
  BottomBarItem(
    label: chatPageLabel,
    iconData: chatIcon,
    screen: const ChatScreen(),
  ),
];

class AppRoutes {
  static const String homeScreen = '/home_screen';
  static const String forgetPassword = '/forget_password_screen';
  static const String loginScreen = '/login_screen';
  static const String profileScreen = '/profile_screen';
  static const String addInventory = '/add_inventory_screen';
  static const String addLead = '/add_lead_screen';
  static const String addWorkItem = '/add_workItem_screen';

  static Map<String, WidgetBuilder> routesTable = {
    homeScreen: (context) => Responsive.isMobile(context) ? const SmallScreen() : const LargeScreen(),
    loginScreen: (context) => const LoginScreen(),
    forgetPassword: (context) => const ForgetPassword(),
    profileScreen: (context) => const ProfileScreen(),
    addInventory: (context) => const AddInventory(),
    addLead: (context) => const AddLead(),
    addWorkItem: (context) => const AddWorkItem(),
  };
}
