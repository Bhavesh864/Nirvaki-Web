import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:yes_broker/TabScreens/account_screens/profile_screen.dart';

import 'package:yes_broker/TabScreens/main_screens/caledar_screen.dart';
import 'package:yes_broker/TabScreens/main_screens/chat_screen.dart';
import 'package:yes_broker/TabScreens/main_screens/inventroy_screen.dart';
import 'package:yes_broker/TabScreens/main_screens/lead_screen.dart';
import 'package:yes_broker/TabScreens/main_screens/todo_screen.dart';
import 'package:yes_broker/constants/colors.dart';
import 'package:yes_broker/constants/constants.dart';
import 'package:yes_broker/controllers/menu_controller.dart';
import 'package:yes_broker/pages/add_inventory.dart';

import 'package:yes_broker/widgets/app/side_menu.dart';
import 'package:yes_broker/widgets/app/nav_bar.dart';
import 'package:yes_broker/TabScreens/main_screens/home_screen.dart';
import 'package:yes_broker/widgets/app/speed_dial_button.dart';

class LargeScreen extends StatelessWidget {
  LargeScreen({super.key});

  final SideMenuController menuController = Get.put(SideMenuController());

  void select(int n) {
    for (int i = 0; i < 5; i++) {
      if (i == n) {
        selected[i] = true;
      } else {
        selected[i] = false;
      }
    }
  }

  final List<Widget> _pages = [
    const HomeScreen(),
    const TodoTabScreen(),
    const InventoryScreen(),
    const LeadScreen(),
    const ChatScreen(),
    const CalendarScreen(),
    const ProfileScreen(),
  ];

  // int _selectedPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const Expanded(
            //   flex: 1,
            //   child: SideMenu(),
            // ),
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
                    menuController.selectPage(index);
                  },
                  destinations: sideBarIcons
                      .map(
                        (e) => NavigationRailDestination(
                          icon: Icon(e),
                          selectedIcon: Icon(e, color: AppColor.primary),
                          label: const Text('Yes Broker'),
                        ),
                      )
                      .toList(),
                  selectedIndex: menuController.selectedPageIndex.value > 5
                      ? 0
                      : menuController.selectedPageIndex.value,
                ),
              ),
            ),
            Expanded(
              flex: 20,
              child: Column(
                children: [
                  LargeScreenNavBar(),
                  Expanded(
                    child: _pages[menuController.selectedPageIndex.value],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomSpeedDialButton(),
          SizedBox(
            height: 10,
          ),
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColor.primary,
            child: Icon(
              Icons.chat_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
