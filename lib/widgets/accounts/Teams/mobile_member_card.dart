import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/user_role.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/riverpodstate/add_member_state.dart';
import 'package:yes_broker/screens/account_screens/Teams/team_screen.dart';

import '../../../constants/firebase/userModel/user_info.dart';
import '../../../constants/utils/colors.dart';

class MobileMemberCard extends ConsumerWidget {
  final User user;
  const MobileMemberCard({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          user.image.isNotEmpty ? user.image : noImg,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text("${user.userfirstname} ${user.userlastname}"),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          showAddMemberAlertDailogBox(context);
                          ref.read(editAddMemberState.notifier).isEdit(true);
                          ref.read(userForEditScreen.notifier).setUserForEdit(user);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(color: AppColor.secondary, borderRadius: BorderRadius.circular(7)),
                          child: const Icon(Icons.edit),
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Text("200"),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Role - ${user.role}"), Text("Manager - ${user.managerName ?? ""}")],
              )
            ],
          ),
        ),
      ),
    );
  }
}
