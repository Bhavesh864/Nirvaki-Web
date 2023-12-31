import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yes_broker/chat/repositories/chat_repositories.dart';

import '../../../Customs/text_utility.dart';
import '../../app_constant.dart';
import '../../firebase/chatModels/group_model.dart';
import '../../utils/colors.dart';

void onLeaveGroup(BuildContext context, String contactId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
        ),
      );
    },
  );
}

void onDeleteGroup(BuildContext context, String contactId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
        ),
      );
    },
  );
}

void onClearChat(BuildContext context, String docId, String username, bool isGroupChat) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const AppText(
            text: 'Clear Chat',
            fontsize: 20,
            fontWeight: FontWeight.w500,
          ),
          content: AppText(
            text: 'Clear all messages from $username',
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
              onPressed: () async {
                Navigator.of(context).pop();
                if (isGroupChat) {
                  print(isGroupChat);
                  await clearAllChatFromGroup(docId);
                } else {
                  await clearAllChatOneTOOneUserChat(docId);
                }
                ChatRepository.updateLastMessageInContactSubCollection(
                  docId,
                  "",
                  isGroupChat,
                  Timestamp.now().millisecondsSinceEpoch,
                );
              },
              child: const AppText(
                text: 'Delete',
                fontWeight: FontWeight.w500,
                fontsize: 16,
                textColor: AppColor.red,
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> clearAllChatFromGroup(String docId) async {
  print("object");
  final messagesCollection = FirebaseFirestore.instance.collection('groups').doc(docId).collection('chats');
  final messagesSnapshot = await messagesCollection.get();
  for (var messageDoc in messagesSnapshot.docs) {
    final List<dynamic> deletedBy = List<dynamic>.from(messageDoc.data()['deleteMsgUserId']);
    deletedBy.add(AppConst.getAccessToken());
    await messageDoc.reference.update({
      'deleteMsgUserId': deletedBy,
    });
  }
}

Future<void> clearAllChatOneTOOneUserChat(String docId) async {
  final collection = await FirebaseFirestore.instance.collection('users').doc(AppConst.getAccessToken()).collection('chats').doc(docId).collection('messages').get();
  for (QueryDocumentSnapshot doc in collection.docs) {
    await doc.reference.delete();
  }
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