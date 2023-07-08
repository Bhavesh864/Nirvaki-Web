// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/colors.dart';

class CustomChip extends StatelessWidget {
  final Widget label;
  final Color? color;
  final Widget? avatar;
  final double? paddingHorizontal;

  const CustomChip({
    Key? key,
    required this.label,
    this.color = AppColor.chipGreyColor,
    this.avatar,
    this.paddingHorizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(
      //     left: Responsive.isMobile(context) ? 0 : 1,
      //     right: Responsive.isMobile(context) ? 8 : 1),
      margin: EdgeInsets.symmetric(horizontal: 2),
      child: Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        avatar: avatar,
        padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal ?? 0, vertical: 0),
        labelPadding: const EdgeInsets.symmetric(horizontal: 3),
        side: BorderSide.none,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        label: label,
      ),
    );
  }
}
