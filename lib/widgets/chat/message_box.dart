// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/number_symbols_data.dart';

import 'package:yes_broker/chat/enums/message.enums.dart';
import 'package:yes_broker/chat/models/message.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/riverpodstate/chat/message_selection_state.dart';

import '../../constants/methods/date_time_methods.dart';
import '../../constants/utils/constants.dart';

// ignore: must_be_immutable
class MessageBox extends ConsumerStatefulWidget {
  final String message;
  final int? currMessageIndex;
  final bool isSender;
  final bool isGroupChat;
  final ChatMessage data;
  final bool isSeen;
  final MessageEnum messageType;

  const MessageBox({
    Key? key,
    required this.message,
    required this.isSender,
    required this.isGroupChat,
    required this.data,
    required this.isSeen,
    required this.messageType,
    this.currMessageIndex,
  }) : super(key: key);

  @override
  ConsumerState<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends ConsumerState<MessageBox> {
  User? userlist;

  Future<void> getUserData(String userIds) async {
    final User? user = await User.getUser(userIds);
    userlist = user!;

    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final messgeForwardMode = ref.watch(messgeForwardModeProvider);
    final selectedMessageIndex = ref.watch(selectedMessageProvider);

    return GestureDetector(
      onLongPress: () {
        ref.read(messgeForwardModeProvider.notifier).state = true;
        ref.read(selectedMessageProvider.notifier).addIndex(widget.currMessageIndex!);
      },
      onTap: () {
        ref.read(messgeForwardModeProvider.notifier).state = true;
        ref.read(selectedMessageProvider.notifier).addIndex(widget.currMessageIndex!);
      },
      child: Stack(
        children: [
          // if (widget.isSender == true)
          //   Positioned(
          //     top: 8,
          //     right: 0,
          //     child: Image.asset('assets/images/messageTip.png'),
          //   ),
          Container(
            color: messgeForwardMode && selectedMessageIndex.contains(widget.currMessageIndex) ? AppColor.primary.withOpacity(0.2) : null,
            margin: const EdgeInsets.only(bottom: 6.0),
            padding: const EdgeInsets.all(8.0),
            alignment: widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: widget.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!widget.isSender && widget.isGroupChat) ...[
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: NetworkImage(widget.data.profilePic == '' ? noImg : widget.data.profilePic),
                  ),
                ],
                // Image.asset('assets/images/receiveMsgTip.png'),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: width * 3 / 4,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.isSender ? AppColor.primary : AppColor.secondary,
                    borderRadius: BorderRadius.only(
                      topLeft: widget.isSender ? const Radius.circular(8) : const Radius.circular(0),
                      topRight: widget.isSender ? const Radius.circular(0) : const Radius.circular(8),
                      bottomLeft: const Radius.circular(8),
                      bottomRight: const Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.isGroupChat && !widget.isSender)
                        Text(
                          widget.data.senderName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      Container(
                        constraints: Responsive.isMobile(context) ? null : const BoxConstraints(maxWidth: 210),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: DisplayMessage(
                          message: widget.message,
                          type: widget.data.type,
                          isSender: widget.isSender,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            formatTimestamp(widget.data.timeSent.toDate()),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: widget.isSender ? Colors.white : AppColor.inActiveColor,
                              fontSize: 10,
                            ),
                          ),
                          if (widget.isSender)
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Icon(
                                widget.isSeen ? Icons.done_all : Icons.done,
                                color: widget.isSeen ? Colors.blue : Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayMessage extends StatelessWidget {
  final String message;
  final MessageEnum type;
  final bool isSender;

  const DisplayMessage({
    Key? key,
    required this.message,
    required this.type,
    required this.isSender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: TextStyle(
              color: isSender ? Colors.white : Colors.black,
            ),
          )
        : CachedNetworkImage(
            fit: BoxFit.cover,
            height: 300,
            width: 250,
            imageUrl: message,
          );
    // : type == MessageEnum.audio
    //     ? StatefulBuilder(builder: (context, setState) {
    //         return IconButton(
    //           constraints: const BoxConstraints(
    //             minWidth: 100,
    //           ),
    //           onPressed: () async {
    //             // if (isPlaying) {
    //             //   await audioPlayer.pause();
    //             //   setState(() {
    //             //     isPlaying = false;
    //             //   });
    //             // } else {
    //             //   await audioPlayer.play(UrlSource(message));
    //             //   setState(() {
    //             //     isPlaying = true;
    //             //   });
    //             // }
    //           },
    //           icon: Icon(
    //             isPlaying ? Icons.pause_circle : Icons.play_circle,
    //           ),
    //         );
    //       })
    // : type == MessageEnum.video
    //     ? VideoPlayerItem(
    //         videoUrl: message,
    //       )
    //     : type == MessageEnum.gif
    //         ? CachedNetworkImage(
    //             imageUrl: message,
    //           )
    //         : CachedNetworkImage(
    //             imageUrl: message,
    //           );
  }
}
