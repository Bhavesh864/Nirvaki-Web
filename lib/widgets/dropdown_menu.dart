// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';

class CustomDropDownMenu extends StatelessWidget {
  final String title;
  const CustomDropDownMenu({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PopupMenuItem popupMenuItem(String title,
        {Color color = AppColor.secondary}) {
      return PopupMenuItem(
        height: 5,
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Center(
          child: Container(
            width: 200,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(title),
          ),
        ),
      );
    }

    return PopupMenuButton(
      splashRadius: 0,
      padding: EdgeInsets.zero,
      color: Colors.white.withOpacity(1),
      offset: const Offset(200, 40),
      itemBuilder: (context) => [
        popupMenuItem('Location Finalised'),
        popupMenuItem('New', color: AppColor.green),
        popupMenuItem('Negotiation'),
        popupMenuItem('Token'),
        popupMenuItem('Agreement'),
        popupMenuItem('Converted'),
        popupMenuItem('Closed'),
      ],
      child: Icon(
        Icons.expand_more,
        color: taskStatusColor(title),
      ),
    );
  }
}
