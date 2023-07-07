import 'package:flutter/material.dart';

import 'package:yes_broker/constants/colors.dart';

class TodoTabScreen extends StatelessWidget {
  const TodoTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            spreadRadius: 12,
            blurRadius: 4,
            offset: const Offset(5, 5),
          ),
        ],
        color: Colors.white,
      ),
      child: const Center(
        child: Text('Todo Screen'),
      ),
    );
  }
}
