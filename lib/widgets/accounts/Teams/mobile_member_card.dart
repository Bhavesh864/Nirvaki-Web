import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/riverpodstate/add_member_state.dart';
import 'package:yes_broker/screens/account_screens/Teams/team_screen.dart';

import '../../../constants/firebase/Hive/hive_methods.dart';
import '../../../constants/firebase/userModel/user_info.dart';
import '../../../constants/methods/string_methods.dart';
import '../../../constants/utils/colors.dart';

class MobileMemberCard extends ConsumerStatefulWidget {
  final List<User> userList;
  final int index;
  const MobileMemberCard({super.key, required this.userList, required this.index});
  @override
  ConsumerState<MobileMemberCard> createState() => _MobileMemberCardState();
}

class _MobileMemberCardState extends ConsumerState<MobileMemberCard> {
  List<User> managers = [];
  void getdataFromLocalStorage() async {
    List<User> retrievedUsers = await UserListPreferences.getUserList();
    if (mounted) {
      setState(() {
        managers = retrievedUsers;
      });
    }
  }

  String getNamesMatchWithid(id) {
    final User managerArr = managers.firstWhere((element) => id == element.userId);
    return "${managerArr.userfirstname} ${managerArr.userlastname}";
  }

  @override
  void initState() {
    getdataFromLocalStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.userList[widget.index];
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
                      const SizedBox(width: 7),
                      SizedBox(
                        width: 200,
                        child: AppText(
                          text: "${capitalizeFirstLetter(user.userfirstname)} ${capitalizeFirstLetter(user.userlastname)}",
                          softwrap: true,
                        ),
                      ),
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
                          child: const Icon(Icons.edit_outlined),
                        ),
                      ),
                      const SizedBox(width: 3),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      const TextSpan(
                        text: "Role - ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: user.role,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      )
                    ]),
                  ),
                  RichText(
                    text: TextSpan(children: [
                      const TextSpan(
                        text: "Manager - ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: managers.isNotEmpty ? capitalizeFirstLetter(getNamesMatchWithid(user.managerid)) : "",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      )
                    ]),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
