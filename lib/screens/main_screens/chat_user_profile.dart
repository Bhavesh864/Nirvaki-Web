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
import 'package:yes_broker/widgets/chat/group/leave_delete_group_button.dart';

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
                LeaveDeleteGroupPopupButton(
                  contactId: widget.contactId,
                  adminId: widget.adminId!,
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
  final Function? onPressAddMember;
  final Function? goToCreateGroup;

  const UserProfileBody({
    Key? key,
    required this.profilePic,
    required this.contactId,
    required this.name,
    this.adminId,
    required this.isGroupChat,
    this.user,
    this.onGoBack,
    this.onPressAddMember,
    this.goToCreateGroup,
  }) : super(key: key);

  @override
  ConsumerState<UserProfileBody> createState() => _UserProfileBodyState();
}

class _UserProfileBodyState extends ConsumerState<UserProfileBody> {
  List<User>? userInfo = [];

  @override
  void initState() {
    super.initState();
    if (widget.isGroupChat) {
      getUserDetails();
    }
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
      height: Responsive.isMobile(context) ? height : 540,
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
                                if (!Responsive.isMobile(context)) {
                                  widget.onGoBack!();
                                }
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
                      GestureDetector(
                        onTap: () {
                          if (Responsive.isMobile(context)) {
                            showEnlargedImage(context, widget.profilePic);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                              widget.profilePic.isEmpty ? noImg : widget.profilePic,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (widget.isGroupChat)
                        Consumer(
                          builder: (context, ref, child) {
                            final selectedUserIds = ref.watch(selectedUserIdsProvider);

                            return AppText(
                              text: '(${selectedUserIds.length} Participants)',
                              textColor: Colors.grey,
                              fontWeight: FontWeight.w700,
                              fontsize: 12,
                            );
                          },
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
                                    text: widget.user!.mobile,
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
                      if (widget.adminId == AppConst.getAccessToken())
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: InkWell(
                            onTap: () {
                              if (Responsive.isMobile(context)) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => AddGroupMembers(
                                      contactId: widget.contactId,
                                    ),
                                  ),
                                );
                              } else {
                                widget.onPressAddMember!();
                              }
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.add_circle_outlined,
                                  size: 20,
                                  color: AppColor.primary,
                                ),
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
                const SizedBox(
                  height: 10,
                )
              ] else ...[
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    if (Responsive.isMobile(context)) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => CreateGroupScreen(
                            alreadySelectedUser: widget.contactId,
                            createGroup: true,
                          ),
                        ),
                      );
                    } else {
                      widget.goToCreateGroup!();
                    }
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

void showEnlargedImage(BuildContext context, picture) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: SizedBox(
            width: width,
            height: 300,
            child: Image.network(
              picture.isEmpty ? noImg : picture,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    },
  );
}
