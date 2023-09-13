// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:yes_broker/customs/custom_text.dart';

class NewChatNewGroupPopupButton extends StatelessWidget {
  final Function openNewChat;
  final Function createNewGroup;

  const NewChatNewGroupPopupButton({
    Key? key,
    required this.openNewChat,
    required this.createNewGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      child: const Icon(
        Icons.more_vert,
        size: 22,
      ),
      onSelected: (value) {
        if (value == 'new_chat') {
          openNewChat();
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (ctx) => const CreateGroupScreen(
          //       createGroup: false,
          //     ),
          //   ),
          // );
        } else if (value == 'create_group') {
          createNewGroup();
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (ctx) => const CreateGroupScreen(
          //       createGroup: true,
          //     ),
          //   ),
          // );
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'new_chat',
            child: Row(
              children: [
                CustomText(
                  title: 'New Chat',
                  size: 12,
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.chat_outlined,
                  size: 12,
                ),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'create_group',
            child: Row(
              children: [
                CustomText(
                  title: 'Create New Group',
                  size: 12,
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.group_add_outlined,
                  size: 12,
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}
