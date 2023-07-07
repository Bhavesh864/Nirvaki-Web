// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/responsive.dart';

class CustomChip extends StatelessWidget {
  final Widget label;
  final Color color;
  final Widget? avatar;

  const CustomChip({
    Key? key,
    required this.label,
    required this.color,
    this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: Responsive.isMobile(context) ? 0 : 1,
          right: Responsive.isMobile(context) ? 8 : 1),
      child: Chip(
          avatar: avatar,
          labelPadding: const EdgeInsets.only(left: 4),
          side: BorderSide.none,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          label: label),
    );
  }
}
