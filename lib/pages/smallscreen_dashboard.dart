import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/widgets/app/app_bar.dart';
import 'package:yes_broker/widgets/app/speed_dial_button.dart';
import '../constants/functions/auth/auth_functions.dart';
import '../constants/utils/constants.dart';
import '../screens/account_screens/common_screen.dart';

final currentIndexProvider = StateProvider<int>((ref) {
  return 0;
});

class SmallScreen extends ConsumerWidget {
  const SmallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);
    final selectedItem = ref.watch(selectedProfileItemProvider);

    return Scaffold(
      appBar: mobileAppBar(context, (selectedVal) {
        if (selectedVal != 'Logout') {
          final ProfileMenuItems profile = profileMenuItems.firstWhere((element) => element.title == selectedVal);
          ref.read(selectedProfileItemProvider.notifier).setSelectedItem(profile);
        } else if (selectedVal == "Logout") {
          userLogout(ref, context);
        }
      }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColor.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (value) => {
          ref.read(currentIndexProvider.notifier).update((state) => value),
          ref.read(selectedProfileItemProvider.notifier).setSelectedItem(null),
        },
        currentIndex: currentIndex,
        items: List.generate(
          bottomBarItems.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(
              bottomBarItems[index].iconData,
              color: index == currentIndex ? AppColor.primary : Colors.black,
            ),
            label: bottomBarItems[index].label,
          ),
        ),
      ),
      body: Stack(
        children: [
          if (selectedItem == null) ...[
            bottomBarItems[currentIndex].screen,
          ],
          if (selectedItem != null) ...[
            selectedItem.screen,
          ],
        ],
      ),
      floatingActionButton: const CustomSpeedDialButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
