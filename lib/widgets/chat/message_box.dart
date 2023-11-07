// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/chat/enums/message.enums.dart';
import 'package:yes_broker/chat/models/message.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/customs/responsive.dart';
import '../../Customs/snackbar.dart';
import '../../constants/methods/date_time_methods.dart';
import '../../constants/utils/constants.dart';

import '../../constants/utils/download_file.dart';

// ignore: must_be_immutable
class MessageBox extends ConsumerStatefulWidget {
  final String message;
  final int? currMessageIndex;
  final bool isSender;
  final bool isGroupChat;
  final ChatMessage data;
  final bool isSeen;
  final MessageEnum messageType;
  final List<String>? selectedMessageList;
  final bool? selectedMode;
  final Function? onLongPress;
  final Function? onTap;

  const MessageBox({
    Key? key,
    required this.message,
    this.currMessageIndex,
    required this.isSender,
    required this.isGroupChat,
    required this.data,
    required this.isSeen,
    required this.messageType,
    this.selectedMessageList,
    this.selectedMode,
    this.onLongPress,
    this.onTap,
  }) : super(key: key);

  @override
  ConsumerState<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends ConsumerState<MessageBox> {
  User? userlist;

  Future<void> getUserData(String userIds) async {
    final User? user = await User.getUser(userIds);
    userlist = user!;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    // final messgeForwardMode = ref.read(messgeForwardModeProvider);
    // final selectedMessageIndex = ref.read(selectedMessageProvider);

    return Stack(
      children: [
        GestureDetector(
          onLongPress: () {
            widget.onLongPress!();
          },
          onTap: () {
            widget.onTap!();
          },
          // onLongPress: () {
          //   ref.read(messgeForwardModeProvider.notifier).setForwardMode(true);
          //   ref.read(selectedMessageProvider.notifier).addIndex(widget.currMessageIndex!);
          // },
          // onTap: () {

          //   if (selectedMessageIndex.isNotEmpty && messgeForwardMode) {
          //     ref.read(messgeForwardModeProvider.notifier).setForwardMode(true);
          //     if (selectedMessageIndex.contains(widget.currMessageIndex)) {
          //       ref.read(selectedMessageProvider.notifier).removeIndex(widget.currMessageIndex!);
          //     } else if (messgeForwardMode) {
          //       ref.read(selectedMessageProvider.notifier).addIndex(widget.currMessageIndex!);
          //     }
          //   } else {
          //     ref.read(messgeForwardModeProvider.notifier).setForwardMode(false);
          //     ref.read(selectedMessageProvider.notifier).setToEmpty();
          //   }
          // },
          child: Container(
            color: widget.selectedMode! && widget.selectedMessageList!.contains(widget.data.messageId) ? AppColor.primary.withOpacity(0.2) : Colors.transparent,
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
        ),
      ],
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
        : GestureDetector(
            onTap: () {
              if (Responsive.isMobile(context)) {
                // showEnlargedImage(context, message);
                showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                    transitionDuration: const Duration(milliseconds: 200),
                    pageBuilder: (context, animation1, animation2) {
                      return ImagePreview(url: message, type: type.type);
                    });
              }
            },
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              height: 300,
              width: 250,
              imageUrl: message,
            ),
          );
  }
}

class ImagePreview extends StatelessWidget {
  final String url;
  final String type;

  const ImagePreview({super.key, required this.url, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 22,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.download,
              color: Colors.white,
              size: 22,
            ),
            onPressed: () {
              downloadFile(
                  url,
                  type,
                  context,
                  (value, progress) => {
                        if (value)
                          {
                            // setState(() {
                            //   downloading = true;
                            //   progressString = "${((rec / total) * 100).toStringAsFixed(0)}%";
                            // });
                            if (progress == "100%")
                              {
                                customSnackBar(context: context, text: 'Download Completed'),
                              }
                          }
                        else
                          {
                            customSnackBar(context: context, text: 'Download Failed'),
                          },
                      });
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
        child: Image.network(
          url,
          fit: BoxFit.contain,
          frameBuilder: (_, image, loadingBuilder, __) {
            if (loadingBuilder == null) {
              return const SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator(color: Colors.white)),
              );
            }
            return image;
          },
        ),
      ),
    );
  }
}
