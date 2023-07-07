// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String title;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  const CustomText({
    Key? key,
    required this.title,
    this.color,
    this.size,
    this.fontWeight,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        color: color ?? Colors.black,
        fontSize: size ?? 16,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );
  }
}
