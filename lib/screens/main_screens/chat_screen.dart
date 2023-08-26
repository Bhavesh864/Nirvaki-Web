import 'package:flutter/material.dart';
import 'package:yes_broker/widgets/chat/chat_input.dart';
import 'package:yes_broker/widgets/chat/chat_screen_header.dart';
import 'package:yes_broker/widgets/chat/message_box.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.user});
  final user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ChatScreenBody(user: user),
        ),
      ),
    );
  }
}

class ChatScreenBody extends StatefulWidget {
  const ChatScreenBody({super.key, required this.user});
  final user;

  @override
  State<ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  var allMessages = [];

  void sendMessage(message) {
    setState(() {
      allMessages.insert(0, message);
    });
    // allMessages = [...allMessages, message];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: ChatScreenHeader(user: widget.user)),
          Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.grey.shade400,
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: allMessages.length,
              itemBuilder: (context, index) {
                return MessageBox(
                  message: allMessages[index],
                  isSender: index % 2 == 0 ? true : false,
                );
              },
            ),
          ),
          const Divider(height: 1.0),
          ChatInput(
            onSendMessage: (msg) {
              sendMessage(msg);
            },
          ),
        ],
      ),
    );
  }
}
