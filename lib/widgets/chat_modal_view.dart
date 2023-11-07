import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/customs/loader.dart';
import 'package:yes_broker/riverpodstate/chat/message_selection_state.dart';
import 'package:yes_broker/screens/main_screens/add_group_member_screen.dart';

import 'package:yes_broker/screens/main_screens/chat_list_screen.dart';
import 'package:yes_broker/screens/main_screens/chat_user_profile.dart';
import 'package:yes_broker/screens/main_screens/create_group_screen.dart';
import 'package:yes_broker/widgets/chat/group/newchat_newgroup_popup.dart';
import '../Customs/custom_text.dart';
import '../chat/controller/chat_controller.dart';
import '../constants/app_constant.dart';
import '../constants/methods/date_time_methods.dart';
import '../constants/utils/colors.dart';
import 'chat/chat_input.dart';
import 'chat/chat_screen_header.dart';
import 'chat/message_box.dart';

enum ChatModalScreenType {
  chatList,
  chatScreen,
  userProfile,
  newChat,
  createNewGroup,
  addNewMember,
}

class ChatDialogBox extends ConsumerStatefulWidget {
  const ChatDialogBox({super.key});

  @override
  ConsumerState<ChatDialogBox> createState() => _ChatDialogBoxState();
}

class _ChatDialogBoxState extends ConsumerState<ChatDialogBox> {
  late ScrollController messageController;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    messageController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  ChatModalScreenType currentScreen = ChatModalScreenType.chatList;
  ChatItem? chatItem;
  User? user;
  bool alreadySelectedUser = false;

  @override
  Widget build(BuildContext context) {
    final selectedUserIds = ref.read(selectedUserIdsProvider.notifier);

    final String chatItemId = chatItem?.id ?? user?.userId ?? '';
    final bool isGroupChat = chatItem?.isGroupChat ?? false;
    final String name = chatItem?.name ?? '${user?.userfirstname} ${user?.userlastname}';
    final String profilePic = chatItem?.profilePic ?? user?.image ?? '';
    final String adminId = chatItem?.adminId ?? '';

    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: const EdgeInsets.only(bottom: 45, right: 80),
        // width: wid > 800 ? wid / 2.4 : wid / 2,
        width: 600,
        height: 600,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: const Color(0xFFF5F9FE),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: currentScreen == ChatModalScreenType.chatList ? 15 : 0,
              vertical: currentScreen == ChatModalScreenType.chatList ? 20 : 0,
            ),
            child: Column(
              children: [
                if (currentScreen == ChatModalScreenType.chatList) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          title: 'Chat',
                          fontWeight: FontWeight.w600,
                        ),
                        Row(
                          children: [
                            NewChatNewGroupPopupButton(
                              openNewChat: () {
                                currentScreen = ChatModalScreenType.newChat;
                                alreadySelectedUser = false;
                                setState(() {});
                              },
                              createNewGroup: () {
                                currentScreen = ChatModalScreenType.createNewGroup;
                                alreadySelectedUser = false;
                                setState(() {});
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              child: const Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.black87,
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    // height: 470,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: TestList(
                              selectedUserIds: selectedUserIds,
                              onPressed: (c) {
                                currentScreen = ChatModalScreenType.chatScreen;
                                chatItem = c;
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (currentScreen == ChatModalScreenType.chatScreen)
                  StreamBuilder(
                    stream: isGroupChat
                        ? ref.read(chatControllerProvider).groupChatStream(
                              chatItemId,
                            )
                        : ref.read(chatControllerProvider).chatStream(
                              chatItemId,
                            ),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Loader();
                      }

                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        messageController.animateTo(
                          messageController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 50),
                          curve: Curves.ease,
                        );
                      });

                      return GestureDetector(
                        onTap: () {
                          if (!kIsWeb) {
                            FocusScope.of(context).unfocus();
                          }
                        },
                        child: Container(
                          height: 530,
                          margin: const EdgeInsets.only(top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: ChatScreenHeader(
                                  chatItem: chatItem,
                                  user: user,
                                  showProfileScreen: (u) {
                                    currentScreen = ChatModalScreenType.userProfile;
                                    user = u;
                                    setState(
                                      () {},
                                    );
                                  },
                                  goToChatList: () {
                                    currentScreen = ChatModalScreenType.chatList;
                                    setState(
                                      () {},
                                    );
                                  },
                                ),
                              ),
                              Divider(
                                height: 1,
                                thickness: 0.5,
                                color: Colors.grey.shade400,
                              ),
                              if (isGroupChat && snapshot.data!.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                  child: Chip(
                                    shape: const StadiumBorder(),
                                    // backgroundColor: Colors.grey.shade200,
                                    backgroundColor: AppColor.chipGreyColor,

                                    label: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                      child: Text(
                                        chatItem!.groupCreatedBy!,
                                        style: const TextStyle(
                                          color: Colors.black45,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: ScrollConfiguration(
                                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                                  child: ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    controller: messageController,
                                    itemCount: snapshot.data!.length + 1,
                                    itemBuilder: (BuildContext context, int index) {
                                      if (index == snapshot.data!.length) {
                                        return Container();
                                      }
                                      final messageData = snapshot.data![index];
                                      final isSender = messageData.senderId == AppConst.getAccessToken();

                                      final bool isFirstMessageOfNewDay = index == 0 ||
                                          !isSameDay(
                                            messageData.timeSent.toDate(),
                                            snapshot.data![index - 1].timeSent.toDate(),
                                          );

                                      final bool isNewWeek = DateTime.now().difference(messageData.timeSent.toDate()).inDays >= 7;
                                      final String messageDay = getMessageDay(messageData.timeSent.toDate(), isNewWeek);

                                      if (!isSender && !messageData.isSeen && !isGroupChat) {
                                        ref.read(chatControllerProvider).setChatMessageSeen(
                                              context,
                                              chatItemId,
                                              messageData.messageId,
                                              isSender,
                                            );
                                      }

                                      return Column(
                                        children: [
                                          if (isGroupChat && index == 0)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                                              child: Chip(
                                                shape: const StadiumBorder(),
                                                // backgroundColor: Colors.grey.shade200,
                                                backgroundColor: AppColor.chipGreyColor,

                                                label: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                                  child: Text(
                                                    chatItem!.groupCreatedBy!,
                                                    style: const TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (isFirstMessageOfNewDay) ...[
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                                              child: Chip(
                                                shape: const StadiumBorder(),
                                                // backgroundColor: Colors.grey.shade200,
                                                backgroundColor: AppColor.chipGreyColor,

                                                label: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                                  child: Text(
                                                    messageDay,
                                                    style: const TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                          MessageBox(
                                            isGroupChat: isGroupChat,
                                            message: messageData.text,
                                            isSender: isSender,
                                            data: messageData,
                                            isSeen: messageData.isSeen,
                                            messageType: messageData.type,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const Divider(height: 1.0),
                              ChatInput(
                                revceiverId: chatItemId,
                                isGroupChat: isGroupChat,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                if (currentScreen == ChatModalScreenType.userProfile)
                  UserProfileBody(
                    profilePic: profilePic,
                    name: name,
                    user: user,
                    contactId: chatItemId,
                    isGroupChat: isGroupChat,
                    adminId: adminId,
                    goToCreateGroup: () {
                      alreadySelectedUser = true;
                      currentScreen = ChatModalScreenType.createNewGroup;
                      setState(() {});
                    },
                    onGoBack: () {
                      currentScreen = ChatModalScreenType.chatScreen;
                      setState(() {});
                    },
                    onPressAddMember: () {
                      currentScreen = ChatModalScreenType.addNewMember;
                      setState(() {});
                    },
                  ),
                if (currentScreen == ChatModalScreenType.newChat)
                  Expanded(
                    // height: 500,
                    child: CreateGroupScreen(
                      createGroup: false,
                      alreadySelectedUser: alreadySelectedUser ? chatItemId : null,
                      goToChatScreen: (u) {
                        currentScreen = ChatModalScreenType.chatScreen;
                        user = u;
                        chatItem = null;
                        setState(() {});
                      },
                      goToChatList: () {
                        currentScreen = ChatModalScreenType.chatList;
                        setState(() {});
                      },
                    ),
                  ),
                if (currentScreen == ChatModalScreenType.createNewGroup)
                  Expanded(
                    // height: 500,
                    child: CreateGroupScreen(
                      createGroup: true,
                      alreadySelectedUser: alreadySelectedUser ? chatItemId : null,
                      goToChatScreen: (u) {
                        currentScreen = ChatModalScreenType.chatScreen;
                        user = u;
                        chatItem = null;
                        setState(() {});
                      },
                      goToChatList: () {
                        currentScreen = ChatModalScreenType.chatList;
                        setState(() {});
                      },
                    ),
                  ),
                if (currentScreen == ChatModalScreenType.addNewMember)
                  Expanded(
                    // height: 500,
                    child: AddGroupMembersScreenBody(
                      contactId: chatItem!.id,
                      onSubmitCallback: (s) {},
                      goToUserProfile: () {
                        currentScreen = ChatModalScreenType.userProfile;
                        setState(() {});
                      },
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
// import 'package:yes_broker/customs/loader.dart';
// import 'package:yes_broker/screens/main_screens/add_group_member_screen.dart';

// import 'package:yes_broker/screens/main_screens/chat_list_screen.dart';
// import 'package:yes_broker/screens/main_screens/chat_user_profile.dart';
// import 'package:yes_broker/screens/main_screens/create_group_screen.dart';
// import 'package:yes_broker/widgets/chat/group/newchat_newgroup_popup.dart';
// import '../Customs/custom_text.dart';
// import '../chat/controller/chat_controller.dart';
// import '../constants/app_constant.dart';
// import '../constants/functions/datetime/date_time.dart';
// import 'chat/chat_input.dart';
// import 'chat/chat_screen_header.dart';
// import 'chat/message_box.dart';

// final chatDialogStateProvider = StateProvider<ChatModalScreenType>((ref) => ChatModalScreenType.chatList);
// final chatItemProvider = StateProvider<ChatItem?>((ref) => null);
// final selectedUserIdsProvider = StateProvider<List<String>>((ref) => []);
// final userProfileProvider = StateProvider<User?>((ref) => null);

// enum ChatModalScreenType {
//   chatList,
//   chatScreen,
//   userProfile,
//   newChat,
//   createNewGroup,
//   addNewMember,
// }

// class ChatDialogBox extends ConsumerStatefulWidget {
//   const ChatDialogBox({super.key});

//   @override
//   ConsumerState<ChatDialogBox> createState() => _ChatDialogBoxState();
// }

// class _ChatDialogBoxState extends ConsumerState<ChatDialogBox> {
//   late ScrollController messageController;

//   @override
//   void initState() {
//     messageController = ScrollController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     messageController.dispose();
//     super.dispose();
//   }

//   ChatModalScreenType currentScreen = ChatModalScreenType.chatList;
//   ChatItem? chatItem;
//   User? user;
//   bool alreadySelectedUser = false;

//   @override
//   Widget build(BuildContext context) {
//     final selectedUserIds = ref.read(selectedUserIdsProvider.notifier);

//     final String chatItemId = chatItem?.id ?? user?.userId ?? '';
//     final bool isGroupChat = chatItem?.isGroupChat ?? false;
//     final String name = chatItem?.name ?? '${user?.userfirstname} ${user?.userlastname}';
//     final String profilePic = chatItem?.profilePic ?? user?.image ?? '';
//     final String adminId = chatItem?.adminId ?? '';

//     return Align(
//       alignment: Alignment.bottomRight,
//       child: Container(
//         padding: const EdgeInsets.only(bottom: 45, right: 80),
//         // width: wid > 800 ? wid / 2.4 : wid / 2,
//         width: 600,
//         height: 600,
//         child: Card(
//           color: const Color(0xFFF5F9FE),
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: ref.watch(chatDialogStateProvider.notifier).state == ChatModalScreenType.chatList ? 15 : 0,
//               vertical: ref.watch(chatDialogStateProvider.notifier).state == ChatModalScreenType.chatList ? 20 : 0,
//             ),
//             child: Column(
//               // mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (currentScreen == ChatModalScreenType.chatList) ...[
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 10.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const CustomText(
//                           title: 'Chat',
//                           fontWeight: FontWeight.w600,
//                         ),
//                         Row(
//                           children: [
//                             NewChatNewGroupPopupButton(
//                               openNewChat: () {
//                                 ref.read(chatDialogStateProvider.notifier).state = ChatModalScreenType.newChat;
//                                 ref.read(chatItemProvider.notifier).state = null;
//                               },
//                               createNewGroup: () {
//                                 ref.read(chatDialogStateProvider.notifier).state = ChatModalScreenType.createNewGroup;
//                                 ref.read(chatItemProvider.notifier).state = null;
//                               },
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             InkWell(
//                               child: const Icon(
//                                 Icons.close,
//                                 size: 20,
//                               ),
//                               onTap: () {
//                                 Navigator.of(context).pop();
//                               },
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     // height: 470,
//                     child: Card(
//                       elevation: 0,
//                       child: Column(
//                         children: [
//                           Expanded(
//                             child: Container(
//                               decoration: const BoxDecoration(
//                                 color: Colors.white,
//                               ),
//                               child: TestList(
//                                 selectedUserIds: selectedUserIds,
//                                 onPressed: (c) {
//                                   currentScreen = ChatModalScreenType.chatScreen;
//                                   chatItem = c;
//                                   setState(() {});
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//                 if (currentScreen == ChatModalScreenType.chatScreen)
//                   StreamBuilder(
//                     stream: isGroupChat
//                         ? ref.read(chatControllerProvider).groupChatStream(
//                               chatItemId,
//                             )
//                         : ref.read(chatControllerProvider).chatStream(
//                               chatItemId,
//                             ),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasError) {
//                         return Text('Error ${snapshot.error}');
//                       }
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Loader();
//                       }

//                       SchedulerBinding.instance.addPostFrameCallback((_) {
//                         messageController.animateTo(
//                           messageController.position.maxScrollExtent,
//                           duration: const Duration(milliseconds: 50),
//                           curve: Curves.ease,
//                         );
//                       });

//                       return GestureDetector(
//                         onTap: () {
//                           FocusScope.of(context).unfocus();
//                         },
//                         child: Container(
//                           height: 530,
//                           margin: const EdgeInsets.only(top: 10),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Container(
//                                 margin: const EdgeInsets.only(bottom: 5),
//                                 child: ChatScreenHeader(
//                                   chatItem: chatItem,
//                                   user: user,
//                                   showProfileScreen: (u) {
//                                     currentScreen = ChatModalScreenType.userProfile;
//                                     user = u;
//                                     setState(() {});
//                                   },
//                                   goToChatList: () {
//                                     currentScreen = ChatModalScreenType.chatList;
//                                     setState(() {});
//                                   },
//                                 ),
//                               ),
//                               Divider(
//                                 height: 1,
//                                 thickness: 0.5,
//                                 color: Colors.grey.shade400,
//                               ),
//                               if (isGroupChat && snapshot.data!.isEmpty)
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 10, bottom: 10),
//                                   child: Chip(
//                                     shape: const StadiumBorder(),
//                                     backgroundColor: Colors.grey.shade200,
//                                     label: Padding(
//                                       padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
//                                       child: Text(
//                                         chatItem!.groupCreatedBy!,
//                                         style: const TextStyle(
//                                           color: Colors.black45,
//                                           fontSize: 12,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               Expanded(
//                                 child: ScrollConfiguration(
//                                   behavior: const ScrollBehavior().copyWith(overscroll: false),
//                                   child: ListView.builder(
//                                     physics: const ClampingScrollPhysics(),
//                                     controller: messageController,
//                                     itemCount: snapshot.data!.length + 1,
//                                     itemBuilder: (BuildContext context, int index) {
//                                       if (index == snapshot.data!.length) {
//                                         return Container();
//                                       }
//                                       final messageData = snapshot.data![index];
//                                       final isSender = messageData.senderId == AppConst.getAccessToken();

//                                       final bool isFirstMessageOfNewDay = index == 0 ||
//                                           !isSameDay(
//                                             messageData.timeSent.toDate(),
//                                             snapshot.data![index - 1].timeSent.toDate(),
//                                           );

//                                       final bool isNewWeek = index == 0 || messageData.timeSent.toDate().difference(messageData.timeSent.toDate()).inDays >= 7;
//                                       final String messageDay = getMessageDay(messageData.timeSent.toDate(), isNewWeek);

//                                       if (!isSender && !messageData.isSeen && !isGroupChat) {
//                                         ref.read(chatControllerProvider).setChatMessageSeen(
//                                               context,
//                                               chatItemId,
//                                               messageData.messageId,
//                                               isSender,
//                                             );
//                                       }

//                                       return Column(
//                                         children: [
//                                           if (isGroupChat && index == 0)
//                                             Padding(
//                                               padding: const EdgeInsets.only(top: 10, bottom: 10),
//                                               child: Chip(
//                                                 shape: const StadiumBorder(),
//                                                 backgroundColor: Colors.grey.shade200,
//                                                 label: Padding(
//                                                   padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
//                                                   child: Text(
//                                                     chatItem!.groupCreatedBy!,
//                                                     style: const TextStyle(
//                                                       color: Colors.black45,
//                                                       fontSize: 12,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           if (isFirstMessageOfNewDay) ...[
//                                             Padding(
//                                               padding: const EdgeInsets.only(top: 10.0, bottom: 10),
//                                               child: Chip(
//                                                 shape: const StadiumBorder(),
//                                                 backgroundColor: Colors.grey.shade200,
//                                                 label: Padding(
//                                                   padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
//                                                   child: Text(
//                                                     messageDay,
//                                                     style: const TextStyle(
//                                                       color: Colors.black45,
//                                                       fontSize: 12,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                           MessageBox(
//                                             message: messageData.text,
//                                             isSender: isSender,
//                                             data: messageData,
//                                             isSeen: messageData.isSeen,
//                                             messageType: messageData.type,
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ),
//                               const Divider(height: 1.0),
//                               ChatInput(
//                                 revceiverId: chatItemId,
//                                 isGroupChat: isGroupChat,
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 if (currentScreen == ChatModalScreenType.userProfile)
//                   UserProfileBody(
//                     profilePic: profilePic,
//                     name: name,
//                     user: user,
//                     contactId: chatItemId,
//                     isGroupChat: isGroupChat,
//                     adminId: adminId,
//                     goToCreateGroup: () {
//                       alreadySelectedUser = true;
//                       currentScreen = ChatModalScreenType.createNewGroup;
//                       setState(() {});
//                     },
//                     onGoBack: () {
//                       currentScreen = ChatModalScreenType.chatScreen;
//                       setState(() {});
//                     },
//                     onPressAddMember: () {
//                       currentScreen = ChatModalScreenType.addNewMember;
//                       setState(() {});
//                     },
//                   ),
//                 if (currentScreen == ChatModalScreenType.newChat)
//                   Expanded(
//                     // height: 500,
//                     child: CreateGroupScreen(
//                       createGroup: false,
//                       alreadySelectedUser: alreadySelectedUser ? chatItemId : null,
//                       goToChatScreen: (u) {
//                         currentScreen = ChatModalScreenType.chatScreen;
//                         user = u;
//                         chatItem = null;
//                         setState(() {});
//                       },
//                       goToChatList: () {
//                         currentScreen = ChatModalScreenType.chatList;
//                         setState(() {});
//                       },
//                     ),
//                   ),
//                 if (currentScreen == ChatModalScreenType.createNewGroup)
//                   Expanded(
//                     // height: 500,
//                     child: CreateGroupScreen(
//                       createGroup: true,
//                       alreadySelectedUser: alreadySelectedUser ? chatItemId : null,
//                       goToChatScreen: (u) {
//                         currentScreen = ChatModalScreenType.chatScreen;
//                         user = u;
//                         chatItem = null;
//                         setState(() {});
//                       },
//                       goToChatList: () {
//                         currentScreen = ChatModalScreenType.chatList;
//                         setState(() {});
//                       },
//                     ),
//                   ),
//                 if (currentScreen == ChatModalScreenType.addNewMember)
//                   Expanded(
//                     // height: 500,
//                     child: AddGroupMembersScreenBody(
//                       contactId: chatItem!.id,
//                       onSubmitCallback: (s) {},
//                       goToUserProfile: () {
//                         currentScreen = ChatModalScreenType.userProfile;
//                         setState(() {});
//                       },
//                     ),
//                   )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
