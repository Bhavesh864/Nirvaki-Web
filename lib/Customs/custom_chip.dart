// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:yes_broker/constants/utils/colors.dart';

class CustomChip2 extends StatelessWidget {
  final Widget label;
  final Color? color;
  final Widget? avatar;
  final double? paddingHorizontal;
  final Function()? onPressed;

  const CustomChip2({
    Key? key,
    required this.label,
    this.color = AppColor.chipGreyColor,
    this.avatar,
    this.paddingHorizontal,
    this.onPressed,
  }) : super(key: key);

  // transform: Matrix4.identity()..scale(0.9),

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 2.0),
      child: GestureDetector(
        onTap: onPressed,
        child: IntrinsicWidth(
          child: Chip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            avatar: avatar,
            labelPadding: EdgeInsets.symmetric(horizontal: paddingHorizontal ?? 1, vertical: 0),
            backgroundColor: color,
            label: Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              child: label,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomChip extends StatelessWidget {
  final Widget label;
  final Color? color;
  final Widget? avatar;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final Function()? onPressed;

  const CustomChip({
    Key? key,
    required this.label,
    this.color = AppColor.chipGreyColor,
    this.avatar,
    this.paddingHorizontal,
    this.paddingVertical,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: InkWell(
        onTap: onPressed,
        child: IntrinsicWidth(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: color,
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: paddingVertical ?? 0),
            child: Row(
              children: [
                if (avatar != null) avatar!,
                const SizedBox(width: 2),
                label,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
