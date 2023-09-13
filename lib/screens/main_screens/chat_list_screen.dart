// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
// ignore: depend_on_referenced_packages
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
import 'package:yes_broker/screens/main_screens/chat_screen.dart';
import 'package:yes_broker/screens/main_screens/create_group_screen.dart';

import '../../Customs/responsive.dart';
import '../../constants/utils/colors.dart';

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
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const CreateGroupScreen(
                    createGroup: true,
                  ),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.add_circle_outline,
                color: Color.fromARGB(255, 92, 91, 91),
                size: 25,
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: TestList(selectedUserIds: selectedUserIds),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const CreateGroupScreen(
                createGroup: false,
              ),
            ),
          );
        },
        backgroundColor: AppColor.primary,
        child: const Icon(Icons.chat),
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
    return StreamBuilder<List<ChatItem>>(
      stream: mergeChatContactsAndGroups(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        if (snapshot.hasData) {
          final chatItems = snapshot.data!;
          return ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: chatItems.length,
            itemBuilder: (context, index) {
              final chatItem = chatItems[index];
              final isSender = chatItem.lastMessageSenderId == AppConst.getAccessToken();

              return Column(
                children: [
                  InkWell(
                    onTap: () {
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
                          title: Text(
                            chatItem.name,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              chatItem.lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              chatItem.profilePic == '' ? noImg : chatItem.profilePic,
                            ),
                            radius: 25,
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
                                  color: Colors.grey,
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
          );
        }
        return const SizedBox();
      },
    );
  }
}
