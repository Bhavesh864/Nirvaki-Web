import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/material.dart';

import 'package:yes_broker/constants/firebase/chat_services.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/widgets/chat/chat_input.dart';
import 'package:yes_broker/widgets/chat/chat_screen_header.dart';
import 'package:yes_broker/widgets/chat/message_box.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ChatScreenBody(user: user),
      ),
    );
  }
}

class ChatScreenBody extends StatefulWidget {
  const ChatScreenBody({super.key, required this.user});
  final User user;

  @override
  State<ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  var allMessages = [];
  final firebaseAuth.FirebaseAuth _firebaseAuth = firebaseAuth.FirebaseAuth.instance;
  final ChatService chatService = ChatService();

  void sendMessage(message) async {
    await chatService.sendMessage(widget.user.userId, message);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatService.getMessages(widget.user.userId, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Erron${snapshot.error}');
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
                    child: ChatScreenHeader(user: widget.user),
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Colors.grey.shade400,
                  ),
                ],
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Map<String, dynamic> data = snapshot.data!.docs.reversed.toList()[index].data() as Map<String, dynamic>;

                      return MessageBox(
                        message: data['message'],
                        isSender: data['senderId'] == _firebaseAuth.currentUser!.uid,
                        document: data,
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
          ),
        );
      },
    );
  }
}
