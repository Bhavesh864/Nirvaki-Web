import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/Hive/hive_methods.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/firebase/userModel/broker_info.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/pages/edit_todo.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/screens/account_screens/common_screen.dart';
import 'package:yes_broker/screens/main_screens/inventory_details_screen.dart';
import 'package:yes_broker/screens/main_screens/caledar_screen.dart';
import 'package:yes_broker/screens/main_screens/chat_screen.dart';
import 'package:yes_broker/screens/main_screens/home_screen.dart';
import 'package:yes_broker/screens/main_screens/inventory_listing_screen.dart';
import 'package:yes_broker/screens/main_screens/lead_details_screen.dart';
import 'package:yes_broker/screens/main_screens/lead_listing_screen.dart';
import 'package:yes_broker/screens/main_screens/todo_details_screen.dart';
import 'package:yes_broker/screens/main_screens/todo_listing_screen.dart';
import 'package:yes_broker/widgets/app/nav_bar.dart';
import 'package:yes_broker/widgets/app/speed_dial_button.dart';

final largeScreenTabsProvider = StateProvider<int>((ref) {
  return 0;
});

void userLogout(WidgetRef ref, BuildContext context) {
  context.beamToNamed('/login');
  authentication.signOut().then((value) => {Navigator.of(context).pushReplacementNamed(AppRoutes.loginScreen)});
  UserHiveMethods.deleteData(AppConst.getAccessToken());
  UserHiveMethods.deleteData("token");
  ref.read(selectedProfileItemProvider.notifier).setSelectedItem(null);
  ref.read(largeScreenTabsProvider.notifier).update((state) => 0);
}

class LargeScreen extends ConsumerStatefulWidget {
  const LargeScreen({Key? key}) : super(key: key);

  @override
  LargeScreenState createState() => LargeScreenState();
}

class LargeScreenState extends ConsumerState<LargeScreen> {
  @override
  Widget build(BuildContext context) {
    // final currentIndex = ref.watch(largeScreenTabsProvider);
    int currentIndex = 0;
    final beamerKey = GlobalKey<BeamerState>();

    final path = (context.currentBeamLocation.state as BeamState).uri.path;

    if (path.contains('/ ')) {
      currentIndex = 0;
    } else if (path.contains('/todo')) {
      currentIndex = 1;
    } else if (path.contains('/inventory')) {
      currentIndex = 2;
    } else if (path.contains('/lead')) {
      currentIndex = 3;
    } else if (path.contains('/chat')) {
      currentIndex = 4;
    } else if (path.contains('/calendar')) {
      currentIndex = 5;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              height: 600,
              padding: EdgeInsets.only(top: height! * 0.2),
              child: NavigationRail(
                backgroundColor: Colors.white,
                minWidth: 60,
                useIndicator: false,
                onDestinationSelected: (index) {
                  // ref.read(largeScreenTabsProvider.notifier).update((state) => index);
                  setState(() {
                    beamerKey.currentState?.routerDelegate.beamToNamed(sideBarItems[index].nav);
                  });
                },
                destinations: sideBarItems
                    .sublist(0, 6)
                    .map(
                      (e) => NavigationRailDestination(
                        icon: Icon(e.iconData),
                        selectedIcon: Icon(e.iconData, color: AppColor.primary),
                        label: const Text('Yes Broker'),
                      ),
                    )
                    .toList(),
                selectedIndex: currentIndex > 5 ? 0 : currentIndex,
              ),
            ),
          ),
          Expanded(
            flex: 20,
            child: Column(
              children: [
                LargeScreenNavBar(
                  (selectedVal) {
                    if (selectedVal != 'Logout') {
                      ref.read(largeScreenTabsProvider.notifier).update((state) => 6);
                      final ProfileMenuItems profile = profileMenuItems.firstWhere((element) => element.title == selectedVal);
                      ref.read(selectedProfileItemProvider.notifier).setSelectedItem(profile);
                      context.beamToNamed('/profile');
                    } else if (selectedVal == "Logout") {
                      userLogout(ref, context);
                    }
                  },
                ),
                Expanded(
                  // child: sideBarItems[currentIndex].screen,
                  child: Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.secondary,
                          spreadRadius: 12,
                          blurRadius: 4,
                          offset: Offset(5, 5),
                        ),
                      ],
                      color: Colors.white,
                      // color: Color(0xFFF9F9FD),
                    ),
                    child: Beamer(
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: !AppConst.getPublicView()
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CustomSpeedDialButton(),
                const SizedBox(
                  height: 10,
                ),
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColor.primary,
                  child: IconButton(
                    icon: const Icon(
                      Icons.chat_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {
                      popupMenuItem('title');
                    },
                  ),
                ),
              ],
            )
          : null,
    );
  }
}
