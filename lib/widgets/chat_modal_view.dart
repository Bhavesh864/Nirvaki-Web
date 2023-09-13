import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/screens/main_screens/add_group_member_screen.dart';

import 'package:yes_broker/screens/main_screens/chat_list_screen.dart';
import 'package:yes_broker/screens/main_screens/chat_user_profile.dart';
import 'package:yes_broker/screens/main_screens/create_group_screen.dart';
import 'package:yes_broker/widgets/chat/group/newchat_newgroup_popup.dart';
import '../Customs/custom_text.dart';
import '../chat/controller/chat_controller.dart';
import '../constants/app_constant.dart';
import '../constants/utils/constants.dart';
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
  ChatModalScreenType currentScreen = ChatModalScreenType.chatList;
  ChatItem? chatItem;
  User? user;

  @override
  Widget build(BuildContext context) {
    final selectedUserIds = ref.read(selectedUserIdsProvider.notifier);
    final ScrollController messageController = ScrollController();

    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: const EdgeInsets.only(bottom: 45, right: 80),
        width: 450,
        child: Card(
          color: const Color(0xFFF5F9FE),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: currentScreen == ChatModalScreenType.chatList ? 15 : 0,
              vertical: currentScreen == ChatModalScreenType.chatList ? 20 : 0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (currentScreen == ChatModalScreenType.chatList) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
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
                                setState(() {});
                              },
                              createNewGroup: () {
                                currentScreen = ChatModalScreenType.createNewGroup;
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
                  ),
                ],
                if (currentScreen == ChatModalScreenType.chatScreen)
                  StreamBuilder(
                    stream: chatItem!.isGroupChat
                        ? ref.read(chatControllerProvider).groupChatStream(
                              chatItem!.id,
                            )
                        : ref.read(chatControllerProvider).chatStream(
                              chatItem!.id,
                            ),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: 400,
                          width: width,
                          child: const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        );
                      }

                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        messageController.jumpTo(messageController.position.maxScrollExtent);
                      });

                      return GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: Container(
                          height: 500,
                          margin: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: ChatScreenHeader(
                                  chatItem: chatItem,
                                  showProfileScreen: (u) {
                                    currentScreen = ChatModalScreenType.userProfile;
                                    user = u;
                                    setState(() {});
                                  },
                                  goToChatList: () {
                                    currentScreen = ChatModalScreenType.chatList;

                                    setState(() {});
                                  },
                                ),
                              ),
                              Divider(
                                height: 1,
                                thickness: 0.5,
                                color: Colors.grey.shade400,
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
                                      if (!isSender && !messageData.isSeen && !chatItem!.isGroupChat) {
                                        ref.read(chatControllerProvider).setChatMessageSeen(
                                              context,
                                              chatItem!.id,
                                              messageData.messageId,
                                              isSender,
                                            );
                                      }

                                      return MessageBox(
                                        message: messageData.text,
                                        isSender: isSender,
                                        data: messageData,
                                        isSeen: messageData.isSeen,
                                        messageType: messageData.type,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const Divider(height: 1.0),
                              ChatInput(
                                revceiverId: chatItem!.id,
                                isGroupChat: chatItem!.isGroupChat,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                if (currentScreen == ChatModalScreenType.userProfile)
                  UserProfileBody(
                    profilePic: chatItem!.profilePic,
                    name: chatItem!.name,
                    user: user,
                    contactId: chatItem!.id,
                    isGroupChat: chatItem!.isGroupChat,
                    adminId: chatItem!.adminId,
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
                  const SizedBox(
                    height: 500,
                    child: CreateGroupScreen(
                      createGroup: false,
                    ),
                  ),
                if (currentScreen == ChatModalScreenType.createNewGroup)
                  const SizedBox(
                    height: 500,
                    child: CreateGroupScreen(
                      createGroup: true,
                    ),
                  ),
                if (currentScreen == ChatModalScreenType.addNewMember)
                  SizedBox(
                    height: 500,
                    child: AddGroupMembersScreenBody(
                      contactId: chatItem!.id,
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
