// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_broker/Customs/responsive.dart';

import '../../chat/controller/chat_controller.dart';
import '../../chat/enums/message.enums.dart';
import '../../chat/pick_methods.dart';

class ChatInput extends ConsumerStatefulWidget {
  final String revceiverId;
  final bool isGroupChat;

  const ChatInput({
    super.key,
    required this.revceiverId,
    required this.isGroupChat,
  });

  @override
  ConsumerState<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends ConsumerState<ChatInput> {
  final TextEditingController messageController = TextEditingController();
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();

  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  void sendTextMessage() {
    if (messageController.text.trim().isNotEmpty) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            messageController.text.trim(),
            widget.revceiverId,
            widget.isGroupChat,
          );
    }
    messageController.clear();
    focusNode.unfocus();
  }

  void sendFileMessage(
    File? file,
    MessageEnum messageEnum,
    Uint8List? webImage,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.revceiverId,
          messageEnum,
          widget.isGroupChat,
          webImage,
        );
  }

  // void selectImage() async {
  //   File? image = await pickImageFromGallery(context);
  //   if (image != null) {
  //     sendFileMessage(image, MessageEnum.image);
  //   }
  // }

  // void selectVideo() async {
  //   File? video = await pickVideoFromGallery(context);
  //   if (video != null) {
  //     sendFileMessage(video, MessageEnum.video);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: Responsive.isMobile(context) ? BorderRadius.circular(0) : BorderRadius.circular(0),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 6),
          child: Row(
            children: [
              InkWell(
                onTap: toggleEmojiKeyboardContainer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    !isShowEmojiContainer ? Icons.mood : Icons.keyboard_outlined,
                    size: 16,
                  ),
                ),
              ),
              Expanded(
                child: RawKeyboardListener(
                  focusNode: FocusNode(),
                  onKey: (RawKeyEvent event) {
                    if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
                      sendTextMessage();
                    }
                  },
                  child: TextField(
                    textInputAction: TextInputAction.send,
                    focusNode: focusNode,
                    controller: messageController,
                    minLines: 1,
                    maxLines: 7,
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Start typing...',
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                    onSubmitted: (_) {
                      sendTextMessage();
                    },
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  // showModalBottomSheet(
                  //   backgroundColor: Colors.transparent,
                  //   context: context,
                  //   builder: (builder) => bottomSheet(context),
                  // );
                  if (kIsWeb) {
                    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      var f = await image.readAsBytes();

                      sendFileMessage(null, MessageEnum.image, f);
                    }
                  } else {
                    final image = await pickImageFromGallery(context);

                    sendFileMessage(image!, MessageEnum.image, null);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Icon(
                    Icons.attach_file_rounded,
                    size: 16,
                  ),
                ),
              ),
              InkWell(
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.send,
                    size: 16,
                  ),
                ),
                onTap: () {
                  sendTextMessage();
                },
              ),
            ],
          ),
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 255,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    messageController.text = messageController.text + emoji.emoji;
                  },
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  // Widget bottomSheet(context) {
  //   return SizedBox(
  //     height: 180,
  //     width: MediaQuery.of(context).size.width,
  //     child: Card(
  //       margin: const EdgeInsets.all(18.0),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
  //         child: Column(
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 iconCreation(Icons.insert_drive_file, Colors.indigo, "Document", context),
  //                 const SizedBox(
  //                   width: 40,
  //                 ),
  //                 iconCreation(Icons.camera_alt, Colors.pink, "Camera", context),
  //                 const SizedBox(
  //                   width: 40,
  //                 ),
  //                 iconCreation(Icons.insert_photo, Colors.purple, "Gallery", context),
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 30,
  //             ),
  //             // Row(
  //             //   mainAxisAlignment: MainAxisAlignment.center,
  //             //   children: [
  //             //     iconCreation(Icons.headset, Colors.orange, "Audio", context),
  //             //     const SizedBox(
  //             //       width: 40,
  //             //     ),
  //             //     iconCreation(Icons.location_pin, Colors.teal, "Location", context),
  //             //     const SizedBox(
  //             //       width: 40,
  //             //     ),
  //             //     iconCreation(Icons.person, Colors.blue, "Contact", context),
  //             //   ],
  //             // ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget iconCreation(IconData icons, Color color, String text, BuildContext context) {
  //   return InkWell(
  //     onTap: () async {
  //       if (text == 'Gallery') {
  //         final image = await pickImageFromGallery(context);
  //         sendFileMessage(image!, MessageEnum.image);
  //       }
  //     },
  //     child: Column(
  //       children: [
  //         CircleAvatar(
  //           radius: 25,
  //           backgroundColor: color,
  //           child: Icon(
  //             icons,
  //             // semanticLabel: "Help",
  //             size: 25,
  //             color: Colors.white,
  //           ),
  //         ),
  //         const SizedBox(
  //           height: 5,
  //         ),
  //         Text(
  //           text,
  //           style: const TextStyle(
  //             fontSize: 12,
  //             // fontWeight: FontWeight.w100,
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
