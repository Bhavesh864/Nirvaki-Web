import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key, required this.onSendMessage});

  final void Function(String message) onSendMessage;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController message = TextEditingController();

  void sendMessage() {
    if (message.text.isEmpty) {
      return;
    }
    widget.onSendMessage(message.text);
    message.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          InkWell(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.mood,
                size: 18,
              ),
            ),
            onTap: () {},
          ),
          Expanded(
            child: TextField(
              controller: message,
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
            onTap: () {},
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
              sendMessage();
            },
          ),
        ],
      ),
    );
  }
}
