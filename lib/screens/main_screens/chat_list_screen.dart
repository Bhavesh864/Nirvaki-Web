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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => CreateGroupScreen(list: list)));
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
          ]),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where("brokerId", isEqualTo: currentUser["brokerId"])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    if (snapshot.hasData) {
                      final usersListSnapshot = snapshot.data!.docs;
                      List<User> usersList = usersListSnapshot
                          .map((doc) => User.fromSnapshot(doc))
                          .toList();
                      List<User> filterUser = usersList
                          .where((element) =>
                              element.userId != AppConst.getAccessToken())
                          .toList();
                      list = filterUser;
                      return ChatUserList(users: filterUser);
                    }
                    return const SizedBox();
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
