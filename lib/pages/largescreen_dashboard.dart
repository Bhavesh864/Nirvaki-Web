import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/widgets/app/side_menu.dart';
import 'package:yes_broker/widgets/app/nav_bar.dart';
import 'package:yes_broker/widgets/app/speed_dial_button.dart';

final currentIndexProvider = StateProvider<int>((ref) {
  return 0;
});

class LargeScreen extends ConsumerWidget {
  LargeScreen({super.key});

  // final SideMenuController menuController = Get.put(SideMenuController());

  void select(int n) {
    for (int i = 0; i < 5; i++) {
      if (i == n) {
        selected[i] = true;
      } else {
        selected[i] = false;
      }
    }
  }

  // int _selectedPageIndex = 0;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
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
                  ref
                      .read(currentIndexProvider.notifier)
                      .update((state) => index);
                },
                destinations: sideBarItems
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
                LargeScreenNavBar((selectedVal) {
                  if (selectedVal == 'Profile') {
                    ref
                        .read(currentIndexProvider.notifier)
                        .update((state) => 6);
                  }
                }),
                Expanded(
                  child: sideBarItems[currentIndex].screen,
                ),
              ],
            ),
          ),
        ],
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
