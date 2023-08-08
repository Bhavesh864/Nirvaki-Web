import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/widgets/app/app_bar.dart';
import 'package:yes_broker/widgets/app/speed_dial_button.dart';
import '../constants/firebase/Hive/hive_methods.dart';
import '../constants/firebase/userModel/broker_info.dart';
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
          // ref.read(currentIndexProvider.notifier).update((state) => 4);
          final ProfileMenuItems profile = profileMenuItems.firstWhere((element) => element.title == selectedVal);
          ref.read(selectedProfileItemProvider.notifier).setSelectedItem(profile);
        } else if (selectedVal == "Logout") {
          authentication.signOut().then(
                (value) => Navigator.of(context).pushReplacementNamed(AppRoutes.loginScreen),
              );
          UserHiveMethods.deleteData(authentication.currentUser?.uid);
          UserHiveMethods.deleteData("token");
        }
      }),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColor.primary,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
