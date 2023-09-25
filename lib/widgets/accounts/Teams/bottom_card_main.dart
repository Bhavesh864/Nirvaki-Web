import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/text_utility.dart';

import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/riverpodstate/add_member_state.dart';

import 'package:yes_broker/widgets/accounts/Teams/bottom_card_header.dart';

import '../../../constants/firebase/userModel/user_info.dart';

class BottomCardMain extends ConsumerStatefulWidget {
  final List<User> userList;
  const BottomCardMain({required this.userList, super.key});

  @override
  ConsumerState<BottomCardMain> createState() => _BottomCardMainState();
}

class _BottomCardMainState extends ConsumerState<BottomCardMain> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(text: "NAME", textColor: AppColor.cardtitleColor),
              AppText(text: "ROLE", textColor: AppColor.cardtitleColor),
              AppText(text: "MANAGER", textColor: AppColor.cardtitleColor),
              AppText(text: ""),
            ],
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: widget.userList.length,
              itemBuilder: (context, index) {
                final user = widget.userList[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.baseline))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText(text: '${user.userfirstname} ${user.userlastname}', fontsize: 12, fontWeight: FontWeight.bold),
                      AppText(text: user.role, fontsize: 12, fontWeight: FontWeight.w400),
                      Row(
                        children: [
                          IconButton(onPressed: () {}, icon: const Icon(Icons.abc)),
                          user.managerName != null ? AppText(text: user.managerName!, fontsize: 12, fontWeight: FontWeight.w400) : const SizedBox(),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(color: AppColor.secondary, borderRadius: BorderRadius.circular(7)),
                        child: IconButton(
                          tooltip: "Edit",
                          iconSize: 12,
                          onPressed: () {
                            ref.read(editAddMemberState.notifier).isEdit(true);
                            showAddMemberScreen(ref);
                            ref.read(userForEditScreen.notifier).setUserForEdit(user);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      )
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }
}
