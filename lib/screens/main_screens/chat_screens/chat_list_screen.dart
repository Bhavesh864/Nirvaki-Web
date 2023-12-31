// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
// ignore: depend_on_referenced_packages
import 'dart:async';

import "package:rxdart/rxdart.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/chat/controller/chat_controller.dart';
import 'package:yes_broker/chat/models/chat_contact.dart';
import 'package:yes_broker/chat/models/chat_group.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/customs/loader.dart';
import 'package:yes_broker/screens/main_screens/chat_screens/chat_screen.dart';
import 'package:yes_broker/screens/main_screens/chat_screens/create_group_screen.dart';

import '../../../Customs/responsive.dart';
import '../../../constants/methods/string_methods.dart';
import '../../../constants/utils/colors.dart';

class ChatItem {
  final String id;
  final String adminId;
  final String name;
  final String profilePic;
  final String lastMessage;
  final DateTime timeSent;
  final bool isGroupChat;
  final bool lastMessageIsSeen;
  final String lastMessageSenderId;
  final List<String> membersUid;
  final String? groupCreatedBy;
  final String? role;

  ChatItem({
    required this.id,
    required this.adminId,
    required this.name,
    required this.profilePic,
    required this.lastMessage,
    required this.timeSent,
    required this.isGroupChat,
    required this.lastMessageIsSeen,
    required this.lastMessageSenderId,
    required this.membersUid,
    this.groupCreatedBy,
    this.role,
  });
}

Future<User?> getUserDetails(String id) async {
  final user = await User.getUser(id);
  return user;
}

final selectedUserIdsProvider = StateProvider<List<String>>((ref) => []);

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedUserIds = ref.read(selectedUserIdsProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const AppText(
          text: 'Chat',
          fontsize: 15,
          textColor: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          PopupMenuButton<int>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.white.withOpacity(1),
            offset: const Offset(100, 40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Icon(
                Icons.more_vert_outlined,
                color: Colors.black,
                size: 22,
              ),
            ),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<int>>[
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: const [
                      AppText(
                        text: 'New Chat  ',
                        fontsize: 13,
                      ),
                      Icon(
                        Icons.chat_outlined,
                        size: 16,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    children: const [
                      AppText(
                        text: 'Create Group  ',
                        fontsize: 13,
                      ),
                      Icon(
                        Icons.group_add_outlined,
                        size: 16,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ];
            },
            onSelected: (int value) {
              bool isGroup = value == 2 ? true : false;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => CreateGroupScreen(
                    createGroup: isGroup,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: TestList(selectedUserIds: selectedUserIds),
      ),
    );
  }
}

Stream<List<ChatItem>> mergeChatContactsAndGroups(WidgetRef ref) {
  final chatContactsStream = ref.watch(chatControllerProvider).chatContacts();
  final chatGroupsStream = ref.watch(chatControllerProvider).chatGroups();

  final mergedStream = Rx.combineLatest2<List<ChatContact>, List<ChatGroup>, List<ChatItem>>(
    chatContactsStream,
    chatGroupsStream,
    (chatContacts, chatGroups) {
      final chatItems = <ChatItem>[];

      chatItems.addAll(chatContacts.map((contact) => ChatItem(
            id: contact.contactId,
            name: contact.name,
            profilePic: contact.profilePic,
            lastMessage: contact.lastMessage,
            timeSent: contact.timeSent.toDate(),
            isGroupChat: false,
            lastMessageIsSeen: contact.lastMessageIsSeen,
            lastMessageSenderId: contact.lastMessageSenderId,
            membersUid: [],
            adminId: '',
            role: contact.role,
          )));

      chatItems.addAll(
        chatGroups.map(
          (group) => ChatItem(
            id: group.groupId,
            name: group.name,
            profilePic: group.groupIcon,
            lastMessage: group.lastMessage,
            timeSent: group.timeSent.toDate(),
            isGroupChat: true,
            lastMessageIsSeen: group.lastMessageIsSeen,
            lastMessageSenderId: group.lastMessageSenderId,
            membersUid: group.membersUid,
            adminId: group.senderId,
            groupCreatedBy: group.groupCreatedBy,
            role: '',
          ),
        ),
      );

      chatItems.sort((a, b) => b.timeSent.compareTo(a.timeSent));

      return chatItems;
    },
  );

  return mergedStream;
}

class TestList extends ConsumerWidget {
  final StateController<List<String>> selectedUserIds;
  final Function(ChatItem)? onPressed;

  const TestList({
    super.key,
    required this.selectedUserIds,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // void updateUnreadMessagesCount() {
    //   final chatBadge = ref.read(chatBadgeProvider.notifier);
    //   chatBadge.state++;
    // }

    return StreamBuilder<List<ChatItem>>(
      stream: mergeChatContactsAndGroups(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        if (snapshot.hasData) {
          final chatItems = snapshot.data!;

          return ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(scrollbars: false),
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: chatItems.length,
              itemBuilder: (context, index) {
                final chatItem = chatItems[index];
                final isSender = chatItem.lastMessageSenderId == AppConst.getAccessToken();

                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // final snapshot = FirebaseFirestore.instance.collection("groups").doc(chatItem.id).collection("chats");
                        // QuerySnapshot messagesSnapshot = await snapshot.get();
                        // for (QueryDocumentSnapshot doc in messagesSnapshot.docs) {
                        //   // Update each message document with the new field
                        //   await snapshot.doc(doc.id).update({
                        //     'deleteMsgUserId': []"], // Replace 'newField' with the actual field name
                        //   });
                        // }
                        selectedUserIds.update(
                          (state) => chatItem.membersUid,
                        );
                        if (!isSender && !chatItem.lastMessageIsSeen) {
                          ref.read(chatControllerProvider).setLastMessageSeen(
                                context,
                                chatItem.id,
                                chatItem.isGroupChat,
                                chatItem.id,
                              );
                        }
                        if (Responsive.isMobile(context)) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => ChatScreen(
                                chatItem: chatItem,
                              ),
                            ),
                          );
                        } else {
                          onPressed!(chatItem);
                        }
                      },
                      child: Container(
                        color: !isSender && !chatItem.lastMessageIsSeen ? AppColor.secondary : Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: AppText(
                                    text: capitalizeFirstLetter(chatItem.name),
                                    fontsize: 15,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                // if (!chatItem.isGroupChat && chatItem.role != 'Employee')
                                //   CustomChip(
                                //     paddingVertical: 8,
                                //     label: AppText(
                                //       text: chatItem.role!,
                                //       fontsize: 10,
                                //     ),
                                //   ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Row(
                                children: [
                                  if (isSender && !chatItem.isGroupChat && chatItem.lastMessage.isNotEmpty) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Icon(
                                        chatItem.lastMessageIsSeen ? Icons.done_all : Icons.done,
                                        color: chatItem.lastMessageIsSeen ? Colors.blue : Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                  ],
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: Responsive.isMobile(context) ? 150 : 300,
                                    ),
                                    child: Text(
                                      chatItem.lastMessage,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            leading: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  chatItem.profilePic == '' ? noImg : chatItem.profilePic,
                                ),
                                radius: 25,
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(),
                                if (!isSender && !chatItem.lastMessageIsSeen)
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor.primary,
                                    ),
                                  ),
                                Text(
                                  DateFormat.Hm().format(chatItem.timeSent),
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 60, 115, 15),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      indent: 85,
                      height: 5,
                    ),
                  ],
                );
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
