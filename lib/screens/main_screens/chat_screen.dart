import 'package:flutter/material.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/widgets/chat/chat_search_bar.dart';
import 'package:yes_broker/widgets/chat/chat_users_list.dart';

final arr = [
  {
    'title': 'Madhav Sewag',
    'message': 'Hey, how are you',
    'time': '14:20',
    'seen': false,
    'unRead': '0'
  },
  {
    'title': 'John Smith',
    'message': 'Bye',
    'time': '11: 01',
    'seen': true,
    'unRead': '1'
  },
  {
    'title': 'Manish Chayal',
    'message': 'Hii',
    'time': '10:00',
    'seen': false,
    'unRead': '0'
  },
  {
    'title': 'Bhavesh',
    'message': 'Hello, nice',
    'time': '16:33',
    'seen': false,
    'unRead': '0'
  },
  {
    'title': 'Gopal Verma',
    'message': 'Hy, how are you',
    'time': '22:20',
    'seen': true,
    'unRead': '5'
  },
  {
    'title': 'Saurabh Mehra',
    'message': 'Kaam kab tk hoga',
    'time': '14:22',
    'seen': false,
    'unRead': '0'
  },
];

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: ChatUserList(users: arr),
            ),
          ),
        ],
      ),
    );
  }
}
