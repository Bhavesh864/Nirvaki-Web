// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/Hive/hive_methods.dart';
import 'package:yes_broker/constants/functions/chat_group/group.dart';

import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';
import 'package:yes_broker/screens/account_screens/screens_state.dart';
import 'package:yes_broker/widgets/app/nav_bar.dart';

import '../../constants/firebase/userModel/user_info.dart';
import '../../constants/functions/auth/auth_functions.dart';
import 'Teams/team_screen.dart';

final selectedProfileItemProvider = StateNotifierProvider<SelectedItemNotifier, ProfileMenuItems?>((ref) {
  return SelectedItemNotifier();
});

class CommonScreen extends ConsumerStatefulWidget {
  final BuildContext? outerContext;
  const CommonScreen({
    super.key,
    this.outerContext,
  });

  @override
  ConsumerState<CommonScreen> createState() => _CommonScreenState();
}

class _CommonScreenState extends ConsumerState<CommonScreen> {
  bool firstTime = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(selectedProfileItemProvider) == null) {
        ref.read(selectedProfileItemProvider.notifier).setSelectedItem(profileMenuItems[0]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = ref.watch(selectedProfileItemProvider);
    final userData = ref.watch(userDataProvider);
    void onItemSelected(ProfileMenuItems item) {
      ref.read(selectedProfileItemProvider.notifier).setSelectedItem(item);
      if (item.id == 2) {
        ref.read(addMemberScreenStateProvider.notifier).setAddMemberScreenState(false);
      }
    }

    if (userData != null && !firstTime) {
      addOrRemoveTeamAndOrganization(userData);
      firstTime = true;
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
                child: Container(
                  margin: const EdgeInsets.only(top: 10, left: 10),
                  child: ListView(
                    children: [
                      for (var item in profileMenuItems)
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: selectedItem?.id == item.id ? AppColor.selectedItemColor : Colors.white,
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            hoverColor: AppColor.selectedItemColor,
                            selectedTileColor: selectedItem?.id == item.id ? AppColor.selectedItemColor : Colors.white,
                            title: Text(item.title),
                            onTap: () {
                              item.id == 6
                                  ? customConfirmationAlertDialog(context, () {
                                      userLogout(ref, context);
                                      Navigator.of(AppConst.getOuterContext()!).pop();
                                    }, 'Logout', 'Are you sure you want to logout?')
                                  : onItemSelected(item);
                            },
                            selected: selectedItem?.id == item.id,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            const VerticalDivider(
              color: AppColor.verticalLineColor,
              thickness: 1,
              width: 25,
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
