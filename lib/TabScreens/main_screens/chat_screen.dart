import 'package:flutter/material.dart';

import 'package:yes_broker/constants/utils/colors.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColor.secondary,
            spreadRadius: 12,
            blurRadius: 4,
            offset: const Offset(5, 5),
          ),
        ],
        color: Colors.white,
      ),
      child: const Center(
        child: Text('Chat Screen'),
      ),
    );
  }
}
