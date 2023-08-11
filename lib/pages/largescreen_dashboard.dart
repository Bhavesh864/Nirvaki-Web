import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/Hive/hive_methods.dart';
import 'package:yes_broker/constants/firebase/userModel/broker_info.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/screens/account_screens/common_screen.dart';
import 'package:yes_broker/widgets/app/nav_bar.dart';
import 'package:yes_broker/widgets/app/speed_dial_button.dart';

final largeScreenTabsProvider = StateProvider<int>((ref) {
  return 0;
});

class LargeScreen extends ConsumerWidget {
  const LargeScreen({Key? key}) : super(key: key);
  void userLogout(WidgetRef ref, BuildContext context) {
    authentication.signOut().then((value) => {Navigator.of(context).pushReplacementNamed(AppRoutes.loginScreen)});
    UserHiveMethods.deleteData(AppConst.getAccessToken());
    UserHiveMethods.deleteData("token");
    ref.read(selectedProfileItemProvider.notifier).setSelectedItem(null);
    ref.read(largeScreenTabsProvider.notifier).update((state) => 0);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(largeScreenTabsProvider);

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
                  ref.read(largeScreenTabsProvider.notifier).update((state) => index);
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
                LargeScreenNavBar((selectedVal) {
                  if (selectedVal != 'Logout') {
                    ref.read(largeScreenTabsProvider.notifier).update((state) => 6);
                    final ProfileMenuItems profile = profileMenuItems.firstWhere((element) => element.title == selectedVal);
                    ref.read(selectedProfileItemProvider.notifier).setSelectedItem(profile);
                  } else if (selectedVal == "Logout") {
                    userLogout(ref, context);
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
      floatingActionButton: Column(
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
      ),
    );
  }
}
