// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/Customs/text_utility.dart';

import 'package:yes_broker/chat/controller/chat_controller.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/chat_services.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/screens/main_screens/chat_screens/chat_list_screen.dart';
import 'package:yes_broker/widgets/chat/chat_input.dart';
import 'package:yes_broker/widgets/chat/chat_screen_header.dart';
import 'package:yes_broker/widgets/chat/message_box.dart';

import '../../../constants/methods/date_time_methods.dart';
import '../../../constants/utils/colors.dart';
import '../../../riverpodstate/chat/message_selection_state.dart';

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
  late ScrollController messageController;
  bool startSelectionMode = false;
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

  final ChatService chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    final ChatItem? chatItem = widget.chatItem;
    final User? user = widget.user;
    final String chatItemId = chatItem?.id ?? user?.userId ?? '';
    final bool isGroupChat = chatItem?.isGroupChat ?? false;

    return WillPopScope(
      onWillPop: () async {
        ref.read(selectedMessageProvider.notifier).setToEmpty();
        return true; // Allow navigation back
      },
      child: Scaffold(
        body: SafeArea(
          child: StreamBuilder(
            stream: isGroupChat
                ? ref.read(chatControllerProvider).groupChatStream(chatItemId)
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

              if (snapshot.hasData) {
                if (snapshot.data!.length > 3) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    messageController.animateTo(
                      messageController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 50),
                      curve: Curves.ease,
                    );
                  });
                }
                return StatefulBuilder(
                  builder: (context, setstate) {
                    remove(String id) {
                      setstate(
                        () {
                          selectedMessageList.remove(id);
                          if (selectedMessageList.isEmpty) {
                            selectedMode = false;
                          }
                        },
                      );
                    }

                    removeAll() {
                      setstate(
                        () {
                          selectedMessageList = [];
                          selectedMode = false;
                        },
                      );
                      ref.read(selectedMessageProvider.notifier).setToEmpty();
                    }

                    add(String id) {
                      setstate(
                        () {
                          selectedMessageList.add(id);
                        },
                      );
                    }

                    toggleSelectedMode(bool k) {
                      setstate(
                        () {
                          selectedMode = k;
                        },
                      );
                    }

                    return Container(
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
                                selectedMessageList: selectedMessageList,
                                selectedMode: selectedMode,
                                toggleSelectedMode: toggleSelectedMode,
                                removeAllItems: removeAll,
                                // removeItem: remove,
                                dataList: snapshot.data,
                              ),
                            ),
                            Divider(
                              height: 1,
                              thickness: 0.5,
                              color: Colors.grey.shade400,
                            ),
                          ],
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
                                    return Container(
                                      height: 10,
                                    );
                                  }
                                  final messageData = snapshot.data![index];
                                  final currentMessageId = messageData.messageId;
                                  final isSender = messageData.senderId == AppConst.getAccessToken();

                                  if (!isSender && !messageData.isSeen && !isGroupChat) {
                                    ref.read(chatControllerProvider).setChatMessageSeen(
                                          context,
                                          chatItemId,
                                          messageData.messageId,
                                          isSender,
                                        );
                                  }

                                  final bool isFirstMessageOfNewDay = index == 0 ||
                                      !isSameDay(
                                        messageData.timeSent.toDate(),
                                        snapshot.data![index - 1].timeSent.toDate(),
                                      );

                                  final bool isNewWeek = DateTime.now().difference(messageData.timeSent.toDate()).inDays >= 7;

                                  final String messageDay = getMessageDay(messageData.timeSent.toDate(), isNewWeek);

                                  return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                    if (isGroupChat && index == 0)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                                        child: Chip(
                                          shape: const StadiumBorder(),
                                          // backgroundColor: Colors.grey.shade200,
                                          backgroundColor: AppColor.chipGreyColor,
                                          label: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                            child: AppText(
                                              text: chatItem!.groupCreatedBy!,
                                              fontsize: 12,
                                              textColor: Colors.black45,
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
                                    if (isGroupChat && !messageData.deleteMsgUserId.contains(AppConst.getAccessToken()) || !isGroupChat)
                                      MessageBox(
                                        currMessageIndex: index,
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
                                          // setstate(() {
                                          if (selectedMessageList.isNotEmpty && selectedMode) {
                                            if (selectedMessageList.contains(currentMessageId)) {
                                              // selectedMessageList.remove(currentMessageId);
                                              remove(currentMessageId);
                                              if (selectedMessageList.isEmpty) {
                                                selectedMode = false;
                                              }
                                              ref.read(selectedMessageProvider.notifier).removeMessge(messageData);
                                            } else if (selectedMode) {
                                              add(currentMessageId);
                                              ref.read(selectedMessageProvider.notifier).addMessage(messageData);
                                            }
                                          } else {
                                            removeAll();
                                            ref.read(selectedMessageProvider.notifier).setToEmpty();
                                          }
                                          // });
                                        },
                                      ),
                                  ]);
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
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
