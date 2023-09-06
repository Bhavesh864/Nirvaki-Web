import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/screens/main_screens/chat_user_profile.dart';

class ChatScreenHeader extends StatefulWidget {
  final String contactId;
  final String profilePic;
  final String name;
  final String? adminId;
  final List<String>? members;
  final bool isGroupChat;

  const ChatScreenHeader({
    super.key,
    required this.contactId,
    required this.profilePic,
    required this.name,
    this.members,
    this.adminId,
    required this.isGroupChat,
  });

  @override
  State<ChatScreenHeader> createState() => _ChatScreenHeaderState();
}

class _ChatScreenHeaderState extends State<ChatScreenHeader> {
  User? userInfo;

  void getUserDetails() async {
    final user = await User.getUser(widget.contactId);
    userInfo = user;
  }

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(
              Icons.arrow_back,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => ChatUserProfile(
                  profilePic: widget.profilePic,
                  name: widget.name,
                  user: userInfo,
                  members: widget.members,
                  isGroupChat: widget.isGroupChat,
                  adminId: widget.adminId,
                ),
              ),
            );
          },
          child: Row(
            children: [
              Hero(
                tag: widget.contactId,
                child: CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                    widget.profilePic.isEmpty ? noImg : widget.profilePic,
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
                    text: widget.name,
                    textColor: const Color.fromRGBO(44, 44, 46, 1),
                    fontWeight: FontWeight.w500,
                    fontsize: 16,
                  ),
                  const AppText(
                    text: "11:20",
                    textColor: Color.fromRGBO(155, 155, 155, 1),
                    fontWeight: FontWeight.w400,
                    fontsize: 15,
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
