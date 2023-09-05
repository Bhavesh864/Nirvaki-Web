import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/chat/controller/chat_controller.dart';
import 'package:yes_broker/chat/models/chat_contact.dart';
import 'package:yes_broker/constants/app_constant.dart';

import 'package:yes_broker/constants/firebase/chat_services.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/widgets/chat/chat_input.dart';
import 'package:yes_broker/widgets/chat/chat_screen_header.dart';
import 'package:yes_broker/widgets/chat/message_box.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final ChatContact data;
  const ChatScreen({super.key, required this.data});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ChatService chatService = ChatService();
  final ScrollController messageController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: ref.read(chatControllerProvider).chatStream(widget.data.contactId),
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
                        child: ChatScreenHeader(userData: widget.data),
                      ),
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Colors.grey.shade400,
                      ),
                    ],
                    Expanded(
                      child: ListView.builder(
                        // reverse: true,
                        controller: messageController,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final messageData = snapshot.data![index];
                          final isSender = messageData.senderId == AppConst.getAccessToken();

                          if (isSender && !messageData.isSeen) {
                            ref.read(chatControllerProvider).setChatMessageSeen(
                                  context,
                                  messageData.recieverid,
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
                    const Divider(height: 1.0),
                    ChatInput(
                      revceiverId: widget.data.contactId,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        // child: StreamBuilder(
        //   stream: chatService.getMessages(widget.data.contactId, _firebaseAuth.currentUser!.uid),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasError) {
        //       return Text('Error ${snapshot.error}');
        //     }

        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return SizedBox(
        //         height: Responsive.isMobile(context) ? height : 400,
        //         width: width,
        //         child: const Center(
        //           child: CircularProgressIndicator.adaptive(),
        //         ),
        //       );
        //     }

        //     return GestureDetector(
        //       onTap: () {
        //         FocusScope.of(context).unfocus();
        //       },
        //       child: Container(
        //         height: Responsive.isMobile(context) ? null : 400,
        //         margin: const EdgeInsets.only(top: 10),
        //         child: Column(
        //           children: [
        //             if (Responsive.isMobile(context)) ...[
        //               Container(
        //                 margin: const EdgeInsets.only(bottom: 5),
        //                 child: ChatScreenHeader(userData: widget.data),
        //               ),
        //               Divider(
        //                 height: 1,
        //                 thickness: 0.5,
        //                 color: Colors.grey.shade400,
        //               ),
        //             ],
        //             Expanded(
        //               child: ListView.builder(
        //                 reverse: true,
        //                 itemCount: snapshot.data!.docs.length,
        //                 itemBuilder: (BuildContext context, int index) {
        //                   final Map<String, dynamic> data = snapshot.data!.docs.reversed.toList()[index].data() as Map<String, dynamic>;

        //                   return MessageBox(
        //                     message: data['message'],
        //                     isSender: data['senderId'] == _firebaseAuth.currentUser!.uid,
        //                     document: data,
        //                   );
        //                 },
        //               ),
        //             ),
        //             const Divider(height: 1.0),
        //             ChatInput(
        //               revceiverId: widget.data.contactId,
        //               onSendMessage: (msg) {
        //                 sendMessage(msg);
        //               },
        //             ),
        //           ],
        //         ),
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }
}
