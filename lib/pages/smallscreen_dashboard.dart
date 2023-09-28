import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/app_constant.dart';

import 'package:yes_broker/riverpodstate/user_data.dart';
import 'package:yes_broker/widgets/app/app_bar.dart';

import '../constants/firebase/userModel/user_info.dart';
import '../constants/functions/auth/auth_functions.dart';
import '../constants/utils/colors.dart';
import '../constants/utils/constants.dart';

import '../routes/routes.dart';
import '../screens/account_screens/Teams/team_screen.dart';
import '../screens/account_screens/common_screen.dart';
import '../widgets/app/speed_dial_button.dart';

final currentIndexProvider = StateProvider<int>((ref) {
  return 0;
});

class SmallScreen extends ConsumerStatefulWidget {
  const SmallScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SmallScreen> createState() => _SmallScreenState();
}

class _SmallScreenState extends ConsumerState<SmallScreen> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentIndexProvider);
    final selectedItem = ref.watch(selectedProfileItemProvider);
    final User? user = ref.watch(userDataProvider);
    AppConst.setOuterContext(context);

    return Scaffold(
      appBar: mobileAppBar(user!, context, (selectedVal) {
        if (selectedVal != 'Logout') {
          final ProfileMenuItems profile = profileMenuItems.firstWhere((element) => element.title == selectedVal);
          ref.read(selectedProfileItemProvider.notifier).setSelectedItem(profile);
          if (profile.id == 2) {
            ref.read(addMemberScreenStateProvider.notifier).setAddMemberScreenState(false);
          }
        } else if (selectedVal == "Logout") {
          // customConfirmationAlertDialog(context, () {
          userLogout(ref, context);
          // }, 'Logout', 'Are you sure you want to logout?');
        }
      }, ref),
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
