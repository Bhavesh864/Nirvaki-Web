import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/riverpodstate/add_member_state.dart';

import '../../../Customs/text_utility.dart';
import '../../../constants/utils/colors.dart';
import '../../../screens/account_screens/Teams/team_screen.dart';

class BottomCardHeader extends ConsumerWidget {
  const BottomCardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const AppText(
          text: "My Team",
          fontsize: 18,
          fontWeight: FontWeight.bold,
        ),
        GestureDetector(
          onTap: () => {
            ref.read(editAddMemberState.notifier).isEdit(false),
            showAddMemberScreen(ref),
            ref.read(userForEditScreen.notifier).setUserForEdit(null),
          },
          child: const AppText(
            text: "Add Members",
            fontsize: 18,
            fontWeight: FontWeight.w500,
            textdecoration: TextDecoration.underline,
            textColor: AppColor.blue,
          ),
        )
      ],
    );
  }
}

void showAddMemberScreen(WidgetRef ref) {
  ref.read(addMemberScreenStateProvider.notifier).setAddMemberScreenState(true);
}
