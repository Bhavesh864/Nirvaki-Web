import 'package:flutter/material.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/image_constants.dart';
import 'package:yes_broker/widgets/chat/chat_input.dart';
import 'package:yes_broker/widgets/chat/chat_screen_header.dart';

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

// ignore: must_be_immutable
class MessageBox extends StatelessWidget {
  MessageBox({super.key, required this.message, required this.isSender});
  String message;
  bool isSender;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender) ...[
            const CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage(profileImage),
            ),
            const SizedBox(width: 8),
          ],
          Container(
            constraints: BoxConstraints(
              maxWidth: width * 3 / 4,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isSender ? AppColor.primary : AppColor.secondary,
              borderRadius: BorderRadius.only(
                topLeft: isSender
                    ? const Radius.circular(8)
                    : const Radius.circular(0),
                topRight: isSender
                    ? const Radius.circular(0)
                    : const Radius.circular(8),
                bottomLeft: const Radius.circular(8),
                bottomRight: const Radius.circular(8),
              ),
            ),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isSender)
                  const Text(
                    'John Smith',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                Text(
                  message,
                  style: TextStyle(
                    color: isSender ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '11:20 PM',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color:
                              isSender ? Colors.white : AppColor.inActiveColor,
                          fontSize: 12),
                    ),
                    if (isSender)
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Icon(
                          Icons.done_all,
                          color: Colors.white,
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
