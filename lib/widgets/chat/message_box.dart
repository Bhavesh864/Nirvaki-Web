// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/chat/enums/message.enums.dart';
import 'package:yes_broker/chat/models/message.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/customs/custom_text.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/customs/text_utility.dart';
import 'package:yes_broker/widgets/chat/videoplayer.dart';
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

class _MessageBoxState extends ConsumerState<MessageBox> with SingleTickerProviderStateMixin {
  User? userlist;
  bool isDownloading = false;
  bool isDownloaded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> getUserData(String userIds) async {
    final User? user = await User.getUser(userIds);
    userlist = user!;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        GestureDetector(
          onLongPress: () {
            widget.onLongPress!();
          },
          onTap: () {
            widget.onTap!();
          },
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
                    backgroundImage: NetworkImage(widget.data.profilePic.isEmpty ? noImg : widget.data.profilePic),
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
                          isSelectedMode: widget.selectedMode!,
                          onTap: widget.onTap!,
                          fileName: widget.data.fileName,
                          fileSize: widget.data.fileSize,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          if (widget.data.type == MessageEnum.video || widget.data.type == MessageEnum.file) ...[
                            if (Responsive.isMobile(context)) ...[
                              const Spacer()
                            ] else ...[
                              const SizedBox(
                                width: 135,
                              )
                            ],
                            StatefulBuilder(builder: (context, setstate) {
                              if (isDownloading) {
                                return AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(0.0, _animation.value * 8.0), // Adjust the bounce height
                                      child: const Icon(
                                        Icons.download,
                                        size: 22.0,
                                        color: Colors.white, // Customize color as needed
                                      ),
                                    );
                                  },
                                );
                                // return const CustomText(
                                //   title: 'Donwloading...',
                                //   color: Colors.white,
                                // );
                              } else {
                                return isDownloaded
                                    ? const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                        size: 22,
                                      )
                                    : InkWell(
                                        onTap: () {
                                          if (!kIsWeb) {
                                            setstate(() {
                                              isDownloading = true;
                                            });
                                            downloadFile(
                                              widget.message,
                                              widget.data.type.type,
                                              context,
                                              (value, progress) => {
                                                if (value)
                                                  {
                                                    if (progress == "100%")
                                                      {
                                                        customSnackBar(context: context, text: 'Download Completed'),
                                                        setstate(() {
                                                          isDownloading = false;
                                                          isDownloaded = true;
                                                        }),
                                                      },
                                                  }
                                                else
                                                  {
                                                    customSnackBar(context: context, text: 'Download Failed'),
                                                    setstate(() {
                                                      isDownloading = false;
                                                    }),
                                                  }
                                              },
                                              name: widget.data.fileName!,
                                            );
                                          } else {
                                            // if (kIsWeb) {
                                            //   AnchorElement anchorElement = AnchorElement(href: widget.message);
                                            //   anchorElement.download = 'Attachment file';
                                            //   anchorElement.click();
                                            // }
                                          }
                                        },
                                        child: const Icon(
                                          Icons.download,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      );
                              }
                            }),
                          ]
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
  final String? fileName;
  final String? fileSize;
  final MessageEnum type;
  final bool isSender;
  final bool isSelectedMode;
  final Function onTap;

  const DisplayMessage({
    Key? key,
    required this.message,
    this.fileName,
    this.fileSize,
    required this.type,
    required this.isSender,
    required this.isSelectedMode,
    required this.onTap,
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
        : type == MessageEnum.image
            ? GestureDetector(
                onTap: () {
                  if (Responsive.isMobile(context)) {
                    // showEnlargedImage(context, message);
                    if (!isSelectedMode) {
                      showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                          transitionDuration: const Duration(milliseconds: 200),
                          pageBuilder: (context, animation1, animation2) {
                            return ImagePreview(url: message, type: type.type);
                          });
                    } else {
                      onTap();
                    }
                  } else {
                    onTap();
                  }
                },
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  height: 300,
                  width: 250,
                  imageUrl: message,
                ),
              )
            : type == MessageEnum.video
                ? VideoPlayerItem(videoUrl: message)
                : Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 98, 122, 240),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ListTile(
                      minLeadingWidth: 0,
                      leading: const Icon(
                        Icons.insert_drive_file,
                        size: 30,
                        color: Colors.white,
                      ),
                      titleAlignment: ListTileTitleAlignment.center,
                      title: AppText(
                        text: fileName!,
                        textColor: Colors.white,
                        fontsize: 15,
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                      ),
                      subtitle: CustomText(
                        title: fileSize!,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  );

    // if (type == MessageEnum.text) {
    //   return Text(
    //     message,
    //     style: TextStyle(
    //       color: isSender ? Colors.white : Colors.black,
    //     ),
    //   );
    // }

    // if (type == MessageEnum.image) {
    //   return GestureDetector(
    //     onTap: () {
    //       if (Responsive.isMobile(context)) {
    //         // showEnlargedImage(context, message);
    //         if (!isSelectedMode) {
    //           showGeneralDialog(
    //               context: context,
    //               barrierDismissible: true,
    //               barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    //               transitionDuration: const Duration(milliseconds: 200),
    //               pageBuilder: (context, animation1, animation2) {
    //                 return ImagePreview(url: message, type: type.type);
    //               });
    //         } else {
    //           onTap();
    //         }
    //       } else {
    //         onTap();
    //       }
    //     },
    //     child: CachedNetworkImage(
    //       fit: BoxFit.cover,
    //       height: 300,
    //       width: 250,
    //       imageUrl: message,
    //     ),
    //   );
    // }
    // if (type == MessageEnum.video) return VideoPlayerItem(videoUrl: message);

    // if (type == MessageEnum.file) {
    //   return Container(
    //     decoration: BoxDecoration(
    //       color: const Color.fromARGB(255, 98, 122, 240),
    //       borderRadius: BorderRadius.circular(5),
    //     ),
    //     child: ListTile(
    //       minLeadingWidth: 0,
    //       leading: const Icon(
    //         Icons.insert_drive_file,
    //         size: 30,
    //         color: Colors.white,
    //       ),
    //       titleAlignment: ListTileTitleAlignment.center,
    //       title: AppText(
    //         text: fileName!,
    //         textColor: Colors.white,
    //         fontsize: 15,
    //         softwrap: true,
    //         overflow: TextOverflow.ellipsis,
    //         fontWeight: FontWeight.w600,
    //       ),
    //       subtitle: CustomText(
    //         title: fileSize!,
    //         size: 12,
    //         color: Colors.white,
    //       ),
    //     ),
    //   );
    // }
  }
}

class ImagePreview extends StatelessWidget {
  final String url;
  final String type;
  final bool? isDownload;

  const ImagePreview({super.key, required this.url, required this.type, this.isDownload = true});

  @override
  Widget build(BuildContext context) {
    downloadProgress(value, progress) {
      if (value) {
        // setState(() {
        //   downloading = true;
        //   progressString = "${((rec / total) * 100).toStringAsFixed(0)}%";
        // });
        if (progress == "100%") {
          customSnackBar(context: context, text: 'Download Completed');
        }
      } else {
        customSnackBar(context: context, text: 'Download Failed');
      }
    }

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
        actions: isDownload == true
            ? <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.download,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () {
                    if (!kIsWeb) {
                      downloadFile(
                        url,
                        type,
                        context,
                        downloadProgress,
                      );
                    } else {
                      // if (kIsWeb) {
                      //   AnchorElement anchorElement = AnchorElement(href: url);
                      //   anchorElement.download = 'Attachment file';
                      //   anchorElement.click();
                      // }
                    }
                  },
                ),
              ]
            : [],
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
