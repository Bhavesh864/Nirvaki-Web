import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

// Flutter Packages Imports
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:yes_broker/pages/Auth/login/login_screen.dart';
import 'package:yes_broker/pages/Auth/signup/personal_details.dart';
import 'package:yes_broker/pages/Auth/set_new_password.dart';
import 'package:yes_broker/pages/Auth/signup/signup_screen.dart';
import 'package:yes_broker/pages/add_todo.dart';
import 'package:yes_broker/pages/edit_todo.dart';
import 'package:yes_broker/screens/main_screens/inventory_details_screen.dart';
import 'package:yes_broker/screens/main_screens/lead_details_screen.dart';
import 'package:yes_broker/screens/main_screens/todo_details_screen.dart';
import 'package:yes_broker/widgets/workitems/workitem_filter_view.dart';

// Local Files Imports
import '../Customs/responsive.dart';
import '../constants/firebase/detailsModels/card_details.dart';
import '../layout.dart';
import '../pages/Auth/signup/company_details.dart';
import '../screens/main_screens/caledar_screen.dart';
import '../screens/main_screens/chat_screen.dart';
import '../screens/main_screens/home_screen.dart';
import '../screens/main_screens/inventory_listing_screen.dart';
import '../screens/main_screens/lead_listing_screen.dart';
import '../screens/main_screens/todo_listing_screen.dart';
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
    nav: '/',
    // nav = '/home_screen',
    label: homeScreenPageLabel,
    iconData: homeIcon,
    screen: const HomeScreen(),
  ),
  MenuItem(
    nav: '/todo',
    label: todoPageLabel,
    iconData: todoIcon,
    screen: const TodoListingScreen(),
  ),
  MenuItem(
    nav: '/inventory',
    label: inventoryPageLabel,
    iconData: inventoryIcon,
    screen: const InventoryListingScreen(),
  ),
  MenuItem(
    nav: '/lead',
    label: leadPageLabel,
    iconData: leadIcon,
    screen: const LeadListingScreen(),
  ),
  // MenuItem(
  //   nav: '/chat',
  //   label: chatPageLabel,
  //   iconData: chatIcon,
  //   screen: const ChatScreen(),
  // ),
  MenuItem(
    nav: '/calendar',
    label: calendarPageLabel,
    iconData: calendarIcon,
    screen: const CalendarScreen(),
  ),
  MenuItem(
    label: profilePageLabel,
    screen: const CommonScreen(),
  ),
  MenuItem(
    nav: '/inventorydetails',
    label: inventoryDetailsLabel,
    screen: const InventoryDetailsScreen(),
  ),
  MenuItem(
    nav: '/lead-details',
    label: profilePageLabel,
    screen: const LeadDetailsScreen(),
  ),
];

List<BottomBarItem> bottomBarItems = [
  BottomBarItem(
    label: homeScreenPageLabel,
    iconData: homeIcon,
    screen: const TodoListingScreen(),
  ),
  BottomBarItem(
    label: inventoryPageLabel,
    iconData: inventoryIcon,
    screen: const InventoryListingScreen(),
  ),
  BottomBarItem(
    label: leadPageLabel,
    iconData: leadIcon,
    screen: const LeadListingScreen(),
  ),
  BottomBarItem(
    label: chatPageLabel,
    iconData: chatIcon,
    screen: const ChatScreen(),
  ),
];

class AppRoutes {
  static const String homeScreen = '/home_screen';
  static const String editTodo = '/edit_todo';
  static const String forgetPassword = '/forget_password_screen';
  static const String loginScreen = '/login_screen';
  static const String singupscreen = '/signup_screen';
  static const String setNewPassword = '/setNewPassword';
  static const String personalDetailsScreen = '/personal_details_screen';
  static const String companyDetailsScreen = '/company_details_screen';

  static const String workItemFilterScreen = '/workitem_filter_screen';
  static const String inventoryDetailsScreen = '/inventory_details_screen';
  static const String leadDetailsScreen = '/lead_details_screen';
  static const String todoDetailsScreen = '/todo_details_screen';

  static const String addInventory = '/add_inventory_screen';
  static const String addLead = '/add_lead_screen';
  static const String addWorkItem = '/add_workItem_screen';
  static const String addTodo = '/add_todoItem_screen';

  static Map<String, WidgetBuilder> routesTable = {
    homeScreen: (context) => Responsive.isMobile(context) ? const SmallScreen() : const LargeScreen(),
    loginScreen: (context) => const LoginScreen(),
    singupscreen: (context) => const SignUpScreen(),
    forgetPassword: (context) => const ForgetPassword(),
    setNewPassword: (context) => const ChangePasswordPage(),
    personalDetailsScreen: (context) => const PersonalDetailsAuthScreen(),
    companyDetailsScreen: (context) => const CompanyDetailsAuthScreen(),
    addInventory: (context) => const AddInventory(),
    addLead: (context) => const AddLead(),
    addTodo: (context) => const AddTodo(),
    editTodo: (context) => const EditTodo(),
    workItemFilterScreen: (context) => const WorkItemFilterView(
          originalCardList: [],
        ),
    inventoryDetailsScreen: (context) => const InventoryDetailsScreen(),
    leadDetailsScreen: (context) => const LeadDetailsScreen(),
    todoDetailsScreen: (context) => const TodoDetailsScreen(),
  };

  static Route createAnimatedRoute(Widget destinationScreen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return destinationScreen;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}

final routerDelegate = BeamerDelegate(
  setBrowserTabTitle: false,
  notFoundPage: const BeamPage(child: LayoutView()),
  locationBuilder: RoutesLocationBuilder(
    routes: {
      '/': (p0, p1, p2) => const LayoutView(),
      '/profile': (p0, p1, p2) => const LargeScreen(),
      AppRoutes.addInventory: (p0, p1, p2) => const AddInventory(),
      AppRoutes.addLead: (p0, p1, p2) => const AddLead(),
      AppRoutes.addTodo: (p0, p1, p2) => const AddTodo(),
      AppRoutes.editTodo: (p0, p1, data) {
        return const EditTodo();
      },
      AppRoutes.singupscreen: (p0, p1, p2) => const SignUpScreen(),
      AppRoutes.personalDetailsScreen: (p0, p1, p2) => const PersonalDetailsAuthScreen(),
      AppRoutes.companyDetailsScreen: (p0, p1, p2) => const CompanyDetailsAuthScreen(),
    },
  ),
);

class BeamerScreenNavigation extends StatelessWidget {
  const BeamerScreenNavigation({
    super.key,
    required this.beamerKey,
  });

  final GlobalKey<BeamerState> beamerKey;

  @override
  Widget build(BuildContext context) {
    return Beamer(
      createBackButtonDispatcher: true,
      key: beamerKey,
      routerDelegate: BeamerDelegate(
        setBrowserTabTitle: false,
        transitionDelegate: const NoAnimationTransitionDelegate(),
        locationBuilder: RoutesLocationBuilder(
          routes: {
            // '*': (p0, p1, p2) => const HomeScreen(),
            '*': (p0, state, p2) {
              if (state.pathPatternSegments.contains('inventory-details')) {
                return BeamPage(
                    key: const ValueKey('/inventory-details from home'),
                    type: BeamPageType.scaleTransition,
                    child: InventoryDetailsScreen(
                      inventoryId: state.pathPatternSegments[1],
                    ));
                // child: InventoryDetailsScreen());
              } else if (state.pathPatternSegments.contains('lead-details')) {
                return BeamPage(
                  key: const ValueKey('/lead-details from home'),
                  type: BeamPageType.scaleTransition,
                  child: LeadDetailsScreen(
                    leadId: state.pathPatternSegments[1],
                  ),
                );
                // child: LeadDetailsScreen());
              } else if (state.pathPatternSegments.contains('todo-details')) {
                return BeamPage(
                  key: const ValueKey('/todo-details from home'),
                  type: BeamPageType.scaleTransition,
                  child: TodoDetailsScreen(
                    todoId: state.pathPatternSegments[1],
                  ),
                );
                // child: LeadDetailsScreen());
              }
              return const BeamPage(
                key: ValueKey('/'),
                type: BeamPageType.scaleTransition,
                child: HomeScreen(),
              );
            },
            '/todo': (p0, state, p2) {
              if (state.pathPatternSegments.contains('todo-details')) {
                return BeamPage(
                  key: const ValueKey('/todo-details'),
                  type: BeamPageType.scaleTransition,
                  child: TodoDetailsScreen(
                    todoId: state.pathPatternSegments[2],
                  ),
                );
              }
              return const BeamPage(
                key: ValueKey('/todo'),
                type: BeamPageType.scaleTransition,
                child: TodoListingScreen(),
              );
            },
            '/inventory': (p0, state, p2) {
              if (state.pathPatternSegments.contains('inventory-details')) {
                return BeamPage(
                  key: const ValueKey('/inventory-details'),
                  type: BeamPageType.scaleTransition,
                  child: InventoryDetailsScreen(
                    inventoryId: state.pathPatternSegments[2],
                  ),
                );
                // child: PublicViewInventoryDetails());
              }
              return const BeamPage(
                key: ValueKey('/inventory-listing'),
                type: BeamPageType.scaleTransition,
                child: InventoryListingScreen(),
              );
            },
            '/lead': (p0, state, p2) {
              if (state.pathPatternSegments.contains('lead-details')) {
                return BeamPage(
                  key: const ValueKey('/lead-details'),
                  type: BeamPageType.scaleTransition,
                  child: LeadDetailsScreen(
                    leadId: state.pathPatternSegments[2],
                  ),
                );
                // child: PublicViewLeadDetails());
              }
              return const BeamPage(
                key: ValueKey('/lead-listing'),
                type: BeamPageType.scaleTransition,
                child: LeadListingScreen(),
              );
            },
            '/chat': (p0, p1, p2) => const BeamPage(
                  key: ValueKey('/chat'),
                  type: BeamPageType.scaleTransition,
                  child: ChatScreen(),
                ),
            '/calendar': (p0, p1, p2) => const BeamPage(
                  key: ValueKey('/calendar'),
                  type: BeamPageType.scaleTransition,
                  child: CalendarScreen(),
                ),
            '/profile': (p0, p1, p2) => const BeamPage(
                  key: ValueKey('/calendar'),
                  type: BeamPageType.scaleTransition,
                  child: CommonScreen(),
                ),
            AppRoutes.editTodo: (p0, p1, data) {
              return BeamPage(
                key: const ValueKey('/edit-todo'),
                type: BeamPageType.scaleTransition,
                child: EditTodo(cardDetails: data as CardDetails),
              );
            },
          },
        ),
      ),
    );
  }
}
