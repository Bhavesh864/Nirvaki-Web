// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/screens/main_screens/chat_list_screen.dart';
import 'package:yes_broker/screens/main_screens/chat_user_profile.dart';

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
    if (widget.user != null) {
      final user = await User.getUser(widget.user!.userId);
      setState(() {
        userInfo = user;
      });
      userInfo = user;
    }
  }

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String chatItemId = widget.chatItem?.id ?? widget.user?.brokerId ?? '';
    final bool isGroupChat = widget.chatItem?.isGroupChat ?? false;
    final String name = widget.chatItem?.name ?? '${widget.user?.userfirstname} ${widget.user?.userlastname}';
    final String profilePic = widget.chatItem?.profilePic ?? widget.user?.image ?? '';
    final String adminId = widget.chatItem?.adminId ?? '';

    return Row(
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
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  profilePic.isEmpty ? noImg : profilePic,
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
                    fontWeight: FontWeight.w500,
                    fontsize: 15,
                  ),
                  const AppText(
                    text: "Online",
                    textColor: Color.fromRGBO(155, 155, 155, 1),
                    fontWeight: FontWeight.w400,
                    fontsize: 12,
                    maxLines: 1,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
