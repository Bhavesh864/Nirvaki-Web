import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/material.dart';
import 'package:yes_broker/constants/app_constant.dart';

import 'package:yes_broker/constants/firebase/chat_services.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/widgets/chat/chat_input.dart';
import 'package:yes_broker/widgets/chat/message_box.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key, required this.user});
  final dynamic user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GroupScreenBody(user: user),
      ),
    );
  }
}

class GroupScreenBody extends StatefulWidget {
  const GroupScreenBody({super.key, required this.user});
  final user;

  @override
  State<GroupScreenBody> createState() => _GroupScreenBodyState();
}

class _GroupScreenBodyState extends State<GroupScreenBody> {
  var allMessages = [];
  final firebaseAuth.FirebaseAuth _firebaseAuth = firebaseAuth.FirebaseAuth.instance;
  final ChatService chatService = ChatService();
  // User? userDetails = await User.getUser(AppConst.getAccessToken());

  void sendMessage(message) async {
    await chatService.sendMessage(AppConst.getAccessToken(), message);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatService.getMessages(widget.user["admin"], _firebaseAuth.currentUser!.uid),
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
                    // child: chatscrn(user: widget.user),
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
