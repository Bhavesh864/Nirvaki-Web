import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/screens/main_screens/chat_list_screen.dart';

import '../Customs/custom_text.dart';
import '../constants/app_constant.dart';
import '../constants/firebase/userModel/user_info.dart';
import '../constants/utils/constants.dart';
import 'chat/chat_users_list.dart';

class ChatDialogBox extends ConsumerStatefulWidget {
  const ChatDialogBox({super.key});

  @override
  ConsumerState<ChatDialogBox> createState() => _ChatDialogBoxState();
}

class _ChatDialogBoxState extends ConsumerState<ChatDialogBox> {
  bool isChatOpen = false;
  List list = [];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // return ChatListScreen();
    final selectedUserIds = ref.read(selectedUserIdsProvider.notifier);

    return StreamBuilder(
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
            return Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.only(bottom: 45, right: 80),
                width: 450,
                child: Card(
                  color: const Color(0xFFF5F9FE),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isChatOpen ? 0 : 15, vertical: isChatOpen ? 0 : 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isChatOpen) ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const CustomText(
                                  title: 'Chat',
                                  fontWeight: FontWeight.w600,
                                ),
                                InkWell(
                                  child: const Icon(
                                    Icons.close,
                                    size: 20,
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 350,
                            child: Card(
                              elevation: 0,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: TestList(selectedUserIds: selectedUserIds)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ] else ...[
                          Column(
                            children: [
                              ListTile(
                                leading: SizedBox(
                                  width: 70,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        child: const Icon(
                                          Icons.arrow_back,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                        onTap: () {
                                          isChatOpen = false;
                                          setState(() {});
                                        },
                                      ),
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          filterUser[selectedIndex].image.isEmpty ? noImg : filterUser[selectedIndex].image,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                title: CustomText(title: '${filterUser[selectedIndex].userfirstname} ${filterUser[selectedIndex].userlastname}'),
                                subtitle: const CustomText(
                                  title: 'Abhi, John and 4 more',
                                  color: Color(0xFF9B9B9B),
                                ),
                                trailing: InkWell(
                                  child: const Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          // ChatScreen(
                          //   user: filterUser[selectedIndex],
                          // ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox();
        });
  }
}
