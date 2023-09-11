// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/screens/main_screens/add_group_member_screen.dart';
import 'package:yes_broker/widgets/chat/group/group_user_list.dart';

import '../../constants/firebase/chatModels/group_model.dart';
import '../../constants/firebase/userModel/user_info.dart';
import 'chat_list_screen.dart';
import 'create_group_screen.dart';

class ChatUserProfile extends ConsumerStatefulWidget {
  final String profilePic;
  final String contactId;
  final String name;
  final String? adminId;
  final bool isGroupChat;
  final User? user;

  const ChatUserProfile({
    Key? key,
    required this.profilePic,
    required this.name,
    required this.user,
    required this.contactId,
    required this.isGroupChat,
    this.adminId,
  }) : super(key: key);

  @override
  ConsumerState<ChatUserProfile> createState() => _ChatUserProfileState();
}

class _ChatUserProfileState extends ConsumerState<ChatUserProfile> {
  List<User>? userInfo = [];

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    final selectedUserIds = ref.read(selectedUserIdsProvider.notifier);
    final user = await User.getListOfUsersByIds(selectedUserIds.state);
    userInfo!.addAll(user);
    setState(() {});
  }

  void onLeaveGroup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const AppText(
            text: 'Leave Group',
            fontsize: 20,
            fontWeight: FontWeight.w500,
          ),
          content: const AppText(
            text: 'Are you sure you want to leave the group?',
            fontWeight: FontWeight.w600,
            fontsize: 16,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const AppText(
                text: 'Cancel',
                fontWeight: FontWeight.w500,
                fontsize: 16,
                textColor: AppColor.primary,
              ),
            ),
            TextButton(
              onPressed: () {
                Group.deleteMember(groupId: widget.contactId, memberIdToDelete: AppConst.getAccessToken());
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const AppText(
                text: 'Leave',
                fontWeight: FontWeight.w500,
                fontsize: 16,
                textColor: AppColor.primary,
              ),
            ),
          ],
        );
      },
    );
  }

  void onDeleteGroup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const AppText(
            text: 'Delete Group',
            fontsize: 20,
            fontWeight: FontWeight.w500,
          ),
          content: const AppText(
            text: 'Are you sure you want to delete the group?',
            fontWeight: FontWeight.w600,
            fontsize: 16,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const AppText(
                text: 'Cancel',
                fontWeight: FontWeight.w500,
                fontsize: 16,
                textColor: AppColor.primary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Group.deleteGroup(widget.contactId);
              },
              child: const AppText(
                text: 'Delete',
                fontWeight: FontWeight.w500,
                fontsize: 16,
                textColor: AppColor.primary,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: AppColor.secondary,
        iconTheme: const IconThemeData(size: 22),
        actions: widget.isGroupChat
            ? [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'leave_group') {
                      onLeaveGroup();
                    } else if (value == 'delete_group') {
                      onDeleteGroup();
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'leave_group',
                        child: Row(
                          children: [
                            Text('Leave Group'),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.exit_to_app,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                      if (AppConst.getAccessToken() == widget.adminId) ...[
                        const PopupMenuItem<String>(
                          value: 'delete_group',
                          child: Row(
                            children: [
                              Text('Delete Group'),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.delete_outline,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ]
                    ];
                  },
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: UserProfileBody(
          profilePic: widget.profilePic,
          name: widget.name,
          user: widget.user,
          contactId: widget.contactId,
          adminId: widget.adminId,
          isGroupChat: widget.isGroupChat,
        ),
      ),
    );
  }
}

class UserProfileBody extends ConsumerStatefulWidget {
  final String profilePic;
  final String contactId;
  final String name;
  final String? adminId;
  final bool isGroupChat;
  final User? user;
  final Function? onGoBack;

  const UserProfileBody({
    Key? key,
    required this.profilePic,
    required this.contactId,
    required this.name,
    this.adminId,
    required this.isGroupChat,
    required this.user,
    this.onGoBack,
  }) : super(key: key);

  @override
  ConsumerState<UserProfileBody> createState() => _UserProfileBodyState();
}

class _UserProfileBodyState extends ConsumerState<UserProfileBody> {
  List<User>? userInfo = [];

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    final selectedUserIds = ref.read(selectedUserIdsProvider.notifier);
    final user = await User.getListOfUsersByIds(selectedUserIds.state);
    userInfo!.addAll(user);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Responsive.isMobile(context) ? height : 500,
      color: AppColor.secondary,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Responsive.isMobile(context)
                    ? null
                    : widget.isGroupChat
                        ? 230
                        : 350,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: Responsive.isMobile(context) ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                        children: [
                          if (!Responsive.isMobile(context))
                            IconButton(
                              onPressed: () {
                                widget.onGoBack!();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 20,
                              ),
                            ),
                          AppText(
                            text: widget.name,
                            fontsize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          if (!Responsive.isMobile(context))
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.close,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(widget.profilePic.isEmpty ? noImg : widget.profilePic),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (widget.isGroupChat)
                        AppText(
                          text: '(${userInfo!.length} Participants)',
                          textColor: Colors.grey,
                          fontWeight: FontWeight.w700,
                          fontsize: 12,
                        ),
                      if (!widget.isGroupChat)
                        SizedBox(
                          height: 100,
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(32, 14, 50, 0.05),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    width: 26,
                                    height: 26,
                                    child: const Center(
                                      child: Icon(
                                        Icons.call_outlined,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  AppText(
                                    text: widget.user != null ? widget.user!.mobile : '91293843854',
                                    fontsize: 13,
                                    fontWeight: FontWeight.w500,
                                    textColor: const Color(0xFFA8A8A8),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Container(
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(32, 14, 50, 0.05),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.whatsapp,
                                          size: 18,
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  const AppText(
                                    text: 'Not Acitve',
                                    fontsize: 13,
                                    fontWeight: FontWeight.w500,
                                    textColor: Color(0xFFA8A8A8),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // const Padding(
              //   padding: EdgeInsets.only(left: 30, top: 20, bottom: 10),
              //   child: AppText(
              //     text: 'Upcoming Acitivity',
              //     textColor: Color(0xFF181818),
              //     fontWeight: FontWeight.w700,
              //     fontsize: 18,
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: Container(
              //     width: double.infinity,
              //     height: 90,
              //     padding: const EdgeInsets.all(20.0),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(20.0),
              //     ),
              //     child: Container(
              //       width: double.infinity,
              //       height: double.infinity,
              //       decoration: BoxDecoration(
              //         color: AppColor.secondary,
              //         borderRadius: BorderRadius.circular(6.0),
              //       ),
              //       child: const Padding(
              //         padding: EdgeInsets.all(8),
              //         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //           Row(
              //             children: [
              //               CircleAvatar(
              //                 radius: 3,
              //                 backgroundColor: AppColor.primary,
              //               ),
              //               SizedBox(
              //                 width: 5,
              //               ),
              //               AppText(
              //                 text: 'Follow Up',
              //                 fontsize: 12,
              //                 fontWeight: FontWeight.w400,
              //                 textColor: AppColor.primary,
              //               )
              //             ],
              //           ),
              //           SizedBox(
              //             height: 3,
              //           ),
              //           AppText(
              //             text: 'Google meet 10:30-11:00 am',
              //             fontsize: 10,
              //             fontWeight: FontWeight.w300,
              //             textColor: Color.fromARGB(255, 63, 63, 63),
              //           )
              //         ]),
              //       ),
              //     ),
              //   ),
              // ),
              if (widget.isGroupChat) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppText(
                        text: 'Members',
                        textColor: Color(0xFF181818),
                        fontWeight: FontWeight.w700,
                        fontsize: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => AddGroupMembers(
                                  contactId: widget.contactId,
                                ),
                              ),
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.add_circle_outlined, size: 20, color: AppColor.primary),
                              SizedBox(
                                width: 5,
                              ),
                              AppText(
                                text: 'Add Members',
                                textColor: Color.fromARGB(255, 57, 57, 57),
                                fontWeight: FontWeight.w700,
                                fontsize: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: GroupUserList(
                    userInfo: userInfo!,
                    adminId: widget.adminId,
                    contactId: widget.contactId,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: ElevatedButton(
                //     onPressed: () {
                //        onLeaveGroup();
                //    },
                //     style: ElevatedButton.styleFrom(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //     ),
                //     child: const Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         AppText(
                //           text: 'Leave Group',
                //           textColor: Colors.white,
                //           fontWeight: FontWeight.w500,
                //           fontsize: 17,
                //         ),
                //         SizedBox(width: 8.0),
                //         Icon(
                //           Icons.exit_to_app,
                //           size: 20,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                )
              ] else ...[
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => CreateGroupScreen(
                          alreadySelectedUser: widget.contactId,
                          createGroup: true,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            child: Icon(
                              Icons.group_add_outlined,
                              size: 22,
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: 'Create group with ${widget.name}',
                                textColor: AppColor.primary,
                                fontWeight: FontWeight.w700,
                                fontsize: 14,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
