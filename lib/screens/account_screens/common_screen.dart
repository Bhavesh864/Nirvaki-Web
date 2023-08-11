import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/utils/colors.dart';

import 'package:yes_broker/constants/utils/constants.dart';

import 'package:yes_broker/screens/account_screens/Teams/team_screen.dart';

import 'package:yes_broker/screens/account_screens/screens_state.dart';

import '../../constants/app_constant.dart';
import '../../constants/firebase/Hive/hive_methods.dart';
import '../../constants/firebase/userModel/broker_info.dart';
import '../../pages/largescreen_dashboard.dart';
import '../../routes/routes.dart';

final selectedProfileItemProvider = StateNotifierProvider<SelectedItemNotifier, ProfileMenuItems?>((ref) {
  return SelectedItemNotifier();
});

List<ProfileMenuItems> profileMenuItems = [
  ProfileMenuItems(title: "Profile", screen: const Center(child: Text('Screen for Item 1')), id: 1),
  ProfileMenuItems(title: "Team", screen: const TeamScreen(), id: 2),
  ProfileMenuItems(title: "Settings", screen: const Center(child: Text('Screen for Item 3')), id: 3),
  ProfileMenuItems(title: "Subscription", screen: const Center(child: Text('Screen for Item 4')), id: 4),
  ProfileMenuItems(title: "Help", screen: const Center(child: Text('Screen for Item 1')), id: 5),
  ProfileMenuItems(title: "Logout", screen: const Center(child: Text('Screen for Item 1')), id: 6),
];

class CommonScreen extends ConsumerWidget {
  const CommonScreen({super.key});
  void logoutaction(WidgetRef ref, BuildContext context) {
    authentication.signOut().then((value) => {Navigator.of(context).pushReplacementNamed(AppRoutes.loginScreen)});
    UserHiveMethods.deleteData(AppConst.getAccessToken());
    ref.read(selectedProfileItemProvider.notifier).setSelectedItem(null);
    UserHiveMethods.deleteData("token");
    ref.read(largeScreenTabsProvider.notifier).update((state) => 0);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItem = ref.watch(selectedProfileItemProvider);

    void onItemSelected(ProfileMenuItems item) {
      ref.read(selectedProfileItemProvider.notifier).setSelectedItem(item);
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColor.secondary,
              spreadRadius: 12,
              blurRadius: 4,
              offset: Offset(5, 5),
            ),
          ],
          color: Colors.white,
        ),
        child: Row(
          children: [
            if (MediaQuery.of(context).size.width >= 900)
              Expanded(
                flex: 1,
                child: ListView(
                  children: [
                    for (var item in profileMenuItems)
                      ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        hoverColor: AppColor.selectedItemColor,
                        selectedTileColor: selectedItem?.id == item.id ? AppColor.selectedItemColor : Colors.white,
                        title: Text(item.title),
                        onTap: () => item.id == 6 ? logoutaction(ref, context) : onItemSelected(item),
                        selected: selectedItem?.id == item.id,
                      ),
                  ],
                ),
              ),
            const VerticalDivider(
              color: AppColor.verticalLineColor,
              thickness: 1,
            ),
            // Right side content
            Expanded(
              flex: 5,
              child: selectedItem != null ? selectedItem.screen : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
