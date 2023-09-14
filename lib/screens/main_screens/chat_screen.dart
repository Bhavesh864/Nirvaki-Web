// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/chat/controller/chat_controller.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/chat_services.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/screens/main_screens/chat_list_screen.dart';
import 'package:yes_broker/widgets/chat/chat_input.dart';
import 'package:yes_broker/widgets/chat/chat_screen_header.dart';
import 'package:yes_broker/widgets/chat/message_box.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final ChatItem? chatItem;
  final User? user;

  const ChatScreen({
    super.key,
    this.chatItem,
    this.user,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ChatService chatService = ChatService();
  final ScrollController messageController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final ChatItem? chatItem = widget.chatItem;
    final User? user = widget.user;

    final String chatItemId = chatItem?.id ?? user?.userId ?? '';
    final bool isGroupChat = chatItem?.isGroupChat ?? false;

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
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
              return SizedBox(
                height: Responsive.isMobile(context) ? height : 400,
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
                height: Responsive.isMobile(context) ? null : 400,
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    if (Responsive.isMobile(context)) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: ChatScreenHeader(
                          chatItem: widget.chatItem,
                          user: widget.user,
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Colors.grey.shade400,
                      ),
                    ],
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
                            if (!isSender && !messageData.isSeen && !isGroupChat) {
                              ref.read(chatControllerProvider).setChatMessageSeen(
                                    context,
                                    chatItemId,
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
                      revceiverId: chatItemId,
                      isGroupChat: isGroupChat,
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
      ),
    );
  }
}
