import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/app_constant.dart';

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
  void userLogout(WidgetRef ref, BuildContext context) {
    authentication.signOut().then(
          (value) => {
            // Navigator.of(context).pushReplacementNamed(AppRoutes.loginScreen),
            context.beamToReplacementNamed(AppRoutes.loginScreen),
          },
        );
    UserHiveMethods.deleteData(AppConst.getAccessToken());
    UserHiveMethods.deleteData("token");
    ref.read(selectedProfileItemProvider.notifier).setSelectedItem(null);
  }

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
          userLogout(ref, context);
        }
      }),
      // bottomNavigationBar: BottomAppBar(
      //   shape: const CircularNotchedRectangle(),
      //   notchMargin: 10,
      //   child: Container(
      //     height: 60,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Row(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: List.generate(
      //             bottomBarItems.length,
      //             (index) => MaterialButton(
      //               onPressed: () {},
      //               minWidth: 40,
      //               child: const Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Icon(
      //                     Icons.dashboard,
      //                     color: Colors.amber,
      //                   )
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
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
