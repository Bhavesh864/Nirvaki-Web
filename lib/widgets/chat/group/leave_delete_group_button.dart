// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/customs/custom_text.dart';

import '../../../constants/app_constant.dart';
import '../../../constants/functions/chat_group/group.dart';

class LeaveDeleteGroupPopupButton extends StatelessWidget {
  final String contactId;
  final String adminId;

  const LeaveDeleteGroupPopupButton({
    Key? key,
    required this.contactId,
    required this.adminId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
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
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'leave_group',
            child: Row(
              children: [
                CustomText(title: 'Leave Group'),
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
          if (AppConst.getAccessToken() == adminId) ...[
            const PopupMenuItem<String>(
              value: 'delete_group',
              child: Row(
                children: [
                  CustomText(title: 'Delete Group'),
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
    );
  }
}
