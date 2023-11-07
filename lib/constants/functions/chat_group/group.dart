import 'package:flutter/material.dart';

import '../../../Customs/text_utility.dart';
import '../../app_constant.dart';
import '../../firebase/chatModels/group_model.dart';
import '../../utils/colors.dart';

void onLeaveGroup(BuildContext context, String contactId) {
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
              Group.deleteMember(groupId: contactId, memberIdToDelete: AppConst.getAccessToken());
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

void onDeleteGroup(BuildContext context, String contactId) {
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
              Group.deleteGroup(contactId);
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

void customConfirmationAlertDialog(
  BuildContext context,
  void Function() onConfirmPress,
  String title,
  String content,
  String cofirmText,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: AppText(
          text: title,
          fontsize: 20,
          fontWeight: FontWeight.w500,
        ),
        content: AppText(
          text: content,
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
            onPressed: onConfirmPress,
            child: AppText(
              text: cofirmText,
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