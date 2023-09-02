// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/utils/colors.dart';

class CustomChip extends StatelessWidget {
  final Widget label;
  final Color? color;
  final Widget? avatar;
  final double? paddingHorizontal;
  final Function()? onPressed;

  const CustomChip({
    Key? key,
    required this.label,
    this.color = AppColor.chipGreyColor,
    this.avatar,
    this.paddingHorizontal,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.only(left: Responsive.isMobile(context) ? 0 : 1, right: 1),
        child: Transform(
          transform: Matrix4.identity()..scale(0.9),
          child: Chip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            avatar: avatar,
            labelPadding: EdgeInsets.symmetric(horizontal: paddingHorizontal ?? 1, vertical: 0),
            backgroundColor: color,
            label: Container(
              padding: EdgeInsets.zero,
              child: label,
            ),
          ),
        ),
      ),
    );
  }
}
