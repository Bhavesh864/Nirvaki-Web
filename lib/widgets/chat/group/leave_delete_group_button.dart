// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/customs/custom_text.dart';

import '../../../constants/app_constant.dart';
import '../../../constants/functions/chat_group/group.dart';

class LeaveDeleteGroupPopupButton extends StatelessWidget {
  final String contactId;
  final String adminId;
  final String chatItemName;
  final bool isGroupChat;
  const LeaveDeleteGroupPopupButton({Key? key, required this.contactId, required this.adminId, required this.chatItemName, required this.isGroupChat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
        child: const Icon(
          Icons.more_vert,
          size: 16,
        ),
      ),
      onSelected: (value) {
        if (value == 'leave_group') {
          onLeaveGroup(context, contactId);
        } else if (value == 'delete_group') {
          onDeleteGroup(context, contactId);
        } else if (value == "clear_chat") {
          onClearChat(context, contactId, chatItemName, isGroupChat);
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          if (isGroupChat) ...[
            const PopupMenuItem<String>(
              value: 'leave_group',
              child: Row(
                children: [
                  CustomText(
                    title: 'Exit Group',
                    size: 13,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.exit_to_app,
                    size: 14,
                  ),
                ],
              ),
            ),
          ],
          if (AppConst.getAccessToken() == adminId && isGroupChat) ...[
            const PopupMenuItem<String>(
              value: 'delete_group',
              child: Row(
                children: [
                  CustomText(
                    title: 'Delete Group',
                    size: 13,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.delete_outline,
                    size: 14,
                  ),
                ],
              ),
            ),
          ],
          const PopupMenuItem<String>(
            value: 'clear_chat',
            child: Row(
              children: [
                AppText(
                  text: 'Clear Chat',
                  fontsize: 13,
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.delete_outline,
                  size: 14,
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}
