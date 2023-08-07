import 'package:flutter/material.dart';

// Flutter Packages Imports
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:yes_broker/pages/Auth/login/login_screen.dart';
import 'package:yes_broker/pages/Auth/signup/personal_details.dart';
import 'package:yes_broker/pages/Auth/set_new_password.dart';
import 'package:yes_broker/pages/Auth/signup/signup_screen.dart';
import 'package:yes_broker/pages/add_todo.dart';
import 'package:yes_broker/pages/add_workitems.dart';
import 'package:yes_broker/screens/main_screens/inventory_details_screen.dart';

// Local Files Imports
import '../Customs/responsive.dart';
import '../pages/Auth/signup/company_details.dart';
import '../screens/main_screens/caledar_screen.dart';
import '../screens/main_screens/chat_screen.dart';
import '../screens/main_screens/home_screen.dart';
import '../screens/main_screens/inventroy_screen.dart';
import '../screens/main_screens/lead_screen.dart';
import '../screens/main_screens/todo_screen.dart';
import '../constants/utils/constants.dart';
import '../pages/Auth/login/forget_password.dart';
import '../pages/add_inventory.dart';
import '../pages/add_lead.dart';
import '../pages/largescreen_dashboard.dart';
import '../pages/smallscreen_dashboard.dart';
import '../screens/account_screens/common_screen.dart';

// labels
const homeScreenPageLabel = 'Home';
const todoPageLabel = 'Todo';
const inventoryPageLabel = 'Inventory';
const leadPageLabel = 'Lead';
const calendarPageLabel = 'Calendar';
const chatPageLabel = 'Chat';
const profilePageLabel = 'Profile';
const teamPageLabel = "Team";
const inventoryDetailsLabel = 'InventoryDetails';

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
    screen: const CommonScreen(),
  ),
  MenuItem(
    label: profilePageLabel,
    screen: const InventoryDetailsScreen(),
  ),
];

List<BottomBarItem> bottomBarItems = [
  BottomBarItem(
    label: homeScreenPageLabel,
    iconData: homeIcon,
    screen: const TodoTabScreen(),
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
  static const String singupscreen = '/signup_screen';
  static const String personalDetailsScreen = '/personal_details_screen';
  static const String companyDetailsScreen = '/company_details_screen';
  static const String inventoryDetailsScreen = '/inventory_details_screen';

  static const String addInventory = '/add_inventory_screen';
  static const String addLead = '/add_lead_screen';
  static const String addWorkItem = '/add_workItem_screen';
  static const String addTodo = '/add_todoItem_screen';
  static const String setNewPassword = '/setNewPassword';
  static const String inventroyDetails = '/setNewPassword';

  static Map<String, WidgetBuilder> routesTable = {
    homeScreen: (context) => Responsive.isMobile(context) ? const SmallScreen() : const LargeScreen(),
    loginScreen: (context) => const LoginScreen(),
    singupscreen: (context) => const SignUpScreen(),
    forgetPassword: (context) => const ForgetPassword(),
    personalDetailsScreen: (context) => const PersonalDetailsAuthScreen(),
    companyDetailsScreen: (context) => const CompanyDetailsAuthScreen(),
    addInventory: (context) => const AddInventory(),
    addLead: (context) => const AddLead(),
    // addWorkItem: (context) => const AddWorkItem(),
    addTodo: (context) => const AddTodo(),
    setNewPassword: (context) => const ChangePasswordPage(),
    inventoryDetailsScreen: (context) => const InventoryDetailsScreen(),
  };
}
