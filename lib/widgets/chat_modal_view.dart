import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/customs/loader.dart';
import 'package:yes_broker/screens/main_screens/add_group_member_screen.dart';
import 'package:yes_broker/screens/main_screens/chat_screens/chat_list_screen.dart';
import 'package:yes_broker/screens/main_screens/chat_screens/chat_user_profile.dart';
import 'package:yes_broker/screens/main_screens/chat_screens/create_group_screen.dart';
import 'package:yes_broker/widgets/chat/group/newchat_newgroup_popup.dart';
import '../Customs/custom_text.dart';
import '../Customs/text_utility.dart';
import '../chat/controller/chat_controller.dart';
import '../chat/models/message.dart';
import '../constants/app_constant.dart';
import '../constants/methods/date_time_methods.dart';
import '../constants/utils/colors.dart';
import '../riverpodstate/chat/message_selection_state.dart';
import 'chat/chat_input.dart';
import 'chat/chat_screen_header.dart';
import 'chat/group/newgroup_user_list.dart';
import 'chat/message_box.dart';

enum ChatModalScreenType {
  chatList,
  chatScreen,
  userProfile,
  newChat,
  createNewGroup,
  addNewMember,
  messageForward,
  photoFullView,
}

class ChatDialogBox extends ConsumerStatefulWidget {
  const ChatDialogBox({super.key});

  @override
  ConsumerState<ChatDialogBox> createState() => _ChatDialogBoxState();
}

class _ChatDialogBoxState extends ConsumerState<ChatDialogBox> {
  late ScrollController messageController;
  final FocusNode focusNode = FocusNode();

  List<String> selectedMessageList = [];
  bool selectedMode = false;

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
  String imageUrl = '';

  void onPressSendButton(List<String> selectedUsers, List<ChatItem> groupChatList) {
    for (var userId in selectedUsers) {
      for (var msgData in ref.read(selectedMessageProvider)) {
        ref.read(chatControllerProvider).sendTextMessage(
              context,
              msgData.text,
              userId,
              groupChatList.firstWhere((element) => element.id == userId).isGroupChat,
              messageType: msgData.type,
            );
      }
    }

    ref.read(selectedMessageProvider.notifier).setToEmpty();
    currentScreen = ChatModalScreenType.chatList;
    selectedMessageList = [];
    selectedMode = false;
    setState(() {});
  }

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
              mainAxisAlignment: MainAxisAlignment.center,
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

                        if (snapshot.hasData) {
                          List<ChatMessage> messagesList = snapshot.data!;

                          if (messagesList.length > 3) {
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              messageController.animateTo(
                                messageController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 50),
                                curve: Curves.ease,
                              );
                            });
                          }

                          if (isGroupChat) {
                            messagesList = messagesList.where((element) => !element.deleteMsgUserId.contains(AppConst.getAccessToken())).toList();
                          }

                          return StatefulBuilder(builder: (context, setstate) {
                            removeAll() {
                              setstate(
                                () {
                                  selectedMessageList = [];
                                  selectedMode = false;
                                  ref.read(selectedMessageProvider.notifier).setToEmpty();
                                },
                              );
                            }

                            return Container(
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
                                          setState(() {});
                                        },
                                        goToChatList: () {
                                          currentScreen = ChatModalScreenType.chatList;
                                          if (selectedMode) {
                                            removeAll();
                                          }
                                          setState(() {});
                                        },
                                        goToForwardScreen: () {
                                          currentScreen = ChatModalScreenType.messageForward;
                                          setState(() {});
                                        },
                                        selectedMessageList: selectedMessageList,
                                        selectedMode: selectedMode,
                                        toggleSelectedMode: (bool k) {
                                          setstate(
                                            () {
                                              selectedMode = k;
                                            },
                                          );
                                        },
                                        removeAllItems: removeAll,
                                        // removeItem: remove,
                                        dataList: messagesList),
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 0.5,
                                    color: Colors.grey.shade400,
                                  ),
                                  if (isGroupChat && messagesList.isEmpty)
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
                                        itemCount: messagesList.length + 1,
                                        itemBuilder: (BuildContext context, int index) {
                                          if (index == messagesList.length) {
                                            return Container();
                                          }
                                          final messageData = messagesList[index];
                                          final currentMessageId = messageData.messageId;
                                          final isSender = messageData.senderId == AppConst.getAccessToken();

                                          final bool isFirstMessageOfNewDay = index == 0 ||
                                              !isSameDay(
                                                messageData.timeSent.toDate(),
                                                messagesList[index - 1].timeSent.toDate(),
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
                                                // onOpenFullImage: () {
                                                //   print('object');
                                                //   setState(() {
                                                //     currentScreen = ChatModalScreenType.photoFullView;
                                                //     imageUrl = messageData.text;
                                                //   });
                                                // },
                                                isGroupChat: isGroupChat,
                                                message: messageData.text,
                                                isSender: isSender,
                                                data: messageData,
                                                isSeen: messageData.isSeen,
                                                messageType: messageData.type,
                                                selectedMessageList: selectedMessageList,
                                                selectedMode: selectedMode,
                                                onLongPress: () {
                                                  setstate(() {
                                                    selectedMode = true;
                                                    selectedMessageList.add(currentMessageId);
                                                    ref.read(selectedMessageProvider.notifier).addMessage(messageData);
                                                  });
                                                },
                                                onTap: () {
                                                  setstate(() {
                                                    if (selectedMessageList.isNotEmpty && selectedMode) {
                                                      if (selectedMessageList.contains(currentMessageId)) {
                                                        selectedMessageList.remove(currentMessageId);
                                                        if (selectedMessageList.isEmpty) {
                                                          selectedMode = false;
                                                        }
                                                        ref.read(selectedMessageProvider.notifier).removeMessge(messageData);
                                                      } else if (selectedMode) {
                                                        selectedMessageList.add(currentMessageId);
                                                        ref.read(selectedMessageProvider.notifier).addMessage(messageData);
                                                      }
                                                    } else {
                                                      removeAll();
                                                    }
                                                  });
                                                },
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
                            );
                          });
                        }
                        return const SizedBox();
                      }),
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
                  ),
                if (currentScreen == ChatModalScreenType.messageForward)
                  StreamBuilder(
                    stream: mergeChatContactsAndGroups(ref),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Loader();
                      }
                      if (snapshot.hasData) {
                        final filterUser = snapshot.data!;

                        final List<String> selectedUsers = [];
                        List<ChatItem> groupChatList = [];

                        void toggleUse(ChatItem user) {
                          if (selectedUsers.contains(user.id)) {
                            selectedUsers.remove(user.id);
                            groupChatList.remove(user);
                          } else {
                            if (selectedUsers.length == 5) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Limit Reached"),
                                    content: const Text("You can only share with up to 5 chats."),
                                    actions: [
                                      TextButton(
                                        child: const Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              selectedUsers.add(user.id);
                              groupChatList.add(user);
                            }
                          }
                        }

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    currentScreen = ChatModalScreenType.chatScreen;
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    size: 22,
                                  ),
                                ),
                                const AppText(
                                  text: 'Forward to...',
                                  fontsize: 15,
                                  textColor: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    size: 22,
                                  ),
                                ),
                              ],
                            ),
                            StatefulBuilder(
                              builder: (context, setstate) {
                                return Container(
                                  height: 440,
                                  margin: const EdgeInsets.only(top: 5),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: GroupAndUsersMergedListToForward(
                                      users: filterUser,
                                      selectedUser: selectedUsers,
                                      toggleUser: (user) {
                                        setstate(
                                          () {
                                            toggleUse(user);
                                          },
                                        );
                                      }),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  onPressSendButton(selectedUsers, groupChatList);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppText(
                                      text: 'Send',
                                      textColor: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontsize: 17,
                                    ),
                                    SizedBox(width: 8.0),
                                    Icon(
                                      Icons.send,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                if (currentScreen == ChatModalScreenType.photoFullView) ImagePreview(url: imageUrl, type: 'image'),
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
