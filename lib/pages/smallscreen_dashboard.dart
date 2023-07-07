import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_broker/TabScreens/main_screens/chat_screen.dart';
import 'package:yes_broker/TabScreens/main_screens/inventroy_screen.dart';
import 'package:yes_broker/TabScreens/main_screens/lead_screen.dart';
import 'package:yes_broker/constants/colors.dart';
import 'package:yes_broker/constants/constants.dart';
import 'package:yes_broker/controllers/menu_controller.dart';
import 'package:yes_broker/widgets/app/app_bar.dart';
import 'package:yes_broker/widgets/app/speed_dial_button.dart';
import 'package:yes_broker/widgets/calendar_view.dart';
import 'package:yes_broker/widgets/todo/todo_list_view.dart';

class SmallScreen extends StatelessWidget {
  final SideMenuController menuController = Get.put(SideMenuController());

  SmallScreen({super.key});

  final List<Widget> _pages = [
    const SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          CustomCalendarView(),
          TodoListView(),
        ],
      ),
    ),
    const InventoryScreen(),
    const LeadScreen(),
    const ChatScreen(),
  ];

  // int menuController.selectedMobilePageIndex.value = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: MobileAppBar(context, GlobalKey()),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: const Color.fromARGB(255, 158, 153, 153),
          selectedItemColor: AppColor.primary,
          showUnselectedLabels: false,
          currentIndex: menuController.selectedMobilePageIndex.value,
          onTap: (value) => menuController.selectMobilePage(value),
          backgroundColor: Colors.white,
          items: List.generate(
            bottomBarItems.length,
            (index) => BottomNavigationBarItem(
              icon: Icon(
                bottomBarItems[index]["icon"],
                color: index == menuController.selectedMobilePageIndex.value
                    ? AppColor.primary
                    : Colors.black,
              ),
              label: bottomBarItems[index]['title'],
            ),
          ),
        ),
        body: _pages[menuController.selectedMobilePageIndex.value],
        floatingActionButton: CustomSpeedDialButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
