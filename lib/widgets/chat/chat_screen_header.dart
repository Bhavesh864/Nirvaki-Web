// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/screens/main_screens/chat_list_screen.dart';
import 'package:yes_broker/screens/main_screens/chat_user_profile.dart';
import 'package:yes_broker/widgets/chat/group/leave_delete_group_button.dart';

class ChatScreenHeader extends StatefulWidget {
  final ChatItem? chatItem;
  final User? user;
  final Function? showProfileScreen;
  final Function? goToChatList;

  const ChatScreenHeader({
    Key? key,
    this.chatItem,
    this.user,
    this.showProfileScreen,
    this.goToChatList,
  }) : super(key: key);

  @override
  State<ChatScreenHeader> createState() => _ChatScreenHeaderState();
}

class _ChatScreenHeaderState extends State<ChatScreenHeader> {
  User? userInfo;

  void getUserDetails() async {
    final user = await User.getUser(widget.chatItem?.id ?? widget.user!.userId);
    setState(() {
      userInfo = user;
    });
  }

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String chatItemId = widget.chatItem?.id ?? widget.user?.userId ?? '';
    final bool isGroupChat = widget.chatItem?.isGroupChat ?? false;
    final String name = widget.chatItem?.name ?? '${widget.user?.userfirstname} ${widget.user?.userlastname}';
    final String profilePic = widget.chatItem?.profilePic ?? widget.user?.image ?? '';
    final String adminId = widget.chatItem?.adminId ?? '';

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(chatItemId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final dataList = snapshot.data!.data();
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (Responsive.isMobile(context)) {
                          Navigator.of(context).pop();
                        } else {
                          widget.goToChatList!();
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.arrow_back,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (Responsive.isMobile(context)) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => ChatUserProfile(
                                profilePic: profilePic,
                                name: name,
                                user: userInfo,
                                isGroupChat: isGroupChat,
                                adminId: adminId,
                                contactId: chatItemId,
                              ),
                            ),
                          );
                        } else {
                          widget.showProfileScreen!(userInfo);
                        }
                      },
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                profilePic.isEmpty ? noImg : profilePic,
                              ),
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
                                text: name,
                                textColor: const Color.fromRGBO(44, 44, 46, 1),
                                fontWeight: FontWeight.w600,
                                fontsize: 16,
                              ),
                              if (!isGroupChat) ...[
                                AppText(
                                  text: dataList!['isOnline'] ? "Online" : 'Offline',
                                  textColor: AppColor.grey,
                                  fontWeight: FontWeight.w500,
                                  fontsize: 12,
                                  maxLines: 1,
                                ),
                              ] else
                                ...[]
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isGroupChat)
                  LeaveDeleteGroupPopupButton(
                    contactId: chatItemId,
                    adminId: adminId,
                  ),
              ],
            );
          }
          return const SizedBox();
        });
  }
}
