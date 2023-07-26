import 'package:flutter/material.dart';

import 'package:yes_broker/constants/utils/colors.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColor.secondary,
            spreadRadius: 12,
            blurRadius: 4,
            offset: Offset(5, 5),
          ),
        ],
        color: Colors.white,
      ),
      child: const Center(
        child: Text('Calendar Screen'),
      ),
    );
  }
}
