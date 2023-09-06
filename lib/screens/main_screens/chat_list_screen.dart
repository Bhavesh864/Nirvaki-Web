import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/chat/controller/chat_controller.dart';
import 'package:yes_broker/chat/models/chat_contact.dart';
import 'package:yes_broker/chat/models/chat_group.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/customs/loader.dart';
import 'package:yes_broker/screens/main_screens/create_group_screen.dart';

import '../../Customs/responsive.dart';
import '../../constants/utils/colors.dart';
import 'chat_screen.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  builder: (ctx) => const CreateGroupScreen(),
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
        child: Column(
          children: [
            StreamBuilder<List<ChatContact>>(
              stream: ref.watch(chatControllerProvider).chatContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var chatContactData = snapshot.data![index];

                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              if (Responsive.isMobile(context)) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => ChatScreen(
                                      profilePic: chatContactData.profilePic,
                                      name: chatContactData.name,
                                      contactId: chatContactData.contactId,
                                      isGroupChat: false,
                                    ),
                                  ),
                                );
                              } else {
                                // onPressed(index);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                title: Text(
                                  chatContactData.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    chatContactData.lastMessage,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    chatContactData.profilePic == '' ? noImg : chatContactData.profilePic,
                                  ),
                                  radius: 30,
                                ),
                                trailing: Text(
                                  DateFormat.Hm().format(chatContactData.timeSent.toDate()),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
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
            ),
            StreamBuilder<List<ChatGroup>>(
              stream: ref.watch(chatControllerProvider).chatGroups(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var chatContactData = snapshot.data![index];

                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              if (Responsive.isMobile(context)) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => ChatScreen(
                                      profilePic: chatContactData.groupIcon,
                                      name: chatContactData.name,
                                      contactId: chatContactData.groupId,
                                      isGroupChat: true,
                                    ),
                                  ),
                                );
                              } else {
                                // onPressed(index);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                title: Text(
                                  chatContactData.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    chatContactData.lastMessage,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    chatContactData.groupIcon == '' ? noImg : chatContactData.groupIcon,
                                  ),
                                  radius: 30,
                                ),
                                trailing: Text(
                                  // '11:20',
                                  DateFormat.Hm().format(chatContactData.timeSent.toDate()),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
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
                return const Center(
                  child: SizedBox(),
                );
              },
            ),
          ],
        ),
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
