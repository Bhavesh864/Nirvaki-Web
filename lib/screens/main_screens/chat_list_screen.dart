import 'package:flutter/material.dart';
import 'package:yes_broker/widgets/chat/chat_users_list.dart';

final arr = [
  {
    "id": "01",
    'title': 'Madhav Sewag',
    'message': 'Hey, how are you',
    'time': '14:20',
    'seen': false,
    'unRead': '0'
  },
  {
    "id": "02",
    'title': 'John Smith',
    'message': 'Bye',
    'time': '11: 01',
    'seen': true,
    'unRead': '1'
  },
  {
    "id": "03",
    'title': 'Manish Chayal',
    'message': 'Hii',
    'time': '10:00',
    'seen': false,
    'unRead': '0'
  },
  {
    "id": "04",
    'title': 'Bhavesh',
    'message': 'Hello, nice',
    'time': '16:33',
    'seen': false,
    'unRead': '0'
  },
  {
    "id": "05",
    'title': 'Gopal Verma',
    'message': 'Hy, how are you',
    'time': '22:20',
    'seen': true,
    'unRead': '5'
  },
  {
    "id": "06",
    'title': 'Saurabh Mehra',
    'message': 'Okay',
    'time': '14:22',
    'seen': false,
    'unRead': '0'
  },
];

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 5),
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
