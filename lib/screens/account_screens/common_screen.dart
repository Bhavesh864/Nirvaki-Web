import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/utils/colors.dart';

import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/screens/account_screens/Teams/AddMembers/add_member_screen.dart';
import 'package:yes_broker/screens/account_screens/Teams/team_screen.dart';

import 'package:yes_broker/screens/account_screens/screens_state.dart';

final selectedItemProvider = StateNotifierProvider<SelectedItemNotifier, ProfileMenuItems?>((ref) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItem = ref.watch(selectedItemProvider);

    void onItemSelected(ProfileMenuItems item) {
      ref.read(selectedItemProvider.notifier).setSelectedItem(item);
    }

    void logoutaction() {
      // authentication.signOut().then((value) => {Navigator.of(context).pushReplacementNamed(AppRoutes.loginScreen)});
      // UserHiveMethods.deleteData(authentication.currentUser?.uid);
    }

    return Container(
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
          if (MediaQuery.of(context).size.width >= 600)
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
                      onTap: () => item.id == 6 ? logoutaction() : onItemSelected(item),
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
    );
  }
}
