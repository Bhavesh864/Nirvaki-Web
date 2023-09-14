import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/snackbar.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/chatModels/group_model.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';

import '../../../screens/main_screens/chat_list_screen.dart';

// ignore: must_be_immutable
class GroupUserList extends ConsumerStatefulWidget {
  List<User> userInfo;
  final String? adminId;
  final String? contactId;

  GroupUserList({
    super.key,
    required this.userInfo,
    this.adminId,
    this.contactId,
  });

  @override
  ConsumerState<GroupUserList> createState() => _GroupUserListState();
}

class _GroupUserListState extends ConsumerState<GroupUserList> {
  List<User> userlist = [];

  Future<void> getUserData(List userIds) async {
    final List<User> user = await User.getListOfUsersByIds(userIds);
    userlist = user;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final selectedUserIds = ref.read(selectedUserIdsProvider.notifier);
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("groups").where("groupId", isEqualTo: widget.contactId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userSnapshot = snapshot.data?.docs;

          getUserData(userSnapshot?[0]["membersUid"]);

          if (userlist.isNotEmpty) {
            final adminUser = userlist.firstWhere((user) => user.userId == widget.adminId);
            userlist.removeWhere((user) => user.userId == widget.adminId);

              // Add the admin user to the beginning of the userlist
              userlist.insert(0, adminUser);
            }

            return ListView.builder(
                physics: const PageScrollPhysics(),
                shrinkWrap: true,
                itemCount: userlist.length,
                itemBuilder: (ctx, index) {
                  final user = userlist[index];

                  return Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                    margin: const EdgeInsets.all(5),
                    child: ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      leading: CircleAvatar(
                        radius: 23,
                        backgroundImage: NetworkImage(
                          user.image.isEmpty ? noImg : user.image,
                        ),
                      ),
                      title: AppText(
                        text: user.userId == widget.adminId ? '${user.userfirstname} ${user.userlastname} (Admin)' : '${user.userfirstname} ${user.userlastname}',
                        textColor: const Color.fromRGBO(44, 44, 46, 1),
                        fontWeight: FontWeight.w500,
                        fontsize: 15,
                      ),
                      trailing: AppConst.getAccessToken() == widget.adminId && user.userId != widget.adminId
                          ? InkWell(
                              onTap: () {
                                Group.deleteMember(groupId: widget.contactId!, memberIdToDelete: user.userId);
                                selectedUserIds.update(
                                  (state) {
                                    state.remove(user.userId);
                                    return state;
                                  },
                                );
                                getUserData(
                                  userSnapshot?[0]["membersUid"],
                                );
                                setState(() {});
                                customSnackBar(
                                  context: context,
                                  text: '${user.userfirstname} ${user.userlastname} has been removed',
                                );
                              },
                              splashColor: Colors.grey[350],
                              child: const Padding(
                                padding: EdgeInsets.all(5),
                                child: AppText(
                                  text: 'Remove',
                                  textColor: AppColor.primary,
                                  fontWeight: FontWeight.w500,
                                  fontsize: 15,
                                ),
                              ),
                            )
                          : null,
                    ),
                  );
                });
          }

          return ListView.builder(
            physics: const PageScrollPhysics(),
            shrinkWrap: true,
            itemCount: userlist.length,
            itemBuilder: (ctx, index) {
              final user = userlist[index];

              return Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                margin: const EdgeInsets.all(5),
                child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  leading: CircleAvatar(
                    radius: 21,
                    backgroundImage: NetworkImage(
                      user.image.isEmpty ? noImg : user.image,
                    ),
                  ),
                  title: AppText(
                    text: user.userId == widget.adminId ? '${user.userfirstname} ${user.userlastname} (Admin)' : '${user.userfirstname} ${user.userlastname}',
                    textColor: const Color.fromRGBO(44, 44, 46, 1),
                    fontWeight: FontWeight.w500,
                    fontsize: 14,
                  ),
                  trailing: AppConst.getAccessToken() == widget.adminId && user.userId != widget.adminId
                      ? InkWell(
                          onTap: () {
                            Group.deleteMember(groupId: widget.contactId!, memberIdToDelete: user.userId);

                            selectedUserIds.update(
                              (state) {
                                state.remove(user.userId);
                                return [...state];
                              },
                            );

                            getUserData(
                              userSnapshot?[0]["membersUid"],
                            );
                            setState(() {});
                            customSnackBar(
                              context: context,
                              text: '${user.userfirstname} ${user.userlastname} has been removed',
                            );
                          },
                          splashColor: Colors.grey[350],
                          child: const Padding(
                            padding: EdgeInsets.all(5),
                            child: AppText(
                              text: 'Remove',
                              textColor: AppColor.primary,
                              fontWeight: FontWeight.w500,
                              fontsize: 12,
                            ),
                          ),
                        )
                      : null,
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
