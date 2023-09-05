import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/chat/controller/chat_controller.dart';
import 'package:yes_broker/chat/models/chat_contact.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
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
    List<User> list = [];
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
                  builder: (ctx) => CreateGroupScreen(list: list),
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

//Groups List -----------
        // child: StreamBuilder(
        //     stream: FirebaseFirestore.instance.collection("groups").snapshots(),
        //     builder: (context, snapshot) {
        //       final usersListSnapshot = snapshot.data!.docs;
        //       // List<User> usersList = usersListSnapshot.map((doc) => User.fromSnapshot(doc)).toList();
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return const Center(
        //           child: CircularProgressIndicator.adaptive(),
        //         );
        //       }
        //       if (snapshot.hasData) {
        //         // return ListView.builder(

        //         //   itemBuilder: (ctx, index) {
        //         //     return Text(usersListSnapshot[index]["groupName"]);
        //         //   },
        //         // );
        //         return ListView.separated(
        //           separatorBuilder: (context, index) {
        //             return const Divider();
        //           },
        //           itemCount: usersListSnapshot.length,
        //           itemBuilder: (ctx, index) {
        //             final groupData = usersListSnapshot[index];
        //             return Material(
        //               color: Colors.white,
        //               child: ListTile(
        //                 minVerticalPadding: 0,
        //                 // contentPadding: EdgeInsets.zero,
        //                 dense: true,
        //                 onTap: () {
        //                   if (Responsive.isMobile(context)) {
        //                     Navigator.of(context).push(
        //                       MaterialPageRoute(
        //                         builder: (ctx) => GroupScreen(
        //                           user: groupData,
        //                         ),
        //                       ),
        //                     );
        //                   } else {
        //                     // onPressed(index);
        //                   }
        //                 },
        //                 splashColor: Colors.grey[350],
        //                 leading: // Hero(
        //                     // tag: user.userId,
        //                     CircleAvatar(
        //                   radius: 26,
        //                   backgroundImage: NetworkImage(
        //                     groupData['groupIcon'] == '' ? noImg : groupData['groupIcon'],
        //                   ),
        //                 ),
        //                 // ),
        //                 title: AppText(
        //                   text: groupData['groupName'],
        //                   textColor: const Color.fromRGBO(44, 44, 46, 1),
        //                   fontWeight: FontWeight.w500,
        //                   fontsize: 16,
        //                 ),
        //                 subtitle: const Row(
        //                   children: [
        //                     Flexible(
        //                       child: Padding(
        //                         padding: EdgeInsets.only(right: 10),
        //                         child: AppText(
        //                           overflow: TextOverflow.ellipsis,
        //                           text: 'Hey,',
        //                           textColor: Color.fromRGBO(155, 155, 155, 1),
        //                           fontWeight: FontWeight.w400,
        //                           fontsize: 15,
        //                           maxLines: 1,
        //                         ),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 trailing: Column(
        //                   // mainAxisSize: MainAxisSize.min,
        //                   children: [
        //                     const AppText(
        //                       text: '11:20 am',
        //                       textColor: Color.fromRGBO(155, 155, 155, 1),
        //                       fontWeight: FontWeight.w400,
        //                       fontsize: 10,
        //                       maxLines: 1,
        //                     ),
        //                     Container(
        //                       margin: const EdgeInsets.only(top: 5),
        //                       width: 20,
        //                       height: 20,
        //                       decoration: const BoxDecoration(
        //                         color: AppColor.primary,
        //                         shape: BoxShape.circle,
        //                       ),
        //                       child: const Center(
        //                         child: Text(
        //                           '2',
        //                           style: TextStyle(
        //                             color: Colors.white,
        //                             fontSize: 11,
        //                             fontWeight: FontWeight.bold,
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             );
        //           },
        //         );
        //       }
        //       return const SizedBox();
        //     }),

        //Users List ------
        // child: StreamBuilder(
        //     stream: FirebaseFirestore.instance.collection("users").where("brokerId", isEqualTo: currentUser["brokerId"]).snapshots(),
        //     builder: (context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return const Center(
        //           child: CircularProgressIndicator.adaptive(),
        //         );
        //       }
        //       if (snapshot.hasData) {
        //         final usersListSnapshot = snapshot.data!.docs;
        //         List<User> usersList = usersListSnapshot.map((doc) => User.fromSnapshot(doc)).toList();
        //         List<User> filterUser = usersList.where((element) => element.userId != AppConst.getAccessToken()).toList();
        //         list = filterUser;
        // return ChatUserList(
        //           users: filterUser,
        //         );
        //       }
        //       return const SizedBox();
        //     }),

        child: StreamBuilder<List<ChatContact>>(
            stream: ref.watch(chatControllerProvider).chatContacts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }

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
                                  data: chatContactData,
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
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => CreateGroupScreen(
                list: list,
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
