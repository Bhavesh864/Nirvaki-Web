import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/TabScreens/account_screens/profile_screen.dart';

import 'package:yes_broker/TabScreens/main_screens/chat_screen.dart';
import 'package:yes_broker/TabScreens/main_screens/inventroy_screen.dart';
import 'package:yes_broker/TabScreens/main_screens/lead_screen.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/widgets/app/app_bar.dart';
import 'package:yes_broker/widgets/app/speed_dial_button.dart';
import 'package:yes_broker/widgets/calendar_view.dart';
import 'package:yes_broker/widgets/todo/todo_list_view.dart';

final currentIndexProvider = StateProvider<int>((ref) {
  return 0;
});

class SmallScreen extends ConsumerWidget {
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
    const ProfileScreen(),
  ];

  // int menuController.selectedMobilePageIndex.value = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);
    return Scaffold(
      appBar: MobileAppBar(context, (selectedVal) {
        print(selectedVal);
        if (selectedVal == 'Profile') {
          ref.read(currentIndexProvider.notifier).update((state) => 3);
        }
      }),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: const Color.fromARGB(255, 158, 153, 153),
        selectedItemColor: AppColor.primary,
        showUnselectedLabels: false,
        onTap: (value) =>
            ref.read(currentIndexProvider.notifier).update((state) => value),
        currentIndex: currentIndex,
        backgroundColor: Colors.white,
        items: List.generate(
          bottomBarItems.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(
              bottomBarItems[index]["icon"],
              color: index == currentIndex ? AppColor.primary : Colors.black,
            ),
            label: bottomBarItems[index]['title'],
          ),
        ),
      ),
      body: _pages[currentIndex],
      floatingActionButton: const CustomSpeedDialButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
