// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../chat/controller/chat_controller.dart';

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
    if (messageController.text.isNotEmpty) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            messageController.text.trim(),
            widget.revceiverId,
            widget.isGroupChat,
          );
    }
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              InkWell(
                onTap: toggleEmojiKeyboardContainer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    !isShowEmojiContainer ? Icons.mood : Icons.keyboard_outlined,
                    size: 18,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
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
                  ),
                ),
              ),
              InkWell(
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Icon(
                    Icons.alternate_email,
                    size: 18,
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                    // barrierColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (builder) => bottomSheet(context),
                  );
                },
              ),
              InkWell(
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.send,
                    size: 18,
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
                height: 310,
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
}

Widget bottomSheet(context) {
  return SizedBox(
    height: 280,
    width: MediaQuery.of(context).size.width,
    child: Card(
      margin: const EdgeInsets.all(18.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconCreation(Icons.insert_drive_file, Colors.indigo, "Document"),
                const SizedBox(
                  width: 40,
                ),
                iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                const SizedBox(
                  width: 40,
                ),
                iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconCreation(Icons.headset, Colors.orange, "Audio"),
                const SizedBox(
                  width: 40,
                ),
                iconCreation(Icons.location_pin, Colors.teal, "Location"),
                const SizedBox(
                  width: 40,
                ),
                iconCreation(Icons.person, Colors.blue, "Contact"),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget iconCreation(IconData icons, Color color, String text) {
  return InkWell(
    onTap: () {},
    child: Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: Icon(
            icons,
            // semanticLabel: "Help",
            size: 29,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            // fontWeight: FontWeight.w100,
          ),
        )
      ],
    ),
  );
}
