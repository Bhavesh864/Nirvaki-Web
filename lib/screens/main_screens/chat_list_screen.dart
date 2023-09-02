import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/screens/main_screens/create_group_screen.dart';
import 'package:yes_broker/widgets/chat/chat_users_list.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").where("brokerId", isEqualTo: currentUser["brokerId"]).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (snapshot.hasData) {
                final usersListSnapshot = snapshot.data!.docs;
                List<User> usersList = usersListSnapshot.map((doc) => User.fromSnapshot(doc)).toList();
                List<User> filterUser = usersList.where((element) => element.userId != AppConst.getAccessToken()).toList();
                list = filterUser;
                return ChatUserList(
                  users: filterUser,
                );
              }
              return const SizedBox();
            }),
      ),
    );
  }
}
