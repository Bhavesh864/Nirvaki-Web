import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/riverpodstate/add_member_state.dart';

import 'package:yes_broker/widgets/accounts/Teams/bottom_card_header.dart';

import '../../../constants/firebase/Hive/hive_methods.dart';
import '../../../constants/firebase/userModel/user_info.dart';
import '../../../constants/methods/string_methods.dart';

class BottomCardMain extends ConsumerStatefulWidget {
  final List<User> userList;
  const BottomCardMain({required this.userList, super.key});

  @override
  ConsumerState<BottomCardMain> createState() => _BottomCardMainState();
}

class _BottomCardMainState extends ConsumerState<BottomCardMain> {
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
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Table(
            children: const [
              TableRow(children: [
                AppText(text: "NAME", textColor: AppColor.cardtitleColor),
                AppText(text: "ROLE", textColor: AppColor.cardtitleColor),
                AppText(text: "MANAGER", textColor: AppColor.cardtitleColor),
                SizedBox()
              ])
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
                  child: Table(
                    children: [
                      TableRow(children: [
                        AppText(text: '${capitalizeFirstLetter(user.userfirstname)} ${capitalizeFirstLetter(user.userlastname)}', fontsize: 12, fontWeight: FontWeight.bold),
                        AppText(text: user.role, fontsize: 12, fontWeight: FontWeight.w400),
                        TableCell(
                          child: AppText(text: managers.isNotEmpty ? capitalizeFirstLetter(getNamesMatchWithid(user.managerid)) : "", fontsize: 12, fontWeight: FontWeight.w400),
                        ),
                        TableCell(
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              tooltip: "Edit",
                              iconSize: 12,
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                ref.read(editAddMemberState.notifier).isEdit(true);
                                showAddMemberScreen(ref);
                                ref.read(userForEditScreen.notifier).setUserForEdit(user);
                              },
                              icon: const Icon(Icons.edit),
                            ),
                          ),
                        )
                      ])
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }
}
