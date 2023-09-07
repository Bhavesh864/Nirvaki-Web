// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/chat/controller/chat_controller.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/chat_services.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/widgets/chat/chat_input.dart';
import 'package:yes_broker/widgets/chat/chat_screen_header.dart';
import 'package:yes_broker/widgets/chat/message_box.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String contactId;
  final String profilePic;
  final String name;
  final String? adminId;
  final bool isGroupChat;
  final Function? onOpenChat;
  final List<String>? memberuid;
  const ChatScreen({
    super.key,
    this.memberuid,
    required this.contactId,
    this.adminId,
    required this.profilePic,
    required this.name,
    required this.isGroupChat,
    this.onOpenChat,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final List<String> members = [];
  final ChatService chatService = ChatService();
  final ScrollController messageController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: widget.isGroupChat
              ? ref.read(chatControllerProvider).groupChatStream(
                    widget.contactId,
                  )
              : ref.read(chatControllerProvider).chatStream(
                    widget.contactId,
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
                            profilePic: widget.profilePic,
                            name: widget.name,
                            contactId: widget.contactId,
                            members: widget.memberuid,
                            isGroupChat: widget.isGroupChat,
                            adminId: widget.adminId),
                      ),
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Colors.grey.shade400,
                      ),
                    ],
                    Expanded(
                      child: ListView.builder(
                        controller: messageController,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final messageData = snapshot.data![index];
                          final isSender = messageData.senderId == AppConst.getAccessToken();
                          if (!isSender && !messageData.isSeen && !widget.isGroupChat) {
                            ref.read(chatControllerProvider).setChatMessageSeen(
                                  context,
                                  widget.contactId,
                                  messageData.messageId,
                                  isSender,
                                );
                          }

                          widget.onOpenChat!();

                          // if (widget.chatItem != null) {
                          // final isWhat = widget.chatItem!.lastMessageSenderId == AppConst.getAccessToken();
                          // // print(!widget.chatItem!.lastMessageIsSeen);
                          // if (!isWhat) {
                          //   ref.read(chatControllerProvider).setLastMessageSeen(
                          //         context,
                          //         widget.chatItem!.id,
                          //         widget.chatItem!.isGroupChat,
                          //         widget.chatItem!.id,
                          //       );
                          //   // }
                          // }
                          return MessageBox(
                            message: messageData.text,
                            isSender: isSender,
                            data: messageData,
                            isSeen: messageData.isSeen,
                          );
                        },
                      ),
                    ),
                    const Divider(height: 1.0),
                    ChatInput(
                      revceiverId: widget.contactId,
                      isGroupChat: widget.isGroupChat,
                    ),
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
