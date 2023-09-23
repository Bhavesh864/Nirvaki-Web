// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/functions/chat_group/group.dart';

import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/screens/account_screens/screens_state.dart';

import '../../constants/functions/auth/auth_functions.dart';
import 'Teams/team_screen.dart';

final selectedProfileItemProvider = StateNotifierProvider<SelectedItemNotifier, ProfileMenuItems?>((ref) {
  return SelectedItemNotifier();
});

class CommonScreen extends ConsumerWidget {
  final BuildContext outerContext;

  const CommonScreen({
    super.key,
    required this.outerContext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItem = ref.watch(selectedProfileItemProvider);

    void onItemSelected(ProfileMenuItems item) {
      ref.read(selectedProfileItemProvider.notifier).setSelectedItem(item);
      if (item.id == 2) {
        ref.read(addMemberScreenStateProvider.notifier).setAddMemberScreenState(false);
      }
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
                        onTap: () {
                          item.id == 6
                              ? customConfirmationAlertDialog(context, () {
                                  userLogout(ref, outerContext);
                                }, 'Logout', 'Are you sure you want to logout?')
                              : onItemSelected(item);
                        },
                        selected: selectedItem?.id == item.id,
                      ),
                  ],
                ),
              ),
            const VerticalDivider(
              color: AppColor.verticalLineColor,
              thickness: 1,
            ),
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
