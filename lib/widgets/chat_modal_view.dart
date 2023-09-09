import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';

import 'package:yes_broker/screens/main_screens/chat_list_screen.dart';
import 'package:yes_broker/screens/main_screens/chat_user_profile.dart';
import '../Customs/custom_text.dart';
import '../chat/controller/chat_controller.dart';
import '../constants/app_constant.dart';
import '../constants/utils/constants.dart';
import 'chat/chat_input.dart';
import 'chat/chat_screen_header.dart';
import 'chat/message_box.dart';

class ChatDialogBox extends ConsumerStatefulWidget {
  const ChatDialogBox({super.key});

  @override
  ConsumerState<ChatDialogBox> createState() => _ChatDialogBoxState();
}

class _ChatDialogBoxState extends ConsumerState<ChatDialogBox> {
  bool isChatOpen = false;
  bool showProfileScreen = false;
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
                              child: TestList(
                                selectedUserIds: selectedUserIds,
                                onPressed: (c) {
                                  isChatOpen = true;
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
                ] else if (showProfileScreen) ...[
                  UserProfileBody(
                    profilePic: chatItem!.profilePic,
                    name: chatItem!.name,
                    user: user,
                    contactId: chatItem!.id,
                    isGroupChat: chatItem!.isGroupChat,
                    adminId: chatItem!.adminId,
                    onGoBack: () {
                      showProfileScreen = false;
                      setState(() {});
                    },
                  )
                ] else ...[
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
                              // ListTile(
                              //   leading: SizedBox(
                              //     width: 70,
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         InkWell(
                              //           child: const Icon(
                              //             Icons.arrow_back,
                              //             size: 20,
                              //             color: Colors.black,
                              //           ),
                              //           onTap: () {
                              //             isChatOpen = false;
                              //             setState(() {});
                              //           },
                              //         ),
                              //         CircleAvatar(
                              //           backgroundImage: NetworkImage(
                              //             // filterUser[selectedIndex].image.isEmpty ? noImg : filterUser[selectedIndex].image,
                              //             chatItem!.profilePic.isEmpty ? noImg : chatItem!.profilePic,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              //   title: CustomText(title: chatItem!.name),
                              //   subtitle: const CustomText(
                              //     title: 'Abhi, John and 4 more',
                              //     color: Color(0xFF9B9B9B),
                              //   ),
                              //   trailing: InkWell(
                              //     child: const Icon(
                              //       Icons.close,
                              //       size: 20,
                              //       color: Colors.black,
                              //     ),
                              //     onTap: () {
                              //       Navigator.of(context).pop();
                              //     },
                              //   ),
                              // ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: ChatScreenHeader(
                                  chatItem: chatItem,
                                  showProfileScreen: (u) {
                                    showProfileScreen = true;
                                    user = u;
                                    setState(() {});
                                  },
                                  goToChatList: () {
                                    isChatOpen = false;
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
                              //   if (!ids.contains(AppConst.getAccessToken())) ...[
                              //     Container(
                              //       width: double.infinity,
                              //       padding: const EdgeInsets.symmetric(vertical: 15),
                              //       color: Colors.white,
                              //       child: const Column(
                              //         children: [
                              //           AppText(text: 'You\' no longer a participant in this group.'),
                              //         ],
                              //       ),
                              //     ),
                              //   ] else ...[
                              //     ChatInput(
                              //       revceiverId: chatItemId,
                              //       isGroupChat: isGroupChat,
                              //     ),
                              //   ]
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
