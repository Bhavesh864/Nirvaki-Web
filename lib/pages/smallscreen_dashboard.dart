import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/pages/largescreen_dashboard.dart';

import 'package:yes_broker/riverpodstate/user_data.dart';
import 'package:yes_broker/widgets/app/app_bar.dart';

import '../constants/firebase/userModel/user_info.dart';
import '../constants/functions/auth/auth_functions.dart';
import '../constants/utils/colors.dart';
import '../constants/utils/constants.dart';

import '../riverpodstate/chat/message_selection_state.dart';
import '../routes/routes.dart';
import '../screens/account_screens/Teams/team_screen.dart';
import '../screens/account_screens/common_screen.dart';
import '../widgets/app/speed_dial_button.dart';

final mobileBottomIndexProvider = StateProvider<int>((ref) {
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
    final currentIndex = ref.watch(mobileBottomIndexProvider);
    final selectedItem = ref.watch(selectedProfileItemProvider);
    final User? user = ref.watch(userDataProvider);
    AppConst.setOuterContext(context);

    return Scaffold(
      appBar: mobileAppBar(user, context, (selectedVal) {
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
      body:
          // deskTopSideBarIndex == 4 && currentIndex != 4
          //     // ? const CalendarScreen()
          //     :
          Stack(
        children: [
          if (selectedItem == null) ...[
            bottomBarItems[currentIndex].screen,
          ],
          if (selectedItem != null) ...[
            selectedItem.screen,
          ],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColor.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (value) => {
          ref.read(mobileBottomIndexProvider.notifier).update((state) => value),
          ref.read(selectedProfileItemProvider.notifier).setSelectedItem(null),
          ref.read(desktopSideBarIndexProvider.notifier).update((state) => value),
          if (value == 4) {ref.read(selectedMessageProvider.notifier).setToEmpty()}
        },
        currentIndex: currentIndex,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        items: List.generate(
          bottomBarItems.length,
          (index) => BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              width: 70,
              padding: const EdgeInsets.symmetric(vertical: 8),
              // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: index == currentIndex ? AppColor.secondary : Colors.transparent,
              ),
              child: Column(
                children: [
                  Icon(
                    bottomBarItems[index].iconData,
                    color: index == currentIndex ? AppColor.primary : Colors.black,
                    size: 20,
                  ),
                  AppText(
                    text: bottomBarItems[index].label,
                    fontsize: 12,
                    textColor: index == currentIndex ? AppColor.primary : Colors.black,
                  )
                ],
              ),
            ),
            label: '',
          ),
        ),
      ),
      floatingActionButton: currentIndex == 4 ? null : const CustomSpeedDialButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
